//  System Name : ALFA Core Rules
//     Filename : i_abr_dmquarantine_ac
//    $Revision::             $ current version of the file
//        $Date::             $ date the file was created or modified
//       Author : AcadiusLost
//
//    Var Prefix: ACR_Q
//  Dependencies: 1984 logging, portalling code
//  Description
//  This script handles activation of the DM Quarantine Wand.
//
//  Revision History
//  2009/02/10  AcadiusLost: Inception
//	2009/02/20  AcadiusLost: Added text feedback to Validated PCs and DM channel.
//
////////////////////////////////////////////////////////////////////////////////
#include "acr_1984_i"
#include "acr_xp_i"
#include "acr_db_persist_i"
#include "acr_pps_i"
#include "acr_resting_i"

void main()
{
	object oTarget =  GetItemActivatedTarget();
	object oUser = GetItemActivator();
	int bQuarantined = FALSE;
	string sPassport = "";
	string sPortalRecord = "";
	
	if (!GetIsDM(oUser)) {
		DestroyObject(GetItemActivated()); 
		SendMessageToPC(oUser, "You are not allowed to use the Quarantine Wand!");
		SendMessageToAllDMs("PC "+GetName(oUser)+" attempted to use a Quarantine wand in area "+GetName(GetArea(oUser))+"!  The wand has been destroyed.");
		return;
	}

	if (!GetIsObjectValid(oTarget) || (oTarget == oUser)) {
		// using the wand on the ground or on yourself lists all quarantined PCs and their portalling information.
		SendMessageToPC(oUser, "Listing Quarantined PCs...");
		object oPC = GetFirstPC(TRUE);
		while (GetIsObjectValid(oPC)) {
			bQuarantined = GetLocalInt(oPC, "ACR_PPS_QUARANTINED");
			if (bQuarantined) {
				ACR_PortalInformationReport(oPC, oUser);
			}
			oPC = GetNextPC(TRUE);
		}
	} else if (GetIsPC(oTarget)) {
		// Got a live target here.  Is it quarantined?			
		if (!GetLocalInt(oTarget, "ACR_PPS_QUARANTINED")) {
			// False alarm. Notify the DM, end.
			SendMessageToPC(oUser, GetName(oTarget)+" is not flagged as Quarantined.");
			return;
		}
		// store the current server and location as valid
		ACR_PCUpdateStatus(oTarget, TRUE);
		// clear the local quarantine flag on the PC
		DeleteLocalInt(oTarget, "ACR_PPS_QUARANTINED"); 
		// re-run the rest initialization
	    ACR_RestOnClientEnter(oTarget);
		// Validate the targeted PC.
		ACR_PPSValidatePC(oTarget);
		// start the XP system as well
		ACR_XPOnClientLoaded(oTarget);
		ACR_LogEvent(oTarget, ACR_LOG_VALIDATED, "Validated for play on server "+GetName(GetModule())+" by DM: "+GetName(oUser));
		ACR_SetPersistentString(oTarget, _ACR_PTL_RECORD, "Validated for serverID "+IntToString(ACR_GetServerID())+" by DM: "+GetName(oUser));
		ACR_DeletePersistentVariable(oTarget, _ACR_PTL_PASSPORT);
		SendMessageToPC(oTarget, "Validated and normalized by DM: "+GetName(oUser)+".");
		SendMessageToAllDMs("PC: "+GetName(oTarget)+" was validated from quarantine by DM: "+GetName(oUser));
		
	} else {
    	SendMessageToPC(oUser, "Invalid target.  The Quarantine Wand must be used on yourself or the ground (to list information), or on a PC (to validate).");
	}
}
	

