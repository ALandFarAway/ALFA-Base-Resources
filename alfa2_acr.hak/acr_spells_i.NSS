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
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

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

int ACR_GetCorrectCasterLevel(object oCreature, int nClass);

void WarnWhenSpellExpires(object oCreature, int nSpellId, string sMessage, float fDuration);

void _floatMessageIfHasSpellEffect(object oCreature, int nSpellId, string sMessage, float fDuration);

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

int ACR_GetCorrectCasterLevel(object oCreature, int nClass) {
	int nCasterLevel;
	int nClassLevels = GetLevelByClass(nClass, oCreature);
	
	switch(nClass) {
		
		case CLASS_TYPE_CLERIC:
			if(GetHasFeat(FEAT_LOREMASTER_SPELLCASTING_CLERIC, oCreature)) nCasterLevel += GetLevelByClass(CLASS_LOREMASTER, oCreature);
			if(GetHasFeat(FEAT_MYSTICTHEURGE_SPELLCASTING_CLERIC, oCreature)) nCasterLevel += GetLevelByClass(CLASS_MYSTICTHEURGE, oCreature);
			if(GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_CLERIC, oCreature)) nCasterLevel += GetLevelByClass(CLASS_TYPE_WARPRIEST, oCreature) / 2;
			if(GetHasFeat(FEAT_STORMLORD_SPELLCASTING_CLERIC, oCreature)) nCasterLevel += GetLevelByClass(CLASS_TYPE_STORMLORD, oCreature);
			if(GetHasFeat(FEAT_HARPER_SPELLCASTING_CLERIC, oCreature)) nCasterLevel += GetLevelByClass(CLASS_TYPE_HARPER, oCreature) - 1;
			if(GetHasFeat(FEAT_DOOMGUIDE_CLERIC_SPELLCASTING, oCreature)) nCasterLevel += GetLevelByClass(CLASS_TYPE_DOOMGUIDE, oCreature);
			if(GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_CLERIC, oCreature)) nCasterLevel += (GetLevelByClass(CLASS_TYPE_SACREDFIST, oCreature)+1) * 3 / 4;
			nCasterLevel += nClassLevels;
			break;
			
		case CLASS_TYPE_DRUID:
			if(GetHasFeat(FEAT_LOREMASTER_SPELLCASTING_DRUID, oCreature)) nCasterLevel += GetLevelByClass(CLASS_LOREMASTER, oCreature);
			if(GetHasFeat(FEAT_MYSTICTHEURGE_SPELLCASTING_DRUID, oCreature)) nCasterLevel += GetLevelByClass(CLASS_MYSTICTHEURGE, oCreature);
			if(GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_DRUID, oCreature)) nCasterLevel += GetLevelByClass(CLASS_TYPE_WARPRIEST, oCreature) / 2;
			if(GetHasFeat(FEAT_STORMLORD_SPELLCASTING_DRUID, oCreature)) nCasterLevel += GetLevelByClass(CLASS_TYPE_STORMLORD, oCreature);
			if(GetHasFeat(FEAT_HARPER_SPELLCASTING_DRUID, oCreature)) nCasterLevel += GetLevelByClass(CLASS_TYPE_HARPER, oCreature) - 1;
			if(GetHasFeat(FEAT_DOOMGUIDE_DRUID_SPELLCASTING, oCreature)) nCasterLevel += GetLevelByClass(CLASS_TYPE_DOOMGUIDE, oCreature);
			if(GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_DRUID, oCreature)) nCasterLevel += (GetLevelByClass(CLASS_TYPE_SACREDFIST, oCreature)+1) * 3 / 4;
			nCasterLevel += nClassLevels;
			break;
			
		case CLASS_TYPE_FAVORED_SOUL:
			if(GetHasFeat(FEAT_LOREMASTER_SPELLCASTING_FS, oCreature)) nCasterLevel += GetLevelByClass(CLASS_LOREMASTER, oCreature);
			if(GetHasFeat(FEAT_MYSTICTHEURGE_SPELLCASTING_FS, oCreature)) nCasterLevel += GetLevelByClass(CLASS_MYSTICTHEURGE, oCreature);
			if(GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_FAVORED_SOUL, oCreature)) nCasterLevel += GetLevelByClass(CLASS_TYPE_WARPRIEST, oCreature) / 2;
			if(GetHasFeat(FEAT_STORMLORD_SPELLCASTING_FAVORED_SOUL, oCreature)) nCasterLevel += GetLevelByClass(CLASS_TYPE_STORMLORD, oCreature);
			if(GetHasFeat(FEAT_HARPER_SPELLCASTING_FAVORED_SOUL, oCreature)) nCasterLevel += GetLevelByClass(CLASS_TYPE_HARPER, oCreature) - 1;
			if(GetHasFeat(FEAT_DOOMGUIDE_FAVORED_SOUL_SPELLCASTING, oCreature)) nCasterLevel += GetLevelByClass(CLASS_TYPE_DOOMGUIDE, oCreature);
			if(GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_FAVORED_SOUL, oCreature)) nCasterLevel += (GetLevelByClass(CLASS_TYPE_SACREDFIST, oCreature)+1) * 3 / 4;
			nCasterLevel += nClassLevels;
			break;
				
		case CLASS_TYPE_SPIRIT_SHAMAN:
			if(GetHasFeat(FEAT_LOREMASTER_SPELLCASTING_SS, oCreature)) nCasterLevel += GetLevelByClass(CLASS_LOREMASTER, oCreature);
			if(GetHasFeat(FEAT_MYSTICTHEURGE_SPELLCASTING_SS, oCreature)) nCasterLevel += GetLevelByClass(CLASS_MYSTICTHEURGE, oCreature);
			if(GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_SPIRIT_SHAMAN, oCreature)) nCasterLevel += GetLevelByClass(CLASS_TYPE_WARPRIEST, oCreature) / 2;
			if(GetHasFeat(FEAT_STORMLORD_SPELLCASTING_SPIRIT_SHAMAN, oCreature)) nCasterLevel += GetLevelByClass(CLASS_TYPE_STORMLORD, oCreature);
			if(GetHasFeat(FEAT_HARPER_SPELLCASTING_SPIRIT_SHAMAN, oCreature)) nCasterLevel += GetLevelByClass(CLASS_TYPE_HARPER, oCreature) - 1;
			if(GetHasFeat(FEAT_DOOMGUIDE_SPIRIT_SHAMAN_SPELLCASTING, oCreature)) nCasterLevel += GetLevelByClass(CLASS_TYPE_DOOMGUIDE, oCreature);
			if(GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_SPIRIT_SHAMAN, oCreature)) nCasterLevel += (GetLevelByClass(CLASS_TYPE_SACREDFIST, oCreature)+1) * 3 / 4;
			nCasterLevel += nClassLevels;
			break;
		
		case CLASS_TYPE_BARD:
			if(GetHasFeat(FEAT_LOREMASTER_SPELLCASTING_BARD, oCreature)) nCasterLevel += GetLevelByClass(CLASS_LOREMASTER, oCreature);
			if(GetHasFeat(FEAT_MYSTICTHEURGE_SPELLCASTING_BARD, oCreature)) nCasterLevel += GetLevelByClass(CLASS_MYSTICTHEURGE, oCreature);
			if(GetHasFeat(FEAT_HARPER_SPELLCASTING_BARD, oCreature)) nCasterLevel += GetLevelByClass(CLASS_TYPE_HARPER, oCreature) - 1;
			if(GetHasFeat(FEAT_ARCANE_SCHOLAR_SPELLCASTING_BARD, oCreature)) nCasterLevel += GetLevelByClass(CLASS_TYPE_ARCANE_SCHOLAR, oCreature);
			if(GetHasFeat(FEAT_ARCTRICKSTER_SPELLCASTING_BARD, oCreature)) nCasterLevel += GetLevelByClass(CLASS_TYPE_ARCANETRICKSTER, oCreature);
			if(GetHasFeat(FEAT_ELDRITCH_KNIGHT_SPELLCASTING_BARD, oCreature)) nCasterLevel += GetLevelByClass(CLASS_TYPE_ELDRITCH_KNIGHT, oCreature) - 1;
			if(GetHasFeat(FEAT_BLADESINGER_SPELLCASTING_BARD, oCreature)) nCasterLevel += (GetLevelByClass(CLASS_BLADESINGER, oCreature)+1) / 2;
			nCasterLevel += nClassLevels;
			break;
		
		case CLASS_TYPE_SORCERER:
			if(GetHasFeat(FEAT_LOREMASTER_SPELLCASTING_SORCERER, oCreature)) nCasterLevel += GetLevelByClass(CLASS_LOREMASTER, oCreature);
			if(GetHasFeat(FEAT_MYSTICTHEURGE_SPELLCASTING_SORCERER, oCreature)) nCasterLevel += GetLevelByClass(CLASS_MYSTICTHEURGE, oCreature);
			if(GetHasFeat(FEAT_HARPER_SPELLCASTING_SORCERER, oCreature)) nCasterLevel += GetLevelByClass(CLASS_TYPE_HARPER, oCreature) - 1;
			if(GetHasFeat(FEAT_ARCANE_SCHOLAR_SPELLCASTING_SORCERER, oCreature)) nCasterLevel += GetLevelByClass(CLASS_TYPE_ARCANE_SCHOLAR, oCreature);
			if(GetHasFeat(FEAT_ARCTRICKSTER_SPELLCASTING_SORCERER, oCreature)) nCasterLevel += GetLevelByClass(CLASS_TYPE_ARCANETRICKSTER, oCreature);
			if(GetHasFeat(FEAT_ELDRITCH_KNIGHT_SPELLCASTING_SORCERER, oCreature)) nCasterLevel += GetLevelByClass(CLASS_TYPE_ELDRITCH_KNIGHT, oCreature) - 1;
			if(GetHasFeat(FEAT_BLADESINGER_SPELLCASTING_SORCERER, oCreature)) nCasterLevel += (GetLevelByClass(CLASS_BLADESINGER, oCreature)+1) / 2;
			nCasterLevel += nClassLevels;
			break;
			
		case CLASS_TYPE_WIZARD:
			if(GetHasFeat(FEAT_LOREMASTER_SPELLCASTING_WIZARD, oCreature)) nCasterLevel += GetLevelByClass(CLASS_LOREMASTER, oCreature);
			if(GetHasFeat(FEAT_MYSTICTHEURGE_SPELLCASTING_WIZARD, oCreature)) nCasterLevel += GetLevelByClass(CLASS_MYSTICTHEURGE, oCreature);
			if(GetHasFeat(FEAT_HARPER_SPELLCASTING_WIZARD, oCreature)) nCasterLevel += GetLevelByClass(CLASS_TYPE_HARPER, oCreature) - 1;
			if(GetHasFeat(FEAT_ARCANE_SCHOLAR_SPELLCASTING_WIZARD, oCreature)) nCasterLevel += GetLevelByClass(CLASS_TYPE_ARCANE_SCHOLAR, oCreature);
			if(GetHasFeat(FEAT_ARCTRICKSTER_SPELLCASTING_WIZARD, oCreature)) nCasterLevel += GetLevelByClass(CLASS_TYPE_ARCANETRICKSTER, oCreature);
			if(GetHasFeat(FEAT_ELDRITCH_KNIGHT_SPELLCASTING_WIZARD, oCreature)) nCasterLevel += GetLevelByClass(CLASS_TYPE_ELDRITCH_KNIGHT, oCreature) - 1;
			if(GetHasFeat(FEAT_BLADESINGER_SPELLCASTING_WIZARD, oCreature)) nCasterLevel += (GetLevelByClass(CLASS_BLADESINGER, oCreature)+1) / 2;
			if(GetHasFeat(FEAT_RED_WIZARD_SPELLCASTING_WIZARD, oCreature)) nCasterLevel += (GetLevelByClass(CLASS_TYPE_RED_WIZARD, oCreature)+1) / 2;
			nCasterLevel += nClassLevels;
			break;
				
		case CLASS_TYPE_PALADIN:
			if(GetHasFeat(FEAT_LOREMASTER_SPELLCASTING_PALADIN, oCreature)) nCasterLevel += GetLevelByClass(CLASS_LOREMASTER, oCreature);
			if(GetHasFeat(FEAT_MYSTICTHEURGE_SPELLCASTING_PALADIN, oCreature)) nCasterLevel += GetLevelByClass(CLASS_MYSTICTHEURGE, oCreature);
			if(GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_PALADIN, oCreature)) nCasterLevel += GetLevelByClass(CLASS_TYPE_WARPRIEST, oCreature) / 2;
			if(GetHasFeat(FEAT_STORMLORD_SPELLCASTING_PALADIN, oCreature)) nCasterLevel += GetLevelByClass(CLASS_TYPE_STORMLORD, oCreature);
			if(GetHasFeat(FEAT_HARPER_SPELLCASTING_PALADIN, oCreature)) nCasterLevel += GetLevelByClass(CLASS_TYPE_HARPER, oCreature) - 1;
			if(GetHasFeat(FEAT_DOOMGUIDE_PALADIN_SPELLCASTING, oCreature)) nCasterLevel += GetLevelByClass(CLASS_TYPE_DOOMGUIDE, oCreature);
			if(GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_PALADIN, oCreature)) nCasterLevel += (GetLevelByClass(CLASS_TYPE_SACREDFIST, oCreature)+1) * 3 / 4;
			if(nClassLevels >= 4) nCasterLevel += nClassLevels / 2;
			break;
		
		case CLASS_TYPE_RANGER:
			if(GetHasFeat(FEAT_LOREMASTER_SPELLCASTING_RANGER, oCreature)) nCasterLevel += GetLevelByClass(CLASS_LOREMASTER, oCreature);
			if(GetHasFeat(FEAT_MYSTICTHEURGE_SPELLCASTING_RANGER, oCreature)) nCasterLevel += GetLevelByClass(CLASS_MYSTICTHEURGE, oCreature);
			if(GetHasFeat(FEAT_WARPRIEST_SPELLCASTING_RANGER, oCreature)) nCasterLevel += GetLevelByClass(CLASS_TYPE_WARPRIEST, oCreature) / 2;
			if(GetHasFeat(FEAT_STORMLORD_SPELLCASTING_RANGER, oCreature)) nCasterLevel += GetLevelByClass(CLASS_TYPE_STORMLORD, oCreature);
			if(GetHasFeat(FEAT_HARPER_SPELLCASTING_RANGER, oCreature)) nCasterLevel += GetLevelByClass(CLASS_TYPE_HARPER, oCreature) - 1;
			if(GetHasFeat(FEAT_DOOMGUIDE_RANGER_SPELLCASTING, oCreature)) nCasterLevel += GetLevelByClass(CLASS_TYPE_DOOMGUIDE, oCreature);
			if(GetHasFeat(FEAT_SACREDFIST_SPELLCASTING_RANGER, oCreature)) nCasterLevel += (GetLevelByClass(CLASS_TYPE_SACREDFIST, oCreature)+1) * 3 / 4;
			if(nClassLevels >= 4) nCasterLevel += nClassLevels / 2;
			break;
		
		default: return 0;
	}
	
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
	
	return nCasterLevel;
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