//::///////////////////////////////////////////////
//:: On Blocked
//:: NW_CH_ACE
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This will cause blocked creatures to open
    or smash down doors depending on int and
    str.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 23, 2001
//:://////////////////////////////////////////////
// ChazM 2/21/07 Script deprecated. Use gb_assoc_* scripts instead.

#include "ginc_event_handlers"

void main()
{
    ConvertToAssociateEventHandler(CREATURE_SCRIPT_ON_BLOCKED_BY_DOOR, SCRIPT_ASSOC_BLOCK);
}    
/*

void main()
{
    object oDoor = GetBlockingDoor();

    if(GetIsDoorActionPossible(oDoor, DOOR_ACTION_OPEN) && GetAbilityScore(OBJECT_SELF, ABILITY_INTELLIGENCE) >= 3)
    {
        DoDoorAction(oDoor, DOOR_ACTION_OPEN);
    }
    else if(GetIsDoorActionPossible(oDoor, DOOR_ACTION_BASH) && GetAbilityScore(OBJECT_SELF, ABILITY_STRENGTH) >= 16)
    {
        DoDoorAction(oDoor, DOOR_ACTION_BASH);
    }
}
*/