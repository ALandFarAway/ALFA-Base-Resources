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
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// Local variable names.
const string ACR_ANCR_VAR_PREFIX = "acr_anchor_";
const string ACR_ANCR_VAR_PARENT = "acr_anchor_parent";
const string ACR_ANCR_VAR_INDEX = "acr_anchor_index";

// One less than the maximum number of anchors supported.
const int ACR_ANCR_MAX_INDEX = 9;

// Management GUI Core Data
const string ACR_ANCR_UI_SCENE = "SCREEN_ACR_ANCHMAN";
const string ACR_ANCR_UI_FILE = "acr_anchorman.xml";

// GUI Callback Action Codes
const int ACR_ANCR_UI_ACT_CLOSE = 1;
const int ACR_ANCR_UI_ACT_REFRESH = 2;
const int ACR_ANCR_UI_ACT_ADD = 3;
const int ACR_ANCR_UI_ACT_REMOVE_ONE = 4;
const int ACR_ANCR_UI_ACT_REMOVE_ALL = 5;
const int ACR_ANCR_UI_ACT_JUMP_DM = 6;
const int ACR_ANCR_UI_ACT_JUMP_ANCHOR = 7;
const int ACR_ANCR_UI_ACT_SELECTED = 8;

// GUI Object Names
const string ACR_ANCR_UI_LISTBOX = "lbAnchors";
const string ACR_ANCR_UI_SELECT_INFO = "txtSelectInfo";
const string ACR_ANCR_UI_HEALTH = "txtHealth";
const string ACR_ANCR_UI_FACTION = "txtFaction";
const string ACR_ANCR_UI_CR = "txtCR";

// GUI Colors
const string ACR_ANCR_UI_HP_GOOD = "#a6ffa6";
const string ACR_ANCR_UI_HP_DECENT = "#ffffa6";
const string ACR_ANCR_UI_HP_BAD = "#ffd2a6";
const string ACR_ANCR_UI_HP_CRITICAL = "#ffa6a6";

// GUI Local Variable Indexes
const int ACR_ANCR_UI_VAR_SELECTED = 10;


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

//! Refreshes the PC's anchor list, reloading the list of their anchors.
//!  - oPC : Player to refresh the UI of.
void ACR_GUI_RefreshAnchorList( object oPC );

//! GUI wrapper around ACR_AddAnchor, updates the UI.
//!  - oPC : Speaker.
//!  - oTarget : Target to add as an anchor.
void ACR_GUI_AddAnchor( object oPC, object oTarget );

//! GUI wrapper around ACR_RemoveAnchor, updates the UI.
//!  - oPC : Speaker.
void ACR_GUI_RemoveAnchor( object oPC, string sIndex );

//! GUI wrapper around ACR_RemoveAllAnchors, updates the UI.
//!  - oPC : Speaker.
void ACR_GUI_RemoveAllAnchors( object oPC );

//! Jumps the DM to an anchor.
//!  - oPC : DM to jump.
//!  - sIndex : Index of the anchor to jump to.
void ACR_GUI_JumpDM( object oPC, string sIndex );

//! Jumps the anchor to its DM.
//!  - oPC : DM to jump to.
//!  - sIndex : Index of the anchor to jump.
void ACR_GUI_JumpAnchor( object oPC, string sIndex );

//! Cleans up the selection information pane.
//!  - oPC : Player who owns the UI.
void ACR_GUI_ClearSelectionInformation( object oPC );

//! Callback for when the selection in the UI is changed.
//!  - oPC : Player who is using the UI.
//!  - sIndex : Index of the anchor to select.
void ACR_GUI_OnSelectionChanged( object oPC, string sIndex );


