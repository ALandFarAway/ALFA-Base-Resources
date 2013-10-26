////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_door_i
//    $Revision:: 430        $ current version of the file
//        $Date:: 2007-10-04#$ date the file was created or modified
//       Author : Ronan & AcadiusLost & Cipher
//
//  Local Variable Prefix = ACR_DOOR
//
//
//  Dependencies external of nwscript:
//  Configurable options, see the ACR_DOOR_* local variables.
//
//  Description
//  This script contains all the event handlers for doors, and all other
//  functions which act specifically on doors.
//
//  Revision History
//  2006/06/04  Ronan  Inception
//  2007/03/18  AcadiusLost  Switched include to acr_area_i.nss
//  2007/06/07  Cipher  Added OnDisarm and OnTrapTriggered placeholders
//  2007/07/03  ?
//  2007/09/22  AcadiusLost - removed AssignCommands for door operations
//                  also added ACR_CloseDoor() for calling from contextmenu.
////////////////////////////////////////////////////////////////////////////////

#ifndef ACR_DOOR_I
#define ACR_DOOR_I

// This include must be done prematurely due to dependent constants.
#include "acr_tools_i"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// The strength check DC required to break this door open.
const string _DOOR_BREAK_DC_LI = "ACR_DOOR_BREAK_DC";

// The local float on every door describing how long it takes to close on its
// own if left open.
const string _AUTO_CLOSE_DELAY_LF = "ACR_DOOR_CLOSE_DELAY";

// Boolean which indicates if a door locks itself when closing automatically.
const string _AUTO_LOCK_LI = "ACR_DOOR_AUTO_LOCK";

// The local int which decides whether or not we do these behaviors if a PC is
// nearby. If nonzero, the proximity of PCs is ignored.
const string _AUTO_CLOSE_WITH_PC_NEAR_LI = "ACR_DOOR_CLOSE_NEAR_PCS";

// If set to 1, the object is considered stuck, as per DMG rules.
const string _IS_STUCK_LI = "ACR_DOOR_IS_STUCK";

// This is a custom message sent to PCs who try to open the door and fail.
const string _FAILED_TO_OPEN_MESSAGE_LS = "ACR_DOOR_FAIL_OPEN_MESSAGE";

// This is the time of day the door unlocks itself, from 0 to 23.
const string _UNLOCK_HOUR_LI = "ACR_DOOR_UNLOCK_HOUR";

// This is the time of day the door locks itself, from 0 to 23.
const string _LOCK_HOUR_LI = "ACR_DOOR_LOCK_HOUR";

// The setting which indicates if a door automatically "sticks" when open or closed.
const string _AUTOSTUCK_LI = "ACR_DOOR_AUTOSTICKS";
const int _AUTOSTICK_CLOSED = 1;
const int _AUTOSTICK_OPEN = 2;
const int _AUTOSTICK_BOTH = 3;

const string _DOOR_HEARTBEAT_SCRIPT = "ACR_DOOR_ON_HEARTBEAT";

// Integer which combines all of the above booleans and integers into one local
// variable.
const string _DOOR_STATUS = "ACR_DOOR_S";
const int _BREAK_DC_START_POS = 0;
const int _BREAK_DC_END_POS = 7;
const int _UNLOCK_HOUR_START_POS = 8;
const int _UNLOCK_HOUR_END_POS = 12;
const int _LOCK_HOUR_START_POS = 13;
const int _LOCK_HOUR_END_POS = 17;
const int _AUTOSTUCK_CLOSED = BIT_24;
const int _AUTOSTUCK_OPEN = BIT_25;
const int _IS_STUCK = BIT_26;
const int _IS_BROKEN_OPEN = BIT_27;
const int _IS_INITIALIZED = BIT_28;
const int _CLOSE_NEAR_PCS = BIT_29;
const int _IS_AUTO_LOCKED = BIT_30;
const int _WAS_LOCKABLE = BIT_31;

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! *** PUBLIC FUNCTIONS ***

//! The event handler for a creature clicking on a door AT.
void ACR_DoorOnAreaTransitionClick();

//! The event handler for a door closing.
void ACR_DoorOnClose();

//! The event handler for a door being damaged.
void ACR_DoorOnDamaged();

//! The event handler for a door being destroyed.
void ACR_DoorOnDeath();

//! The event handler for a door trap being disarmed.
void ACR_DoorOnDisarm();

//! The event handler for a door trap being triggered.
void ACR_DoorOnTrapTriggered();

