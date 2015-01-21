////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_hazards_i
//    $Revision:: 1          $ current version of the file
//        $Date:: 2012-97-18#$ date the file was created or modified
//       Author : FoamBats4All
//
//  Local Variable Prefix = ACR_HAZ
//
//  Description
//    Provides functions that represent game hazards, such as zones where the
//    player might fall.
////////////////////////////////////////////////////////////////////////////////

#ifndef ACR_HAZARDS_I
#define ACR_HAZARDS_I

// This include must be done prematurely due to dependent constants.
#include "acr_environment_i"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// Local trigger variable name: Hazard safe condition check.
const string ACR_HAZ_SAFE_COND = "ACR_HAZ_SAFE_COND";
const int ACR_HAZ_SAFE_COND_NEVER = 0;			// Hazard will trigger every time an object enters.
const int ACR_HAZ_SAFE_COND_ON_SUCCESS = 1;		// Hazard will trigger only the first time an object enters.
const int ACR_HAZ_SAFE_COND_AFTER_ONCE = 2;		// Hazard will twigger only the first time an object enters, and won't trigger for anyone else.

// Balance hazard local variables.
const string ACR_HAZ_BALANCING = "ACR_IS_BALANCING";					// TRUE if the PC is currently trying to balance.
const string ACR_HAZ_BALANCE_DC = "ACR_HAZ_BALANCE_DC";					// Base DC of the balance effort.
const string ACR_HAZ_BALANCE_FALL_WP = "ACR_HAZ_BALANCE_FALL_WP";		// What waypoint the player will fall to if they fail their check.
const string ACR_HAZ_BALANCE_FALL_DIST = "ACR_HAZ_BALANCE_FALL_DIST";	// How far the player will fall if they fail their balance check.

// Temperature hazard local variables.
const string ACR_HAZ_TEMP_IS = "ACR_HAZ_TEMP_IS";	// Currently suffering temperature effects?
const string ACR_HAZ_TEMP_CUR = "ACR_HAZ_TEMP_CUR";	// Current climate hazard temperature.
const string ACR_HAZ_TEMP_CNT = "ACR_HAZ_TEMP_CNT";	// Current climate hazard counter.
const string ACR_HAZ_TEMP_CHK = "ACR_HAZ_TEMP_CHK";	// Number of climate checks made so far.
const string ACR_HAZ_TEMP_LCK = "ACR_HAZ_TEMP_LCK";	// Current climate hazard lock.

// Water hazards local variables.
const string ACR_SWIM_DC = "ACR_SWIM_DC";			// Swim DC.
const string ACR_NO_AIR = "ACR_NO_AIR";				// Is there air above this body of water?
const string ACR_NO_AIR_DC = "NO_AIR_DC";			// What is the difficulty of getting air?
const string ACR_NO_AIR_FOR = "NO_AIR_FOR";			// How long the PC has gone without air?
const string ACR_WATER_DEPTH = "ACR_WATER_DEPTH";	// How deep are the waters?

// Local trigger variable name: Depth of a water trigger.
const string ACR_SOFT_SURFACE = "ACR_SOFT_SURFACE";

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! Trigger calls for entering/exiting hazardous areas.
void ACR_HazardousAreaOnEnter();
void ACR_HazardousTriggerOnEnter();
void ACR_HazardousTriggerOnExit();

//! Cause the character to perform a balance check, until the balance situation ends.
//! Note that ACR_HAZ_BALANCING must be set to TRUE on the balancing character prior to
//! this function being called.
//!  - oPC : Creature to make a balance check for.
//!  - nBalanceDC : The balance DC.
//!  - sFallWaypoint : Where the character will fall to if they significantly fail a check.
//!  - nFallDistance : How far they will fall on a significant failure.
void ACR_PerformBalanceCheck( object oPC, int nBalanceDC, string sFallWaypoint, int nFallDistance );

void ACR_DoTemperatureHazard( object oPC, float fTemperature = ACR_TEMP_INVALID );

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

