//::///////////////////////////////////////////////
//:: Shadow Simulacrum
//:: nx_s0_shadow_sim_buff.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Illusion (Shadow)
	Level: Sor/Wiz 9
	Components: V, S
	Range: Touch
	Effect: One duplicate creature
	Duration: 1 round / caster level
	Saving Throw: None
	Spell Resistance: No 
	 
	Shadow Simulacrum reaches into the plane of
	shadow and creates a shadow duplicate of the
	creature touched by the caster. This shadow
	creature retains all the abilities of the
	original, but is created with only 3/4th the
	current hit points of the original and all
	memorized spells are lost.  Moreover, the
	simulacrum gains 20% concealment and immunity
	to negative energy damage.  Creatures with more
	than double the caster's level in hit dice are
	immune to this spell.
	
	
	This script handles the buff to the simulacrum.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 05/15/2007
//:://////////////////////////////////////////////
//:: AFW-OEI 07/02/2007: Add VFX to the simulacrum.

#include "nwn2_inc_spells"
#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode())
    {   // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
    
	effect eConcealment = EffectConcealment(20);
	effect eImmunity = EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE, 100);
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_SHADOW_SIMULACRUM);
	
	effect eLink = EffectLinkEffects(eConcealment, eImmunity);
	eLink = EffectLinkEffects(eLink, eVis);
	eLink = ExtraordinaryEffect(eLink);
	
	//Apply the effects
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, OBJECT_SELF);	// Permanent duration is OK, since simulacrum will expire...

	TakeGoldFromCreature(GetGold(OBJECT_SELF), OBJECT_SELF, TRUE);
}