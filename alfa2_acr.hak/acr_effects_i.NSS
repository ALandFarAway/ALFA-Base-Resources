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
//  2011/09/08  Ronan: Added a function to re-apply AC bonuses from a single source because this comes up so often.
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_tools_i"
#include "nwn2_inc_spells"
#include "x2_inc_itemprop"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

const int ACR_EFFECT_SOURCE_START = 100000;

const int ACR_EFFECT_SOURCE_RESTING = 1;
const int ACR_EFFECT_SOURCE_COMBAT_ACTION = 2;

const int ACR_EFFECT_SOURCE_FATIGUE = 10;
const int ACR_EFFECT_SOURCE_OOC_ADAPTION = 11;

const int ACR_EFFECT_SOURCE_FEAT_OFFSET = 100000;
const int ACR_EFFECT_SOURCE_FEAT_END = 199999;

const int ACR_EFFECT_SOURCE_SPELL_OFFSET = 200000;
const int ACR_EFFECT_SOURCE_SPELL_END = 299999;

const string ACR_EFFECT_FLAGS = "ACR_EFFECT_FLAGS";
const int ACR_EFFECT_FLAG_FATIGUED = 0x01;
const int ACR_EFFECT_FLAG_EXHAUSTED = 0x02;

const int AOE_PER_RADIUS_MIN = 80;
const int AOE_PER_RADIUS_MAX = 120;

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! Functions like ApplyEffectsToObject, but applies effects from a specific source named sSource.
//! For spell sources, add ACR_EFFECT_SOURCE_SPELL_OFFSET to the SpellId.
//! For feat sources, add ACR_EFFECT_SOURCE_FEAT_OFFSET to the FeatId.
void ApplyEffectFromSource(int nSource, int nDurationType, effect eEffect, object oTarget, float fDuration=0.0f);

//! Removes all effects sSource placed on oTarget.
//! For spell sources, add ACR_EFFECT_SOURCE_SPELL_OFFSET to the SpellId.
//! For feat sources, add ACR_EFFECT_SOURCE_FEAT_OFFSET to the FeatId.
void RemoveAllEffectsFromSource(object oTarget, int nSource);

//! Removes all effects placed on oTarget by sources in the specified range.
void RemoveAllEffectsFromSourceRange(object oTarget, int nSourceMin, int nSourceMax);

//! Removes all effects placed on oTarget by feats.
void RemoveAllFeatEffects(object oTarget);

//! Returns true if the effect is from nSourceId.
int GetIsTrackingEffectFor(effect eEffect, int nSourceId);

//! Returns the source id of eEffect.
//! Returns 0 if eEffect is not a tracking effect.
int GetTrackingEffectSource(effect eEffect);

//! Returns true if the effect is a tracking effect.
int GetIsTrackingEffect(effect eEffect, int nSourceId);

//! Returns the number of tracking effect found for source id nSourceId on oTarget. Returns OBJECT_INVALID if no effect is found.
int CountTrackingEffectsFor(object oTarget, int nSource);

//! This function sets the fatigue status on the target creature
//!  - oPC: player who's fatigue status is being adjusted
//!  - bStatus: the new fatigue status to apply
//!  - Returns: nothing
void ACR_SetIsFatigued(object oPC, int bStatus);

//! This function sets the exhausted status on the target creature
//!  - oPC: player who's exhausted status is being adjusted
//!  - bStatus: the new exhausted status to apply
//!  - Returns: nothing
void ACR_SetIsExhausted(object oPC, int bStatus);

//! This function sets the adaption status on the target creature
//!  - oPC: player who's adaption status is being adjusted
//!  - bStatus: the new adaption status to apply
//!  - Returns: nothing
void ACR_SetAdaption(object oPC, int bStatus);

//! This function retrieves the fatigue status on the target creature
//!  - oPC: player who's fatigue status is being queried
//!  - Returns: nothing
int ACR_GetIsFatigued(object oPC);

//! This function retrieves the exhausted status on the target creature
//!  - oPC: player who's exhausted status is being queried
//!  - Returns: nothing
int ACR_GetIsExhausted(object oPC);

//! Add fatigue/exhaustion to oPC dependent on current state
//!  - oPC: creature to exhaust
//!  - Returns: 1,2,3 (new level of exhaustion)
int ACR_AddFatigueToCreature(object oPC);

//! Wrapper for the standard NWN2 EffectFatigue effect, returns the effect
effect ACR_EffectFatigue();

//! Wrapper for the standard NWN2 EffectExhausted effect, returns the effect
effect ACR_EffectExhausted();

//! ACR Adaption effect to be used during skill/feat adjustment, returns the effect
effect ACR_AdaptionEffect();

//! If nAmount differs from the last nAmount passed to this function on oCreature from
//! nSource, all effects from nSource are removed and replaced by eEffect.
//! For spell sources, add ACR_EFFECT_SOURCE_SPELL_OFFSET to the SpellId.
//! For feat sources, add ACR_EFFECT_SOURCE_FEAT_OFFSET to the FeatId.
void ChangeEffectFromSource(int nSource, object oCreature, effect eEffect);

//! Return AOE ID for a specific radius for EffectAreaOfEffect
int ACR_GetAOERadiusID(float fRadius);

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
	if(!nSourceId) return 0;
	return nSourceId == GetTrackingEffectSource(eEffect);
}


int GetTrackingEffectSource(effect eEffect) {
	if(GetEffectType(eEffect) != EFFECT_TYPE_VISUALEFFECT) return 0;
	int nSource = GetEffectInteger(eEffect, 0);
	return (nSource > ACR_EFFECT_SOURCE_START) ? (nSource - ACR_EFFECT_SOURCE_START) : 0;
}


