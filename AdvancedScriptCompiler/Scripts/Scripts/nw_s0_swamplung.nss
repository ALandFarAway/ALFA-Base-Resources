//::///////////////////////////////////////////////
//:: Swamp Lung
//:: nw_s0_swamplung.nss
//:: Copyright (c) 2006 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	The spell attempts to flood the target's lungs with stagnant
	swamp water.  if the subject fails the save, the creature falls
	prone in a coughing fit for 1-6 rounds and is helpless during
	that time.  Furthermore, on a failed save, the subject contracts 
	filth fever, which causs 1-3 strength and dexterity damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: Oct 16, 2006
//:://////////////////////////////////////////////
//:: RPGplayer1 03/19/2008: Prevented stacking by not applying new effect
//:: RPGplayer1 02/10/2009: Added missing SignalEvent (will force caster to drop invisibility)

#include "nw_i0_spells"
#include "x2_inc_spellhook" 
#include "x2_i0_spells"


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

	object	oCaster		=	OBJECT_SELF;
	object	oTarget		=	GetSpellTargetObject();
	effect	eVis		=	EffectVisualEffect(VFX_SPELL_HIT_SWAMP_LUNG);
	effect	eKnockdown	=	EffectKnockdown();
	effect	eDisease	=	EffectDisease(DISEASE_FILTH_FEVER);
	int		nSave		=	GetSpellSaveDC();
	float	fDuration	=	RoundsToSeconds(d6());
	

//Metamagic behaviors
//Detemine duration
			fDuration	=	ApplyMetamagicDurationMods(fDuration);

//This spell doesn't stack
	if (GetHasSpellEffect(1006, oTarget))
	{
		//RemoveSpellEffects( 1006, oCaster, oTarget);
		FloatingTextStrRefOnCreature(100775,OBJECT_SELF,FALSE);
		return;
	}
	
//Determine validity of Target and then apply effects.
	if (GetIsObjectValid(oTarget))
	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			if (GetRacialType(oTarget) == RACIAL_TYPE_CONSTRUCT
			|| GetRacialType(oTarget) == RACIAL_TYPE_ELEMENTAL 
			|| GetRacialType(oTarget) == RACIAL_TYPE_VERMIN 
			|| GetRacialType(oTarget) == RACIAL_TYPE_OOZE 
			|| GetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER 
			|| GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
			{
				FloatingTextStrRefOnCreature(184683, oCaster, FALSE);
				return;
			}
			else
			{
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
				if (!FortitudeSave(oTarget, nSave, SAVING_THROW_TYPE_SPELL, oCaster))
				{
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, fDuration);
					ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDisease, oTarget);
				}
			}
		}
	}
}
	
	