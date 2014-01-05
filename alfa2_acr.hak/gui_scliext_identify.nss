//
// gui_scliext_identify
//
// This support script lets DMs using the client extension view creatures in
// areas other than their current area.
//

#include "acr_scliext_i"
#include "acr_db_persist_i"

void main( int nFlagsAndProtocolVersion, int nClientExtensionVersion )
{
	object oCallerPC          = OBJECT_SELF;
	int    nSupportedFeatures = ACR_SCLIEXT_DEFAULT_FEATURE_BITS;

	if (GetLocalInt(OBJECT_SELF, ACR_SCLIEXT_VERSION) == 0)
		ACR_IncrementStatistic("CLIEXT_LOGINS");

	// Remember the CE version and send a nag message to the user if they have
	// an older version.
	SetLocalInt(OBJECT_SELF, ACR_SCLIEXT_VERSION, nClientExtensionVersion);
	SetLocalInt(OBJECT_SELF, ACR_SCLIEXT_FEATURES, nFlagsAndProtocolVersion);

	if (nClientExtensionVersion < ACR_MakeClientExtensionVersion(ACR_SCLIEXT_LATEST_VERSION))
	{
		DelayCommand(15.0f,
			SendMessageToPC(OBJECT_SELF, "You appear to be running an older version of the Client Extension, and a newer version is available (recommended).  View " + ACR_SCLIEXT_URL_AND_FORUM_INFO + " for details on how to upgrade."));
	}

	//
	// Tell the client that we support area polling.
	//

	SendMessageToPC(
		oCallerPC,
		"SCliExt10" + GetStringRight(
			IntToHexString(
				nSupportedFeatures ),
			8 )
		);

	//
	// Set DM scry polling interval to 2 minutes (120000ms).
	//

	SendMessageToPC(oCallerPC, "SCliExt13120000");
}