//! The event handler for a creature failing to open a door.
void ACR_DoorOnFailToOpen();

//! The event handler for a door's heartbeat.
void ACR_DoorOnHeartbeat();

//! The event handler for a door being locked.
void ACR_DoorOnLock();

//! The event handler for a door opening.
void ACR_DoorOnOpen();

//! The event handler for a door being physically attacked.
void ACR_DoorOnPhysicalAttacked();

//! The event handler for a door having a spell cast at it.
void ACR_DoorOnSpellCastAt();

//! The event handler for a door being unlocked.
void ACR_DoorOnUnlock();

//! The user-defined event handler for a door.
void ACR_DoorOnUserDefined();

//! The event handler for a conversation.
void ACR_DoorOnConversation();

//! Returns 1 if the door has been forced open, and 0 otherwise.
int ACR_GetIsDoorForcedOpen(object oDoor);

//! Returns the strength-check DC needed to break open oDoor.
int ACR_GetDoorBreakOpenDC(object oDoor);

//! Processes an event of oPC attempting to force open oDoor.
//!  - nRollModifier: A modifier applied to the roll to break the door open.
void ACR_DoorOnBreakOpenAttempt(object oDoor, object oPC, int nRollModifier = 0);

//! Sets a door as being stuck.
void ACR_DoorSetIsStuck(object oDoor);

//! Sets a door as not being stuck.
void ACR_DoorSetIsNotStuck(object oDoor);

//! Sets a door as being broken open.
void ACR_DoorSetIsBroken(object oDoor);

//! Sets a door as not being broken open.
void ACR_DoorSetIsNotBroken(object oDoor);

//! Sets whether or not oDoor automatically locks itself when it closes.
void ACR_DoorIsAutoLocked(object oDoor, int bAutoLocked);

//! Gets whether or not oDoor is stuck.
int ACR_DoorGetIsStuck(object oDoor);

//! Gets whether or not oDoor has been broken open.
int ACR_DoorGetIsBroken(object oDoor);

//! Gets whether or not oDoor automatically locks when it is closed.
int ACR_DoorGetIsAutoLocked(object oDoor);

//! Called to script-close a door from the radial/contextmenu
void ACR_CloseDoor(object oDoor);

//! *** PRIVATE FUNCTIONS ***

//! Initializes oDoor if it has not already been initialized, 
//! and returns its status data.
int _InitializeDoor(object oDoor);

//! Private function for handling a failure to open a door regardless of the
//! event that caused it.
void _DoorOnFailToOpen(object oPC);

//! Private polling function which auto-closes doors.
void _AutoClose(object oDoor, float fDelay, int nStatus);

//! Private scheduled function which auto-locks doors.
void _AutoLock(object oDoor, int nStatus);

//! Private scheduled function which auto-unlocks doors.
void _AutoUnlock(object oDoor, int nStatus);

//! Returns the strength-check DC needed to break this door open, given the door
//! and its status integer.
int _GetDoorBreakOpenDC(object oDoor, int nStatus);

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_physical_object_i"
#include "acr_area_i"

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// *** BEGIN PUBLIC FUNCTIONS ***
////////////////////////////////////////////////////////////////////////////////

void ACR_DoorOnAreaTransitionClick() {	
	_InitializeDoor(OBJECT_SELF);
    ACR_OnAreaTransitionClick();
}

void ACR_DoorOnClose() {
	int nStatus = _InitializeDoor(OBJECT_SELF);
	object oCloser = GetLastClosedBy();
	
    if( nStatus & _IS_AUTO_LOCKED && !(nStatus & _IS_BROKEN_OPEN) ) {
        SetLocked(OBJECT_SELF, 1);
    }

	// Sync up with the door on the other side of the AT, if any.
	object oAT = GetTransitionTarget(OBJECT_SELF);	
    if(GetIsObjectValid(oAT) && GetIsOpen(oAT)) {
		ActionCloseDoor(oAT);
    }
}

void ACR_DoorOnDamaged() {
	_InitializeDoor(OBJECT_SELF);
    object oAT = GetTransitionTarget(OBJECT_SELF);

    if(GetLastDamager() == oAT) {
        return;
    }

    if(oAT != OBJECT_INVALID) {
        int nDamage = GetTotalDamageDealt(); // + GetHardness(oAT);
        // Possible some doors would have resistance to magical damage? Fix?
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamage), oAT);
    }
}

