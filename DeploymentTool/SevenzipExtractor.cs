using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;

namespace DeploymentTool
{
    class SevenzipExtractor
    {
        public SevenzipExtractor(string path)
        {
            Filename = path;
        }

        public int extract( string destination )
        {
            ProcessStartInfo SevenZipInfo = new ProcessStartInfo();
            SevenZipInfo.FileName = Program.SevenZipFilename;
            SevenZipInfo.Arguments = string.Format(CmdArguments, Filename, destination);
            SevenZipInfo.RedirectStandardOutput = true;
            SevenZipInfo.RedirectStandardError = true;
            SevenZipInfo.UseShellExecute = false;
            SevenZipInfo.CreateNoWindow = true;

            Process SevenZip = new Process();
            SevenZip.StartInfo = SevenZipInfo;
            SevenZip.OutputDataReceived += ReadOutput;
            SevenZip.ErrorDataReceived += ReadOutput;

            Console.WriteLine("Extracting '{0}' ...", Filename);
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
            StreamWriter log = File.AppendText("DeploymentTool_7zip.log");
            log.WriteLine("{0}", e.Data);
            log.Close();
        }
        public static string LogFilename = "Log_7zip.log";
        private static string CmdArguments = "x \"{0}\" -o\"{1}\\\"";

        private string Filename;
        private bool Success;
    }
}
