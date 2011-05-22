//::///////////////////////////////////////////////
//:: Spiderskin
//:: [NW_S0_Spidrskin.nss]
//:://////////////////////////////////////////////
/*
    Gives the target +1 Natural AC, +1 Saves vs.
    Poison, +1 Hide Skill bonus.  At 3rd lvl & every
    3 levels after, bonuses are increased by +1 up
    to maximum of +5 (at 12th lvl).
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: June 11, 2005
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 10, 2001
//:: VFX Pass By: Preston W, On: June 22, 2001

/*
bugfix by Kovi 2002.07.23
- dodge bonus was stacking
*/



// JLR - OEI 08/24/05 -- Metamagic changes
#include "nwn2_inc_spells"


#include "nw_i0_spells"
#include "x2_inc_spellhook" 

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-23 by GeorgZ
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
    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
    float fDuration = TurnsToSeconds(nCasterLvl * 10);

    //effect eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SPIDERSKIN, FALSE));

    int nLvlBonus;
    if ( nCasterLvl < 12 ) { nLvlBonus = nCasterLvl / 3; }
    else                   { nLvlBonus = 4; }

    int nACBonus = 1 + nLvlBonus;
    int nPoisonSaveBonus = 1 + nLvlBonus;
    int nHideSkillBonus = 1 + nLvlBonus;

    //Check for metamagic extend
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    //Set the bonuses
    effect eAC = EffectACIncrease(nACBonus, AC_NATURAL_BONUS);
    effect ePoison = EffectSavingThrowIncrease(SAVING_THROW_ALL, nPoisonSaveBonus , SAVING_THROW_TYPE_POISON);
    effect eHide = EffectSkillIncrease(SKILL_HIDE, nHideSkillBonus);
    effect eDur = EffectVisualEffect( VFX_DUR_SPELL_SPIDERSKIN );
    effect eLink = EffectLinkEffects(eAC, ePoison);
    eLink = EffectLinkEffects(eLink, eHide);
    eLink = EffectLinkEffects(eLink, eDur);

    RemoveEffectsFromSpell(oTarget, GetSpellId());

    //Apply the armor bonuses and the VFX impact
    ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}