using System;
using System.IO;
using System.Collections.Generic;
using System.Configuration;
using System.Diagnostics;
using System.Linq;
using System.Net;
using OEIShared;
using System.Text;
using System.Xml;
using System.Xml.Linq;

namespace DeploymentTool
{
    class ALFADeployerTool
    {
        public void Run()
        {
            // Check configuration.
            LoadConfiguration();

            // Commonly used variables.
            wcDownloader = new WebClient();
            ADLResources = new List<ADLResource>();

            // Run through update process.
            CheckForCommonIssues();
            DownloadLatestACR();
            PatchModuleResourceXML();
            RecompileModuleScripts();
            FetchExternalDependencies();
            AdjustModuleVariables();

            // Give completion feedback.
            Console.WriteLine("Update process complete.");
        }

        public void LoadConfiguration()
        {
            // Load patch fetcher URL. Error checking is done in DownloadLatestACR.
            PatchURL = Properties.Settings.Default.PatchURL;

            // Check for the NWN2 install path.
            NWN2InstallPath = Properties.Settings.Default.NWN2InstallPath;
            if (!Directory.Exists(NWN2InstallPath)) throw new Exception("NWN2 instal path does not exist. Check the config file.");

            // Check for the NWN2 install path.
            NWNX4Path = Properties.Settings.Default.NWNX4Path;
            if (!Directory.Exists(NWNX4Path)) throw new Exception("NWNx4 path does not exist. Check the config file.");

            // Check for the NWN2 home directory.
            NWN2HomePath = Properties.Settings.Default.NWN2HomePath;
            if (!Directory.Exists(NWN2HomePath)) throw new Exception("NWN2 home path does not exist. Check the config file.");

            // Check for the module.
            ModuleName = Properties.Settings.Default.ModuleName;
            string ModuleDirectory = NWN2HomePath + "\\modules\\" + ModuleName + Path.DirectorySeparatorChar;
            if (!Directory.Exists(ModuleDirectory)) throw new Exception("Module could not be found. Ensure that the NWN2HomePath and ModuleName config setting are correct. Checked dir: " + ModuleDirectory);
        }

        private void CheckForCommonIssues()
        {
            // Confirm that we do not have NWNX4 files in the root directory.
            string[] xpFiles = Directory.GetFiles(NWN2InstallPath, "xp_*.dll");
            if (xpFiles.Length > 0)
            {
                // Report the warning.
                Console.WriteLine("WARNING: NWNX plugin files were found in the NWN2 install directory. These files are being moved to the a backup folder.");

                // Ensure that the backup directory exists.
                string BackupDirectory = NWN2InstallPath + "\\backup\\";
                if (!Directory.Exists(BackupDirectory)) Directory.CreateDirectory(BackupDirectory);

                // Move files.
                foreach (string filename in xpFiles)
                {
                    string destination = BackupDirectory + filename.Remove(0, NWN2InstallPath.Length + 1);
                    Console.WriteLine(string.Format("Moving '{0}' to '{1}'", filename, destination));
                    File.Move(filename, destination);
                }
            }
        }

        private void DownloadLatestACR()
        {
            // Download the latest ACR patch.
            Console.WriteLine("Downloading latest ACR patch...");
            WebClient downloader = new WebClient();
            wcDownloader.DownloadFile(PatchURL, "patch.xml");

            // Load the patch document.
            XDocument PatchDoc = XDocument.Load("patch.xml");

            // Load servers.
            ServerList = PatchDoc.Root.Element("servers").Elements().ToDictionary(el => (int)el.Attribute("id"), el => (string)el.Attribute("url"));
            if (ServerList.Count == 0) throw new Exception("No download servers found. Contact the technical administrator.");
            Console.WriteLine("Found {0} servers.", ServerList.Count);

            // Parse module dependency/ADL resoures.
            List<XElement> resources = PatchDoc.Root.Element("module_externs").Elements().ToList();
            for (int i = 0; i < resources.Count; i++) ADLResources.Add(new ADLResource(resources[i]));
            if (ADLResources.Count == 0) throw new Exception("No resources found. Contact the technical administrator.");
            Console.WriteLine("Loaded {0} resource entries.", ADLResources.Count);

            // Update ADL resources.
            string DownloadFolder = GetHomeSubfolder("staging\\client");
            foreach (ADLResource resource in ADLResources)
            {
                resource.Update(NWN2HomePath, DownloadFolder, ServerList);
            }
        }

