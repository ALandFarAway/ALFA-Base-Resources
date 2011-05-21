////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_cs_guard_out
//    $Revision:: 154       $
//        $Date:: 2006-10-1#$
//       Author : Petter Stene (Baalster)
//
//    Var Prefix: unique name comprised of 3 letter system and feature acronyms
//  Dependencies: OBJECT_SELF is an NPC with guard duty variables set. See GuardDuty.txt
//
//  guard_waypoint  :
//    tag should end with "_in" for a guard inside the gate
//   tag should end with "_out" for a guard outside the gate
//
//  Description
//  Script is a starting condition which determines whether the guard is placed
//  on the inside or outside of the gate. The purpose is to use the same script
//  and conversation file for both the inside and outside guards.
//
//  This SC returns true if the "guard_waypoint" local variable string on the guard contain "_out".
//  Used in Guard Duty NPC conversations.
//
//  Revision History
//  2006-10-09 Baalster Initial creation for NWN2
////////////////////////////////////////////////////////////////////////////////

int StartingConditional()
{
   return (FindSubString(GetLocalString(OBJECT_SELF, "guard_waypoint"), "_out") > 1);
}

