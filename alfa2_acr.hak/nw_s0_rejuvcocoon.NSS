//::///////////////////////////////////////////////
//:: Rejuvination Cocoon
//:: nw_s0_rejuvcocoon.nss
//:: Copyright (c) 2006 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	When you cast the spell, the rejuvination cocoon forms
	around the subject.  While inside the cocoon, the subject
	cannot move or act in any way.
	
	The cocoon heals the subject every second, restoring a 
	number of hit points equal to the caster's level (maximum
	of 15/second).  It also immediately purges the subject of 
	poison and disease effects, and makes the subject immune to 
	similar effects for the duration.
	
	While enveloped in the cocoon, the subject has DR 10/-.  Once
	the damage reduction has absorbed damage equal to 10 per caster 
	level, the cocoon is the destroyed.  Such destruction halts any 
	health and protective effects offered by the cocoon.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: Oct 20, 2006
//:://////////////////////////////////////////////
//
// 2008/08/30 - ALFA ACR edit for subdual

#include "nw_i0_spells"
#include "x2_inc_spellhook" 
#include "x2_i0_spells"
#include "x0_i0_petrify"


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
	object	oTarget			=	GetSpellTargetObject();
	object	oCaster			=	OBJECT_SELF;
	effect	ePoisonImmune	=	EffectImmunity(IMMUNITY_TYPE_POISON);
	effect	eDiseaseImmune	=	EffectImmunity(IMMUNITY_TYPE_DISEASE);
	effect	eImmobile		=	EffectCutsceneImmobilize();
	effect	eVis			=	EffectVisualEffect(VFX_SPELL_DUR_COCOON);
	effect 	eFailure			=	EffectSpellFailure(100);
	float	fDuration		=	12.0;
	int		nDRLimit		=	10*GetCasterLevel(oCaster);
	effect	eDR				=	EffectDamageReduction(10, 0, nDRLimit, DR_TYPE_NONE); 
	int		nRegen			=	GetCasterLevel(oCaster);
	effect	eRegen;
	
//Determine duration
	fDuration = ApplyMetamagicDurationMods(fDuration);
	
//Determine regen rate
	if (nRegen > 15)
	{
			nRegen			=	15;
	}
			eRegen			=	EffectRegenerate(nRegen, 1.0);

//Link duration effects	
	effect	eDuration		=	EffectLinkEffects(ePoisonImmune,eDiseaseImmune);
			eDuration		=	EffectLinkEffects(eDuration,eVis);
			eDuration		=	EffectLinkEffects(eDuration,eImmobile);
			eDuration		=	EffectLinkEffects(eDuration,eDR);
			eDuration		=	EffectLinkEffects(eDuration,eRegen);	
			eDuration		=	EffectLinkEffects(eDuration,eFailure);
//Validate target
	if (GetIsObjectValid(oTarget))
	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster))
		{
			RemoveEffectOfType(oTarget, EFFECT_TYPE_POISON);
			RemoveEffectOfType(oTarget, EFFECT_TYPE_DISEASE);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDuration, oTarget, fDuration);
			// ALFA ACR edits for Subdual
			ACR_NLD_Regen(oTarget, nRegen, GetSpellId(), 1.0);
		}
	}
}

	