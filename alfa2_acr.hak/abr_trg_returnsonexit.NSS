////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ABR Store Returns System
//     Filename : abr_trg_returnsonexit.nss
//    $Revision:: 1        $ current version of the file
//        $Date:: 2009-02-09#$ date the file was created or modified
//       Author : AcadiusLost
//
//  Local Variable Prefix =
//
//  Dependencies external of nwscript:
//
//  Description
//  This script cleans up variables and pointers for the returns bin system for ACR merchants.
//
//  Revision History
//  2009-02-01  AcadiusLost:  Inception
//  2009-02-09  AcadiusLost:  Added cleanup for a LocalInt on the PC, added head to inventory slots checked.
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_trigger_i"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// name of the pointer variable for tracking who is owed a refund on an item.
const string _ACR_RTN_POINTER = "ACR_RETURNS_POINTER";

// name of the Local String variable that identifies where the object was bought.
const string _ACR_RTN_MERCHANT = "ACR_RETURNS_MERCHANT";

// name of the Local Integer that attempts to record the actual purchased price of an item.
const string _ACR_RTN_VALUE = "ACR_RETURNS_VALUE";

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// The main event handler.
void main();

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void main() {
    ACR_TriggerOnExit();

    // Custom code goes here.
	object oPC = GetExitingObject();
	object oTestItem = GetFirstItemInInventory(oPC);
	string sTest = "";
	SendMessageToPC(oPC, "Now leaving store area.");
	while (oTestItem != OBJECT_INVALID) {
		// check for items bought here to clear the merchant stamp
		sTest = GetLocalString(oTestItem, _ACR_RTN_MERCHANT);
		if (sTest != "") {
			// item had a variable, clear it (leaving shop area)
			DeleteLocalString(oTestItem, _ACR_RTN_MERCHANT);
			DeleteLocalString(oTestItem, _ACR_RTN_VALUE);
			SendMessageToPC(oPC, "Item: "+GetName(oTestItem)+" can no longer be returned for full purchase cost.");
		}
		oTestItem = GetNextItemInInventory(oPC);
	}
	int nIndex = 0; // 0 = INVENTORY_SLOT_HEAD
	while (nIndex <= 18) {
		// loop through all 18 possible inventory slots to remove return variables.
		oTestItem = GetItemInSlot(nIndex, oPC);
		sTest = GetLocalString(oTestItem, _ACR_RTN_MERCHANT);
		if (sTest != "") {
			// item had a variable, clear it (leaving shop area)
			DeleteLocalString(oTestItem, _ACR_RTN_MERCHANT);
			DeleteLocalString(oTestItem, _ACR_RTN_VALUE);
			SendMessageToPC(oPC, "Equipped item: "+GetName(oTestItem)+" can no longer be returned for full purchase cost.");
		}
		nIndex = nIndex + 1;
	}
	DeleteLocalObject(oPC, _ACR_RTN_POINTER);
	DeleteLocalInt(oPC, "ACR_RETURNS");

}