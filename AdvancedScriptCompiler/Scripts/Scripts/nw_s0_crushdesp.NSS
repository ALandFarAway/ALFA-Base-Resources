//::///////////////////////////////////////////////
//:: [Crushing Despair]
//:: [NW_S0_CrushDesp.nss]
//:://////////////////////////////////////////////
/*
    All affected creatures in range suffer -2
    penalties to attack rolls, saving throws,
    ability checks, skill checks, and weapon
    dmg rolls.
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: June 12, 2005
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001
//:: Modified March 2003 to give -2 attack and damage penalties

// JLR - OEI 08/24/05 -- Metamagic changes
#include "nwn2_inc_spells"

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    object oOrigTgt = oTarget;
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetSpellTargetLocation();
    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
    float fDuration = TurnsToSeconds(nCasterLvl);
    int nNumTargets = (nCasterLvl / 3) + 1;

    // Do Metamagic Checks
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if ((GetObjectType(oTarget) == OBJECT_TYPE_CREATURE) && (oTarget != OBJECT_SELF))
        {
            // * added rep check April 2003
			// Removed rep check Spetember 2006 cause that ain't how we roll
            if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) == TRUE)
            {
                nNumTargets = nNumTargets - 1;

                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

                //Make SR check
                if(!MyResistSpell(OBJECT_SELF, oTarget))
                {
                    //Make Will save versus fear
                    if(!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS))
                    {
                        effect eSave = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL);
						//effect eHit = EffectVisualEffect(VFX_HIT_SPELL_ENCHANTMENT);	// NWN1 VFX
						effect eHit = EffectVisualEffect( VFX_DUR_SPELL_CRUSHING_DESP );	// NWN2 VFX
// Ability & Skill ***CHECKS***!!!
                        //effect eStr = EffectAbilityDecrease(ABILITY_STRENGTH, 2);
                        //effect eDex = EffectAbilityDecrease(ABILITY_DEXTERITY, 2);
                        //effect eCon = EffectAbilityDecrease(ABILITY_CONSTITUTION, 2);
                        //effect eInt = EffectAbilityDecrease(ABILITY_INTELLIGENCE, 2);
                        //effect eWis = EffectAbilityDecrease(ABILITY_WISDOM, 2);
                        //effect eCha = EffectAbilityDecrease(ABILITY_CHARISMA, 2);
//Ability scores are no longer reduced by two.  This was an incorrect interpretation of the rules. //PKM OEI 11.02.06						

                        effect eSkill = EffectSkillDecrease(SKILL_ALL_SKILLS, 2);

                        effect eDamagePenalty = EffectDamageDecrease(2);
                        effect eAttackPenalty = EffectAttackDecrease(2);
                        //effect eLink2 = EffectLinkEffects(eSkill, eStr );
                        //eLink2 = EffectLinkEffects(eLink2, eDex );
                        //eLink2 = EffectLinkEffects(eLink2, eCon );
                        //eLink2 = EffectLinkEffects(eLink2, eInt );
                        //eLink2 = EffectLinkEffects(eLink2, eWis );
                        //eLink2 = EffectLinkEffects(eLink2, eCha );
                        //eLink2 = EffectLinkEffects(eLink2, eDamagePenalty);
                        //eLink2 = EffectLinkEffects(eLink2, eAttackPenalty);
						effect eLink2 = EffectLinkEffects(eDamagePenalty, eAttackPenalty);
						eLink2 = EffectLinkEffects(eLink2, eSave);
						eLink2 = EffectLinkEffects(eLink2, eSkill);

                        if (!GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, OBJECT_SELF))
                        {
                        //Apply linked effects and VFX impact
                        //ApplyEffectToObject(nDurType, eSave, oTarget, fDuration);
                        ApplyEffectToObject(nDurType, eLink2, oTarget, fDuration);
						ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
                        }
                    }
                }
            }
        }

        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}