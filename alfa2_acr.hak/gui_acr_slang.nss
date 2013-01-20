
#include "acr_language_i"

// Language UI Action Codes
const int ACR_LANG_UI_ACT_POPULATE = 1;
const int ACR_LANG_UI_ACT_ONSELECT = 2;

void PopulateLanguageUI( object oPC ) {
	// Clear our current list.
	ClearListBox( oPC, ACR_LANGUI_SCENE, ACR_LANG_UI_LISTBOX );
	
	// Go through our known languages and add them to the UI.
	int i;
	string sLanguageList = ACR_GetLanguageList( oPC );
	int nNumLanguages = GetNumberTokens( sLanguageList, "," );
	for ( i = 0; i < nNumLanguages; i++ ) {
		// Valid anchor?
		string sLanguage = GetTokenByPosition( sLanguageList, ",", i );
		if ( sLanguage == "" ) continue;
		
		// Get data we care about.
		string sName = ACR_LangIDToString( sLanguage );
		string sAbbrev = ACR_LANG_MSG_TOKEN + GetStringLowerCase( GetStringLeft( sLanguage, 3 ) );
		
		// GUI data.
		string sRowName = "lang_" + sLanguage;
		string sTextFields = "txtName=" + sName + ";txtAbbrev=" + sAbbrev + ";";
		string sTextures = "";
		string sVariables = IntToString( ACR_LANG_UI_VAR_SELECTED ) + "=" + sLanguage + ";";
		string sHideUnhide = "";
		
		// Add the data to the list.
		AddListBoxRow( oPC, ACR_LANGUI_SCENE, ACR_LANG_UI_LISTBOX, sRowName, sTextFields, sTextures, sVariables, sHideUnhide );
	}
	
	// Update the current language UI.
	string sCurrentLanguage = ACR_GetDefaultLanguage( oPC );
	if ( sCurrentLanguage == "" ) sCurrentLanguage = "common";
	SetGUIObjectText( oPC, ACR_LANGUI_SCENE, ACR_LANG_UI_CURRENT, -1, ACR_LangIDToString( sCurrentLanguage ) );
}


void OnLanguageSelected( object oPC, string sLanguage ) {
	// Do they know the language?
	if ( !ACR_IsLanguageKnown( oPC, sLanguage ) ) {
		SendMessageToPC( oPC, "You may not speak languages you do not know." );
		return;
	}

	ACR_SetDefaultLanguage( oPC, sLanguage );
	SetGUIObjectText( oPC, ACR_LANGUI_SCENE, ACR_LANG_UI_CURRENT, -1, ACR_LangIDToString( sLanguage ) );
}


void main( int iAction, string sParam0 ) {
	object oPC = OBJECT_SELF;
	
	switch ( iAction ) {
		case ACR_LANG_UI_ACT_POPULATE:
			PopulateLanguageUI( oPC );
			break;
		case ACR_LANG_UI_ACT_ONSELECT:
			OnLanguageSelected( oPC, sParam0 );
			break;
	}
}