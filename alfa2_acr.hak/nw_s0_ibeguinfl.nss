//::///////////////////////////////////////////////
//:: Invocation: Beguiling Influence
//:: NW_S0_IBeguInfl.nss
//:://////////////////////////////////////////////
/*
    Gives a +6 bonus to Bluff, Diplomacy & Intimidate
    for 24 hours.
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

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    float fDuration = HoursToSeconds(24);

    //Enter Metamagic conditions
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    effect eBluff = EffectSkillIncrease(SKILL_BLUFF, 6);
    effect eDiplomacy = EffectSkillIncrease(SKILL_DIPLOMACY, 6);
    effect eIntimidate = EffectSkillIncrease(SKILL_INTIMIDATE, 6);
    effect eDur = EffectVisualEffect(VFX_DUR_INVOCATION_BEGUILE_INFLUENCE);
    
    effect eLink = EffectLinkEffects(eBluff, eDiplomacy);
    eLink = EffectLinkEffects(eLink, eIntimidate);
    eLink = EffectLinkEffects(eLink, eDur);

    RemoveEffectsFromSpell(oTarget, GetSpellId());

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    //Apply the VFX impact and effects
    ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
}