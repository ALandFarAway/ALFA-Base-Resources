//::///////////////////////////////////////////////
//:: Nightshield
//:: nx2_s0_nightshield.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Nightshield
	Abjuration
	Level: Cleric 1, sorceror/wizard 1
	Components: V, S
	Range: Personal
	Target: You
	Duration: 1 minute/level
	 
	This spell provides a +1 resistance bonus on saving throws; this resistance increases to +2 at caster level 6th, and +3 at caster level 9th.  
	In addition, the spell negate magic missile attacks directed at you.
	
*/
//:://////////////////////////////////////////////
//:: Created By: Michael Diekmann
//:: Created On: 08/28/2007
//:://////////////////////////////////////////////
//:: RPGplayer1 11/22/2008: Added support for metamagic
//:: RPGplayer1 11/25/2008: Fixed +3 bonus to saves

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
	float fDuration			= TurnsToSeconds(nCasterLevel);
	fDuration			= ApplyMetamagicDurationMods(fDuration);
	// Amount of increase
	int nIncrease = 1;
	if(nCasterLevel >= 6)
		nIncrease = 2;
	if(nCasterLevel >= 9)	//FIX: removed else
		nIncrease = 3;
	// Effects
	effect eSTIncrease 		= EffectSavingThrowIncrease(SAVING_THROW_ALL, nIncrease);
	effect eImmuneMM		= EffectSpellImmunity(SPELL_MAGIC_MISSILE);
	effect eVisual			= EffectVisualEffect(VFX_DUR_SPELL_NIGHTSHIELD);
	effect eLink			= EffectLinkEffects(eSTIncrease, eImmuneMM);
	eLink			= EffectLinkEffects(eLink, eVisual);

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