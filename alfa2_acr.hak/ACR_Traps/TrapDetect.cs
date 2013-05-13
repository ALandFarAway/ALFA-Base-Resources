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
    public class TrapDetect : CLRScriptBase
    {
        public static void Enter(CLRScriptBase s, ALFA.Shared.ActiveTrap trap)
        {
            uint enteringObject = s.GetEnteringObject();

            if (IsTrapDetectedBy(s, trap, enteringObject))
            {
                HandleTrapDetected(s, trap, enteringObject);
            }
        }

        public static void Exit(CLRScriptBase s, ALFA.Shared.ActiveTrap trap)
        {
            s.SendMessageToPC(s.GetEnteringObject(), String.Format("If I were implemented, {0} would no longer be in detection range.", trap.Tag));
        }

        private static void HandleTrapDetected(CLRScriptBase s, ALFA.Shared.ActiveTrap trap, uint detector)
        {
            trap.Detected = true;
           
            NWEffect vfx = s.SupernaturalEffect(s.EffectNWN2SpecialEffectFile(trap.TrapTriggerVFX, OBJECT_INVALID, s.Vector(0.0f, 0.0f, 0.0f)));
            s.ApplyEffectToObject(DURATION_TYPE_PERMANENT, vfx, s.GetObjectByTag(trap.Tag, 0), 0.0f);

            s.CreateObject(OBJECT_TYPE_PLACEABLE, "acr_trap_disarm", s.GetLocation(detector), TRUE, trap.Tag + "_");
            
            // If they clicked to walk, let's stop them from walking into the hazard they just found.
            if (s.GetCurrentAction(detector) == ACTION_MOVETOPOINT)
            {
                s.AssignCommand(detector, delegate { s.ClearAllActions(0); });
            }

            s.SendMessageToPC(detector, "You spot a trap!");
        }

        private static void DetectHeartBeat(CLRScriptBase s, ALFA.Shared.ActiveTrap trap, uint detector)
        {
            if (IsTrapDetectedBy(s, trap, detector))
            {
                HandleTrapDetected(s, trap, detector);
            }
        }

        private static bool IsTrapDetectedBy(CLRScriptBase s, ALFA.Shared.ActiveTrap trap, uint detector)
        {
            if (trap.Detected)
            {
                return false;
            }
            if(!IsInArea(s, trap, detector))
            {
                return false;
            }

            if (s.GetDetectMode(detector) == FALSE)
            {
                s.DelayCommand(6.0f, delegate { DetectHeartBeat(s, trap, detector); });
                return false;
            }

            if (trap.DetectDC > 20 &&
                s.GetLevelByClass(CLASS_TYPE_ROGUE, detector) == FALSE &&
                s.GetHasSpellEffect(SPELL_FIND_TRAPS, detector) == FALSE)
            {
                s.DelayCommand(6.0f, delegate { DetectHeartBeat(s, trap, detector); }); 
                return false;
            }

            int searchBonus = s.GetSkillRank(SKILL_SEARCH, detector, FALSE);
            int roll = s.d20(1);
            int finalDice = roll + searchBonus;
            if (trap.DetectDC <= searchBonus)
            {
                return true;
            }
            s.DelayCommand(6.0f, delegate { DetectHeartBeat(s, trap, detector); });
            return false;
        }

        private static bool IsInArea(CLRScriptBase s, ALFA.Shared.ActiveTrap trap, uint creature)
        {
            uint nwTrap = s.GetObjectByTag(trap.DetectTag, 0);
            foreach (uint item in s.GetObjectsInPersistentObject(nwTrap, OBJECT_TYPE_CREATURE, PERSISTENT_ZONE_ACTIVE))
            {
                if (item == creature)
                {
                    return true;
                }
            }
            return false;
        }
    }
}
