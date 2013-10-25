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

#ifndef ACR_FEAT_I
#define ACR_FEAT_I

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

// Public
//

//! Returns TRUE if oCreature's nFeat's custom script isn't running, and flags
//! that it is running (so future calls will return FALSE). Should only be called
//! from custom Persistent feat scripts.
int ACR_EnterCustomFeatHeartbeat(object oCreature, int nFeat);

//! Returns TRUE if oCreature's nFeat's custom heartbeart script should continue.
//! Returns FALSE if it shouldn't.
int ACR_ContinueCustomFeatHeartbeat(object oCreature, int nFeat);

//! Handle on level up feat adjustments.
void ACR_FeatsOnPCLevelUp( object oPC );

// Private
//

void _RefreshFeatsOnHide ( object oPC );

void _ContinueCustomFeatHeartbeat(object oCreature, int nFeat, string sScript);

//! Handle all Feat bonuses for hide
void _HandleFeatBonus(object oPC, object oHide, int nFeat, int nSkill=0);

//! Return an itemproperty representing a skillfocus bonus
itemproperty _SkillFocusBonus( int nSkill );

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_i"
#include "acr_queue_i"
#include "acr_effects_i"
#include "acr_pchide_i"
#include "x2_inc_itemprop"

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
	ACR_RecalculatePCHide( oPC );
}

#endif