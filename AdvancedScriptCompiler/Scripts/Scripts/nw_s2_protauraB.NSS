//::///////////////////////////////////////////////
//:: Protective Aura
//:: NW_S2_ProtAuraB.nss
//:: Copyright (c) 2006 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
    Grants a bonus to saves and AC to allies within
	the spell radius.

	Used by both VFX_PER_PROTECTIVE_AURA and
	VFX_PER_PROTECTIVE_AURA_II.

	On Exit script.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 05/17/2006
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{	
	//SpeakString("nw_s2_protauraB.nss: On Exit: function entry");

    object oTarget = GetExitingObject();
	object oCaster = GetAreaOfEffectCreator();

    //Search through the valid effects on the target.
    effect eAOE = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eAOE))
    {
        // If the effect was created by the Protective Aura then remove it,
		// but only if it's not the caster himself.
        if ((GetEffectCreator(eAOE) == oCaster) &&
			(GetEffectSpellId(eAOE) == SPELLABILITY_PROTECTIVE_AURA) &&
			(oTarget != oCaster))
        {
			//SpeakString("nw_s2_protauraB.nss: On Exit: removing effect");
            RemoveEffect(oTarget, eAOE);
        }

        eAOE = GetNextEffect(oTarget);
    }
}