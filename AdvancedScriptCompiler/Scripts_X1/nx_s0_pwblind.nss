//::///////////////////////////////////////////////
//:: Power Word: Weaken
//:: NX_s0_pwweaken.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	Power Word Blind
	Divination (Formerly Enchantment)
	Level Worc/Wiz 7, [War 7]
	Components: V
	Range: Close
	Target: One creature with 200 hp or less
	Duration: See text
	Saving Throw: None
	Spell Resistance: Yes
	 
	You utter a single word of power that causes 
	one creature of your choice to become blinded, 
	whether the creature can hear the word or not.  
	The duration of the spell depends on the target's 
	current hit point total.  Any creature that 
	currently has 201 or more hit points is 
	unaffected by power word blind.
	 
	Hit Points        Duration
	50 or less       Permanent
	51-100           1d4+1 minutes
	101-200         1d4+1 rounds
	 
	NOTE: Because this was changed from enchantment
	to Divination, creatures previously immune to
	mind-affecting spells are vulnurable.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: 11.28.06
//:://////////////////////////////////////////////
//:: Updates to scripts go here.
//:: MDiekmann 6/13/07 - Added SignalEvent
//:: AFW-OEI 07/10/2007: NX1 VFX

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
	int	nTargetHP	=	GetCurrentHitPoints(oTarget);
	effect	eBlind	=	EffectBlindness();
	effect	eVis	=	EffectVisualEffect(VFX_DUR_SPELL_POWER_WORD_BLIND);
	float	fDuration;
	
//Link vfx with strength drain
	effect	eLink		=	EffectLinkEffects(eBlind, eVis);
	
//Spell Resistance Check & Target Discrimination

	if (GetIsObjectValid(oTarget))
	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			if (!MyResistSpell(oCaster, oTarget))
			{
//Determine the nature of the effect
				if	(nTargetHP > 200)
				{
					FloatingTextStrRefOnCreature( STR_REF_FEEDBACK_SPELL_INVALID_TARGET, OBJECT_SELF );
				}
				else if (nTargetHP > 100)
				{
					fDuration	=	ApplyMetamagicDurationMods(RoundsToSeconds(d4()));
					
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
					SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));
				}
				else if (nTargetHP > 50)
				{
					fDuration	=	ApplyMetamagicDurationMods(TurnsToSeconds(d4()));
					
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
					SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));
				}
				else
				{
					ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
					SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));
				}
			}
		}
	}
}
					
						
	