void RemoveAllEffectsFromSource(object oTarget, int nSource) {
	RemoveAllEffectsFromSourceRange(oTarget, nSource, nSource);
}


void RemoveAllEffectsFromSourceRange(object oTarget, int nSourceMin, int nSourceMax) {

	effect eff = GetFirstEffect(oTarget);
	while(GetIsEffectValid(eff)) {
		int nSource = GetTrackingEffectSource(eff);
		if(nSource >= nSourceMin && nSource <= nSourceMax) {
			RemoveEffect(oTarget, eff);
		}
		eff = GetNextEffect(oTarget);
	}
}


void RemoveAllFeatEffects(object oTarget) {
	RemoveAllEffectsFromSourceRange(oTarget, ACR_EFFECT_SOURCE_FEAT_OFFSET, ACR_EFFECT_SOURCE_FEAT_END);
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


int ACR_GetIsExhausted(object oPC)
{
	return (ACR_GetPersistentInt(oPC, ACR_EFFECT_FLAGS) & ACR_EFFECT_FLAG_EXHAUSTED);
}


int ACR_AddFatigueToCreature(object oPC)
{
	if (ACR_GetIsFatigued(oPC)) {
		ACR_SetIsFatigued(oPC, 0);
		ACR_SetIsExhausted(oPC, 1);
		return 2;
	}
	else if (!ACR_GetIsExhausted(oPC)){
		ACR_SetIsExhausted(oPC, 0);
		ACR_SetIsFatigued(oPC, 1);
		return 1;
	}

	return 3;
}


void ACR_SetIsFatigued(object oPC, int bStatus)
{
    // check if fatigue is being activated or deactivated
    if (bStatus)
    {
        // set the persistent fatigue status
        ACR_SetPersistentInt(oPC, ACR_EFFECT_FLAGS, ACR_GetPersistentInt(oPC, ACR_EFFECT_FLAGS) | ACR_EFFECT_FLAG_FATIGUED);
	ApplyEffectFromSource(ACR_EFFECT_SOURCE_FATIGUE, DURATION_TYPE_PERMANENT, ACR_EffectFatigue(), oPC);
    }
    else
    {
        // unset the persistent fatigue status
        ACR_SetPersistentInt(oPC, ACR_EFFECT_FLAGS, ACR_GetPersistentInt(oPC, ACR_EFFECT_FLAGS) & ~(ACR_EFFECT_FLAG_FATIGUED));
	RemoveAllEffectsFromSource(oPC, ACR_EFFECT_SOURCE_FATIGUE);
    }
}


void ACR_SetIsExhausted(object oPC, int bStatus)
{
    // check if exhausted is being activated or deactivated
    if (bStatus)
    {
        // set the persistent fatigue status
        ACR_SetPersistentInt(oPC, ACR_EFFECT_FLAGS, ACR_GetPersistentInt(oPC, ACR_EFFECT_FLAGS) | ACR_EFFECT_FLAG_EXHAUSTED);
	ApplyEffectFromSource(ACR_EFFECT_SOURCE_FATIGUE, DURATION_TYPE_PERMANENT, ACR_EffectFatigue(), oPC);
    }
    else
    {
        // unset the persistent exhausted status
        ACR_SetPersistentInt(oPC, ACR_EFFECT_FLAGS, ACR_GetPersistentInt(oPC, ACR_EFFECT_FLAGS) & ~(ACR_EFFECT_FLAG_EXHAUSTED));
	RemoveAllEffectsFromSource(oPC, ACR_EFFECT_SOURCE_FATIGUE);
    }
}


void ACR_SetAdaptionEffect(object oPC, int bStatus)
{
	if (bStatus)
		ApplyEffectFromSource(ACR_EFFECT_SOURCE_OOC_ADAPTION, DURATION_TYPE_PERMANENT, ACR_AdaptionEffect(), oPC);
	else
		RemoveAllEffectsFromSource(oPC, ACR_EFFECT_SOURCE_OOC_ADAPTION);
}


effect ACR_EffectFatigue()
{
	return EffectFatigue();
}


effect ACR_EffectExhausted()
{
	return EffectExhausted();
}


effect ACR_AdaptionEffect()
{
	effect e1,e2,e3;
	e1 = EffectEthereal();
	e2 = EffectVisualEffect(VFX_DUR_SHINING_SHIELD);
	e3 = EffectCutsceneImmobilize();
	e1 = EffectLinkEffects(e2, e1);
	e1 = EffectLinkEffects(e3, e1);

	e1 = SupernaturalEffect(e1);

	return e1;
}


void ChangeEffectFromSource(int nSource, object oCreature, effect eEffect) {	
	RemoveAllEffectsFromSource(oCreature, nSource);
	
	ApplyEffectFromSource(nSource, DURATION_TYPE_PERMANENT, eEffect, oCreature);
}

int ACR_GetAOERadiusID(float fRadius)
{
	int ret;

	fRadius = fRadius/FeetToMeters(1.0);
	ret = AOE_PER_RADIUS_MIN + FloatToInt(fabs(fRadius/5.0f));
	
	if (ret > AOE_PER_RADIUS_MAX)
		ret = AOE_PER_RADIUS_MAX;

	return ret;
}

void ACR_AddTemporaryDarkvision(object player, object item)
{
	IPSafeAddItemProperty(item, ItemPropertyBonusFeat(IP_CONST_FEAT_DARKVISION));
	SetActionMode(player, ACTION_MODE_DARKVISION, 1);
}

void ACR_RemoveTemporaryDarkvision(object player, object item)
{
	SetActionMode(player, ACTION_MODE_DARKVISION, 0);
	IPRemoveMatchingItemProperties(item, ITEM_PROPERTY_BONUS_FEAT, DURATION_TYPE_PERMANENT);
}
