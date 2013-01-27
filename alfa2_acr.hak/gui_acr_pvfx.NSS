#include "acr_vfx_i"

// Personal VFX GUI action codes.
const int ACR_PVFX_GUI_ACT_REFRESH = 0;
const int ACR_PVFX_GUI_ACT_APPLY = 1;
const int ACR_PVFX_GUI_ACT_REMOVE = 2;
const int ACR_PVFX_GUI_ACT_REMOVE_ALL = 3;
const int ACR_PVFX_GUI_ACT_SET_TARGET = 4;

void main( int nActionCode, int nTarget, int nParam0 ) {
	// Determine who we are manipulating.
	object oPC = OBJECT_SELF;
	object oTarget = IntToObject( nTarget );
	if ( !GetIsObjectValid( oTarget ) ) oTarget = oPC;
	
	// Non-DMs can only target themselves.
	if ( !GetIsDM( oPC ) && !GetIsDMPossessed( oPC ) ) {
		oTarget = oPC;
	}
	
	switch ( nActionCode ) {
		case ACR_PVFX_GUI_ACT_REFRESH:
			ACR_RefreshPersonalVFXUI( oTarget );
			break;
		case ACR_PVFX_GUI_ACT_APPLY:
			ACR_ApplyPersonalVFX( oTarget, nParam0 );
			break;
		case ACR_PVFX_GUI_ACT_REMOVE:
			ACR_RemovePersonalVFX( oTarget, nParam0 );
			break;
		case ACR_PVFX_GUI_ACT_REMOVE_ALL:
			ACR_RemoveAllPersonalVFX( oTarget );
			break;
		case ACR_PVFX_GUI_ACT_SET_TARGET:
			SetLocalGUIVariable( oPC, ACR_PVFX_GUI_SCENE, ACR_PVFX_GUI_LVAR_TARGET, IntToString( nTarget ) );
			break;
	}
}