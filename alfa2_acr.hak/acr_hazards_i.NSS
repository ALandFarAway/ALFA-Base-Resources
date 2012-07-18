////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_hazards_i
//    $Revision:: 1          $ current version of the file
//        $Date:: 2012-97-18#$ date the file was created or modified
//       Author : FoamBats4All
//
//  Local Variable Prefix = ACR_HAZ\
//
//  Description
//    Provides functions that represent game hazards, such as zones where the
//    player might fall.
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_i"
#include "acr_items_i"
#include "acr_nonlethal_i"
#include "acr_skills_i"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// Local trigger variable name: Depth of a water trigger.
const string ACR_WATER_DEPTH = "ACR_WATER_DEPTH";

// Local trigger variable name: Depth of a water trigger.
const string ACR_SOFT_SURFACE = "ACR_SOFT_SURFACE";

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! Cause the target to fall.
//!  - oPC: Falling object.
//!  - nDistance: Falling distance.
//!  - lTarget: Target destination to port to after falling.
//!  - nWilling: TRUE if the target is willingly falling (i.e., jumped).
//!  - nWaterDepth: Depth of the water where the fall is occuring. If none is provided, it will search for
//!		data on triggers at the location.
//!  - bYieldingSurface: TRUE if the fall goes to a soft surface. If none is provided, it will search for
//!		data on triggers at the location.
void ACR_FallToLocation( object oPC, int nDistance, location lTarget, int nWilling = FALSE, int nWaterDepth = -1, int bYieldingSurface = -1 );
void ACR_FallToWaypoint( object oPC, int nDistance, string sTarget, int nWilling = FALSE, int nWaterDepth = -1, int bYieldingSurface = -1 );

//! Gets the fall damage, given an object and the fall distance.
void ACR_InflictFallDamage( object oPC, int nDistance, int bWilling = FALSE, int nWaterDepth = 0, int bYieldingSurface = FALSE );

//! Checks if the player is under the effects of a Feather Falling spell.
//!  - oPC: Object that should be teleporting.
int ACR_IsFeatherFalling( object oPC );

////////////////////////////////////////////////////////////////////////////////
// Function Definitions : PUBLIC ///////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void ACR_FallToLocation( object oPC, int nDistance, location lTarget, int nWilling = FALSE, int nWaterDepth = -1, int bYieldingSurface = -1 ) {
	// Are we falling to a valid location?
	if ( !GetIsLocationValid( lTarget ) ) {
		WriteTimestampedLogEntry( "ERROR - ACR_FallToLocation failed: Invalid location provided." );
		return;
	}
	
	// Is it a valid object?
	if ( GetIsObjectValid( oPC ) ) return;
	AssignCommand( oPC, ClearAllActions() );
	
	// Check the distance.
	if ( nDistance < 0 ) nDistance = 0;
	
	// First, move the PC to the target location, in case they die.
	AssignCommand( oPC, JumpToLocation( lTarget ) );
	
	// Check triggers at our destination for some information, if we need to.
	if ( nWaterDepth == -1 || bYieldingSurface == -1 ) {
		object oTargetArea = GetAreaFromLocation( lTarget );
		object oTestObject = CreateObject( OBJECT_TYPE_WAYPOINT, "nw_waypoint001", lTarget );
		object oTrigger = GetFirstObjectInArea( oTargetArea );
		while ( GetIsObjectValid( oTrigger ) ) {
			if ( GetObjectType( oTrigger ) == OBJECT_TYPE_TRIGGER && GetIsInSubArea( oTestObject, oTrigger ) ) {
				// 
				int nDepth = GetLocalInt( oTrigger, ACR_WATER_DEPTH );
				if ( nDepth != 0 && nDepth > nWaterDepth ) nWaterDepth = nDepth;
				
				int nSoft = GetLocalInt( oTrigger, ACR_SOFT_SURFACE );
				if ( nSoft > 0 ) bYieldingSurface = TRUE;
			}
			oTrigger = GetNextObjectInArea( oTargetArea );
		}
		DestroyObject( oTestObject, 1.0f, FALSE );
	}
	
	// Inflict fall damage.
	ACR_InflictFallDamage( oPC, nDistance, nWilling, nWaterDepth, bYieldingSurface );
}

void ACR_FallToWaypoint( object oPC, int nDistance, string sTarget, int nWilling = FALSE, int nWaterDepth = -1, int bYieldingSurface = -1 ) {
	ACR_FallToLocation( oPC, nDistance, GetLocation( GetWaypointByTag( sTarget ) ), nWilling, nWaterDepth, bYieldingSurface );
}

