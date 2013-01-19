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

#include "acr_anchor_i"


void main( int nAction, string sParam0, string sParam1, string sParam2 ) {
	object oPC = OBJECT_SELF;
	
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

