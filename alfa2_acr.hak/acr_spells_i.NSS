////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_spells_i.nss
//      Version : 0.1
//         Date : 2011-05-26
//       Author : Ronan
//
//  Local Variable Prefix = None
//
//
//  Dependencies external of nwscript: None
//
//  Description
//  Utility functions used by ALFA's modified spells.
//
//  Revision History
//	2011-05-26	Ronan	Initial version.
//	2012-05-29	Foam	Added ACR_GetSpellDuration.
////////////////////////////////////////////////////////////////////////////////

#ifndef ACR_SPELLS_I
#define ACR_SPELLS_I

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

const float ACR_DURATION_GLOBAL_SCALE = 1.0f;
const float ACR_DURATION_10M_SCALE = 1.0f;
const float ACR_DURATION_HOUR_SCALE = 13.0f / 60.0f;

const int ACR_DURATION_TYPE_STATIC = 0;
const int ACR_DURATION_TYPE_PER_CL = 1;

const float ACR_DURATION_1R = 6.0f;
const float ACR_DURATION_6S = 6.0f;
const float ACR_DURATION_60S = 60.0f;
const float ACR_DURATION_1M = 60.0f;
const float ACR_DURATION_10M = 600.0f * ACR_DURATION_10M_SCALE;
const float ACR_DURATION_1H = 3600.0f * ACR_DURATION_HOUR_SCALE;
const float ACR_DURATION_2H = ACR_DURATION_1H * 2.0f;
const float ACR_DURATION_24H = ACR_DURATION_1H * 24.0f;

const float ACR_MC_GOLD_SCALE = 0.0f;

const string ACR_SPELL_RESIST_PREFIX = "ACR_SPELL_RESIST_";
const string ACR_SPELL_VULNER_PREFIX = "ACR_SPELL_VULNER_";

const string ACR_SPELL_DESCRIPT_VAR_PREFIX = "ACR_SPELL_DESC_";
const int ACR_SPELL_DESCRIPT_ACID = 0;
const int ACR_SPELL_DESCRIPT_AIR = 1;
const int ACR_SPELL_DESCRIPT_CHAOTIC = 2;
const int ACR_SPELL_DESCRIPT_COLD = 3;
const int ACR_SPELL_DESCRIPT_DARKNESS = 4;
const int ACR_SPELL_DESCRIPT_DEATH = 5;
const int ACR_SPELL_DESCRIPT_EARTH = 6;
const int ACR_SPELL_DESCRIPT_ELECTRICITY = 7;
const int ACR_SPELL_DESCRIPT_EVIL = 8;
const int ACR_SPELL_DESCRIPT_FEAR = 9;
const int ACR_SPELL_DESCRIPT_FIRE = 10;
const int ACR_SPELL_DESCRIPT_FORCE = 11;
const int ACR_SPELL_DESCRIPT_GOOD = 12;
const int ACR_SPELL_DESCRIPT_LANGUAGE_DEP = 13;
const int ACR_SPELL_DESCRIPT_LAWFUL = 14;
const int ACR_SPELL_DESCRIPT_LIGHT = 15;
const int ACR_SPELL_DESCRIPT_MIND_AFFECTING = 16;
const int ACR_SPELL_DESCRIPT_SONIC = 17;
const int ACR_SPELL_DESCRIPT_WATER = 18;

const string _DM_CASTER_LEVEL = "ACR_SPELLS_DM_CL";

const int ACR_MAX_SPELLID = 3200;

const string DICT_SPELL_NAME = "DICT_SPELL_NAME";
const string DICT_SPELL_LVL = "DICT_SPELL_LVL";


////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// Precast and post-cast events.
int ACR_PrecastEvent();
int ACR_PostcastEvent();

//! Calculates the duration of a spell's effects.
//!  - oCaster: the spell caster for whom the duration is being calculated
//!  - nDurationType: the ACR_DURATION_TYPE_ constant to determine if caster
//!     level is involved in duration calculation
//!  - nDurationBase: the duration of the spell in seconds, or the number which
//!     is manipulated by the caster level.
float ACR_GetSpellDuration( object oCaster, int nDurationType, float nDurationBase );

//! Handle and pay a material component.
int ACR_PayMaterialComponentCost( object oCaster, string sItemName, int nGold, int bPayGoldIfNoItem = TRUE );

int ACR_GetCorrectCasterLevel(object oCreature, int nClass = -1);

int ACR_SpellResistanceCheck( object oCaster, object oCreature, int nSpellId = -1 );

//! Gets the common/standard spell level for a spell of Id nSpellId.
int ACR_GetSpellLevel( int nSpellId );

//! Sets if the currently casting spell is a domain spell or not.
void ACR_SetIsDomainSpell( int nDomain, int bValue );

void WarnWhenSpellExpires(object oCreature, int nSpellId, string sMessage, float fDuration);

void _floatMessageIfHasSpellEffect(object oCreature, int nSpellId, string sMessage, float fDuration);

//! Get spell name from ID
string ACR_GetSpellName(int nSpellId);

//! Get spell innate level from ID
int ACR_GetSpellInnateLevel(int nSpellId);

//! ACR's version of nw_i0_spells spellCure function.
void ACR_SpellCure( object oTarget, int nDieCount, int nDieSides, int nMaxExtraDamage, int nSpellID, int vfxImpactHeal, int vfxImpactHarm );

//! ACR's version of x0_i0_spells spellsInflictTouchAttack function.
void ACR_SpellsInflictTouchAttack( object oTarget, int nDieCount, int nDieSides, int nMaxExtraDamage, int nSpellID, int vfxImpactHeal, int vfxImpactHarm );

//! ACR's version of nw_i0_spells spellsHealOrHarmTarget function.
void ACR_SpellsHealOrHarmTarget( object oTarget, int nDamageTotal, int vfx_impactNormalHurt, int vfx_impactUndeadHurt, int vfx_impactHeal, int nSpellID, int bIsHealingSpell=TRUE, int bHarmTouchAttack=TRUE );

//! ACR's version of nw_i0_spells GetCureDamageTotal. Handles changes to our feats.
int ACR_GetCureDamageTotal( object oTarget, int nDieCount, int nDieSides, int nMaxExtraDamage, int nSpellID );

string _GetDomainVarName( int nDomain );

//! Cache Name/Lvl of Spell 2da for future use
void ACR_Cache2daSpellListing();

//! Adds a persistant AC bonus effect to oTarget, such as is used in Mage Armor and Shield spells.
void PersistACBonusFromSpell(object oTarget, int nSpellId, int nACType, int nACBonus, float fDurationRemaining, effect eLinkedEffects);

//!!  Handles caster level check (if needed) for use of a scroll.
//!!    - oUser - The PC or NPC using the scroll
//!!    - oScroll - The scroll item
//!!    - nSpellID - the Spells.2da ID for the spell to be cast.
//!!    Returns:
//!!     1 - Scroll works properly
//!!     2 - Scroll use failed.
int ACR_ScrollUse(object oUser, object oScroll, int nSpellID);

//! *** PRIVATE FUNCTIONS ***

//! Determines which class a given caster should use to activate a scroll, and whether they succeed.
int _DetermineScrollAttempt(object oCaster, int nScrollID);

//! Works out how hard the caster level check would be for a given class, level, and spell level
int _ScrollCastDiff(int nClass, int nUserLevel, int nSpellLevel);

//! Attempts a caster level check, with chance for mishap on failure.
int _AttemptScrollUse(int nScrollID, int nSpellLevel, object oCaster, int nSpellClass);

//! Handles mishap checks for scroll use.
int _ScrollMishapCheck(object oCaster, int nScrollID, int nSpellLevel, int nSpellID);

//! Handles actual scroll mishap effects.
//!  takes the user and the level and identity of the spell into account.
void _ProcessMishap(object oCaster, int nSpellLevel, int nSpellID);

//! Check if we need to cache the spell 2da list
int ACR__CheckIsReadySpell2daList();

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "nw_i0_spells"
#include "x2_inc_spellhook"
#include "acr_i"
#include "acr_roll_i"
#include "acr_creature_i"
#include "acr_effects_i"

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

int ACR_PrecastEvent() {
	// First call NWN2's precast code.
	if ( !X2PreSpellCastCode() ) return FALSE;
	
	return TRUE;
}

int ACR_PostcastEvent() {
	// Delete temp description variables.
	ACR_SetIsDomainSpell( ACR_SPELL_DESCRIPT_ACID, FALSE );
	ACR_SetIsDomainSpell( ACR_SPELL_DESCRIPT_AIR, FALSE );
	ACR_SetIsDomainSpell( ACR_SPELL_DESCRIPT_CHAOTIC, FALSE );
	ACR_SetIsDomainSpell( ACR_SPELL_DESCRIPT_COLD, FALSE );
	ACR_SetIsDomainSpell( ACR_SPELL_DESCRIPT_DARKNESS, FALSE );
	ACR_SetIsDomainSpell( ACR_SPELL_DESCRIPT_DEATH, FALSE );
	ACR_SetIsDomainSpell( ACR_SPELL_DESCRIPT_EARTH, FALSE );
	ACR_SetIsDomainSpell( ACR_SPELL_DESCRIPT_ELECTRICITY, FALSE );
	ACR_SetIsDomainSpell( ACR_SPELL_DESCRIPT_EVIL, FALSE );
	ACR_SetIsDomainSpell( ACR_SPELL_DESCRIPT_FEAR, FALSE );
	ACR_SetIsDomainSpell( ACR_SPELL_DESCRIPT_FIRE, FALSE );
	ACR_SetIsDomainSpell( ACR_SPELL_DESCRIPT_FORCE, FALSE );
	ACR_SetIsDomainSpell( ACR_SPELL_DESCRIPT_GOOD, FALSE );
	ACR_SetIsDomainSpell( ACR_SPELL_DESCRIPT_LANGUAGE_DEP, FALSE );
	ACR_SetIsDomainSpell( ACR_SPELL_DESCRIPT_LAWFUL, FALSE );
	ACR_SetIsDomainSpell( ACR_SPELL_DESCRIPT_LIGHT, FALSE );
	ACR_SetIsDomainSpell( ACR_SPELL_DESCRIPT_MIND_AFFECTING, FALSE );
	ACR_SetIsDomainSpell( ACR_SPELL_DESCRIPT_SONIC, FALSE );
	ACR_SetIsDomainSpell( ACR_SPELL_DESCRIPT_WATER, FALSE );

	return TRUE;
}

