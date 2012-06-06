// Detect Poison
// Created for ALFA by FoamBats4All 2012-05-30

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "acr_spells_i"

void main() {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell.
    if ( !X2PreSpellCastCode() ) return;
	
	// Get the caster and location of the target.
	object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
	
	// Signal event.
    SignalEvent( oTarget, EventSpellCastAt( oCaster, GetSpellId(), FALSE ) );
	
	// Get duration and limit.
	float fDuration = ACR_GetSpellDuration( oCaster, ACR_DURATION_TYPE_PER_CL, ACR_DURATION_2H );
	
	// Apply the spell effect.
	effect eWaterBreathing = EffectLinkEffects( EffectSpellImmunity( SPELL_DROWN ), EffectSpellImmunity( SPELL_MASS_DROWN ) );
	ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eWaterBreathing, oTarget, fDuration );
	
	// Establish warning.
	WarnWhenSpellExpires( oTarget, GetSpellId(), "<C=lightblue><i>Water Breathing</i> has expired.</C>", fDuration );
}