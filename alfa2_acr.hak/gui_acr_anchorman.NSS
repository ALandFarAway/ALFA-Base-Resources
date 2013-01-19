////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : gui_acr_anchorman
//      Version : 1.0
//         Date : 2012-01-18
//       Author : FoamBats4All
//
//  Local Variable Prefix = ACR_ANCR
//
//  Description
//  This script houses the callbacks for the Anchor Manager GUI.
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_anchor_i"


////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// GUI Callback Action Codes
const int ACR_ANCR_UI_ACT_CLOSE = 1;
const int ACR_ANCR_UI_ACT_REFRESH = 2;
const int ACR_ANCR_UI_ACT_ADD = 3;
const int ACR_ANCR_UI_ACT_REMOVE_ONE = 4;
const int ACR_ANCR_UI_ACT_REMOVE_ALL = 5;
const int ACR_ANCR_UI_ACT_JUMP_DM = 6;
const int ACR_ANCR_UI_ACT_JUMP_ANCHOR = 7;
const int ACR_ANCR_UI_ACT_SELECTED = 8;

// GUI Local Variable Indexes
const int ACR_ANCR_UI_VAR_SELECTED = 10;

// GUI Object Names
const string ACR_ANCR_UI_SELECT_INFO = "txtSelectInfo";
const string ACR_ANCR_UI_HEALTH = "txtHealth";
const string ACR_ANCR_UI_FACTION = "txtFaction";
const string ACR_ANCR_UI_CR = "txtCR";

// GUI Colors
const string ACR_ANCR_UI_HP_GOOD = "#a6ffa6";
const string ACR_ANCR_UI_HP_DECENT = "#ffffa6";
const string ACR_ANCR_UI_HP_BAD = "#ffd2a6";
const string ACR_ANCR_UI_HP_CRITICAL = "#ffa6a6";


////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

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
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

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
		string sVariables = "10=" + sIndex + ";";
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


void main( int nAction, string sParam0, string sParam1, string sParam2 ) {
	object oPC = OBJECT_SELF;
	
	SendMessageToPC( oPC, "gui_acr_anchoman( " + IntToString( nAction ) + ", " + sParam0 + ", " + sParam1 + ", " + sParam2 + " )" );
	
	// Main action switch.
	switch ( nAction ) {
		case ACR_ANCR_UI_ACT_CLOSE:
			CloseGUIScreen( oPC, ACR_ANCR_UI_SCENE );
			break;
		case ACR_ANCR_UI_ACT_REFRESH:
			ACR_GUI_RefreshAnchorList( oPC );
			break;
		case ACR_ANCR_UI_ACT_ADD:
			ACR_GUI_AddAnchor( oPC, GetPlayerCurrentTarget( oPC ) );
			break;
		case ACR_ANCR_UI_ACT_REMOVE_ONE:
			ACR_GUI_RemoveAnchor( oPC, sParam0 );
			break;
		case ACR_ANCR_UI_ACT_REMOVE_ALL:
			ACR_GUI_RemoveAllAnchors( oPC );
			break;
		case ACR_ANCR_UI_ACT_JUMP_DM:
			ACR_GUI_JumpDM( oPC, sParam0 );
			break;
		case ACR_ANCR_UI_ACT_JUMP_ANCHOR:
			ACR_GUI_JumpAnchor( oPC, sParam0 );
			break;
		case ACR_ANCR_UI_ACT_SELECTED:
			ACR_GUI_OnSelectionChanged( oPC, sParam0 );
			break;
	}
}