        private void RecompileModuleScripts()
        {
            // Recompile all scripts in the module.
            string Command = Program.ScriptCompilerFilename;
            string Arguments = "-e -v1.70 -o";
            Arguments += " -h \"" + NWN2HomePath + "\"";
            Arguments += " -n \"" + NWN2InstallPath + "\"";
            Arguments += " -m \"" + ModuleName + "\"";
            Arguments += " \"" + NWN2HomePath + "\\modules\\" + ModuleName + "\\*.nss\"";
            string WorkingDirectory = NWNX4Path;

            // Process information.
            ProcessStartInfo cmdStartInfo = new ProcessStartInfo();
            cmdStartInfo.WorkingDirectory = WorkingDirectory;
            cmdStartInfo.FileName = Command;
            cmdStartInfo.Arguments = Arguments;
            cmdStartInfo.RedirectStandardOutput = true;
            cmdStartInfo.RedirectStandardError = true;
            cmdStartInfo.RedirectStandardInput = true;
            cmdStartInfo.UseShellExecute = false;
            cmdStartInfo.CreateNoWindow = true;

            // Create recompile process.
            Process cmdProcess = new Process();
            cmdProcess.StartInfo = cmdStartInfo;
            cmdProcess.OutputDataReceived += ParseOutput_Recompile;
            cmdProcess.ErrorDataReceived += ParseOutput_Recompile;
            cmdProcess.EnableRaisingEvents = true;

            // Begin processing.
            Console.WriteLine("Recompiling '{0}'", NWN2HomePath + "\\modules\\" + ModuleName + "\\*.nss");
            cmdProcess.Start();
            cmdProcess.BeginOutputReadLine();
            cmdProcess.BeginErrorReadLine();
            cmdProcess.WaitForExit();
            Console.WriteLine("Recompile complete. Logs available in '{0}'.", "DeploymentTool_Recompile.log");
        }

        void ParseOutput_Recompile(object sender, DataReceivedEventArgs e)
        {
            if (e.Data == null) return;

            // Log errors or warnings to console.
            if (e.Data.ToLower().Contains("error") || e.Data.ToLower().Contains("warning"))
            {
                Console.WriteLine(e.Data.Trim());
            }

            // Log all output to the log file.
            StreamWriter log = File.AppendText("DeploymentTool_Recompile.log");
            log.WriteLine("{0}", e.Data.Trim());
            log.Close();
        }

        private void PatchModuleResourceXML()
        {
            string ModuleDLResourcePath = GetModuleFolder() + "\\moduledownloaderresources.xml";
            Console.WriteLine("Patching '{0}'", "moduledownloaderresources.xml");

            // Load the XML file.
            XDocument ModuleDLResource = XDocument.Load(ModuleDLResourcePath);

            // Find each resource and adjust values.
            List<XElement> elements = ModuleDLResource.Root.Elements().ToList();
            foreach (ADLResource resource in ADLResources)
            {
                // Find element.
                XElement element = null;
                foreach (XElement e in elements)
                {
                    if ((string)e.Attribute("name") == resource.name)
                    {
                        element = e;
                        break;
                    }
                }

                // TODO: Add an element if it doesn't exist.
                if (element == null) throw new Exception(string.Format("Could not find resource: {0}", resource.name));

                // Adjust data.
                element.SetAttributeValue("hash", resource.hash);
                element.SetAttributeValue("downloadHash", resource.downloadHash);
                element.SetAttributeValue("dlsize", resource.dlsize);
                element.SetAttributeValue("size", resource.size);
                element.SetAttributeValue("critical", resource.critical);
                element.SetAttributeValue("exclude", resource.exclude);
                element.SetAttributeValue("urlOverride", resource.urlOverride);
            }

            ModuleDLResource.Save(ModuleDLResourcePath);
        }

        private void FetchExternalDependencies()
        {
            List<DependencyResource> Dependencies = new List<DependencyResource>();

            // Load the dependencies from the patch xml.
            XDocument PatchDoc = XDocument.Load("patch.xml");
            List<XElement> elements = PatchDoc.Root.Element("files").Elements().ToList();
            for (int i = 0; i < elements.Count; i++)
            {
                Dependencies.Add(new DependencyResource(elements[i]));
            }

            if (ADLResources.Count == 0)
            {
                Console.WriteLine("WARNING: No external dependency records found.");
                return;
            }

            Console.WriteLine("Found {0} external dependencies.", ADLResources.Count);

            // Upgrade dependencies.
            string DownloadFolder = GetHomeSubfolder("staging\\client");
            foreach (DependencyResource dependency in Dependencies)
            {
                dependency.Update(this, DownloadFolder);
            }
        }

        private void AdjustModuleVariables()
        {

        }

        public string GetHomeSubfolder(string folder)
        {
            string target = NWN2HomePath + Path.DirectorySeparatorChar + folder;
            if (!Directory.Exists(target)) throw new Exception(string.Format("Home subfolder '{0}' does not exist.", folder));
            return target;
        }

        public string GetModuleFolder(string module = null)
        {
            if (module == null) module = ModuleName;
            string folder = GetHomeSubfolder("modules") + "\\" + module;
            if (!Directory.Exists(folder)) throw new Exception(string.Format("Folder does not exist: {0}", folder));
            return folder;
        }

        // Common files.
        public WebClient wcDownloader;
        public Dictionary<int, string> ServerList;
        public List<ADLResource> ADLResources;

        // Configuration values.
        public string PatchURL;
        public string NWN2InstallPath;
        public string NWN2HomePath;
        public string NWNX4Path;
        public string ModuleName;
    }
}
