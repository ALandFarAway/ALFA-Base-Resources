//::///////////////////////////////////////////////
//:: Vigor
//:: NX_s0_lsrVigor.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
 	
	Vigor
	Conjuration (Healing)
	Level: Cleric 3, druid 3
	Components: V, S
	Range: Touch
	Target: Living creature touched
	Duration: 10 rounds + 1 round/level (max 25 rounds)
	 
	Target gains fast healing 1 for 10 rounds + 1
	round/level (max 15).
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: 12.04.06
//:://////////////////////////////////////////////
//:: AFW-OEI 07/18/2007: Weaker versions of vigor will not override the stronger versions,
//::	but versions of the same or greater strength will replace each other.
//
//  2008/08/30 - ALFA ACR edits for subdual system

#include "nw_i0_spells"
#include "x2_inc_spellhook" 
#include "nwn2_inc_metmag"
#include "nwn2_inc_spells"


void main()
{
    /*
      Spellcast Hook Code
      Added 2003-07-07 by Georg Zoeller
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more

    */

    if (!ACR_PrecastEvent())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

//Declare major variables
	location	lLocation	=	GetSpellTargetLocation();
	object		oCaster		=	OBJECT_SELF;
	object		oTarget		=	GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lLocation, FALSE, OBJECT_TYPE_CREATURE);
	effect		eVis		=	EffectVisualEffect( VFX_DUR_SPELL_MASS_LESSER_VIGOR );
    effect		eRegen		= 	EffectRegenerate(1, 6.0);
	effect		eLink		= 	EffectLinkEffects( eRegen, eVis );
	
	int	nLvl = GetCasterLevel(oCaster);
	if (nLvl >= 15) {
		nLvl = 15;
	}
		
	float		fDuration	=	RoundsToSeconds(10+nLvl);
	int			nDurType	=	ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
//metamagic
	fDuration	=	ApplyMetamagicDurationMods(fDuration);
	
//Target discrimination, then apply effects

	
	while (GetIsObjectValid(oTarget))
	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster))
		{	
			// AFW-OEI 07/18/2007: Strip all weaker vigor effcts and replace them with this spell's effects;
			//	fizzle the spell if there is a stronger vigor effect active.
			RemoveEffectsFromSpell(oTarget, SPELL_LESSER_VIGOR);
			RemoveEffectsFromSpell(oTarget, SPELL_MASS_LESSER_VIGOR);
			if (GetHasSpellEffect(SPELL_VIGOR, oTarget) || GetHasSpellEffect(SPELL_VIGOROUS_CYCLE, oTarget))
			{
				FloatingTextStrRefOnCreature( STR_REF_FEEDBACK_SPELL_FAILED, oTarget );  //"Failed"		
			}
			else
			{
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
			    RemovePermanencySpells(oTarget);
				ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
				// ALFA ACR subdual system edits
				ACR_NLD_Regen(oTarget, 1, GetSpellId(), 6.0);
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lLocation, FALSE, OBJECT_TYPE_CREATURE);
	}
}
	
	
	
	