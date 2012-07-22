using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Net;
using System.Text;
using System.Xml;
using System.Xml.Linq;

namespace DeploymentTool
{
    class DependencyResource
    {
        public DependencyResource(XElement xmlElement)
        {
            // Load basic resources.
            name = (string)xmlElement.Attribute("name");
            hash = (string)xmlElement.Attribute("hash");
            downloadHash = (string)xmlElement.Attribute("downloadHash");
            size = (long)xmlElement.Attribute("size");
            downloadSize = (long)xmlElement.Attribute("downloadSize");
            location = (string)xmlElement.Attribute("location");

            // Get download resources.
            servers = new List<int>();
            List<XElement> ServerRefs = xmlElement.Element("server-ref").Elements().ToList();
            for (int i = 0; i < ServerRefs.Count; i++)
            {
                servers.Add(int.Parse(ServerRefs[i].Value));
            }
            if (servers.Count == 0)
            {
                Console.WriteLine(string.Format("WARNING: Dependency entry '{0}' contains no valid server references.", name));
            }
        }

        public void Update(ALFADeployerTool deployer, string DownloadDirectory)
        {
            // Get the download location.
            string DownloadPath = DownloadDirectory + "\\" + name + ".lzma";

            // Get the file location.
            string FileDir = null;
            string FilePath = FileDir + "\\" + name;

            Console.WriteLine("Updating '{0}' ...", name);

            // Does the file exist and is it valid?
            if (File.Exists(FilePath))
            {
                if (FileVerification.VerifyFile(FilePath, this))
                {
                    Console.WriteLine("File verified. Update not required.");
                    return;
                }
                else
                {
                    Console.WriteLine("File found, but failed verification. Updating.");
                    File.Delete(FilePath);
                }
            }

            // Does the download file exist and is valid?
            bool bDownloadRequired = true;
            if (File.Exists(DownloadPath))
            {
                if (FileVerification.VerifyFile(DownloadPath, this))
                {
                    Console.WriteLine("Download file found. Extracting.");
                    bDownloadRequired = false;
                }
                else
                {
                    File.Delete(DownloadPath);
                }
            }

            // Download file if necessary.
            if (bDownloadRequired)
            {
                WebClient downloader = new WebClient();
                bool bDownloaded = false;
                foreach (int server in servers)
                {
                    try
                    {
                        // Valid server?
                        if (!deployer.ServerList.Keys.Contains(server)) throw new Exception("Server not found.");

                        // Get local and remote destinations.
                        string url = deployer.ServerList[server] + name + ".lzma";

                        // Try to download.
                        float sizeInMB = (float)(downloadSize) / 1024 / 1024;
                        Console.WriteLine("Downloading update from server {1} ({2} MB)", name, server, sizeInMB);
                        downloader.DownloadFile(url, DownloadPath);

                        // Download. Verify file again.
                        if (!FileVerification.VerifyFile(DownloadPath, this))
                        {
                            // TODO: Log the details of the discrepency.
                            throw new Exception("Verification failed.");
                        }

                        bDownloaded = true;
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("WARNING: Download failed for server index '{0}'. {1}", server, e.Message);
                        if (File.Exists(DownloadPath)) File.Delete(DownloadPath);
                    }

                    // Break if we downloaded it successfully.
                    if (bDownloaded) break;
                }

                if (!bDownloaded) throw new Exception(string.Format("Could not download file: {0}", name));
            }

            // Extract it.
            SevenzipExtractor extractor = new SevenzipExtractor(DownloadPath);
            int ExitCode = extractor.extract(FileDir);

            // Check exit codes.
            if (ExitCode == 1)
            {
                Console.WriteLine("WARNING: Non-fatal errors when extracting '{0}'", name);
            }
            else if (ExitCode == 2)
            {
                throw new Exception(string.Format("Fatal error when extracting '{0}'", name));
            }
            else if (ExitCode == 7)
            {
                throw new Exception(string.Format("Command line error."));
            }
            else if (ExitCode == 8)
            {
                throw new Exception(string.Format("Not enough memory when extracting '{0}'", name));
            }

            // Verify extracted file.
            if (!FileVerification.VerifyFile(FilePath, this))
            {
                throw new Exception("Could not verify extracted file. Contact the technical administrator.");
            }
        }

        public string name;
        public string hash;
        public string downloadHash;
        public long size;
        public long downloadSize;
        public string location;
        public List<int> servers;
    }
}
