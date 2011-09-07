////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ACR Configuration File
//     Filename : acr_effects_i
//      Version : 1.0
//         Date : 2011-08-21
//       Author : Ronan
//
//  Local Variable Prefix = ACR_EFF
//
//
//  Dependencies external of nwscript: None
//
//  Description
//  This script provides tools for tracking effects.
//  Also provides some basic effects
//
//  Revision History
//  2011/09/04  Paazin: Remove Fatigue code from acr_restting_i and place it into acr_effects_i
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_tools_i"
#include "nwn2_inc_spells"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

const int ACR_EFFECT_SOURCE_START = 100000;

const int ACR_EFFECT_SOURCE_MAGE_ARMOR_SPELL = 1;
const int ACR_EFFECT_SOURCE_SHIELD_SPELL = 2;
const int ACR_EFFECT_SOURCE_RESTING = 3;
const int ACR_EFFECT_SOURCE_COMBAT_ACTION = 4;

const string ACR_EFFECT_FLAGS = "ACR_EFFECT_FLAGS";
const int ACR_EFFECT_FLAG_FATIGUED = 0x01;

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! Functions like ApplyEffectsToObject, but applies this effects from a specific source named sSource.
void ApplyEffectFromSource(int nSource, int nDurationType, effect eEffect, object oTarget, float fDuration=0.0f);

//! Removes all effects sSource placed on oTarget.
void RemoveAllEffectsFromSource(object oTarget, int nSource);

//! Returns true if the effect is from nSourceId.
int GetIsTrackingEffectFor(effect eEffect, int nSourceId);

//! Returns true if the effect is a tracking effect.
int GetIsTrackingEffect(effect eEffect, int nSourceId);

//! Returns the number of tracking effect found for source id nSourceId on oTarget. Returns OBJECT_INVALID if no effect is found.
int CountTrackingEffectsFor(object oTarget, int nSource);

//! This function sets the fatigue status on the target creature
//!  - oPC: player who's fatigue status is being adjusted
//!  - bStatus: the new fatigue status to apply
//!  - Returns: nothing
void ACR_SetIsFatigued(object oPC, int bStatus);

//! This function retrieves the fatigue status on the target creature
//!  - oPC: player who's fatigue status is being queried
//!  - Returns: nothing
int ACR_GetIsFatigued(object oPC);

//! Find Fatigue effect on a player and return it, otherwise return an empty effect
effect ACR_GetFatigueEffectOnPlayer(object player);

//! Wrapper for the standard NWN2 EffectFatigue effect, returns the effect
effect ACR_EffectFatigue();

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void ApplyEffectFromSource(int nSource, int nDurationType, effect eEffect, object oTarget, float fDuration=0.0f) {
	ApplyEffectToObject(
		nDurationType,
		EffectLinkEffects(eEffect, EffectVisualEffect(ACR_EFFECT_SOURCE_START + nSource)),
		oTarget,
		fDuration);
}

int GetIsTrackingEffect(effect eEffect, int nSourceId) {
	return GetEffectType(eEffect) == EFFECT_TYPE_VISUALEFFECT && GetEffectInteger(eEffect, 0) > ACR_EFFECT_SOURCE_START;
}

int GetIsTrackingEffectFor(effect eEffect, int nSourceId) {
	return GetEffectType(eEffect) == EFFECT_TYPE_VISUALEFFECT && GetEffectInteger(eEffect, 0) == (ACR_EFFECT_SOURCE_START + nSourceId);
}

void RemoveAllEffectsFromSource(object oTarget, int nSource) {

	effect eff = GetFirstEffect(oTarget);
	while(GetIsEffectValid(eff)) {
		if(GetIsTrackingEffectFor(eff, nSource)) {
			RemoveEffect(oTarget, eff);
		}
		eff = GetNextEffect(oTarget);
	}
}

int CountTrackingEffectsFor(object oTarget, int nSource) {

	int count = 0;

	effect eff = GetFirstEffect(oTarget);
	while(GetIsEffectValid(eff)) {
		if(GetIsTrackingEffectFor(eff, nSource)) {
			count++;
		}
		eff = GetNextEffect(oTarget);
	}
	return count;
}

int ACR_GetIsFatigued(object oPC)
{
	return (ACR_GetPersistentInt(oPC, ACR_EFFECT_FLAGS) & ACR_EFFECT_FLAG_FATIGUED);
}

void ACR_SetIsFatigued(object oPC, int bStatus)
{
    // check if fatigue is being activated or deactivated
    if (bStatus)
    {
        // set the persistent fatigue status
        ACR_SetPersistentInt(oPC, ACR_EFFECT_FLAGS, ACR_GetPersistentInt(oPC, ACR_EFFECT_FLAGS) | ACR_EFFECT_FLAG_FATIGUED);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, ACR_EffectFatigue(), oPC);
    }
    else
    {
        // unset the persistent fatigue status
        ACR_SetPersistentInt(oPC, ACR_EFFECT_FLAGS, ACR_GetPersistentInt(oPC, ACR_EFFECT_FLAGS) & ~(ACR_EFFECT_FLAG_FATIGUED));
	RemoveEffect(oPC, ACR_GetFatigueEffectOnPlayer(oPC));
    }
}

effect ACR_GetFatigueEffectOnPlayer(object player)
{
	effect e = GetFirstEffect(player),null_effect;
	while (GetIsEffectValid(e)) {
	
		// This should be the only extraordinary effect that decreases movement speed
		if (		(GetEffectType(e) == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE)
			&&	(GetEffectSubType(e) == SUBTYPE_EXTRAORDINARY)
			&&	(GetEffectDurationType(e) == DURATION_TYPE_PERMANENT))
			return e;
		
		e = GetNextEffect(player);
	}

	return null_effect;
}

effect ACR_EffectFatigue()
{
	return EffectFatigue();
}