void ACR_DoorOnDeath() {
    // Necissary in NWN2?
	object oKiller = GetLastKiller();
	if(oKiller != OBJECT_SELF && oKiller != GetTransitionTarget(OBJECT_SELF)) {
    	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), GetTransitionTarget(OBJECT_SELF));
	}
}

void ACR_DoorOnDisarm()
{
}

//! The event handler for a door trap being triggered.
void ACR_DoorOnTrapTriggered()
{
}

void ACR_DoorOnFailToOpen() {
	_InitializeDoor(OBJECT_SELF);
    object oPC = GetClickingObject();
    if( oPC == OBJECT_SELF ) {
        return;
    }
    _DoorOnFailToOpen(oPC);
}

void ACR_DoorOnHeartbeat() {
	_InitializeDoor(OBJECT_SELF);
	SetEventHandler(OBJECT_SELF, SCRIPT_DOOR_ON_HEARTBEAT, GetLocalString(OBJECT_SELF, _DOOR_HEARTBEAT_SCRIPT));
    // FIX ME FOR NWN2 !!
    // We need to remove this hearbeat script entirely, using NWN2's
    // ability to set the event scripts of objects.
}

void ACR_DoorOnLock() {
	int nStatus = _InitializeDoor(OBJECT_SELF);
    object oLastLocked = GetLastLocked();
    object oAT = GetTransitionTarget(OBJECT_SELF);
	object oLocker = GetLastLocked();

	if(GetObjectType(oLocker) == OBJECT_TYPE_CREATURE && !GetIsDM(oLocker)) {
	    if(nStatus & _IS_BROKEN_OPEN) {
	        FloatingTextStringOnCreature("*The door has been broken open, and cannot be locked*", GetLastLocked());
	        SetLocked(OBJECT_SELF, 0);
	        SetLocked(oAT, 0);
	        return;
	    }
	}
	
    if(!GetLocked(oAT)) {
        SetLocked(oAT, 1);
    }
}

void ACR_DoorOnOpen() {
	int nStatus = _InitializeDoor(OBJECT_SELF);
	object oOpener = GetLastOpenedBy();
	object oAT =  GetTransitionTarget(OBJECT_SELF);
	
	// Did a non-DM creature try to open the door?
	if(GetObjectType(oOpener) == OBJECT_TYPE_CREATURE && !GetIsDM(oOpener)) {
		// If so, check to see if its openable.
	    if( nStatus & _IS_STUCK ) {        
	        ClearAllActions(TRUE);
	        ActionCloseDoor(OBJECT_SELF);
			SpeakString("*the door is firmly stuck, and will not open*");		
	        _DoorOnFailToOpen(oOpener);
	        return;
	    }
	
	    /*if( GetHasSpellEffect(SPELL_ARCANE_LOCK, OBJECT_SELF)
	    	|| GetHasSpellEffect(SPELL_HOLD_PORTAL, OBJECT_SELF) ) {
	        ClearAllActions(TRUE);
	        ActionCloseDoor(OBJECT_SELF);
	        object oPC = GetLastUnlocked();
	        SpeakString("*an unseen force holds the door shut*");
	        _DoorOnFailToOpen(oOpener);
	        return;
	    } Fix me !! uncomment when these spells are added. */
	}
	
	// Check for auto-close settings.
	float fDelay = GetLocalFloat(OBJECT_SELF, _AUTO_CLOSE_DELAY_LF);
	if(fDelay > 0.0) {
		//SendMessageToPC(oPC, "Door closing in: " + FloatToString(fDelay, 3, 0) + " seconds.");
		DelayCommand( fDelay, _AutoClose(OBJECT_SELF, fDelay, nStatus) );
	}
	
	if(GetIsObjectValid(oAT) && !GetIsOpen(oAT)) // Is the door on the other side of the AT open?	
		ActionOpenDoor(oAT);
}

void ACR_DoorOnPhysicalAttacked() {
	_InitializeDoor(OBJECT_SELF);
}

void ACR_DoorOnSpellCastAt() {
	_InitializeDoor(OBJECT_SELF);
}

void ACR_DoorOnUnlock() {
	_InitializeDoor(OBJECT_SELF);
    object oPC = GetLastUnlocked();
    object oAT = GetTransitionTarget(OBJECT_SELF);

    if(GetLocked(oAT)) {
        SetLocked(oAT, 0);
    }
}

void ACR_DoorOnUserDefined() {
	_InitializeDoor(OBJECT_SELF);
}

void ACR_DoorOnExamined() {
    // FIX ME FOR NWN2 !!!
    // Add a way to judge a door's status. Forced open, damaged, etc.
}

