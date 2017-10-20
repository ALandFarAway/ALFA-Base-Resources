//::///////////////////////////////////////////////
//:: Sleep
//:: NW_S0_Sleep
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Goes through the area and sleeps the lowest 2d4
	HD of creatures first.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: March 7 , 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001
//:: VFX Pass By: Preston W, On: June 25, 2001
//:: PKM-OEI 07.28.06 - NWN2 VFX pass
//:: RPGplayer1 11/25/2008: Reduced duration for 2 rounds to match desciption
//:: RPGplayer1 02/03/2009: Fixed signal event

#include "acr_spells_i"
#include "acr_nonlethal_i"

const int SLEEP_MAX_HD = 4;
const string SLEEP_TEMP_VAR = "ACR_TMP_SLEEP";

int AffectedBySleep( object oTarget ) {
	// Max Hit Die
	if ( GetHitDice( oTarget ) > SLEEP_MAX_HD ) return FALSE;

	// Check the "already affected" var.
	if ( GetLocalInt( oTarget, SLEEP_TEMP_VAR ) > 0 ) return FALSE;
	
	// Racial types unaffected by sleep.
	if ( GetRacialType( oTarget ) == RACIAL_TYPE_CONSTRUCT ) return FALSE;
	if ( GetRacialType( oTarget ) == RACIAL_TYPE_UNDEAD ) return FALSE;
	
	// Check if they're already affected by a sleep spell.
	if ( GetHasSpellEffect( SPELL_SLEEP, oTarget ) ) return FALSE;
	if ( GetHasSpellEffect( SPELL_DEEP_SLUMBER, oTarget ) ) return FALSE;
	if ( GetHasSpellEffect( SPELL_HISS_OF_SLEEP, oTarget ) ) return FALSE;
	if ( GetHasSpellEffect( SPELL_SYMBOL_OF_SLEEP, oTarget ) ) return FALSE;
	if ( GetHasSpellEffect( SPELL_COLOR_SPRAY, oTarget ) && GetHitDice( oTarget ) <= 2 ) return FALSE;
	
	// Are they otherwise immune?
	if ( GetIsImmune( oTarget, IMMUNITY_TYPE_SLEEP ) ) return FALSE;
	
	// Are they otherwise unconscious?
	if ( GetCurrentHitPoints( oTarget ) < 0 ) return FALSE;
	if ( _GetNLDState( oTarget ) >= ACR_NLD_STATE_HELPLESS ) return FALSE;
	if ( GetCurrentAction( oTarget ) == ACTION_REST ) return FALSE;

	return TRUE;
}

int MakeResistanceCheck( object oCaster, object oTarget ) {
	// Check for spell resistance.
	if ( MyResistSpell( oCaster, oTarget ) ) return TRUE;
	
	// And for saving throw.
	if ( MySavingThrow( SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS ) ) return TRUE;
	
	return FALSE;
}

void ApplySpellEffect( object oTarget, float fDuration ) {
	SetLocalInt( oTarget, SLEEP_TEMP_VAR, TRUE );
	
	// Build effect.
	effect eSleep =  EffectSleep();
	effect eDurIcon = EffectVisualEffect( VFX_DUR_SLEEP );
	effect eLinkedEffect = EffectLinkEffects( eSleep, eDurIcon );
	
	// Apply effect.
	ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLinkedEffect, oTarget, fDuration );
}

void main() {
	// Hook ACR pre-cast event.
	if ( !ACR_PrecastEvent() ) return;
	
	// Major variables.
	object oCaster = OBJECT_SELF;
	object oTarget;
	location lTarget = GetSpellTargetLocation();
	int nHDAffected = 0;
	float fDuration = ACR_GetSpellDuration( oCaster, ACR_DURATION_TYPE_PER_CL, ACR_DURATION_1M );

	// Get the number valid of targets.
	int nAvailableTargets = 0;
	int nLowestHD = 999;
	oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget );
	while ( GetIsObjectValid( oTarget ) ) {
		SignalEvent( oTarget, EventSpellCastAt( oCaster, SPELL_SLEEP ) );
		if ( AffectedBySleep( oTarget ) ) {
			int nHD = GetHitDice( oTarget );
			if ( nHD < nLowestHD ) nLowestHD = nHD;
			nAvailableTargets++;
		}
		oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget );
	}
	if ( nAvailableTargets == 0 || nLowestHD > SLEEP_MAX_HD ) return;
	
	// Loop through targets.
	int nAffected = 0;
	int bContinue = TRUE;
	int nTargetHD = nLowestHD;
	while ( bContinue ) {
		oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget );
		while ( GetIsObjectValid( oTarget ) && nHDAffected + nTargetHD <= SLEEP_MAX_HD ) {
			int nHD = GetHitDice( oTarget );
			if ( nHD == nTargetHD && AffectedBySleep( oTarget ) && !MakeResistanceCheck( oCaster, oTarget ) ) {
				ApplySpellEffect( oTarget, fDuration );
				nHDAffected += nHD;
				nAffected++;
			}
			oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget );
		}
		
		// Have we affected enough?
		nTargetHD++;
		if ( nHDAffected + nTargetHD > SLEEP_MAX_HD ) bContinue = FALSE;
	}
	
	// Finally we loop through the targets one last time to clean up our variable.
	oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget );
	while ( GetIsObjectValid( oTarget ) ) {
		DeleteLocalInt( oTarget, SLEEP_TEMP_VAR );
		oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget );
	}
	
	// Hook ACR post-cast event.
	if ( !ACR_PostcastEvent() ) return;
}