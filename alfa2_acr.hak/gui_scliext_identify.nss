//
// gui_scliext_identify
//
// This support script lets DMs using the client extension view creatures in
// areas other than their current area.
//

const int FEATURE_PER_AREA_MAP_CONTROLS = 1;
const int FEATURE_NO_MAP_ENVIRON        = 2;
const int FEATURE_NO_MAP_DOORS          = 4;
const int FEATURE_NO_MAP_TRAPS          = 8;
const int FEATURE_NO_MAP_CREATURES      = 16;
const int FEATURE_NO_MAP_PATHING        = 32;
const int FEATURE_NO_MAP_PINS           = 64;
const int FEATURE_NO_MAP_BACKGROUND     = 128;
const int FEATURE_DM_AREA_POLLING       = 256;

void main( int nFlagsAndProtocolVersion, int nClientExtensionVersion )
{
	object oCallerPC          = OBJECT_SELF;
	int    nSupportedFeatures = FEATURE_DM_AREA_POLLING;

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
}

