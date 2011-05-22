//::///////////////////////////////////////////////
//:: Curse of Impending Blades
//:: nw_s0_bladecurse.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
 	Curse of Impending Blades
	Necromancy
	Level: Bard 2, ranger 2, sorceror/wizard 2
	Components: V, S
	Range: Medium
	Target: One creature
	Duration: 1 minute/level
	Saving Throw: None
	Spell Resistance: Yes
	 
	The target of the spell has a hard time avoiding 
	attacks, sometimes even seeming to stumble into 
	harm's way.  The subject takes a -2 penalty to AC.
	 
	This curse cannot be dispelled, but can be removed 
	with remove curse.
	 
	NOTE: This spell can also be removed with break 
	enchantment, limited wish, miracle, and wish, but 
	we don't have these spells.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: 12.11.2006
//:://////////////////////////////////////////////
//:: AFW-OEI 07/12/2007: NX1 VFX.
//:: RPGplayer1 03/19/2008: Added SR check

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
	float		fDuration	=	TurnsToSeconds(GetCasterLevel(oCaster));
	int			nDurType	=	ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	// AFW-OEI 06/27/2007: Add a hit effect.
	effect		eHit		= 	EffectVisualEffect(VFX_HIT_SPELL_CURSE_OF_IMPENDING_BLADES);

	effect		eAC			=	EffectACDecrease(2);
	effect 		eDur		=	EffectVisualEffect(VFX_DUR_SPELL_CURSE_OF_BLADES);
	effect		eLink		=	EffectLinkEffects(eAC, eDur);

	eLink = EffectLinkEffects(eLink, EffectCurse(0, 0, 0, 0, 0, 0));
	eLink = SupernaturalEffect(eLink);
	
//metamagic
	fDuration	=	ApplyMetamagicDurationMods(fDuration);
	
//Target discrimination, then apply effects

	if (GetIsObjectValid(oTarget))
	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
		{	
			if(!MyResistSpell(OBJECT_SELF, oTarget))
			{
    			//should not stack with itself or similar spells
    			RemoveEffectsFromSpell(oTarget, GetSpellId());
    			RemoveEffectsFromSpell(oTarget, SPELL_GREATER_CURSE_OF_BLADES);

				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 1035));
				ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
			}
		}
	}
}
	
	
	
	