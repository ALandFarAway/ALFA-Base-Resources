//::///////////////////////////////////////////////
//:: Rebuked Heartbeat
//:: NW_G0_REBUKED
//:: Copyright (c) 2006 Obsidian Entertainment Inc
//:://////////////////////////////////////////////
/*
	When an undead becomes rebuked, this script plays on their heartbeat,
	preventing them from fighting back or doing much of anything.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On:  08.08.06
//:://////////////////////////////////////////////

#include "x0_inc_henai"

void main()
{    
    //Allow the target to recieve commands for the round
    SetCommandable(TRUE);

    ClearAllActions();

    //Disable the ability to recieve commands.
    SetCommandable(FALSE);
}