float ACR_GetSpellDuration( object oCaster, int nDurationType, float nDurationBase ) {
	// Get base duration.
	float nDuration = nDurationBase;
	
	// Adjust to caster level if not static.
	if ( nDurationType == ACR_DURATION_TYPE_PER_CL ) {
		nDuration = nDuration * ACR_GetCorrectCasterLevel( oCaster );
	}
	
	// Check for extended metamagic.
	if ( GetMetaMagicFeat() & METAMAGIC_EXTEND ) {
		nDuration = nDuration * 2;
	}
	
	// Check for persistent metamagic.
	if ( GetMetaMagicFeat() & METAMAGIC_PERSISTENT ) {
		nDuration = ACR_DURATION_24H;
	}
	
	// Apply global duration scaling.
	nDuration = nDuration * ACR_DURATION_GLOBAL_SCALE;
	
	return nDuration;
}

int ACR_PayMaterialComponentCost( object oCaster, string sItemName, int nGold, int bPayGoldIfNoItem = TRUE ) {
	// Dealing with an item or gold?
	if ( sItemName == "" ) {
		// Scale our gold by our constant.
		nGold = FloatToInt( IntToFloat( nGold ) * ACR_MC_GOLD_SCALE );
		if ( nGold <= 0 ) return TRUE;
		
		// Return false if we don't have enough gold.
		if ( GetGold( oCaster ) < nGold ) {
			return FALSE;
		}
		
		// Remove the gold.
		AssignCommand( oCaster, TakeGoldFromCreature( nGold, oCaster, TRUE, FALSE ) );
		SendMessageToPC( oCaster, "You have paid " + IntToString( nGold ) + "gp in material components." );
	} else {
		// We currently don't support item material components.
		return ACR_PayMaterialComponentCost( oCaster, "", nGold, TRUE );
	}
	return TRUE;
}

int _GetClassCL(int nClass, int nLevel) {

	if(nLevel < 1) return 0;

	switch(nClass) {
		case CLASS_TYPE_BARD:
		case CLASS_TYPE_CLERIC:
		case CLASS_TYPE_DRUID:
		case CLASS_TYPE_FAVORED_SOUL:
		case CLASS_TYPE_SORCERER:
		case CLASS_TYPE_SPIRIT_SHAMAN:
		case CLASS_TYPE_WIZARD:
		case CLASS_LOREMASTER:
		case CLASS_MYSTICTHEURGE:
		case CLASS_TYPE_STORMLORD:
		case CLASS_TYPE_DOOMGUIDE:
		case CLASS_TYPE_ARCANE_SCHOLAR:
		case CLASS_TYPE_ARCANETRICKSTER:
		case CLASS_TYPE_RED_WIZARD:
			return nLevel;
		
		case CLASS_TYPE_PALADIN:
		case CLASS_TYPE_RANGER:
			return (nLevel < 4) ? 0 : nLevel / 2;
		
		case CLASS_BLADESINGER:
			return 1 + nLevel / 2;
		
		case CLASS_TYPE_WARPRIEST:
			return nLevel / 2;
		
		case CLASS_TYPE_HARPER:
		case CLASS_TYPE_ELDRITCH_KNIGHT:
			return nLevel - 1;
		
		case CLASS_TYPE_SACREDFIST:
			return (nLevel + 1) * 3 / 4;
	}
	return 0;
}

int _GetClassCLContribution(object oCreature, int nCasterClass, int nClass) {
	if(nClass == nCasterClass)
		// This is the same class we're casting from.
		return _GetClassCL(nClass, GetLevelByClass(nClass, oCreature));
	else {
		// This is not the same class we're casting from.
		// Check to see if its mapped to our class.
		string sFeatMap2DA = Get2DAString("classes", "BonusCasterFeatByClassMap", nClass);
		if(sFeatMap2DA == "****" || sFeatMap2DA == "")
			return 0;
		else {
			int nFeat = StringToInt(Get2DAString(sFeatMap2DA, "SpellcasterFeat", nCasterClass));
			// Lets assume nFeat == 0 an error, since feat 0 is alertness.
			if(!nFeat) nFeat = -1;
			return GetHasFeat(nFeat, oCreature) * _GetClassCL(nClass, GetLevelByClass(nClass, oCreature));
		}
	}
}

int ACR_GetCorrectCasterLevel(object oCreature, int nClass = -1) {

	if(GetSpellCastItem() != OBJECT_INVALID) return GetCasterLevel(oCreature);

	// If no class is provided, get the last caster class.
	if ( nClass == -1 ) nClass = GetLastSpellCastClass();
	
	if(GetIsDM(oCreature)) {
		int nCL = GetLocalInt(oCreature, _DM_CASTER_LEVEL);
		return nCL ? nCL : 10;
	}

	int i = 1;
	int nCL;
	for(; i<5; i++) {
		int nCurClass = GetClassByPosition(i, oCreature);
		if(nCurClass != CLASS_TYPE_INVALID)
			nCL += _GetClassCLContribution(oCreature, nClass, nCurClass);
	}
	
	int nPS = StringToInt(Get2DAString("classes", "FEATPracticedSpellcaster", nClass));
	if(nPS && GetHasFeat(nPS, oCreature)) {
		int nHd = GetHitDice(oCreature);
		nCL += 4;
		if(nCL > nHd) nCL = nHd;
	}
	
	return nCL;
}

int ACR_SpellResistanceCheck( object oCaster, object oCreature, int nSpellId = -1 ) {
	if ( nSpellId < 0 ) nSpellId = GetSpellId();
	
	// Check for a specific immunity.
	if ( GetLocalInt( oCreature, ACR_SPELL_RESIST_PREFIX + IntToString( nSpellId ) ) ) return TRUE;
	
	// Check for a specific vulnerability.
	if ( GetLocalInt( oCreature, ACR_SPELL_VULNER_PREFIX + IntToString( nSpellId ) ) ) return FALSE;
	
	// Otherwise we just wrap MyResistSpell.
	return MyResistSpell( oCaster, oCreature );
}

int ACR_GetSpellLevel( int nSpellId ) {
    ClearScriptParams();
    AddScriptParameterObject(OBJECT_INVALID);
    AddScriptParameterInt(ACR_ITEMS_CSHARP_SPELL_LEVEL);
    AddScriptParameterInt(nSpellId);
    return ExecuteScriptEnhanced("ACR_Items", OBJECT_SELF, TRUE);
}

void ACR_SetIsDomainSpell( int nDomain, int nValue ) {
	string sVarName = _GetDomainVarName( nDomain );

	// Are we deleting?
	if ( nValue = FALSE ) {
		DeleteLocalInt( OBJECT_SELF, sVarName );
		return;
	}
	
	SetLocalInt( OBJECT_SELF, sVarName, nValue );
}

int ACR_GetIsDomainSpell( int nDomain ) {
	return ( GetLocalInt( OBJECT_SELF, _GetDomainVarName( nDomain ) ) != FALSE );
}

int ACR_GetHighestCasterLevel(object oCreature) {
	int nCL;
	
	int level = ACR_GetCorrectCasterLevel(oCreature, CLASS_TYPE_CLERIC);
	nCL = (level > nCL) ? level : nCL;
	
	level = ACR_GetCorrectCasterLevel(oCreature, CLASS_TYPE_DRUID);
	nCL = (level > nCL) ? level : nCL;
	
	level = ACR_GetCorrectCasterLevel(oCreature, CLASS_TYPE_FAVORED_SOUL);
	nCL = (level > nCL) ? level : nCL;
	
	level = ACR_GetCorrectCasterLevel(oCreature, CLASS_TYPE_SPIRIT_SHAMAN);
	nCL = (level > nCL) ? level : nCL;
	
	level = ACR_GetCorrectCasterLevel(oCreature, CLASS_TYPE_BARD);
	nCL = (level > nCL) ? level : nCL;
	
	level = ACR_GetCorrectCasterLevel(oCreature, CLASS_TYPE_SORCERER);
	nCL = (level > nCL) ? level : nCL;
	
	level = ACR_GetCorrectCasterLevel(oCreature, CLASS_TYPE_WIZARD);
	nCL = (level > nCL) ? level : nCL;
	
	level = ACR_GetCorrectCasterLevel(oCreature, CLASS_TYPE_PALADIN);
	nCL = (level > nCL) ? level : nCL;
	
	level = ACR_GetCorrectCasterLevel(oCreature, CLASS_TYPE_RANGER);
	nCL = (level > nCL) ? level : nCL;
	
	return nCL;
}

