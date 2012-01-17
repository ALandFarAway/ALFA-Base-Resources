//  System Name : ALFA Core Rules
//     Filename : i_acr_dmexamine_ac
//    $Revision::             $ current version of the file
//        $Date::             $ date the file was created or modified
//       Author : AcadiusLost

//  Dependencies: None
//  Description
//  This script handles activation of the dc setter wand, for traps and doors.
//
//  Revision History
//  2008/11/03  AcadiusLost  Inception
////////////////////////////////////////////////////////////////////////////////


void main()
{
object oTarget =  GetItemActivatedTarget();
object oUser = GetItemActivator();

string sDescription = GetDescription(oTarget);
SendMessageToPC(oUser, "Description field for object "+GetName(oTarget));
SendMessageToPC(oUser, "With tag = "+GetTag(oTarget));
SendMessageToPC(oUser, "-----------------------");
SendMessageToPC(oUser, sDescription);

}		