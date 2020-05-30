//::///////////////////////////////////////////////
//:: Magic Cirle Against Chaos
//:: NW_S0_CircChaoB
//:: Copyright (c) 2020 A Land Far Away
//:://////////////////////////////////////////////
/*
    Add basic protection from chaos effects to
    entering allies.
*/
#include "NW_I0_SPELLS"


#include "x2_inc_spellhook"

void main()
{
    // Get the object that is exiting the AOE
    object oTarget = GetExitingObject();
    int bValid = FALSE;
    effect eAOE;

    if (GetHasSpellEffect(SPELL_MAGIC_CIRCLE_AGAINST_CHAOS, oTarget))
    {
        // Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                // If the effect was created by the AOE then remove it
                if(GetEffectSpellId(eAOE) == SPELL_MAGIC_CIRCLE_AGAINST_CHAOS)
                {
                    RemoveEffect(oTarget, eAOE);
                }
            }
            // Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
}
