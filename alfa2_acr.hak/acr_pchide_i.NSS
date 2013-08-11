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
#include "acr_db_persist_i"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

const string ACR_PCH_RESREF = "acr_pchide";
const int ACR_PCH_SLOT = INVENTORY_SLOT_CARMOUR;

const string ACR_PCH_PREFIX = "pchide_flag_";

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! Forcibly equips the PC Hide, and will continue to try to equip the hide until
//! successful.
void _EquipHide( object oPC, object oHide);

//! Ensures that the player has a PC Hide object.
//! Warning: Will delete any other object in the ACR_PCH_SLOT slot.
object ACR_InitializePCHide( object oPC );

//! Get the player hidden creature slot equipment.
//! Returns OBJECT_INVALID if there is a problem.
object ACR_GetPCHide( object oPC );

//! Get the properties from the PC's hide
void ACR_CopyPropertiesToHide( object oPC );

//! Remove all properties of duration type (-1 for all properties)
void ACR_RemoveAllPropertiesFromHide(object oHide, int duration_type);

//! Add a flag to a PC's hide
void ACR_AddFlagToHide(object oHide, int nFlag);

//! See if a flag is set for a PC's hide
int ACR_GetFlagFromHide(object oHide, int nFlag);

//! Remove a flag from a PC's hide
int ACR_RemoveFlagFromHide(object oHide, int nFlag);

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void _EquipHide( object oPC, object oHide) {
	if ( !GetIsObjectValid( oHide ) ) return;
	if ( !GetIsObjectValid( GetItemInSlot( ACR_PCH_SLOT, oPC ) ) ) {
		if ( !GetHasFeat( FEAT_WEAPON_PROFICIENCY_CREATURE, oPC, TRUE ) ) {
			FeatAdd( oPC, FEAT_WEAPON_PROFICIENCY_CREATURE, FALSE, FALSE, FALSE );
		}
		AssignCommand( oPC, ClearAllActions( TRUE ) );
		AssignCommand( oPC, ActionEquipItem( oHide, ACR_PCH_SLOT ) );
		DelayCommand( 0.5f, _EquipHide( oPC, oHide ) );
	}
}
object ACR_InitializePCHide( object oPC ) {
	// Get the object in the PCH slot.
	object oHide = GetItemPossessedBy( oPC, ACR_PCH_RESREF );
	
	// Does the PC have required proficiencies?
	if ( !GetHasFeat( FEAT_WEAPON_PROFICIENCY_CREATURE, oPC ) ) {
		FeatAdd( oPC, FEAT_WEAPON_PROFICIENCY_CREATURE, FALSE );
	}
	
	// Not in the inventory. Create the item.
	if ( !GetIsObjectValid( oHide ) ) {
		oHide = CreateItemOnObject( ACR_PCH_RESREF, oPC, 1 );
		if ( !GetIsObjectValid( oHide ) ) {
			SendMessageToPC( oPC, Colorize( "ERROR: Could not create PC Hide item!", "FF0000" ) );
		}
	}
	
	// Equip if we don't have another item in the slot.
	if ( !GetIsObjectValid( GetItemInSlot( ACR_PCH_SLOT, oPC ) ) ) {
		DelayCommand(0.5f, _EquipHide( oPC, oHide ) );
	}
	
	return oHide;
}

void ACR_RemoveAllPropertiesFromHide(object oHide, int duration_type)
{
	if (duration_type < 0) {
		IPRemoveAllItemProperties(oHide, DURATION_TYPE_TEMPORARY);
		duration_type = DURATION_TYPE_PERMANENT;
	}

	IPRemoveAllItemProperties(oHide, duration_type);
}

void ACR_CopyPropertiesToHide( object oPC ) {
	// Get the PC hide object.
	object oHide = ACR_GetPCHide( oPC );
	if ( !GetIsObjectValid( oHide ) ) {
		WriteTimestampedLogEntry( "PC Hide could not be found for ACR_CopyPropertiesToHide. Creature: " + GetName( oPC ) );
		return;
	}
	
	// Get the current hide item.
	object oCurrentHide = GetItemInSlot( ACR_PCH_SLOT, oPC );
	if ( !GetIsObjectValid( oCurrentHide ) ) {
		WriteTimestampedLogEntry( "No current hide for ACR_CopyPropertiesToHide to copy to. Creature: " + GetName( oPC ) );
		return;
	}
	
	// Copy permanent properties.
	itemproperty ipProp = GetFirstItemProperty( oHide );
	while ( GetIsItemPropertyValid( ipProp ) ) {
		if ( GetItemPropertyDurationType( ipProp ) == DURATION_TYPE_PERMANENT ) {
			AddItemProperty( DURATION_TYPE_PERMANENT, ipProp, oCurrentHide );
		}
		ipProp = GetNextItemProperty( oHide );
	}
}

object ACR_GetPCHide( object oPC ) {
	// Only check player characters.
	if ( !GetIsPC( oPC ) ) {
		return OBJECT_INVALID;
	}
	
	// Get the item.
	object oHide = GetItemPossessedBy( oPC, ACR_PCH_RESREF );
	
	// Invalid item?
	if ( !GetIsObjectValid( oHide ) ) {
		oHide = ACR_InitializePCHide( oPC );
	}
	
	return oHide;
}

void ACR_AddFlagToHide(object oHide, int nFlag)
{
	object oPC = GetItemPossessor(oHide);

	ACR_SetPersistentInt(oPC, ACR_PCH_PREFIX + IntToString(nFlag), 1);
}

int ACR_GetFlagFromHide(object oHide, int nFlag)
{
	object oPC = GetItemPossessor(oHide);

	return ACR_GetPersistentInt(oPC, ACR_PCH_PREFIX + IntToString(nFlag));
}

int ACR_RemoveFlagFromHide(object oHide, int nFlag)
{
	int resval;
	object oPC = GetItemPossessor(oHide);
	string varname = ACR_PCH_PREFIX + IntToString(nFlag);

	resval = ACR_GetPersistentInt(oPC, varname);
	
	if (resval)
		ACR_DeletePersistentVariable(oPC, varname);

	return resval;
}
