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

namespace CB_ModuleLoad
{
    public partial class CB_ModuleLoad : CLRScriptBase
    {
        public Int32 CB_IndexAreas()
        {
            int ReturnValue = 0;

            uint Area = GetFirstArea();
            while (GetIsObjectValid(Area) == TRUE)
            {
                
                Area = GetNextArea();
            }
            return ReturnValue;
        }

    }
}