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
    public class TrapTrigger : CLRScriptBase
    {
        public static void Enter(CLRScriptBase s, ALFA.Shared.ActiveTrap trap)
        {
            s.SendMessageToPC(s.GetEnteringObject(), String.Format("If I were implemented, {0} would be blasting you right now.", trap.Tag));
        }

        public static void Exit(CLRScriptBase s, ALFA.Shared.ActiveTrap trap)
        {
            s.SendMessageToPC(s.GetEnteringObject(), String.Format("If I were implemented, {0} no longer be blasting you.", trap.Tag));
        }

        public static void Fire(CLRScriptBase s, ALFA.Shared.ActiveTrap trap, uint specialTarget = OBJECT_INVALID)
        {
            if (s.GetIsObjectValid(specialTarget) == TRUE)
            {
                s.SendMessageToPC(specialTarget, String.Format("If I were implemented, {0} would have just fired on you.", trap.Tag));
            }
        }
    }
}
