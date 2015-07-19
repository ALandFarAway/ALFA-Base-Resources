using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace PortraitSyncer
{
    class Program
    {
        static void Main(string[] args)
        {
            // Ensure portraits folder exists.
            Directory.CreateDirectory("portraits");

            // Download portraits manifest.
            Console.WriteLine("Downloading manifest...");
            var webClient = new WebClient();
            var manifestPath = "portraits/manifest.dat";
            webClient.DownloadFile("http://alandfaraway.pw/NWN2/portraits/manifest.dat", manifestPath);

            // Parse download.
            var manifestEntries = File.ReadAllLines(manifestPath);

            // Parse to get total bytes to sync.
            int totalBytes = 0;
            foreach (var entry in manifestEntries)
            {
                try
                {
                    totalBytes += Convert.ToInt32(entry.Split('|')[1]);
                }
                catch (Exception e)
                {
                    Console.WriteLine("Error: {0}", e.Message);
                }
            }

            // Keep a list of problematic downloads.
            var failedDownloads = new List<string>();

            // Read the manifest and download portraits...
            Console.WriteLine("Syncing {0} portraits ({1} MB)...", manifestEntries.Length, totalBytes / 1048576);
            int downloadedPortraits = 0;
            int downloadedBytes = 0;
            int i = 0;
            foreach (var entry in manifestEntries)
            {
                i++;
                try
                {
                    if (!entry.Contains("|")) continue;

                    // Gather data from manifest entry.
                    var data = entry.Split('|');
                    var portraitName = data[0];
                    var portraitSize = Convert.ToInt32(data[1]);
                    var portraitPath = "portraits/" + portraitName + ".tga";

                    // Validate data.
                    if (portraitName.Contains("..") || portraitName.Contains("/") || portraitName.Contains("\\"))
                    {
                        throw new Exception("Portraits may not contain relative directory paths.");
                    }

                    // File already exist of the right size? Skip it.
                    if (File.Exists(portraitPath))
                    {
                        var portraitInfo = new FileInfo(portraitPath);
                        if (portraitInfo.Length == portraitSize)
                            continue;
                    }

                    // Download portrait...
                    Console.WriteLine("  [{0} of {1}] Downloading: {2} ({3} bytes)", i, manifestEntries.Length, portraitPath, portraitSize);
                    webClient.DownloadFile("http://alandfaraway.pw/NWN2/" + portraitPath, portraitPath);

                    // Verify file size.
                    var downloadedPortraitInfo = new FileInfo(portraitPath);
                    if (downloadedPortraitInfo.Length != portraitSize)
                    {
                        File.Delete(portraitPath);
                        throw new Exception("Portrait download does not match expected size!");
                    }

                    downloadedPortraits++;
                    downloadedBytes += portraitSize;
                }
                catch (Exception e)
                {
                    failedDownloads.Add(entry);
                    Console.WriteLine("    Error: {0}", e.Message);
                }
            }

            // Print problematic downloads.
            if (failedDownloads.Count > 0)
            {
                Console.WriteLine("\nFailed to download {0} files:", failedDownloads.Count);
                foreach (var failedDownload in failedDownloads)
                    Console.WriteLine("    {0}", failedDownload);
            }

            // Print out some end of program information.
            Console.WriteLine("\nFinished downloading {0} portraits, totaling {1} MB.", downloadedPortraits, downloadedBytes / 1048576);
            Console.WriteLine("Press any key to continue...");
            Console.ReadKey();
        }
    }
}
