#include "acr_spells_i"

void main() {
	// Ensure that our precast event checks out.
	if ( !ACR_PrecastEvent() ) return;
	
	// Basic casting objects.
	object oCaster = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	
	// Check for the material component cost.
	if ( !ACR_PayMaterialComponentCost( oCaster, "abr_diamond_dust", 250 ) ) return;
	
	// Get our spell data.
	float fDuration = ACR_GetSpellDuration( oCaster, ACR_DURATION_TYPE_PER_CL, ACR_DURATION_10M );
	int nDRLimit = ACR_GetCorrectCasterLevel( oCaster ) * 10;
	if ( nDRLimit > 150 ) nDRLimit = 150;

    // Fire cast spell at event for the specified target.
    SignalEvent( oTarget, EventSpellCastAt( oCaster, SPELL_STONESKIN, FALSE ) );
	
	// Build our effects.
	effect eVFX = EffectVisualEffect( VFX_DUR_SPELL_STONESKIN );
	effect eDR = EffectDamageReduction( 10, GMATERIAL_METAL_ADAMANTINE, nDRLimit, DR_TYPE_GMATERIAL );
	effect eStoneskin = EffectLinkEffects( eVFX, eDR );
	
	// And apply it to the target.
	RemoveEffectsFromSpell( oTarget, SPELL_STONESKIN );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eStoneskin, oTarget, fDuration );
}