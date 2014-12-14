////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ACR Portalling System
//     Filename : acr_portal_exe
//      Version : 0.4
//         Date : 2/13/09
//       Author : AcadiusLost
//
//  Local Variable Prefix = ACR_PTL
//
//
//  Dependencies external of nwscript:
//   acr_portal_i, NWNx4, xp_mysql plugin, connection to a valid MySQL database.
//
//  Description
//	  This file includes the functions which enable successful portalling
//   between linked ALFA servers.  It is called from acr_portal_convo.nss
//
//  Revision History:
//   0.1: 1/19/2009  AcadiusLost: inception.
//   0.2: 2/01/2009  AcadiusLost: Added operand for portal number (to account for multiple portals)
//   0.3: 2/08/2009, AcadiusLost  Shifted to infer nDestID and bAdjacency from locals on the PC.
//   0.4: 2/13/2009, AcadiusLost: Added controls for PCs who stay logged in after getting a server pass.
//   0.5: 1/07/2012, Basilica     Cleanup and readiness for seamless server to server portals.
//   0.6: 1/08/2012, Basilica     Added QuarantineAutoPortal function for automatic quarantine portal.
//

#include "acr_portal_i"
#include "acr_pps_i"

#define SEAMLESS_SERVER_PORTAL_ENABLED 1

//!  Private function to wrap a check and conditional booting
void _ReCheckPCPortaller(object oPC);

void main(string sFunction) 
{
    object oPC = GetPCSpeaker();
    // PC's don't have tags so use CD key instead
    int nDestID = GetLocalInt(oPC, "ACR_PORTAL_DEST_SERVER");
    int nPortalNum = GetLocalInt(oPC, "ACR_PORTAL_NUM");
    int bAdjacency = GetLocalInt(oPC, "ACR_PORTAL_ADJACENT");
	
    if (sFunction == "Ping") 
    {
        // writes a p-variable to get a current SQL timestamp
        _PingSQL();
    } 
    else if (sFunction == "GetTimestamp") 
    {
        // sets a local cache from the written timestamp
        SetLocalString(GetModule(), _ACR_PTL_TIMESTAMP, _CheckSQLForTimeStamp());
    } 
    else if (sFunction == "IssuePass")  
    {
        SendMessageToPC(oPC, "Generating a new pass.");
        if (bAdjacency)
        {
            ACR_SetPersistentStringNoTimestamp(oPC, _ACR_PTL_PASSPORT, _BuildPortalPass(nDestID, nPortalNum));
        }
        else
        {
            ACR_SetPersistentString(oPC, _ACR_PTL_PASSPORT, _BuildPortalPass(nDestID, nPortalNum));
            ACR_SetPersistentInt(oPC, _ACR_PTL_TIMESTAMP, ACR_GetGameHoursSinceStart());
        }
#if SEAMLESS_SERVER_PORTAL_ENABLED
#if SERVER_IPC_ENABLED
        ACR_StartServerToServerPortal(nDestID, nPortalNum, oPC);
#else
        // if the PC has not logged out in 60 seconds, and is still holding a portal pass, boot them.
        DelayCommand(60.0, _ReCheckPCPortaller(oPC));
#endif
#else
        // if the PC has not logged out in 60 seconds, and is still holding a portal pass, boot them.
        DelayCommand(60.0, _ReCheckPCPortaller(oPC));
#endif
    } 
    else if (sFunction == "QuarantineAutoPortal")
    {
#if SEAMLESS_SERVER_PORTAL_ENABLED
        nDestID = GetLocalInt(oPC, ACR_PPS_QUARANTINED_AUTOPORTAL_TARGET);
        nPortalNum = -1;
        SendMessageToPC(oPC, "Transferring you to your correct home server (" + IntToString(nDestID) + ").");
        DeleteLocalInt(oPC, ACR_PPS_QUARANTINED_AUTOPORTAL_TARGET);
        ACR_StartServerToServerPortal(nDestID, nPortalNum, oPC);
#else
        SendMessageToPC(oPC, "This ACR build does not have seamless server portals enabled.  You will have to manually connect to the correct server.");
#endif
    }
}


void _ReCheckPCPortaller(object oPC) {

	if (GetIsObjectValid(oPC)) {
		// PC is logged in.  Do they still have the portalling record?
		if (ACR_GetPersistentString(oPC, _ACR_PTL_PASSPORT) != "") {
			// still logged in, still has a portalling passport.  Show them the door.
			BootPC(oPC);
		}
	}
}
