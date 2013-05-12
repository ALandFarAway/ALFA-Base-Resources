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
            uint enterer = s.GetEnteringObject();

            // If one is enough, we don't need to check the trigger's contents.
            if (trap.MinimumToTrigger == 1)
            {
                if (FitsTrapTargetRestriction(s, trap, enterer))
                {
                    Fire(s, trap);
                }
            }
            else
            {
                int validTargets = 0;
                foreach (uint contents in s.GetObjectsInPersistentObject(s.GetObjectByTag(trap.Tag, 0), OBJECT_TYPE_CREATURE, 0))
                {
                    if (FitsTrapTargetRestriction(s, trap, contents))
                    {
                        validTargets++;
                    }
                }
                if (validTargets >= trap.MinimumToTrigger)
                {
                    Fire(s, trap);
                }
            }
            s.SendMessageToPC(s.GetEnteringObject(), String.Format("If I were implemented, {0} would be blasting you right now.", trap.Tag));
        }

        public static void Exit(CLRScriptBase s, ALFA.Shared.ActiveTrap trap)
        {
            s.SendMessageToPC(s.GetEnteringObject(), String.Format("If I were implemented, {0} no longer be blasting you.", trap.Tag));
        }

        public static void Fire(CLRScriptBase s, ALFA.Shared.ActiveTrap trap)
        {
            Fire(s, trap, OBJECT_INVALID);
        }

        public static void Fire(CLRScriptBase s, ALFA.Shared.ActiveTrap trap, uint specialTarget)
        {
            List<uint> targets = new List<uint>();
            if (s.GetIsObjectValid(specialTarget) == TRUE)
            {
                targets.Add(specialTarget);
            }
            foreach (uint contents in s.GetObjectsInPersistentObject(s.GetObjectByTag(trap.Tag, 0), OBJECT_TYPE_CREATURE, 0))
            {
                if (FitsTrapTargetRestriction(s, trap, contents))
                {
                    targets.Add(contents);
                }
            }

            if (targets.Count == 0)
            {
                // Might be that they all left. In any case
                // we have nothing to shoot
                return;
            }
            uint target;
            if (targets.Count == 1)
            {
                target = targets[0];
            }
            else
            {
                target = targets[s.Random(targets.Count)];
            }

            uint caster;
            if (s.GetIsObjectValid(trap.TrapOrigin) == FALSE)
            {
                caster = s.GetObjectByTag(trap.Tag, 0);
            }
            else
            {
                caster = trap.TrapOrigin;
            }

            if (trap.SpellTrap)
            {
                // It's a spell-- guess this is simple.
                s.AssignCommand(caster, delegate { s.ActionCastSpellAtObject(trap.SpellId, target, METAMAGIC_NONE, TRUE, 0, 0, 1); });
            }
            else
            {
                foreach (uint victim in s.GetObjectsInShape(trap.EffectArea, trap.EffectSize, s.GetLocation(target), false, OBJECT_TYPE_CREATURE, s.GetPosition(caster)))
                {
                    // TODO: Larger AOEs could probably use some visual to demonstrate that it's exploding and/or how
                    // big the explosion is.
                    s.ApplyEffectToObject(DURATION_TYPE_INSTANT, GetTrapEffect(s, trap, victim), victim, 0.0f);
                }
            }   
        }

        private static NWEffect GetTrapEffect(CLRScriptBase s, ALFA.Shared.ActiveTrap trap, uint target)
        {
            int damage = 0;
            for (int count = 0; count < trap.DiceNumber; count++)
            {
                damage += s.Random(trap.DiceType) + 1;
            }
            if (trap.SaveDC > -1)
            {
                if (s.ReflexSave(target, trap.SaveDC, SAVING_THROW_TYPE_TRAP, s.GetObjectByTag(trap.Tag, 0)) == TRUE)
                {
                    if (s.GetHasFeat(FEAT_IMPROVED_EVASION, target, TRUE) == TRUE)
                        damage /= 2;
                }
                else
                {
                    if (s.GetHasFeat(FEAT_EVASION, target, TRUE) == TRUE)
                        damage = 0;
                    else damage /= 2;
                }
            }
            else
            {
                if (s.d20(1) + trap.AttackBonus < s.GetAC(target, FALSE))
                    damage = 0;
            }

            NWEffect eVis = s.EffectVisualEffect(VFX_COM_HIT_DIVINE, FALSE);

            List<int> damageTypes = new List<int>();
            if ((trap.DamageType & DAMAGE_TYPE_ACID) == DAMAGE_TYPE_ACID)
            {
                damageTypes.Add(DAMAGE_TYPE_ACID);
                eVis = s.EffectVisualEffect(VFX_COM_HIT_ACID, FALSE);
            }
            if ((trap.DamageType & DAMAGE_TYPE_BLUDGEONING) == DAMAGE_TYPE_BLUDGEONING)
            {
                damageTypes.Add(DAMAGE_TYPE_BLUDGEONING);
                eVis = s.EffectVisualEffect(VFX_COM_BLOOD_CRT_RED, FALSE);
            }
            if ((trap.DamageType & DAMAGE_TYPE_COLD) == DAMAGE_TYPE_COLD)
            {
                damageTypes.Add(DAMAGE_TYPE_COLD);
                eVis = s.EffectVisualEffect(VFX_COM_HIT_FROST, FALSE);
            }
            if ((trap.DamageType & DAMAGE_TYPE_DIVINE) == DAMAGE_TYPE_DIVINE)
            {
                damageTypes.Add(DAMAGE_TYPE_DIVINE);
                eVis = s.EffectVisualEffect(VFX_COM_HIT_DIVINE, FALSE);
            }
            if ((trap.DamageType & DAMAGE_TYPE_ELECTRICAL) == DAMAGE_TYPE_ELECTRICAL)
            {
                damageTypes.Add(DAMAGE_TYPE_ELECTRICAL);
                eVis = s.EffectVisualEffect(VFX_COM_HIT_ELECTRICAL, FALSE);
            }
            if ((trap.DamageType & DAMAGE_TYPE_FIRE) == DAMAGE_TYPE_FIRE)
            {
                damageTypes.Add(DAMAGE_TYPE_FIRE);
                eVis = s.EffectVisualEffect(VFX_COM_HIT_FIRE, FALSE);
            }
            if ((trap.DamageType & DAMAGE_TYPE_MAGICAL) == DAMAGE_TYPE_MAGICAL)
            {
                damageTypes.Add(DAMAGE_TYPE_MAGICAL);
                eVis = s.EffectVisualEffect(VFX_COM_HIT_DIVINE, FALSE);
            }
            if ((trap.DamageType & DAMAGE_TYPE_NEGATIVE) == DAMAGE_TYPE_NEGATIVE)
            {
                damageTypes.Add(DAMAGE_TYPE_NEGATIVE);
                eVis = s.EffectVisualEffect(VFX_COM_HIT_NEGATIVE, FALSE);
            }
            if ((trap.DamageType & DAMAGE_TYPE_PIERCING) == DAMAGE_TYPE_PIERCING)
            {
                damageTypes.Add(DAMAGE_TYPE_PIERCING);
                eVis = s.EffectVisualEffect(VFX_COM_BLOOD_CRT_RED, FALSE);
            }
            if ((trap.DamageType & DAMAGE_TYPE_POSITIVE) == DAMAGE_TYPE_POSITIVE)
            {
                damageTypes.Add(DAMAGE_TYPE_POSITIVE);
                eVis = s.EffectVisualEffect(VFX_COM_HIT_DIVINE, FALSE);
            }
            if ((trap.DamageType & DAMAGE_TYPE_SLASHING) == DAMAGE_TYPE_SLASHING)
            {
                damageTypes.Add(DAMAGE_TYPE_SLASHING);
                eVis = s.EffectVisualEffect(VFX_COM_BLOOD_CRT_RED, FALSE);
            }
            if ((trap.DamageType & DAMAGE_TYPE_SONIC) == DAMAGE_TYPE_SONIC)
            {
                damageTypes.Add(DAMAGE_TYPE_SONIC);
                eVis = s.EffectVisualEffect(VFX_COM_HIT_SONIC, FALSE);
            }

            if (damage == 0)
            {
                return eVis;
            }

            NWEffect eDam = eVis;
            damage /= damageTypes.Count;
            if (damage < 1) damage = 1;
            foreach (int dmgType in damageTypes)
            {
                eDam = s.EffectLinkEffects(eDam, s.EffectDamage(damage, dmgType, DAMAGE_POWER_NORMAL, FALSE));
            }

            return eDam;
        }

        public static bool FitsTrapTargetRestriction(CLRScriptBase s, ALFA.Shared.ActiveTrap trap, uint target)
        {
            if (trap.TargetAlignment != ALIGNMENT_ALL)
            {
                if ((trap.TargetAlignment == ALIGNMENT_CHAOTIC ||
                    trap.TargetAlignment == ALIGNMENT_LAWFUL ||
                    trap.TargetAlignment == ALIGNMENT_NEUTRAL) &&
                    s.GetAlignmentLawChaos(target) != trap.TargetAlignment)
                {
                    return false;
                }
                if ((trap.TargetAlignment == ALIGNMENT_GOOD ||
                    trap.TargetAlignment == ALIGNMENT_EVIL ||
                    trap.TargetAlignment == ALIGNMENT_NEUTRAL) &&
                    s.GetAlignmentGoodEvil(target) != trap.TargetAlignment)
                {
                    return false;
                }
            }
            if (trap.TargetRace != RACIAL_TYPE_ALL)
            {
                if (trap.TargetRace != s.GetRacialType(target))
                {
                    return false;
                }
            }
            return true;
        }
    }
}
