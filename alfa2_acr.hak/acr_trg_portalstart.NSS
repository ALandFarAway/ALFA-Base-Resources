////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ACR Server Portal initator
//     Filename : acr_trg_portalstart.nss
//    $Revision:: 1        $ current version of the file
//        $Date:: 2009-02-08#$ date the file was created or modified
//       Author : AcadiusLost
//
//  Local Variable Prefix =
//
//  Dependencies external of nwscript:
//
//  Description
//  This script starts the portalling convo.
//
//  Revision History
//    2009-02-08  AcadiusLost: Inception
//    2012-02-01  Basilica   : Cleanup and and skip dialog for adjacent portals.
////////////////////////////////////////////////////////////////////////////////
#include "acr_trigger_i"
#include "acr_portal_i"

void main()
{
	object oPC = GetClickingObject();
	if (!GetIsPC(oPC))
	{
		return;
	}

	int nDestServerID = GetLocalInt(OBJECT_SELF, "ACR_PORTAL_DEST");
	int nPortalNumber = GetLocalInt(OBJECT_SELF, "ACR_PORTAL_NUM");
	int bAdjacency = GetLocalInt(OBJECT_SELF, "ACR_PORTAL_ADJACENT");

	if (nDestServerID == 0)
	{
		// portal is not configured, notify the player and DMs.
		SendMessageToPC(oPC, "This server portal is not configured properly.  Please notify the DM team.");
		SendMessageToAllDMs("Incorrectly configured server portal activation in area: "+GetName(GetArea(OBJECT_SELF))+" by PC: "+GetName(oPC));

		return;
	}
	else if (nPortalNumber == 0 )
	{
		// portal is not numbered, assume it's #1
		nPortalNumber = 1;
	}

	// cache portalling trigger information on the portalling PC.
	SetLocalInt(oPC, "ACR_PORTAL_DEST_SERVER", nDestServerID);
	SetLocalInt(oPC, "ACR_PORTAL_NUM", nPortalNumber);
	SetLocalInt(oPC, "ACR_PORTAL_ADJACENT", bAdjacency);

	SendMessageToPC(oPC, "Using portal trigger.");

	// Start the portal conversation if the portal has a cooldown, so that the
	// player is aware of what is going on.  Otherwise, just immediately begin a
	// seamless transfer.
	if (bAdjacency == FALSE)
		AssignCommand(oPC, ActionStartConversation(oPC, "acr_portal_convo", TRUE, FALSE));
	else
		ACR_PortalPC_Start(oPC, nDestServerID, nPortalNumber, TRUE);
}
