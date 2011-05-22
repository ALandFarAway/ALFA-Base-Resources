//::///////////////////////////////////////////////
//:: Clairaudience / Clairvoyance
//:: NW_S0_ClairAdVo.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Grants the target creature a bonus of +10 to
    spot and listen checks
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 21, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001

// JLR - OEI 08/24/05 -- Metamagic changes
// BDF - OEI 6/26/06 -- NWN2 VFX updates
#include "nwn2_inc_spells"


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
    effect eSpot = EffectSkillIncrease(SKILL_SPOT, 10);
    effect eListen = EffectSkillIncrease(SKILL_LISTEN, 10);
    //effect eVis = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);	// NWN1 VFX
    effect eVis = EffectVisualEffect( VFX_DUR_SPELL_CLAIRAUD );	// NWN2 VFX
    //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);	// NWN1 VFX

    effect eLink = EffectLinkEffects(eSpot, eListen);
    eLink = EffectLinkEffects(eLink, eVis);
    //eLink = EffectLinkEffects(eLink, eDur);	// NWN1 VFX

    object oTarget = GetSpellTargetObject();
    float fDuration = RoundsToSeconds(GetCasterLevel(OBJECT_SELF));
    
    //Meta-Magic checks
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    //Make sure the spell has not already been applied
    if(!GetHasSpellEffect(SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE, oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE, FALSE));

         //Apply linked and VFX effects
         ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
    }
}