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
            ALFADeployerTool DeployerTool = new ALFADeployerTool();
            try
            {
                // Delete the old deployment logs.
                if (File.Exists(Program.LogFilename)) File.Delete(Program.LogFilename);
                if (File.Exists(SevenzipExtractor.LogFilename)) File.Delete(SevenzipExtractor.LogFilename);
                if (File.Exists("DeploymentStager_Recompile.log")) File.Delete("DeploymentStager_Recompile.log");


                // Make sure that we have the 7-zip extractor.
                if (!File.Exists(SevenZipFilename)) throw new Exception(string.Format("{0} not found!", SevenZipFilename));

                // Verify that we have the Advanced Script Compiler.
                if (!File.Exists(ScriptCompilerFilename)) throw new Exception(string.Format("{0} not found!", ScriptCompilerFilename));

                // Run the deployment tool.
                DeployerTool.Run();
            }
            catch (Exception e)
            {
                LogEvent(e.ToString());
            }

            // Pause for user interaction before closing.
            Console.Write("Press any key to exit.");
            Console.ReadKey(true);
        }

        public static void LogEvent(string Event)
        {
            Console.WriteLine(Event);
            StreamWriter log = File.AppendText(LogFilename);
            log.WriteLine("{0}", Event);
            log.Close();
        }

        public static string LogFilename = "DeploymentDownloader.log";
        public static string ScriptCompilerFilename = "tools\\NWNScriptCompiler.exe";
        public static string SevenZipFilename = "tools\\7z.exe";
    }
}