void WarnWhenSpellExpires(object oCreature, int nSpellId, string sMessage, float fDuration) {
	DelayCommand(fDuration - 12.0, _floatMessageIfHasSpellEffect(oCreature, nSpellId, sMessage, 12.0));
}

void _floatMessageIfHasSpellEffect(object oCreature, int nSpellId, string sMessage, float fDuration) {
	if(GetHasSpellEffect(nSpellId, oCreature))
		FloatingTextStringOnCreature(sMessage, oCreature, TRUE, fDuration);
}

void ACR_Cache2daSpellListing()
{
	ACR_Cache2daListing(SPELLS_2DA, SPELLS_NAME_COL, DICT_SPELL_NAME, ACR_MAX_SPELLID);
	ACR_Cache2daListing(SPELLS_2DA, SPELLS_INNATE_LEVEL_COL, DICT_SPELL_LVL, ACR_MAX_SPELLID);
}

int ACR__CheckIsReadySpell2daList()
{
	if (ACR_CheckIsReady2daList(DICT_SPELL_NAME))
		return 1;

	if (!ACR_CheckIsStarted2daList(DICT_SPELL_NAME))
		ACR_Cache2daSpellListing();

	return 0;
}

string ACR_GetSpellName(int spell_id)
{
	string str, strref;

	str = IntToString(spell_id);

	if (!ACR__CheckIsReadySpell2daList()) {
		return "error";
	}

	strref  = ACR_DictionaryGet(DICT_SPELL_NAME, str);
	return GetStringByStrRef(StringToInt(strref));
}

int ACR_GetSpellInnateLevel(int spell_id)
{
	string str;

	str = IntToString(spell_id);

	if (!ACR__CheckIsReadySpell2daList()) {
		return -1;
	}

	return StringToInt(ACR_DictionaryGet(DICT_SPELL_LVL, str));
}

string ACR_GetSpellList(object oCreature, int nMemorized=0)
{
	int id, lvl, num, len, old_lvl;
	string name, str, msg, dict_id = "TMP";

	if (!ACR__CheckIsReadySpell2daList()) {
		return "Please try again shortly.  Spell list not yet ready.";
	}

	// Iterate through all possible spells to determine those present
	for (str = ACR_DictionaryIterateFirst(DICT_SPELL_NAME); str != ""; str = ACR_DictionaryIterateNext(DICT_SPELL_NAME)) {
		id = StringToInt(str);

		num = (nMemorized ? GetHasSpell(id, oCreature) : GetSpellKnown(oCreature, id));

		if (num) {
			lvl = ACR_GetSpellInnateLevel(id);
			name = ACR_GetSpellName(id);

			// Handle sorting (reverse order from highest level spell to lowest)
			lvl = 10 - lvl;

			if (lvl < 10) {
				str = "0" + IntToString(lvl);
			}
			else
				str = "10";

			str += " " + name;

			ACR_DictionarySet(dict_id, str, IntToString(num));
		}
	}

	old_lvl = -1;
	msg = "";

	// Iterate through spells present and format
	for (str = ACR_DictionaryIterateFirst(dict_id); str != ""; str = ACR_DictionaryIterateNext(dict_id)) {
		len = GetStringLength(str);
		name = GetStringRight(str, len-3);

		// Shift level back to correct value
		lvl = 10-StringToInt(GetStringLeft(str, 2));

		num = StringToInt(ACR_DictionaryGet(dict_id, str));

		// Display spell level if new level
		if (old_lvl != lvl) {

			// Remove trailing comma
			len = GetStringLength(msg);
			msg = GetStringLeft(msg, len-2);

			msg += "\n<b>Level " + IntToString(lvl) + "</b>: ";
			old_lvl = lvl;
		}

		// Display number if > 1
		if (num > 1) {
			msg += IntToString(num) + " ";
		}

		msg += name + ", ";
	}

	ACR_DictionaryClear(dict_id);

	// Remove trailing comma
	if (old_lvl != -1) {
		len = GetStringLength(msg);
		msg = GetStringLeft(msg, len-2);
	}

	return msg;
}

void ACR_SpellCure( object oTarget, int nDieCount, int nDieSides, int nMaxExtraDamage, int nSpellID, int vfxImpactHeal, int vfxImpactHarm ) {
	int nDamageTotal = ACR_GetCureDamageTotal( oTarget, nDieCount, nDieSides, nMaxExtraDamage, nSpellID );
 	int bIsHealingSpell = TRUE;
	int bHarmTouchAttack = TRUE;
	ACR_SpellsHealOrHarmTarget( oTarget, nDamageTotal, vfxImpactHarm, vfxImpactHarm, vfxImpactHeal, nSpellID, bIsHealingSpell, bHarmTouchAttack );
}

void ACR_SpellsInflictTouchAttack( object oTarget, int nDieCount, int nDieSides, int nMaxExtraDamage, int nSpellID, int vfxImpactHeal, int vfxImpactHarm ) {
	int nMetaMagic = GetMetaMagicFeat();
	
	// Calculate damage.
	int nDamage = ACR_Roll( nDieCount, nDieSides );
	
	// Handle metamagics.
	if ( nMetaMagic == METAMAGIC_MAXIMIZE ) {
		nDamage = ( nDieCount * nDieSides );
	} else if ( nMetaMagic == METAMAGIC_EMPOWER ) {
		nDamage += ( nDamage / 2 );
	}
	
	// Get caster level bonus damage.
	int nExtraDamage = GetCasterLevel(OBJECT_SELF);
	if ( nSpellID == SPELLABILITY_BG_INFLICT_SERIOUS_WOUNDS ) nExtraDamage = GetLevelByClass( CLASS_TYPE_BLACKGUARD );
	if ( nSpellID == SPELLABILITY_BG_INFLICT_CRITICAL_WOUNDS ) nExtraDamage = GetLevelByClass( CLASS_TYPE_BLACKGUARD );
	if ( nExtraDamage > nMaxExtraDamage ) nExtraDamage = nMaxExtraDamage;
	nDamage += nExtraDamage;
	
	// Do the harming.
	int bIsHealingSpell = FALSE;
	int bHarmTouchAttack = TRUE;
	ACR_SpellsHealOrHarmTarget( oTarget, nDamage, vfxImpactHarm, vfxImpactHarm, vfxImpactHeal, nSpellID, bIsHealingSpell, bHarmTouchAttack );
}

void ACR_SpellsHealOrHarmTarget( object oTarget, int nDamageTotal, int vfx_impactNormalHurt, int vfx_impactUndeadHurt, int vfx_impactHeal, int nSpellID, int bIsHealingSpell=TRUE, int bHarmTouchAttack=TRUE ) {
	int bIsHarmful = FALSE;
	
	// Immune to healing effects?
	if ( GetLocalInt( oTarget, VAR_IMMUNE_TO_HEAL ) == TRUE ) {
		return;
	}
	
	// Apply effects.
	if ( !ACR_GetIsUndead( oTarget ) ) {
		if ( bIsHealingSpell ) {
			DoHealing( oTarget, nDamageTotal, vfx_impactHeal );
		} else {
			DoHarming( oTarget, nDamageTotal, DAMAGE_TYPE_NEGATIVE, vfx_impactNormalHurt, bHarmTouchAttack );
			bIsHarmful = TRUE;
		}
	} else {
		if ( bIsHealingSpell ) {
			DoHarming( oTarget, nDamageTotal, DAMAGE_TYPE_POSITIVE, vfx_impactUndeadHurt, bHarmTouchAttack );
			bIsHarmful = TRUE;
		} else {
			DoHealing( oTarget, nDamageTotal, vfx_impactHeal );
		}
	}
}

int ACR_GetCureDamageTotal( object oTarget, int nDieCount, int nDieSides, int nMaxExtraDamage, int nSpellID ) {
	// Get base data.
	object oCaster = OBJECT_SELF;
	int nCasterClass = GetLastSpellCastClass();
	int nCasterLevel = ACR_GetCorrectCasterLevel( oCaster, nCasterClass );
	int nMetaMagic = GetMetaMagicFeat();
	
	// Cure spells are treated one level higher if we're a healing domain cleric.
	if ( nCasterClass == CLASS_TYPE_CLERIC && GetHasFeat( FEAT_HEALING_DOMAIN_POWER, oCaster ) ) {
		nCasterLevel++;
	}
	
	// Get the damage.
	int nDamage = ACR_Roll( nDieCount, nDieSides );
	
	// Apply metamagic.
	if ( nMetaMagic == METAMAGIC_MAXIMIZE ) {
		nDamage = ( nDieCount * nDieSides );
	} else if ( nMetaMagic == METAMAGIC_EMPOWER ) {
		nDamage += ( nDamage / 2 );
	}

	// Add the caster level as bonus, to a maximum.
	int nExtraDamage = nCasterLevel;
	if ( nExtraDamage > nMaxExtraDamage ) nExtraDamage = nMaxExtraDamage;
	nDamage += nExtraDamage;
	
	// Handle the Augment Healing feat.
	if ( GetHasFeat( FEAT_AUGMENT_HEALING ) && !GetIsObjectValid( GetSpellCastItem() ) ) {
		int nSpellLvl = GetSpellLevel( nSpellID );
		nDamage += ( 2 * nSpellLvl );
	}
	
	return nDamage;
}

