//  System Name : ALFA Core Rules
//     Filename : i_abr_it_dmprcvalidate_ac
//    $Revision::             $ current version of the file
//        $Date::             $ date the file was created or modified
//       Author : AcadiusLost

//  Dependencies: None
//  Description
//  This script handles granting or removal of the PrC Validation feat
//     which is required by any PC who wishes to take a level in a Prestige Class.
//
//  Revision History
//  2008/12/13  AcadiusLost  Inception
////////////////////////////////////////////////////////////////////////////////
#include "acr_1984_i"

void main()
{
object oTarget =  GetItemActivatedTarget();
object oUser = GetItemActivator();
if(oUser == OBJECT_INVALID)
		{oUser = OBJECT_SELF;
		}
  

if (!GetIsDM(oUser)) {
	SendMessageToAllDMs("PC "+GetName(oUser)+" Attempted to use PrC Validation widget in area "+GetName(GetArea(oUser))+"!!");
	return;
}
if (GetHasFeat(3500, oTarget)) {
	FeatRemove(oTarget, 3500);
	// make sure the change "sticks"
	ExportSingleCharacter(oTarget);
	SendMessageToPC(oUser, "PrC Validation feat removed from "+GetName(oTarget)+".");
	SendMessageToPC(oTarget, "PrC Validation feat has been removed.");
	ACR_LogEvent(oTarget, "PrC Validation", "Removal of the DM Permission Feat.", oUser);
} else {
	// PC doesn't have PrC Validation feat, so add it.
	FeatAdd(oTarget, 3500, FALSE, FALSE, TRUE);
	// make sure the change "sticks"
	ExportSingleCharacter(oTarget);
	SendMessageToPC(oUser, "PrC Validation feat added to "+GetName(oTarget)+".");
	SendMessageToPC(oTarget, "You have now been validated to allow leveling into a Prestige Class, once you meet the other formal requirements.");
	ACR_LogEvent(oTarget, "PrC Validation", "DM permission feat granted.", oUser);
}	

}		