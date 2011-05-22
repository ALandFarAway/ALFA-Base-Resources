//::///////////////////////////////////////////////
//:: Body of the Sun
//:: nw_s0_bodysun.nss
//:: Copyright (c) 2006 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	By drawing on the power of the sun, you cause your body to emanate fire.
	Fire extends 5 feet in all directions from your body, illuminating the 
	area and dealing 1d4 points of fire damage per two caster levels (maximum 5d4)
	to adjacent enemies every round.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: Oct 18, 2006
//:://////////////////////////////////////////////


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
//Also prevent stacking

	object	oCaster		=	OBJECT_SELF;
	string	sSelf		=	ObjectToString(oCaster) + IntToString(GetSpellId());
	object	oSelf		=	GetNearestObjectByTag(sSelf);
	effect	eAOE		=	EffectAreaOfEffect(60, "", "", "", sSelf);
	effect 	eVis		=	EffectVisualEffect(924);
	float	fDuration	=	RoundsToSeconds(GetCasterLevel(oCaster));

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
	//ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oCaster, fDuration);
}