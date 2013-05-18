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

namespace ACR_Traps
{
    public partial class ACR_Traps : CLRScriptBase, IGeneratedScriptProgram
    {
        public ACR_Traps([In] NWScriptJITIntrinsics Intrinsics, [In] INWScriptProgram Host)
        {
            InitScript(Intrinsics, Host);
        }

        private ACR_Traps([In] ACR_Traps Other)
        {
            InitScript(Other);

            LoadScriptGlobals(Other.SaveScriptGlobals());
        }

        public static Type[] ScriptParameterTypes =
        { typeof(int), typeof(float), typeof(float), typeof(float), typeof(uint), typeof(int), typeof(int), typeof(float), typeof(int), typeof(int), typeof(int), typeof(int), typeof(int), typeof(int), typeof(uint), typeof(int), typeof(int), typeof(int), typeof(int), typeof(int), typeof(string) };

        public Int32 ScriptMain([In] object[] ScriptParameters, [In] Int32 DefaultReturnCode)
        {
            int Value = (int)ScriptParameters[0]; // ScriptParameterTypes[0] is typeof(int)

            TrapEvent currentEvent = (TrapEvent)ScriptParameters[0];
            
            switch (currentEvent)
            {
                case TrapEvent.CreateGeneric:
                    {
                        NWLocation loc = Location((uint)ScriptParameters[4], Vector((float)ScriptParameters[1], (float)ScriptParameters[2], (float)ScriptParameters[3]), 0.0f);
                        string resRef = (string)ScriptParameters[20];
                        if (resRef == "")
                        {
                            TriggerArea triggerArea = (TriggerArea)ScriptParameters[5];
                            int effectArea = (int)ScriptParameters[6];
                            float effectSize = (float)ScriptParameters[7];
                            int damageType = (int)ScriptParameters[8];
                            int diceNumber = (int)ScriptParameters[9];
                            int diceType = (int)ScriptParameters[10];
                            int saveDC = (int)ScriptParameters[11];
                            int attackBonus = (int)ScriptParameters[12];
                            int numberOfShots = (int)ScriptParameters[13];
                            uint trapOrigin = (uint)ScriptParameters[14];
                            int targetAlignment = (int)ScriptParameters[15];
                            int targetRace = (int)ScriptParameters[16];
                            int minimumToTrigger = (int)ScriptParameters[17];
                            int detectDC = (int)ScriptParameters[18];
                            int disarmDC = (int)ScriptParameters[19];
                            CreateTraps.GenericDamage(this, loc, triggerArea, effectArea, effectSize, damageType, diceNumber, diceType, saveDC, attackBonus, numberOfShots, trapOrigin, targetAlignment, targetRace, minimumToTrigger, detectDC, disarmDC);
                            break;
                        }
                        else
                        {
                            ALFA.Shared.TrapResource trapToSpawn = ALFA.Shared.Modules.InfoStore.ModuleTraps[(string)ScriptParameters[20]];
                            if (trapToSpawn.SpellTrap)
                            {
                                CreateTraps.Spell(this, loc, (TriggerArea)trapToSpawn.TriggerArea, trapToSpawn.SpellId, trapToSpawn.NumberOfShots, trapToSpawn.TrapOrigin, trapToSpawn.TargetAlignment, trapToSpawn.TargetRace, trapToSpawn.MinimumToTrigger, trapToSpawn.DetectDC, trapToSpawn.DisarmDC);
                            }
                            else
                            {
                                CreateTraps.GenericDamage(this, loc, (TriggerArea)trapToSpawn.TriggerArea, trapToSpawn.EffectArea, trapToSpawn.EffectSize, trapToSpawn.DamageType, trapToSpawn.DiceNumber, trapToSpawn.DiceType, trapToSpawn.SaveDC, trapToSpawn.AttackBonus, trapToSpawn.NumberOfShots, trapToSpawn.TrapOrigin, trapToSpawn.TargetAlignment, trapToSpawn.TargetRace, trapToSpawn.MinimumToTrigger, trapToSpawn.DetectDC, trapToSpawn.DisarmDC);
                            }
                        }
                        break;
                    }
                case TrapEvent.CreateSpell:
                    {
                        NWLocation loc = Location((uint)ScriptParameters[4], Vector((float)ScriptParameters[1], (float)ScriptParameters[2], (float)ScriptParameters[3]), 0.0f);
                        TriggerArea triggerArea = (TriggerArea)ScriptParameters[5];
                        int spellId = (int)ScriptParameters[8];
                        int numberOfShots = (int)ScriptParameters[13];
                        uint trapOrigin = (uint)ScriptParameters[14];
                        int targetAlignment = (int)ScriptParameters[15];
                        int targetRace = (int)ScriptParameters[16];
                        int minimumToTrigger = (int)ScriptParameters[17];
                        int detectDC = (int)ScriptParameters[18];
                        int disarmDC = (int)ScriptParameters[19];
                        CreateTraps.Spell(this, loc, triggerArea, spellId, numberOfShots, trapOrigin, targetAlignment, targetRace, minimumToTrigger, detectDC, disarmDC);
                        break;
                    }
                case TrapEvent.DetectEnter:
                    {
                        string trapTag = GetTag(OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.SpawnedTrapDetect.Keys.Contains(trapTag))
                        {
                            TrapDetect.Enter(this, ALFA.Shared.Modules.InfoStore.SpawnedTrapDetect[trapTag]);
                        }
                        else
                        {
                            uint enteringObject = GetEnteringObject();
                            SendMessageToPC(enteringObject, String.Format("Error: This appears to be a trap detection trigger, but I can not find any trap named {0}", trapTag));
                        }
                        break;
                    }
                case TrapEvent.DetectExit:
                    {
                        string trapTag = GetTag(OBJECT_SELF);
                        uint enteringObject = GetEnteringObject();
                        if (ALFA.Shared.Modules.InfoStore.SpawnedTrapDetect.Keys.Contains(trapTag))
                        {
                            TrapDetect.Exit(this, ALFA.Shared.Modules.InfoStore.SpawnedTrapDetect[trapTag]);
                        }                     
                        break;
                    }
                case TrapEvent.TriggerEnter:
                    {
                        string trapTag = GetTag(OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.SpawnedTrapTriggers.Keys.Contains(trapTag))
                        {
                            TrapTrigger.Enter(this, ALFA.Shared.Modules.InfoStore.SpawnedTrapTriggers[trapTag]);
                        }
                        else
                        {
                            uint enteringObject = GetEnteringObject();
                            SendMessageToPC(enteringObject, String.Format("Error: This appears to be a trap firing trigger, but I can not find any trap named {0}", trapTag));
                        }
                        break;
                    }
                case TrapEvent.TriggerExit:
                    {
                        string trapTag = GetTag(OBJECT_SELF);
                        uint enteringObject = GetEnteringObject();
                        if (ALFA.Shared.Modules.InfoStore.SpawnedTrapTriggers.Keys.Contains(trapTag))
                        {
                            TrapTrigger.Exit(this, ALFA.Shared.Modules.InfoStore.SpawnedTrapTriggers[trapTag]);
                        }
                        break;
                    }
                case TrapEvent.TrapDisarm:
                    {
                        string trapTag = GetTag(OBJECT_SELF);
                        trapTag = trapTag.Substring(0, trapTag.Length - 1);
                        uint disabler = GetLastUsedBy();
                        if (ALFA.Shared.Modules.InfoStore.SpawnedTrapTriggers.Keys.Contains(trapTag))
                        {
                            TrapDisable.Disable(this, ALFA.Shared.Modules.InfoStore.SpawnedTrapTriggers[trapTag], disabler);
                        }
                        break;
                    }
            }

            return 0;
        }

    }
}