////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


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
	if ( oTarget == oPC ) return TRUE;
	if ( oTarget == GetAssociate( ASSOCIATE_TYPE_ANIMALCOMPANION, oPC ) ) return TRUE;
	if ( oTarget == GetAssociate( ASSOCIATE_TYPE_DOMINATED, oPC ) ) return TRUE;
	if ( oTarget == GetAssociate( ASSOCIATE_TYPE_FAMILIAR, oPC ) ) return TRUE;
	if ( oTarget == GetAssociate( ASSOCIATE_TYPE_HENCHMAN, oPC ) ) return TRUE;
	if ( oTarget == GetAssociate( ASSOCIATE_TYPE_SUMMONED, oPC ) ) return TRUE;
	if ( oTarget == GetOwnedCharacter( oPC ) ) return TRUE;
	
	// Players can take anchor of nothing else.
	if ( !GetIsDM( oPC ) ) return FALSE;
	
	// DMs cannot take control of player-owned objects.
	if ( GetIsPC( oTarget ) ) return FALSE;
	if ( GetIsPC( GetOwnedCharacter( oTarget ) ) ) return FALSE;

	// Otherwise, not anchorable.
	return TRUE;
}

void ACR_GUI_RefreshAnchorList( object oPC ) {
	// Clear our current list.
	ClearListBox( oPC, ACR_ANCR_UI_SCENE, ACR_ANCR_UI_LISTBOX );
	
	// Go through our anchors and add data.
	int i;
	for ( i = 0; i <= ACR_ANCR_MAX_INDEX; i++ ) {
		// Valid anchor?
		object oAnchor = ACR_GetAnchor( oPC, i );
		if ( !GetIsObjectValid( oAnchor ) ) continue;
		
		// Get data we care about.
		string sIndex = IntToString( i );
		string sName = GetName( oAnchor );
		string sArea = GetName( GetArea( oAnchor ) );
		
		// GUI data.
		string sRowName = "index_" + sIndex;
		string sTextFields = "txtID=" + sIndex + ";txtName=" + sName + ";txtArea=" + sArea;
		string sTextures = "";
		string sVariables = IntToString( ACR_ANCR_UI_VAR_SELECTED ) + "=" + sIndex + ";";
		string sHideUnhide = "";
		
		// Add the data to the list.
		AddListBoxRow( oPC, ACR_ANCR_UI_SCENE, ACR_ANCR_UI_LISTBOX, sRowName, sTextFields, sTextures, sVariables, sHideUnhide );
	}
	
	// Clear selection info.
	ACR_GUI_ClearSelectionInformation( oPC );
}


void ACR_GUI_AddAnchor( object oPC, object oTarget ) {
	// Hook our anchor.
	ACR_AddAnchor( oPC, oTarget );
	
	// Refresh UI.
	ACR_GUI_RefreshAnchorList( oPC );
}


void ACR_GUI_RemoveAnchor( object oPC, string sIndex ) {
	// Call 'remove anchor' on the converted parameter.
	ACR_RemoveAnchor( oPC, StringToInt( sIndex ) );
	
	// Refresh UI.
	ACR_GUI_RefreshAnchorList( oPC );
}


void ACR_GUI_RemoveAllAnchors( object oPC ) {
	// Call 'remove anchor' on the converted parameter.
	ACR_RemoveAllAnchors( oPC );
	
	// Refresh UI.
	ACR_GUI_RefreshAnchorList( oPC );
}


void ACR_GUI_JumpDM( object oPC, string sIndex ) {
	// Limit to DMs.
	if ( !GetIsDM( oPC ) && !GetIsDMPossessed( oPC ) ) {
		SendMessageToPC( oPC, "This function is limited to DMs." );
		return;
	}
	
	// Convert our index and grab our anchor.
	int nIndex = StringToInt( sIndex );
	object oAnchor = ACR_GetAnchor( oPC, nIndex );
	if ( !GetIsObjectValid( oAnchor ) ) {
		SendMessageToPC( oPC, "Could not jump DM to anchor: invalid anchor object." );
		return;
	}
	
	// Make the jump.
	AssignCommand( oPC, ClearAllActions() );
	AssignCommand( oAnchor, ClearAllActions() );
	AssignCommand( oPC, ActionJumpToObject( oAnchor, FALSE ) );
}


