using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using SevenZip;

namespace DeploymentStager
{
    class SevenzipCompresser
    {
        public SevenzipCompresser(string path)
        {
            Filename = path;
        }

        public int compress( string destination )
        {
            ProcessStartInfo SevenZipInfo = new ProcessStartInfo();
            SevenZipInfo.FileName = Program.SevenZipFilename;
            SevenZipInfo.Arguments = string.Format(CmdArguments, destination, Filename);
            SevenZipInfo.RedirectStandardOutput = true;
            SevenZipInfo.RedirectStandardError = true;
            SevenZipInfo.UseShellExecute = false;
            SevenZipInfo.CreateNoWindow = true;

            Process SevenZip = new Process();
            SevenZip.StartInfo = SevenZipInfo;
            SevenZip.OutputDataReceived += ReadOutput;
            SevenZip.ErrorDataReceived += ReadOutput;

            Console.WriteLine("Compressing '{0}' ...", Filename);
            SevenZip.Start();
            SevenZip.BeginOutputReadLine();
            SevenZip.BeginErrorReadLine();
            SevenZip.WaitForExit();
            return SevenZip.ExitCode;
        }

        void ReadOutput(object sender, DataReceivedEventArgs e)
        {
            if (e.Data == null) return;

            // Log all output to the log file.
            StreamWriter log = File.AppendText("DeploymentStager_7zip.log");
            log.WriteLine("{0}", e.Data);
            log.Close();
        }
        public static string LogFilename = "Log_7zip.log";
        private static string CmdArguments = "a \"{0}\" \"{1}\"";

        private string Filename;
    }
}