string _GetDomainVarName( int nDomain ) {
	return ACR_SPELL_DESCRIPT_VAR_PREFIX + IntToString( nDomain );
}

int _GetPersistentACBonusTarget(object oTarget, int nACType, int nACBonus) {
	// Find the base and enhancement AC bonuses.
	// Base should not stack with the effect.
	// Enhancement should.
	int nEnhancement = 0;
	int nBaseAC = 0;
	if(nACType == AC_ARMOUR_ENCHANTMENT_BONUS) {
		object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget);
		nBaseAC = GetBaseArmorClass(oArmor);
		nEnhancement = GetACEnhancementBonus(oArmor);
		/* Not sure what to do with bracers...
		object oBracers = GetItemInSlot(INVENTORY_SLOT_ARMS, oTarget);
		if(GetBaseItemType(oBracers) == BASE_ITEM_BRACER) {
			int nBracersEnhancement = GetACEnhancementBonus(oBracers);
			if(nBracersEnhancement > nEnhancement) nEnhancement = nBracersEnhancement;
		}*/
	} else if(nACType = AC_SHIELD_ENCHANTMENT_BONUS) {
		object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
		int nType = GetBaseItemType(oShield);
		if(nType == BASE_ITEM_TOWERSHIELD || nType == BASE_ITEM_LARGESHIELD || nType == BASE_ITEM_SMALLSHIELD) {
			nEnhancement = GetACEnhancementBonus(oShield);
			nBaseAC = GetBaseArmorClass(oShield);
		}
	}
	
	int nResult = nACBonus + nEnhancement - nBaseAC;
	if(nResult < 0) nResult = 0;
	return nResult;
}

void _AddPersistentACBonusEffects(object oTarget, int nSpellId, int nACType, int nBonus, float fDurationRemaining, effect eLinkedEffects) {	

	if(nBonus <= 0) {
		// If there's no AC bonus needed, persist this effect as something else so the spell won't be ended.
		if(GetEffectType(eLinkedEffects) != EFFECT_TYPE_INVALIDEFFECT)
			ApplyEffectFromSpell(nSpellId, DURATION_TYPE_TEMPORARY, eLinkedEffects, oTarget, fDurationRemaining);
			else ApplyTrackingEffectFromSpell(nSpellId, DURATION_TYPE_TEMPORARY, oTarget, fDurationRemaining);
	} else {
		effect newEffect = EffectACIncrease(nBonus, nACType);
		SetEffectSpellId(newEffect, nSpellId);
		if(GetEffectType(eLinkedEffects) != EFFECT_TYPE_INVALIDEFFECT) 
			newEffect = EffectLinkEffects(eLinkedEffects, newEffect);
			
		ApplyEffectFromSpell(nSpellId, DURATION_TYPE_TEMPORARY, newEffect, oTarget, fDurationRemaining);
	}
}

void _PersistACBonusFromSpell(object oTarget, int nSpellId, int nACType, int nACBonus, int nLastACBonus, float fDurationRemaining, effect eLinkedEffects, int bIsPC) {	
	
	if(bIsPC && !GetIsObjectValid(oTarget)) {
		// If the PC has logged out, skip this heartbeat.
		DelayCommand(6.0, _PersistACBonusFromSpell(oTarget, nSpellId, nACType, nACBonus, nLastACBonus, fDurationRemaining - 6.0, eLinkedEffects, bIsPC));
		return;
	}
	
	int nSource = ACR_EFFECT_SOURCE_SPELL_OFFSET + nSpellId;

	if(CountTrackingEffectsFor(oTarget, nSource)) {
		// Spell is still active. See if we need to change the AC effects.
		int nNeededACBonus = _GetPersistentACBonusTarget(oTarget, nACType, nACBonus);
		if(nNeededACBonus != nLastACBonus) {
			// Change AC effects.
			RemoveAllEffectsFromSource(oTarget, nSource);
			_AddPersistentACBonusEffects(oTarget, nSpellId, nACType, nNeededACBonus, fDurationRemaining, eLinkedEffects);
		}
		if(fDurationRemaining > 0.0)
			DelayCommand(6.0, _PersistACBonusFromSpell(oTarget, nSpellId, nACType, nACBonus, nNeededACBonus, fDurationRemaining - 6.0, eLinkedEffects, bIsPC));
	}
}

void PersistACBonusFromSpell(object oTarget, int nSpellId, int nACType, int nACBonus, float fDurationRemaining, effect eLinkedEffects) {
	SetEffectSpellId(eLinkedEffects, nSpellId);
	int nTarget = _GetPersistentACBonusTarget(oTarget, nACType, nACBonus);
	_AddPersistentACBonusEffects(oTarget, nSpellId, nACType, nTarget, fDurationRemaining, eLinkedEffects);
	DelayCommand(6.0, _PersistACBonusFromSpell(oTarget, nSpellId, nACType, nACBonus, nTarget, fDurationRemaining - 6.0, eLinkedEffects, GetIsPC(oTarget) && !GetIsDMPossessed(oTarget)));
}


int ACR_ScrollUse(object oUser, object oScroll, int nSpellID) {

   int nResultType = _DetermineScrollAttempt(oUser, nSpellID);
   
   if ( nResultType < 0) {
       // then there was a mishap. do not run the spell script, the scroll is consumed.
	   SetModuleOverrideSpellScriptFinished();
	   return FALSE;
	
   } else if (nResultType == 0) {
   	   // the user failed to activate the scroll, replace it and end.
       SetPlotFlag(oScroll, TRUE);
	   DelayCommand(2.0, SetPlotFlag(oScroll, FALSE));
	   SetModuleOverrideSpellScriptFinished();
       return FALSE;
   } 
   // otherwise, scroll use was successful.
return TRUE;
}

////////////////////////////////////////////////////////////////////////////////
// *** BEGIN PRIVATE FUNCTIONS ***
////////////////////////////////////////////////////////////////////////////////

