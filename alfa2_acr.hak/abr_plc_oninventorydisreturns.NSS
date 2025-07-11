////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ACR Configuration File
//     Filename : abr_plc_oninventorydisReturns.nss
//    $Revision:: 1        $ current version of the file
//        $Date:: 2000-02-01#$ date the file was created or modified
//       Author : AcadiusLost
//
//  Local Variable Prefix =
//
//  Dependencies external of nwscript:
//
//  Description
//  This script calls the ACR's OnDisturbed code for Returns bins.
//
//  Revision History
//	2009-02-01  AcadiusLost: Inception
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_placeable_i"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// name of the pointer variable for tracking who is owed a refund on an item.
const string _ACR_RTN_POINTER = "ACR_RETURNS_POINTER";

// name of the Local String variable that identifies where the object was bought.
const string _ACR_RTN_MERCHANT = "ACR_RETURNS_MERCHANT";

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
    ACR_PlaceableOnDisturbed();

    // Custom code goes here.
	int nDisturbType = GetInventoryDisturbType();
	object oPC = GetLastDisturbed();
	object oItem = GetInventoryDisturbItem();
	if (nDisturbType == INVENTORY_DISTURB_TYPE_ADDED) {
		// item has been added to the Returns bin.  Add a pointer back to the
		//  PC that added it to the Returns Bin (for gold, or for returning to inventory
		SetLocalObject(oItem, _ACR_RTN_POINTER, oPC);
	} else if ((nDisturbType == INVENTORY_DISTURB_TYPE_REMOVED) || (nDisturbType == INVENTORY_DISTURB_TYPE_STOLEN)) {
		// item has been removed, so the original giver isn't really valid anymore.
		DeleteLocalObject(oItem, _ACR_RTN_POINTER);
	}
}