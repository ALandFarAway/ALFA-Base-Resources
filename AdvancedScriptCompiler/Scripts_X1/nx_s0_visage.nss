//::///////////////////////////////////////////////
//:: Visage of the Deity
//:: nx_s0_visage.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
 	Components: V, S
	Range: Personal
	Duration: 1 round/level
	 
	Caster gains:
	+4 CHA (enhancement bonus; doesn't stack with similar)
	 
	If Good:
	Resistance 10 to acid, cold, electricity
	 
	If Neutral (with respect to good & evil):
	Resistance 15 to acid and electricity
	 
	If Evil:
	Resistance 10 to cold and fire
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: 12.12.2006
//:://////////////////////////////////////////////
//:: AFW-OEI 06/28/2007: Add Lesser Visage aura VFX.
//:: RPGplayer1 02/25/2009: Changed SpellCastAt event to harmless, so it doesn't drop invisibility

#include "nw_i0_spells"
#include "x2_inc_spellhook" 
#include "nwn2_inc_metmag"


void main()
{
    /*
      Spellcast Hook Code
      Added 2003-07-07 by Georg Zoeller
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

	object		oCaster		=	OBJECT_SELF;
	object		oTarget		=	GetSpellTargetObject();
	effect		eCha		=	EffectAbilityIncrease(ABILITY_CHARISMA, 4);
	effect		eAcid;
	effect		eCold;
	effect		eElec;
	effect		eFire;
	effect		eGood;
	effect		eEvil;
	effect		eNeut;
	effect		eGoodVis	=	EffectVisualEffect(VFX_HIT_SPELL_HOLY);
	effect		eEvilVis	=	EffectVisualEffect(VFX_HIT_SPELL_EVIL);
	effect		eNeutVis	=	EffectVisualEffect(VFX_HIT_AOE_TRANSMUTATION);
	effect		eDurVis		= 	EffectVisualEffect(VFX_DUR_SPELL_LESSER_VISAGE);
	float		fDuration	=	RoundsToSeconds(GetCasterLevel(oCaster));
	int			nDurType	=	ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	fDuration	=	ApplyMetamagicDurationMods(fDuration);
	
	if (GetIsObjectValid(oCaster))
	{
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 1040, FALSE));
		if (GetAlignmentGoodEvil(oCaster) == ALIGNMENT_GOOD)
		{
			eAcid	=	EffectDamageResistance(DAMAGE_TYPE_ACID, 10);
			eCold	=	EffectDamageResistance(DAMAGE_TYPE_COLD, 10);
			eElec	=	EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 10);
			
			eGood	=	EffectLinkEffects(eAcid, eCold);
			eGood	=	EffectLinkEffects(eGood, eElec);
			eGood	=	EffectLinkEffects(eGood, eCha);
			eGood 	=   EffectLinkEffects(eGood, eDurVis);
			
			ApplyEffectToObject(nDurType, eGood, oCaster, fDuration);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eGoodVis, oCaster);
		}
		else if (GetAlignmentGoodEvil(oCaster) == ALIGNMENT_EVIL)
		{
		 	eCold	=	EffectDamageResistance(DAMAGE_TYPE_COLD, 10);
			eFire	=	EffectDamageResistance(DAMAGE_TYPE_FIRE, 10);
			
			eEvil	=	EffectLinkEffects(eCold, eFire);
			eEvil	=	EffectLinkEffects(eEvil, eCha);
			eEvil	=	EffectLinkEffects(eEvil, eDurVis);
			
			ApplyEffectToObject(nDurType, eEvil, oCaster, fDuration);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eEvilVis, oCaster);
		}
		else
		{
			eAcid	=	EffectDamageResistance(DAMAGE_TYPE_ACID, 15);
			eElec	=	EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 15);
			
			eNeut	=	EffectLinkEffects(eAcid, eElec);
			eNeut	=	EffectLinkEffects(eNeut, eCha);
			eNeut	= 	EffectLinkEffects(eNeut, eDurVis);
			
			ApplyEffectToObject(nDurType, eNeut, oCaster, fDuration);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eNeutVis, oCaster);
		}
	}
}
	