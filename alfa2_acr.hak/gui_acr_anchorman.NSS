
#include "acr_anchor_i"

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
	
	SendMessageToPC( oPC, IntToString( nAction ) + " " + sParam0 + " " + sParam1 + " " + sParam2 );
	
	if ( nAction == 2 ) {
		ACR_GUI_RefreshAnchorList( oPC );
	}
}