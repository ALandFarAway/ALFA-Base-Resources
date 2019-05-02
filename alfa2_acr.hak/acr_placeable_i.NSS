////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_placeable_i.nss
//    $Revision:: 369        $ current version of the file
//        $Date:: 2007-08-23#$ date the file was created or modified
//       Author : Ronan 
//
//    Var Prefix: ACR_PLC
//  Dependencies:
//  The local variabled named by the string constant _ACR_PLC_BREAK_DC must be
//  present on a placable for it to be able to be broken open.
//
//  Description
//  This script handles the various ways of interacting with placables. It
//  handles all of their events, as well as other ways ALFA may have of
//  interacting with placables (such as picking them up, forcing them open, etc).
//
//  http://www.alandfaraway.info/wiki/Building_Placeables
//
//  Revision History
//  2006/11/01  Cipher  Added calls to VFX functions
//  2006/12/11  Cipher  Added calls to persistent storage and corpse functions
//  2006/12/21  Cipher  Added OnConversation, OnDisarm, OnTrapTriggered event handlers
//  2007/01/20  Cipher  Added missing ACR_VFXOnDisarm() function call
//  2007/01/24  Cipher  Added link to ALFA Wiki placeables article
//  2007/05/02 AcadiusLost commented out reference to nonexistent SPELL_ARCANE_LOCK for now
//  2007/08/21 AcadiusLost Added corpse mutilation OnPhysicallyAttacked()
////////////////////////////////////////////////////////////////////////////////

#ifndef ACR_PLACEABLE_I
#define ACR_PLACEABLE_I

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// Local interger, the placeables weight in pounds.
const string _WEIGHT_LI = "ACR_PLC_WEIGHT";

// Local integer, not for external use.
const string _OBJECT_STATUS = "ACR_PLC_S";

// define time needed for pchest saving
const float _ACR_PCHEST_SAVE_TIME = 2.0f;
const float _ACR_PCHEST_SAVE_DELAY = 0.1f;

// Local variables to store the broken state and DC.
const string ACR_VAR_IS_BROKEN = "ACR_PLC_IS_BROKEN";
const string ACR_VAR_BREAK_DC = "ACR_PLC_BREAK_DC";

// Local variable to store the autolock state.
const string ACR_VAR_AUTOLOCK = "ACR_PLC_AUTO_LOCK";

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

//! The event handler for a placeable being closed.
void ACR_PlaceableOnClose();

//! The event handler for a placeable's conversation.
void ACR_PlaceableOnConversation();

//! The event handler for a placeable being opened.
void ACR_PlaceableOnOpen();

//! The event handler for a placeable being damaged.
void ACR_PlaceableOnDamaged();

//! The event handler for a placeable being destroyed.
void ACR_PlaceableOnDeath();

//! The event handler for a placeable's heartbeat.
void ACR_PlaceableOnHeartbeat();

//! The event handler for a placeable's inventory being changed.
void ACR_PlaceableOnDisturbed();

//! The event handler for a placeable being locked.
void ACR_PlaceableOnLock();

//! The event handler for a placeable being clicked on.
void ACR_PlaceableOnClick();

//! The event handler for a placeable being attacked.
void ACR_PlaceableOnPhysicalAttacked();

//! The event handler for a placeable having a spell cast at it.
void ACR_PlaceableOnSpellCastAt();

//! The event handler for a placeable being unlocked.
void ACR_PlaceableOnUnlock();

//! The event handler for a placeable being used.
void ACR_PlaceableOnUsed();

//! The event handler for a placeable's user defined event.
void ACR_PlaceableOnUserDefined();

//! The event handler for something trying to break a placeable open.
void ACR_PlaceableOnBreakAttempt(object oObject, object oPC, int nRollModifier = 0);

//! Returns TRUE if the object has been broken open.
int ACR_GetIsBrokenOpen( object oObject );

//! Sets if the door is broken open or not.
void ACR_SetIsBrokenOpen( object oObject, int nBroken );

//! Returns the DC to break a door open.
int ACR_GetBreakDC( object oObject );

//! Sets the DC to break a door open.
void ACR_SetBreakDC( object oObject, int nDC );

//! Returns TRUE if the door is set to autolock.
int ACR_GetDoesAutolock( object oObject );

//! Sets if the door should autolock.
void ACR_SetDoesAutolock( object oObject, int nAutolock );

//! *** PRIVATE FUNCTIONS ***

//! Gets this object's strength DC to break open.
int _GetObjectBreakOpenDC(object oObject, int nStatus);

//! Save pchest contents
void _SavePchestStart(object oChest, object oCloser);

//! Finish saving process
void _SavePchestEnd(object oChest, object oCloser);

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_physical_object_i"
#include "acr_tools_i"
#include "acr_vfx_i"
#include "acr_death_i"
#include "acr_wealth_i"

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// *** BEGIN PUBLIC FUNCTIONS ***
////////////////////////////////////////////////////////////////////////////////

