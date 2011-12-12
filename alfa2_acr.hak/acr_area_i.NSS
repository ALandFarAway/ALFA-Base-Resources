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

// The last area object id is stored in this local on a PC so as to only fire
// the actual ACR_AreaOnClientEnter event once per area, even if the PC is
// joined to a party.
const string ACR_AREA_LAST_AREA_CLIENTENTER_VAR = "ACR_AREA_LAST_AREA_CLIENTENTER_VAR";

const float ACR_AREA_TRANSITION_SEARCH_RADIUS = 5.0f;

const float ACR_AREA_TRANSITION_SIGMA_EXP = 1.1f;
const float ACR_AREA_TRANSITION_SIGMA_INIT = 0.5f;
const float ACR_AREA_TRANSITION_SIGMA_MAX = 10.0f;

const float ACR_AREA_TRANSITION_ZDIFF_MAX = 1.0f;

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
// ! Returns:  TRUE if the OnClientEnter event should be processed, else FALSE
//             if the caller should stop handling the event immediately.
int ACR_AreaOnClientEnter();

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

int ACR_AreaOnClientEnter() {
    // Fires after OnEnter, when the client finishes loading the area, it seems.
	object oObject = GetEnteringObject();
	object Area = GetArea(oObject);

	if (Area == GetLocalObject(oObject, ACR_AREA_LAST_AREA_CLIENTENTER_VAR))
	{
		// We may receive this event again if another party member has finished
		// area loading and we were still waiting to clear the loading screen,
		// even if this wasn't a party transition.  Only perform significant
		// processing the first time around.

		return FALSE;
	}

	SetLocalObject(oObject, ACR_AREA_LAST_AREA_CLIENTENTER_VAR, Area);

	if(GetIsPC(oObject) || GetIsDMPossessed(oObject)) {
        // Code which only runs for PCs goes here.
	    SendMessageToPC(oObject, "Entering area "+GetName(OBJECT_SELF));
		ACR_PCSave(oObject, FALSE);
    } else {
        // Code which only runs for NPCs goes here.
    }
	 return TRUE;
}

void ACR_AreaOnUserDefined() {
    // Probably won't be used.
}


void ACR_OnAreaTransitionClick()
{
	object oClicker, oTarget, oTargetArea;
	location lTarget, l, lClicker;
	vector vtarg, v, tmp;
	float face,sigma = ACR_AREA_TRANSITION_SIGMA_INIT;

	oClicker = GetClickingObject();
	oTarget = GetTransitionTarget(OBJECT_SELF);
	oTargetArea = GetArea(oTarget);
	lTarget = GetLocation(oTarget);
	lClicker = GetLocation(oClicker);

	// We need to confirm that this goes somewhere
	lTarget = CalcSafeLocation(oClicker, lTarget, ACR_AREA_TRANSITION_SEARCH_RADIUS, FALSE, FALSE);
	
	// Simple search failed, AT destination is invalid
	if (lTarget == lClicker) {

		// A decent destination is cached, exit
		if (l != GetLocalLocation(OBJECT_SELF, "ACR_TRANSITION_TARGET")) {
			lTarget = GetLocalLocation(OBJECT_SELF, "ACR_TRANSITION_TARGET");
		}
		// destination object is valid but not location
		else if (oTarget != OBJECT_INVALID) {
			WriteTimestampedLogEntry("AT destination search invoked for "+GetTag(GetArea(oClicker))+"->"+GetTag(oTargetArea));
			vtarg = GetPosition(oTarget);

			// search
			while (lTarget == lClicker) {
	
				v = vtarg;
		
				tmp.x = v.x;
				tmp.y = v.y;
				tmp.z = 0.0f;
		
				// random perturbation, mean x variance sigma^2
				v.x = ACR_RandomNormal(v.x,sigma);
				v.y = ACR_RandomNormal(v.y,sigma);
				v.z = 0.0f;
		
				// orientation away from door
				tmp.x = v.x - tmp.x;
				tmp.y = v.y - tmp.y;
		
				face = VectorToAngle(tmp);

				lTarget = CalcSafeLocation(oClicker, Location(oTargetArea,v,face), ACR_AREA_TRANSITION_SEARCH_RADIUS, FALSE, FALSE);

				tmp = GetPositionFromLocation(lTarget);

				// reject anything that has a large zdiff
				// e.g. we are being ported down/up to a strange location
				if (fabs(tmp.z - vtarg.z) > ACR_AREA_TRANSITION_ZDIFF_MAX)
					lTarget = lClicker;
		
				if (lTarget == lClicker) {
					// increase exponentially
					sigma *= ACR_AREA_TRANSITION_SIGMA_EXP;

					// Cancel out if beyond some limit
					if (sigma > ACR_AREA_TRANSITION_SIGMA_MAX)
						break;
		
				}
				// correct, let's just cache
				else
					SetLocalLocation(OBJECT_SELF, "ACR_TRANSITION_TARGET", lTarget);
		
			}
		}
	}
			


	if (GetIsPC(oClicker)) {
		// NPCs don't need AT warnings/feedback
		// this function handles transitioning as well.
		ACR_CheckAT(oClicker, lTarget);
	} else {
		AssignCommand(oClicker,JumpToLocation(lTarget));
	}
    // Set the AT screen randomly.
    //SetAreaTransitionBMP(AREA_TRANSITION_RANDOM);
    
}
