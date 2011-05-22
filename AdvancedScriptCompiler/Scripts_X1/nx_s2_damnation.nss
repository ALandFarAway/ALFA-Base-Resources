//::///////////////////////////////////////////////
//:: Damnation
//:: nx_s2_damnation
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Classes: Cleric, Warlock
	Spellcraft Required: 33
	Caster Level: Epic
	Innate Level: Epic
	School: Enchantment
	Descriptor(s): Teleportation
	Components: Verbal, Somatic
	Range: Touch
	Area of Effect / Target: Creature touched
	Duration: Instant
	Save: Will negates (DC +5)
	Spell Resistance: Yes
	
	You banish a single foe to the Hells, with no possibility of return.
	You must succeed at a melee touch attack, and the target must fail
	at a Will saving throw (DC +5). If the target fails the saving throw,
	it is dragged screaming into the Hells, to be tormented and ultimately
	devoured by fiends.
	
	Creatures that succeed at their saving throw are nonetheless exhausted
	from resisting so powerful an enchantment, and they are Dazed for 1d6+1 rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo
//:: Created On: 04/12/2007
//:://////////////////////////////////////////////
//:: AFW-OEI 06/25/2007: Reduce DC from +15 to +5.
//:: AFW-OEI 07/11/2007: Defer to NX1 Damnation hit VFX in spells.2da.


#include "X0_I0_SPELLS"
#include "x2_i0_spells"
#include "x2_inc_spellhook"


void main()
{
	if (!X2PreSpellCastCode())
	{	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	    return;
	}

	
	int nSaveDC = GetSpellSaveDC() + 5;
	int nDazeDuration = d6(1) + 1;
	
	object oTarget = GetSpellTargetObject();
	//effect eVis = EffectVisualEffect(VFX_HIT_SPELL_EVIL);
	effect eDeath = EffectDeath(FALSE, TRUE, TRUE);		// No spectacular death, yes display feedback, yes ignore death immunity.
	effect eDaze = EffectDazed();
	
	// Make a melee touch attack.
	if (TouchAttackMelee(oTarget) != FALSE)
	{	// If we succeed at a melee touch attack
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
			
			if (!MyResistSpell(OBJECT_SELF, oTarget))
			{
				//ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

				if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nSaveDC, SAVING_THROW_TYPE_SPELL, OBJECT_SELF))
				{	// Fail save and die.
					DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
				}
				else
				{	// Make save, so be dazed.
					DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDaze, oTarget, RoundsToSeconds(nDazeDuration)));
				}
				
			}
		}		
	}
}