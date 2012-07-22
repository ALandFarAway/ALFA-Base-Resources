using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

namespace DeploymentStager
{
    class Program
    {
        static void Main(string[] args)
        {
            DeploymentStager StagingTool = new DeploymentStager();

            try
            {
                StagingTool.Run();
            }
            catch (Exception e)
            {
                Console.WriteLine(String.Format("ERROR: {0}", e.Message));
                StreamWriter log = File.AppendText(GenericLogFilename);
                log.WriteLine("{0}", e);
                log.Close();
            }

            // Pause for user interaction before closing.
            Console.Write("Press any key to exit.");
            Console.ReadKey(true);
        }

        public static string GenericLogFilename = "DeploymentStager.log";
        public static string SevenZipFilename = "7z.exe";
    }
}
