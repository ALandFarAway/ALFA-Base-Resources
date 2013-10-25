////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_game_loc_i
//      Version : 0.1
//         Date : 10/31/07
//       Author : Ronan & AcadiusLost
//
//  Local Variable Prefix = ACR_GLC
//
//
//  Dependencies external of nwscript:
//
//  Description
//  This script provides functions to store and retreive in-game locations which
//  are recognizable across all servers, and stay valid across most module
//  updates.
//
//  Revision History
//   5/28/06: Ronan:  Inception
//  10/31/07 AcadiusLost  Added player locator function to be called from Heeds.
//	2011-05-28 Ronan: Removed acf_settings_i reference.
////////////////////////////////////////////////////////////////////////////////

#ifndef ACR_GAME_LOC_I
#define ACR_GAME_LOC_I

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

const string _ACR_GLC_LOCATION = "|ACR_GLC_L";
const string _ACR_GLC_AREA_TAG = "|ACR_GLC_T";
const string _ACR_GLC_AREA_RESREF = "|ACR_GLC_R";
const string _ACR_GLC_SERVER_ID = "|ACR_GLC_S";

// defines whether players can query the locations of PCs in their party
const string _ACR_GCL_PLAYER_PARTY_QUERY = "ACR_PLAYER_LOCATIONS";

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

struct GameLocation {
    location lLocation;
    string sAreaTag;
    string sAreaResRef;
    int nServerId;
};

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// Sets the game location lValue named sVarName on object oObject.
// Returns the starting position if the stored location cannot be found on this
// server.
void SetLocalGameLocation(object oObject, string sVarName, location lValue);

// Gets the game location named sVarName stored on oObject.
struct GameLocation GetLocalGameLocation(object oObject, string sVarName);

// Used to query and report PC locations to the server information window
//  will work for DMs at all times, will only work for PCs if the module has
//  "ACR_PLAYER_LOCATIONS" = TRUE.  Activated by Heed's PC Tools custom 2.
void ACR_ShowPlayerLocations(object oPC);

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_settings_i"
#include "acr_tools_i"

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

struct GameLocation GetLocalGameLocation(object oObject, string sVarName) {
    struct GameLocation strNewLocation;
    strNewLocation.lLocation = GetLocalLocation(oObject, sVarName + _ACR_GLC_LOCATION);
    strNewLocation.sAreaTag = GetLocalString(oObject, sVarName + _ACR_GLC_AREA_TAG);
    strNewLocation.sAreaResRef = GetLocalString(oObject, sVarName + _ACR_GLC_AREA_RESREF);
    strNewLocation.nServerId = GetLocalInt(oObject, sVarName + _ACR_GLC_SERVER_ID);
    object oArea = GetAreaFromTagAndResref(strNewLocation.sAreaResRef, strNewLocation.sAreaTag);
    if(oArea == OBJECT_INVALID) {
        strNewLocation.lLocation = GetStartingLocation();
    } else {
        strNewLocation.lLocation = GetLocationInDifferentArea(strNewLocation.lLocation, oArea);
    }
    return strNewLocation;
}

void SetLocalGameLocation(object oObject, string sVarName, location lValue) {
    object oArea = GetAreaFromLocation(lValue);
    SetLocalLocation(oObject, sVarName + _ACR_GLC_LOCATION, lValue);
    SetLocalString(oObject, sVarName + _ACR_GLC_AREA_TAG, GetTag(oArea) );
    SetLocalString(oObject, sVarName + _ACR_GLC_AREA_RESREF, GetResRef(oArea));
    SetLocalInt(oObject, sVarName + _ACR_GLC_SERVER_ID, ACR_GetServerId());
}

string GameLocationToString(struct GameLocation gloc) {
    return "Server: " + IntToString(gloc.nServerId) + ", Area tag: " + gloc.sAreaTag + ", Area resref: " + gloc.sAreaResRef;
}


void ACR_ShowPlayerLocations(object oPC) {

 
    // first, check if it's a DM calling.
    if (GetIsDM(oPC) || GetIsDMPossessed(oPC)) {
	    object oQueryPC = GetFirstPC();
		SendMessageToPC(oPC, "-> Listing all players on server:");
		SendMessageToPC(oPC, "----------------------------------");
		while (GetIsObjectValid(oQueryPC)) {
		    SendMessageToPC(oPC, GetFirstName(oQueryPC)+": "+GetName(GetArea(oQueryPC)));
			oQueryPC = GetNextPC();
		}
	} else if (GetLocalInt(GetModule(), _ACR_GCL_PLAYER_PARTY_QUERY)) {
	    object oLocated = GetFirstFactionMember(oPC);
		SendMessageToPC(oPC, "-> Listing party member locations:");
		SendMessageToPC(oPC, "-----------------------------------");
		while (GetIsObjectValid(oLocated)) {
		    SendMessageToPC(oPC, GetFirstName(oLocated)+": "+GetName(GetArea(oLocated)));
			oLocated = GetNextFactionMember(oPC);
		}
	} else {
	    SendMessageToPC(oPC, "Party member location is disabled.");
	}
	 	    
}

#endif