int _DetermineScrollAttempt(object oCaster, int nScrollID) {
   
    int nSpellClass = 0;
	int nSpellDiff = 99;
	int nTestDiff = 99;
	int nSpellLevel = 99;
	int nTestSpellLevel = 99;
	int bAttributeFail = FALSE;
	int bHasUMD = FALSE;
	int nUMDRanks = GetSkillRank(SKILL_USE_MAGIC_DEVICE, oCaster);
	// track how good our class/level combo is: 0 - nothing
	//   1 - need to use UMD for class /and/ an attribute UMD check
	//   2 - class is OK, but attribute is too low, UMD check to simulate it
	//   3 - need to use UMD for class (attribute OK)
	//   4 - valid caster class and stat
	int nAttemptLevel = 0;
	string sTest = "default";
	string sClass = "";
	
	// need to know if the PC has Use Magic Device skill, so it can be used if needed.
	if (GetSkillRank(SKILL_USE_MAGIC_DEVICE, oCaster, TRUE) >=1) {
	    bHasUMD = TRUE;
	}
	// start with checking for bard levels
	int nPCCasterLevel = ACR_GetCorrectCasterLevel(oCaster, CLASS_TYPE_BARD);
	if ((nPCCasterLevel > 0) || bHasUMD) {
	    sTest = Get2DAString("spells", "Bard", nScrollID);
		// check to see if it is on the bard list
        if (sTest != "") {	
	        nTestSpellLevel = StringToInt(sTest);
		    //SendMessageToPC(oCaster, "Bard scroll- level "+sTest);
			nSpellClass = CLASS_TYPE_BARD;
			nSpellLevel = nTestSpellLevel;
			sClass = "Bard";
			//SendMessageToPC(oCaster, "Bard scroll- level "+sTest);
		    if (GetAbilityScore(oCaster, ABILITY_CHARISMA) >= (nSpellLevel + 10)) {
		        // caster has high enough attribute, calculate difficulty
				nSpellDiff = _ScrollCastDiff(CLASS_TYPE_BARD, nPCCasterLevel, nSpellLevel);
				if (nPCCasterLevel == 0) {
				    // need the UMD check, for this, but stat is OK
					nAttemptLevel = 3;
				} else {
				    nAttemptLevel = 4;
				}
			} else {
			    bAttributeFail = TRUE;
				if (bHasUMD) {
				    // if the PC had UMD, the attribute failure isn't final.  Track info.
					nSpellDiff = _ScrollCastDiff(CLASS_TYPE_BARD, nPCCasterLevel, nSpellLevel);
				    if (nPCCasterLevel == 0) {
				        // doesn't qualify by attribute or class
					    nAttemptLevel = 1;
					} else {
					    // has the class, but not the attribute
					    nAttemptLevel = 2;
					}						
				}
			}
		}
	}
	// check cleric levels next
	nPCCasterLevel = ACR_GetCorrectCasterLevel(oCaster, CLASS_TYPE_CLERIC);
	if ((nPCCasterLevel > 0) || bHasUMD) {
	    // is the spell on the cleric spell list?
	    sTest = Get2DAString("spells", "Cleric", nScrollID);
        if (sTest != "") {	
	        nTestSpellLevel = StringToInt(sTest);
		    //SendMessageToPC(oCaster, "Cleric scroll- level "+sTest);
		    if (GetAbilityScore(oCaster, ABILITY_WISDOM) >= (nTestSpellLevel + 10)) {
		        // caster has high enough attribute
				// now, need to decide if we are better off using cleric or bard levels.
				nTestDiff = _ScrollCastDiff(CLASS_TYPE_CLERIC, nPCCasterLevel, nTestSpellLevel);
				if ((nPCCasterLevel == 0) && (nAttemptLevel < 4)) {
				    if (ACR_GetMinSpellCL(nTestSpellLevel, CLASS_TYPE_CLERIC) < ACR_GetMinSpellCL(nSpellLevel, nSpellClass)) {
				        nSpellLevel = nTestSpellLevel;
				        nSpellClass = CLASS_TYPE_CLERIC;
					    sClass = "Cleric";
					    nSpellDiff = nTestDiff;
					    bAttributeFail = FALSE;	
					    nAttemptLevel = 3;
					}
				} else if (nTestDiff < nSpellDiff) {
				    // cleric levels have a better chance to activate.
				    nSpellLevel = nTestSpellLevel;
				    nSpellClass = CLASS_TYPE_CLERIC;
					sClass = "Cleric";
					nSpellDiff = nTestDiff;
					bAttributeFail = FALSE;
					nAttemptLevel = 4;
				}
			} else if ((nAttemptLevel <= 1) && bHasUMD) {
			    // if nAttemptLevel is not set yet, or requires both checks, then
				// we need to consider this class as an alternative.
				if ((nTestSpellLevel < nSpellLevel) && (nPCCasterLevel == 0)) {
				    // PC will need a UMD class check, and an attribute check, but this class is more favorable.
					nSpellLevel = nTestSpellLevel;
					nSpellClass = CLASS_TYPE_CLERIC;
					sClass = "Cleric";
					nSpellDiff = nTestDiff;
					bAttributeFail = TRUE;
					nAttemptLevel = 1;
				}
			} else if ((nAttemptLevel <= 2) && bHasUMD) {
				// The PC has the class, but needs the attribute.  Use this class if it's better than the alternative.
				if ((nTestSpellLevel < nSpellLevel) && (nPCCasterLevel == 0)) {
				    // PC will need a UMD class check, and an attribute check, but this class is more favorable.
					nSpellLevel = nTestSpellLevel;
					nSpellClass = CLASS_TYPE_CLERIC;
					sClass = "Cleric";
					nSpellDiff = nTestDiff;
					bAttributeFail = TRUE;
					nAttemptLevel = 2;
				}
					
			} else if (nAttemptLevel == 0) {
			    bAttributeFail = TRUE;
			}
		}	
	}
	// next, check for druid levels.
	nPCCasterLevel = ACR_GetCorrectCasterLevel(oCaster, CLASS_TYPE_DRUID);
	if ((nPCCasterLevel > 0) || bHasUMD) {
	    sTest = Get2DAString("spells", "Druid", nScrollID);
		// spell on the druid list?
        if (sTest != "") {	
	        nTestSpellLevel = StringToInt(sTest);
		    //SendMessageToPC(oCaster, "Druid scroll- level "+sTest);
		    if (GetAbilityScore(oCaster, ABILITY_WISDOM) >= (nTestSpellLevel + 10)) {
		        // caster has high enough attribute
				// now, need to decide if we are better off using cleric or bard levels.
				nTestDiff = _ScrollCastDiff(CLASS_TYPE_DRUID, nPCCasterLevel, nTestSpellLevel);
				if ((nPCCasterLevel == 0) && (nAttemptLevel < 4)) {
				    if (ACR_GetMinSpellCL(nTestSpellLevel, CLASS_TYPE_DRUID) < ACR_GetMinSpellCL(nSpellLevel, nSpellClass)) {
					    nSpellLevel = nTestSpellLevel;
				        nSpellClass = CLASS_TYPE_DRUID;
					    sClass = "Druid";
					    nSpellDiff = nTestDiff;
					    bAttributeFail = FALSE;
						nAttemptLevel = 3;
					}
				} else if (nTestDiff < nSpellDiff) {
				    // then we're better off using druid levels to activate.
				    nSpellLevel = nTestSpellLevel;
				    nSpellClass = CLASS_TYPE_DRUID;
					sClass = "Druid";
					nSpellDiff = nTestDiff;
					bAttributeFail = FALSE;
					nAttemptLevel = 4;
				}
			} else if ((nAttemptLevel <= 1) && bHasUMD) {
			    // if nAttemptLevel is not set yet, or requires both checks, then
				// we need to consider this class as an alternative.
				if ((nTestSpellLevel < nSpellLevel) && (nPCCasterLevel == 0)) {
				    // PC will need a UMD class check, and an attribute check, but this class is more favorable.
					nSpellLevel = nTestSpellLevel;
					nSpellClass = CLASS_TYPE_DRUID;
					sClass = "Druid";
					nSpellDiff = nTestDiff;
					bAttributeFail = TRUE;
					nAttemptLevel = 1;
				}
			} else if ((nAttemptLevel <= 2) && bHasUMD) {
				// The PC has the class, but needs the attribute.  Use this class if it's better than the alternative.
				if ((nTestSpellLevel < nSpellLevel) && (nPCCasterLevel == 0)) {
				    // PC will need a UMD class check, and an attribute check, but this class is more favorable.
					nSpellLevel = nTestSpellLevel;
					nSpellClass = CLASS_TYPE_DRUID;
					sClass = "Druid";
					nSpellDiff = nTestDiff;
					bAttributeFail = TRUE;
					nAttemptLevel = 2;
				}
			} else if (nAttemptLevel == 0) {
				//  only count this as an attribute fail if no other class works. 
			    bAttributeFail = TRUE;
			}
		}
	}
	// now checking Paladin levels.
	nPCCasterLevel = ACR_GetCorrectCasterLevel(oCaster, CLASS_TYPE_PALADIN);
	// Paladins  only cast from 4th onward, but still have CL 0 for scrolls.
	if ((nPCCasterLevel > 0) || bHasUMD) {
	    sTest = Get2DAString("spells", "Paladin", nScrollID);
        if (sTest != "") {	
	        nTestSpellLevel = StringToInt(sTest);
		    //SendMessageToPC(oCaster, "Paladin scroll- level "+sTest);
		    if (GetAbilityScore(oCaster, ABILITY_WISDOM) >= (nTestSpellLevel + 10)) {
		        // caster has high enough attribute
				nTestDiff = _ScrollCastDiff(CLASS_TYPE_PALADIN, nPCCasterLevel, nTestSpellLevel);
				if (nPCCasterLevel == 0) {
				    if ((ACR_GetMinSpellCL(nTestSpellLevel, CLASS_TYPE_PALADIN) < ACR_GetMinSpellCL(nSpellLevel, nSpellClass)) && (nAttemptLevel < 4)) {
					    nSpellLevel = nTestSpellLevel;
				        nSpellClass = CLASS_TYPE_PALADIN;
					    sClass = "Paladin";
					    nSpellDiff = nTestDiff;
					    bAttributeFail = FALSE;
						nAttemptLevel = 3;
					}
				} else if (nTestDiff < nSpellDiff) {
				    // then we're better off using paladin levels to activate.
				    nSpellLevel = nTestSpellLevel;
				    nSpellClass = CLASS_TYPE_PALADIN;
					sClass = "Paladin";
					nSpellDiff = nTestDiff;
					bAttributeFail = FALSE;
					nAttemptLevel = 4;
				}
			} else if ((nAttemptLevel <= 1) && bHasUMD) {
			    // if nAttemptLevel is not set yet, or requires both checks, then
				// we need to consider this class as an alternative.
				if ((nTestSpellLevel < nSpellLevel) && (nPCCasterLevel == 0)) {
				    // PC will need a UMD class check, and an attribute check, but this class is more favorable.
					nSpellLevel = nTestSpellLevel;
					nSpellClass = CLASS_TYPE_PALADIN;
					sClass = "Paladin";
					nSpellDiff = nTestDiff;
					bAttributeFail = TRUE;
					nAttemptLevel = 1;
				}
			} else if ((nAttemptLevel <= 2) && bHasUMD) {
				// The PC has the class, but needs the attribute.  Use this class if it's better than the alternative.
				if ((nTestSpellLevel < nSpellLevel) && (nPCCasterLevel == 0)) {
				    // PC will need a UMD class check, and an attribute check, but this class is more favorable.
					nSpellLevel = nTestSpellLevel;
					nSpellClass = CLASS_TYPE_PALADIN;
					sClass = "Paladin";
					nSpellDiff = nTestDiff;
					bAttributeFail = TRUE;
					nAttemptLevel = 2;
				}
			} else if (nAttemptLevel == 0) {
				//  only count this as an attribute fail if no other class works. 
			    bAttributeFail = TRUE;
			}
		}
	}
	// check for ranger levels.
	nPCCasterLevel = ACR_GetCorrectCasterLevel(oCaster, CLASS_TYPE_RANGER);
	// Rangers only cast from 4th onward, but still have CL 0 for scrolls.
	if ((nPCCasterLevel > 0) || bHasUMD) {
	    sTest = Get2DAString("spells", "Ranger", nScrollID);
        if (sTest != "") {	
	        nTestSpellLevel = StringToInt(sTest);
		    //SendMessageToPC(oCaster, "Ranger scroll- level "+sTest);
		    if (GetAbilityScore(oCaster, ABILITY_WISDOM) >= (nTestSpellLevel + 10)) {
		        // caster has high enough attribute
				nTestDiff = _ScrollCastDiff(CLASS_TYPE_RANGER, nPCCasterLevel, nTestSpellLevel);
				if (nPCCasterLevel == 0) {
				    if ((ACR_GetMinSpellCL(nTestSpellLevel, CLASS_TYPE_RANGER) < ACR_GetMinSpellCL(nSpellLevel, nSpellClass)) && (nAttemptLevel < 4)) {
					    nSpellLevel = nTestSpellLevel;
				        nSpellClass = CLASS_TYPE_RANGER;
					    sClass = "Ranger";
					    nSpellDiff = nTestDiff;
					    bAttributeFail = FALSE;
						nAttemptLevel = 3;
					}
				} else if (nTestDiff < nSpellDiff) {
				    // then we are better off casting as a ranger.
				    nSpellLevel = nTestSpellLevel;
				    nSpellClass = CLASS_TYPE_RANGER;
					sClass = "Ranger";
					nSpellDiff = nTestDiff;
					bAttributeFail = FALSE;
				    nAttemptLevel = 4;
				}
			} else if ((nAttemptLevel <= 1) && bHasUMD) {
			    // if nAttemptLevel is not set yet, or requires both checks, then
				// we need to consider this class as an alternative.
				if ((nTestSpellLevel < nSpellLevel) && (nPCCasterLevel == 0)) {
				    // PC will need a UMD class check, and an attribute check, but this class is more favorable.
					nSpellLevel = nTestSpellLevel;
					nSpellClass = CLASS_TYPE_RANGER;
					sClass = "Ranger";
					nSpellDiff = nTestDiff;
					bAttributeFail = TRUE;
					nAttemptLevel = 1;
				}
			} else if ((nAttemptLevel <= 2) && bHasUMD) {
				// The PC has the class, but needs the attribute.  Use this class if it's better than the alternative.
				if ((nTestSpellLevel < nSpellLevel) && (nPCCasterLevel == 0)) {
				    // PC will need a UMD class check, and an attribute check, but this class is more favorable.
					nSpellLevel = nTestSpellLevel;
					nSpellClass = CLASS_TYPE_RANGER;
					sClass = "Ranger";
					nSpellDiff = nTestDiff;
					bAttributeFail = TRUE;
					nAttemptLevel = 2;
				}
			} else if (nAttemptLevel == 0) {
				//  only count this as an attribute fail if no other class works. 
			    bAttributeFail = TRUE;
			}
		}
	}
	// check Wizard levels next
	nPCCasterLevel = ACR_GetCorrectCasterLevel(oCaster, CLASS_TYPE_WIZARD);
	if ((nPCCasterLevel > 0) || bHasUMD) {
	    // is the spell on the wizard spell list?
	    sTest = Get2DAString("Spells", "Wiz_Sorc", nScrollID);
        if (sTest != "") {	
	        nTestSpellLevel = StringToInt(sTest);
		    //SendMessageToPC(oCaster, "Wizard scroll- level "+sTest);
		    if (GetAbilityScore(oCaster, ABILITY_INTELLIGENCE) >= (nTestSpellLevel + 10)) {
		        // caster has high enough attribute
				// now, need to decide if we are better off using cleric or bard levels.
				nTestDiff = _ScrollCastDiff(CLASS_TYPE_WIZARD, nPCCasterLevel, nTestSpellLevel);
				if (nPCCasterLevel == 0) {
				    if ((ACR_GetMinSpellCL(nTestSpellLevel, CLASS_TYPE_WIZARD) < ACR_GetMinSpellCL(nSpellLevel, nSpellClass)) && (nAttemptLevel < 4)) {
					    nSpellLevel = nTestSpellLevel;
				        nSpellClass = CLASS_TYPE_WIZARD;
					    sClass = "Wizard";
					    nSpellDiff = nTestDiff;
					    bAttributeFail = FALSE;
						nAttemptLevel = 3;
					}
				} else if (nTestDiff < nSpellDiff) {
				    // cleric levels have a better chance to activate.
				    nSpellLevel = nTestSpellLevel;
				    nSpellClass = CLASS_TYPE_WIZARD;
					sClass = "Wizard";
					nSpellDiff = nTestDiff;
					bAttributeFail = FALSE;
 					nAttemptLevel = 4;
				}
			} else if ((nAttemptLevel <= 1) && bHasUMD) {
			    // if nAttemptLevel is not set yet, or requires both checks, then
				// we need to consider this class as an alternative.
				if ((nTestSpellLevel < nSpellLevel) && (nPCCasterLevel == 0)) {
				    // PC will need a UMD class check, and an attribute check, but this class is more favorable.
					nSpellLevel = nTestSpellLevel;
					nSpellClass = CLASS_TYPE_WIZARD;
					sClass = "Wizard";
					nSpellDiff = nTestDiff;
					bAttributeFail = TRUE;
					nAttemptLevel = 1;
				}
			} else if ((nAttemptLevel <= 2) && bHasUMD) {
				// The PC has the class, but needs the attribute.  Use this class if it's better than the alternative.
				if ((nTestSpellLevel < nSpellLevel) && (nPCCasterLevel == 0)) {
				    // PC will need a UMD class check, and an attribute check, but this class is more favorable.
					nSpellLevel = nTestSpellLevel;
					nSpellClass = CLASS_TYPE_WIZARD;
					sClass = "Wizard";
					nSpellDiff = nTestDiff;
					bAttributeFail = TRUE;
					nAttemptLevel = 2;
				}
			} else if (nAttemptLevel == 0) {
				//  only count this as an attribute fail if no other class works. 
			    bAttributeFail = TRUE;
			}
		}	
	}
	// check spirit shaman levels
	// -Spirit shamans draw from the druid list, using wisdom- so most UMD cases are better
	//   done via druid class simulation, as it has a faster progression.
	//   only UMD check I forsee here is a SS using a scroll they don't have the attribute for.
	nPCCasterLevel = ACR_GetCorrectCasterLevel(oCaster, CLASS_TYPE_SPIRIT_SHAMAN);
	if (nPCCasterLevel > 0) {
	    // is the spell on the cleric spell list?
	    sTest = Get2DAString("spells", "Druid", nScrollID);
        if (sTest != "") {	
	        nTestSpellLevel = StringToInt(sTest);
		    //SendMessageToPC(oCaster, "Spirit Shaman scroll- level "+sTest);
		    if (GetAbilityScore(oCaster, ABILITY_WISDOM) >= (nTestSpellLevel + 10)) {
		        // caster has high enough attribute
				// now, need to decide if we are better off using cleric or bard levels.
				nTestDiff = _ScrollCastDiff(CLASS_TYPE_SPIRIT_SHAMAN, nPCCasterLevel, nTestSpellLevel);
				if (nPCCasterLevel == 0) {
				    if ((ACR_GetMinSpellCL(nTestSpellLevel, CLASS_TYPE_SPIRIT_SHAMAN) < ACR_GetMinSpellCL(nSpellLevel, nSpellClass)) && (nAttemptLevel < 4)) {
					    nSpellLevel = nTestSpellLevel;
				        nSpellClass = CLASS_TYPE_SPIRIT_SHAMAN;
					    sClass = "Spitit Shaman";
					    nSpellDiff = nTestDiff;
					    bAttributeFail = FALSE;
						nAttemptLevel = 3;
					}
				} else if (nTestDiff < nSpellDiff) {
				    // cleric levels have a better chance to activate.
				    nSpellLevel = nTestSpellLevel;
				    nSpellClass = CLASS_TYPE_SPIRIT_SHAMAN;
					sClass = "Spirit Shaman";
					nSpellDiff = nTestDiff;
					bAttributeFail = FALSE;
				}
			} else if ((nAttemptLevel <= 2) && bHasUMD) {
				// The PC has the class, but needs the attribute.  Use this class if it's better than the alternative.
				if ((nTestSpellLevel < nSpellLevel) && (nPCCasterLevel == 0)) {
				    // PC will need a UMD class check, and an attribute check, but this class is more favorable.
					nSpellLevel = nTestSpellLevel;
					nSpellClass = CLASS_TYPE_SPIRIT_SHAMAN;
					sClass = "Spirit Shaman";
					nSpellDiff = nTestDiff;
					bAttributeFail = TRUE;
					nAttemptLevel = 2;
				}
			} else if (nAttemptLevel == 0) {
				//  only count this as an attribute fail if no other class works. 
			    bAttributeFail = TRUE;
			}
		}	
	}
	// check Favored Soul levels next
	//  Favored Souls draw from the cleric spell list, but by Charisma- so a high CHA, low 
	//   WIS UMD user is almost always going to be be better off emulating a FS.
	nPCCasterLevel = ACR_GetCorrectCasterLevel(oCaster, CLASS_TYPE_FAVORED_SOUL);
	if ((nPCCasterLevel > 0) || bHasUMD) {
	    // is the spell on the cleric spell list?
	    sTest = Get2DAString("spells", "Cleric", nScrollID);
        if (sTest != "") {	
	        nTestSpellLevel = StringToInt(sTest);
		    //SendMessageToPC(oCaster, "Favored Soul scroll- level "+sTest);
		    if (GetAbilityScore(oCaster, ABILITY_CHARISMA) >= (nTestSpellLevel + 10)) {
		        // caster has high enough attribute
				// now, need to decide if we are better off using cleric or bard levels.
				nTestDiff = _ScrollCastDiff(CLASS_TYPE_FAVORED_SOUL, nPCCasterLevel, nTestSpellLevel);
				if (nPCCasterLevel == 0) {
				    if ((ACR_GetMinSpellCL(nTestSpellLevel, CLASS_TYPE_FAVORED_SOUL) < ACR_GetMinSpellCL(nSpellLevel, nSpellClass)) && (nAttemptLevel < 4)) {
					    nSpellLevel = nTestSpellLevel;
				        nSpellClass = CLASS_TYPE_FAVORED_SOUL;
					    sClass = "Favored Soul";
					    nSpellDiff = nTestDiff;
					    bAttributeFail = FALSE;
						nAttemptLevel = 3;
					}
				} else if (nTestDiff < nSpellDiff) {
				    // cleric levels have a better chance to activate.
				    nSpellLevel = nTestSpellLevel;
				    nSpellClass = CLASS_TYPE_FAVORED_SOUL;
					sClass = "Favored Soul";
					nSpellDiff = nTestDiff;
					bAttributeFail = FALSE;
					nAttemptLevel = 4;
				}
			} else if ((nAttemptLevel <= 1) && bHasUMD) {
			    // if nAttemptLevel is not set yet, or requires both checks, then
				// we need to consider this class as an alternative.
				if ((nTestSpellLevel < nSpellLevel) && (nPCCasterLevel == 0)) {
				    // PC will need a UMD class check, and an attribute check, but this class is more favorable.
					nSpellLevel = nTestSpellLevel;
					nSpellClass = CLASS_TYPE_FAVORED_SOUL;
					sClass = "Favored Soul";
					nSpellDiff = nTestDiff;
					bAttributeFail = TRUE;
					nAttemptLevel = 1;
				}
			} else if ((nAttemptLevel <= 2) && bHasUMD) {
				// The PC has the class, but needs the attribute.  Use this class if it's better than the alternative.
				if ((nTestSpellLevel < nSpellLevel) && (nPCCasterLevel == 0)) {
				    // PC will need a UMD class check, and an attribute check, but this class is more favorable.
					nSpellLevel = nTestSpellLevel;
					nSpellClass = CLASS_TYPE_FAVORED_SOUL;
					sClass = "Favored Soul";
					nSpellDiff = nTestDiff;
					bAttributeFail = TRUE;
					nAttemptLevel = 2;
				}
			} else if (nAttemptLevel == 0) {
				//  only count this as an attribute fail if no other class works. 
			    bAttributeFail = TRUE;
			}
		}	
	}
	// finally, check sorceror levels
	//  Wiz spell list, but uses CHA as the stat, so higher CHA UMD users will want to test.
	nPCCasterLevel = ACR_GetCorrectCasterLevel(oCaster, CLASS_TYPE_SORCERER);
	if (nPCCasterLevel > 0) {
	    // is the spell on the cleric spell list?
	    sTest = Get2DAString("spells", "Wiz_Sorc", nScrollID);
        if (sTest != "") {	
	        nTestSpellLevel = StringToInt(sTest);
		    //SendMessageToPC(oCaster, "Sorceror scroll- level "+sTest);
		    if (GetAbilityScore(oCaster, ABILITY_CHARISMA) >= (nTestSpellLevel + 10)) {
		        // caster has high enough attribute
				// now, need to decide if we are better off using cleric or bard levels.
				nTestDiff = _ScrollCastDiff(CLASS_TYPE_SORCERER, nPCCasterLevel, nTestSpellLevel);
				if (nPCCasterLevel == 0) {
				    if ((ACR_GetMinSpellCL(nTestSpellLevel, CLASS_TYPE_SORCERER) < ACR_GetMinSpellCL(nSpellLevel, nSpellClass)) && (nAttemptLevel < 4))  {
					    nSpellLevel = nTestSpellLevel;
				        nSpellClass = CLASS_TYPE_SORCERER;
					    sClass = "Sorcerer";
					    nSpellDiff = nTestDiff;
					    bAttributeFail = FALSE;
						nAttemptLevel = 3;
					}
				} else if (nTestDiff < nSpellDiff) {
				    // cleric levels have a better chance to activate.
				    nSpellLevel = nTestSpellLevel;
				    nSpellClass = CLASS_TYPE_SORCERER;
					sClass = "Sorcerer";
					nSpellDiff = nTestDiff;
					bAttributeFail = FALSE;
					nAttemptLevel = 4;
				}
			} else if ((nAttemptLevel <= 1) && bHasUMD) {
			    // if nAttemptLevel is not set yet, or requires both checks, then
				// we need to consider this class as an alternative.
				if ((nTestSpellLevel < nSpellLevel) && (nPCCasterLevel == 0)) {
				    // PC will need a UMD class check, and an attribute check, but this class is more favorable.
					nSpellLevel = nTestSpellLevel;
					nSpellClass = CLASS_TYPE_SORCERER;
					sClass = "Sorcerer";
					nSpellDiff = nTestDiff;
					bAttributeFail = TRUE;
					nAttemptLevel = 1;
				}
			} else if ((nAttemptLevel <= 2) && bHasUMD) {
				// The PC has the class, but needs the attribute.  Use this class if it's better than the alternative.
				if ((nTestSpellLevel < nSpellLevel) && (nPCCasterLevel == 0)) {
				    // PC will need a UMD class check, and an attribute check, but this class is more favorable.
					nSpellLevel = nTestSpellLevel;
					nSpellClass = CLASS_TYPE_SORCERER;
					sClass = "Sorcerer";
					nSpellDiff = nTestDiff;
					bAttributeFail = TRUE;
					nAttemptLevel = 2;
				}
			} else if (nAttemptLevel == 0) {
				//  only count this as an attribute fail if no other class works. 
			    bAttributeFail = TRUE;
			}
		}	
	}
	if (bAttributeFail) {
	    if (bHasUMD) {
		    // PC doesn't qualify to cast the spell by any possessed or simulated classes.
			//  They are allowed an attempt to simulate the required attribute.
			int nAttributeDC = 15 + 10 + nSpellLevel;
			int nRoll = d20(1);
			if (GetSkillRank(SKILL_SPELLCRAFT, oCaster, TRUE) >= 5) {
		        // synergy bonus for scroll use
			    nAttributeDC = nAttributeDC - 2;
			    SendMessageToPC(oCaster, "Spellcraft Synergy Applied: DC reduced to "+IntToString(nAttributeDC));
		    }
			if (GetSkillRank(SKILL_DECIPHER_SCRIPT, oCaster, TRUE) >= 5) {
		        // synergy bonus for scroll use
			    nAttributeDC = nAttributeDC - 2;
			    SendMessageToPC(oCaster, "Decipher Script Synergy Applied: DC reduced to "+IntToString(nAttributeDC));
		    }
			if ((nRoll + nUMDRanks) >= nAttributeDC) {
				// don't return here, even though it's successful- caster level check and/or UMD class check may still be needed.
			    SendMessageToPC(oCaster, "Use Magic Device Roll to emulate ability score: "+IntToString(nRoll)+"+"+IntToString(nUMDRanks)+"="+IntToString(nRoll+nUMDRanks)+" vs. DC "+IntToString(nAttributeDC)+": Success!");
				bAttributeFail = FALSE;
			} else {
			    SendMessageToPC(oCaster, "Use Magic Device Roll to emulate ability score: "+IntToString(nRoll)+"+"+IntToString(nUMDRanks)+"="+IntToString(nRoll+nUMDRanks)+" vs. DC "+IntToString(nAttributeDC)+": Failure!");
			    return 0;
			}
		} else {
		    // without UMD, the attempt will fail.
	        SendMessageToPC(oCaster, "Your attributes are not high enough to activate this scroll.");
		    return 0;
		}
	}
	
	if (nSpellDiff <= 1) {
	    // the user can activate the scroll without a check, due to level and attributes.
		return 1;	
		
	} else if (nAttemptLevel == 0) {
	    // no class was found to allow you to activate, fail.
		SendMessageToPC(oCaster, "You cannot activate this scroll.");
		return 0;	
		
	} else if ((GetLevelByClass(nSpellClass, oCaster) == 0) && bHasUMD) {
	    // caster does not have appropriate levels to attempt the spell, must make UMD check.
        int nUMDDC = 20 + _ScrollCastDiff(nSpellClass, 0, nSpellLevel) - 1;
		int nRoll2 = d20(1);
		SendMessageToPC(oCaster, "Attempting to activate by emulating a "+sClass);
		if (GetSkillRank(SKILL_SPELLCRAFT, oCaster, TRUE) >= 5) {
		    // synergy bonus for scroll use
			nUMDDC = nUMDDC - 2;
			SendMessageToPC(oCaster, "Spellcraft Synergy Applied: DC reduced to "+IntToString(nUMDDC));
		}
		if (GetSkillRank(SKILL_DECIPHER_SCRIPT, oCaster, TRUE) >= 5) {
		    // synergy bonus for scroll use
			nUMDDC = nUMDDC - 2;
			SendMessageToPC(oCaster, "Decipher Script Synergy Applied: DC reduced to "+IntToString(nUMDDC));
		}
		if ((nRoll2 + nUMDRanks) >= nUMDDC) {
		    SendMessageToPC(oCaster, "Use Magic Device Roll to activate scroll: "+IntToString(nRoll2)+"+"+IntToString(nUMDRanks)+"="+IntToString(nRoll2+nUMDRanks)+" vs. DC "+IntToString(nUMDDC)+": Success!");
			return 1;
		} else if ((nRoll2+ nUMDRanks) <= (nUMDDC-10)) {
		    // missed it by a mile, auto-mishap as per PhB p.85
			SendMessageToPC(oCaster, "Use Magic Device Roll to activate scroll: "+IntToString(nRoll2)+"+"+IntToString(nUMDRanks)+"="+IntToString(nRoll2+nUMDRanks)+" vs. DC "+IntToString(nUMDDC)+": Critical Failure!");
			_ProcessMishap(oCaster, nSpellLevel, nScrollID);
			return -1;
		} else {
		    SendMessageToPC(oCaster, "Use Magic Device Roll to activate scroll: "+IntToString(nRoll2)+"+"+IntToString(nUMDRanks)+"="+IntToString(nRoll2+nUMDRanks)+" vs. DC "+IntToString(nUMDDC)+": Failure!");
			if (_ScrollMishapCheck(oCaster, nScrollID, nSpellLevel, nScrollID)) {
                return -1;
		    } else { 
		        return 0; 
		    }
		}
	} else {
	    // have to run a caster level check, with chance of failure.
		SendMessageToPC(oCaster, "Attempting to activate scroll using "+sClass+" level(s)."); 
		return _AttemptScrollUse(nScrollID, nSpellLevel, oCaster, nSpellClass);
	}
}