// Temperature condition private functions.
int _IsObjectInHazard( object oPC );
void _DoHeatDamage( object oPC, int nDamage, int nLethal);
void _DoHeat( object oPC );
void _DoSevereHeat( object oPC );
void _DoExtremeHeat( object oPC );
void _DoColdDamage( object oPC, int nDamage, int nLethal );
void _DoCold( object oPC );
void _DoSevereCold( object oPC );
void _DoExtremeCold( object oPC );

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_i"
#include "acr_items_i"
#include "acr_nonlethal_i"
#include "acr_skills_i"

////////////////////////////////////////////////////////////////////////////////
// Function Definitions : PUBLIC ///////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void ACR_HazardousAreaOnEnter() {
	object oPC = GetEnteringObject();
	
	// Check for temperature hazards.
	if ( ACR_GetHasTemperature( OBJECT_SELF ) ) {
		if ( !ACR_IsComfortableTemperature( oPC, ACR_GetCurrentTemperature( OBJECT_SELF ) ) ) {
			SetLocalInt( oPC, ACR_HAZ_TEMP_IS, TRUE );
			ACR_DoTemperatureHazard( oPC );
		}
	}
}


void ACR_HazardousTriggerOnEnter() {
	object oPC = GetEnteringObject();
	
	// Is this hazard removed?
	int nSafeCondition = GetLocalInt( OBJECT_SELF, ACR_HAZ_SAFE_COND );
	if ( nSafeCondition == ACR_HAZ_SAFE_COND_ON_SUCCESS ) {
		// ACR_HAZ_SAFE_COND_ON_SUCCESS : We only want a hazard to apply once per character.
		string sKey = "haz_passed_" + ObjectToString( oPC );
		if ( GetLocalInt( OBJECT_SELF, sKey ) ) return;
		SetLocalInt( OBJECT_SELF, sKey, TRUE );
	} else if ( nSafeCondition == ACR_HAZ_SAFE_COND_AFTER_ONCE ) {
		// ACR_HAZ_SAFE_COND_AFTER_ONCE : Hazard only applies once.
		string sKey = "haz_passed";
		if ( GetLocalInt( OBJECT_SELF, sKey ) ) return;
		SetLocalInt( OBJECT_SELF, sKey, TRUE );
	}
	
	// Check for balance hazards.
	int nBalanceDC = GetLocalInt( OBJECT_SELF, ACR_HAZ_BALANCE_DC );
	if ( nBalanceDC > 0 ) {
		SetLocalInt( oPC, ACR_HAZ_BALANCING, TRUE );
		string sFallWP = GetLocalString( OBJECT_SELF, ACR_HAZ_BALANCE_FALL_WP );
		int sFallDistance = GetLocalInt( OBJECT_SELF, ACR_HAZ_BALANCE_FALL_DIST );
		ACR_PerformBalanceCheck( oPC, nBalanceDC, sFallWP, sFallDistance );
	}
	
	// Check for temperature hazards.
	if ( ACR_GetHasTemperature( OBJECT_SELF ) ) {
		if ( !ACR_IsComfortableTemperature( oPC, ACR_GetCurrentTemperature( OBJECT_SELF ) ) ) {
			SetLocalInt( oPC, ACR_HAZ_TEMP_IS, TRUE );
			ACR_DoTemperatureHazard( oPC );
		}
	}
}


void ACR_HazardousTriggerOnExit() {
	object oPC = GetExitingObject();
	
	// Remove effects.
	effect eEffect = GetFirstEffect( oPC );
	while ( GetIsEffectValid( eEffect ) ) {
		if ( GetEffectCreator( eEffect ) == OBJECT_SELF ) RemoveEffect( oPC, eEffect );
		eEffect = GetNextEffect(oPC);
	}
	
	// Clean up local variables..
	DeleteLocalInt( oPC, ACR_HAZ_BALANCING );
}


