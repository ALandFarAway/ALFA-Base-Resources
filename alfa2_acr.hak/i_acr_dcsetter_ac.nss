//  System Name : ALFA Core Rules
//     Filename : i_acr_dcsetter_ac
//    $Revision::             $ current version of the file
//        $Date::             $ date the file was created or modified
//       Author : CorinTack
//
//    Var Prefix: ACR_CSA
//  Dependencies: None
//  Description
//  This script handles activation of the dc setter wand, for traps and doors.
//
//  Revision History
//  2007/12/03  CorinTack  Inception
//  2007/12/17  AcadiusLost ACR adaption
////////////////////////////////////////////////////////////////////////////////

/****************************************************
This script originally crafted by Corin Tack
****************************************************/

void main()
{
object oTarget =  GetItemActivatedTarget();
object oUser = GetItemActivator();
int nTargetType = GetObjectType(oTarget);

if ((nTargetType == OBJECT_TYPE_DOOR) || (nTargetType == OBJECT_TYPE_TRIGGER)) { 
    SetLocalObject(oUser, "ACR_CS_DMTARGET", oTarget);
	
} else {
    location lTarget = GetItemActivatedTargetLocation();
	oTarget = GetNearestObjectToLocation(OBJECT_TYPE_TRIGGER, lTarget);
	SetLocalObject(oUser, "ACR_CS_DMTARGET", oTarget);
}
SendMessageToPC(oUser, "Unlock DC = "+IntToString(GetLockUnlockDC(oTarget)));
SendMessageToPC(oUser, "Detect DC = "+IntToString(GetTrapDetectDC(oTarget)));
SendMessageToPC(oUser, "Disarm DC = "+IntToString(GetTrapDisarmDC(oTarget)));

AssignCommand(oUser, ActionStartConversation(oUser, "acr_dcsetter", TRUE, FALSE));
}		