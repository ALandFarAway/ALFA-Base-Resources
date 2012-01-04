//
// This script is used during development to load other script assemblies
// dynamically without requiring a server restart.  Its purpose is to enable
// faster development and testing.
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

namespace ScriptLoader
{
    public partial class ScriptLoader : CLRScriptBase, IGeneratedScriptProgram
    {

        public ScriptLoader([In] NWScriptJITIntrinsics Intrinsics, [In] INWScriptProgram Host)
        {
            InitScript(Intrinsics, Host);
        }

        private ScriptLoader([In] ScriptLoader Other)
        {
            InitScript(Other);

            LoadScriptGlobals(Other.SaveScriptGlobals());
        }

        public static Type[] ScriptParameterTypes = { typeof(string) };

        public Int32 ScriptMain([In] object[] ScriptParameters, [In] Int32 DefaultReturnCode)
        {
            string ScriptFileName = (string)ScriptParameters[0];
            IGeneratedScriptProgram ScriptObject;

            ScriptObject = ALFA.ScriptLoader.LoadScriptFromDisk(ScriptFileName, this);

            ScriptObject.ExecuteScript(OBJECT_SELF, ALFA.ScriptLoader.GetDefaultParametersForScript(ScriptObject, this), DefaultReturnCode);

            return DefaultReturnCode;
        }
    }
}
