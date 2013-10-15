#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "acr_spells_i"
#include "acr_items_i"

void main() {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell.
	if ( !ACR_PrecastEvent() ) {
		return;
	}

	// Casting information.
	object oCaster = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();

	// Read Magic identifies magic scrolls.
	if ( ACR_GetIsMagicScroll( oTarget ) ) {
		SignalEvent( oTarget, EventSpellCastAt( oCaster, SPELL_READ_MAGIC, FALSE ) );
		SetIdentified( oTarget, TRUE );
	}
}