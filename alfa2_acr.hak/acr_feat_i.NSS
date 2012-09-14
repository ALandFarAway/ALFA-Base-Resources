////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_feat_i
//      Version : 0.5
//         Date : 2011-09-08
//       Author : Ronan
//
//  Local Variable Prefix = ACR_FEAT
//
//
//  Dependencies external of nwscript: none
//
//  Description
//  This script contains all the ACR hooks for handling custom feats.
//
//  Revision History
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_i"
#include "acr_queue_i"
#include "acr_effects_i"
#include "acr_pchide_i"
#include "x2_inc_itemprop"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

const float ACR_FEAT_HEARTBEAT_DELAY = 6.0;

const string ACR_FEAT_HEARTBEAT_FLAG = "ACR_FEAT_HB_";
const string ACR_FEAT_HEARTBEAT_QUEUE = "ACR_FEAT_HB_QUEUE";

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! Returns TRUE if oCreature's nFeat's custom script isn't running, and flags
//! that it is running (so future calls will return FALSE). Should only be called
//! from custom Persistent feat scripts.
int ACR_EnterCustomFeatHeartbeat(object oCreature, int nFeat);

//! Returns TRUE if oCreature's nFeat's custom heartbeart script should continue.
//! Returns FALSE if it shouldn't.
int ACR_ContinueCustomFeatHeartbeat(object oCreature, int nFeat);

void _ContinueCustomFeatHeartbeat(object oCreature, int nFeat, string sScript);

//! Handle on level up feat adjustments.
void ACR_FeatsOnPCLevelUp( object oPC );

//! Give the player the benefits of an ALFA skill focus feat if they don't
//! already have it.
void _GiveSkillFocusBonus( object oPC, object oHide, int nFeat, int nSkill );

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void ACR_StartCustomFeatHeartbeat(object oCreature, int nFeat) {
	string sFeat = IntToString(nFeat);
	if(GetLocalInt(oCreature, ACR_FEAT_HEARTBEAT_FLAG + sFeat))
		return;
	
	SetLocalInt(oCreature, ACR_FEAT_HEARTBEAT_FLAG + IntToString(nFeat), TRUE);
	string sScript = GetFeatSpellScript(nFeat);
	_ContinueCustomFeatHeartbeat(oCreature, nFeat, sScript);
}

void _ContinueCustomFeatHeartbeat(object oCreature, int nFeat, string sScript) {
	if(!GetHasFeat(nFeat, oCreature, TRUE)) {
		RemoveAllEffectsFromSource(oCreature, ACR_EFFECT_SOURCE_FEAT_OFFSET + nFeat);
		DeleteLocalInt(oCreature, ACR_FEAT_HEARTBEAT_FLAG + IntToString(nFeat));
		return;
	}

	DelayCommand(ACR_FEAT_HEARTBEAT_DELAY, _ContinueCustomFeatHeartbeat(oCreature, nFeat, sScript));
	ExecuteScript(sScript + "_hb", oCreature);
}

