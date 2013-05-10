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

namespace ACR_Traps
{
    public static class TrapDetect
    {
        public static void Enter(CLRScriptBase s, ALFA.Shared.ActiveTrap trap)
        {
            s.SendMessageToPC(s.GetEnteringObject(), String.Format("If I were implemented, {0} would be in detection range.", trap.Tag));
        }

        public static void Exit(CLRScriptBase s, ALFA.Shared.ActiveTrap trap)
        {
            s.SendMessageToPC(s.GetEnteringObject(), String.Format("If I were implemented, {0} would no longer be in detection range.", trap.Tag));
        }
    }
}
