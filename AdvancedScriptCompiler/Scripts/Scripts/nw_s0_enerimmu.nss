//:://////////////////////////////////////////////////////////////////////////
//:: Level 7 Arcane Spell: Energy Immunity
//:: nw_s0_enerimmu.nss
//:: Created By: Brock Heinz - OEI
//:: Created On: 
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
        Energy Immunity (B)
        E-mail from WotC, up-coming Complete Arcane 
        School:		    Abjuration
        Components: 	Verbal, Somatic
        Range:		    Touch
        Target:		    Creature Touched
        Duration:		24 hours

        This provides complete protection from one of the five energy types: 
		acid, cold, electricity, fire, or sonic. They take no damage from the
	    selected elemental type.
        [Art] This is a buff spell. This may need an effect depending on 
		decisions later.

*/
//:://////////////////////////////////////////////////////////////////////////


#include "nwn2_inc_spells"
#include "x2_inc_spellhook" 

void main()
{

    if (!X2PreSpellCastCode())
    {
        // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    //Declare major variables
    object oTarget 	= GetSpellTargetObject();
    int nCasterLvl 	= GetCasterLevel(OBJECT_SELF);
    float fDuration = HoursToSeconds(24);

    //Enter Metamagic conditions
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	effect eImmu1 = EffectDamageResistance(DAMAGE_TYPE_ACID, 9999, 0);
	effect eImmu2 = EffectDamageResistance(DAMAGE_TYPE_COLD, 9999, 0);
	effect eImmu3 = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 9999, 0);
	effect eImmu4 = EffectDamageResistance(DAMAGE_TYPE_FIRE, 9999, 0);
	effect eImmu5 = EffectDamageResistance(DAMAGE_TYPE_SONIC, 9999, 0);
	//effect eHit = EffectVisualEffect(VFX_HIT_SPELL_ABJURATION);	// NWN1 VFX
	effect eHit = EffectVisualEffect( VFX_DUR_SPELL_ENERGY_IMMUNITY );	// NWN2 VFX

	effect eLink = EffectLinkEffects(eImmu1, eImmu2);
	eLink = EffectLinkEffects(eLink, eImmu3);	
	eLink = EffectLinkEffects(eLink, eImmu4);	
	eLink = EffectLinkEffects(eLink, eImmu5);
	eLink = EffectLinkEffects(eLink, eHit);


    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    //Apply the VFX impact and effects
    ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
	//ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);	// NWN1 VFX
}