void ACR_FeatsOnPCLevelUp( object oPC ) {
	// Get the PC hide object.
	object oHide = ACR_GetPCHide( oPC );
	
	// Handle the skill focus feats.
	_GiveSkillFocusBonus( oPC, oHide, FEAT_SKILL_FOCUS_BALANCE, SKILL_BALANCE );
	_GiveSkillFocusBonus( oPC, oHide, FEAT_SKILL_FOCUS_CLIMB, SKILL_CLIMB );
	_GiveSkillFocusBonus( oPC, oHide, FEAT_SKILL_FOCUS_DECIPHER, SKILL_DECIPHER_SCRIPT );
	_GiveSkillFocusBonus( oPC, oHide, FEAT_SKILL_FOCUS_DISGUISE, SKILL_DISGUISE );
	_GiveSkillFocusBonus( oPC, oHide, FEAT_SKILL_FOCUS_ESC_ART, SKILL_ESCAPE_ARTIST );
	_GiveSkillFocusBonus( oPC, oHide, FEAT_SKILL_FOCUS_FORGERY, SKILL_FORGERY );
	_GiveSkillFocusBonus( oPC, oHide, FEAT_SKILL_FOCUS_GATH_INFO, SKILL_GATHER_INFORMATION );
	_GiveSkillFocusBonus( oPC, oHide, FEAT_SKILL_FOCUS_HAND_ANIM, SKILL_HANDLE_ANIMAL );
	_GiveSkillFocusBonus( oPC, oHide, FEAT_SKILL_FOCUS_JUMP, SKILL_JUMP );
	_GiveSkillFocusBonus( oPC, oHide, FEAT_SKILL_FOCUS_PROF, SKILL_PROFESSION );
	_GiveSkillFocusBonus( oPC, oHide, FEAT_SKILL_FOCUS_RIDE_ACR, SKILL_RIDE );
	_GiveSkillFocusBonus( oPC, oHide, FEAT_SKILL_FOCUS_SENS_MOTV, SKILL_SENSE_MOTIVE );
	_GiveSkillFocusBonus( oPC, oHide, FEAT_SKILL_FOCUS_SPK_LANG, SKILL_SPEAK_LANGUAGE );
	_GiveSkillFocusBonus( oPC, oHide, FEAT_SKILL_FOCUS_SWIM, SKILL_SWIM );
	_GiveSkillFocusBonus( oPC, oHide, FEAT_SKILL_FOCUS_USE_ROPE, SKILL_USE_ROPE );
	_GiveSkillFocusBonus( oPC, oHide, FEAT_SKILL_FOCUS_KNOW_ARC, SKILL_KNOWLEDGE_ARCANA );
	_GiveSkillFocusBonus( oPC, oHide, FEAT_SKILL_FOCUS_KNOW_DUNG, SKILL_KNOWLEDGE_DUNGEONEERING );
	_GiveSkillFocusBonus( oPC, oHide, FEAT_SKILL_FOCUS_KNOW_ENG, SKILL_KNOWLEDGE_ENGINEERING );
	_GiveSkillFocusBonus( oPC, oHide, FEAT_SKILL_FOCUS_KNOW_GEO, SKILL_KNOWLEDGE_GEOGRAPHY );
	_GiveSkillFocusBonus( oPC, oHide, FEAT_SKILL_FOCUS_KNOW_HIST, SKILL_KNOWLEDGE_HISTORY );
	_GiveSkillFocusBonus( oPC, oHide, FEAT_SKILL_FOCUS_KNOW_LOC, SKILL_KNOWLEDGE_LOCAL );
	_GiveSkillFocusBonus( oPC, oHide, FEAT_SKILL_FOCUS_KNOW_NATR, SKILL_KNOWLEDGE_NATURE );
	_GiveSkillFocusBonus( oPC, oHide, FEAT_SKILL_FOCUS_KNOW_NOBL, SKILL_KNOWLEDGE_NOBILITY );
	_GiveSkillFocusBonus( oPC, oHide, FEAT_SKILL_FOCUS_KNOW_PLAN, SKILL_KNOWLEDGE_THE_PLANES );
	_GiveSkillFocusBonus( oPC, oHide, FEAT_SKILL_FOCUS_KNOW_RELG, SKILL_KNOWLEDGE_RELIGION );
	_GiveSkillFocusBonus( oPC, oHide, FEAT_SKILL_FOCUS_PERF_ACT, SKILL_PERFORM_ACT );
	_GiveSkillFocusBonus( oPC, oHide, FEAT_SKILL_FOCUS_PERF_COMD, SKILL_PERFORM_COMEDY );
	_GiveSkillFocusBonus( oPC, oHide, FEAT_SKILL_FOCUS_PERF_DANC, SKILL_PERFORM_DANCE );
	_GiveSkillFocusBonus( oPC, oHide, FEAT_SKILL_FOCUS_PERF_KEYB, SKILL_PERFORM_KEYBOARD );
	_GiveSkillFocusBonus( oPC, oHide, FEAT_SKILL_FOCUS_PERF_ORAT, SKILL_PERFORM_ORATORY );
	_GiveSkillFocusBonus( oPC, oHide, FEAT_SKILL_FOCUS_PERF_PERC, SKILL_PERFORM_PERCUSSION );
	_GiveSkillFocusBonus( oPC, oHide, FEAT_SKILL_FOCUS_PERF_SING, SKILL_PERFORM_SING );
	_GiveSkillFocusBonus( oPC, oHide, FEAT_SKILL_FOCUS_PERF_STRG, SKILL_PERFORM_STRING_INSTRUMENTS );
	_GiveSkillFocusBonus( oPC, oHide, FEAT_SKILL_FOCUS_PERF_WIND, SKILL_PERFORM_WIND_INSTRUMENTS );
	_GiveSkillFocusBonus( oPC, oHide, FEAT_SKILL_FOCUS_CRFT_ALCH, SKILL_CRAFT__ALCHEMY );
	_GiveSkillFocusBonus( oPC, oHide, FEAT_SKILL_FOCUS_CRFT_ARM, SKILL_CRAFT_ARMORSMITHING );
	_GiveSkillFocusBonus( oPC, oHide, FEAT_SKILL_FOCUS_CRFT_BOW, SKILL_CRAFT_BOWMAKING );
	_GiveSkillFocusBonus( oPC, oHide, FEAT_SKILL_FOCUS_CRFT_WPN, SKILL_CRAFT_WEAPONSMITHING );
}

void _GiveSkillFocusBonus( object oPC, object oHide, int nFeat, int nSkill ) {
	// Do we have an item to store the property on?
	if ( !GetIsObjectValid( oHide ) ) return;
	
	// Does the player have the right feat?
	if ( !GetHasFeat( nFeat, oPC ) ) return;
	
	// The property.
	itemproperty ipSkillFocus = ItemPropertySkillBonus( nSkill, 3 );

	// Marker that this feat is enabled.
	itemproperty ipFeat = ItemPropertyVisualEffect(IP_FEAT_OFFSET + nFeat);
	
	// Has this feat already been handled?
	if ( IPGetItemHasProperty( oHide, ipFeat, DURATION_TYPE_PERMANENT ) ) return;
	
	// Add the properties.
	AddItemProperty( DURATION_TYPE_PERMANENT, ipSkillFocus, oHide );
	AddItemProperty( DURATION_TYPE_PERMANENT, ipFeat, oHide );
}
