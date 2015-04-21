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

            if (trap.IsFiring)
            {
                // Trap's already firing. It'll reset when it runs out of targets.
                return;
            }

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
        }

        public static void Exit(CLRScriptBase s, ALFA.Shared.ActiveTrap trap)
        {
            s.SendMessageToPC(s.GetEnteringObject(), String.Format("This event has no functionality in it. If it has fired, you should write up a ticket about how. Trap ID: {0}", trap.Tag));
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
                trap.IsFiring = false;
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
                    s.ApplyEffectToObject(DURATION_TYPE_INSTANT, GetTrapEffect(s, trap, victim), victim, 0.0f);
                    _doSoloVFX(s, trap, victim);
                }
                _doGroupVFX(s, trap, s.GetLocation(target));
            }

            if (trap.NumberOfShots > -1)
            {
                if (trap.NumberOfShots < 2)
                {
                    TrapDisable.RemoveTrap(s, trap);
                    return;
                }
                else
                {
                    trap.NumberOfShots--;
                }
            }

            trap.IsFiring = true;
            s.DelayCommand(6.0f, delegate { Fire(s, trap); });
        }

        private static void _doGroupVFX(CLRScriptBase s, ALFA.Shared.ActiveTrap trap, NWLocation target)
        {
            if (trap.EffectSize < 2.0f) { return; } // these are probably single-target, and a group VFX would be overkill.
            else
            {
                if((trap.DamageType & DAMAGE_TYPE_DIVINE) == DAMAGE_TYPE_DIVINE)
                {
                    s.ApplyEffectAtLocation(DURATION_TYPE_INSTANT, s.EffectVisualEffect(VFX_FNF_LOS_HOLY_10, FALSE), target, 0.0f);
                }
                else if ((trap.DamageType & DAMAGE_TYPE_FIRE) == DAMAGE_TYPE_FIRE)
                {
                    s.ApplyEffectAtLocation(DURATION_TYPE_INSTANT, s.EffectVisualEffect(VFX_FNF_FIREBALL, FALSE), target, 0.0f);
                }
                else if ((trap.DamageType & DAMAGE_TYPE_MAGICAL) == DAMAGE_TYPE_MAGICAL)
                {
                    s.ApplyEffectAtLocation(DURATION_TYPE_INSTANT, s.EffectVisualEffect(VFX_FNF_LOS_NORMAL_10, FALSE), target, 0.0f);
                }
                else if((trap.DamageType & DAMAGE_TYPE_NEGATIVE) == DAMAGE_TYPE_NEGATIVE)
                {
                    s.ApplyEffectAtLocation(DURATION_TYPE_INSTANT, s.EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD, FALSE), target, 0.0f);
                }
                else if((trap.DamageType & DAMAGE_TYPE_POSITIVE) == DAMAGE_TYPE_POSITIVE)
                {
                    s.ApplyEffectAtLocation(DURATION_TYPE_INSTANT, s.EffectVisualEffect(VFX_FNF_LOS_HOLY_10, FALSE), target, 0.0f);
                }
                else
                {
                    s.ApplyEffectAtLocation(DURATION_TYPE_INSTANT, s.EffectVisualEffect(VFX_FNF_FIREBALL, FALSE), target, 0.0f);
                }
            }
        }

        private static void _doSoloVFX(CLRScriptBase s, ALFA.Shared.ActiveTrap trap, uint target)
        {
            if (trap.EffectSize < 2.0f)
            {
                if (s.GetIsObjectValid(trap.TrapOrigin) == CLRScriptBase.TRUE)
                {
                    if ((trap.DamageType & DAMAGE_TYPE_ACID) == DAMAGE_TYPE_ACID)
                    {
                        s.ApplyEffectToObject(DURATION_TYPE_TEMPORARY, s.EffectBeam(VFX_BEAM_ACID, trap.TrapOrigin, BODY_NODE_CHEST, FALSE), target, 1.0f);
                    }
                    if ((trap.DamageType & DAMAGE_TYPE_BLUDGEONING) == DAMAGE_TYPE_BLUDGEONING)
                    {
                        s.SpawnItemProjectile(trap.TrapOrigin, target, s.GetLocation(trap.TrapOrigin), s.GetLocation(target), BASE_ITEM_SLING, PROJECTILE_PATH_TYPE_HOMING, OVERRIDE_ATTACK_RESULT_HIT_SUCCESSFUL, 0);
                        float fShotDelay = 0.1f;
                        int c = 1;
                        while (c < trap.DiceNumber)
                        {
                            s.DelayCommand(fShotDelay, delegate { s.SpawnItemProjectile(trap.TrapOrigin, target, s.GetLocation(trap.TrapOrigin), s.GetLocation(target), BASE_ITEM_SLING, PROJECTILE_PATH_TYPE_HOMING, OVERRIDE_ATTACK_RESULT_HIT_SUCCESSFUL, 0); });
                            fShotDelay += 0.1f;
                            c++;
                        }
                    }
                    if ((trap.DamageType & DAMAGE_TYPE_COLD) == DAMAGE_TYPE_COLD)
                    {
                        s.ApplyEffectToObject(DURATION_TYPE_TEMPORARY, s.EffectBeam(VFX_BEAM_ICE, trap.TrapOrigin, BODY_NODE_CHEST, FALSE), target, 1.0f);
                    }
                    if ((trap.DamageType & DAMAGE_TYPE_DIVINE) == DAMAGE_TYPE_DIVINE)
                    {
                        s.ApplyEffectToObject(DURATION_TYPE_TEMPORARY, s.EffectBeam(VFX_BEAM_HOLY, trap.TrapOrigin, BODY_NODE_CHEST, FALSE), target, 1.0f);
                    }
                    if ((trap.DamageType & DAMAGE_TYPE_ELECTRICAL) == DAMAGE_TYPE_ELECTRICAL)
                    {
                        s.ApplyEffectToObject(DURATION_TYPE_TEMPORARY, s.EffectBeam(VFX_BEAM_LIGHTNING, trap.TrapOrigin, BODY_NODE_CHEST, FALSE), target, 1.0f);
                    }
                    if ((trap.DamageType & DAMAGE_TYPE_FIRE) == DAMAGE_TYPE_FIRE)
                    {
                        s.ApplyEffectToObject(DURATION_TYPE_TEMPORARY, s.EffectBeam(VFX_BEAM_FIRE, trap.TrapOrigin, BODY_NODE_CHEST, FALSE), target, 1.0f);
                    }
                    if ((trap.DamageType & DAMAGE_TYPE_MAGICAL) == DAMAGE_TYPE_MAGICAL)
                    {
                        s.ApplyEffectToObject(DURATION_TYPE_TEMPORARY, s.EffectBeam(VFX_BEAM_MAGIC, trap.TrapOrigin, BODY_NODE_CHEST, FALSE), target, 1.0f);
                    }
                    if ((trap.DamageType & DAMAGE_TYPE_NEGATIVE) == DAMAGE_TYPE_NEGATIVE)
                    {
                        s.ApplyEffectToObject(DURATION_TYPE_TEMPORARY, s.EffectBeam(VFX_BEAM_EVIL, trap.TrapOrigin, BODY_NODE_CHEST, FALSE), target, 1.0f);
                    }
                    if ((trap.DamageType & DAMAGE_TYPE_PIERCING) == DAMAGE_TYPE_PIERCING)
                    {
                        s.SpawnItemProjectile(trap.TrapOrigin, target, s.GetLocation(trap.TrapOrigin), s.GetLocation(target), BASE_ITEM_DART, PROJECTILE_PATH_TYPE_HOMING, OVERRIDE_ATTACK_RESULT_HIT_SUCCESSFUL, 0);
                        float fShotDelay = 0.1f;
                        int c = 1;
                        while (c < trap.DiceNumber)
                        {
                            s.SpawnItemProjectile(trap.TrapOrigin, target, s.GetLocation(trap.TrapOrigin), s.GetLocation(target), BASE_ITEM_DART, PROJECTILE_PATH_TYPE_HOMING, OVERRIDE_ATTACK_RESULT_HIT_SUCCESSFUL, 0);
                            fShotDelay += 0.1f;
                            c++;
                        }
                    }
                    if ((trap.DamageType & DAMAGE_TYPE_POSITIVE) == DAMAGE_TYPE_POSITIVE)
                    {
                        s.ApplyEffectToObject(DURATION_TYPE_TEMPORARY, s.EffectBeam(VFX_BEAM_HOLY, trap.TrapOrigin, BODY_NODE_CHEST, FALSE), target, 1.0f);
                    }
                    if ((trap.DamageType & DAMAGE_TYPE_SLASHING) == DAMAGE_TYPE_SLASHING)
                    {
                        s.SpawnItemProjectile(trap.TrapOrigin, target, s.GetLocation(trap.TrapOrigin), s.GetLocation(target), BASE_ITEM_THROWINGAXE, PROJECTILE_PATH_TYPE_HOMING, OVERRIDE_ATTACK_RESULT_HIT_SUCCESSFUL, 0);
                        float fShotDelay = 0.1f;
                        int c = 1;
                        while (c < trap.DiceNumber)
                        {
                            s.SpawnItemProjectile(trap.TrapOrigin, target, s.GetLocation(trap.TrapOrigin), s.GetLocation(target), BASE_ITEM_THROWINGAXE, PROJECTILE_PATH_TYPE_HOMING, OVERRIDE_ATTACK_RESULT_HIT_SUCCESSFUL, 0);
                            fShotDelay += 0.1f;
                            c++;
                        }
                    }
                    if ((trap.DamageType & DAMAGE_TYPE_SONIC) == DAMAGE_TYPE_SONIC)
                    {
                        s.ApplyEffectToObject(DURATION_TYPE_TEMPORARY, s.EffectBeam(VFX_BEAM_SONIC, trap.TrapOrigin, BODY_NODE_CHEST, FALSE), target, 1.0f);
                    }
                }
                else
                {
                    // These are pretty much single-target effects.
                    if ((trap.DamageType & DAMAGE_TYPE_ACID) == DAMAGE_TYPE_ACID)
                    {
                        s.ApplyEffectToObject(DURATION_TYPE_INSTANT, s.EffectVisualEffect(VFX_IMP_ACID_S, FALSE), target, 0.0f);
                    }
                    if ((trap.DamageType & DAMAGE_TYPE_BLUDGEONING) == DAMAGE_TYPE_BLUDGEONING)
                    {
                        s.ApplyEffectToObject(DURATION_TYPE_INSTANT, s.EffectVisualEffect(VFX_COM_BLOOD_CRT_RED, FALSE), target, 0.0f);
                    }
                    if ((trap.DamageType & DAMAGE_TYPE_COLD) == DAMAGE_TYPE_COLD)
                    {
                        s.ApplyEffectToObject(DURATION_TYPE_INSTANT, s.EffectVisualEffect(VFX_IMP_FROST_L, FALSE), target, 0.0f);
                    }
                    if ((trap.DamageType & DAMAGE_TYPE_DIVINE) == DAMAGE_TYPE_DIVINE)
                    {
                        s.ApplyEffectToObject(DURATION_TYPE_INSTANT, s.EffectVisualEffect(VFX_COM_HIT_DIVINE, FALSE), target, 0.0f);
                    }
                    if ((trap.DamageType & DAMAGE_TYPE_ELECTRICAL) == DAMAGE_TYPE_ELECTRICAL)
                    {
                        s.ApplyEffectToObject(DURATION_TYPE_INSTANT, s.EffectVisualEffect(VFX_IMP_LIGHTNING_S, FALSE), target, 0.0f);
                    }
                    if ((trap.DamageType & DAMAGE_TYPE_FIRE) == DAMAGE_TYPE_FIRE)
                    {
                        s.ApplyEffectToObject(DURATION_TYPE_INSTANT, s.EffectVisualEffect(VFX_IMP_FLAME_S, FALSE), target, 0.0f);
                    }
                    if ((trap.DamageType & DAMAGE_TYPE_MAGICAL) == DAMAGE_TYPE_MAGICAL)
                    {
                        s.ApplyEffectToObject(DURATION_TYPE_INSTANT, s.EffectVisualEffect(VFX_IMP_MAGBLUE, FALSE), target, 0.0f);
                    }
                    if ((trap.DamageType & DAMAGE_TYPE_NEGATIVE) == DAMAGE_TYPE_NEGATIVE)
                    {
                        s.ApplyEffectToObject(DURATION_TYPE_INSTANT, s.EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY, FALSE), target, 0.0f);
                    }
                    if ((trap.DamageType & DAMAGE_TYPE_PIERCING) == DAMAGE_TYPE_PIERCING)
                    {
                        s.ApplyEffectToObject(DURATION_TYPE_INSTANT, s.EffectVisualEffect(VFX_IMP_SPIKE_TRAP, FALSE), target, 0.0f);
                    }
                    if ((trap.DamageType & DAMAGE_TYPE_POSITIVE) == DAMAGE_TYPE_POSITIVE)
                    {
                        s.ApplyEffectToObject(DURATION_TYPE_INSTANT, s.EffectVisualEffect(VFX_IMP_SUNSTRIKE, FALSE), target, 0.0f);
                    }
                    if ((trap.DamageType & DAMAGE_TYPE_SLASHING) == DAMAGE_TYPE_SLASHING)
                    {
                        s.ApplyEffectToObject(DURATION_TYPE_INSTANT, s.EffectVisualEffect(VFX_COM_BLOOD_CRT_RED, FALSE), target, 0.0f);
                    }
                    if ((trap.DamageType & DAMAGE_TYPE_SONIC) == DAMAGE_TYPE_SONIC)
                    {
                        s.ApplyEffectToObject(DURATION_TYPE_INSTANT, s.EffectVisualEffect(VFX_IMP_SONIC, FALSE), target, 0.0f);
                    }
                }
            }
            else { return; }
        }

        private static bool GetTrapVFX(CLRScriptBase s, ALFA.Shared.ActiveTrap trap, uint source, out NWEffect vfx)
        {
            // TODO: This should be refined-- we could plausibly divide out things that make attack
            // rolls to shoot beams, and find thins other than fireballs to be our explosions.
            if (trap.EffectSize < 2.0f)
            {
                // These are pretty much single-target effects.
                if ((trap.DamageType & DAMAGE_TYPE_ACID) == DAMAGE_TYPE_ACID)
                {
                    vfx = s.EffectVisualEffect(VFX_IMP_ACID_S, FALSE);
                    return true;
                }
                if ((trap.DamageType & DAMAGE_TYPE_BLUDGEONING) == DAMAGE_TYPE_BLUDGEONING)
                {
                    vfx = s.EffectVisualEffect(VFX_COM_BLOOD_CRT_RED, FALSE);
                    return true;
                }
                if ((trap.DamageType & DAMAGE_TYPE_COLD) == DAMAGE_TYPE_COLD)
                {
                    vfx = s.EffectVisualEffect(VFX_IMP_FROST_L, FALSE);
                    return false;
                }
                if ((trap.DamageType & DAMAGE_TYPE_DIVINE) == DAMAGE_TYPE_DIVINE)
                {
                    vfx = s.EffectVisualEffect(VFX_COM_HIT_DIVINE, FALSE);
                    return true;
                }
                if ((trap.DamageType & DAMAGE_TYPE_ELECTRICAL) == DAMAGE_TYPE_ELECTRICAL)
                {
                    vfx = s.EffectVisualEffect(VFX_IMP_LIGHTNING_S, FALSE);
                    return true;
                }
                if ((trap.DamageType & DAMAGE_TYPE_FIRE) == DAMAGE_TYPE_FIRE)
                {
                    vfx = s.EffectVisualEffect(VFX_IMP_FLAME_S, FALSE);
                    return true;
                }
                if ((trap.DamageType & DAMAGE_TYPE_MAGICAL) == DAMAGE_TYPE_MAGICAL)
                {
                    vfx = s.EffectVisualEffect(VFX_IMP_MAGBLUE, FALSE);
                    return true;
                }
                if ((trap.DamageType & DAMAGE_TYPE_NEGATIVE) == DAMAGE_TYPE_NEGATIVE)
                {
                    vfx = s.EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY, FALSE);
                    return true;
                }
                if ((trap.DamageType & DAMAGE_TYPE_PIERCING) == DAMAGE_TYPE_PIERCING)
                {
                    vfx = s.EffectVisualEffect(VFX_IMP_SPIKE_TRAP, FALSE);
                    return true;
                }
                if ((trap.DamageType & DAMAGE_TYPE_POSITIVE) == DAMAGE_TYPE_POSITIVE)
                {
                    vfx = s.EffectVisualEffect(VFX_IMP_SUNSTRIKE, FALSE);
                    return true;
                }
                if ((trap.DamageType & DAMAGE_TYPE_SLASHING) == DAMAGE_TYPE_SLASHING)
                {
                    vfx = s.EffectVisualEffect(VFX_COM_BLOOD_CRT_RED, FALSE);
                    return true;
                }
                if ((trap.DamageType & DAMAGE_TYPE_SONIC) == DAMAGE_TYPE_SONIC)
                {
                    vfx = s.EffectVisualEffect(VFX_IMP_SONIC, FALSE);
                    return true;
                }
            }
            else
            {
                // these ones blow up.
                vfx = s.EffectVisualEffect(VFX_FNF_FIREBALL, FALSE);
                return true;
            }

            // Oh well, guess it blows up then.
            vfx = s.EffectVisualEffect(VFX_FNF_FIREBALL, FALSE);
            return true;
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
                if (s.ReflexSave(target, trap.SaveDC, SAVING_THROW_TYPE_TRAP, s.GetObjectByTag(trap.Tag, 0)) != TRUE)
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
                int roll = new Random().Next(20) + 1;
                int final = roll + trap.AttackBonus;
                s.SendMessageToPC(target, "Trap: " + roll + " + " + trap.AttackBonus + " = " + final);
                if (final < s.GetAC(target, FALSE) && roll != 20)
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
            if (s.GetIsDead(target, FALSE) == TRUE)
            {
                return false;
            }
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
