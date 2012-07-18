#include "acr_spells_i"

void main() {
	// Basic casting data.
	object oCaster = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nCasterLevel = ACR_GetCorrectCasterLevel( oCaster );
	float fDuration = ACR_GetSpellDuration( oCaster, ACR_DURATION_TYPE_PER_CL, ACR_DURATION_10M );
	
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell.
	if ( !X2PreSpellCastCode() ) return;
	
	// Apply bonus. We treat this purely as a visual effect, and check
	// for the spell in rolls. This prevents abuse with the feint feat.
	effect eVFX = EffectVisualEffect( VFX_DUR_SPELL_EAGLE_SPLENDOR );
	ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVFX, oTarget, fDuration );
	
	// Signal event.
	SignalEvent( oTarget, EventSpellCastAt( oCaster, GetSpellId(), FALSE ) );
}