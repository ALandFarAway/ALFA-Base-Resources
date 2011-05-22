//::///////////////////////////////////////////////
//:: Reach to the Blaze
//:: nx_s2_reachblaze.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	By drawing on the power of the sun, you cause your body to emanate fire.
	Fire extends 5 feet in all directions from your body, illuminating the 
	area and dealing 1d4 points of fire damage per two caster levels (maximum 5d4)
	to adjacent enemies every round.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 01/11/2007
//:://////////////////////////////////////////////
//:: Repurposed from Body of the Sun

#include "nw_i0_spells"
#include "x2_inc_spellhook" 
#include "nwn2_inc_metmag"

void main()
{
    if (!X2PreSpellCastCode())
    {   // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
	
//Declare major variables
//Also prevent stacking

	object	oCaster		=	OBJECT_SELF;
	string	sSelf		=	ObjectToString(oCaster) + IntToString(GetSpellId());
	object	oSelf		=	GetNearestObjectByTag(sSelf);
	effect	eAOE		=	EffectAreaOfEffect(AOE_MOB_REACH_TO_THE_BLAZE, "", "", "", sSelf);
	effect 	eVis		=	EffectVisualEffect(VFX_SPELL_DUR_BODY_SUN);
	float	fDuration	=	RoundsToSeconds(5);		// Fixed to 5 rounds.

//Link effects
	effect	eLink		=	EffectLinkEffects(eAOE, eVis);
	
//Destroy the object if it already exists before creating a new one

	if (GetIsObjectValid(oSelf))
	{
		DestroyObject(oSelf);
	}
	
//Determine duration
			fDuration	=	ApplyMetamagicDurationMods(fDuration);

//Generate the object
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, fDuration);
}