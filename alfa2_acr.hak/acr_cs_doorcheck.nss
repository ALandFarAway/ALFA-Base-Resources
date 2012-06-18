/////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_cs_doorcheck
//    $Revision::             $ current version of the file
//        $Date::             $ date the file was created or modified
//       Author : CorinTack
//
//    Var Prefix: ACR_CSA
//  Dependencies: None
//  Description
//  This script checks the current target to see if it is a door.
//   returns: TRUE (1) if target is a door
//  		  FALSE (0) if target is not a door.
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

if(GetObjectType(oTarget) == OBJECT_TYPE_DOOR)
	return TRUE;
else
	return FALSE;
}

