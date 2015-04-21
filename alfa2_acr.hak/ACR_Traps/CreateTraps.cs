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
    public class CreateTraps: CLRScriptBase
    {
        public static void GenericDamage(CLRScriptBase script, NWLocation location, TriggerArea triggerArea, int effectArea, float effectSize, int damageType, int diceNumber, int diceType, int saveDC, int attackBonus, int numberOfShots, uint trapOrigin, int targetAlignment, int targetRace, int minimumToTrigger, int detectDC, int disarmDC)
        {
            string tag = uniqueTrapTag();
            string detectTag = tag + detectSuffix();
            
            script.ApplyEffectAtLocation(DURATION_TYPE_PERMANENT,
                script.SupernaturalEffect(script.EffectAreaOfEffect(triggerAreaToAreaOfEffect(triggerArea), "acr_traponenter", "****", "acr_traponexit", tag)),
                location,
                0.0f);

            script.ApplyEffectAtLocation(DURATION_TYPE_PERMANENT,
                script.SupernaturalEffect(script.EffectAreaOfEffect(triggerAreaToDetectArea(triggerArea), "acr_trapdtctenter", "****", "acr_trapdtctexit", detectTag)),
                location,
                0.0f);

            ALFA.Shared.ActiveTrap createdTrap = new ALFA.Shared.ActiveTrap();
            createdTrap.AreaName = script.GetName(script.GetAreaFromLocation(location));
            createdTrap.AttackBonus = attackBonus;
            createdTrap.ChallengeRating = 0.0f;
            createdTrap.DamageType = damageType;
            createdTrap.DetectTag = detectTag;
            createdTrap.DiceNumber = diceNumber;
            createdTrap.DiceType = diceType;
            createdTrap.EffectArea = effectArea;
            createdTrap.EffectSize = effectSize;
            createdTrap.Location = location;
            createdTrap.MinimumToTrigger = minimumToTrigger;
            createdTrap.NumberOfShots = numberOfShots;
            createdTrap.SaveDC = saveDC;
            createdTrap.SpellTrap = false;
            createdTrap.Tag = tag;
            createdTrap.TargetAlignment = targetAlignment;
            createdTrap.TargetRace = targetRace;
            createdTrap.TrapTriggerVFX = triggerAreaToTrapVFX(triggerArea);
            createdTrap.DetectDC = detectDC;
            createdTrap.DisarmDC = disarmDC;
            createdTrap.Detected = false;
            createdTrap.Disabler = 0;
            createdTrap.Helpers = new List<uint>();
            createdTrap.TotalHelp = 0;
            createdTrap.IsFiring = false;
            createdTrap.ConfigureDisplayName();
            createdTrap.CalculateCR();

            createdTrap.TrapOrigin = GetNearestTrapEmitter(script, location);

            ALFA.Shared.Modules.InfoStore.SpawnedTrapDetect.Add(detectTag, createdTrap);
            ALFA.Shared.Modules.InfoStore.SpawnedTrapTriggers.Add(tag, createdTrap);

            script.SetLocalString(script.GetModule(), "ACR_TRAPS_LAST_TAG", tag);
        }

        public static void Spell(CLRScriptBase script, NWLocation location, TriggerArea triggerArea, int spellId, int numberOfShots, uint trapOrigin, int targetAlignment, int targetRace, int minimumToTrigger, int detectDC, int disarmDC)
        {
            string tag = uniqueTrapTag();
            string detectTag = tag + detectSuffix();

            script.ApplyEffectAtLocation(DURATION_TYPE_PERMANENT,
                script.SupernaturalEffect(script.EffectAreaOfEffect(triggerAreaToAreaOfEffect(triggerArea), "acr_traponenter", "****", "acr_traponexit", tag)),
                location,
                0.0f);

            script.ApplyEffectAtLocation(DURATION_TYPE_PERMANENT,
                script.SupernaturalEffect(script.EffectAreaOfEffect(triggerAreaToDetectArea(triggerArea), "acr_trapdtctenter", "****", "acr_trapdtctexit", detectTag)),
                location,
                0.0f);

            ALFA.Shared.ActiveTrap createdTrap = new ALFA.Shared.ActiveTrap();
            createdTrap.AreaName = script.GetName(script.GetAreaFromLocation(location));
            createdTrap.ChallengeRating = 0.0f;
            createdTrap.DetectTag = detectTag;
            createdTrap.Location = location;
            createdTrap.MinimumToTrigger = minimumToTrigger;
            createdTrap.NumberOfShots = numberOfShots;
            createdTrap.SpellTrap = true;
            createdTrap.Tag = tag;
            createdTrap.TargetAlignment = targetAlignment;
            createdTrap.TargetRace = targetRace;
            createdTrap.SpellId = spellId;
            createdTrap.TrapTriggerVFX = triggerAreaToTrapVFX(triggerArea);
            createdTrap.DetectDC = detectDC;
            createdTrap.DisarmDC = disarmDC;
            createdTrap.Detected = false;
            createdTrap.Disabler = 0;
            createdTrap.Helpers = new List<uint>();
            createdTrap.TotalHelp = 0;
            createdTrap.IsFiring = false;
            createdTrap.ConfigureDisplayName();
            createdTrap.CalculateCR();

            createdTrap.TrapOrigin = GetNearestTrapEmitter(script, location);

            ALFA.Shared.Modules.InfoStore.SpawnedTrapDetect.Add(detectTag, createdTrap);
            ALFA.Shared.Modules.InfoStore.SpawnedTrapTriggers.Add(tag, createdTrap);

            script.SetLocalString(script.GetModule(), "ACR_TRAPS_LAST_TAG", tag);
        }

        private static uint GetNearestTrapEmitter(CLRScriptBase script, NWLocation loc)
        {
            float nearestDist = -1.0f;
            uint nearestObject = CLRScriptBase.OBJECT_INVALID;
            Vector3 trapPos = script.GetPositionFromLocation(loc);
            foreach(uint obj in script.GetObjectsInArea(script.GetAreaFromLocation(loc)))
            {
                if(script.GetObjectType(obj) == OBJECT_TYPE_PLACEABLE &&
                   (script.GetTag(obj) == "TRAP_EMITTER" ||
                    script.GetTag(obj) == "TRAP_ORIGIN"))
                {
                    Vector3 emitterPos = script.GetPosition(obj);
                    float newDist = (trapPos.x - emitterPos.x)*(trapPos.x - emitterPos.x)+(trapPos.y - emitterPos.y)*(trapPos.y - emitterPos.y);
                    if(nearestDist < 0 || nearestDist > newDist)
                    {
                        nearestDist = newDist;
                        nearestObject = obj;
                    }
                }
            }
            if(script.GetIsObjectValid(nearestObject) == CLRScriptBase.FALSE || nearestDist > 400.0f) // 20 meters; nearestDist is squared to be cheaper
            {
                nearestObject = CLRScriptBase.OBJECT_INVALID;
            }
            return nearestObject;
        }

        /// <summary>
        /// This method turns a TriggerArea value into a constant that can be used for
        /// the trap trigger.
        /// </summary>
        /// <param name="triggerArea">The TriggerArea to match</param>
        /// <returns>a vfx_persistent.2da line number</returns>
        private static int triggerAreaToAreaOfEffect(TriggerArea triggerArea)
        {
            int areaOfEffect = 81;
            switch (triggerArea)
            {
                case TriggerArea.Small:
                    {
                        areaOfEffect = 81;
                        break;
                    }
                case TriggerArea.Medium:
                    {
                        areaOfEffect = 82;
                        break;
                    }
                case TriggerArea.Large:
                    {
                        areaOfEffect = 83;
                        break;
                    }
                case TriggerArea.Huge:
                    {
                        areaOfEffect = 84;
                        break;
                    }
                case TriggerArea.Gargantuan:
                    {
                        areaOfEffect = 85;
                        break;
                    }
                case TriggerArea.Colossal:
                    {
                        areaOfEffect = 86;
                        break;
                    }
            }
            return areaOfEffect;
        }

        /// <summary>
        /// This method turns a TriggerArea value into a constant that can be used
        /// for a trap's detection area.
        /// </summary>
        /// <param name="triggerArea">The TriggerArea to match</param>
        /// <returns>a vfx_persistent.2da line number</returns>
        private static int triggerAreaToDetectArea(TriggerArea triggerArea)
        {
            int areaOfEffect = 83;
            switch (triggerArea)
            {
                case TriggerArea.Small:
                    {
                        areaOfEffect = 83;
                        break;
                    }
                case TriggerArea.Medium:
                    {
                        areaOfEffect = 84;
                        break;
                    }
                case TriggerArea.Large:
                    {
                        areaOfEffect = 85;
                        break;
                    }
                case TriggerArea.Huge:
                    {
                        areaOfEffect = 87;
                        break;
                    }
                case TriggerArea.Gargantuan:
                    {
                        areaOfEffect = 88;
                        break;
                    }
                case TriggerArea.Colossal:
                    {
                        areaOfEffect = 86;
                        break;
                    }
            }
            return areaOfEffect;
        }

        /// <summary>
        /// This method gets the name of a trap-placement VFX that is appropriate for the trap 
        /// to be spawned.
        /// </summary>
        /// <param name="triggerArea">the TriggerArea to match against</param>
        /// <returns>the name of an appropriate VFX</returns>
        private static string triggerAreaToTrapVFX(TriggerArea triggerArea)
        {
            string visual = "acr_trap_";
            switch (triggerArea)
            {
                case TriggerArea.Small:
                    {
                        visual += "010";
                        break;
                    }
                case TriggerArea.Medium:
                    {
                        visual += "015";
                        break;
                    }
                case TriggerArea.Large:
                    {
                        visual += "020";
                        break;
                    }
                case TriggerArea.Huge:
                    {
                        visual += "025";
                        break;
                    }
                case TriggerArea.Gargantuan:
                    {
                        visual += "030";
                        break;
                    }
                case TriggerArea.Colossal:
                    {
                        visual += "035";
                        break;
                    }
            }
            return visual;
        }


        private static int _currentTrapNumber = 0;

        private static string uniqueTrapTag()
        {
            _currentTrapNumber++;
            return String.Format("trap_{0}", _currentTrapNumber);
        }

        private static string detectSuffix()
        {
            return "_det";
        }
    }
}
