#include "acr_spells_i"

void main() {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell.
	if ( !ACR_PrecastEvent() ) {
		return;
	}

	// Casting information.
	object oCaster = OBJECT_SELF;
	object oTarget = oCaster;
	float fDuration = ACR_GetSpellDuration( oCaster, ACR_DURATION_TYPE_PER_CL, ACR_DURATION_10M );

	// Apply the dummy effect.
	effect eVfx = EffectVisualEffect( VFX_HIT_DROWN );
	ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVfx, oTarget, fDuration );
	ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectVisualEffect(99999), oTarget, fDuration);
	
	// Establish warning.
	WarnWhenSpellExpires( oTarget, GetSpellId(), "<C=lightblue><i>Read Magic</i> has expired.</C>", fDuration );
	
	// Post-cast event.
	ACR_PostcastEvent();
}