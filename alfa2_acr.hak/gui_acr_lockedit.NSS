
#include "acr_placeable_i"

// UI basic data.
const string ACR_LOCKEDIT_UI_SCENE = "SCREEN_ACR_ELOCK";
const string ACR_LOCKEDIT_UI_FILE = "acr_lockedit.xml";

// UI element names.
const string ACR_LOCKEDIT_UI_ELE_HEALTH_PB = "pbHealth";
const string ACR_LOCKEDIT_UI_ELE_HEALTH_TXT = "txtHealth";

// Action Codes.
const int ACR_LOCKEDIT_UI_ACT_OPEN = 0;
const int ACR_LOCKEDIT_UI_ACT_APPLY = 1;
const int ACR_LOCKEDIT_UI_ACT_RELOAD = 2;
const int ACR_LOCKEDIT_UI_ACT_DESTROY = 3;
const int ACR_LOCKEDIT_UI_ACT_BUMP_HEALTH = 4;
const int ACR_LOCKEDIT_UI_ACT_MAX_HEALTH = 5;
const int ACR_LOCKEDIT_UI_ACT_UNLINK = 6;
const int ACR_LOCKEDIT_UI_ACT_MAKE_KEY = 7;

// Local GUI variables.
const int ACR_LOCKEDIT_UI_VAR_CURRENT_PAGE = 10;
const int ACR_LOCKEDIT_UI_VAR_BOTTOM_TEXT = 11;
const int ACR_LOCKEDIT_UI_VAR_CURRENT_OBJECT = 12;
const int ACR_LOCKEDIT_UI_VAR_NAME = 20;
const int ACR_LOCKEDIT_UI_VAR_TAG = 21;
const int ACR_LOCKEDIT_UI_VAR_HEALTH = 22;
const int ACR_LOCKEDIT_UI_VAR_DESCRIPTION = 23;
const int ACR_LOCKEDIT_UI_VAR_OPEN = 30;
const int ACR_LOCKEDIT_UI_VAR_USABLE = 31;
const int ACR_LOCKEDIT_UI_VAR_PLOT = 32;
const int ACR_LOCKEDIT_UI_VAR_BROKEN = 33;
const int ACR_LOCKEDIT_UI_VAR_BREAK_DC = 34;
const int ACR_LOCKEDIT_UI_VAR_HARDNESS = 35;
const int ACR_LOCKEDIT_UI_VAR_LOCKED = 40;
const int ACR_LOCKEDIT_UI_VAR_KEY_REQ = 41;
const int ACR_LOCKEDIT_UI_VAR_KEY_REQ_MSG = 42;
const int ACR_LOCKEDIT_UI_VAR_KEY_REQ_TAG = 43;
const int ACR_LOCKEDIT_UI_VAR_LOCKABLE = 44;
const int ACR_LOCKEDIT_UI_VAR_LOCK_DC = 45;
const int ACR_LOCKEDIT_UI_VAR_UNLOCK_DC = 46;
const int ACR_LOCKEDIT_UI_VAR_AUTOLOCK = 47;

//
// Function prototypes.
//

void OpenInterface( object oPC, object oTarget );
void ApplyChanges( object oPC, object oTarget, string sName, string sTag, string sHealth, string sDescription, string sOpen, string sUseable, string sPlot, string sBroken, string sBreakDC, string sHardness, string sLocked, string sKeyReq, string sKeyReqMsg, string sKeyTag, string sLockable, string sLockDC, string sUnlockDC, string sAutolock );
void ReloadHealthInformation( object oPC, object oTarget );
void ReloadInformation( object oPC, object oTarget );
void Destroy( object oPC, object oTarget );
void Unlink( object oPC, object oTarget );
void BumpHealth( object oPC, object oTarget, int nHealthMod );

//
// Functions.
//

void OpenInterface( object oPC, object oTarget ) {
	// Get our target.
	if ( !GetIsObjectValid( oTarget ) ) {
		oTarget = GetPlayerCurrentTarget( oPC );
		if ( !GetIsObjectValid( oTarget ) ) {
			SendMessageToPC( oPC, "<C=red>Could not find target!</C>" );
			return;
		}
	}
	
	// Verify type.
	int nObjType = GetObjectType( oTarget );
	if ( nObjType != OBJECT_TYPE_DOOR && nObjType != OBJECT_TYPE_PLACEABLE ) {
		SendMessageToPC( oPC, "<C=red>Invalid object type!</C>" );
		return;
	}
	
	// Open the UI.
	DisplayGuiScreen( oPC, ACR_LOCKEDIT_UI_SCENE, FALSE, ACR_LOCKEDIT_UI_FILE );
	
	// Set our data.
	SetLocalGUIVariable( oPC, ACR_LOCKEDIT_UI_SCENE, ACR_LOCKEDIT_UI_VAR_CURRENT_OBJECT, IntToString(ObjectToInt(oTarget)) );
	
	// Reload everything.
	ReloadInformation( oPC, oTarget );
}


