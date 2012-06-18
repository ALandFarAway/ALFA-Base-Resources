/////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_cs_settrapdet
//    $Revision::             $ current version of the file
//        $Date::             $ date the file was created or modified
//       Author : CorinTack
//
//    Var Prefix: ACR_CSA
//  Dependencies: None
//  Description
//  This file implements a change in trap detection DC, for a trap targeted 
//  by the SetDC wand.
//   arguments: takes an integer to add to the current detection DC.
//   note: If 0 is passed, the script will set the search DC to 0 instead.
//
//  Revision History
//  2007/12/03  CorinTack  Inception
//  2007/12/05  AcadiusLost ACR adaption
////////////////////////////////////////////////////////////////////////////////

/****************************************************
This script originally crafted by Corin Tack
****************************************************/

void main(int nSearchDC)
{
object oPC = GetPCSpeaker();
object oTarget = GetLocalObject(oPC, "ACR_CS_DMTARGET");
int nTargetDetectDC =  GetTrapDetectDC(oTarget);

SendMessageToPC(oPC, "Trap detection DC was previously at "+IntToString(nTargetDetectDC));
if (nSearchDC != 0) {
    // if we're trying to change the DC, work out the final number
    nSearchDC = nTargetDetectDC + nSearchDC;
}

SetTrapDetectDC(oTarget, nSearchDC);

SendMessageToPC(oPC, "Trap detect DC now set to "+IntToString(GetTrapDetectDC(oTarget)));
}

