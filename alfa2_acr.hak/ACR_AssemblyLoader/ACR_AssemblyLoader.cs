//
// This module contains logic for providing common assembly resolution services
// for ALFA shared assemblies.
// 

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;
using System.Reflection;
using System.Reflection.Emit;
using System.Threading;
using CLRScriptFramework;
using NWScript;
using NWScript.ManagedInterfaceLayer.NWScriptManagedInterface;

using NWEffect = NWScript.NWScriptEngineStructure0;
using NWEvent = NWScript.NWScriptEngineStructure1;
using NWLocation = NWScript.NWScriptEngineStructure2;
using NWTalent = NWScript.NWScriptEngineStructure3;
using NWItemProperty = NWScript.NWScriptEngineStructure4;

namespace ACR_AssemblyLoader
{
    public partial class ACR_AssemblyLoader : CLRScriptBase, IGeneratedScriptProgram
    {
        public ACR_AssemblyLoader([In] NWScriptJITIntrinsics Intrinsics, [In] INWScriptProgram Host)
        {
            InitScript(Intrinsics, Host);
        }

        private ACR_AssemblyLoader([In] ACR_AssemblyLoader Other)
        {
            InitScript(Other);

            LoadScriptGlobals(Other.SaveScriptGlobals());
        }

        public static Type[] ScriptParameterTypes =
        { typeof(int) };

        public Int32 ScriptMain([In] object[] ScriptParameters, [In] Int32 DefaultReturnCode)
        {
            int Cmd = (int)ScriptParameters[0]; // ScriptParameterTypes[0] is typeof(int)

            switch (Cmd)
            {

                case ACR_ASSEMBLY_LOADER_INITIALIZE:
                    {
                        InitializeAssemblyLoader();
                        break;
                    }
            }

            return 0;
        }

        /// <summary>
        /// Initialize the reference assembly loader.
        /// </summary>
        private void InitializeAssemblyLoader()
        {
            if (Loader != null)
                return;

            try
            {
                Loader = new AssemblyLoader();
            }
            catch (Exception e)
            {
                WriteTimestampedLogEntry(String.Format("ACR_AssemblyLoader.InitializeAssemblyLoader(): AssemblyLoader.AssemblyLoader raised exception '{0}'.", e));
            }
        }

        private const int ACR_ASSEMBLY_LOADER_INITIALIZE = 0;
        private static AssemblyLoader Loader = null;

    }
}
