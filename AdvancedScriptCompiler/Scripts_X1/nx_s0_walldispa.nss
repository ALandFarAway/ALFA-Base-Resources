//::///////////////////////////////////////////////
//:: Wall of Dispel Magic (on enter script)
//:: nw_s0_walldispa.nss
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
//:: AFW-OEI 07/12/2007: NX1 VFX

#include "nw_i0_spells"
#include "x2_inc_spellhook" 
#include "nwn2_inc_metmag"
#include "x0_i0_spells"


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
	object	oCaster		=	GetAreaOfEffectCreator();
	object	oTarget		=	GetEnteringObject();
	int		nCasterLvl	=	GetCasterLevel(oCaster);
	effect	eVis		=	EffectVisualEffect(VFX_HIT_SPELL_WALL_OF_DISPEL);
	effect 	eImpact; //This additional varaible is required for the use of spellsDispelMagic, but we don't use it
	
//Cap caster level at 10, as per dispel magic, then determine power of spell

	if (nCasterLvl > 10)
	{
		nCasterLvl	=	10;
	}
//Determine validity of target
//additional target validation handed in x0_i0_spells
	if (GetIsObjectValid(oTarget))
	{
		spellsDispelMagic(oTarget, nCasterLvl, eVis, eImpact);
	}
}
		