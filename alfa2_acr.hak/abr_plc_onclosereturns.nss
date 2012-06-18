////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ACR Configuration File
//     Filename : abr_plc_oncloseReturns.nss
//    $Revision:: 1        $ current version of the file
//        $Date:: 2010-03-20#$ date the file was created or modified
//       Author : AcadiusLost
//
//  Local Variable Prefix =
//
//  Dependencies external of nwscript:
//		acr_placeable_i (normal hooks)
//		acr_spawn_i (for variables to check spawn type/name)
//
//  Description
//  This script manages scripted "Returns" bins for merchants.
//
//  Revision History
//	2009-02-01  AcadiusLost: Inception
//  2009-02-10  AcadiusLost: Added updated of the ACR_GOLD cached LocalInt on Refund.
//  2010-03-20  AcadiusLost: Updated for better logging
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_placeable_i"
#include "acr_spawn_i"
#include "acr_1984_i"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// name of the pointer variable for tracking who is owed a refund on an item.
const string _ACR_RTN_POINTER = "ACR_RETURNS_POINTER";

// name of the Local String variable that identifies where the object was bought.
const string _ACR_RTN_MERCHANT = "ACR_RETURNS_MERCHANT";

// name of the Local Integer that attempts to record the actual purchased price of an item.
const string _ACR_RTN_VALUE = "ACR_RETURNS_VALUE";

// radius to check for a store or store spawn
const float _ACR_RTN_RADIUS = 7.5;

// Percent value returned to the PC on returning the item promptly.
const int _ACR_RTN_PERCENT = 80;

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

    ACR_PlaceableOnClose();
	
	object oCloser = GetLastClosedBy();
	// this can be set in the toolset.  If it's missing, try to find one valid.
	string sStoreResRef = GetLocalString(OBJECT_SELF, _ACR_RTN_MERCHANT);
	if (sStoreResRef == "") {
		// first, try picking the store up from the closing PC.
		object oTrigger = GetLocalObject(oCloser, _ACR_RTN_POINTER);
		object oTargetStore = GetLocalObject(oTrigger, _ACR_RTN_POINTER);
		sStoreResRef = GetResRef(oTargetStore);
	}
	if (sStoreResRef == "") {
		// check for nearby stores to try to pick up the right one to refer to.
		float fRadius = 0.0;
		float fRange = 0.0;
		int bSuccess = FALSE;
		int nNum = 1;
		// look for spawned stores first, since that's what ALFA uses primarily
		object oWP = GetNearestObject(OBJECT_TYPE_WAYPOINT, OBJECT_SELF);
		while (GetIsObjectValid(oWP)) {
			fRange = GetDistanceToObject(oWP);
			if ((fRange <= _ACR_RTN_RADIUS) && (fRange > 0.0)) {
				// waypoint within range, check it
				if (GetLocalInt(oWP, _WP_SPAWN_TYPE) == 3) {
					// store spawn!  Assume this is it.
					sStoreResRef = GetLocalString(oWP, "ACR_SPAWN_RESNAME_1");
					SetLocalString(OBJECT_SELF, _ACR_RTN_MERCHANT, sStoreResRef);
					
					bSuccess = TRUE;
					// now, set the oWP invalid so we don't waste more CPU cycles.
					oWP = OBJECT_INVALID;
				} else {
					nNum = nNum + 1;
					oWP = GetNearestObject(OBJECT_TYPE_WAYPOINT, OBJECT_SELF, nNum);
				}
			} else {
				// closest waypoint is outside the radius, don't bother checking any more.
				oWP = OBJECT_INVALID;
			}
		}
		if (!bSuccess) {
			// Didn't find a store waypoint in range, check for the closest placed store.
			object oStore = GetNearestObject(OBJECT_TYPE_STORE, OBJECT_SELF);
			fRange = GetDistanceToObject(oStore);
			if ((fRange <= _ACR_RTN_RADIUS) && (fRange > 0.0)) {
				// Store in range, assume this is it.
				sStoreResRef = GetResRef(oStore);
				SetLocalString(OBJECT_SELF, _ACR_RTN_MERCHANT, sStoreResRef);
				oStore = OBJECT_INVALID;
				bSuccess = TRUE;
			}
		}
		// if we still don't have a store resref, give up.
		if (!bSuccess) {
			ActionSpeakString("Could not find a store to associate with.");
			WriteTimestampedLogEntry("ACR Returns Bins: Failed to associate with a valid store in area: "+GetName(GetArea(OBJECT_SELF))+", after being closed by PC: "+GetName(oCloser));
			return;
		}
	}

	int nValue = 0;
	object oItem = GetFirstItemInInventory();
	object oReturner = GetLocalObject(oItem, _ACR_RTN_POINTER);
	while (GetIsObjectValid(oItem)) {
		// valid object, loop through and deal with inventory
		if (!GetIsObjectValid(oReturner)) {
			// Could not get the PC who turned in the item.
			ActionSpeakString("Could not find an owner for "+GetName(oItem));
		} else if (GetLocalString(oItem, _ACR_RTN_MERCHANT) == sStoreResRef) {
			// Item was bought from the appropriate store, calculate and issue a refund.
			nValue = GetLocalInt(oItem, _ACR_RTN_VALUE);
			// grab the actual purchase price, if possible.
			if (nValue == 0) {
				nValue = GetGoldPieceValue(oItem);
				if (nValue > 5) {
					// for anything with a significant cost, apply a return markdown.
					nValue = (nValue * _ACR_RTN_PERCENT) / 100;
				} 
			}
			if (nValue > 0 ) {
				SendMessageToPC(oReturner, "Item: "+GetName(oItem)+" has been returned for a refund.");
				GiveGoldToCreature(oReturner, nValue);
				ACR_LogEvent(oReturner, "Refund", "Received "+IntToString(nValue)+" gp for returning item from "+sStoreResRef+".");
				WriteTimestampedLogEntry("ACR Returns Bins: PC "+GetName(oReturner)+" received "+IntToString(nValue)+" gp for returning a "+IntToString(GetGoldPieceValue(oItem))+" gp value item with resref: "+GetResRef(oItem)+" from "+sStoreResRef+" in area "+GetName(GetArea(oReturner))+".");
				DestroyObject(oItem);
				SetLocalInt(oReturner, "ACR_GOLD", GetGold(oReturner));
			} else {
				SendMessageToPC(oReturner, "Error: value calulated at "+IntToString(nValue)+".");
				WriteTimestampedLogEntry("ACR Returns Bins: ERROR- PC "+GetName(oReturner)+" got calculated value "+IntToString(nValue)+" gp when attempting to return a "+IntToString(GetGoldPieceValue(oItem))+" gp value item with resref: "+GetResRef(oItem)+" purchased from "+sStoreResRef+" in area "+GetName(GetArea(oReturner))+".");
			}
		} else {
			// object was turned in by oReturner, but not valid for return.
			SendMessageToPC(oReturner, "Object: "+GetName(oItem)+" can not be returned. Please recover it if you still want it.");
			ActionGiveItem(oItem, oReturner);
		}
		oItem = GetNextItemInInventory();
	}		
		
}

