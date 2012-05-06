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
            string GFFName, ResRef;
            ushort ResType = 0;

            if (ResourceManager == null)
                ResourceManager = new ALFA.ResourceManager(null);

            ResRef = GetResRef(Object);
	    
	    switch (GetObjectType(Object)) {
		    case OBJECT_TYPE_CREATURE:
                ResType = ResourceManager.ResUTC;
			    break;
		    case OBJECT_TYPE_ITEM:
                ResType = ResourceManager.ResUTI;
			    break;
		    case OBJECT_TYPE_PLACEABLE:
                ResType = ResourceManager.ResUTP;
			    break;
		    default:
			    break;
	    }
            
	    try {
            OEIShared.IO.GFF.GFFFile gff = ResourceManager.OpenGffResource(ResRef, ResType);
        	GFFName = gff.TopLevelStruct.GetExoLocStringSafe(Key).Strings.First().Value;

	    	SetLocalString(Object, "RawText", GFFName.Replace("{","[").Replace("}","]"));
	    }
	    catch {
	    }

            return DefaultReturnCode;
	}


        static ALFA.ResourceManager ResourceManager = null;
    }
}
