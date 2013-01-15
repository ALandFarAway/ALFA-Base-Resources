////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_ugui_i.nss
//      Version : 1.0
//         Date : 2012-01-08
//       Author : FoamBats4All
//
//  Local Variable Prefix:
//	ACR_UGUI
//
//  Dependencies:
//	None.
//
//  Description:
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// UI Scene and File Data
const string ACR_UGUI_SCENE = "SCREEN_ACR_UGUI";
const string ACR_UGUI_FILE = "alfaui.xml";
const string ACR_UGUI_MAINOBJ = "UGUI_MainInterface";

// Player Local Variables
const string ACR_UGUI_CURRENT_CAT = "ACR_UGUI_CURRENT_CAT";
const string ACR_UGUI_CURRENT_SUBCAT = "ACR_UGUI_CURRENT_SUBCAT";

// Callback Actions
const int ACR_UGUI_ACT_CALL_INTERFACE = 1;
const int ACR_UGUI_ACT_SET_COLLAPSED = 2;
const int ACR_UGUI_ACT_OPEN_CATEGORY = 3;
const int ACR_UGUI_ACT_OPEN_SUBCATEGORY = 4;

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! Opens the ALFA Universal UI, enabling sections of the UI meant for DMs if
//! called on a DM.
//!  - oPC : Player character or DM avatar to show the UI to.
void ACR_OpenUniversalGUI( object oPC );

void ACR_UGUI_SetCollapsed( object oPC, int bCollapsed );

//! Tells the UI to open a particular category.
//!  - oPC : Player character or DM avatar.
//!  - sCategory : Category to display or toggle.
void ACR_UGUI_SetCurrentCategory( object oPC, string sCategory );

void ACR_UGUI_CloseCurrentSubcategory( object oPC );

void ACR_UGUI_SetCurrentSubcategory( object oPC, string sSubcategory );


////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void ACR_OpenUniversalGUI( object oPC ) {
	// Open the screen.
	DisplayGuiScreen( oPC, ACR_UGUI_SCENE, FALSE, ACR_UGUI_FILE );
	
	// Enable DM options.
//	if ( GetIsDM( oPC ) ) {
		// Enable DM categories.
		SetGUIObjectHidden( oPC, ACR_UGUI_SCENE, "UGUI_CATEGORY_GRID_PLAYER", TRUE );
		SetGUIObjectHidden( oPC, ACR_UGUI_SCENE, "UGUI_CATEGORY_GRID_DM", FALSE );
//	}
}


void ACR_UGUI_SetCollapsed( object oPC, int bHidden ) {
	SetGUIObjectHidden( oPC, ACR_UGUI_SCENE, ACR_UGUI_MAINOBJ, bHidden );
	SetGUIObjectHidden( oPC, ACR_UGUI_SCENE, "UGUI_CollapseBtnMin", bHidden );
	SetGUIObjectHidden( oPC, ACR_UGUI_SCENE, "UGUI_CollapseBtnMax", !bHidden );
}


void ACR_UGUI_SetCurrentCategory( object oPC, string sCategory ) {
	// Valid parameters?
	if ( !GetIsObjectValid( oPC ) ) return;
	if ( sCategory == "" ) return;

	// Get and disable our current category.
	string sCurCategory = GetLocalString( oPC, ACR_UGUI_CURRENT_CAT );
	if ( sCurCategory != "" ) {
		SetGUIObjectHidden( oPC, ACR_UGUI_SCENE, sCurCategory, TRUE );
		SetGUIObjectHidden( oPC, ACR_UGUI_SCENE, sCurCategory + "_HINT", TRUE );
	}
	
	// Get and disable our current subcategory.
	ACR_UGUI_CloseCurrentSubcategory( oPC );
	
	// Allow toggling by clicking the same category twice.
	if ( sCurCategory == sCategory ) {
		DeleteLocalString( oPC, ACR_UGUI_CURRENT_CAT );
		return;
	}
	
	// Show new category.
	SetGUIObjectHidden( oPC, ACR_UGUI_SCENE, sCategory, FALSE );
	SetGUIObjectHidden( oPC, ACR_UGUI_SCENE, sCategory + "_HINT", FALSE );
	SetLocalString( oPC, ACR_UGUI_CURRENT_CAT, sCategory );
}


void ACR_UGUI_CloseCurrentSubcategory( object oPC ) {
	// Valid parameters?
	if ( !GetIsObjectValid( oPC ) ) return;

	// Get and disable our current subcategory.
	string sCurSubcategory = GetLocalString( oPC, ACR_UGUI_CURRENT_SUBCAT );
	if ( sCurSubcategory != "" ) {
		SetGUIObjectHidden( oPC, ACR_UGUI_SCENE, sCurSubcategory, TRUE );
		DeleteLocalString( oPC, ACR_UGUI_CURRENT_SUBCAT );
	}
}


void ACR_UGUI_SetCurrentSubcategory( object oPC, string sSubcategory ) {
	// Valid parameters?
	if ( !GetIsObjectValid( oPC ) ) return;
	if ( sSubcategory == "" ) return;
	
	// Get and disable our current subcategory.
	string sCurSubcategory = GetLocalString( oPC, ACR_UGUI_CURRENT_SUBCAT );
	ACR_UGUI_CloseCurrentSubcategory( oPC );
	
	// Allow toggling by clicking the same category twice.
	if ( sCurSubcategory == sSubcategory ) return;
	
	// Show new subcategory.
	SetGUIObjectHidden( oPC, ACR_UGUI_SCENE, sSubcategory, FALSE );
	SetLocalString( oPC, ACR_UGUI_CURRENT_SUBCAT, sSubcategory );
}