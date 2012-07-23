#include "acr_spells_i"

void main() {
	// Basic casting data.
	object oCaster = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	float fDuration = ACR_GetSpellDuration( oCaster, ACR_DURATION_TYPE_PER_CL, ACR_DURATION_1M );
	
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell.
	if ( !ACR_PrecastEvent() ) return;
	
	// Apply a dummy visual effect to represent the spell.
	effect eVFX = EffectVisualEffect( VFX_DUR_SPELL_ENTROPIC_SHIELD );
	ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVFX, oTarget, fDuration );
	
	// Signal event.
	SignalEvent( oTarget, EventSpellCastAt( oCaster, GetSpellId(), TRUE ) );
}