void ACR_PlaceableOnClose() {
    object oCloser = GetLastClosedBy();

    if( ACR_GetDoesAutolock( OBJECT_SELF ) && GetLockLockable( OBJECT_SELF ) ) {
		SetLocked( OBJECT_SELF, TRUE );
	}

    // apply any effects on the placeable
    ACR_VFXOnClose(oCloser, OBJECT_SELF);

    // manage persistent storage objects
    if (ACR_GetIsPersistentStorageObject(OBJECT_SELF)) {
	
        SetUseableFlag(OBJECT_SELF, 0);

        DelayCommand(_ACR_PCHEST_SAVE_DELAY, _SavePchestStart(OBJECT_SELF, oCloser));
    }
}

void ACR_PlaceableOnConversation() {
    object oSpeaker= GetPCSpeaker();

}

void ACR_PlaceableOnOpen() {
    object oOpener = GetLastOpenedBy();

    // manage persistent storage objects
    if (ACR_GetIsPersistentStorageObject(OBJECT_SELF)) {
	    ACR_PersistentStorageOnOpen(OBJECT_SELF);
	    SetLocalObject(oOpener, "ACR_PCHEST_OPENED", OBJECT_SELF);
    }

    // apply any effects on the placeable
    ACR_VFXOnOpen(oOpener, OBJECT_SELF);
}

void ACR_PlaceableOnDamaged() {
    object oDamager = GetLastDamager();

    // apply any effects on the placeable
    ACR_VFXOnDamage(oDamager, OBJECT_SELF);
}

void ACR_PlaceableOnDeath() {
    object oKiller = GetLastKiller();

    // manage persistent storage objects
    if (ACR_GetIsPersistentStorageObject(OBJECT_SELF)) { ACR_PersistentStorageOnDeath(OBJECT_SELF); }

    // apply any effects on the placeable
    ACR_VFXOnDeath(oKiller, OBJECT_SELF);
}

void ACR_PlaceableOnHeartbeat() {
    // Apply any effects on the placeable.
    ACR_VFXOnHeartBeat(OBJECT_SELF);
}

void ACR_PlaceableOnDisarm() {
    object oDisarmer = GetLastDisarmed();

    // apply any effects on the placeable
    ACR_VFXOnDisarm(oDisarmer, OBJECT_SELF);
}

void ACR_PlaceableOnDisturbed() {
    object oDisturber = GetLastDisturbed();
    object oItem = GetInventoryDisturbItem();

    // apply any effects on the placeable
    ACR_VFXOnDisturb(oDisturber, OBJECT_SELF);

    // manage persistent storage objects
    if (ACR_GetIsPersistentStorageObject(OBJECT_SELF)) { ACR_PersistentStorageOnDisturb(OBJECT_SELF, oDisturber); }

    // prevent duping or stealing corpses
    ACR_CorpseOnDisturbed(oItem, oDisturber, OBJECT_SELF);
}

void ACR_PlaceableOnLock() {
    object oLocker = GetLastLocked();

    if( ACR_GetIsBrokenOpen( OBJECT_SELF ) ) {
        FloatingTextStringOnCreature("The object has been broken open and cannot be locked.", oLocker);
        SetLocked(OBJECT_SELF, 0);
    }

    // apply any effects on the placeable
    ACR_VFXOnLock(oLocker, OBJECT_SELF);
}

void ACR_PlaceableOnClick() {
//    object oActivator = GetLastClicked();

    // apply any effects on the placeable
//    ACR_VFXOnUsed(oActivater, OBJECT_SELF);
}

void ACR_PlaceableOnPhysicalAttacked() {
    object oAttacker = GetLastAttacker();

	// if the placeable being bashed is a PC corpse, treat it as a mutilation attempt.
	if (GetResRef(OBJECT_SELF) == ACR_DTH_CORPSE_RESREF) {
	    ACR_CorpseOnMutilate(OBJECT_SELF, oAttacker);
	}
    // apply any effects on the placeable
    ACR_VFXOnAttack(oAttacker, OBJECT_SELF);
}

void ACR_PlaceableOnTrapTriggered() {
    //object oTriggered = GetLastTriggered();
}

void ACR_PlaceableOnSpellCastAt() {
    object oCaster = GetLastSpellCaster();
    int nSpellId = GetLastSpell();

    // apply the spell to corpses
    ACR_CorpseOnResurrect(oCaster, OBJECT_SELF, nSpellId);

    // apply any effects on the placeable
    ACR_VFXOnSpellCastAt(oCaster, OBJECT_SELF);
}

void ACR_PlaceableOnUnlock() {
    object oUnlocker = GetLastUnlocked();

    // apply any effects on the placeable
    ACR_VFXOnUnLock(oUnlocker, OBJECT_SELF);
}

void ACR_PlaceableOnUsed() {
    object oActivator = GetLastUsedBy();

    // apply any effects on the placeable
    ACR_VFXOnUsed(oActivator, OBJECT_SELF);
}

