using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using ALFA;
using CLRScriptFramework;

namespace DeploymentTool
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.Clear();

            File.Delete("DeploymentTool.log");

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
            Console.Write("Press any key to exit.");
            Console.ReadKey(true);
        }
    }
}
