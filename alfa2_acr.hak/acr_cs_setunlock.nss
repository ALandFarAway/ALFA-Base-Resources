/////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_cs_setunlock
//    $Revision::             $ current version of the file
//        $Date::             $ date the file was created or modified
//       Author : CorinTack
//
//    Var Prefix: ACR_CSA
//  Dependencies: None
//  Description
//  This file implements a change in unlock DC, for a door targeted with the SetDC wand.
//    arguments: takes an integer to add to the current unlock DC.
//   note: If 0 is passed, the script will set the unlock DC to 0 instead.
//
//  Revision History
//  2007/12/03  CorinTack  Inception
//  2007/12/05  AcadiusLost ACR adaption
////////////////////////////////////////////////////////////////////////////////

/****************************************************
This script originally crafted by Corin Tack
****************************************************/

void main(int nUnlockDC)
{
object oPC = GetPCSpeaker();
object oTarget = GetLocalObject(oPC, "ACR_CS_DMTARGET");
int nTargetDC = GetLockUnlockDC(oTarget);

SendMessageToPC(oPC, "Door unlock DC was previously at "+IntToString(nTargetDC));

if (nUnlockDC != 0) {
    // if we're trying to change the DC, work out the final number
    nUnlockDC =  nTargetDC + nUnlockDC;
}
    
SetLockUnlockDC(oTarget, nUnlockDC);
	
SendMessageToPC(oPC, "Door unlock DC now set to "+IntToString(GetLockUnlockDC(oTarget)));
}

