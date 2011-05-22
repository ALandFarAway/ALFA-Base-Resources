//::///////////////////////////////////////////////
//:: Insane Heartbeat Support Script
//:: nw_g0_insane
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
    This heartbeat script runs on any creature
    that has been hit with the insanity effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo
//:: Created On: 04/16/2007
//:://////////////////////////////////////////////


#include "x0_inc_henai"

#include "hench_i0_generic"

void main()
{
//    SendForHelp();
    InitializeCreatureInformation(OBJECT_SELF);

    SetCommandable(TRUE);	//Make sure the creature is commandable for the round
	
    ClearAllActions(TRUE);	//Clear all previous actions.
	
    ActionAttack(GetNearestObject(OBJECT_TYPE_CREATURE));
	
    SetCommandable(FALSE);
}