//::///////////////////////////////////////////////
//:: Endure Elements
//:: NW_S0_EndEle
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Offers 10 points of elemental resistance.  If 20
    points of a single elemental type is done to the
    protected creature the spell fades
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 23, 2001
//:://////////////////////////////////////////////


// JLR - OEI 08/23/05 -- Permanency & Metamagic changes
#include "nwn2_inc_spells"


#include "nw_i0_spells"
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
    float fDuration = HoursToSeconds(24); //GetCasterLevel(OBJECT_SELF);
    int nAmount = 20;
    int nResistance = 10;
    effect eCold = EffectDamageResistance(DAMAGE_TYPE_COLD, nResistance, nAmount);
    effect eFire = EffectDamageResistance(DAMAGE_TYPE_FIRE, nResistance, nAmount);
    effect eAcid = EffectDamageResistance(DAMAGE_TYPE_ACID, nResistance, nAmount);
    effect eSonic = EffectDamageResistance(DAMAGE_TYPE_SONIC, nResistance, nAmount);
    effect eElec = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, nResistance, nAmount);
    //effect eDur = EffectVisualEffect(VFX_DUR_PROTECTION_ELEMENTS);	// no longer using NWN1 VFX
    effect eDur = EffectVisualEffect( VFX_DUR_SPELL_ENDURE_ELEMENTS );	// uses NWN2 VFX
	//effect eVis = EffectVisualEffect(VFX_IMP_ELEMENTAL_PROTECTION);	// no longer using NWN1 VFX
    //effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);	// no longer using NWN1 VFX

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ENDURE_ELEMENTS, FALSE));

    //Link Effects
    effect eLink = EffectLinkEffects(eCold, eFire);
    eLink = EffectLinkEffects(eLink, eAcid);
    eLink = EffectLinkEffects(eLink, eSonic);
    eLink = EffectLinkEffects(eLink, eElec);
    eLink = EffectLinkEffects(eLink, eDur);
    //eLink = EffectLinkEffects(eLink, eDur2); 	// no longer using NWN1 VFX


    //Enter Metamagic conditions
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    RemoveEffectsFromSpell(oTarget, GetSpellId());
    RemovePermanencySpells(oTarget);

    //Apply the VFX impact and effects
    ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);	// no longer using NWN1 VFX
}