void ApplyChanges( object oPC, object oTarget, string sName, string sTag, string sHealth, string sDescription, string sOpen, string sUseable, string sPlot, string sBroken, string sBreakDC, string sHardness, string sLocked, string sKeyReq, string sKeyReqMsg, string sKeyTag, string sLockable, string sLockDC, string sUnlockDC, string sAutolock ) {
	// Validate target.
	if ( !GetIsObjectValid( oTarget ) ) {
		SendMessageToPC( oPC, "<C=red>Could not find target!</C>" );
		return;
	}
	
	// Data tab.
	SetFirstName( oTarget, sName );
	SetLastName( oTarget, "" );
	SetTag( oTarget, sTag );
	SetDescription( oTarget, sDescription );
	
	// Status tab.
	if ( sOpen == "1" ) AssignCommand( oTarget, ActionOpenDoor( oTarget ) );
	else AssignCommand( oTarget, ActionCloseDoor( oTarget ) );
	SetUseableFlag( oTarget, StringToInt( sUseable ) );
	SetPlotFlag( oTarget, StringToInt( sPlot ) );
	ACR_SetIsBrokenOpen( oTarget, StringToInt( sBroken ) );
	ACR_SetBreakDC( oTarget, StringToInt( sBreakDC ) );
	SetHardness( StringToInt(sHardness), oTarget );
	
	// Lock tab.
	SetLocked( oTarget, StringToInt(sLocked) );
	SetLockKeyRequired( oTarget, StringToInt(sKeyReq) );
	SetKeyRequiredFeedbackMessage( oTarget, sKeyReqMsg );
	SetLockKeyTag( oTarget, sKeyTag );
	SetLockLockable( oTarget, StringToInt(sLockable) );
	SetLockLockDC( oTarget, StringToInt(sLockDC) );
	SetLockUnlockDC( oTarget, StringToInt(sUnlockDC) );
	ACR_SetDoesAutolock( oTarget, StringToInt( sBroken ) );
}


void ReloadHealthInformation( object oPC, object oTarget ) {
	// Validate target.
	if ( !GetIsObjectValid( oTarget ) ) {
		SendMessageToPC( oPC, "<C=red>Could not find target!</C>" );
		return;
	}
	
	// Get health data.
	int nCurHealth = GetCurrentHitPoints( oTarget );
	int nMaxHealth = GetMaxHitPoints( oTarget );
	float fProgress = 1.0f;
	string sHealthText = IntToString(nCurHealth) + "/" + IntToString(nMaxHealth);
	if ( nMaxHealth != 0 ) fProgress = IntToFloat(nCurHealth) / IntToFloat(nMaxHealth);
	if ( fProgress < 0.0f ) fProgress = 0.0f;
	
	// Update UI elements.
	SetGUIProgressBarPosition( oPC, ACR_LOCKEDIT_UI_SCENE, ACR_LOCKEDIT_UI_ELE_HEALTH_PB, fProgress );
	SetGUIObjectText( oPC, ACR_LOCKEDIT_UI_SCENE, ACR_LOCKEDIT_UI_ELE_HEALTH_TXT, -1, sHealthText );
	SetLocalGUIVariable( oPC, ACR_LOCKEDIT_UI_SCENE, ACR_LOCKEDIT_UI_VAR_HEALTH, IntToString(nCurHealth) );
}


