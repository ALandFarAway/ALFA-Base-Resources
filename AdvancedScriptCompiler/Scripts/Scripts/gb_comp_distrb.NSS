// gb_comp_distrb
/*
	companion On Disturbed
*/
// ChazM 12/5/05
// ChazM 5/17/06 - comment changes

//::///////////////////////////////////////////////
//:: Henchmen: On Disturbed
//:: NW_C2_AC8
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Determine Combat Round on disturbed.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 16, 2001
//::///////////////////////////////////////////

// * Make me hostile the faction of my last attacker (TEMP)
//  AdjustReputation(OBJECT_SELF,GetFaction(GetLastAttacker()),-100);
// * Determined Combat Round

#include "X0_INC_HENAI"

void main()
{
    object oTarget = GetLastDisturbed();

    if(!GetIsObjectValid(GetAttemptedAttackTarget()) && !GetIsObjectValid(GetAttemptedSpellTarget()))
    {
        if(GetIsObjectValid(oTarget))
        {
            HenchmenCombatRound(oTarget);
        }
        else
        {
        }
    }
    if(GetSpawnInCondition(NW_FLAG_DISTURBED_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_DISTURBED));
    }
}