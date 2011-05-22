//::///////////////////////////////////////////////
//:: Aura of Courage
//:: NW_S2_CourageAB.nss
//:: Copyright (c) 2006 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
    Paladin ability.  Grants +4 morale bonus on saves
	vs. fear effects to all allies within 10'.  The
	paladin herself gains an immunity to fear that's
	implemented in the code.

	On Exit script.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 05/30/2006
//:://////////////////////////////////////////////
#include "x0_i0_spells"
#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{	
	//SpeakString("nw_s2_courageaB.nss: On Exit: function entry");

    object oTarget = GetExitingObject();
	object oCaster = GetAreaOfEffectCreator();

    //Search through the valid effects on the target.
    effect eAOE = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eAOE))
    {
        // If the effect was created by the Aura of Courage then remove it,
		// but only if it's not the caster himself.
        if ((GetEffectCreator(eAOE) == oCaster) &&
			(GetEffectSpellId(eAOE) == SPELLABILITY_AURA_OF_COURAGE) &&
			(oTarget != oCaster))
        {
			//SpeakString("nw_s2_courageaB.nss: On Exit: removing effect");
            RemoveEffect(oTarget, eAOE);
        }

        eAOE = GetNextEffect(oTarget);
    }
}