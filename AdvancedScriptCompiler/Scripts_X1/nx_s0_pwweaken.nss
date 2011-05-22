//::///////////////////////////////////////////////
//:: Power Word: Weaken
//:: NX_s0_pwweaken.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	Power Word Weaken
	Divination
	Level: Sorceror/Wizard 3
	Components: V
	Range: Close
	Target: One living creature with 75 hp or less
	Duration: See text
	Saving Throw: None
	Spell Resistance: Yes
	 
	You utter a single word of power that instantly 
	causes one creature of your choice to become 
	weaker, dealing 2 points of damage to its strength, 
	whether the creature can hear the word or not.  
	
	The specific effect and duration of the spell 
	depend on the target's current hit point total, 
	as show below.  Any creature that currently has 
	75 or more hit points is unaffected by power word 
	weaken.
	 
	Hit Points           Effect/Duration
	25 or less          The strength damage is ability drain instead
	26-50                Strength damage last 1d4+1 minutes
	51-75                Strength damage lasts 1d4+1 rounds
	 
	NOTE: Because this was changed from enchantment
	to Divination, creatures previously immune to
	mind-affecting spells are vulnurable.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: 11.28.06
//:://////////////////////////////////////////////
//:: Updates to scripts go here.
//:: MDiekmann 6/13/07 - Added Signal Event
//:: AFW-OEI 07/10/2007: NX1 VFX.

#include "nw_i0_spells" 
#include "x2_inc_spellhook"
#include "nwn2_inc_metmag"
#include "nwn2_inc_spells"

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
*/

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


//Declare Major variables

	object 	oCaster		=	OBJECT_SELF;
	object	oTarget		=	GetSpellTargetObject();
	int	nTargetHP		=	GetCurrentHitPoints(oTarget);
	effect	eStrDrain	=	EffectAbilityDecrease(ABILITY_STRENGTH, 2);
	effect	eDur		=	EffectVisualEffect(VFX_DUR_SPELL_POWER_WORD_WEAKEN);
	effect	eVis		=	EffectVisualEffect(VFX_HIT_SPELL_DIVINATION);
	float	fDuration;
	
//Link vfx with strength drain
	effect	eLink		=	EffectLinkEffects(eStrDrain, eDur);
	
//Spell Resistance Check & Target Discrimination

	if (GetIsObjectValid(oTarget))
	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			if (!MyResistSpell(oCaster, oTarget))
			{
//Determine the nature of the effect
				if	(nTargetHP > 75)
				{
					FloatingTextStrRefOnCreature( STR_REF_FEEDBACK_SPELL_INVALID_TARGET, OBJECT_SELF );
				}
				else if (nTargetHP > 50)
				{
					fDuration	=	ApplyMetamagicDurationMods(RoundsToSeconds(d4()));
					
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
					SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));
				}
				else if (nTargetHP > 25)
				{
					fDuration	=	ApplyMetamagicDurationMods(TurnsToSeconds(d4()));
					
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
					SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));
				}
				else
				{
					ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
					SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));
				}
			}
		}
	}
}
					
						
	