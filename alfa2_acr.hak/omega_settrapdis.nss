/////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_cs_settrapdis
//    $Revision::             $ current version of the file
//        $Date::             $ date the file was created or modified
//       Author : CorinTack
//
//    Var Prefix: ACR_CSA
//  Dependencies: None
//  Description
//  This file implements a change in trap disarm DC, for a trap targeted 
//  by the SetDC wand.
//   arguments: takes an integer to add to the current disarm DC.
//   note: If 0 is passed, the script will set the disarm DC to 0 instead.
//
//  Revision History
//  2007/12/03  CorinTack  Inception
//  2007/12/05  AcadiusLost ACR adaption
////////////////////////////////////////////////////////////////////////////////

/****************************************************
This script originally crafted by Corin Tack
****************************************************/

void main(int nDisarmDC)
{
object oDM = OBJECT_SELF;
object oTarget = GetLocalObject(oDM, "Object_Target");
int nTargetDisarmDC = GetTrapDisarmDC(oTarget);

SendMessageToPC(oDM, "Trap disarm DC was previously at "+IntToString(nTargetDisarmDC));

if (nDisarmDC != 0) {
    // if we're trying to change the DC, work out the final number
    nDisarmDC = nTargetDisarmDC + nDisarmDC;
}

SetTrapDisarmDC(oTarget, nDisarmDC);

SendMessageToPC(oDM, "Trap disarm DC now set to "+IntToString(GetTrapDisarmDC(oTarget)));
}