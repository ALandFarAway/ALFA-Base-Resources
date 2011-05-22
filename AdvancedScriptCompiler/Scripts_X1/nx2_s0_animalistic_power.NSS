//::///////////////////////////////////////////////
//:: Animalistic Power
//:: nx2_s0_animalistic_power.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Animalistic Power
	Transmutation
	Level: Cleric 2, Druid 2, duskblade 2, ranger 2, sorceror/wizard 2
	Components: V, S
	Range: Touch
	Target: Creature touched
	Duration 1 minute/level
	 
	You imbue the subject with an aspect of the natural world.  
	The subject gains a +2 bonus to Strength, Dexterity, and Constitution.
*/
//:://////////////////////////////////////////////
//:: Created By: Michael Diekmann
//:: Created On: 08/28/2007
//:://////////////////////////////////////////////
//:: RPGplayer1 11/22/2008: Added support for metamagic

#include "nwn2_inc_spells"
#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode())
    {
	    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

	// Get necessary objects
	object oTarget			= GetSpellTargetObject();
	object oCaster			= OBJECT_SELF;
	int nCasterLevel		= GetCasterLevel(oCaster);
	// Spell Duration
	float fDuration			= TurnsToSeconds(nCasterLevel);
	fDuration			= ApplyMetamagicDurationMods(fDuration);
	// Effects
	effect eStrength 		= EffectAbilityIncrease(ABILITY_STRENGTH, 2);
	effect eDexterity		= EffectAbilityIncrease(ABILITY_DEXTERITY, 2);
	effect eConstitution	= EffectAbilityIncrease(ABILITY_CONSTITUTION, 2);
	effect eVisual			= EffectVisualEffect(VFX_DUR_SPELL_ANIMALISTIC_POWER);
	effect eLink = EffectLinkEffects(eStrength, eDexterity);
	eLink =  EffectLinkEffects(eLink, eConstitution);
	eLink =  EffectLinkEffects(eLink, eVisual);
	 
	// Make sure spell target is valid
	if (GetIsObjectValid(oTarget))
	{
		// remove previous usages of this spell
		RemoveEffectsFromSpell(oTarget, GetSpellId());	
		// check to see if ally
		if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster)) 
		{
			// apply linked effect to target
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
			//Fire cast spell at event for the specified target
    		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
		}
		
	}
}