void ACR_InflictFallDamage( object oPC, int nDistance, int bWilling = FALSE, int nWaterDepth = 0, int bYieldingSurface = FALSE ) {
	if ( !GetIsObjectValid( oPC ) ) return;
	if ( nDistance < 0 ) nDistance = 0;
	if ( nWaterDepth < 0 ) nWaterDepth = 0;
	
	int i = 0;
	
	// Are we feather falling? Well, no problem then.
	if ( ACR_IsFeatherFalling( oPC ) ) {
		SendMessageToPC( oPC, "You fall gracefully downwards." );
		return;
	}
	
	// Do we have feather falling memorized? If so, let's use it. This only applies for ourself.
	if ( GetHasSpell( SPELL_FEATHER_FALL, oPC ) ) {
		SendMessageToPC( oPC, "Casting Feather Fall as an instant action." );
		SendMessageToPC( oPC, "You fall gracefully downwards." );
		DecrementRemainingSpellUses( oPC, SPELL_FEATHER_FALL );
		return;
	}
	
	//! TODO: Handle extremely long falls, where feather falling won't always work for the entire length.
	
	// Damage types.
	int nLethalDamageDice = 0;
	int nNonlethalDamageDice = 0;
	
	// Are we diving into water?
	if ( nWaterDepth > 0 ) {
		// Characters who deliberately dive into water take no damage on a successful DC 15 Swim check 
		// or DC 15 Tumble check, so long as the water is at least 10 feet deep for every 30 feet fallen.
		int bSuccessfulDive = FALSE;
		if ( bWilling == TRUE && ( nWaterDepth / 10 >= nDistance / 30 ) ) {
			int nDC = 15;
			
			// However, the DC of the check increases by 5 for every 50 feet of the dive.
			nDC	+= ( nDistance / 50 ) * 5;

			// Make the actual check.
			if ( ACR_SkillCheck( SKILL_SWIM, oPC, nDC, TRUE ) || !ACR_SkillCheck( SKILL_TUMBLE, oPC, nDC, TRUE ) ) {
				SendMessageToPC( oPC, "The water is deep enough for you to dive harmlessly." );
				bSuccessfulDive = TRUE;
			}
		}
		
		// However, if they're not so agile or a diver...
		if ( bSuccessfulDive == FALSE ) {
			// If the water is at least 10 feet deep, the first 20 feet of falling do no damage.
			if ( nWaterDepth > 10 ) {
				nDistance -= 20;
				if ( nDistance < 0 ) nDistance = 0;
			}
			
			// The next 20 feet do nonlethal damage (1d3 per 10-foot increment).
			for ( i = 0; i < 2; i++ ) {
				if ( nDistance < 0 ) {
					nDistance = 0;
					break;
				}
				nNonlethalDamageDice++;
				nDistance -= 10;
			}
			if ( nDistance < 0 ) nDistance = 0;
			
			// Beyond that, falling damage is lethal damage (1d6 per additional 10-foot increment). 
			while ( nDistance > 0 ) {
				nLethalDamageDice++;
				nDistance -= 10;
			}
		}
	} else {
		// The basic rule is simple: 1d6 points of damage per 10 feet fallen, to a maximum of 20d6.
		while ( nDistance > 0 ) {
			nLethalDamageDice++;
			nDistance -= 10;
		}
	
		// If a character deliberately jumps instead of merely slipping or falling, the damage is the same but the first 1d6 is nonlethal damage.
		if ( bWilling == TRUE ) {
			nLethalDamageDice--;
			nNonlethalDamageDice++;
		}
		
		// A DC 15 Jump check or DC 15 Tumble check allows the character to avoid any damage from the first 10 feet fallen and converts any damage from the second 10 feet to nonlethal damage.
		if ( ACR_SkillCheck( SKILL_JUMP, oPC, 15, TRUE ) || !ACR_SkillCheck( SKILL_TUMBLE, oPC, 15, TRUE ) ) {
			nLethalDamageDice--;
			if ( bWilling == FALSE ) {
				nLethalDamageDice--;
				nNonlethalDamageDice++;
			}
		}
		
		// Falls onto yielding surfaces (soft ground, mud) also convert the first 1d6 of damage to nonlethal damage.
		// This reduction is cumulative with reduced damage due to deliberate jumps and the Jump skill. 
		if ( bYieldingSurface == TRUE ) {
			nLethalDamageDice--;
			nNonlethalDamageDice++;
		}
	}
	
	// Damage restrictions.
	if ( nLethalDamageDice < 0 ) nLethalDamageDice = 0;
	if ( nNonlethalDamageDice < 0 ) nNonlethalDamageDice = 0;
	if ( nLethalDamageDice + nNonlethalDamageDice > 20 ) {
		nLethalDamageDice = 20 - nNonlethalDamageDice;
	}
	
	// Inflict damage.
	ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( d6( nLethalDamageDice ), DAMAGE_TYPE_BLUDGEONING, TRUE ), oPC );
	ACR_ApplyNonlethalDamageToCreature( oPC, d6( nNonlethalDamageDice ) );
}

int ACR_IsFeatherFalling( object oPC ) {
	if ( GetHasSpellEffect( SPELL_FEATHER_FALL, oPC ) ) return TRUE;
	if ( ACR_HasActiveItemProperty( oPC, ITEM_PROPERTY_FEATHER_FALL ) ) return TRUE;
	return FALSE;
}

////////////////////////////////////////////////////////////////////////////////
// Function Definitions : PRIVATE //////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
