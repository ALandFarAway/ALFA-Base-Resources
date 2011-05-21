//::///////////////////////////////////////////////
//:: [Cause Fear]
//:: [NW_S0_CauseFear.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Will save or the target is scared for 1d4 rounds.
//:: NOTE THIS SPELL IS EQUAL TO **CAUSE FEAR** NOT SCARE.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 30, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001
//:: Modified March 2003 to give -2 attack and damage penalties

// (Updated JLR - OEI 07/05/05 NWN2 3.5)

// JLR - OEI 08/23/05 -- Metamagic changes

// Modified by Riotnrrd for ALFA 1/7/2009
// Added canon fear effect (-2 atk, saves, skills)
// If make save, still shaken for 1 round

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
	effect eDur = EffectVisualEffect(VFX_DUR_SPELL_CAUSE_FEAR);
	effect eMind = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	effect eAttackPenalty = EffectAttackDecrease(2);
	effect eSavePenalty = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_FEAR);
	effect eSkillPenalty = EffectSkillDecrease(SKILL_ALL_SKILLS, 2);
	effect eShaken = EffectLinkEffects(eMind, eDur);
	eShaken = EffectLinkEffects(eShaken, eAttackPenalty);
	eShaken = EffectLinkEffects(eShaken, eSavePenalty);
	eShaken = EffectLinkEffects(eShaken, eSkillPenalty);
	effect eFrightened = EffectLinkEffects(eShaken, EffectFrightened());
	
    int nDur = d4();

    //Do metamagic checks
    nDur = ApplyMetamagicVariableMods(nDur, 4);
    float fDuration = RoundsToSeconds(nDur);
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    //Check the Hit Dice of the creature
    if ((GetHitDice(oTarget) < 6) && GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
    {
        // * added rep check April 2003
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) == TRUE)
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CAUSE_FEAR));
            //Make SR check
            if(!MyResistSpell(OBJECT_SELF, oTarget))
            {
                //Make Will save versus fear
                if(!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FEAR))
                {
					ApplyEffectToObject(nDurType, eFrightened, oTarget, fDuration);                 
                }
				else { // is still shaken for 1 round
					ApplyEffectToObject(nDurType, eShaken, oTarget, 1.0);	
				}
            }
        }
    }
}