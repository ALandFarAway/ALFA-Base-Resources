
#include "acr_anchor_i"

const int ACTION_CLOSE = 1;
const int ACTION_REFRESH = 2;
const int ACTION_ADD = 3;
const int ACTION_REMOVE_ONE = 4;
const int ACTION_REMOVE_ALL = 5;
const int ACTION_JUMP_DM = 6;
const int ACTION_JUMP_ANCHOR = 7;

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
		string sVariables = "";
		string sHideUnhide = "";
		
		// Add the data to the list.
		AddListBoxRow( oPC, ACR_ANCR_UI_SCENE, ACR_ANCR_UI_LISTBOX, sRowName, sTextFields, sTextures, sVariables, sHideUnhide );
	}
}

void main( int nAction, string sParam0, string sParam1, string sParam2 ) {
	object oPC = OBJECT_SELF;
	
	switch ( nAction ) {
		case ACTION_CLOSE:
			CloseGUIScreen( oPC, ACR_ANCR_UI_SCENE );
			break;
		case ACTION_REFRESH:
			ACR_GUI_RefreshAnchorList( oPC );
			break;
		case ACTION_ADD:
			ACR_AddAnchor( oPC, GetPlayerCurrentTarget( oPC ) );
			ACR_GUI_RefreshAnchorList( oPC );
			break;
		case ACTION_REMOVE_ONE:
			ACR_GUI_RefreshAnchorList( oPC );
			break;
		case ACTION_REMOVE_ALL:
			ACR_RemoveAllAnchors( oPC );
			ACR_GUI_RefreshAnchorList( oPC );
			break;
		case ACTION_JUMP_DM:
			
			break;
		case ACTION_JUMP_ANCHOR:
			
			break;
	}
}