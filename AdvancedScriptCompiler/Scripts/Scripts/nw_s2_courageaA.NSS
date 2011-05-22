//::///////////////////////////////////////////////
//:: Aura of Courage
//:: NW_S2_CourageA.nss
//:: Copyright (c) 2006 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
    Paladin ability.  Grants +4 morale bonus on saves
	vs. fear effects to all allies within 10'.  The
	paladin herself gains an immunity to fear that's
	implemented in the code.

	On Enter script.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 05/30/2006
//:://////////////////////////////////////////////
#include "x0_i0_spells"
#include "x2_inc_spellhook"

void main()
{
	//SpeakString("nw_s2_courageaA.nss: On Enter: function entry");

	object oTarget = GetEnteringObject();
	object oCaster = GetAreaOfEffectCreator();

	// Default to +4 saves vs. fear.
	int nSaveBonus = 4;

	// Doesn't work on self
	if (oTarget != oCaster)
	{
		//SpeakString("nw_s2_courageaA.nss: On Enter: target is not the same as the creator");

	    //Faction Check
	    if(spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster))
	    {
			//SpeakString("nw_s2_courageaA.nss: On Enter: target is friend");

		    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, nSaveBonus, SAVING_THROW_TYPE_FEAR);
		    eSave        = SupernaturalEffect(eSave);
	
			SignalEvent (oTarget, EventSpellCastAt(oCaster, SPELLABILITY_AURA_OF_COURAGE, FALSE));		
	        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSave, oTarget);
	    }
	}
}