void ACR_PerformBalanceCheck( object oPC, int nBalanceDC, string sFallWaypoint, int nFallDistance ) {
	if ( !GetIsObjectValid( oPC ) ) return;
	
	// Remove effects.
	effect eEffect = GetFirstEffect( oPC );
	while ( GetIsEffectValid( eEffect ) ) {
		if ( GetEffectCreator( eEffect ) == OBJECT_SELF ) RemoveEffect( oPC, eEffect );
		eEffect = GetNextEffect(oPC);
	}
	
	// Are we still balancing?
	if ( GetLocalInt( oPC, ACR_HAZ_BALANCING ) != TRUE ) return;
	
	// Adjust the DC if we are running.
	int nActualDC = nBalanceDC;
	int bIsRunning = ( GetMovementRateFactor( oPC ) >= 4.0f );
	
	// Roll balance for the hazard.
	int nCheck = ACR_SkillCheck( SKILL_BALANCE, oPC, 0, TRUE );
	
	// If we're running, we require two checks.
	if ( bIsRunning ) {
		SendMessageToPC( oPC, "Your quickened pace requires you to focus harder on balancing." );
		int nCheck2 = ACR_SkillCheck( SKILL_BALANCE, oPC, 0, TRUE );
		if ( nCheck2 < nCheck ) nCheck = nCheck2;
	}
	
	// Parse our balance check results.
	if ( nCheck >= nActualDC + 5 ) {
		// If we beat the DC by 5 or more, we move at the normal rate.
		SendMessageToPC( oPC, "To make it easily along your path." );
		DelayCommand( 6.0f, ACR_PerformBalanceCheck( oPC, nBalanceDC, sFallWaypoint, nFallDistance ) );
	} else if ( nCheck >= nActualDC ) {
		// A successful check lets you move at half your speed along the surface for 1 round.
		SendMessageToPC( oPC, "By picking your steps carefully, you manage to move forward." );
		ApplyEffectToObject( DURATION_TYPE_PERMANENT, EffectMovementSpeedDecrease( 50 ), oPC );
		DelayCommand( 6.0f, ACR_PerformBalanceCheck( oPC, nBalanceDC, sFallWaypoint, nFallDistance ) );
	} else if ( ( nActualDC - nCheck ) <= 4 ) {
		// A failure by 4 or less means you can’t move for 1 round.
		SendMessageToPC( oPC, "You slip, wavering to catch your balance!" );
		ApplyEffectToObject( DURATION_TYPE_PERMANENT, EffectCutsceneImmobilize(), oPC );
		DelayCommand( 6.0f, ACR_PerformBalanceCheck( oPC, nBalanceDC, sFallWaypoint, nFallDistance ) );
	} else {
		// A failure by 5 or more means you fall.
		SendMessageToPC( oPC, "You slip, falling from your path!" );
		DelayCommand( 2.0f, ACR_FallToWaypoint( oPC, nFallDistance, sFallWaypoint ) );
	}
}