void ACR_PlaceableOnUserDefined() {
}

void ACR_PlaceableOnBreakAttempt(object oObject, object oPC, int nRollModifier = 0) {

    if(GetIsOpen(oObject) || !GetHasInventory(oObject) || GetObjectType(oObject) != OBJECT_TYPE_PLACEABLE) {
        return;
    }
	
    if ( ACR_GetIsBrokenOpen( oObject ) ) {
        // Its already been forced open.
        AssignCommand(oObject, ActionSpeakString("*Swings open quickly, its lock already broken*"));
        return;
    }
    int nDC = ACR_GetBreakDC( oObject );
    //SendMessageToPC(oPC, "Force open door DC: " + IntToString(nDC));
    int nRollNeeded = nDC - GetAbilityModifier(ABILITY_STRENGTH, oPC) - nRollModifier - ACR_GetBreakSizeModifier(GetCreatureSize(oPC));

    if(nRollNeeded > 20 || !nDC) {
        // Success is impossible.
        AssignCommand(oObject, ActionSpeakString("*Doesn't budge a bit*"));
        return;
    }

    if(d20() >= nRollNeeded) {
        // Successfully forced the door open.
        ACR_SetIsBrokenOpen( oObject, TRUE );
        AssignCommand(oObject, ActionSpeakString("*The lock breaks, and it flies open*"));
        return;
    }
    // Failure, but lets give the PC a message so they know what their chances
    // are.
    if(nRollNeeded > 18) {
        AssignCommand(oObject, ActionSpeakString("*Gives way very slightly*"));
    } else if(nRollNeeded > 12) {
        AssignCommand(oObject, ActionSpeakString("*Gives way a little*"));
    } else {
        AssignCommand(oObject, ActionSpeakString("*Creaks under the strain, but holds fast for now*"));
    }
}


int ACR_GetIsBrokenOpen( object oObject ) {
	return GetLocalInt( oObject, ACR_VAR_IS_BROKEN );
}


void ACR_SetIsBrokenOpen( object oObject, int nBroken ) {
	// Are we doing anything?
	if ( ACR_GetIsBrokenOpen( oObject ) == nBroken ) {
		return;
	}
	
	// Limit nBroken to be a boolean.
	if ( nBroken ) nBroken = 1;
	
	// Toggle status.
	SetLocalInt( oObject, ACR_VAR_IS_BROKEN, nBroken );
	SetLocked( oObject, !nBroken );
	SetLockLockable( oObject, !nBroken );
}


int ACR_GetBreakDC( object oObject ) {
	return GetLocalInt( oObject, ACR_VAR_BREAK_DC );
}


void ACR_SetBreakDC( object oObject, int nDC ) {
	if ( nDC < 0 ) nDC = 0;
	SetLocalInt( oObject, ACR_VAR_BREAK_DC, nDC );
}


int ACR_GetDoesAutolock( object oObject ) {
	return GetLocalInt( oObject, ACR_VAR_AUTOLOCK );
}


void ACR_SetDoesAutolock( object oObject, int nAutolock ) {
	// Limit nBroken to be a boolean.
	if ( nAutolock ) nAutolock = 1;
	
	// Set the local variable.
	SetLocalInt( oObject, ACR_VAR_AUTOLOCK, nAutolock );
}

////////////////////////////////////////////////////////////////////////////////
// *** BEGIN PRIVATE FUNCTIONS ***
////////////////////////////////////////////////////////////////////////////////

int _GetObjectBreakOpenDC(object oObject, int nStatus) {

    int nBreakDC = GetPiecewiseInteger( nStatus, 0, 7 );

    if(GetPlotFlag(oObject) || !nBreakDC) {
        return 0;
    }

    if( GetCurrentHitPoints(oObject) <= (GetMaxHitPoints(oObject) / 2) ) {
        nBreakDC = nBreakDC - 2;
    }

//  Commented out until SPELL_ARCANE_LOCK exists.
//    if( GetHasSpellEffect(SPELL_ARCANE_LOCK, oObject) ) {
//        nBreakDC = nBreakDC + 10;
//    }

    return nBreakDC;
}

void _SavePchestStart(object oChest, object oCloser)
{
    int res;
    SendMessageToPC(oCloser, "Saving contents...");

    res = ACR_PersistentStorageOnClose(OBJECT_SELF, oCloser);

    // if there is an error saving, don't allow the pchest to be accessible again
    if (res)
        DelayCommand(_ACR_PCHEST_SAVE_TIME, _SavePchestEnd(OBJECT_SELF, oCloser));
}

void _SavePchestEnd(object oChest, object oCloser)
{
    SetUseableFlag(oChest, 1);
    ACR_WealthPChestClosed(oCloser, oChest, GetLocalInt(oChest, _ACR_PSO_TOTAL_VALUE_LI));
    SendMessageToPC(oCloser, "Saving done.");
}

#endif