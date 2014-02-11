#include "acr_spells_i"

void main() {
	// Basic casting data.
	object oCaster = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	location lTargetLoc = GetSpellTargetLocation();
	int nCasterLevel = ACR_GetCorrectCasterLevel( oCaster );
	float fDuration = ACR_GetSpellDuration( oCaster, ACR_DURATION_TYPE_PER_CL, ACR_DURATION_1R );
	
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell.
	if ( !ACR_PrecastEvent() ) return;
	
	// Dummy effect.
	effect eVFX = EffectVisualEffect( VFX_DUR_SPELL_FEATHER_FALL );
	
	// Find targets.
	int nTargets = nCasterLevel;
	object oPC = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTargetLoc, TRUE );
	while( GetIsObjectValid(oPC) && nTargets > 0 ) {
		if ( GetFactionEqual( oPC, oCaster ) || oPC == oCaster ) {
			if ( oPC != oCaster ) {
				int nSize = GetCreatureSize( oPC );
				if ( nSize <= 3 && nTargets > 0 ) {
					// Medium or smaller.
					nTargets--;
					ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVFX, oPC, fDuration );
				} else if ( nSize == 4 && nTargets > 1 ) {
					nTargets -= 2;
					ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVFX, oPC, fDuration );
				}
			} else {
				ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVFX, oPC, fDuration );
			}
		}
		oPC = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTargetLoc, TRUE );
	}
	
	// Signal event.
	SignalEvent( oTarget, EventSpellCastAt( oCaster, GetSpellId(), FALSE ) );
}