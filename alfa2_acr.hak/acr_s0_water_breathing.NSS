// Water Breathing
// Created for ALFA by FoamBats4All 2012-05-30

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "acr_spells_i"

const float WATER_BREATHING_RADIUS = RADIUS_SIZE_SMALL;

void _ApplyWaterBreathing( object oCaster, object oTarget, float fDuration ) {
	// Signal event.
	SignalEvent( oTarget, EventSpellCastAt( oCaster, GetSpellId(), FALSE ) );
	
	// Apply the spell effect.
	effect eDrownImmunity = EffectLinkEffects( EffectSpellImmunity( SPELL_DROWN ), EffectSpellImmunity( SPELL_MASS_DROWN ) );
	ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eDrownImmunity, oTarget, fDuration );
	
	// Apply a visual feedback effect.
	effect eVfx = EffectVisualEffect( VFX_HIT_DROWN );
	ApplyEffectToObject( DURATION_TYPE_INSTANT, eVfx, oTarget );
	
	// Establish warning.
	WarnWhenSpellExpires( oTarget, GetSpellId(), "<C=lightblue><i>Water Breathing</i> has expired.</C>", fDuration );
}

void main() {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell.
    if ( !X2PreSpellCastCode() ) return;
	
	// Get the caster and location of the target.
	object oCaster = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	location lTarget = GetSpellTargetLocation();
	
	// Get duration limit.
	float fDuration = ACR_GetSpellDuration( oCaster, ACR_DURATION_TYPE_PER_CL, ACR_DURATION_2H );
	
	// Do we have a target that isn't the caster? Focus only on them.
	if ( GetIsObjectValid( oTarget ) && oTarget != oCaster ) {
		_ApplyWaterBreathing( oCaster, oTarget, fDuration );
	} else {
		// Otherwise get the number of targets to affect.
		int nTargetCount = 0;
		oTarget = GetFirstObjectInShape( SHAPE_SPHERE, WATER_BREATHING_RADIUS, lTarget, FALSE, OBJECT_TYPE_CREATURE );
		while ( GetIsObjectValid( oTarget ) ) {
			if ( !GetFactionEqual( oCaster, oTarget ) ) {
				oTarget = GetNextObjectInShape( SHAPE_SPHERE, WATER_BREATHING_RADIUS, lTarget, FALSE, OBJECT_TYPE_CREATURE );
				continue;
			}

			nTargetCount++;
			oTarget = GetNextObjectInShape( SHAPE_SPHERE, WATER_BREATHING_RADIUS, lTarget, FALSE, OBJECT_TYPE_CREATURE );
		}

		if( nTargetCount == 0 )
			return;
		
		// Apply effect to all in area.
		fDuration = fDuration / nTargetCount;
		oTarget = GetFirstObjectInShape( SHAPE_SPHERE, WATER_BREATHING_RADIUS, lTarget, FALSE, OBJECT_TYPE_CREATURE );
		while ( GetIsObjectValid( oTarget ) ) {
			if( !GetFactionEqual( oCaster, oTarget ))
				continue;

			_ApplyWaterBreathing( oCaster, oTarget, fDuration );
			oTarget = GetNextObjectInShape( SHAPE_SPHERE, WATER_BREATHING_RADIUS, lTarget, FALSE, OBJECT_TYPE_CREATURE );
		}
	}
}
