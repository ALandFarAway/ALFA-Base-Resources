using System;
using System.IO;
using System.Collections.Generic;
using System.Configuration;
using System.Diagnostics;
using System.Linq;
using System.Net;
using System.Security.Cryptography;
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
            AdjustModuleVariables();
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

            // Download files.
            foreach (ADLResource resource in ADLResources)
            {
                string filename = GetHomeSubfolder("staging\\client\\") + resource.name + ".lzma";

                // Does the file already exist?
                if (File.Exists(filename))
                {
                    // Make checks.
                    if (VerifyFile(filename, resource))
                    {
                        Console.WriteLine("File '{0}' already exists, and is valid.", resource.name + ".lzma");
                        continue;
                    }
                    else
                    {
                        Console.WriteLine("File '{0}' already exists, but failed verification. Deleting.", resource.name + ".lzma");
                        File.Delete(filename);
                    };
                }

                // Try each download server.
                bool bDownloaded = false;
                foreach (int server in resource.servers)
                {
                    try
                    {
                        // Valid server?
                        if (!ServerList.Keys.Contains(server)) throw new Exception("Server not found.");

                        // Get local and remote destinations.
                        string url = ServerList[server] + resource.name + ".lzma";

                        // Try to download.
                        float sizeInMB = (float)(resource.dlsize) / 1024 / 1024;
                        Console.WriteLine("Downloading '{0}' from server {1} ({2} MB)", resource.name, server, sizeInMB);
                        wcDownloader.DownloadFile(url, filename);

                        // Download. Verify file again.
                        if (!VerifyFile(filename, resource))
                        {
                            // TODO: Log the details of the discrepency.
                            throw new Exception("Verification failed.");
                        }

                        bDownloaded = true;
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("WARNING: Download failed for server index '{0}'. Message: {1}", server, e.Message);

                        if (File.Exists(filename)) File.Delete(filename);
                    }

                    // Break if we downloaded it successfully.
                    if (bDownloaded) break;
                }

                if (!bDownloaded) throw new Exception(string.Format("Could not download file: {0}", resource.name));
            }

            // Make sure that we have the 7-zip extractor.
            if (!File.Exists("7z.exe")) throw new Exception("7z.exe not found. Redownload the ALFA Deployer Tool.");
            string CmdArguments = "x \"{0}\" -o\"" + NWN2HomePath + "\\{1}\\\"";

            // Delete previous 7zip log file if it exists.
            if (File.Exists("DeploymentTool_7zip.log")) File.Delete("DeploymentTool_7zip.log");

            // Extract files.
            foreach (ADLResource resource in ADLResources)
            {
                string filename = GetHomeSubfolder("staging\\client\\") + resource.name + ".lzma";
                string destination = NWN2HomePath + "\\" + resource.type.ToLower() + "\\" + resource.name;

                // Check to see if the destination is valid.
                if (File.Exists(destination) && VerifyFile(destination, resource))
                {
                    Console.WriteLine("File '{0}' does not need to be extracted.", resource.name);
                    continue;
                }

                if (File.Exists(destination)) File.Delete(destination);

                ProcessStartInfo SevenZipInfo = new ProcessStartInfo();
                SevenZipInfo.FileName = "7z";
                SevenZipInfo.Arguments = string.Format(CmdArguments, filename, resource.type);
                SevenZipInfo.RedirectStandardOutput = true;
                SevenZipInfo.RedirectStandardError = true;
                SevenZipInfo.UseShellExecute = false;
                SevenZipInfo.CreateNoWindow = true;

                Process SevenZip = new Process();
                SevenZip.StartInfo = SevenZipInfo;
                SevenZip.OutputDataReceived += ParseOutput_7zip;
                SevenZip.ErrorDataReceived += ParseOutput_7zip;

                Console.WriteLine("Extracting '{0}' ...", resource.name);
                SevenZip.Start();
                SevenZip.BeginOutputReadLine();
                SevenZip.BeginErrorReadLine();
                SevenZip.WaitForExit();

                // Check exit codes.
                int ExitCode = SevenZip.ExitCode;
                if (ExitCode == 1)
                {
                    Console.WriteLine("WARNING: Non-fatal errors when extracting '{0}'", resource.name);
                }
                else if (ExitCode == 2)
                {
                    throw new Exception(string.Format("Fatal error when extracting '{0}'", resource.name));
                }
                else if (ExitCode == 7)
                {
                    throw new Exception(string.Format("Command line error: '{0} {1}'", SevenZipInfo.FileName, SevenZipInfo.Arguments));
                }
                else if (ExitCode == 8)
                {
                    throw new Exception(string.Format("Not enough memory when extracting '{0}'", resource.name));
                }

                // Verify extracted file.
                if (!VerifyFile(filename, resource))
                {
                    File.Delete(filename);
                    File.Delete(destination);
                    throw new Exception("Could not verify extracted file. Deleting.");
                }
            }
        }

        private void RecompileModuleScripts()
        {
            // Verify that we have the advanced script compiler.
            string ScriptCompilerFilename = "NWNScriptCompiler.exe";
            if (!File.Exists(ScriptCompilerFilename)) throw new Exception(string.Format("{0} not found!", ScriptCompilerFilename));


            // Delete previous compile log file if it exists.
            if (File.Exists("DeploymentTool_Recompile.log")) File.Delete("DeploymentTool_Recompile.log");

            // Recompile all scripts in the module.
            string Command = ScriptCompilerFilename;
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
            Console.WriteLine("Recompiling '{0}", NWN2HomePath + "\\modules\\" + ModuleName + "\\*.nss");
            cmdProcess.Start();
            cmdProcess.BeginOutputReadLine();
            cmdProcess.BeginErrorReadLine();
            cmdProcess.WaitForExit();
        }

        private void PatchModuleResourceXML()
        {
            string ModuleDLResourcePath = GetModuleFolder() + "\\moduledownloaderresources.xml";
            Console.WriteLine("Patching '{0}'", ModuleDLResourcePath);

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

        private void AdjustModuleVariables()
        {

        }

        void ParseOutput_7zip(object sender, DataReceivedEventArgs e)
        {
            if (e.Data == null) return;

            // Log all output to the log file.
            StreamWriter log = File.AppendText("DeploymentTool_7zip.log");
            log.WriteLine("{0}", e.Data);
            log.Close();
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

        private bool VerifyFile(string filename, ADLResource resource, string hash = "")
        {
            // Get file info.
            FileInfo f = new FileInfo(filename);

            // Get hash if it isn't provided.
            if (hash.Length < 1)
            {
                hash = GetSHA1Hash(filename);
            }

            // Get the size and hash we're checking against.
            long size = 0;
            string checkHash = "";
            if (f.Extension.Equals(".lzma"))
            {
                size = resource.dlsize;
                checkHash = resource.downloadHash;
            }
            else
            {
                size = resource.size;
                checkHash = resource.hash;
            }

            // Make checks.
            if (size != f.Length)
            {
                return false;
            }
            else if (!hash.Equals(checkHash))
            {
                return false;
            }

            return true;
        }

        private string GetSHA1Hash(string filename)
        {
            FileStream fStream = new FileStream(filename, FileMode.Open);
            SHA1Managed sha1 = new SHA1Managed();
            byte[] buffer = sha1.ComputeHash(fStream);
            StringBuilder formatted = new StringBuilder(buffer.Length);
            foreach (byte b in buffer)
            {
                formatted.AppendFormat("{0:X2}", b);
            }
            fStream.Close();

            return formatted.ToString().ToUpper();
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
