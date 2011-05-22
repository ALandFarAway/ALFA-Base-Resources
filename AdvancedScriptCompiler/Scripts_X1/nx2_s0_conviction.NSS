//::///////////////////////////////////////////////
//:: Conviction
//:: nx2_s0_conviction.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*

	Conviction
	Abjuration
	Level: Cleric 1
	Components: V, S
	Range: Touch
	Target: Creature touched
	Duration: 10 minutes/level
	Saving Throw: Will negates (harmless)
	Spell Resistance: Yes (harmless)
	 
	This spell bolsters the mental, physical, and spiritual strength of the creature touched.  
	The spell grants the subject a +2 bonus on saving throws, with an additional +1 to the bonus for 
	every six caster levels you have (maximum +5 bonus at 18th level).

	
*/
//:://////////////////////////////////////////////
//:: Created By: Michael Diekmann
//:: Created On: 09/04/2007
//:://////////////////////////////////////////////

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
	// Caster level
	int nCasterLevel		= GetCasterLevel(oCaster);
	// Spell Duration
	float fDuration			= 10 * TurnsToSeconds(nCasterLevel);
	// Cap caster level
	if(nCasterLevel > 18)
		nCasterLevel = 18;
	// Amount of increase
	int nIncrease = nCasterLevel/6;
	// Effects
	effect eSTIncrease 		= EffectSavingThrowIncrease(SAVING_THROW_ALL, (2 + nIncrease));
	effect eVisual			= EffectVisualEffect(VFX_HIT_SPELL_CONVICTION);

	// Make sure spell target is valid
	if (GetIsObjectValid(oTarget))
	{
		// remove previous usages of this spell
		RemoveEffectsFromSpell(oTarget, GetSpellId());	
		// check to see if ally
		if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster)) 
		{
			// apply linked effect to target
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSTIncrease, oTarget, fDuration);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget);
			//Fire cast spell at event for the specified target
    		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
		}
		
	}
}