void ACR_DoorOnConversation() {
}

int ACR_GetDoorIsStuck(object oDoor) {
    return _InitializeDoor(OBJECT_SELF) & _IS_STUCK;
}

int ACR_GetIsDoorForcedOpen(object oDoor) {
    return _InitializeDoor(OBJECT_SELF) & _IS_BROKEN_OPEN;
}

int ACR_GetDoorBreakOpenDC(object oDoor) {
    return _GetDoorBreakOpenDC(oDoor, _InitializeDoor(OBJECT_SELF));
}

void ACR_DoorOnBreakOpenAttempt(object oDoor, object oPC, int nRollModifier = 0) {
	int nStatus = _InitializeDoor(OBJECT_SELF);
    if(GetIsOpen(oDoor) || GetObjectType(oDoor) != OBJECT_TYPE_DOOR) {
        return;
    }

    if(nStatus & _IS_BROKEN_OPEN) {
        // Its already been forced open.
        ActionOpenDoor(oDoor);
        AssignCommand(oDoor, ActionSpeakString("*The door swings open quickly, its lock already broken*"));
        return;
    }
    int nDC = ACR_GetDoorBreakOpenDC(oDoor);
    //SendMessageToPC(oPC, "Force open door DC: " + IntToString(nDC));
    int nRollNeeded = nDC - GetAbilityModifier(ABILITY_STRENGTH, oPC) - nRollModifier - ACR_GetBreakSizeModifier(GetCreatureSize(oPC));

    if(nRollNeeded > 20 || !nDC) {
        // Success is impossible.
        AssignCommand(oDoor, ActionSpeakString("*The door doesn't budge a bit*"));
        return;
    }

    if(d20() >= nRollNeeded) {
        // Successfully forced the door open.
        ACR_DoorSetIsBroken(oDoor);
		ACR_DoorSetIsNotStuck(oDoor);
        AssignCommand(oDoor, ActionOpenDoor(oDoor));
        AssignCommand(oDoor, ActionSpeakString("*The door's lock breaks, and it flies open*"));

        object oATDoor = GetTransitionTarget(oDoor);
        ACR_DoorSetIsBroken(oATDoor);
		ACR_DoorSetIsNotStuck(oATDoor);
        AssignCommand(oATDoor, ActionOpenDoor(oATDoor));
        AssignCommand(oATDoor, ActionSpeakString("*The door's lock breaks, and it flies open*"));
        return;
    }
    // Failure, but lets give the PC a message so they know what their chances
    // are.
    if(nRollNeeded > 18) {
        AssignCommand(oDoor, ActionSpeakString("*The door gives way very slightly*"));
    } else if(nRollNeeded > 12) {
        AssignCommand(oDoor, ActionSpeakString("*The door gives way a little*"));
    } else {
        AssignCommand(oDoor, ActionSpeakString("*The door creaks under the strain, but holds fast for now*"));
    }
}

void ACR_DoorSetIsStuck(object oDoor) {
    int nStatus = _InitializeDoor(OBJECT_SELF);
    object oATDoor = GetTransitionTarget(oDoor);
    int nATStatus = GetLocalInt(oATDoor, _DOOR_STATUS);
    
	SetLocalInt(oDoor, _DOOR_STATUS, nStatus | _IS_STUCK);
    SetLocalInt(oATDoor, _DOOR_STATUS, nATStatus | _IS_STUCK);
}

void ACR_DoorSetIsNotStuck(object oDoor) {
    int nStatus = _InitializeDoor(OBJECT_SELF);
    object oATDoor = GetTransitionTarget(oDoor);
    int nATStatus = GetLocalInt(oATDoor, _DOOR_STATUS);
    
	SetLocalInt(oDoor, _DOOR_STATUS, nStatus & ~_IS_STUCK);
    SetLocalInt(oATDoor, _DOOR_STATUS, nATStatus & ~_IS_STUCK);
}

void ACR_DoorSetIsBroken(object oDoor) {
    int nStatus = _InitializeDoor(OBJECT_SELF);
    object oATDoor = GetTransitionTarget(oDoor);
    int nATStatus = GetLocalInt(oATDoor, _DOOR_STATUS);
    
    SetLocalInt(oDoor, _DOOR_STATUS, nStatus | _IS_BROKEN_OPEN);
    SetLocalInt(oATDoor, _DOOR_STATUS, nATStatus | _IS_BROKEN_OPEN);
	SetLocked(oDoor, 0);
	SetLocked(oATDoor, 0);
    //SetLockLockable(oDoor, 0);
    //SetLockLockable(oATDoor, 0);
}

