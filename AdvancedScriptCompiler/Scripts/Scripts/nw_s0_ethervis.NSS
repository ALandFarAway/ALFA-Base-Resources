//::///////////////////////////////////////////////
//:: Ethereal Visage
//:: NW_S0_EtherVis.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Caster gains 20/+3 Damage reduction and is immune
    to 2 level spells and lower.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////

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


	object oTarget = GetSpellTargetObject();
	//effect eVis = EffectVisualEffect(VFX_DUR_ETHEREAL_VISAGE);	// NWN1 VFX
	effect eVis = EffectVisualEffect( VFX_DUR_SPELL_ETHEREAL_VISAGE );	// NWN2 VFX
    //effect eDam = EffectDamageReduction(20, DAMAGE_POWER_PLUS_THREE);	// 3.0 DR rules
    effect eDam = EffectDamageReduction(20, GMATERIAL_METAL_ADAMANTINE, 0, DR_TYPE_GMATERIAL);	// 3.5 DR approximation
    effect eSpell = EffectSpellLevelAbsorption(2);
    effect eConceal = EffectConcealment(25);
    //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);	// NWN1 VFX
	//effect eHit = EffectVisualEffect(VFX_HIT_SPELL_ILLUSION);	// NWN1 VFX

    effect eLink = EffectLinkEffects(eDam, eVis);
    eLink = EffectLinkEffects(eLink, eSpell);
    //eLink = EffectLinkEffects(eLink, eDur);	// NWN1 VFX
    eLink = EffectLinkEffects(eLink, eConceal);

    int nMetaMagic = GetMetaMagicFeat();
    int nDuration = GetCasterLevel(OBJECT_SELF);
    //Enter Metamagic conditions
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ETHEREAL_VISAGE, FALSE));

    if (nMetaMagic == METAMAGIC_EXTEND)
    {
    	nDuration = nDuration *2; //Duration is +100%
    }

	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
	//ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);	// NWN1 VFX
}