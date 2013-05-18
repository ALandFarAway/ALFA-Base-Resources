using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using CLRScriptFramework;
using NWScript;

using NWEffect = NWScript.NWScriptEngineStructure0;
using NWEvent = NWScript.NWScriptEngineStructure1;
using NWLocation = NWScript.NWScriptEngineStructure2;
using NWTalent = NWScript.NWScriptEngineStructure3;
using NWItemProperty = NWScript.NWScriptEngineStructure4;

namespace ALFA.Shared
{
    public class ActiveTrap : TrapResource
    {
        // Functional flags only needed by active traps.
        public uint Disabler;
        public List<uint> Helpers;
        public int TotalHelp;
        public bool IsFiring;
        public bool Detected;

        // For the chooser
        public string DetectTag;
        public string AreaName;

        public override string Classification
        {
            get
            {
                return String.Format("{0}|Traps", AreaName);
            }
        }
    }
}
