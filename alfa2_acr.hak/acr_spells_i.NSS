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

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "nw_i0_spells"
#include "x2_inc_spellhook"
#include "acr_i"
#include "acr_roll_i"
#include "acr_creature_i"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

const float ACR_DURATION_GLOBAL_SCALE = 1.0f;
const float ACR_DURATION_10M_SCALE = 1.0f;
const float ACR_DURATION_HOUR_SCALE = 7.0f / 60.0f;

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
float ACR_GetSpellDuration( object oCaster, int nDurationType, float nDurationBase );

int ACR_GetCorrectCasterLevel(object oCreature, int nClass = -1);

//! Sets if the currently casting spell is a domain spell or not.
void ACR_SetIsDomainSpell( int nDomain, int bValue );

void WarnWhenSpellExpires(object oCreature, int nSpellId, string sMessage, float fDuration);

void _floatMessageIfHasSpellEffect(object oCreature, int nSpellId, string sMessage, float fDuration);

//! ACR's version of nw_i0_spells spellCure function.
void ACR_SpellCure( object oTarget, int nDieCount, int nDieSides, int nMaxExtraDamage, int nSpellID, int vfxImpactHeal, int vfxImpactHarm );

//! ACR's version of x0_i0_spells spellsInflictTouchAttack function.
void ACR_SpellsInflictTouchAttack( object oTarget, int nDieCount, int nDieSides, int nMaxExtraDamage, int nSpellID, int vfxImpactHeal, int vfxImpactHarm );

//! ACR's version of nw_i0_spells spellsHealOrHarmTarget function.
void ACR_SpellsHealOrHarmTarget( object oTarget, int nDamageTotal, int vfx_impactNormalHurt, int vfx_impactUndeadHurt, int vfx_impactHeal, int nSpellID, int bIsHealingSpell=TRUE, int bHarmTouchAttack=TRUE );

//! ACR's version of nw_i0_spells GetCureDamageTotal. Handles changes to our feats.
int ACR_GetCureDamageTotal( object oTarget, int nDieCount, int nDieSides, int nMaxExtraDamage, int nSpellID );

string _GetDomainVarName( int nDomain );

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
	
	// Check for spell extension metamagics.
	if ( GetMetaMagicFeat() == METAMAGIC_EXTEND ) {
		nDuration = nDuration * 2;
	}
	
	// Apply global duration scaling.
	nDuration = nDuration * ACR_DURATION_GLOBAL_SCALE;
	
	return nDuration;
}

int _GetLevelIfHasFeat(int nClass, object oCreature, int nFeat) {
	return (GetHasFeat(nFeat, oCreature) != FALSE) * GetLevelByClass(nClass, oCreature);
}

int _GetPracticedSpellcasterCL(object oCreature, int nCasterLevel, int nFeat) {
	int nHd = GetHitDice(oCreature);
	return (GetHasFeat(nFeat, oCreature) != 0) * ((nCasterLevel + 4) > nHd) ? nHd : (nCasterLevel + 4);
}

