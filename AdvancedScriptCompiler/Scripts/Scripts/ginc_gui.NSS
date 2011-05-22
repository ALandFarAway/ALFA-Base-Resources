// ginc_gui.nss
/*
	GUI/Screen campaign include
*/
// BMA-OEI 4/06/06
// BMA-OEI 8/22/06 -- Renamed to ginc_gui, moved GUI_DEATH* to ginc_death
// BMA-OEI 9/28/06 -- Added GUI_PARTY_SELECT_CANCEL

const string GUI_LOAD_GAME			= "SCREEN_LOADGAME";
const string GUI_PARTY_SELECT 		= "SCREEN_PARTYSELECT";
const string GUI_PARTY_SELECT_CANCEL	= "REMOVE_PARTY";
const string GUI_PARTY_SELECT_CLOSE		= "CloseButton";


// Displays Load Game screen to oPC
void ShowLoadGame( object oPC );

// Displays Party Selection screen to oPC
// - bModal: T/F, Display window modally
// - sAcceptCallback: Callback script executed when party is accepted
// - bCloseButton: T/F, Enable close button
void ShowPartySelect( object oPC, int bModal=TRUE, string sAcceptCallback="", int bCloseButton=FALSE );

// Hides Party Selection screen for oPC
void HidePartySelect( object oPC );


// Displays Load Game screen to oPC
void ShowLoadGame( object oPC )
{
	DisplayGuiScreen( oPC, GUI_LOAD_GAME, FALSE );
}

// Displays Party Selection screen to oPC
// - bModal: T/F, Display window modally
// - sAcceptCallback: Callback script executed when party is accepted
// - bCloseButton: T/F, Enable close button
void ShowPartySelect( object oPC, int bModal=TRUE, string sAcceptCallback="", int bCloseButton=FALSE )
{
	SetGUIObjectDisabled( oPC, GUI_PARTY_SELECT, GUI_PARTY_SELECT_CANCEL, !bCloseButton );
	SetGUIObjectDisabled( oPC, GUI_PARTY_SELECT, GUI_PARTY_SELECT_CLOSE, !bCloseButton );
	SetLocalGUIVariable( oPC, GUI_PARTY_SELECT, 0, sAcceptCallback );
	DisplayGuiScreen( oPC, GUI_PARTY_SELECT, TRUE );
}

// Hides Party Selection screen for oPC
void HidePartySelect( object oPC )
{
	CloseGUIScreen( oPC, GUI_PARTY_SELECT );
}