void ACR_DoorSetIsNotBroken(object oDoor) {
    int nStatus = _InitializeDoor(OBJECT_SELF);
    object oATDoor = GetTransitionTarget(oDoor);
    int nATStatus = GetLocalInt(oATDoor, _DOOR_STATUS);
	
	SetLocalInt(oDoor, _DOOR_STATUS, nStatus & ~_IS_BROKEN_OPEN);
	SetLocalInt(oATDoor, _DOOR_STATUS, nATStatus & ~_IS_BROKEN_OPEN);
	//SetLockLockable(oDoor, nStatus | _WAS_LOCKABLE);
	//SetLockLockable(oATDoor, nStatus | _WAS_LOCKABLE);
}

void ACR_DoorIsAutoLocked(object oDoor, int bAutoLocked) {
    int nStatus = _InitializeDoor(OBJECT_SELF);
    object oATDoor = GetTransitionTarget(oDoor);
    int nATStatus = GetLocalInt(oATDoor, _DOOR_STATUS);
    if(bAutoLocked) {
        SetLocalInt(oDoor, _DOOR_STATUS, nStatus | _IS_AUTO_LOCKED);
        SetLocalInt(oATDoor, _DOOR_STATUS, nATStatus | _IS_AUTO_LOCKED);
    } else {
        SetLocalInt(oDoor, _DOOR_STATUS, nStatus & ~_IS_AUTO_LOCKED);
        SetLocalInt(oATDoor, _DOOR_STATUS, nATStatus & ~_IS_AUTO_LOCKED);
    }
}

int ACR_DoorGetIsStuck(object oDoor) {
    return GetLocalInt(oDoor, _DOOR_STATUS) & _IS_STUCK;
}

int ACR_DoorGetIsBroken(object oDoor) {
    return GetLocalInt(oDoor, _DOOR_STATUS) & _IS_BROKEN_OPEN;
}

int ACR_DoorGetIsAutoLocked(object oDoor) {
    return GetLocalInt(oDoor, _DOOR_STATUS) & _IS_AUTO_LOCKED;
}

void ACR_CloseDoor(object oDoor) {
	ActionCloseDoor(oDoor);
}


////////////////////////////////////////////////////////////////////////////////
// *** BEGIN PRIVATE FUNCTIONS ***
////////////////////////////////////////////////////////////////////////////////

int _InitializeDoor(object oDoor) {
	if(GetObjectType(oDoor) != OBJECT_TYPE_DOOR) {
		return 0;
	}
	
    int nStatus = GetLocalInt(oDoor, _DOOR_STATUS);
	
    if(!(nStatus & _IS_INITIALIZED)) {
        if( !GetPlotFlag() ) {
            ACR_InitializePhysicalObject(oDoor);
        }

        int nBreakDC = GetLocalInt(oDoor, _DOOR_BREAK_DC_LI);
        nStatus = nStatus | (nBreakDC << (_BREAK_DC_START_POS));
        DeleteLocalInt(oDoor, _DOOR_BREAK_DC_LI);

        int nUnlockHour = GetLocalInt(oDoor, _UNLOCK_HOUR_LI);
        nUnlockHour = ApplyIntegerLimit(nUnlockHour, 0, 23);
        nStatus = nStatus | (nUnlockHour << (_UNLOCK_HOUR_START_POS) );
        DeleteLocalInt(oDoor, _UNLOCK_HOUR_LI);

        int nLockHour = GetLocalInt(oDoor, _LOCK_HOUR_LI);
        nUnlockHour = ApplyIntegerLimit(nUnlockHour, 0, 23);
        nStatus = nStatus | (nUnlockHour << (_LOCK_HOUR_START_POS) );
        DeleteLocalInt(oDoor, _LOCK_HOUR_LI);

        if(GetLocalInt(oDoor, _IS_STUCK_LI)) {
            nStatus = nStatus | _IS_STUCK;
        }
        DeleteLocalInt(oDoor, _IS_STUCK_LI);

        if(GetLocalInt(oDoor, _AUTO_CLOSE_WITH_PC_NEAR_LI)) {
            nStatus = nStatus | _CLOSE_NEAR_PCS;
        }
        DeleteLocalInt(oDoor, _AUTO_CLOSE_WITH_PC_NEAR_LI);

        if(GetLocalInt(oDoor, _AUTO_LOCK_LI)) {
            nStatus = nStatus | _IS_AUTO_LOCKED;
        }
        if(GetLockLockable(oDoor)) {
            nStatus = nStatus | _WAS_LOCKABLE;
        }
		
		int nAutostick = GetLocalInt(oDoor, _AUTOSTUCK_LI);
		switch(nAutostick) {
			case _AUTOSTICK_CLOSED:
				nStatus = nStatus | _AUTOSTUCK_CLOSED;
				break;
			
			case _AUTOSTICK_OPEN:
				nStatus = nStatus | _AUTOSTUCK_OPEN;
				break;
				
			case _AUTOSTICK_BOTH:
				nStatus = nStatus | _AUTOSTUCK_OPEN | _AUTOSTUCK_CLOSED;
				break;
		}

        nStatus = nStatus | _IS_INITIALIZED;

        object oAT = GetTransitionTarget(oDoor);
        if( nUnlockHour != nLockHour ) {
            if( GetIsIntegerInWindow(GetTimeHour(), nUnlockHour, nLockHour) ) {
                DelayCommand( ACR_GetSecondsUntilNextHour(nLockHour), _AutoLock(oDoor, nStatus) );
                SetLocked(oDoor, 0);
            } else {
                DelayCommand( ACR_GetSecondsUntilNextHour(nUnlockHour), _AutoUnlock(oDoor, nStatus) );
                SetLocked(oDoor, 1);
            }
        }

        SetLocalInt(oDoor, _DOOR_STATUS, nStatus);
    }
	return nStatus;
}

