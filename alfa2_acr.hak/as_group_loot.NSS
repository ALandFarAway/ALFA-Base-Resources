////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ACR Spawn System
//     Filename : as_group_example.nss
//      Version : 1.0
//         Date : 2006-9-17
//       Author : Ronan
//
//  Description
//  This is a simple example of a spawn group script which is used by the ACR's
//  spawn system. Though the name of the script is "as_group_example", the spawn
//  point which uses this script would simply have "example" listed as a spawn
//  group name, since the "as_group_" is always added on to the beginning. For a
//  more complex example of spawn groups, see the script "as_group_complex".
//
//  Revision History
// Rick, made several types of rats.
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// This line is required on all spawn group scripts.
#include "acr_spawn_i"
#include "acr_placeable_i"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// This is the main function, which is what the spawn system runs when this
// spawn group is spawned.
void main();

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void main() {


	object oChest;
	object oTrap;
	object oCheckTrigger;
	object o;
	        	
	oCheckTrigger = GetNearestObjectByTag("phat_lewt_trigger", OBJECT_SELF, 1);
	if (GetDistanceBetween(oCheckTrigger, OBJECT_SELF) > 10.0) {
		o = GetArea(OBJECT_SELF);
		WriteTimestampedLogEntry("phat_lewt: Error, no trigger for loot in "+GetName(o) + " (" + GetTag(o) + ")");
		return;
	}
						
	SetLocalInt(oCheckTrigger, "PL_SPAWNABLE", 1);

	switch (Random(10)) {
		// 10%
		case 0:
			SetLocalString(oCheckTrigger, "PL_RESREF", "phat_lewt_sarcophagus");
			break;
		// 20%
		case 1:
		case 2:
			SetLocalString(oCheckTrigger, "PL_RESREF", "phat_lewt_chest_small");
			break;
		// 20%
		case 3:
		case 4:
			SetLocalString(oCheckTrigger, "PL_RESREF", "phat_lewt_chest_large");
			break;
		// 10%
		case 5:
			SetLocalString(oCheckTrigger, "PL_RESREF", "phat_lewt_bookshelf");
			SetLocalInt(oCheckTrigger, "PL_NO_TRAP", 1);
			break;
		// 10%
		case 6:
			SetLocalString(oCheckTrigger, "PL_RESREF", "phat_lewt_barrel");
			SetLocalInt(oCheckTrigger, "PL_NO_TRAP", 1);
			break;
		// 10%
		case 7:
			SetLocalString(oCheckTrigger, "PL_RESREF", "phat_lewt_crate");
			SetLocalInt(oCheckTrigger, "PL_NO_TRAP", 1);
			break;
		// 10%
		case 8:
			SetLocalString(oCheckTrigger, "PL_RESREF", "phat_lewt_vase");
			break;
		default:
			switch (Random(4)) {
				// 2.5%
				case 0:
					SetLocalString(oCheckTrigger, "PL_RESREF", "phat_lewt_corpse_female");
					break;
				// 2.5%
				case 1:
					SetLocalString(oCheckTrigger, "PL_RESREF", "phat_lewt_corpse_male");
					break;
				// 2.5%
				case 2:
					SetLocalString(oCheckTrigger, "PL_RESREF", "phat_lewt_skeleton");
					break;
				// 2.5%
				default:
					SetLocalString(oCheckTrigger, "PL_RESREF", "phat_lewt_corpse_ogre");
			}
			SetLocalInt(oCheckTrigger, "PL_NO_TRAP", 1);
	}

	// 20%
	if (!Random(5))
		ACR_DestroySpawnPoint(OBJECT_SELF);
}
