//:://////////////////////////////////////////////////
//:: X0_CH_HEN_BLOCK
/*
  OnBlocked handler for henchmen/associates.
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 01/06/2003
//:://////////////////////////////////////////////////
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
    int nInt = GetAbilityScore(OBJECT_SELF, ABILITY_INTELLIGENCE);
    int nStr = GetAbilityScore(OBJECT_SELF, ABILITY_STRENGTH);

    if(GetIsDoorActionPossible(oDoor, DOOR_ACTION_OPEN) &&  nInt >= 3) {
        DoDoorAction(oDoor, DOOR_ACTION_OPEN);
    }

    else if(GetIsDoorActionPossible(oDoor, DOOR_ACTION_BASH) && nStr >= 16) {
        DoDoorAction(oDoor, DOOR_ACTION_BASH);
    }
}
*/