void _DoorOnFailToOpen(object oPC) {
    string sMsg = GetLocalString(OBJECT_SELF, _FAILED_TO_OPEN_MESSAGE_LS);
    if(sMsg != "") {
        FloatingTextStringOnCreature(sMsg, oPC, TRUE);
    }
}

void _AutoClose(object oDoor, float fDelay, int nStatus) {

    if(!GetIsOpen(oDoor)) {
        return;
    }
	
	object oAT = GetTransitionTarget(oDoor);

    if(!(nStatus & _CLOSE_NEAR_PCS)) {
        object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oDoor);
        float fDistance = GetDistanceBetween(oPC, oDoor);
		object oOtherPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oAT);
		float fOtherDistance = GetDistanceBetween(oPC, oAT);
		//SendMessageToPC(oPC, "You are " + FloatToString(fDistance, 3, 0) + "m away.");
        if((fDistance <= PC_PERCEPTION_RANGE && fDistance > 0.0) || (fOtherDistance <= PC_PERCEPTION_RANGE && fOtherDistance > 0.0)) {
            DelayCommand(fDelay, _AutoClose(oDoor, fDelay, nStatus));
            return;
        }
    }
    ActionCloseDoor(oDoor);
	ActionCloseDoor(oAT);	
}

int _GetDoorBreakOpenDC(object oDoor, int nStatus) {

    int nBreakDC = GetPiecewiseInteger( nStatus, _BREAK_DC_START_POS, _BREAK_DC_END_POS );

    if(GetPlotFlag(oDoor) || !nBreakDC) {
        return 0;
    }

    if( GetCurrentHitPoints(oDoor) <= (GetMaxHitPoints(oDoor) / 2) ) {
        nBreakDC = nBreakDC - 2;
    }

    /*if( GetHasSpellEffect(SPELL_ARCANE_LOCK, oDoor) ) {
        nBreakDC = nBreakDC + 10;
    }

    if( GetHasSpellEffect(SPELL_HOLD_PORTAL, oDoor) ) {
        nBreakDC = nBreakDC + 5;
    }*/

    return nBreakDC;
}

void _AutoLock(object oDoor, int nStatus) {
    SetLocked(oDoor, 1);
    //SetLocked(GetTransitionTarget(oDoor), 1);
    int nHour = GetPiecewiseInteger(nStatus, _UNLOCK_HOUR_START_POS, _UNLOCK_HOUR_END_POS);
    float fDelay = ACR_GetSecondsUntilNextHour(nHour);
    DelayCommand(fDelay, _AutoUnlock(oDoor, nStatus));
}

void _AutoUnlock(object oDoor, int nStatus) {
    SetLocked(oDoor, 0);
    //SetLocked(GetTransitionTarget(oDoor), 0);
    int nHour = GetPiecewiseInteger(nStatus, _LOCK_HOUR_START_POS, _LOCK_HOUR_END_POS);
    float fDelay = ACR_GetSecondsUntilNextHour(nHour);
    DelayCommand(fDelay, _AutoUnlock(oDoor, nStatus));
}

#endif