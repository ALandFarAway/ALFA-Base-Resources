//::///////////////////////////////////////////////
//:: Power Word: Disable
//:: NX_s0_pwDisable.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
 	
	Power Word Disable
	Divination (Changed from Enchantment)
	Level: Sorceror/wizard 5
	Components: V
	Range: Close
	Target: One living creature with 50 hp or less
	Saving Throw: None
	Spell Resistance: Yes
	 
	You utter a single word of power that instantly 
	reduces the hit points of one creature of your 
	choice to 1.  Any creature that currently had 51 
	or more hit points is unaffected by  power word 
	disable.
	 
	NOTE: I have changed the function of this spell 
	so that it reduces a target to 5 hit point, rather 
	than 0, to better match the intended function 
	since 0 HP in 3.5 is the brink of death, but 0 in 
	NWN2 is actually death.  
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: 12.12.06
//:://////////////////////////////////////////////
//:: Updates to scripts go here.
// MDiekmann 6/13/07 - Added SignalEvent
// AFW-OEI 07/05/2007: Take you down to 1 HP, not 5 HP.

#include "nw_i0_spells" 
#include "x2_inc_spellhook"
#include "nwn2_inc_metmag"
#include "nwn2_inc_spells"
#include "x0_i0_spells"

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
	int		nTargetHP	=	GetCurrentHitPoints(oTarget);
	effect	eDisable	=	EffectDamage(nTargetHP - 1, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL, TRUE);
	effect	eVis		=	EffectVisualEffect(VFX_HIT_SPELL_DIVINATION);

//Link vfx with strength drain
	effect	eLink		=	EffectLinkEffects(eDisable, eVis);
	
//Spell Resistance Check & Target Discrimination
	if (GetIsObjectValid(oTarget))
	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));	// Move signal above SR check.
	
			if (!MyResistSpell(oCaster, oTarget))
			{
				//Determine the nature of the effect
				if	(nTargetHP > 50)
				{
					FloatingTextStrRefOnCreature( STR_REF_FEEDBACK_SPELL_INVALID_TARGET, OBJECT_SELF );
				}
				else
				{
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
				}
			}
		}
	}
}
					
						
	