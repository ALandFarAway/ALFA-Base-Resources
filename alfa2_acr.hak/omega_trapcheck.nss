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
object oDM = OBJECT_SELF;
object oTarget = GetLocalObject(oDM, "Object_Target");

if(GetLocalInt(oTarget, "DM_Trapped") == 1)
	return TRUE;
else
	return FALSE;
}