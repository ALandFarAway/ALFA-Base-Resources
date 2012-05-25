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
        	
	switch(Random(13)) {
		case 0:
			SetLocalString(oCheckTrigger, "PL_RESREF", "phat_lewt_altar");
			break;
		case 1:
			SetLocalString(oCheckTrigger, "PL_RESREF", "phat_lewt_armoire");
			break;
		case 2:
			SetLocalString(oCheckTrigger, "PL_RESREF", "phat_lewt_bag");
			break;
		case 3:
			SetLocalString(oCheckTrigger, "PL_RESREF", "phat_lewt_barrel");
			break;
		case 4:
			SetLocalString(oCheckTrigger, "PL_RESREF", "phat_lewt_basket");
			break;
		case 5:
			SetLocalString(oCheckTrigger, "PL_RESREF", "phat_lewt_bookshelf");
			break;
		case 6:
			SetLocalString(oCheckTrigger, "PL_RESREF", "phat_lewt_cabinet");
			break;
		case 7:
			SetLocalString(oCheckTrigger, "PL_RESREF", "phat_lewt_chest_large");
			break;
		case 8:
			SetLocalString(oCheckTrigger, "PL_RESREF", "phat_lewt_chest_small");
			break;
		case 9:
			SetLocalString(oCheckTrigger, "PL_RESREF", "phat_lewt_crate");
			break;
		case 10:
			SetLocalString(oCheckTrigger, "PL_RESREF", "phat_lewt_desk");
			break;
		case 11:
			SetLocalString(oCheckTrigger, "PL_RESREF", "phat_lewt_urn");
			break;
		case 12:
			SetLocalString(oCheckTrigger, "PL_RESREF", "phat_lewt_vase");
			break;
	}
}
