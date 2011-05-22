//::///////////////////////////////////////////////
//:: Kelemvor's Grace
//:: NW_S2_KelemGraceA.nss
//:: Copyright (c) 2008 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
    Doomguide ability.  Grants +4 bonus on saves
	vs. death effects to all allies within 10'.  The
	doomguide herself gains an immunity to death that's
	implemented in the code.

	OnEnter() Script
	*/
//:://////////////////////////////////////////////
//:: Created By: Justin Reynard (JWR-OEI)
//:: Created On: 05/28/2008
//:://////////////////////////////////////////////
#include "x0_i0_spells"
#include "x2_inc_spellhook"

void main()
{
	//SpeakString("nw_s2_kelgraceA.nss: On Enter: function entry");

	object oTarget = GetEnteringObject();
	object oCaster = GetAreaOfEffectCreator();

	// Default to +4 saves vs. fear.
	int nSaveBonus = 4;

	// Doesn't work on self
	if (oTarget != oCaster)
	{
		//SpeakString("nw_s2_kelgraceA.nss: On Enter: target is not the same as the creator");

	    //Faction Check
	    if(spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster))
	    {
		//	SpeakString("nw_s2_kelgraceA.nss: On Enter: target is friend");

		    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, nSaveBonus, SAVING_THROW_TYPE_DEATH);
		    eSave        = SupernaturalEffect(eSave);
	
			SignalEvent (oTarget, EventSpellCastAt(oCaster, SPELLABILITY_KELEMVORS_GRACE, FALSE));		
	        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSave, oTarget);
	    }
	}
}