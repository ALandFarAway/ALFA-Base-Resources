////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ABR Store OnOpen Script
//     Filename : abr_storeopen.nss
//    $Revision:: 1        $ current version of the file
//        $Date:: 2009-02-21#$ date the file was created or modified
//       Author : AcadiusLost
//
//  Local Variable Prefix =
//
//  Dependencies external of nwscript:
//
//  Description
//  This script sets up pointers for logging and merchant returns.
//
//  Revision History
//    2009-02-01  AcadiusLost: Inception
//    2009-02-21  AcadiusLost: Fix for non-returns stores.
////////////////////////////////////////////////////////////////////////////////


// name of the pointer variable for tracking who is owed a refund on an item.
const string _ACR_RTN_POINTER = "ACR_RETURNS_POINTER";

void main() {


object oPC = GetLastOpenedBy();
object oReturnsTrigger = GetLocalObject(oPC, _ACR_RTN_POINTER);
SetLocalInt(oPC, "ACR_GOLD", GetGold(oPC));

if (oReturnsTrigger != OBJECT_INVALID) {
	// PC is inside a Returns trigger, should be good to go
	// SendMessageToPC(oPC, "Gold stored: "+IntToString(GetGold(oPC)));
	SetLocalObject(oReturnsTrigger, _ACR_RTN_POINTER, OBJECT_SELF);
	SetLocalObject(oPC, "ACR_STORE", OBJECT_SELF);
}
}