int _ScrollCastDiff(int nClass, int nUserLevel, int nSpellLevel) {

	if (nSpellLevel == 0) {
		// special handling for 0th level spells, as they don't work well for the math.
		if (nUserLevel >= 1) {
			// Caster has the right class, return <=1
			return 0;
		} else {
			// Caster has no appropriate levels to cast it, return > 1.
			return 2;
		}
	}
    if (nClass == CLASS_TYPE_BARD) {
	    if (nSpellLevel < 3) {
		    return (nSpellLevel*2 - nUserLevel +1);
		} else {
		    return ((nSpellLevel*3 -2) - nUserLevel +1);
		}
	
	// clerics, druids, and wizards all gain spell level access at the same rate	
	} else if ((nClass == CLASS_TYPE_CLERIC) || (nClass == CLASS_TYPE_DRUID) || (nClass == CLASS_TYPE_WIZARD))  { 
	    return ((nSpellLevel*2 - 1) - nUserLevel +1);
	
	// sorcerors, spirit shamans, and favored souls all use a staggered spell level advancement	
	} else if ((nClass == CLASS_TYPE_SORCERER) || (nClass == CLASS_TYPE_FAVORED_SOUL) || (nClass == CLASS_TYPE_SPIRIT_SHAMAN)) {
	    if (nSpellLevel < 2) {
		    return (1 - nUserLevel +1);
		} else {
            return (nSpellLevel*2 - nUserLevel);
		}

	// Paladins and Rangers use the same delayed spell level table
	} else if ((nClass == CLASS_TYPE_PALADIN) || (nClass == CLASS_TYPE_RANGER)) {
	    if (nUserLevel < 4) { nUserLevel = 0; }
	    if (nSpellLevel < 3) {
		    return ((nSpellLevel*4 - nUserLevel+1)/2 +1);
		} else if (nSpellLevel == 3) {
		    return ((6 - nUserLevel/2));
		} else {
		    // spell is 4th level
		    return ((7 - nUserLevel/2)+1);
		} 
	} else {
	   return 99;
	}
}

