////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ACR Portalling System
//     Filename : acr_portal_cnd
//      Version : 0.3
//         Date : 2/11/09
//       Author : AcadiusLost
//
//  Local Variable Prefix = ACR_PTL
//
//
//
//  Description
//	  This script handles the conditional checks associated with portalling.
//
//  Revision History:
//   0.1: 1/19/2009, AcadiusLost inception.
//   0.2: 2/08/2009, AcadiusLost  Shifted to infer nDestID and bAdjacency from locals on the PC.
//   0.3: 2/11/2009, AcadiusLost  Added CheckCorpse function
//   0.4: 1/07/2012, Basilica     Cleanup and readiness for seamless server to server portals.

#include "acr_portal_i"
#include "acr_death_i"

//!  sFunction: 
//!				CheckServer - checks nDestID to see if it's up currently.
//!				CheckPC - checks oSpeaker for time till valid to portal
//!				CheckPassport - checks oSpeaker for a valid server pass
//!
int StartingConditional(string sFunction) { 

	object oPC = GetPCSpeaker();
	int nDestID = GetLocalInt(oPC, "ACR_PORTAL_DEST_SERVER");
	string sDestID = IntToString(nDestID);
	int bAdjacency = GetLocalInt(oPC, "ACR_PORTAL_ADJACENT");
	// SendMessageToPC(oPC, "Querying SQL DB; function "+sFunction);
	
	if (sFunction == "CheckServer") {
		// call the server check function
		// return the result
		return ACR_PortalCheckServer(nDestID, oPC);
			
	} else if (sFunction == "CheckPC") {
		// if the portal is "adjacent", skip the cooldown check
		if (bAdjacency) {
			return TRUE;
		}
		// otherwise call the cooldown check function
		int nCooldown = ACR_PortalCheckCooldown(oPC);
		if (nCooldown == 0) {
			SendMessageToPC(oPC, "Valid to portal.");
			return TRUE;
		} else {
			// PC must wait, inform them of how long
			SendMessageToPC(oPC, "You must wait at least another "+IntToString(nCooldown)+" RL hours before portalling again.");
			AssignCommand(oPC, ActionSpeakString("You must wait at least another "+IntToString(nCooldown)+" RL hours before portalling again."));
			return FALSE;
		}
			
	} else if (sFunction == "CheckPassport") {
		// check passport
		return ACR_PortalCheckPass(oPC, nDestID);

	} else if (sFunction == "CheckCorpse") {
		// run an inventory loop, kick back TRUE if any PC body items are found.
		object oTestItem = GetFirstItemInInventory(oPC);
		while (GetIsObjectValid(oTestItem)) {
			if (ACR_GetIsCorpseToken(oTestItem)) {
				return TRUE;
			} else {
				oTestItem = GetNextItemInInventory(oPC);
			}
		} // If we get to here, means the PC doesn't have any corpses in inventory.
		return FALSE;	
	} else if (sFunction == "CheckAdjacent") {
		return bAdjacency != FALSE;
	} else {
		SendMessageToPC(oPC, "Function unknown.");	
    	return FALSE;
	}
}