void ReloadInformation( object oPC, object oTarget ) {
	// Validate target.
	if ( !GetIsObjectValid( oTarget ) ) {
		SendMessageToPC( oPC, "<C=red>Could not find target!</C>" );
		return;
	}
	
	// Update health info.
	ReloadHealthInformation( oPC, oTarget );
	
	// Set our other data.
	SetLocalGUIVariable( oPC, ACR_LOCKEDIT_UI_SCENE, ACR_LOCKEDIT_UI_VAR_NAME, GetName(oTarget) );
	SetLocalGUIVariable( oPC, ACR_LOCKEDIT_UI_SCENE, ACR_LOCKEDIT_UI_VAR_TAG, GetTag(oTarget) );
	SetLocalGUIVariable( oPC, ACR_LOCKEDIT_UI_SCENE, ACR_LOCKEDIT_UI_VAR_DESCRIPTION, GetDescription(oTarget) );
	SetLocalGUIVariable( oPC, ACR_LOCKEDIT_UI_SCENE, ACR_LOCKEDIT_UI_VAR_OPEN, IntToString(GetIsOpen(oTarget)) );
	SetLocalGUIVariable( oPC, ACR_LOCKEDIT_UI_SCENE, ACR_LOCKEDIT_UI_VAR_USABLE, IntToString(GetUseableFlag(oTarget)) );
	SetLocalGUIVariable( oPC, ACR_LOCKEDIT_UI_SCENE, ACR_LOCKEDIT_UI_VAR_PLOT, IntToString(GetPlotFlag(oTarget)) );
	SetLocalGUIVariable( oPC, ACR_LOCKEDIT_UI_SCENE, ACR_LOCKEDIT_UI_VAR_BROKEN, IntToString(ACR_GetIsBrokenOpen(oTarget)) );
	SetLocalGUIVariable( oPC, ACR_LOCKEDIT_UI_SCENE, ACR_LOCKEDIT_UI_VAR_BREAK_DC, IntToString(ACR_GetBreakDC(oTarget)) );
	SetLocalGUIVariable( oPC, ACR_LOCKEDIT_UI_SCENE, ACR_LOCKEDIT_UI_VAR_HARDNESS, IntToString(GetHardness(oTarget)) );
	SetLocalGUIVariable( oPC, ACR_LOCKEDIT_UI_SCENE, ACR_LOCKEDIT_UI_VAR_LOCKED, IntToString(GetLocked(oTarget)) );
	SetLocalGUIVariable( oPC, ACR_LOCKEDIT_UI_SCENE, ACR_LOCKEDIT_UI_VAR_KEY_REQ, IntToString(GetLockKeyRequired(oTarget)) );
	SetLocalGUIVariable( oPC, ACR_LOCKEDIT_UI_SCENE, ACR_LOCKEDIT_UI_VAR_KEY_REQ_MSG, GetKeyRequiredFeedbackMessage(oTarget) );
	SetLocalGUIVariable( oPC, ACR_LOCKEDIT_UI_SCENE, ACR_LOCKEDIT_UI_VAR_KEY_REQ_TAG, GetLockKeyTag(oTarget) );
	SetLocalGUIVariable( oPC, ACR_LOCKEDIT_UI_SCENE, ACR_LOCKEDIT_UI_VAR_LOCKABLE, IntToString(GetLockLockable(oTarget)) );
	SetLocalGUIVariable( oPC, ACR_LOCKEDIT_UI_SCENE, ACR_LOCKEDIT_UI_VAR_LOCK_DC, IntToString(GetLockLockDC(oTarget)) );
	SetLocalGUIVariable( oPC, ACR_LOCKEDIT_UI_SCENE, ACR_LOCKEDIT_UI_VAR_UNLOCK_DC, IntToString(GetLockUnlockDC(oTarget)) );
	SetLocalGUIVariable( oPC, ACR_LOCKEDIT_UI_SCENE, ACR_LOCKEDIT_UI_VAR_AUTOLOCK, IntToString(ACR_GetDoesAutolock(oTarget)) );
}


void Destroy( object oPC, object oTarget ) {
	// Validate target.
	if ( !GetIsObjectValid( oTarget ) ) {
		SendMessageToPC( oPC, "<C=red>Could not find target!</C>" );
		return;
	}
	
	// Do not delete plot doors.
	if ( GetPlotFlag( oTarget ) ) {
		SendMessageToPC( oPC, "<C=red>You cannot destroy plot objects. Turn off the plot flag if you need to destroy this object.</C>" );
		return;
	}
	
	// Unlink transitions.
	Unlink( oPC, oTarget );
	
	// And finally destroy it.
	DestroyObject( oTarget, 1.0f, FALSE );
	
	// Then close the GUI.
	CloseGUIScreen( oPC, ACR_LOCKEDIT_UI_SCENE );
}


void Unlink( object oPC, object oTarget ) {
	// Validate target.
	if ( !GetIsObjectValid( oTarget ) ) {
		SendMessageToPC( oPC, "<C=red>Could not find target!</C>" );
		return;
	}
	
	// Unlink its transition target if it exists (and is a door).
	object oTransitionTarget = GetTransitionTarget( oTarget );
	if ( GetObjectType( oTransitionTarget ) == OBJECT_TYPE_DOOR ) {
		UnlinkDoor( oTransitionTarget );
	}
	
	// Unlink this object.
	UnlinkDoor( oTarget );
}