int _AttemptScrollUse(int nScrollID, int nSpellLevel, object oCaster, int nSpellClass) {

    int nRoll = d20(1);
	if (nRoll == 1) {
	    SendMessageToPC(oCaster, "Caster Level check: Critical failure!");
		if (_ScrollMishapCheck(oCaster, nScrollID, nSpellLevel, nScrollID)) {
            return -1;
		} else { 
		    return 0; 
		}
	}
	int nScrollDC = 1 + ACR_GetMinSpellCL(nSpellLevel, nSpellClass);
	int nCL = ACR_GetCasterLevel(oCaster, nSpellClass);
	if (nRoll+nCL >= nScrollDC) {
        SendMessageToPC(oCaster, "Caster Level check: "+IntToString(nRoll)+"+"+IntToString(nCL)+"="+IntToString(nCL+nRoll)+" vs. DC "+IntToString(nScrollDC)+": Success! "); 
		return 1;
	} else {
	    SendMessageToPC(oCaster, "Caster Level check: "+IntToString(nRoll)+"+"+IntToString(nCL)+"="+IntToString(nCL+nRoll)+" vs. DC "+IntToString(nScrollDC)+": Failure! ");
		if (_ScrollMishapCheck(oCaster, nScrollID, nSpellLevel, nScrollID)) {
            return -1;
		} else { 
		    return 0; 
		}
	}
}

