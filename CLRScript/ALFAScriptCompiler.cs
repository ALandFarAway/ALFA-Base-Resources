//
// This module contains logic for compiling scripts by invoking the script
// compiler program.
// 

using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;
using System.Diagnostics;
using System.IO;
using System.Net;

namespace ALFA
{

    /// <summary>
    /// This class encapsulates general system information about the game
    /// environment and configuration.
    /// </summary>
    public static class ScriptCompiler
    {

        /// <summary>
        /// This structure describes the result of a compilation attempt.
        /// </summary>
        public struct CompilerResult
        {
            /// <summary>
            /// True if the compilation succeeded.
            /// </summary>
            public bool Compiled;

            /// <summary>
            /// The list of warning messages.
            /// </summary>
            public IList<string> Warnings;

            /// <summary>
            /// The list of error messages.
            /// </summary>
            public IList<string> Errors;
        };

        /// <summary>
        /// A function to be called on each line that the compiler prints to
        /// standard output.
        /// </summary>
        /// <param name="Line">Supplies the line to parse.</param>
        /// <returns>If true, the line should be ignored by the library and
        /// not parsed.  Otherwise, if false, the library parses the line and
        /// accumulates warning and error messages as appropriate.</returns>
        public delegate bool CompilerParseLineDelegate(string Line);

        /// <summary>
        /// Compile a script (or set of scripts), and return information about
        /// the compilation request.
        /// </summary>
        /// <param name="Filespec">Supplies a filespec of files to compile,
        /// such as *.nss.</param>
        /// <param name="Options">Optionally supplies additional compiler
        /// options (e.g. -e -v1.70).</param>
        /// <param name="ParseLine">Optionally supplies a function to parse
        /// each line printed by the compiler.</param>
        /// <returns>A compiler result descriptor is returned.</returns>
        public static CompilerResult CompileScript(string Filespec, string Options, CompilerParseLineDelegate ParseLine = null)
        {
            CompilerResult Result = new CompilerResult();

            Result.Compiled = false;
            Result.Warnings = new List<string>();
            Result.Errors = new List<string>();

            try
            {
                //
                // Construct the command line for the compiler instance.
                //

                string CmdLine = CreateCompilerCommandLine(Filespec, Options);
                Process CompilerProcess;
                ProcessStartInfo StartInfo = new ProcessStartInfo(GetCompilerExe(), CmdLine);
                string Line;

                //
                // Start the compiler process and begin reading stdout until
                // end of file is reached.  In the absence of any error
                // messages observed, the operation is assumed to have
                // completed successfully.
                //

                StartInfo.CreateNoWindow = true;
                StartInfo.UseShellExecute = false;
                StartInfo.WindowStyle = ProcessWindowStyle.Hidden;
                StartInfo.RedirectStandardOutput = true;
                StartInfo.WorkingDirectory = ALFA.SystemInfo.GetModuleDirectory();

                CompilerProcess = Process.Start(StartInfo);
                Result.Compiled = true;

                while ((Line = CompilerProcess.StandardOutput.ReadLine()) != null)
                {
                    //
                    // Parse each line, examining it for a compiler diagnostic
                    // indicator.  Accumulate errors and warnings into their
                    // respective diagnostic message lists for the caller to
                    // examine.
                    //

                    if (ParseLine != null && ParseLine(Line))
                        continue;

                    if (Line.StartsWith("Error:"))
                    {
                        Result.Errors.Add(Line);
                        Result.Compiled = false;
                    }
                    else if (Line.Contains("): Error: NSC"))
                    {
                        Result.Errors.Add(Line);
                        Result.Compiled = false;
                    }
                    else if (Line.StartsWith("Warning:"))
                    {
                        Result.Warnings.Add(Line);
                    }
                    else if (Line.Contains("): Warning: NSC"))
                    {
                        Result.Warnings.Add(Line);
                    }
                }

                CompilerProcess.WaitForExit();
            }
            catch (Exception e)
            {
                Result.Errors.Add(String.Format(
                    "ALFA.ScriptCompiler.CompileScript({0}, {1}): Exception: '{2}'.",
                    Filespec,
                    Options,
                    e));
                Result.Compiled = false;
            }

            return Result;
        }

        /// <summary>
        /// Get the path to NWNScriptCompiler.exe.
        /// </summary>
        /// <returns>The compiler EXE path.</returns>
        private static string GetCompilerExe()
        {
            return ALFA.SystemInfo.GetNWNX4InstallationDirectory() + "NWNScriptCompiler.exe";
        }

        /// <summary>
        /// Create the command line for the compiler given a filespec to
        /// attempt to compile.
        /// </summary>
        /// <param name="Filespec">Supplies the file specification of the
        /// target file(s) to compile.</param>
        /// <param name="Options">Supplies additional compiler options.</param>
        /// <returns>A compiler command line to compile the given script(s) is
        /// returned.</returns>
        private static string CreateCompilerCommandLine(string Filespec, string Options)
        {
            string InstallDir = Path.GetDirectoryName(ALFA.SystemInfo.GetGameInstallationDirectory());
            string HomeDir = Path.GetDirectoryName(ALFA.SystemInfo.GetHomeDirectory());
            string ModuleDir = ALFA.SystemInfo.GetModuleDirectory();

            if (ModuleDir == null)
                throw new ApplicationException("Unable to determine module directory; verify that NWNX4 was configured to start nwn2server with a -module option.");

            ModuleDir = ModuleDir + Path.DirectorySeparatorChar;

            if (Options == null)
                Options = "";

            return String.Format("-c -n \"{0}\" -h \"{1}\" -m \"{2}\" {3} \"{4}{5}\"",
                InstallDir,
                HomeDir,
                ALFA.SystemInfo.GetModuleResourceName(),
                Options,
                ModuleDir,
                Filespec);
        }

    }   
}

