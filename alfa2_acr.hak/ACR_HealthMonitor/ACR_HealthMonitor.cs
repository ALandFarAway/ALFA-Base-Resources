//
// This script monitors the health of the server, updating the database on
// health changes as well as taking remedial actions.
//

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;
using System.Reflection;
using System.Reflection.Emit;
using CLRScriptFramework;
using ALFA;
using NWScript;
using NWScript.ManagedInterfaceLayer.NWScriptManagedInterface;

using NWEffect = NWScript.NWScriptEngineStructure0;
using NWEvent = NWScript.NWScriptEngineStructure1;
using NWLocation = NWScript.NWScriptEngineStructure2;
using NWTalent = NWScript.NWScriptEngineStructure3;
using NWItemProperty = NWScript.NWScriptEngineStructure4;

namespace ACR_HealthMonitor
{
    public partial class ACR_HealthMonitor : CLRScriptBase, IGeneratedScriptProgram
    {

        public ACR_HealthMonitor([In] NWScriptJITIntrinsics Intrinsics, [In] INWScriptProgram Host)
        {
            InitScript(Intrinsics, Host);
        }

        private ACR_HealthMonitor([In] ACR_HealthMonitor Other)
        {
            ScriptHost = Other.ScriptHost;
            OBJECT_SELF = Other.OBJECT_SELF;

            LoadScriptGlobals(Other.SaveScriptGlobals());
        }

        public static Type[] ScriptParameterTypes = { typeof(int) };

        public Int32 ScriptMain([In] object[] ScriptParameters, [In] Int32 DefaultReturnCode)
        {
		  		int CurrentLatency = (int) ScriptParameters[0];

            return DefaultReturnCode;
        }
    }
}