int _ScrollMishapCheck(object oCaster, int nScrollID, int nSpellLevel, int nSpellID) {
	
    int nCheck = d20(1);
	int nWisBonus = GetAbilityModifier(ABILITY_WISDOM, oCaster);
	int nTotal = nCheck + nWisBonus;
	SendMessageToPC(oCaster, "Rolling to avoid mishap: "+IntToString(nCheck)+"+"+IntToString(nWisBonus)+"= "+IntToString(nTotal)+", vs. DC 5");
	if ((nTotal < 5) || (nCheck == 1)) {
	    // Scroll mishap!
        _ProcessMishap(oCaster, nSpellLevel, nSpellID);
		return TRUE;
	} else {
	    SendMessageToPC(oCaster, "Mishap averted!");
	}
    return FALSE;
}


void _ProcessMishap(object oCaster, int nSpellLevel, int nSpellID) {

		SendMessageToPC(oCaster, "Failure! The spell goes awry...");
		int nMishapType = d4(1);
	    object oTarget = GetSpellTargetObject();
		effect eMishap;
		if (nMishapType == 1) {
		    // raw damage backfire, d6 / spell level magical damage to caster
		    eMishap = EffectDamage(d6(nSpellLevel), DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL, TRUE);
			eMishap = EffectLinkEffects(eMishap, EffectVisualEffect(VFX_IMP_MAGBLUE));
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eMishap, oCaster);
			
		} else if (nMishapType == 2) {
		    // target switch
			SendMessageToPC(oCaster, "The spell seems to have been misdirected!");
			if (oTarget == OBJECT_INVALID) {
			    // spell is aimed at a location, misdirect it
				vector vLoc = GetPositionFromLocation(GetSpellTargetLocation());
				vector vNew = Vector(vLoc.x+(ACR_RandomFloat(-12.0, 12.0)), vLoc.y+(ACR_RandomFloat(-12.0, 12.0)), vLoc.z);
				location lNew = Location(GetAreaFromLocation(GetSpellTargetLocation()), vNew, 0.0);
				AssignCommand(oCaster, ActionCastSpellAtLocation(nSpellID, lNew, METAMAGIC_NONE, TRUE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
			} else {
			    // spell was aimed at a creature or object- switch target
				if (GetIsEnemy(oTarget, oCaster)) {
				    // aiming for an enemy? Redirect to caster
				    AssignCommand(oCaster, ActionCastSpellAtObject(nSpellID, oCaster, METAMAGIC_NONE, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
				} else if (oTarget == oCaster) {
				    // caster aiming at him/herself?  Aim elsewhere.
					object oNewTarget = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, CREATURE_ALIVE_BOTH, oCaster, d6(1));
					AssignCommand(oCaster, ActionCastSpellAtObject(nSpellID, oNewTarget, METAMAGIC_NONE, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
				}	
			}
			
	    } else if (nMishapType == 3) {
		    // delayed effect
			int nDelay = d12(1);			
			SendMessageToPC(oCaster, "The spell seems to have no effect... for now.");
			DelayCommand(HoursToSeconds(nDelay), AssignCommand(oTarget, ActionCastSpellAtObject(nSpellID, oTarget, METAMAGIC_NONE, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE)));

		} else if (nMishapType <= 4) {
		    // innocuous effect, scroll user
			int nDuration = d10(2);
			switch (d10(1)) {
			    case 1:
			        eMishap = EffectVisualEffect(VFX_DUR_INVOCATION_TENACIOUS_PLAGUE);
					break;
				case 2:
				    eMishap = EffectVisualEffect(VFX_DUR_SHINING_SHIELD);
					break;
				case 3:
				    eMishap = EffectVisualEffect(VFX_DUR_SOOTHING_LIGHT);	
					break;
				case 4:
				    eMishap = EffectVisualEffect(VFX_DUR_SACRED_FLAMES);
					break;
				case 5:
				    eMishap = EffectVisualEffect(VFX_DUR_SHADOW_CLOAK);
					break;
				case 6:
				    eMishap = EffectVisualEffect(VFX_DUR_STUN);
					break;
				case 7:
				    eMishap = EffectVisualEffect(VFX_DUR_FIRE);
					break;
				case 8:
				    eMishap = EffectVisualEffect(VFX_INVOCATION_BRIMSTONE_CHAIN2);
					break;
				case 9:
				    eMishap = EffectVisualEffect(VFX_DUR_BLUR);
					break;
				default:
				    eMishap = EffectVisualEffect(VFX_INVOCATION_ELDRITCH_CHAIN);
					break;
			}
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eMishap, oCaster, (IntToFloat(nDuration)*8.57));
		}	

}

#endif