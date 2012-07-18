////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ACR PC Hide System
//     Filename : acr_pchide_i
//      Version : 1.0
//         Date : 2012-07-14
//       Author : FoamBats4All
//
//  Local Variable Prefix = ACR_PCH
//
//  Description
//	  This script handles the hidden creature slot weapon on player characters.
//    Influenced by Mik Clarke's MPWC PC Hide.
//
//  Revision History:
//   2012-07-14	FoamBats4All	Inception.
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_tools_i"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

const string ACR_PCH_RESREF = "acr_pchide";
const int ACR_PCH_SLOT = INVENTORY_SLOT_CWEAPON_L;

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! Ensures that the player has a PC Hide object.
//! Warning: Will delete any other object in the ACR_PCH_SLOT slot.
void ACR_InitializePCHide( object oPC );

//! Get the player hidden creature slot equipment.
//! Returns OBJECT_INVALID if there is a problem.
object ACR_GetPCHide( object oPC );

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void ACR_InitializePCHide( object oPC ) {
	// Get the object in the PCH slot.
	object oHide = GetItemInSlot( ACR_PCH_SLOT, oPC );
	
	// Does the PC have required proficiencies?
	if ( !GetHasFeat( FEAT_WEAPON_PROFICIENCY_CREATURE, oPC ) ) {
		FeatAdd( oPC, FEAT_WEAPON_PROFICIENCY_CREATURE, FALSE );
	}
	
	// Is this our valid item?
	if ( GetIsObjectValid( oHide ) ) {
		if ( GetResRef( oHide ) == ACR_PCH_RESREF ) {
			// All is good.
			return;
		} else {
			// Some other item? Not good! Delete it and reinitialize.
			DestroyObject( oHide );
			_InitializePCHide( oPC );
			return;
		}
	} else {
		// No item in the slot.
		oHide = GetItemPossessedBy( oPC, ACR_PCH_RESREF );
		if ( !GetIsObjectValid( oHide ) ) {
			// Not in the inventory. Create the item.
			oHide = CreateItemOnObject( ACR_PCH_RESREF, oPC, 1 );
			if ( !GetIsObjectValid( oHide ) ) {
				SendMessageToPC( oPC, Colorize( "ERROR: Could not create PC Hide item!", "FF0000" ) );
			}
		}
		AssignCommand( oPC, ActionEquipItem( oHide, ACR_PCH_SLOT ) );
	}
}

object ACR_GetPCHide( object oPC ) {
	// Only check player characters.
	if ( !GetIsPC( oPC ) ) {
		return OBJECT_INVALID;
	}
	
	// Confirm that we have the item set up.
	ACR_InitializePCHide( oPC );
	
	// Return the item.
	object oHide = GetItemInSlot( ACR_PCH_SLOT, oPC );
	if ( GetResRef( oHide ) != ACR_PCH_RESREF ) oHide = OBJECT_INVALID;
	return oHide;
}