void ACR_DoTemperatureHazard( object oPC, float fTemperature = ACR_TEMP_INVALID ) {
	// Only run one temperature script at a time.
	int nLock = GetLocalInt( oPC, ACR_HAZ_TEMP_LCK ) + 1;
	if ( nLock > 1 ) {
		nLock--;
		SetLocalInt( oPC, ACR_HAZ_TEMP_LCK, nLock );
		return;
	}
	
	// Check if the PC handles the temperature comfortably.
	if ( ACR_IsComfortableTemperature( oPC, fTemperature ) ) {
		DeleteLocalFloat( oPC, ACR_HAZ_TEMP_IS );
		DeleteLocalFloat( oPC, ACR_HAZ_TEMP_CUR );
		DeleteLocalInt( oPC, ACR_HAZ_TEMP_CNT );
		DeleteLocalInt( oPC, ACR_HAZ_TEMP_CHK );
		DeleteLocalInt( oPC, ACR_HAZ_TEMP_LCK );
		return;
	}
	
	// Make sure we're still doing temperature checks.
	if ( !GetLocalInt( oPC, ACR_HAZ_TEMP_IS ) != TRUE ) {
		DeleteLocalFloat( oPC, ACR_HAZ_TEMP_IS );
		DeleteLocalFloat( oPC, ACR_HAZ_TEMP_CUR );
		DeleteLocalInt( oPC, ACR_HAZ_TEMP_CNT );
		DeleteLocalInt( oPC, ACR_HAZ_TEMP_CHK );
		DeleteLocalInt( oPC, ACR_HAZ_TEMP_LCK );
		return;
	}
	
	// If this temperature is more dangerous than the last, update.
	float fCurTemp = GetLocalFloat( oPC, ACR_HAZ_TEMP_CUR );
	if ( fCurTemp <= ACR_TEMP_COLD ) {
		if ( fTemperature < fCurTemp ) SetLocalFloat( oPC, ACR_HAZ_TEMP_CUR, fTemperature );
		else fTemperature = fCurTemp;
	} else if ( fCurTemp >= ACR_TEMP_HOT ) {
		if ( fTemperature > fCurTemp ) SetLocalFloat( oPC, ACR_HAZ_TEMP_CUR, fTemperature );
		else fTemperature = fCurTemp;
	} else {
		// This should never happen. If it does, still update our lock.
		SetLocalInt( oPC, ACR_HAZ_TEMP_LCK, nLock - 1 );
		return;
	}
	
	float fDelayToReCheck = 60.0f;
	// What type of hazard are we doing?
	if ( fTemperature >= ACR_TEMP_HOT_EXTREME ) {
		_DoExtremeHeat( oPC );
	} else if ( fTemperature >= ACR_TEMP_HOT_SEVERE ) {
		_DoSevereHeat( oPC );
		fDelayToReCheck = 60.0f * 10.0f;
	} else if ( fTemperature >= ACR_TEMP_HOT ) {
		_DoHeat( oPC );
		fDelayToReCheck = HoursToSeconds(1);
	} else if ( fTemperature <= ACR_TEMP_COLD_EXTREME ) {
		_DoExtremeCold( oPC );
	} else if ( fTemperature <= ACR_TEMP_COLD_SEVERE ) {
		_DoSevereCold( oPC );
		fDelayToReCheck = 60.0f * 10.0f;
	} else if ( fTemperature <= ACR_TEMP_COLD ) {
		_DoCold( oPC );
		fDelayToReCheck = HoursToSeconds(1);
	} else {
		// This should never happen. If it does, still update our lock.
		SetLocalInt( oPC, ACR_HAZ_TEMP_LCK, nLock - 1 );
		return;
	}
	
	// Increment the counter.
	int nCounter = GetLocalInt( oPC, ACR_HAZ_TEMP_CNT );
	SetLocalInt( oPC, ACR_HAZ_TEMP_CNT, nCounter + 1 );
	
	// Call this script again based on how often we expect checks to happen.
	if(_IsObjectInHazard( oPC )) DelayCommand( fDelayToReCheck, ACR_DoTemperatureHazard( oPC, fTemperature ) );
	else SetLocalInt( oPC, ACR_HAZ_TEMP_LCK, nLock - 1 );
}


