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
#define ACR_SCLIEXT_LATEST_VERSION 1, 0, 0, 20

// This constant represents the default feature bits that are reported as
// supported by the server.  By default we turn on DM area polling which lets
// DMs view the creature list in other areas with the DM area chooser window.
const int ACR_SCLIEXT_DEFAULT_FEATURE_BITS = ACR_SCLIEXT_FEATURE_DM_AREA_POLLING;

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

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

int ACR_MakeClientExtensionVersion(int V0, int V1, int V2, int V3)
{
	return (V0 << 24) | (V1 << 16) | (V2 << 8) | (V3);
}

int ACR_GetPlayerClientExtensionVersion(object PC)
{
	return GetLocalInt(OBJECT_SELF, ACR_SCLIEXT_VERSION);
}

int ACR_GetPlayerClientExtensionFeatures(object PC)
{
	return GetLocalInt(OBJECT_SELF, ACR_SCLIEXT_FEATURES);
}

