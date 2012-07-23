//::///////////////////////////////////////////////
//:: Invocation: Leaps and Bounds
//:: NW_S0_ILeapsBnd.nss
//:://////////////////////////////////////////////
/*
    Gives a +4 Dexterity bonus and a +4 Tumble Skill
    Bonus for 24 hours.
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: June 19, 2005
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001


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

    if (!ACR_PrecastEvent())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    float fDuration = HoursToSeconds(24);
    int nBonus = GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF);

    //Enter Metamagic conditions
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    effect eBalance = EffectSkillIncrease(SKILL_BALANCE, 6);
    effect eJump    = EffectSkillIncrease(SKILL_JUMP, 6);
    effect eTumble  = EffectSkillIncrease(SKILL_TUMBLE, 6);
    effect eDur = EffectVisualEffect(VFX_DUR_INVOCATION_LEAPS_BOUNDS);
    effect eLink = EffectLinkEffects(eJump, eBalance);
    eLink = EffectLinkEffects(eLink, eTumble);
    eLink = EffectLinkEffects(eLink, eDur);

    RemoveEffectsFromSpell(oTarget, GetSpellId());

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    //Apply the VFX impact and effects
    ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
}