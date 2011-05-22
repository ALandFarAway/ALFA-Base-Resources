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

	OnExit() Script
	*/
//:://////////////////////////////////////////////
//:: Created By: Justin Reynard (JWR-OEI)
//:: Created On: 05/28/2008
//:://////////////////////////////////////////////
#include "x0_i0_spells"
#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{	
	//SpeakString("nw_s2_kelgraceB.nss: On Exit: function entry");

    object oTarget = GetExitingObject();
	object oCaster = GetAreaOfEffectCreator();

    //Search through the valid effects on the target.
    effect eAOE = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eAOE))
    {
        // If the effect was created by the Aura of Courage then remove it,
		// but only if it's not the caster himself.
        if ((GetEffectCreator(eAOE) == oCaster) &&
			(GetEffectSpellId(eAOE) == SPELLABILITY_KELEMVORS_GRACE) &&
			(oTarget != oCaster))
        {
		//	SpeakString("nw_s2_kelgraceB.nss: On Exit: removing effect");
            RemoveEffect(oTarget, eAOE);
        }

        eAOE = GetNextEffect(oTarget);
    }
}