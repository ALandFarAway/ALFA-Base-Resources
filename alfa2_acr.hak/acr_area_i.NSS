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

// Handles the display of loading screens in accordance with knowledge skills and
// the conventions set forth by the DM teams. It defaults to one of the 60ish
// generic screens on failure.
void ACR_SetLoadingScreen(object oClicker);

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
	int bValid = TRUE;
	location lTarget;

	oClicker = GetClickingObject();
	oTarget = GetTransitionTarget(OBJECT_SELF);
	oTargetArea = GetArea(oTarget);
	lTarget = GetLocation(oTarget);

	// confirm that this goes somewhere
	if (!GetIsLocationValid(lTarget)) {

		// A decent destination is cached, exit
		if (LOCATION_INVALID != GetLocalLocation(OBJECT_SELF, "ACR_TRANSITION_TARGET")) {
			lTarget = GetLocalLocation(OBJECT_SELF, "ACR_TRANSITION_TARGET");
		}
		// destination object is valid but not location
		else if (oTarget != OBJECT_INVALID) {
			WriteTimestampedLogEntry("AT destination search invoked for "+GetTag(GetArea(oClicker))+"->"+GetTag(oTargetArea));
			lTarget = ACR_CalcSafeLocation(oClicker, GetLocation(oTarget));
		

			if (LOCATION_INVALID != lTarget) 
				SetLocalLocation(OBJECT_SELF, "ACR_TRANSITION_TARGET", lTarget);
			
		}
		bValid = FALSE;
	}
			

	if (GetIsPC(oClicker)) {
		// NPCs don't need AT warnings/feedback
		// this function handles transitioning as well.
		ACR_SetLoadingScreen(object oClicker);
		if (bValid)
			ACR_CheckAT(oClicker, oTarget, lTarget);
		else
			ACR_CheckAT(oClicker, OBJECT_INVALID, lTarget);
	} else {
		if (bValid)
			AssignCommand(oClicker, JumpToObject(oTarget));
		else
			AssignCommand(oClicker, JumpToLocation(lTarget));
	}

	// Set the AT screen randomly.
	//SetAreaTransitionBMP(AREA_TRANSITION_RANDOM);
}

void ACR_SetLoadingScreen(object oClicker)
{
    string sScreen = "";
    int nCheck = Random(11);
    if(nCheck == 0) // coming soon
    {
        sScreen = "ALFA_projects_0"+IntToString(d6(1));
    }
    else if(nCheck == 1) // Knowledge: Arcana
    {
    }
    else if(nCheck == 2) // Knowledge: Architecture and Engineering
    {
    }
    else if(nCheck == 3) // Knowledge: Dungeoneering
    {
    }
    else if(nCheck == 4) // Knowledge: Geography
    {
    }
    else if(nCheck == 5) // Knowledge: History
    {
        if(GetSkillRank(SKILL_KNOWLEDGE_HISTORY, oClicker, TRUE) > 0 ||
           GetAbilityScore(oClicker, ABILITY_INTELLIGENCE, TRUE) >= 10)
        {
            sScreen = "FR_his_com_";
            string sNumber = IntToString(Random(10)+1);
            if(GetStringLength(sNumber) == 1) sScreen = sScreen + "0";
            sScreen = sScreen + sNumber;
        }
    }
    else if(nCheck == 6) // Knowledge: Local
    {
    }
    else if(nCheck == 7) // Knowledge: Nature
    {
    }
    else if(nCheck == 8) // Knowledge: Nobility and Royalty
    {
    }
    else if(nCheck == 9) // Knowledge: Religion
    {
        if(GetSkillRank(SKILL_KNOWLEDGE_RELIGION, oClicker, TRUE) > 0 ||
           GetAbilityScore(oClicker, ABILITY_INTELLIGENCE, TRUE) >= 10)
        {
            sScreen = "FR_rel_com_";
            string sNumber = IntToString(Random(15)+1);
            if(GetStringLength(sNumber) == 1) sScreen = sScreen + "0";
            sScreen = sScreen + sNumber;
        }
    }
    else if(nCheck == 10) // Knowledge: The Planes
    {
    }

    if(sScreen != "")
        AssignCommand(oClicker, SetAreaTransitionBMP(AREA_TRANSITION_USER_DEFINED, sScreen));

//=== The generic screens are defined in loadscreens.2da, and don't need to be specified ===//
    return;
}