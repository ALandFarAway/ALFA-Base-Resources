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
//
//  Revision History
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_tools_i"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

const int ACR_EFFECT_SOURCE_START = 100000;

const int ACR_EFFECT_SOURCE_MAGE_ARMOR_SPELL = 1;
const int ACR_EFFECT_SOURCE_SHIELD_SPELL = 2;
const int ACR_EFFECT_SOURCE_RESTING = 3;

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