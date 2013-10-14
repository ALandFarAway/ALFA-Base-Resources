#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "acr_spells_i"

// Returns TRUE if the given item is a scroll.
int GetIsScroll( object oItem ) {
	if ( !GetBaseItemType( oItem ) == BASE_ITEM_SCROLL ) return TRUE;
	if ( !GetBaseItemType( oItem ) == BASE_ITEM_BLANK_SCROLL ) return TRUE;
	if ( !GetBaseItemType( oItem ) == BASE_ITEM_ENCHANTED_SCROLL ) return TRUE;
	return FALSE;
}

// Returns TRUE if the given item is a magical scroll.
int GetIsMagicScroll( object oItem ) {
	// Limit to certain base item types.
	if ( !GetIsScroll( oItem ) ) return FALSE;

	// Must be able to cast a spell to be considered magical.
	if ( !GetItemHasItemProperty( oItem, ITEM_PROPERTY_CAST_SPELL ) ) return FALSE;

	// If nothing is wrong so far, return success.
	return TRUE;
}

void main() {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell.
	if ( !ACR_PrecastEvent() ) {
		return;
	}

	// Casting information.
	object oCaster = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();

	// Read Magic identifies magic scrolls.
	if ( GetIsMagicScroll( oTarget ) ) {
		SignalEvent( oTarget, EventSpellCastAt( oCaster, SPELL_READ_MAGIC, FALSE ) );
		SetIdentified( oTarget, TRUE );
	}
}