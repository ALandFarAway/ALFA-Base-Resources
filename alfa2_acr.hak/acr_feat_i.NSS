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

//! Refresh a PC's hide to account for any changes
void ACR_RefreshHide(object oPC);

// Private
//

void _RefreshFeatsOnHide ( object oPC );

void _ContinueCustomFeatHeartbeat(object oCreature, int nFeat, string sScript);

//! Handle all Feat bonuses for hide
void _HandleFeatBonus(object oPC, object oHide, int nFeat, int nSkill=0);

//! Return an itemproperty representing a skillfocus bonus
itemproperty _SkillFocusBonus( int nSkill );

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

void ACR_RefreshHide(object oPC)
{
	object oHide = ACR_GetPCHide(oPC);

	if (!GetIsObjectValid(oHide))
		return;

	// Clean up hide
	ACR_RemoveAllPropertiesFromHide(oHide, DURATION_TYPE_PERMANENT);

	ACR_FeatsOnPCLevelUp(oPC);
	
	
	// Examine variables for hide
	// Place desired adjustments
}

void ACR_FeatsOnPCLevelUp( object oPC ) {
	ACR_RefreshHide( oPC );
}


void _RefreshFeatsOnHide( object oPC ) {
	// Get the PC hide object.
	object oHide = ACR_GetPCHide( oPC );

	// Do we have an item to store the property on?
	if ( !GetIsObjectValid( oHide ) )
		return;
	
	// Handle the skill focus feats.
	_HandleFeatBonus( oPC, oHide, FEAT_SKILL_FOCUS_BALANCE, SKILL_BALANCE );
	_HandleFeatBonus( oPC, oHide, FEAT_SKILL_FOCUS_CLIMB, SKILL_CLIMB );
	_HandleFeatBonus( oPC, oHide, FEAT_SKILL_FOCUS_DECIPHER, SKILL_DECIPHER_SCRIPT );
	_HandleFeatBonus( oPC, oHide, FEAT_SKILL_FOCUS_DISGUISE, SKILL_DISGUISE );
	_HandleFeatBonus( oPC, oHide, FEAT_SKILL_FOCUS_ESC_ART, SKILL_ESCAPE_ARTIST );
	_HandleFeatBonus( oPC, oHide, FEAT_SKILL_FOCUS_FORGERY, SKILL_FORGERY );
	_HandleFeatBonus( oPC, oHide, FEAT_SKILL_FOCUS_GATH_INFO, SKILL_GATHER_INFORMATION );
	_HandleFeatBonus( oPC, oHide, FEAT_SKILL_FOCUS_HAND_ANIM, SKILL_HANDLE_ANIMAL );
	_HandleFeatBonus( oPC, oHide, FEAT_SKILL_FOCUS_JUMP, SKILL_JUMP );
	_HandleFeatBonus( oPC, oHide, FEAT_SKILL_FOCUS_PROF, SKILL_PROFESSION );
	_HandleFeatBonus( oPC, oHide, FEAT_SKILL_FOCUS_RIDE_ACR, SKILL_RIDE );
	_HandleFeatBonus( oPC, oHide, FEAT_SKILL_FOCUS_SENS_MOTV, SKILL_SENSE_MOTIVE );
	_HandleFeatBonus( oPC, oHide, FEAT_SKILL_FOCUS_SPK_LANG, SKILL_SPEAK_LANGUAGE );
	_HandleFeatBonus( oPC, oHide, FEAT_SKILL_FOCUS_SWIM, SKILL_SWIM );
	_HandleFeatBonus( oPC, oHide, FEAT_SKILL_FOCUS_USE_ROPE, SKILL_USE_ROPE );
	_HandleFeatBonus( oPC, oHide, FEAT_SKILL_FOCUS_KNOW_ARC, SKILL_KNOWLEDGE_ARCANA );
	_HandleFeatBonus( oPC, oHide, FEAT_SKILL_FOCUS_KNOW_DUNG, SKILL_KNOWLEDGE_DUNGEONEERING );
	_HandleFeatBonus( oPC, oHide, FEAT_SKILL_FOCUS_KNOW_ENG, SKILL_KNOWLEDGE_ENGINEERING );
	_HandleFeatBonus( oPC, oHide, FEAT_SKILL_FOCUS_KNOW_GEO, SKILL_KNOWLEDGE_GEOGRAPHY );
	_HandleFeatBonus( oPC, oHide, FEAT_SKILL_FOCUS_KNOW_HIST, SKILL_KNOWLEDGE_HISTORY );
	_HandleFeatBonus( oPC, oHide, FEAT_SKILL_FOCUS_KNOW_LOC, SKILL_KNOWLEDGE_LOCAL );
	_HandleFeatBonus( oPC, oHide, FEAT_SKILL_FOCUS_KNOW_NATR, SKILL_KNOWLEDGE_NATURE );
	_HandleFeatBonus( oPC, oHide, FEAT_SKILL_FOCUS_KNOW_NOBL, SKILL_KNOWLEDGE_NOBILITY );
	_HandleFeatBonus( oPC, oHide, FEAT_SKILL_FOCUS_KNOW_PLAN, SKILL_KNOWLEDGE_THE_PLANES );
	_HandleFeatBonus( oPC, oHide, FEAT_SKILL_FOCUS_KNOW_RELG, SKILL_KNOWLEDGE_RELIGION );
	_HandleFeatBonus( oPC, oHide, FEAT_SKILL_FOCUS_PERF_ACT, SKILL_PERFORM_ACT );
	_HandleFeatBonus( oPC, oHide, FEAT_SKILL_FOCUS_PERF_COMD, SKILL_PERFORM_COMEDY );
	_HandleFeatBonus( oPC, oHide, FEAT_SKILL_FOCUS_PERF_DANC, SKILL_PERFORM_DANCE );
	_HandleFeatBonus( oPC, oHide, FEAT_SKILL_FOCUS_PERF_KEYB, SKILL_PERFORM_KEYBOARD );
	_HandleFeatBonus( oPC, oHide, FEAT_SKILL_FOCUS_PERF_ORAT, SKILL_PERFORM_ORATORY );
	_HandleFeatBonus( oPC, oHide, FEAT_SKILL_FOCUS_PERF_PERC, SKILL_PERFORM_PERCUSSION );
	_HandleFeatBonus( oPC, oHide, FEAT_SKILL_FOCUS_PERF_SING, SKILL_PERFORM_SING );
	_HandleFeatBonus( oPC, oHide, FEAT_SKILL_FOCUS_PERF_STRG, SKILL_PERFORM_STRING_INSTRUMENTS );
	_HandleFeatBonus( oPC, oHide, FEAT_SKILL_FOCUS_PERF_WIND, SKILL_PERFORM_WIND_INSTRUMENTS );
	_HandleFeatBonus( oPC, oHide, FEAT_SKILL_FOCUS_CRFT_ALCH, SKILL_CRAFT__ALCHEMY );
	_HandleFeatBonus( oPC, oHide, FEAT_SKILL_FOCUS_CRFT_ARM, SKILL_CRAFT_ARMORSMITHING );
	_HandleFeatBonus( oPC, oHide, FEAT_SKILL_FOCUS_CRFT_BOW, SKILL_CRAFT_BOWMAKING );
	_HandleFeatBonus( oPC, oHide, FEAT_SKILL_FOCUS_CRFT_WPN, SKILL_CRAFT_WEAPONSMITHING );
	_HandleFeatBonus( oPC, oHide, FEAT_ARTIST );
}

