#include "acr_spells_i"
#include "acr_door_i"

void main() {
	// Basic casting data.
	object oCaster = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell.
	if ( !X2PreSpellCastCode() ) return;
	
	// Are we actually casting the spell on a door?
	if ( GetObjectType( oTarget ) != OBJECT_TYPE_DOOR && GetObjectType( oTarget ) != OBJECT_TYPE_PLACEABLE ) {
		SendMessageToPC( oCaster, "Spell failed: You must target a container or door." );
		SignalEvent( oTarget, EventSpellCastAt( oCaster, GetSpellId(), FALSE ) );
		return;
	}
	
	// Is the target locked or stuck?
	if ( GetLocked( oTarget ) || ACR_DoorGetIsStuck( oTarget ) ) {
		SendMessageToPC( oCaster, "Spell failed: Your spell is unable to force the door open." );
		SignalEvent( oTarget, EventSpellCastAt( oCaster, GetSpellId(), FALSE ) );
		return;
	}
	
	// Is the target trapped?
	if ( GetIsTrapped( oTarget ) ) {
		// TODO: Trigger trap.
	}
	
	// Does this door actually have spell resistance? Well, it applies.
	if ( MyResistSpell( oCaster, oTarget ) > 0 ) {
		SignalEvent( oTarget, EventSpellCastAt( oCaster, GetSpellId(), FALSE ) );
		return;
	}
	
	// Well, open/close.
	if ( GetIsOpen( oTarget ) ) {
		ActionCloseDoor( oTarget );
	} else {
		ActionOpenDoor( oTarget );
	}
	
	// Signal event.
	SignalEvent( oTarget, EventSpellCastAt( oCaster, GetSpellId(), FALSE ) );
}