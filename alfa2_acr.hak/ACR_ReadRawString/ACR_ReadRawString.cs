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

namespace ACR_ReadRawString
{
    public partial class ACR_ReadRawString : CLRScriptBase, IGeneratedScriptProgram
    {
        public ACR_ReadRawString([In] NWScriptJITIntrinsics Intrinsics, [In] INWScriptProgram Host)
        {
            InitScript(Intrinsics, Host);
        }

        private ACR_ReadRawString([In] ACR_ReadRawString Other)
        {
            InitScript(Other);

            LoadScriptGlobals(Other.SaveScriptGlobals());
        }

        public static Type[] ScriptParameterTypes = { typeof(uint), typeof(string) };

        public Int32 ScriptMain([In] object[] ScriptParameters, [In] Int32 DefaultReturnCode)
        {
            uint Object = (uint)ScriptParameters[0]; 
            string Key = (string)ScriptParameters[1]; 
            string ModuleDir, GFFName, ResRef, Extension = "";

	    ModuleDir = ALFA.SystemInfo.GetModuleResourceName();

	    if (ModuleDir == null) {
		    ModuleDir = GetModuleName();
	    }

	    ModuleDir = ALFA.SystemInfo.GetHomeDirectory() + "modules\\" + ModuleDir + "\\";
	    
            ResRef = GetResRef(Object);
	    
	    switch (GetObjectType(Object)) {
		    case OBJECT_TYPE_CREATURE:
			    Extension = "utc";
			    break;
		    case OBJECT_TYPE_ITEM:
			    Extension = "uti";
			    break;
		    case OBJECT_TYPE_PLACEABLE:
			    Extension = "utp";
			    break;
		    default:
			    break;
	    }
            
	    try {
	        OEIShared.IO.GFF.GFFFile gff = new OEIShared.IO.GFF.GFFFile(ModuleDir + ResRef + "." + Extension);
        	GFFName = gff.TopLevelStruct.GetExoLocStringSafe(Key).Strings.First().Value;

	    	SetLocalString(Object, "RawText", GFFName.Replace("{","[").Replace("}","]"));
	    }
	    catch {
	    }

            return DefaultReturnCode;
	}

    }
}
