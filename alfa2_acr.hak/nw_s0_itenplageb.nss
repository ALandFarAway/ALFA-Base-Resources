//:://////////////////////////////////////////////////////////////////////////
//:: Warlock Greater Invocation: Tenacious Plague   ON EXIT
//:: nw_s0_itenplageb.nss
//:: Created By: Brock Heinz - OEI
//:: Created On: 08/30/05
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
        Tenacious Plague [B]
        Complete Arcane, pg. 135
        Spell Level:	6
        Class: 			Misc

        This invocation functions similar to the creeping doom spell (7th level 
        druid). But the progression of damage works differently - 1d6 the first 
        round, 2d6 the second, 3d6 the third, etc. until the 10th round when the 
        invocation effect ends. Tenacious plagues cannot be stacked on top of 
        each other.

        [Rules Note] This spell is extremely different from the Complete Arcane 
        spell because in NWN2 we won't have swarms that can be summoned. So a 
        lesser version of the creeping doom spell is used here.

*/
//:://////////////////////////////////////////////////////////////////////////

#include "x2_inc_spellhook"

void main()
{

    //Declare major variables
    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();
    int bValid = FALSE;
    effect eAOE;

    if(GetHasSpellEffect(SPELL_I_TENACIOUS_PLAGUE, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE) && bValid == FALSE)
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                if(GetEffectType(eAOE) == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE)
                {
                    //If the effect was created by the Acid_Fog then remove it
                    if(GetEffectSpellId(eAOE) == SPELL_I_TENACIOUS_PLAGUE)
                    {
                        RemoveEffect(oTarget, eAOE);
                        bValid = TRUE;
                    }
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
}