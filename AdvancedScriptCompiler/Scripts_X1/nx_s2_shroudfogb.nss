//::///////////////////////////////////////////////
//:: Shroud of Fog: On Exit
//:: nx_s2_shroudfoga.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Repurposed from Darkness (nw_s2_darkness).

    Creates a globe of fog around those in the area
    of effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 01/11/2007
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
    object oTarget  = GetExitingObject();
    object oCreator = GetAreaOfEffectCreator();
	
    //Search through the valid effects on the target.
	effect eAOE = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eAOE))
    {
        if (GetEffectCreator(eAOE) == oCreator)
        {	//If the effect was created by the spell then remove it
            int nID = GetEffectSpellId(eAOE);
            if( nID == SPELLABILITY_SHROUDING_FOG )
            {
				RemoveEffect(oTarget, eAOE);
            }
        }
		
        eAOE = GetNextEffect(oTarget);	//Get next effect on the target
    }
}