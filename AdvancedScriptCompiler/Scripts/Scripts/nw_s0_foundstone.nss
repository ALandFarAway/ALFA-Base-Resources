//::///////////////////////////////////////////////
//:: Foundation of Stone
//:: nw_s0_foundstone.nss
//:: Copyright (c) 2006 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	Calling on the strength of the earth, you lend some of the stability
	of stone to yourself or an ally.  The subject is immune to knockdown
	effects for the duration of the spell, but moves at a greatly reduced 
	speed.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: Oct 17, 2006
//:://////////////////////////////////////////////
//:: RPGplayer1 01/10/2009: Corrected duration to 3 rounds + 1 round/level

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

//Major variables
	object	oTarget		=	GetSpellTargetObject();
	object	oCaster		=	OBJECT_SELF;
	effect	eVis		=	EffectVisualEffect(VFX_SPELL_DUR_FOUND_STONE);
	effect	eImmuneKO	=	EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN);
	effect	eSlow		=	EffectMovementSpeedDecrease(50);
	int		nDur		=	3 + GetCasterLevel(oCaster);
	float	fDuration	=	RoundsToSeconds(nDur);

//Link effects
	effect 	eLink		=	EffectLinkEffects(eVis, eImmuneKO);
			eLink		=	EffectLinkEffects(eLink, eSlow);

//Determine duration
			fDuration	=	ApplyMetamagicDurationMods(fDuration);

//Validate target and apply effects
	if (GetIsObjectValid(oTarget))
	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster))
		{
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
		}
	}
}
	