//
// This module contains logic for dealing with game system information.
// 

using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;
using System.Reflection;
using System.Reflection.Emit;
using System.Diagnostics;
using System.IO;
using CLRScriptFramework;
using NWScript;
using NWScript.ManagedInterfaceLayer.NWScriptManagedInterface;

using NWEffect = NWScript.NWScriptEngineStructure0;
using NWEvent = NWScript.NWScriptEngineStructure1;
using NWLocation = NWScript.NWScriptEngineStructure2;
using NWTalent = NWScript.NWScriptEngineStructure3;
using NWItemProperty = NWScript.NWScriptEngineStructure4;

namespace ALFA
{

    public class SystemInfo
    {

        /// <summary>
        /// This method gets the directory where the game is installed.  The
        /// path has a trailing path separator.
        /// </summary>
        /// <returns>The game installation directory is returned.</returns>
        public static string GetGameInstallationDirectory()
        {
            string[] Args = Environment.GetCommandLineArgs();

            for (int i = 0; i < Args.Length; i += 1)
            {
                if (Args[i] == "-installdir" && i + 1 < Args.Length)
                    return Args[i + 1] + "\\";
            }

            return Path.GetDirectoryName(Process.GetCurrentProcess().MainModule.FileName);
        }

        /// <summary>
        /// This routine gets the NWN2 "Home" directory, which is the directory
        /// name by -home on the command line, or else the user's NWN2
        /// directory under Documents.
        /// </summary>
        /// <returns>The game home directory is returned.</returns>
        public static string GetHomeDirectory()
        {
            string[] Args = Environment.GetCommandLineArgs();

            for (int i = 0; i < Args.Length; i += 1)
            {
                if (Args[i] == "-home" && i + 1 < Args.Length)
                    return Args[i + 1] + "\\";
            }

            return Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments) + "\\Neverwinter Nights 2\\";
        }

        /// <summary>
        /// This routine gets the resource name of the module that was passed
        /// on the server command line.  Note that if the server did not have a
        /// module argument then null is returned.
        /// </summary>
        /// <returns>The module resource name is returned.</returns>
        public static string GetModuleResourceName()
        {
            string[] Args = Environment.GetCommandLineArgs();

            for (int i = 0; i < Args.Length; i += 1)
            {
                if (((Args[i] == "-module") || (Args[i] == "-moduledir")) && i + 1 < Args.Length)
                    return Args[i + 1];
            }

            return null;
        }
    }
}

