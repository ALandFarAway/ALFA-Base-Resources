////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_cs_guard_duty
//    $Revision:: 154       $
//        $Date:: 2006-10-1#$
//       Author : Petter Stene (Baalster)
//
//    Var Prefix: unique name comprised of 3 letter system and feature acronyms
//  Dependencies: See GuardDuty.txt
//  MANDATORY VARIABLES:
//      guard_door : tag of door
//      guard_waypoint : waypoint to return to after close
//  OPTIONAL VARIABLES:
//      guard_doordelay : number of seconds the door should remain open. Default 10 seconds.
//      guard_closedelay : number of seconds before NPC returns to waypoint.
//                         From start of open action. Default 15 seconds
//      guard_nolock : if set to 1, the door will not be locked/unlocked. Only opened/closed. Default 0
//      guard_nokey : if set to 1, a key is not required to lock/unlock. Default 0
//
//  Description
//  Script relies heavily on variables set on the NPC from which the Action Taken is performed.
//  Based on the variables, the gate and the waypoint it will move to the gate, unlock/open/close/lock
//  and then move back to it's starting waypoint. Called from a Guard Duty NPC conversation.
//
//  Revision History
//  2006-10-09 Baalster. Initial creation for NWN2
////////////////////////////////////////////////////////////////////////////////

void main()
{
    // Get the variables off the NPC guard
    // MANDATORY VARIABLES:
    //    guard_door : tag of door
    //    guard_waypoint : waypoint to return to after close
    // OPTIONAL VARIABLES:
    //    guard_doordelay : number of seconds the door should remain open.
    //    guard_closedelay : number of seconds before NPC returns to waypoint. From start of open action.
    //    guard_nolock : if set to 1, the door will not be locked/unlocked. Only opened/closed.
    //    guard_nokey : if set to 1, a key is not required to lock/unlock.

    object oDoor = GetObjectByTag(GetLocalString(OBJECT_SELF,"guard_door"));
    object oWaypoint = GetObjectByTag(GetLocalString(OBJECT_SELF,"guard_waypoint"));
    float fDoorDelay = GetLocalFloat(OBJECT_SELF,"guard_doordelay");
    float fCloseDelay = GetLocalFloat(OBJECT_SELF,"guard_closedelay");
    int nNolock = GetLocalInt(OBJECT_SELF,"guard_nolock");
    int nNokey = GetLocalInt(OBJECT_SELF,"guard_nokey");   
    float fDirection = GetFacing(OBJECT_SELF);

    // Make sure we have some reasonable default values. nNolock will default to 0.
    if (fDoorDelay == 0.0) { fDoorDelay=10.0; }
    if (fCloseDelay == 0.0) { fCloseDelay=15.0; }

    // Unlock if needed, and open
    if (!nNolock)
    {
        if (!nNokey)
        {
            AssignCommand(OBJECT_SELF, ActionUnlockObject(oDoor));
        }
        else
        {
            SetLocked(OBJECT_SELF, FALSE);
        }
    }

    AssignCommand(OBJECT_SELF, ActionOpenDoor(oDoor));

    // Close and lock if needed
    AssignCommand(OBJECT_SELF, DelayCommand(fDoorDelay, ActionCloseDoor(oDoor)));

    if (!nNolock)
    {
        if (!nNokey)
        {
            AssignCommand(OBJECT_SELF, DelayCommand((fDoorDelay + 1.0), ActionLockObject(oDoor)));
        }
        else
        {
            SetLocked(OBJECT_SELF, TRUE);
        }
    }

    // Move back to post waypoint and face correctly
    location lWaypoint = GetLocation(oWaypoint);
    AssignCommand(OBJECT_SELF, DelayCommand(fCloseDelay, ActionMoveToLocation(lWaypoint)));

    if (fDirection > 0.0) { AssignCommand(OBJECT_SELF, 2.0, SetFacing(fDirection); }
}

