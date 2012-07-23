//::///////////////////////////////////////////////
//:: [Scare]
//:: [NW_S0_Scare.nss]
//:://////////////////////////////////////////////
/*
    Casts "Cause Fear" on multiple critters 
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: June 11, 2005
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001
//:: Modified March 2003 to give -2 attack and damage penalties

// JLR - OEI 08/23/05 -- Metamagic changes

// Modified by Riotnrrd for ALFA 1/7/2009
// Simplified code
// On failed save, canon fear effect (-2 atk, -2 saves, -2 skills, flee)
// On successful save, still shaken for 1 round (-2 atks, -2 saves, -2 skills)
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

    if (!ACR_PrecastEvent())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    object oOrigTgt = oTarget;
    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
    float fDuration = RoundsToSeconds(nCasterLvl);
    int nNumTargets = (nCasterLvl / 3);
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetSpellTargetLocation();
	
	effect eMind = EffectVisualEffect(VFX_DUR_SPELL_FEAR);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	effect eAttackPenalty = EffectAttackDecrease(2);
	effect eSavePenalty = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_FEAR);
	effect eSkillPenalty = EffectSkillDecrease(SKILL_ALL_SKILLS, 2);
	effect eShaken = EffectLinkEffects(eMind, eDur);
	eShaken = EffectLinkEffects(eShaken, eAttackPenalty);
	eShaken = EffectLinkEffects(eShaken, eSavePenalty);
	eShaken = EffectLinkEffects(eShaken, eSkillPenalty);
	effect eFrightened = EffectLinkEffects(eShaken, EffectFrightened());

    //Do metamagic checks
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget) && (nNumTargets > 0))
    {
        //Check the Hit Dice of the creature
        if (GetHitDice(oTarget) < 6)
        {
            // * added rep check April 2003
            if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) == TRUE)
            {
                nNumTargets = nNumTargets - 1;

                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SCARE));
                //Make SR check
                if(!MyResistSpell(OBJECT_SELF, oTarget))
                {
                    //Make Will save versus fear
                    if(!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FEAR))
                    {
                        ApplyEffectToObject(nDurType, eFrightened, oTarget, fDuration);
                    }
					else ApplyEffectToObject(nDurType, eShaken, oTarget, fDuration);
                }
            }
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}