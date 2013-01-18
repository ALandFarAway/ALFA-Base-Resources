////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_anchor_i.nss
//      Version : 1.0
//         Date : 2012-01-17
//       Author : FoamBats4All
//
//  Dependencies:
//	None.
//
//  Description:
//  This module defines functions for remotely controlling and speaking from
//  objects.
//  
////////////////////////////////////////////////////////////////////////////////

#ifndef ACR_ANCHOR_I
#define ACR_ANCHOR_I

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

const string ACR_ANCR_VAR_PREFIX = "acr_anchor_";
const string ACR_ANCR_VAR_PARENT = "acr_anchor_parent";
const string ACR_ANCR_VAR_INDEX = "acr_anchor_index";
const int ACR_ANCR_MAX_INDEX = 9;

// Management GUI Core Data
const string ACR_ANCR_UI_SCENE = "SCREEN_ACR_ANCHMAN";
const string ACR_ANCR_UI_FILE = "acr_anchorman.xml";

// Management GUI Elements
const string ACR_ANCR_UI_LISTBOX = "lbAnchors";


////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! Opens the anchor management GUI.
//!  - oPC : Player to open the manager for.
void ACR_OpenAnchorManager( object oPC );

//! Add an anchor to the target at a given index.
//!  - oPC : Player to create the anchor for.
//!  - oAnchor : Object to anchor.
//!  - nIndex : Speak index.
int ACR_AddAnchor( object oPC, object oTarget, int nIndex = -1 );

//! Removes an index from the given index.
//!  - oPC : Player to remove an anchor from.
//!  - nIndex : Index to remove.
void ACR_RemoveAnchor( object oPC, int nIndex );

//! Remove all anchors from a player.
//!  - oPC : Player to purge anchors from.
void ACR_RemoveAllAnchors( object oPC );

//! Returns an anchor at a given index.
//!  oPC : Player to retrieve an anchor from.
//!  nIndex : Index of the anchor to return.
//! Returns: Object ID of the anchor.
object ACR_GetAnchor( object oPC, int nIndex );

//! Determines if the target may be anchored.
//!  oPC : Player to check from.
//!  oTarget : Potential anchor to check.
//! Returns: TRUE if anchorable, else FALSE.
int ACR_IsAnchorable( object oPC, object oTarget );


////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void ACR_OpenAnchorManager( object oPC ) {
	DisplayGuiScreen( oPC, ACR_ANCR_UI_SCENE, FALSE, ACR_ANCR_UI_FILE );
	
	// Enable DM-only options.
	if ( GetIsDM( oPC ) ) {
		SetGUIObjectHidden( oPC, ACR_ANCR_UI_SCENE, "btnJumpDM", FALSE );
		SetGUIObjectHidden( oPC, ACR_ANCR_UI_SCENE, "btnJumpAnchor", FALSE );
	}
}


int ACR_AddAnchor( object oPC, object oTarget, int nIndex = -1 ) {
	// Valid PC?
	
	// Valid anchor?
	if ( !ACR_IsAnchorable( oPC, oTarget ) ) {
		SendMessageToPC( oPC, "You may not anchor target '" + GetName( oTarget ) + "'." );
		return FALSE;
	}
	
	// Using the 'next available index'?
	if ( nIndex == -1 ) {
		int bFoundIndex = FALSE;
		int i = 0;
		for ( i = 0; i <= ACR_ANCR_MAX_INDEX; i++ ) {
			if ( !GetIsObjectValid( ACR_GetAnchor( oPC, i ) ) ) {
				nIndex = i;
				bFoundIndex = TRUE;
				break;
			}
		}
		if ( !bFoundIndex ) {
			SendMessageToPC( oPC, "No free anchor indexes found. Remove an anchor or provide an anchor index to overwrite." );
			return FALSE;
		}
	}
	
	// Valid anchor index?
	if ( nIndex < 0 || nIndex > ACR_ANCR_MAX_INDEX ) {
		SendMessageToPC( oPC, "Invalid index " + IntToString( nIndex ) + ", must be between 0 and " + IntToString( ACR_ANCR_MAX_INDEX ) + " (inclusive)." );
		return FALSE;
	}
	
	// Remove a previous anchor at that index if it exists.
	ACR_RemoveAnchor( oPC, nIndex );
	
	// Is the target already anchored to someone else?
	object oTargetParent = GetLocalObject( oTarget, ACR_ANCR_VAR_PARENT );
	if ( GetIsObjectValid( oTargetParent ) ) {
		// Inform them that they've been kicked as the controller.
		SendMessageToPC( oTargetParent, GetName( oPC ) + " has taken over as speaker for " + GetName( oTarget ) + "." );
		ACR_RemoveAnchor( oTargetParent, GetLocalInt( oTarget, ACR_ANCR_VAR_INDEX ) );
	}
	
	// Set them anchored to us.
	SetLocalObject( oPC, ACR_ANCR_VAR_PREFIX + IntToString( nIndex ), oTarget );
	SetLocalObject( oTarget, ACR_ANCR_VAR_PARENT, oPC );
	SetLocalInt( oTarget, ACR_ANCR_VAR_INDEX, nIndex );
	
	return TRUE;
}


void ACR_RemoveAnchor( object oPC, int nIndex ) {
	// Get the current anchor.
	object oAnchor = ACR_GetAnchor( oPC, nIndex );
	
	// Remove our relationship to them.
	if ( GetIsObjectValid( oPC ) ) {
		DeleteLocalObject( oPC, ACR_ANCR_VAR_PREFIX + IntToString( nIndex ) );
	}
	
	// Remove their relationship to us.
	if ( GetIsObjectValid( oAnchor ) ) {
		DeleteLocalObject( oAnchor, ACR_ANCR_VAR_PARENT );
		DeleteLocalInt( oAnchor, ACR_ANCR_VAR_INDEX );
	}
}


void ACR_RemoveAllAnchors( object oPC ) {
	int i = 0;
	for ( i = 0; i <= ACR_ANCR_MAX_INDEX; i++ ) {
		ACR_RemoveAnchor( oPC, i );
	}
}


object ACR_GetAnchor( object oPC, int nIndex ) {
	// Get the anchor.
	object oAnchor = GetLocalObject( oPC, ACR_ANCR_VAR_PREFIX + IntToString( nIndex ) );
	
	// Make sure it's still valid.
	if ( !GetIsObjectValid( oAnchor ) ) {
		return OBJECT_INVALID;
	}
	
	// Return it if all checks out.
	return oAnchor;
}


int ACR_IsAnchorable( object oPC, object oTarget ) {
	oPC = GetOwnedCharacter( oPC );
	if ( !GetIsObjectValid( oPC ) ) return FALSE;
	if ( !GetIsObjectValid( oTarget ) ) return FALSE;
	
	// Can only anchor creatures.
	if ( GetObjectType( oTarget ) != OBJECT_TYPE_CREATURE ) return FALSE;
	
	// Anyone can anchor themselves or their creation.
	if ( oPC == oTarget ) return TRUE;
	if ( oPC == GetOwnedCharacter( oTarget ) ) return TRUE;
	
	// Players can take anchor of nothing else.
	if ( !GetIsDM( oPC ) ) return FALSE;
	
	// DMs cannot take control of player-owned objects.
	if ( GetIsPC( oTarget ) ) return FALSE;
	if ( GetIsPC( GetOwnedCharacter( oTarget ) ) ) return FALSE;

	// Otherwise, not anchorable.
	return TRUE;
}


#endif