void ACR_FallToLocation( object oPC, int nDistance, location lTarget, int nWilling = FALSE, int nWaterDepth = -1, int bYieldingSurface = -1 ) {
	// Are we falling to a valid location?
	if ( !GetIsLocationValid( lTarget ) ) {
		WriteTimestampedLogEntry( "ERROR - ACR_FallToLocation failed: Invalid location provided." );
		return;
	}
	
	// Is it a valid object?
	if ( !GetIsObjectValid( oPC ) ) return;
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
	if ( nWaterDepth < 0 ) nWaterDepth = 0;
	int i = 0;
	
	// Valid distance?
	if ( nDistance <= 0 ) {
		WriteTimestampedLogEntry( "ERROR - ACR_InflictFallDamage failed: Distance <= 0" );
		return;
	}
	
	// Are we feather falling? Well, no problem then.
	if ( ACR_IsFeatherFalling( oPC ) ) {
		SendMessageToPC( oPC, "You fall gracefully downwards." );
		return;
	}
	
	// Do we have feather falling memorized? If so, let's use it. This only applies for ourself.
	if ( GetHasSpell( SPELL_FEATHER_FALL, oPC ) ) {
		SendMessageToPC( oPC, "Casting Feather Fall as an instant action!" );
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
			if ( ACR_SkillCheck( SKILL_SWIM, oPC, nDC, TRUE ) || ACR_SkillCheck( SKILL_TUMBLE, oPC, nDC, TRUE ) ) {
				SendMessageToPC( oPC, "The water is deep enough for you to dive harmlessly." );
				bSuccessfulDive = TRUE;
			}
		}
		
		// However, if they're not so agile or a diver...
		if ( bSuccessfulDive == FALSE ) {
			// If the water is at least 10 feet deep, the first 20 feet of falling do no damage.
			if ( nWaterDepth >= 10 ) {
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
		if ( ACR_SkillCheck( SKILL_JUMP, oPC, 15, TRUE ) || ACR_SkillCheck( SKILL_TUMBLE, oPC, 15, TRUE ) ) {
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
	if ( nLethalDamageDice > 0 ) ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( d6( nLethalDamageDice ), DAMAGE_TYPE_BLUDGEONING, TRUE ), oPC );
	if ( nNonlethalDamageDice > 0 ) ACR_ApplyNonlethalDamageToCreature( oPC, d6( nNonlethalDamageDice ) );
}


int ACR_IsFeatherFalling( object oPC ) {
	if ( GetHasSpellEffect( SPELL_FEATHER_FALL, oPC ) ) return TRUE;
	if ( ACR_HasActiveItemProperty( oPC, ITEM_PROPERTY_FEATHER_FALL ) ) return TRUE;
	return FALSE;
}

////////////////////////////////////////////////////////////////////////////////
// Function Definitions : PRIVATE //////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

int _IsObjectInHazard( object oPC ) {
    if(GetObjectType(OBJECT_SELF) == OBJECT_TYPE_TRIGGER ||
       GetObjectType(OBJECT_SELF) == OBJECT_TYPE_AREA_OF_EFFECT) {
        object oObj = GetFirstInPersistentObject();
        while(GetIsObjectValid(oObj)) {
            if(oObj == oPC) return TRUE;
            oObj = GetNextInPersistentObject();
        }
        return FALSE;
    }
    else {
        object oObj = GetFirstObjectInArea(OBJECT_SELF);
        while(GetIsObjectValid(oObj)) {
            if(oObj == oPC) return TRUE;
            oObj = GetNextObjectInArea(OBJECT_SELF);
        }
        return FALSE;
    }
}

void _DoHeatDamage( object oPC, int nDamage, int nLethal) {
	int nCurrentHP = GetCurrentHitPoints( oPC );

	if ( !nLethal && ( _GetNLDTotal( oPC ) <= nCurrentHP ) ) {
		ACR_ApplyNonlethalDamageToCreature( oPC, d6() );
	} else {
		ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( nDamage, DAMAGE_TYPE_FIRE, FALSE ), oPC );
		if ( nCurrentHP != GetCurrentHitPoints( oPC ) ) {
			ACR_SetIsFatigued( oPC, TRUE );
		}
	}
}

void _DoHeat( object oPC ) {
	// Basic data.
	int nChecks = GetLocalInt( oPC, ACR_HAZ_TEMP_CHK );
	int nCounter = GetLocalInt( oPC, ACR_HAZ_TEMP_CNT );
	int nDC = 15 + nChecks;
	int nBonus = 0;
	
	// Make a DC 15 survival check to help resist conditions.
	if ( ACR_SkillCheck( SKILL_SURVIVAL, oPC, 15, TRUE ) ) {
		SendMessageToPC( oPC, "Your survival skills help you ward yourself against the heat." );
		nBonus += 3; // This should be +2 if moving, +4 if stationary. We can't really detect that here very well, so we compromise.
	}
	
	// Make a DC 15 + nChecks fortitude save, or take nonlethal damage.
	if ( !ACR_SaveCheck( SAVING_THROW_FORT, oPC, nDC, TRUE, FALSE, nBonus ) ) {
		SendMessageToPC( oPC, "The heat saps you, leaving behind sweat and exhaustion." );
		_DoHeatDamage( oPC, d6(), FALSE );
	}
	
	// Increment check counter.
	nChecks++;
	SetLocalInt( oPC, ACR_HAZ_TEMP_CHK, nChecks );
}


void _DoSevereHeat( object oPC ) {
	// Basic data.
	int nChecks = GetLocalInt( oPC, ACR_HAZ_TEMP_CHK );
	int nCounter = GetLocalInt( oPC, ACR_HAZ_TEMP_CNT );
	int nDC = 15 + nChecks;
	int nBonus = 0;
	
	// Make a DC 15 survival check to help resist conditions.
	if ( ACR_SkillCheck( SKILL_SURVIVAL, oPC, 15, TRUE ) ) {
		SendMessageToPC( oPC, "Your survival skills help you ward yourself against the heat." );
		nBonus += 3; // This should be +2 if moving, +4 if stationary. We can't really detect that here very well, so we compromise.
	}
	
	// Make a DC 15 + nChecks fortitude save, or take nonlethal damage.
	if ( !ACR_SaveCheck( SAVING_THROW_FORT, oPC, nDC, TRUE, FALSE, nBonus ) ) {
		SendMessageToPC( oPC, "The heat saps you, leaving behind sweat and exhaustion." );
		_DoHeatDamage( oPC, d6(), FALSE );
	}
	
	// Increment check counter.
	nChecks++;
	SetLocalInt( oPC, ACR_HAZ_TEMP_CHK, nChecks );
}


void _DoExtremeHeat( object oPC ) {
	// Basic data.
	int nChecks = GetLocalInt( oPC, ACR_HAZ_TEMP_CHK );
	int nCounter = GetLocalInt( oPC, ACR_HAZ_TEMP_CNT );
	int nDC = 15 + nChecks;
	int nBonus = 0;
	
	// Make a DC 15 survival check to help resist conditions.
	if ( ACR_SkillCheck( SKILL_SURVIVAL, oPC, 15, TRUE ) ) {
		SendMessageToPC( oPC, "Your survival skills help you ward yourself against the heat." );
		nBonus += 3; // This should be +2 if moving, +4 if stationary. We can't really detect that here very well, so we compromise.
	}
	
	// Always take lethal damage.
	SendMessageToPC( oPC, "The heat is so oppressive that it scorches your skin." );
	_DoHeatDamage( oPC, d6(), TRUE );
	
	// Make a DC 15 + nChecks fortitude save, or take nonlethal damage. 
	if ( !ACR_SaveCheck( SAVING_THROW_FORT, oPC, nDC, TRUE, FALSE, nBonus ) ) {
		_DoHeatDamage( oPC, d4(), FALSE );
	}
	
	// TODO: Chill equipment.
	
	// Increment check counter.
	nChecks++;
	SetLocalInt( oPC, ACR_HAZ_TEMP_CHK, nChecks );
}


void _DoColdDamage( object oPC, int nDamage, int nLethal ) {
	int nCurrentHP = GetCurrentHitPoints( oPC );

	if ( !nLethal && ( _GetNLDTotal( oPC ) <= nCurrentHP ) ) {
		ACR_ApplyNonlethalDamageToCreature( oPC, d6() );
	} else {
		ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( nDamage, DAMAGE_TYPE_COLD, FALSE ), oPC );
		if ( nCurrentHP != GetCurrentHitPoints( oPC ) ) {
			ACR_SetIsFatigued( oPC, TRUE );
		}
	}
}


