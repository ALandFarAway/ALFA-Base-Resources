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
//	  This file includes the functions which enable succesful portalling between
//    linked ALFA servers.  It is called from acr_portal_convo.nss
//
//  Revision History:
//   0.1: 1/19/2009  AcadiusLost: inception.
//   0.2: 2/01/2009  AcadiusLost: Added operand for portal number (to account for multiple portals)
//   0.3: 2/08/2009, AcadiusLost  Shifted to infer nDestID and bAdjacency from locals on the PC.
//   0.4: 2/13/2009, AcadiusLost: Added controls for PCs who stay logged in after getting a server pass.
//

#include "acr_portal_i"

//!  Private function to wrap a check and conditional booting
void _ReCheckPCPortaller(object oPC);

void main(string sFunction) {

	object oPC = GetPCSpeaker();
	// PC's don't have tags so use CD key instead
	int nDestID = GetLocalInt(oPC, "ACR_PORTAL_DEST_SERVER");
	int nPortalNum = GetLocalInt(oPC, "ACR_PORTAL_NUM");
	
	 if (sFunction == "Ping") {
		// writes a p-variable to get a current SQL timestamp
		_PingSQL();
		
	} else if (sFunction == "GetTimestamp") {
		// sets a local cache from the written timestamp
		SetLocalString(GetModule(), _ACR_PTL_TIMESTAMP, _CheckSQLForTimeStamp());
		
	} else if (sFunction == "IssuePass")  {
	
		SendMessageToPC(oPC, "Generating a new pass.");
		ACR_SetPersistentString(oPC, _ACR_PTL_PASSPORT, _BuildPortalPass(nDestID, nPortalNum));
		// if the PC has not logged out in 60 seconds, and is still holding a portal pass, boot them.
		DelayCommand(60.0, _ReCheckPCPortaller(oPC));
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