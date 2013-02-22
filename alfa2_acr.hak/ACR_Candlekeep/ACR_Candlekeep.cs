using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;
using System.Reflection;
using System.Reflection.Emit;
using System.Threading;
using CLRScriptFramework;
using ALFA;
using NWScript;
using NWScript.ManagedInterfaceLayer.NWScriptManagedInterface;

using NWEffect = NWScript.NWScriptEngineStructure0;
using NWEvent = NWScript.NWScriptEngineStructure1;
using NWLocation = NWScript.NWScriptEngineStructure2;
using NWTalent = NWScript.NWScriptEngineStructure3;
using NWItemProperty = NWScript.NWScriptEngineStructure4;

namespace ACR_Candlekeep
{
    public partial class ACR_Candlekeep : CLRScriptBase, IGeneratedScriptProgram
    {
        public ACR_Candlekeep([In] NWScriptJITIntrinsics Intrinsics, [In] INWScriptProgram Host)
        {
            InitScript(Intrinsics, Host);
        }

        private ACR_Candlekeep([In] ACR_Candlekeep Other)
        {
            InitScript(Other);

            LoadScriptGlobals(Other.SaveScriptGlobals());
        }

        public static Type[] ScriptParameterTypes =
        { typeof(int) };

        public Int32 ScriptMain([In] object[] ScriptParameters, [In] Int32 DefaultReturnCode)
        {
            int Value = (int)ScriptParameters[0]; // ScriptParameterTypes[0] is typeof(int)

            Archivist worker = new Archivist();
            SendMessageToPC(OBJECT_SELF, "Starting Candlekeep");
            switch((Commands)Value)
            {
                case Commands.INITIALIZE_ARCHIVES:
                    ALFA.Shared.Modules.InfoStore = new Archives();
                    worker.DoWork += worker.InitializeArchives;
                    worker.RunWorkerAsync();
                    break;
            }

            SendMessageToPC(OBJECT_SELF, "Script finished");
            return 0;
        }

        enum Commands
        {
            INITIALIZE_ARCHIVES = 0,
        }
    }
}
