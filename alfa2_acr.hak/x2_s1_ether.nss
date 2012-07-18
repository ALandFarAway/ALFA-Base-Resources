//::///////////////////////////////////////////////
//:: Etherealness -> Ethereal Jaunt
//:: x2_s1_ether.nss
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Turns a creature ethereal
    Used by one of the undead shape forms for
    shifter/druids. lasts 5 rounds

	Changed to Ethereal Jaunt:
	Last for 1 round/caster level.
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003/08/01
//:://////////////////////////////////////////////
//:: AFW-OEI 05/30/2006:
//::	Changed to Ethereal Jaunt
//:: RPGplayer1 03/19/2008: Added PreSpellCastHook

#include "x2_inc_spellhook"
#include "acr_travel_i"

void main()
{
    if (!X2PreSpellCastCode())
    {
		// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    //Declare major variables
    object oTarget = GetSpellTargetObject();
    //effect eVis = EffectVisualEffect(VFX_DUR_BLUR);	// NWN1 VFX
    //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);	// NWN1 VFX
    effect eVis = EffectVisualEffect( VFX_DUR_SPELL_ETHEREALNESS );	// NWN2 VFX
    effect eSanc = EffectEthereal();
    effect eLink = EffectLinkEffects(eVis, eSanc);
    //eLink = EffectLinkEffects(eLink, eDur);
    int nDuration = GetCasterLevel(OBJECT_SELF);
    //Enter Metamagic conditions
    int nMetaMagic = GetMetaMagicFeat();
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
    	nDuration = nDuration *2; //Duration is +100%
    }

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    //Apply the VFX impact and effects
    if(!GetHasSpellEffect(GetSpellId(), OBJECT_SELF) && ACR_CanExtradimensionalTravel(OBJECT_SELF))
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
    }

}