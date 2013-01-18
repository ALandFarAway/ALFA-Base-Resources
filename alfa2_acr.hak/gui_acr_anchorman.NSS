
#include "acr_anchor_i"


const int ACR_ANCHOR_ACT_CLOSE = 1;
const int ACR_ANCHOR_ACT_REFRESH = 2;
const int ACR_ANCHOR_ACT_ADD = 3;
const int ACR_ANCHOR_ACT_REMOVE_ONE = 4;
const int ACR_ANCHOR_ACT_REMOVE_ALL = 5;
const int ACR_ANCHOR_ACT_JUMP_DM = 6;
const int ACR_ANCHOR_ACT_JUMP_ANCHOR = 7;
const int ACR_ANCHOR_ACT_SELECTED = 8;

const int ACR_ANCHOR_UI_VAR_SELECTED = 10;

const string ACR_ANCHOR_UI_ROW_PREFIX = "index_";


void ACR_GUI_RefreshAnchorList( object oPC ) {
	// Clear our current list.
	ClearListBox( oPC, ACR_ANCR_UI_SCENE, ACR_ANCR_UI_LISTBOX );
	SetLocalGUIVariable( oPC, ACR_ANCR_UI_SCENE, ACR_ANCHOR_UI_VAR_SELECTED, "-1" );
	
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
		string sRowName = ACR_ANCHOR_UI_ROW_PREFIX + sIndex;
		string sTextFields = "txtID=" + sIndex + ";txtName=" + sName + ";txtArea=" + sArea;
		string sTextures = "";
		string sVariables = "10=" + sIndex + ";";
		string sHideUnhide = "";
		
		// Add the data to the list.
		AddListBoxRow( oPC, ACR_ANCR_UI_SCENE, ACR_ANCR_UI_LISTBOX, sRowName, sTextFields, sTextures, sVariables, sHideUnhide );
	}
}


void ACR_GUI_RemoveAnchor( object oPC, string sCallbackRow ) {
	// Call 'remove anchor' on the converted parameter.
	ACR_RemoveAnchor( oPC, StringToInt( sCallbackRow ) );
}


void ACR_GUI_JumpDM( object oPC, string sCallbackRow ) {
	// Limit to DMs.
	if ( !GetIsDM( oPC ) && !GetIsDMPossessed( oPC ) ) {
		SendMessageToPC( oPC, "This function is limited to DMs." );
		return;
	}
	
	// Convert our index and grab our anchor.
	int nIndex = StringToInt( sCallbackRow );
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


void ACR_GUI_JumpAnchor( object oPC, string sCallbackRow ) {
	// Limit to DMs.
	if ( !GetIsDM( oPC ) && !GetIsDMPossessed( oPC ) ) {
		SendMessageToPC( oPC, "This function is limited to DMs." );
		return;
	}

	// Convert our index and grab our anchor.
	int nIndex = StringToInt( sCallbackRow );
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


void ACR_GUI_OnSelectionChanged( object oPC, string sCallbackRow ) {
	int nIndex = StringToInt( sCallbackRow );
}


void main( int nAction, string sParam0, string sParam1, string sParam2 ) {
	object oPC = OBJECT_SELF;
	
	// Main action switch.
	switch ( nAction ) {
		case ACR_ANCHOR_ACT_CLOSE:
			CloseGUIScreen( oPC, ACR_ANCR_UI_SCENE );
			break;
		case ACR_ANCHOR_ACT_REFRESH:
			ACR_GUI_RefreshAnchorList( oPC );
			break;
		case ACR_ANCHOR_ACT_ADD:
			ACR_AddAnchor( oPC, GetPlayerCurrentTarget( oPC ) );
			ACR_GUI_RefreshAnchorList( oPC );
			break;
		case ACR_ANCHOR_ACT_REMOVE_ONE:
			ACR_GUI_RemoveAnchor( oPC, sParam0 );
			ACR_GUI_RefreshAnchorList( oPC );
			break;
		case ACR_ANCHOR_ACT_REMOVE_ALL:
			ACR_RemoveAllAnchors( oPC );
			ACR_GUI_RefreshAnchorList( oPC );
			break;
		case ACR_ANCHOR_ACT_JUMP_DM:
			ACR_GUI_JumpDM( oPC, sParam0 );
			break;
		case ACR_ANCHOR_ACT_JUMP_ANCHOR:
			ACR_GUI_JumpAnchor( oPC, sParam0 );
			break;
		case ACR_ANCHOR_ACT_SELECTED:
			ACR_GUI_OnSelectionChanged( oPC, sParam0 );
			break;
	}
}