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
    class TrapDisable : CLRScriptBase
    {
        public static void Disable(CLRScriptBase s, ALFA.Shared.ActiveTrap trap, uint disabler)
        {
            if (trap.Disabler == 0)
            {
                // no one is currently working on this trap.
                trap.Disabler = disabler;
                trap.Helpers = new List<uint>();
            }
            else
            {
                if (trap.Helpers.Contains(disabler))
                {
                    s.SendMessageToPC(disabler, "<c=#98FFFF>Disable Device: * Failure * You have already given aid to this attempt.</c>");
                }
                else
                {
                    trap.Helpers.Add(disabler);
                    if (IsDisableSuccessful(s, 10, disabler) == DisableResult.Success)
                    {
                        trap.TotalHelp += 2;
                    }
                }
            }
            float neededTime = s.d4(2) * 6.0f;
            StallForTime(s, trap, disabler, neededTime, s.GetLocation(disabler));
        }

        public static DisableResult IsDisableSuccessful(CLRScriptBase s, int DC, uint disabler)
        {
            if (s.GetSkillRank(SKILL_DISABLE_TRAP, disabler, TRUE) == 0)
            {
                s.SendMessageToPC(disabler, "<c=#98FFFF>Disable Device: * Success will never be possible *</c>");
                return DisableResult.Failure;
            }
            
            int roll = s.d20(1);
            int skill = s.GetSkillRank(SKILL_DISABLE_TRAP, disabler, FALSE);
            int final = roll + skill;
            string resultString = "Failure!";
            DisableResult value = DisableResult.Failure;
            if (final >= DC)
            {
                value = DisableResult.Success;
                resultString = "Success!";
            }
            if (DC > final + 4)
            {
                value = DisableResult.CriticalFailure;
                resultString = "CRITICAL FAILURE!";
            }
            string message = String.Format("<c=#98FFFF>Disable Device : {0} + {1} = {2} vs. DC {3}. * {4} *</c>", roll, skill, final, DC, resultString);
            s.SendMessageToPC(disabler, message);
            
            return value;
        }

        public static void StallForTime(CLRScriptBase s, ALFA.Shared.ActiveTrap trap, uint disabler, float delay, NWLocation loc)
        {
            delay -= 2.0f;
            if (delay <= 0.5f)
            {
                DisableResult result = IsDisableSuccessful(s, trap.DisarmDC, disabler);
                if (result == DisableResult.Success)
                {
                    RemoveTrap(s, trap);
                }
                else if (result == DisableResult.CriticalFailure)
                {
                    trap.Disabler = 0;
                    trap.Helpers = new List<uint>();
                    trap.TotalHelp = 0;
                    TrapTrigger.Fire(s, trap, disabler);
                    return;
                }
            }
            else
            {
                Vector3 oldPos = s.GetPositionFromLocation(loc);
                NWLocation newLoc = s.GetLocation(disabler);
                Vector3 newPos = s.GetPosition(disabler);
                if(Math.Abs(oldPos.x - newPos.x) > 0.5 ||
                    Math.Abs(oldPos.y - newPos.x) > 0.5)
                {
                    // The disabler has moved. Interpret as canceling.
                    trap.Disabler = 0;
                    trap.Helpers = new List<uint>();
                    trap.TotalHelp = 0;
                    return;
                }

                int action = s.GetCurrentAction(disabler);
                if (action == ACTION_ANIMALEMPATHY ||
                    action == ACTION_ATTACKOBJECT ||
                    action == ACTION_CASTSPELL ||
                    action == ACTION_CLOSEDOOR ||
                    action == ACTION_COUNTERSPELL ||
                    action == ACTION_DIALOGOBJECT ||
                    action == ACTION_DROPITEM ||
                    action == ACTION_EXAMINETRAP ||
                    action == ACTION_FLAGTRAP ||
                    action == ACTION_FOLLOW ||
                    action == ACTION_HEAL ||
                    action == ACTION_ITEMCASTSPELL ||
                    action == ACTION_KIDAMAGE ||
                    action == ACTION_LOCK ||
                    action == ACTION_MOVETOPOINT ||
                    action == ACTION_OPENDOOR ||
                    action == ACTION_OPENLOCK ||
                    action == ACTION_PICKPOCKET ||
                    action == ACTION_PICKUPITEM ||
                    action == ACTION_RANDOMWALK ||
                    action == ACTION_RECOVERTRAP ||
                    action == ACTION_REST ||
                    action == ACTION_SETTRAP ||
                    action == ACTION_SIT ||
                    action == ACTION_SMITEGOOD ||
                    action == ACTION_TAUNT ||
                    action == ACTION_USEOBJECT)
                {
                    // Disabler isn't working on the trap any more. Abort.
                    trap.Disabler = 0;
                    trap.Helpers = new List<uint>();
                    trap.TotalHelp = 0;
                    return;
                }

                s.PlayAnimation(ANIMATION_FIREFORGET_KNEELFIDGET, 1.0f, 2.0f);
                s.DelayCommand(2.0f, delegate { StallForTime(s, trap, disabler, delay, newLoc); });
            }
        }

        public static void RemoveTrap(CLRScriptBase s, ALFA.Shared.ActiveTrap trap)
        {
            uint triggerAOE = s.GetObjectByTag(trap.Tag, 0);
            uint detectAOE = s.GetObjectByTag(trap.DetectTag, 0);
            uint disarmPlaceable = s.GetObjectByTag(trap.Tag, 1);

            s.DestroyObject(triggerAOE, 0.0f, FALSE);
            s.DestroyObject(detectAOE, 0.0f, FALSE);
            s.DestroyObject(disarmPlaceable, 0.0f, FALSE);
        }

        public enum DisableResult
        {
            Failure,
            Success,
            CriticalFailure
        }
    }
}
