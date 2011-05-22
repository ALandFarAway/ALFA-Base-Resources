//::///////////////////////////////////////////////
//:: Wall of Dispel Magic
//:: nw_s0_walldisp.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	Wall of Dispel Magic
	Abjuration
	Level: Cleric 5, sorceror/wizard 5
	Components: V, S
	Range: Short
	Effect: 10-ft. by 1-ft. wall
	Duration: 1 minute/level
	Saving Throw: None
	Spell Resistance: No
	
	This spell creates a magic, permiable barrier.
	Anyone passing through it becomes the target of
	a dispel magic effect at your caster level.  A 
	summoned creature targeted in this way can be
	dispelled by the effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: 12.07.2006
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
	effect 		eAOE	=	EffectAreaOfEffect(61);
	location	lTarget	=	GetSpellTargetLocation();
	float		fDur	=	RoundsToSeconds(GetCasterLevel(OBJECT_SELF));
	
//Find proper duration base don possible metamagic modifiers

				fDur	=	ApplyMetamagicDurationMods(fDur);

//Apply AOE effect to location
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, fDur);
}