#include "acr_spells_i" 

void main() {
    if ( !ACR_PrecastEvent() ) return;

	// Placeholder script. Get the caster and inform them that it's RP-only.
	SendMessageToPC( OBJECT_SELF, "This spell has not yet been implemented into ALFA's mechanics." );
	
	SignalEvent( GetSpellTargetObject(), EventSpellCastAt( OBJECT_SELF, GetSpellId(), FALSE ) );
}