void _DoCold( object oPC ) {
	// Basic data.
	int nChecks = GetLocalInt( oPC, ACR_HAZ_TEMP_CHK );
	int nCounter = GetLocalInt( oPC, ACR_HAZ_TEMP_CNT );
	int nDC = 15 + nChecks;
	int nBonus = 0;
	
	// Make a DC 15 survival check to help resist conditions.
	if ( ACR_SkillCheck( SKILL_SURVIVAL, oPC, 15, TRUE ) ) {
		SendMessageToPC( oPC, "Your survival skills help you ward yourself against the cold." );
		nBonus += 3; // This should be +2 if moving, +4 if stationary. We can't really detect that here very well, so we compromise.
	}
	
	// Make a DC 15 + nChecks fortitude save, or take nonlethal damage.
	if ( !ACR_SaveCheck( SAVING_THROW_FORT, oPC, nDC, TRUE, FALSE, nBonus ) ) {
		SendMessageToPC( oPC, "The cold seeps in, aching your bones." );
		_DoColdDamage( oPC, d6(), FALSE );
	}
	
	// Increment check counter.
	nChecks++;
	SetLocalInt( oPC, ACR_HAZ_TEMP_CHK, nChecks );
}


void _DoSevereCold( object oPC ) {
	// Basic data.
	int nChecks = GetLocalInt( oPC, ACR_HAZ_TEMP_CHK );
	int nCounter = GetLocalInt( oPC, ACR_HAZ_TEMP_CNT );
	int nDC = 15 + nChecks;
	int nBonus = 0;
	
	// Make a DC 15 survival check to help resist conditions.
	if ( ACR_SkillCheck( SKILL_SURVIVAL, oPC, 15, TRUE ) ) {
		SendMessageToPC( oPC, "Your survival skills help you ward yourself against the cold." );
		nBonus += 3; // This should be +2 if moving, +4 if stationary. We can't really detect that here very well, so we compromise.
	}
	
	// Make a DC 15 + nChecks fortitude save, or take nonlethal damage.
	if ( !ACR_SaveCheck( SAVING_THROW_FORT, oPC, nDC, TRUE, FALSE, nBonus ) ) {
		SendMessageToPC( oPC, "The cold seeps in, aching your bones." );
		_DoColdDamage( oPC, d6(), FALSE );
	}
	
	// Increment check counter.
	nChecks++;
	SetLocalInt( oPC, ACR_HAZ_TEMP_CHK, nChecks );
}


