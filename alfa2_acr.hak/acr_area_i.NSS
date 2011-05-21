////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_area_i.nss
//      Version : 0.5
//         Date : 1/24/2009
//       Author : Ronan & AcadiusLost
//
//  Local Variable Prefix =
//
//
//  Dependencies external of nwscript:
//     acr_spawn_i : needed for prespawning with area transitions.
//
//  Description
//  This script contains all the ACR handlers for area events.
//
//  Revision History
//      0.1 5/13/06 Ronan: initial version
//      0.2 3/7/07 AcadiusLost: added hook for ACR_SpawnOnAreaExit()
//      0.3 3/18/07 AcadiusLost: Moved ACR_OnAreaTransitionClick() in from 
//                    acr_area_transition_i.nss, which will be discontinued.
//      0.4 3/25/07 AcadiusLost: Differentiated between the prespawn call from
//                    OnAreaTransitionClick, and the OnEnter spawn system call.
//      0.5 7.18.07 AcadiusLost: Added ACR_PCSave() to OnAreaLoad() for PCs.
//      0.6 9.04.08 AcadiusLost: added target safety checks from seamless ATs
//		0.7 1.24.09 AcadiusLost: Added conditional for GetIsPC() on AT click.
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_spawn_i"
#include "acr_pps_i"
#include "acr_seamlessat_i"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// Handles an area's OnHeartbeat event for the ACR.
void ACR_AreaOnHeartbeat();

// Handles an area's OnEnter event for the ACR.
void ACR_AreaOnEnter();

// Handles an area's OnExit event for the ACR.
void ACR_AreaOnExit();

// Handles an area's OnClientEnter event for the ACR.
void ACR_AreaOnClientEnter();

// Handles an area's OnUserDefined event for the ACR.
void ACR_AreaOnUserDefined();

// Event handler for a creature clicking on any sort of area transition.
void ACR_OnAreaTransitionClick();

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void ACR_AreaOnHeartbeat() {
}

void ACR_AreaOnEnter() {
    object oObject = GetEnteringObject();
	ACR_SpawnOnAreaEnter(oObject);
    if(GetIsPC(oObject) || GetIsDMPossessed(oObject)) {
        // Code which only runs for PCs goes here.
    } else {
        // Code which only runs for NPCs goes here.
    }
    // Code which runs for PCs and NPCs goes here.
}

void ACR_AreaOnExit() {
    object oObject = GetExitingObject();
    if(GetIsPC(oObject) || GetIsDMPossessed(oObject)) {
         ACR_SpawnOnAreaExit(oObject);
        // Code which only runs for PCs goes here.
    } else {
        // Code which only runs for NPCs goes here.
    }
    // Code which runs for PCs and NPCs goes here.
}

void ACR_AreaOnClientEnter() {
    // Fires after OnEnter, when the client finishes loading the area, it seems.
	object oObject = GetEnteringObject();

	if(GetIsPC(oObject) || GetIsDMPossessed(oObject)) {
        // Code which only runs for PCs goes here.
	    SendMessageToPC(oObject, "Entering area "+GetName(OBJECT_SELF));
		ACR_PCSave(oObject, FALSE);
    } else {
        // Code which only runs for NPCs goes here.
    }
}

void ACR_AreaOnUserDefined() {
    // Probably won't be used.
}


void ACR_OnAreaTransitionClick() {
    object oClicker = GetClickingObject();
    object oTarget = GetTransitionTarget(OBJECT_SELF);
    object oTargetArea = GetArea(oTarget);

	if (GetIsPC(oClicker)) {
		// NPCs don't need AT warnings/feedback
		// this function handles transitioning as well.
		ACR_CheckAT(oClicker);
	} else {
		AssignCommand(oClicker,JumpToObject(oTarget));
	}
    // Set the AT screen randomly.
    //SetAreaTransitionBMP(AREA_TRANSITION_RANDOM);
    
}