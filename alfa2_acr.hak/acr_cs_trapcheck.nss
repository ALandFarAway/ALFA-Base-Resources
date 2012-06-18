/////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_cs_trapcheck
//    $Revision::             $ current version of the file
//        $Date::             $ date the file was created or modified
//       Author : CorinTack
//
//    Var Prefix: ACR_CSA
//  Dependencies: None
//  Description
//  This script checks the current target to see if it trapped, or is a trap.
//   returns: TRUE (1) if target is trapped
//  		  FALSE (0) if target is not trapped.
//
//  Revision History
//  2007/12/03  CorinTack  Inception
//  2007/12/05  AcadiusLost ACR adaption, switched to use DM client targeting
////////////////////////////////////////////////////////////////////////////////

/****************************************************
This script originally crafted by Corin Tack
****************************************************/

int StartingConditional()
{
object oPC = GetPCSpeaker();
object oTarget = GetLocalObject(oPC, "ACR_CS_DMTARGET");

if(GetIsTrapped(oTarget))
	return TRUE;
else
	return FALSE;
}