void ACR_GUI_JumpAnchor( object oPC, string sIndex ) {
	// Limit to DMs.
	if ( !GetIsDM( oPC ) && !GetIsDMPossessed( oPC ) ) {
		SendMessageToPC( oPC, "This function is limited to DMs." );
		return;
	}

	// Convert our index and grab our anchor.
	int nIndex = StringToInt( sIndex );
	object oAnchor = ACR_GetAnchor( oPC, nIndex );
	if ( !GetIsObjectValid( oAnchor ) ) {
		SendMessageToPC( oPC, "Could not jump anchor to DM: invalid anchor object." );
		return;
	}
	
	// Make the jump.
	AssignCommand( oPC, ClearAllActions() );
	AssignCommand( oAnchor, ClearAllActions() );
	AssignCommand( oAnchor, ActionJumpToObject( oPC, FALSE ) );
}


void ACR_GUI_ClearSelectionInformation( object oPC ) {
	// Enable prompt text.
	SetGUIObjectHidden( oPC, ACR_ANCR_UI_SCENE, ACR_ANCR_UI_SELECT_INFO, FALSE );
	
	// Disable individual elements.
	SetGUIObjectText( oPC, ACR_ANCR_UI_SCENE, ACR_ANCR_UI_HEALTH, -1, "" );
	SetGUIObjectText( oPC, ACR_ANCR_UI_SCENE, ACR_ANCR_UI_FACTION, -1, "" );
	SetGUIObjectText( oPC, ACR_ANCR_UI_SCENE, ACR_ANCR_UI_CR, -1, "" );
}


void ACR_GUI_OnSelectionChanged( object oPC, string sIndex ) {
	// Disable selection information.
	ACR_GUI_ClearSelectionInformation( oPC );

	// Convert our index and grab our anchor.
	int nIndex = StringToInt( sIndex );
	object oAnchor = ACR_GetAnchor( oPC, nIndex );
	if ( !GetIsObjectValid( oAnchor ) ) {
		SendMessageToPC( oPC, "Could display anchor information: invalid anchor object." );
		return;
	}
	
	// Hide selection prompt.
	SetGUIObjectHidden( oPC, ACR_ANCR_UI_SCENE, ACR_ANCR_UI_SELECT_INFO, TRUE );
	
	// Update health.
	int nCurrentHP = GetCurrentHitPoints( oAnchor );
	int nMaxHP = GetMaxHitPoints( oAnchor );
	string sHealthColor = ACR_ANCR_UI_HP_GOOD;
	if ( nCurrentHP < ( nMaxHP / 4 ) ) sHealthColor = ACR_ANCR_UI_HP_CRITICAL;
	else if ( nCurrentHP < ( nMaxHP / 2 ) ) sHealthColor = ACR_ANCR_UI_HP_BAD;
	else if ( nCurrentHP < ( nMaxHP / 4 * 3 ) ) sHealthColor = ACR_ANCR_UI_HP_DECENT;
	string sHealth = "Health: <C=" + sHealthColor + ">" + IntToString( nCurrentHP ) + "</C> / " + IntToString( nMaxHP );
	SetGUIObjectText( oPC, ACR_ANCR_UI_SCENE, ACR_ANCR_UI_HEALTH, -1, sHealth );
	
	// Update faction.
	SetGUIObjectText( oPC, ACR_ANCR_UI_SCENE, ACR_ANCR_UI_FACTION, -1, "Faction: Undefined" );
	
	// Update CR.
	string sCR = FloatToString( GetChallengeRating( oAnchor ) );
	SetGUIObjectText( oPC, ACR_ANCR_UI_SCENE, ACR_ANCR_UI_CR, -1, "CR: " + sCR );
}


#endif