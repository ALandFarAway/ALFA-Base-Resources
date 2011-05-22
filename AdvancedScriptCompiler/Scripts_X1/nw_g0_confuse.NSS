//::///////////////////////////////////////////////
//:: Confusion Heartbeat Support Script
//:: NW_G0_Confuse
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This heartbeat script runs on any creature
    that has been hit with the confusion effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 27, 2001
//:://////////////////////////////////////////////
#include "x0_inc_henai"

#include "hench_i0_generic"


void main()
{
    // TK removed SendForHelp
//    SendForHelp();
	InitializeCreatureInformation(OBJECT_SELF);

    //Make sure the creature is commandable for the round
    SetCommandable(TRUE);
    //Clear all previous actions.
    ClearAllActions(TRUE);
    int nRandom = d10();
    //Roll a random int to determine this rounds effects
    if(nRandom  == 1)
    {
        ActionRandomWalk();
    }
    else if (nRandom >= 2 && nRandom  <= 5)
    {
        ClearAllActions(TRUE);
    }
    else if(nRandom >= 6 && nRandom <= 10)
    {
        ActionAttack(GetNearestObject(OBJECT_TYPE_CREATURE));
    }
    SetCommandable(FALSE);
}