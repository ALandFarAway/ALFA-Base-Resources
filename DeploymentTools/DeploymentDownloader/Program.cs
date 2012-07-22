using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using ALFA;
using CLRScriptFramework;

namespace DeploymentDownloader
{
    class Program
    {
        static void Main(string[] args)
        {
            // Delete the old deployment logs.
            if (File.Exists("DeploymentStager.log")) File.Delete("DeploymentStager.log");
            if (File.Exists(SevenzipExtractor.LogFilename)) File.Delete(SevenzipExtractor.LogFilename);
            if (File.Exists("DeploymentStager_Recompile.log")) File.Delete("DeploymentStager_Recompile.log");


            // Make sure that we have the 7-zip extractor.
            if (!File.Exists(SevenZipFilename)) throw new Exception(string.Format("{0} not found!", SevenZipFilename));

            // Verify that we have the Advanced Script Compiler.
            if (!File.Exists(ScriptCompilerFilename)) throw new Exception(string.Format("{0} not found!", ScriptCompilerFilename));

            ALFADeployerTool DeployerTool = new ALFADeployerTool();
            try
            {
                DeployerTool.Run();
            }
            catch (Exception e)
            {
                Console.WriteLine(String.Format("ERROR: {0}", e.Message));
                StreamWriter log = File.AppendText("DeploymentTool.log");
                log.WriteLine("{0}", e);
                log.Close();
            }

            // Pause for user interaction before closing.
            Console.Write("Press any key to exit.");
            Console.ReadKey(true);
        }

        public static string ScriptCompilerFilename = "NWNScriptCompiler.exe";
        public static string SevenZipFilename = "7z.exe";
    }
}
