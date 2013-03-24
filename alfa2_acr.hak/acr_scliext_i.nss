////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_scliext_i
//    $Revision:: 1          $ current version of the file
//        $Date:: 2012-01-09#$ date the file was created or modified
//       Author : Basilica
//
//    Var Prefix: ACR_SCLIEXT
//  Dependencies: NWNX
//
//  Description
//  This file contains code for interacting with the Client Extension.
//
//  Revision History
//  2012/01/09  Basilica    - Created.
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// Client Extension "Feature Bits" are listed below.

const int ACR_SCLIEXT_FEATURE_PER_AREA_MAP_CONTROLS = 1;
const int ACR_SCLIEXT_FEATURE_NO_MAP_ENVIRON        = 2;
const int ACR_SCLIEXT_FEATURE_NO_MAP_DOORS          = 4;
const int ACR_SCLIEXT_FEATURE_NO_MAP_TRAPS          = 8;
const int ACR_SCLIEXT_FEATURE_NO_MAP_CREATURES      = 16;
const int ACR_SCLIEXT_FEATURE_NO_MAP_PATHING        = 32;
const int ACR_SCLIEXT_FEATURE_NO_MAP_PINS           = 64;
const int ACR_SCLIEXT_FEATURE_NO_MAP_BACKGROUND     = 128;
const int ACR_SCLIEXT_FEATURE_DM_AREA_POLLING       = 256;

// Version number of the extension that a player uses is stored in this PC
// local variable.
const string ACR_SCLIEXT_VERSION = "ACR_SCLIEXT_VERSION";

// Feature bits of the extension that a player uses is stored in this PC
// local variable.
const string ACR_SCLIEXT_FEATURES = "ACR_SCLIEXT_FEATURES";

// This symbol is intended to be used as an argument to the
// ACR_MakeClientExtensionVersion() function to form the latest version number
// of the extension that has been released, for version checks.
#define ACR_SCLIEXT_LATEST_VERSION 1, 0, 0, 24

// This constant represents the default feature bits that are reported as
// supported by the server.  By default we turn on DM area polling which lets
// DMs view the creature list in other areas with the DM area chooser window.
const int ACR_SCLIEXT_DEFAULT_FEATURE_BITS = ACR_SCLIEXT_FEATURE_DM_AREA_POLLING;

// Download and information URL to recommend to players for installation and
// upgrade.
const string ACR_SCLIEXT_URL = "http://www.alandfaraway.org/forums/viewtopic.php?f=231&t=43769";

// URL with forum location description.
const string ACR_SCLIEXT_URL_AND_FORUM_INFO = "http://www.alandfaraway.org/forums/viewtopic.php?f=231&t=43769 (ALFA Forums, New Players forum under ALFA General, Skywing's NWN2 Client Extension sticky thread)";

const string ACR_SCLIEXT_DISABLE_EXISTANCE_CHECK = "ACR_SCLIEXT_DISABLE_EXISTANCE_CHECK";

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! Make a Client Extension version number.
//!  - V0: Supplies the first version component.
//!  - V1: Supplies the second version component.
//!  - V2: Supplies the third version component.
//!  - V3: Supplies the fourth version component.
//!  - Returns: The extension version number.
int ACR_MakeClientExtensionVersion(int V0, int V1, int V2, int V3);

//! Get the Client Extension version for a player, returned in the same format
//  that ACR_MakeClientExtensionVersion() constructs.
//!  - PC: Supplies the player to query.
//!  - Returns: The player's extension version number, else 0 if the player did
//              not use the extension.
int ACR_GetPlayerClientExtensionVersion(object PC);

//! Get the Client Extension feature bits for a player.
//!  - PC: Supplies the player to query.
//!  - Returns: The feature bits reported by the player's extension, else zero
//              if the player did not use the extension.
int ACR_GetPlayerClientExtensionFeatures(object PC);

//! Handle the OnPCLoaded event for the ACR_SCLIEXT package.
//!  - PC: Supplies the player that has logged in.
void ACR_SCliExtOnPCLoaded(object PC);

//! Handle the OnClientLeave event for the ACR_SCLIEXT package.
//!  - PC: Supplies the player that has departed.
void ACR_SCliExtOnClientLeave(object PC);

//! Check if the player has the extension installed.  If not, suggest that they
//  install it.
//!  - PC: Supplies the player to check.
void ACR_CheckForClientExtensionInstalled(object PC);

//! Activate the chat input box for a PC's GUI.  The PC has to be running a
//  recent enough CE version for this to work.
//!  - PC: Supplies the PC whose chat input GUI is to be opened.
//!  - MessagePrefix: Supplies the prefix to assign to the chat GUI window.
void ACR_OpenChatInputBox(object PC, string MessagePrefix);

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

int ACR_MakeClientExtensionVersion(int V0, int V1, int V2, int V3)
{
	return (V0 << 24) | (V1 << 16) | (V2 << 8) | (V3);
}

int ACR_GetPlayerClientExtensionVersion(object PC)
{
	return GetLocalInt(PC, ACR_SCLIEXT_VERSION);
}

int ACR_GetPlayerClientExtensionFeatures(object PC)
{
	return GetLocalInt(PC, ACR_SCLIEXT_FEATURES);
}

void ACR_SCliExtOnPCLoaded(object PC)
{
	// Schedule a check to identify whether the player has the CE installed for
	// notification purposes.
	DelayCommand(30.0f, ACR_CheckForClientExtensionInstalled(PC));
}

void ACR_SCliExtOnClientLeave(object PC)
{
	// Clear the CE state out now so that, at the next logon, we will obtain a
	// current view of whether the player uses the CE or not.
	DeleteLocalInt(PC, ACR_SCLIEXT_VERSION);
	DeleteLocalInt(PC, ACR_SCLIEXT_FEATURES);
}

void ACR_CheckForClientExtensionInstalled(object PC)
{
	if (GetArea(PC) == OBJECT_INVALID)
	{
		DelayCommand(10.0f, ACR_CheckForClientExtensionInstalled(PC));
		return;
	}

	// Check if the player has the CE installed.  We already checked the version
	// in gui_scliext_identify if it was installed.
	if (ACR_GetPlayerClientExtensionVersion(PC) != 0)
		return;

	if (GetLocalInt(GetModule(), ACR_SCLIEXT_DISABLE_EXISTANCE_CHECK) != FALSE)
		return;

	SendMessageToPC(PC, "ALFA recommends installing the Client Extension for the best possible player (and DM) experience.  The Client Extension improves client stability, and adds new client features, such as improved client logging and better chat handling.");
	SendMessageToPC(PC, "You can find more information about the Client Extension here: " + ACR_SCLIEXT_URL_AND_FORUM_INFO);
}

void ACR_OpenChatInputBox(object PC, string MessagePrefix)
{
	SendMessageToPC(PC, "SCliExt15" + MessagePrefix);
}