void BumpHealth( object oPC, object oTarget, int nHealthMod ) {
	// Validate target.
	if ( !GetIsObjectValid( oTarget ) ) {
		SendMessageToPC( oPC, "<C=red>Could not find target!</C>" );
		return;
	}
	
	// Are we actually bumping health?
	if ( nHealthMod == 0 ) {
		SendMessageToPC( oPC, "<C=red>Cannot modify health by 0.</C>" );
		return;
	}
	
	// Get our adjustment effect.
	effect eHealthMod;
	if ( nHealthMod < 0 ) {
		// Plot objects cannot be harmed.
		if ( GetPlotFlag( oTarget ) ) {
			SendMessageToPC( oPC, "<C=red>You cannot harm plot objects. Turn off the plot flag if you need to damage the object.</C>" );
			return;
		}
		eHealthMod = EffectDamage( nHealthMod * -1 );
	} else {
		eHealthMod = EffectHeal( nHealthMod );
	}
	
	// Apply to the object.
	ApplyEffectToObject( DURATION_TYPE_INSTANT, eHealthMod, oTarget );
	
	// And update our health information in the UI.
	ReloadHealthInformation( oPC, oTarget );
}


void MakeKey( object oPC, object oTarget ) {
	// Validate target.
	if ( !GetIsObjectValid( oTarget ) ) {
		SendMessageToPC( oPC, "<C=red>Could not find target!</C>" );
		return;
	}
	
	// Does it actually have a key to it?
	string sKeyTag = GetLockKeyTag( oTarget );
	if ( sKeyTag == "" ) {
		SendMessageToPC( oPC, "<C=red>This object does not have a paired key.</C>" );
		return;
	}
	
	// Create a dummy key.
	object oKey = CreateItemOnObject( "thnmisc001", oPC, 1, sKeyTag );
	if ( !GetIsObjectValid( oKey ) ) {
		SendMessageToPC( oPC, "<C=red>Could not create key! Please report this issue.</C>" );
		return;
	}
	
	// Set it to look like a key, and change its name/description.
	SetFirstName( oKey, "Key to " + GetName( oTarget ) );
	SetLastName( oKey, "" );
	SetItemIcon( oKey, 1664 );
	SetDescription( oKey, "This key has been generated from the Lock Editor UI by " + GetName( oPC ) + " (" + GetPCPlayerName( oPC ) + ") for the object " + GetName( oTarget ) + " (" + GetTag( oTarget ) + ")." );
}


void main( int nActionCode, int nParam0, string sParam0, string sParam1, string sParam2, string sParam3, string sParam4, string sParam5, string sParam6, string sParam7, string sParam8, string sParam9, string sParam10, string sParam11, string sParam12, string sParam13, string sParam14, string sParam15, string sParam16, string sParam17 ) {
	object oPC = OBJECT_SELF;
	object oTarget = IntToObject( nParam0 );
	
	// Only DMs can use this tool.
	if ( !GetIsDM( oPC ) && !GetIsDMPossessed( oPC ) ) {
		SendMessageToPC( oPC, "Only DMs may use this tool." );
		return;
	}
	
	// What type of event is this?
	switch ( nActionCode ) {
		case ACR_LOCKEDIT_UI_ACT_OPEN:
			OpenInterface( oPC, oTarget );
			break;
		case ACR_LOCKEDIT_UI_ACT_APPLY:
			ApplyChanges( oPC, oTarget, sParam0, sParam1, sParam2, sParam3, sParam4, sParam5, sParam6, sParam7, sParam8, sParam9, sParam10, sParam11, sParam12, sParam13, sParam14, sParam15, sParam16, sParam17 );
			break;
		case ACR_LOCKEDIT_UI_ACT_RELOAD:
			ReloadInformation( oPC, oTarget );
			break;
		case ACR_LOCKEDIT_UI_ACT_DESTROY:
			Destroy( oPC, oTarget );
			break;
		case ACR_LOCKEDIT_UI_ACT_BUMP_HEALTH:
			BumpHealth( oPC, oTarget, StringToInt( sParam0 ) );
			break;
		case ACR_LOCKEDIT_UI_ACT_MAX_HEALTH:
			BumpHealth( oPC, oTarget, 99999 );
			break;
		case ACR_LOCKEDIT_UI_ACT_UNLINK:
			Unlink( oPC, oTarget );
			break;
		case ACR_LOCKEDIT_UI_ACT_MAKE_KEY:
			MakeKey( oPC, oTarget );
			break;
	}
}