void _DoExtremeCold( object oPC ) {
	// Basic data.
	int nChecks = GetLocalInt( oPC, ACR_HAZ_TEMP_CHK );
	int nCounter = GetLocalInt( oPC, ACR_HAZ_TEMP_CNT );
	int nDC = 15 + nChecks;
	int nBonus = 0;
	
	// Make a DC 15 survival check to help resist conditions.
	if ( ACR_SkillCheck( SKILL_SURVIVAL, oPC, 15, TRUE ) ) {
		SendMessageToPC( oPC, "Your survival skills help you ward yourself against the cold." );
		nBonus += 3; // This should be +2 if moving, +4 if stationary. We can't really detect that here very well, so we compromise.
	}
	
	// Always take lethal damage.
	SendMessageToPC( oPC, "The cold seeps in, aching your bones." );
	_DoColdDamage( oPC, d6(), TRUE );
	
	// Make a DC 15 + nChecks fortitude save, or take nonlethal damage. 
	if ( !ACR_SaveCheck( SAVING_THROW_FORT, oPC, nDC, TRUE, FALSE, nBonus ) ) {
		_DoColdDamage( oPC, d4(), FALSE );
	}
	
	// TODO: Chill equipment.
	
	// Increment check counter.
	nChecks++;
	SetLocalInt( oPC, ACR_HAZ_TEMP_CHK, nChecks );
}

#endif