int ACR_GetCorrectCasterLevel(object oCreature, int nClass = -1) {
	// If no class is provided, get the last caster class.
	if ( nClass == -1 ) nClass = GetLastSpellCastClass();

	int nCasterLevel;
	int nClassLevels = GetLevelByClass(nClass, oCreature);
	int nHd = GetHitDice(oCreature);
	
	if(GetHasFeat(FEAT_SPELL_POWER_5))
		nCasterLevel += 5;
	else if(GetHasFeat(FEAT_SPELL_POWER_4))
		nCasterLevel += 4;
	else if(GetHasFeat(FEAT_SPELL_POWER_3))
		nCasterLevel += 3;
	else if(GetHasFeat(FEAT_SPELL_POWER_2))
		nCasterLevel += 2;
	else if(GetHasFeat(FEAT_SPELL_POWER_1))
		nCasterLevel += 1;
	
	if(GetHasFeat(FEAT_SPELLCASTING_PRODIGY, oCreature))
		nCasterLevel++;
	
	switch(nClass) {
		
		case CLASS_TYPE_CLERIC:
			nCasterLevel += nClassLevels;
			nCasterLevel += _GetLevelIfHasFeat(CLASS_LOREMASTER, oCreature, FEAT_LOREMASTER_SPELLCASTING_CLERIC);
			nCasterLevel += _GetLevelIfHasFeat(CLASS_MYSTICTHEURGE, oCreature, FEAT_LOREMASTER_SPELLCASTING_CLERIC);
			nCasterLevel += _GetLevelIfHasFeat(CLASS_TYPE_WARPRIEST, oCreature, FEAT_LOREMASTER_SPELLCASTING_CLERIC) / 2;
			nCasterLevel += _GetLevelIfHasFeat(CLASS_TYPE_STORMLORD, oCreature, FEAT_LOREMASTER_SPELLCASTING_CLERIC);
			nCasterLevel += _GetLevelIfHasFeat(CLASS_TYPE_HARPER, oCreature, FEAT_LOREMASTER_SPELLCASTING_CLERIC) - 1;
			nCasterLevel += _GetLevelIfHasFeat(CLASS_TYPE_DOOMGUIDE, oCreature, FEAT_LOREMASTER_SPELLCASTING_CLERIC);
			nCasterLevel += (_GetLevelIfHasFeat(CLASS_TYPE_SACREDFIST, oCreature, FEAT_LOREMASTER_SPELLCASTING_CLERIC)+1) * 3 / 4;
			nCasterLevel = _GetPracticedSpellcasterCL(oCreature, nCasterLevel, FEAT_PRACTICED_SPELLCASTER_CLERIC);
			break;
			
		case CLASS_TYPE_DRUID:
			nCasterLevel += nClassLevels;
			nCasterLevel += _GetLevelIfHasFeat(CLASS_LOREMASTER, oCreature, FEAT_LOREMASTER_SPELLCASTING_DRUID);
			nCasterLevel += _GetLevelIfHasFeat(CLASS_MYSTICTHEURGE, oCreature, FEAT_MYSTICTHEURGE_SPELLCASTING_DRUID);
			nCasterLevel += _GetLevelIfHasFeat(CLASS_TYPE_WARPRIEST, oCreature, FEAT_WARPRIEST_SPELLCASTING_DRUID) / 2;
			nCasterLevel += _GetLevelIfHasFeat(CLASS_TYPE_STORMLORD, oCreature, FEAT_STORMLORD_SPELLCASTING_DRUID);
			nCasterLevel += _GetLevelIfHasFeat(CLASS_TYPE_HARPER, oCreature, FEAT_HARPER_SPELLCASTING_DRUID) - 1;
			nCasterLevel += _GetLevelIfHasFeat(CLASS_TYPE_DOOMGUIDE, oCreature, FEAT_DOOMGUIDE_DRUID_SPELLCASTING);
			nCasterLevel += (_GetLevelIfHasFeat(CLASS_TYPE_SACREDFIST, oCreature, FEAT_SACREDFIST_SPELLCASTING_DRUID)+1) * 3 / 4;
			nCasterLevel = _GetPracticedSpellcasterCL(oCreature, nCasterLevel, FEAT_PRACTICED_SPELLCASTER_DRUID);
			break;
			
		case CLASS_TYPE_FAVORED_SOUL:
			nCasterLevel += nClassLevels;
			nCasterLevel += _GetLevelIfHasFeat(CLASS_LOREMASTER, oCreature, FEAT_LOREMASTER_SPELLCASTING_FS);
			nCasterLevel += _GetLevelIfHasFeat(CLASS_MYSTICTHEURGE, oCreature, FEAT_MYSTICTHEURGE_SPELLCASTING_FS);
			nCasterLevel += _GetLevelIfHasFeat(CLASS_TYPE_WARPRIEST, oCreature, FEAT_WARPRIEST_SPELLCASTING_FAVORED_SOUL) / 2;
			nCasterLevel += _GetLevelIfHasFeat(CLASS_TYPE_STORMLORD, oCreature, FEAT_STORMLORD_SPELLCASTING_FAVORED_SOUL);
			nCasterLevel += _GetLevelIfHasFeat(CLASS_TYPE_HARPER, oCreature, FEAT_HARPER_SPELLCASTING_FAVORED_SOUL) - 1;
			nCasterLevel += _GetLevelIfHasFeat(CLASS_TYPE_DOOMGUIDE, oCreature, FEAT_DOOMGUIDE_FAVORED_SOUL_SPELLCASTING);
			nCasterLevel += (_GetLevelIfHasFeat(CLASS_TYPE_SACREDFIST, oCreature, FEAT_SACREDFIST_SPELLCASTING_FAVORED_SOUL)+1) * 3 / 4;
			nCasterLevel = _GetPracticedSpellcasterCL(oCreature, nCasterLevel, FEAT_PRACTICED_SPELLCASTER_FAVORED_SOUL);
			break;
				
		case CLASS_TYPE_SPIRIT_SHAMAN:
			nCasterLevel += nClassLevels;
			nCasterLevel += _GetLevelIfHasFeat(CLASS_LOREMASTER, oCreature, FEAT_LOREMASTER_SPELLCASTING_SS);
			nCasterLevel += _GetLevelIfHasFeat(CLASS_MYSTICTHEURGE, oCreature, FEAT_MYSTICTHEURGE_SPELLCASTING_SS);
			nCasterLevel += _GetLevelIfHasFeat(CLASS_TYPE_WARPRIEST, oCreature, FEAT_WARPRIEST_SPELLCASTING_SPIRIT_SHAMAN) / 2;
			nCasterLevel += _GetLevelIfHasFeat(CLASS_TYPE_STORMLORD, oCreature, FEAT_STORMLORD_SPELLCASTING_SPIRIT_SHAMAN);
			nCasterLevel += _GetLevelIfHasFeat(CLASS_TYPE_HARPER, oCreature, FEAT_HARPER_SPELLCASTING_SPIRIT_SHAMAN) - 1;
			nCasterLevel += _GetLevelIfHasFeat(CLASS_TYPE_DOOMGUIDE, oCreature, FEAT_DOOMGUIDE_SPIRIT_SHAMAN_SPELLCASTING);
			nCasterLevel += (_GetLevelIfHasFeat(CLASS_TYPE_SACREDFIST, oCreature, FEAT_SACREDFIST_SPELLCASTING_SPIRIT_SHAMAN)+1) * 3 / 4;
			nCasterLevel = _GetPracticedSpellcasterCL(oCreature, nCasterLevel, FEAT_PRACTICED_SPELLCASTER_SPIRIT_SHAMAN);
			break;
		
		case CLASS_TYPE_BARD:
			nCasterLevel += nClassLevels;
			nCasterLevel += _GetLevelIfHasFeat(CLASS_LOREMASTER, oCreature, FEAT_LOREMASTER_SPELLCASTING_BARD);
			nCasterLevel += _GetLevelIfHasFeat(CLASS_MYSTICTHEURGE, oCreature, FEAT_MYSTICTHEURGE_SPELLCASTING_BARD);
			nCasterLevel += _GetLevelIfHasFeat(CLASS_TYPE_HARPER, oCreature, FEAT_HARPER_SPELLCASTING_BARD) - 1;
			nCasterLevel += _GetLevelIfHasFeat(CLASS_TYPE_ARCANE_SCHOLAR, oCreature, FEAT_ARCANE_SCHOLAR_SPELLCASTING_BARD);
			nCasterLevel += _GetLevelIfHasFeat(CLASS_TYPE_ARCANETRICKSTER, oCreature, FEAT_ARCTRICKSTER_SPELLCASTING_BARD);
			nCasterLevel += _GetLevelIfHasFeat(CLASS_TYPE_ELDRITCH_KNIGHT, oCreature, FEAT_ELDRITCH_KNIGHT_SPELLCASTING_BARD) - 1;
			nCasterLevel += (_GetLevelIfHasFeat(CLASS_BLADESINGER, oCreature, FEAT_BLADESINGER_SPELLCASTING_BARD)+1) / 2;
			nCasterLevel = _GetPracticedSpellcasterCL(oCreature, nCasterLevel, FEAT_PRACTICED_SPELLCASTER_BARD);
			break;
		
		case CLASS_TYPE_SORCERER:
			nCasterLevel += nClassLevels;
			nCasterLevel += _GetLevelIfHasFeat(CLASS_LOREMASTER, oCreature, FEAT_LOREMASTER_SPELLCASTING_SORCERER);
			nCasterLevel += _GetLevelIfHasFeat(CLASS_MYSTICTHEURGE, oCreature, FEAT_MYSTICTHEURGE_SPELLCASTING_SORCERER);
			nCasterLevel += _GetLevelIfHasFeat(CLASS_TYPE_HARPER, oCreature, FEAT_HARPER_SPELLCASTING_SORCERER) - 1;
			nCasterLevel += _GetLevelIfHasFeat(CLASS_TYPE_ARCANE_SCHOLAR, oCreature, FEAT_ARCANE_SCHOLAR_SPELLCASTING_SORCERER);
			nCasterLevel += _GetLevelIfHasFeat(CLASS_TYPE_ARCANETRICKSTER, oCreature, FEAT_ARCTRICKSTER_SPELLCASTING_SORCERER);
			nCasterLevel += _GetLevelIfHasFeat(CLASS_TYPE_ELDRITCH_KNIGHT, oCreature, FEAT_ELDRITCH_KNIGHT_SPELLCASTING_SORCERER) - 1;
			nCasterLevel += (_GetLevelIfHasFeat(CLASS_BLADESINGER, oCreature, FEAT_BLADESINGER_SPELLCASTING_SORCERER)+1) / 2;
			nCasterLevel = _GetPracticedSpellcasterCL(oCreature, nCasterLevel, FEAT_PRACTICED_SPELLCASTER_SORCERER);
			break;
			
		case CLASS_TYPE_WIZARD:
			nCasterLevel += nClassLevels;
			nCasterLevel += _GetLevelIfHasFeat(CLASS_LOREMASTER, oCreature, FEAT_LOREMASTER_SPELLCASTING_WIZARD);
			nCasterLevel += _GetLevelIfHasFeat(CLASS_MYSTICTHEURGE, oCreature, FEAT_MYSTICTHEURGE_SPELLCASTING_WIZARD);
			nCasterLevel += _GetLevelIfHasFeat(CLASS_TYPE_HARPER, oCreature, FEAT_HARPER_SPELLCASTING_WIZARD) - 1;
			nCasterLevel += _GetLevelIfHasFeat(CLASS_TYPE_ARCANE_SCHOLAR, oCreature, FEAT_ARCANE_SCHOLAR_SPELLCASTING_WIZARD);
			nCasterLevel += _GetLevelIfHasFeat(CLASS_TYPE_ARCANETRICKSTER, oCreature, FEAT_ARCTRICKSTER_SPELLCASTING_WIZARD);
			nCasterLevel += _GetLevelIfHasFeat(CLASS_TYPE_ELDRITCH_KNIGHT, oCreature, FEAT_ELDRITCH_KNIGHT_SPELLCASTING_WIZARD) - 1;
			nCasterLevel += (_GetLevelIfHasFeat(CLASS_BLADESINGER, oCreature, FEAT_BLADESINGER_SPELLCASTING_WIZARD)+1) / 2;
			nCasterLevel += (_GetLevelIfHasFeat(CLASS_TYPE_RED_WIZARD, oCreature, FEAT_RED_WIZARD_SPELLCASTING_WIZARD)+1) / 2;
			nCasterLevel = _GetPracticedSpellcasterCL(oCreature, nCasterLevel, FEAT_PRACTICED_SPELLCASTER_WIZARD);
			break;
				
		case CLASS_TYPE_PALADIN:
			nCasterLevel += (nClassLevels > 4) ? (nClassLevels / 2) : 0;
			nCasterLevel += _GetLevelIfHasFeat(CLASS_LOREMASTER, oCreature, FEAT_LOREMASTER_SPELLCASTING_PALADIN);
			nCasterLevel += _GetLevelIfHasFeat(CLASS_MYSTICTHEURGE, oCreature, FEAT_MYSTICTHEURGE_SPELLCASTING_PALADIN);
			nCasterLevel += _GetLevelIfHasFeat(CLASS_TYPE_WARPRIEST, oCreature, FEAT_WARPRIEST_SPELLCASTING_PALADIN) / 2;
			nCasterLevel += _GetLevelIfHasFeat(CLASS_TYPE_STORMLORD, oCreature, FEAT_STORMLORD_SPELLCASTING_PALADIN);
			nCasterLevel += _GetLevelIfHasFeat(CLASS_TYPE_HARPER, oCreature, FEAT_HARPER_SPELLCASTING_PALADIN) - 1;
			nCasterLevel += _GetLevelIfHasFeat(CLASS_TYPE_DOOMGUIDE, oCreature, FEAT_DOOMGUIDE_PALADIN_SPELLCASTING);
			nCasterLevel += (_GetLevelIfHasFeat(CLASS_TYPE_SACREDFIST, oCreature, FEAT_SACREDFIST_SPELLCASTING_PALADIN)+1) * 3 / 4;
			nCasterLevel = _GetPracticedSpellcasterCL(oCreature, nCasterLevel, FEAT_PRACTICED_SPELLCASTER_PALADIN);
			break;
		
		case CLASS_TYPE_RANGER:
			nCasterLevel += (nClassLevels > 4) ? (nClassLevels / 2) : 0;
			nCasterLevel += _GetLevelIfHasFeat(CLASS_LOREMASTER, oCreature, FEAT_LOREMASTER_SPELLCASTING_RANGER);
			nCasterLevel += _GetLevelIfHasFeat(CLASS_MYSTICTHEURGE, oCreature, FEAT_MYSTICTHEURGE_SPELLCASTING_RANGER);
			nCasterLevel += _GetLevelIfHasFeat(CLASS_TYPE_WARPRIEST, oCreature, FEAT_WARPRIEST_SPELLCASTING_RANGER) / 2;
			nCasterLevel += _GetLevelIfHasFeat(CLASS_TYPE_STORMLORD, oCreature, FEAT_STORMLORD_SPELLCASTING_RANGER);
			nCasterLevel += _GetLevelIfHasFeat(CLASS_TYPE_HARPER, oCreature, FEAT_HARPER_SPELLCASTING_RANGER) - 1;
			nCasterLevel += _GetLevelIfHasFeat(CLASS_TYPE_DOOMGUIDE, oCreature, FEAT_DOOMGUIDE_RANGER_SPELLCASTING);
			nCasterLevel += (_GetLevelIfHasFeat(CLASS_TYPE_SACREDFIST, oCreature, FEAT_SACREDFIST_SPELLCASTING_RANGER)+1) * 3 / 4;
			nCasterLevel = _GetPracticedSpellcasterCL(oCreature, nCasterLevel, FEAT_PRACTICED_SPELLCASTER_RANGER);
			break;
		
		default: return 0;
	}
	
	return nCasterLevel;
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