itemproperty _SkillFocusBonus( int nSkill ) {
	return ItemPropertySkillBonus( nSkill, 3 );
}


void _HandleFeatBonus(object oPC, object oHide, int nFeat, int nSkill)
{
	itemproperty ip0, ip1, ip2, ip3, ip4, ip5, ip6, ip7, ip8, ip9, ip10;
	int extra_ips = 0;

	
	// Does the player have the right feat?
	if (!GetHasFeat(nFeat, oPC))
		return;


	switch (nFeat) {

		// NWN2 Background Feats
		//

		case FEAT_ARTIST:
			// -2 Diplomacy
			// +2 Perform (All)
			// +2 Craft (Calligraphy, Painting, Sculpture, or Weaving)
			// +3 Bardsong/day
			ip0 = ItemPropertyDecreaseSkill(SKILL_DIPLOMACY, 2);
			ip1 = ItemPropertySkillBonus(SKILL_PERFORM_ACT, 2);
			ip2 = ItemPropertySkillBonus(SKILL_PERFORM_COMEDY, 2);
			ip3 = ItemPropertySkillBonus(SKILL_PERFORM_DANCE, 2);
			ip4 = ItemPropertySkillBonus(SKILL_PERFORM_KEYBOARD, 2);
			ip5 = ItemPropertySkillBonus(SKILL_PERFORM_ORATORY, 2);
			ip6 = ItemPropertySkillBonus(SKILL_PERFORM_PERCUSSION, 2);
			ip7 = ItemPropertySkillBonus(SKILL_PERFORM_STRING_INSTRUMENTS, 2);
			ip8 = ItemPropertySkillBonus(SKILL_PERFORM_SING, 2);
			ip9 = ItemPropertySkillBonus(SKILL_PERFORM_WIND_INSTRUMENTS, 2);

			// Possibly boost a Craft (Other)
			// Add 3 bardsongs per day?
			extra_ips = 1;
			break;

		case FEAT_COURTLY_MAGOCRACY:
			// +2 Knowledge (Arcana)
			ip0 = ItemPropertySkillBonus(SKILL_KNOWLEDGE_ARCANA, 2);
			break;

		case FEAT_NEGOTIATOR:
			// -2 Bluff
			// +2 Sense Motive
			ip0 = ItemPropertyDecreaseSkill(SKILL_BLUFF, 2);
			ip1 = ItemPropertySkillBonus(SKILL_SENSE_MOTIVE, 2);
			break;

		case FEAT_SILVER_PALM:
			// -2 Diplomacy
			// +2 Sense Motive
			ip0 = ItemPropertyDecreaseSkill(SKILL_DIPLOMACY, 2);
			ip1 = ItemPropertySkillBonus(SKILL_SENSE_MOTIVE, 2);
			break;

		case FEAT_SNAKEBLOOD:
			// +1 Reflex save
			ip0 = ItemPropertyBonusSavingThrow(IP_CONST_SAVEBASETYPE_REFLEX, 1);
			break;


		// Standard Background Feats
		// 
		
		case FEAT_COSMOPOLITAN:
			// +2 Bluff
			// +2 Gather Information
			// +2 Sense Motive
			ip0 = ItemPropertySkillBonus(SKILL_BLUFF, 2);
			ip1 = ItemPropertySkillBonus(SKILL_GATHER_INFORMATION, 2);
			ip2 = ItemPropertySkillBonus(SKILL_SENSE_MOTIVE, 2);
			break;

		case FEAT_DISCIPLINE:
			// +2 Concentration
			// +2 Will
			ip0 = ItemPropertySkillBonus(SKILL_CONCENTRATION, 2);
			ip1 = ItemPropertyBonusSavingThrow(IP_CONST_SAVEBASETYPE_WILL, 2);
			break;

		case FEAT_FEARLESS_BK:
			// Immunity to Fear
			ip0 = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_FEAR);
			break;

		case FEAT_FORGEHEART:
			// 5/- Fire reduction
			ip0 = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGERESIST_5);
			break;

		case FEAT_FORESTER:
			// +1 Hide
			// +1 Listen
			// +1 Move Silently
			// +1 Spot
			// +3 in Forest
			ip0 = ItemPropertySkillBonus(SKILL_HIDE, 1);
			ip1 = ItemPropertySkillBonus(SKILL_LISTEN, 1);
			ip2 = ItemPropertySkillBonus(SKILL_MOVE_SILENTLY, 1);
			ip3 = ItemPropertySkillBonus(SKILL_SPOT, 1);
			break;

		case FEAT_SPELLWISE:
			// +2 Knowledge (Arcana)
			// +2 Spellcraft
			// +2 vs Illusions
			ip0 = ItemPropertySkillBonus(SKILL_KNOWLEDGE_ARCANA, 2);
			ip1 = ItemPropertySkillBonus(SKILL_SPELLCRAFT, 2);
			ip2 = ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_MINDAFFECTING, 2);
			break;

		case FEAT_STREET_SMART:
			// +2 Gather Information
			// +2 Intimidate
			// +2 Sense Motive
			ip0 = ItemPropertySkillBonus(SKILL_GATHER_INFORMATION, 2);
			ip1 = ItemPropertySkillBonus(SKILL_INTIMIDATE, 2);
			ip2 = ItemPropertySkillBonus(SKILL_SENSE_MOTIVE, 2);
			break;

		case FEAT_SUREFOOTED:
			// +2 Climb
			// +2 Jump
			ip0 = ItemPropertySkillBonus(SKILL_CLIMB, 2);
			ip1 = ItemPropertySkillBonus(SKILL_JUMP, 2);
			break;

		case FEAT_SURVIVOR:
			// +2 Survival
			// +2 Fortitude
			ip0 = ItemPropertySkillBonus(SKILL_SURVIVAL, 2);
			ip1 = ItemPropertyBonusSavingThrow(IP_CONST_SAVEBASETYPE_FORTITUDE, 2);
			break;

		case FEAT_TREETOPPER:
			// +2 Balance
			// +2 Climb
			ip0 = ItemPropertySkillBonus(SKILL_BALANCE, 2);
			ip1 = ItemPropertySkillBonus(SKILL_CLIMB, 2);
			break;


		// Standard Feats
		//

		case FEAT_ACROBATIC:
			// +2 Jump
			// +2 Tumble
			ip0 = ItemPropertySkillBonus(SKILL_JUMP, 2);
			ip1 = ItemPropertySkillBonus(SKILL_TUMBLE, 2);
			break;

		case FEAT_AGILE:
			// +2 Balance
			// +2 Escape Artist
			ip0 = ItemPropertySkillBonus(SKILL_BALANCE, 2);
			ip1 = ItemPropertySkillBonus(SKILL_ESCAPE_ARTIST, 2);
			break;

		case FEAT_ANIMAL_AFFINITY:
			// +2 Handle Animal
			// +2 Ride
			ip0 = ItemPropertySkillBonus(SKILL_HANDLE_ANIMAL, 2);
			ip1 = ItemPropertySkillBonus(SKILL_RIDE, 2);
			break;

		case FEAT_ATHLETIC:
			// +2 Climb
			// +2 Swim
			ip0 = ItemPropertySkillBonus(SKILL_CLIMB, 2);
			ip1 = ItemPropertySkillBonus(SKILL_SWIM, 2);
			break;

		case FEAT_DECEITFUL:
			// +2 Disguise
			// +2 Forgery
			ip0 = ItemPropertySkillBonus(SKILL_DISGUISE, 2);
			ip1 = ItemPropertySkillBonus(SKILL_FORGERY, 2);
			break;

		case FEAT_DEFT_HANDS:
			// +2 Sleight of Hand
			// +2 Use Rope
			ip0 = ItemPropertySkillBonus(SKILL_SLEIGHT_OF_HAND, 2);
			ip1 = ItemPropertySkillBonus(SKILL_USE_ROPE, 2);
			break;

		case FEAT_DILIGENT:
			// +2 Appraise
			// +2 Decipher Script
			ip0 = ItemPropertySkillBonus(SKILL_APPRAISE, 2);
			ip1 = ItemPropertySkillBonus(SKILL_DECIPHER_SCRIPT, 2);
			break;

		case FEAT_INVESTIGATOR:
			// +2 Gather Information
			// +2 Search
			ip0 = ItemPropertySkillBonus(SKILL_GATHER_INFORMATION, 2);
			ip1 = ItemPropertySkillBonus(SKILL_SEARCH, 2);
			break;

		case FEAT_MAGICAL_APTITUDE:
			// +2 Spellcraft
			// +2 Use Magic Device
			ip0 = ItemPropertySkillBonus(SKILL_SPELLCRAFT, 2);
			ip1 = ItemPropertySkillBonus(SKILL_USE_MAGIC_DEVICE, 2);
			break;

		case FEAT_PERSUASIVE:
			// +2 Bluff
			// +2 Intimidate
			ip0 = ItemPropertySkillBonus(SKILL_BLUFF, 2);
			ip1 = ItemPropertySkillBonus(SKILL_INTIMIDATE, 2);
			break;

		default:
				
			if (nSkill != 0)
				ip0 = _SkillFocusBonus(nSkill);

			break;
	}

	AddItemProperty(DURATION_TYPE_PERMANENT, ip0, oHide);
	AddItemProperty(DURATION_TYPE_PERMANENT, ip1, oHide);
	AddItemProperty(DURATION_TYPE_PERMANENT, ip2, oHide);
	AddItemProperty(DURATION_TYPE_PERMANENT, ip3, oHide);

	if (extra_ips) {
		AddItemProperty(DURATION_TYPE_PERMANENT, ip4, oHide);
		AddItemProperty(DURATION_TYPE_PERMANENT, ip5, oHide);
		AddItemProperty(DURATION_TYPE_PERMANENT, ip6, oHide);
		AddItemProperty(DURATION_TYPE_PERMANENT, ip7, oHide);
		AddItemProperty(DURATION_TYPE_PERMANENT, ip8, oHide);
		AddItemProperty(DURATION_TYPE_PERMANENT, ip9, oHide);
		AddItemProperty(DURATION_TYPE_PERMANENT, ip10, oHide);
	}
}
