////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_prc_bladesinger_i
//      Version : 0.5
//         Date : 2011-09-08
//       Author : Ronan
//
//  Local Variable Prefix = ACR_PRC_BSING
//
//
//  Dependencies external of nwscript: feat.2da
//
//  Description
//  This script contains all the ACR scripts for the Bladesinger PRC.
//
//  Revision History
////////////////////////////////////////////////////////////////////////////////

#ifndef ACR_PRC_BSINGER_I
#define ACR_PRC_BSINGER_I

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_effects_i"
#include "acr_db_persist_i"
#include "acr_feat_i"
#include "acr_i"
#include "acr_tools_i"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! A heartbeat for refreshing the effects of Bladesong.
void StartBladesongHeartbeat(object oCreature);

//! A heartbeat for refreshing the effects of Lesser Spellsong.
//! We make it a heartbeat for NPCs with the PRC.
void StartLesserSpellsongHeartbeat(object oCreature);

//! Refreshes Bladesong effects on a creature.
void RefreshBladesong(object oCreature);

//! Heartbeat for Song of Fury.
//! We make it a heartbeat for NPCs with the PRC.
void StartSongOfFuryHeartbeat(object oCreature);

//! Called from the spellhook when a Bladesinger casts a spell.
void BladesingerSpellhook(object oCaster, int nMetaMagic);

//! At 1st Level while unarmoured, and weilding a Rapier or Longsword in one
//! hand (and nothing in the other) the Bladesinger Gains a Dodge Bonus to
//! their AC equal to their level but not exceeding their intelligence bonus.
int _GetBladesongACBonus(object oCreature);

//! Refreshes Song of Celerity and the feats it (temporarily) grants.
void RefreshSongOfCelerity(object oCreature);

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void RefreshBladesong(object oCreature) {

	int nMod = _GetBladesongACBonus(oCreature);

	ChangeEffectFromSource(
		FEAT_BLADESINGER_BLADESONG_STYLE + ACR_EFFECT_SOURCE_FEAT_OFFSET, 
		oCreature,
		SupernaturalEffect(EffectACIncrease(nMod, AC_DODGE_BONUS))
	);
}

void RefreshSpellsong(object oCreature) {
	object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oCreature);
	if(GetArmorRank(oItem) == ARMOR_RANK_LIGHT) {
		int nSpellFailure = GetTotalSpellFailure(oItem);
		ChangeEffectFromSource(
			FEAT_BLADESINGER_SPELLSONG + ACR_EFFECT_SOURCE_FEAT_OFFSET,
			oCreature,
			SupernaturalEffect(EffectArcaneSpellFailure(-nSpellFailure))
		);
	} else RemoveAllEffectsFromSource(oCreature, FEAT_BLADESINGER_SPELLSONG + ACR_EFFECT_SOURCE_FEAT_OFFSET);
}

void RefreshSongOfCelerity(object oCreature) {
	// Fix when the Spellhook is in the haks.
	/*
	if(GetHasFeat(FEAT_BLADESINGER_SONG_CELERITY, oCreature, FALSE)) {
		FeatAdd(oCreature, FEAT_EPIC_AUTOMATIC_QUICKEN_1, FALSE, FALSE, FALSE);
		FeatAdd(oCreature, FEAT_EPIC_AUTOMATIC_QUICKEN_2, FALSE, FALSE, FALSE);
		FeatAdd(oCreature, FEAT_EPIC_AUTOMATIC_QUICKEN_3, FALSE, FALSE, FALSE);
	} else {
		FeatRemove(oCreature, FEAT_EPIC_AUTOMATIC_QUICKEN_1);
		FeatRemove(oCreature, FEAT_EPIC_AUTOMATIC_QUICKEN_2);
		FeatRemove(oCreature, FEAT_EPIC_AUTOMATIC_QUICKEN_3);
	}*/
}

void BladesingerSpellhook(object oCaster, int nMetaMagic) {
	// Try to guess if we're using Automatic Quicken. Spell level would be <= 3.
	if(nMetaMagic & METAMAGIC_QUICKEN && GetSpellLevel(GetSpellId()) <= 3) {
		DecrementRemainingFeatUses(oCaster, FEAT_BLADESINGER_SONG_CELERITY);
		RefreshSongOfCelerity(oCaster);
	}
}

// Bit easier to write readable performant code using return statements in a
// seperate function.
int _GetBladesongACBonus(object oCreature) {
	int nWeaponType = GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCreature));
	if(nWeaponType != BASE_ITEM_RAPIER && nWeaponType != BASE_ITEM_LONGSWORD) return 0;
	if(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCreature) != OBJECT_INVALID) return 0;
	
	int nArmourType = GetArmorRank(GetItemInSlot(INVENTORY_SLOT_CHEST, oCreature));	
	if(nArmourType != ARMOR_RANK_NONE && nArmourType != ARMOR_RANK_LIGHT) return 0;

	int nIntMod = GetAbilityModifier(ABILITY_INTELLIGENCE, oCreature);
	int nBSLevel = GetLevelByClass(CLASS_BLADESINGER, oCreature);
	int nMod = (nBSLevel > nIntMod) ? nIntMod : nBSLevel;
	if(nMod < 0) nMod = 0;
	
	return nMod;
}

#endif