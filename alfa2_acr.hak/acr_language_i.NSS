////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_language_i.nss
//    $Revision::         $ current version of the file
//        $Date:: 2009-08-02 #$ date the file was created or modified
//       Author : AcadiusLost
//
//  Description
//  This file contains functions which process all events relating to definition of
//  language choice by starting region; may be expanded to include functions for reading/writing.
//
//  Revision History
//  2008/9/17 AcadiusLost: Inception
//	2008/9/18 AcadiusLost: Added class bonus languages, handling for common/undercommon
//  2009/7/18 AcadiusLost: Edited language options based on PGtF tables for 3.5E
//  2009/7/19 AcadiusLost: Added functions for language reinitialization, Language addition
//  2009/7/28 AcadiusLost: Added support for 11 additional regions
//  2009/8/2  AcadiusLost: Distinguished HalfDrow from HalfElves, added bonus languages by faith,
//					expanded bonus languages by class (and favored enemy) 
//
//	2011/05/29 Ronan: Removed ACR_GetServerRegion as it conflicts with acr_settings_i.nss.
/////////////////////////////////////////////////////////////////////////////////

#include "acr_i"
#include "acr_db_persist_i"
#include "acr_settings_i"
#include "dmfi_inc_english"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//!! Local variable cache for origin region for a PC
const string ACR_CHARACTER_REGION = "ACR_CHARACTER_REGION";

// Number of the intial and final rows of feats.2da, used to iterate through all possible regions.
const int ACR_REGIONS_START = 3502;
const int ACR_REGIONS_END = 3571;

// Public functions

//!! Returns the character's starting region constant.
int ACR_GetCharacterRegion(object oPC);

//!! Defines the character's starting region constant.
void ACR_SetCharacterRegion(object oPC, int nRegion);

//!! checks to see if a PC is from outside the server's region.
int ACR_GetIsForeign(object oPC);

//!! Prepares DMFI language selection list by region
void ACR_InitializeLanguages(object oPC, int nRegion);

//!! Handles setup for DMFI languages on login
void ACR_LanguagesOnPCModuleLoaded();

//!! Handles new languages after a levelup.
void ACR_LanguagesOnLevelUp(object oLeveled);


// Private functions

//  Grants automatic languages by class of PC
void _AddAutomaticLanguagesByClass(object oPC);

//  Grants automatic languages by race of PC
void _AddAutomaticLanguagesByRace(object oPC);

//  Grants automatic languages by region of PC origin
void _AddAutomaticLanguagesByRegion(object oPC);

//  Adds languages to the selection list by class
void _AddBonusLanguagesByClass(object oPC);

//  Adds languages to the selection list by Faith
void _AddBonusLanguagesByFaith(object oPC);

//  Adds languages to the selection list by race
void _AddBonusLanguagesByRace(object oPC);

//  Adds languages to the selection list by region of origin
void _AddBonusLanguagesByRegion(int nRegion, object oPC);

// gets a DMFI tool to access languages
object _GetDMFITool(object oPC);

// checks if a language is known
int _IsLanguageKnown(object oPC, string sLang);

// grants an additional language
void _GrantLanguage(object oPC, string sLang);

// adds a language to the list of language options
void _GrantChoosenLang(object oPC, string sLang);

// deletes DMFI list
int _DeleteList( string list, object holder = OBJECT_SELF );

// opens multipage list box from DMFI
void _ShowDMFIListUI(object oPC, string sScreen="SCREEN_DMFI_DMLIST");

// capitalize word, from DMFI
string _CapitalizeWord(string sWord);

// Add string element, from DMFI
// Adds a string item to the list and return the new item count.
int _AddStringElement( string item, string list, object holder = OBJECT_SELF );

// Adds a string item to the list and return the new item count (no duplicates).
int _AddUniqueStringElement( string item, string list, object holder = OBJECT_SELF );

// from DMFI:
// Returns the number of items in the specified list.
int _GetElementCount( string list, object holder = OBJECT_SELF );

// from DMFI:
// Internal function to get the string for a given index
string _IndexToString( int index, string list );

// junk the DMFI tool so the languages can be reassigned
void _WipeLanguages(object oPC);

// reinitialize the new DMFI tool so the languages can be reassigned
void _ReInitializeDMFITool(object oPC, object oTool);

//
//  Function bodies
//

int ACR_GetCharacterRegion(object oPC) {

	int nRegion = GetLocalInt(oPC, ACR_CHARACTER_REGION);
    // Check first for a region cached on the PC or NPC
	if ( nRegion != 0 ) {
		// SendMessageToPC(oPC, "Retrieving region of origin from local cache: "+IntToString(nRegion));
	    return nRegion;
	} // if region isn't cached on the PC, check the PC for regional feats, then cache the result.
	int nCount = ACR_REGIONS_START;
	while (nCount < ACR_REGIONS_END) {
		if (GetHasFeat(nCount, oPC)) {
			SetLocalInt(oPC, ACR_CHARACTER_REGION, nCount);
			return nCount;
		} else { 
			nCount = nCount+1;
		}
	}
	// if this gets this far, no valid regional feat was found, return -1
	return -1;
}

void ACR_SetCharacterRegion(object oPC, int nRegion) {

	// adds the proper regional background feat
	if ((nRegion >= ACR_REGIONS_START) && (nRegion <= ACR_REGIONS_END)) {
		FeatAdd(oPC, nRegion, FALSE, TRUE, TRUE);
		WriteTimestampedLogEntry("Regional background feat # "+IntToString(nRegion)+" added for PC "+GetName(oPC)+".");
		SetLocalInt(oPC, ACR_CHARACTER_REGION, nRegion);
	} else {
		SendMessageToPC(oPC, "Invalid background region selection.");
	}
}

int ACR_GetIsForeign(object oPC) {

	if (ACR_GetCharacterRegion(oPC) == ACR_GetServerRegion()) {
	    return FALSE;
	} else {
	    return TRUE;
	}
}


void ACR_InitializeLanguages(object oPC, int nRegion) {
	// Adapted from the DMFI language initialization code.
	

}



void ACR_LanguagesOnLevelUp(object oLeveled) {

	// Check to see if the PC has any Druid levels, and needs Druidic
	if (GetLevelByClass(CLASS_TYPE_DRUID, oLeveled) > 0) {
		if (!_IsLanguageKnown(oLeveled, LNG_DRUIDIC)) {
			_GrantLanguage(oLeveled, LNG_DRUIDIC);
		}
	}
	// if the PC is in the process of an automated rebuild, skip the rest of this for now.
	if (GetSkillRank(0, oLeveled, TRUE) < 2) {
		return;
	}
	// check to see if the PC has enough bonus languages for their int bonus and skill 
	int nPriorLangs = GetLocalInt(_GetDMFITool(oLeveled), "ACR_LANG_BONUSLANGUAGES");
	int nInitialBonusMod = GetLocalInt(_GetDMFITool(oLeveled), "ACR_LANG_INT_BONUS");
	if (nInitialBonusMod < 0) {
		nInitialBonusMod = 0;
	}
	// based on number of base skill ranks of Speak Language
	int nDeservedLanguages = GetSkillRank(SKILL_SPEAK_LANGUAGE, oLeveled, TRUE);
	// also add the PC's INITIAL BASE intelligence mod (later increases don't boost this)
	nDeservedLanguages = nDeservedLanguages + nInitialBonusMod; 

	if (nDeservedLanguages > nPriorLangs) {
		nDeservedLanguages = nDeservedLanguages - nPriorLangs;
		SendMessageToPC(oLeveled, "You are entitled to "+IntToString(nDeservedLanguages)+" additional languages.");
		// code from DMFI_inc_langexe
		object oTool=_GetDMFITool(oLeveled);
		_DeleteList("LIST_POSSLANGUAGE", oTool);
	
		// build a current list
		_AddBonusLanguagesByClass(oLeveled);
		_AddBonusLanguagesByRace(oLeveled);
		// offer languages from the PC's background region
		_AddBonusLanguagesByRegion(ACR_GetCharacterRegion(oLeveled), oLeveled);
		// also offer languages from the current server
		_AddBonusLanguagesByRegion(ACR_GetServerRegion(), oLeveled);
		// finally, add languages by faith
		_AddBonusLanguagesByFaith(oLeveled);
			
		SetLocalInt(oLeveled, "DMFIChoose", nDeservedLanguages);
		
		DeleteLocalInt(oLeveled, "DMFI_REQ_INT");
		DeleteLocalString(oLeveled, "DMFILastUICom");
		DeleteLocalString(oLeveled, "DMFI_UI_PAGE");
		
		SetLocalString(oLeveled, "DMFILastUICom", "grant ");
		SetLocalString(oLeveled, "DMFI_UI_PAGE", "LIST_POSSLANGUAGE");
		SetLocalString(oLeveled, "DMFILISTTITLE", "Remaining Language Selections: " + IntToString(nDeservedLanguages));
		_ShowDMFIListUI(oLeveled, "SCREEN_DMFI_CHOOSE");
		
		// update the record of how many bonus languages are known, total.
		SetLocalInt(oTool, "ACR_LANG_BONUSLANGUAGES", nDeservedLanguages+nPriorLangs);
	}
}

void _AddAutomaticLanguagesByClass(object oPC) {

	int nClass = GetClassByPosition(1, oPC);
	// for now, just base this on the base class of the PC.
	if (nClass == CLASS_TYPE_DRUID) {
		_GrantLanguage(oPC, LNG_DRUIDIC);
	}
	// cant isn't really canon as a universal rogue language, so leaving this for now.
}


void _AddAutomaticLanguagesByRace(object oPC) {

	int nRace = GetRacialType(oPC);
	int nSubRace = GetSubRace(oPC);
	
	// Make racial automatic languages available
	if (nRace==RACIAL_TYPE_DWARF)
	{
		if (nSubRace==RACIAL_SUBTYPE_GRAY_DWARF) {
			_GrantLanguage(oPC, LNG_UNDERCOMMON);
		} else {
		    _GrantLanguage(oPC, LNG_COMMON);
		}
		_GrantLanguage(oPC, LNG_DWARF);
	}
	else if (nRace==RACIAL_TYPE_ELF)
	{
		if (nSubRace==RACIAL_SUBTYPE_DROW) {
			_GrantLanguage(oPC, LNG_DROW);
			_GrantLanguage(oPC, LNG_UNDERCOMMON);
		} else {
			_GrantLanguage(oPC, LNG_COMMON);
			_GrantLanguage(oPC, LNG_ELVEN);
		}	
	}
	else if (nSubRace==RACIAL_SUBTYPE_HALFELF)
	{
		_GrantLanguage(oPC, LNG_COMMON);
		_GrantLanguage(oPC, LNG_ELVEN);
	}
	else if (nSubRace==RACIAL_SUBTYPE_HALFDROW)
	{
		_GrantLanguage(oPC, LNG_COMMON);
		_GrantLanguage(oPC, LNG_DROW);
	}
	else if ((nRace==RACIAL_TYPE_HALFORC) || (nRace==RACIAL_TYPE_GRAYORC))
	{
		_GrantLanguage(oPC, LNG_COMMON);
		_GrantLanguage(oPC, LNG_ORC);
	}	
	else if (nRace==RACIAL_TYPE_HALFLING)
	{
		_GrantLanguage(oPC, LNG_COMMON);
		_GrantLanguage(oPC, LNG_HALFLING);
	}
	else if (nRace==RACIAL_TYPE_GNOME)
	{
	    if (nSubRace==RACIAL_SUBTYPE_SVIRFNEBLIN) {
			_GrantLanguage(oPC, LNG_UNDERCOMMON);
		} else {
			_GrantLanguage(oPC, LNG_COMMON);
		}
		_GrantLanguage(oPC, LNG_GNOME);
	}
	else if (nRace==RACIAL_TYPE_YUANTI)
	{
		_GrantLanguage(oPC, LNG_YUANTI);
	}
	else 
	{
	 	_GrantLanguage(oPC, LNG_COMMON);
	}
}


void _AddAutomaticLanguagesByRegion(object oPC) {
	
	int nRegion = ACR_GetCharacterRegion(oPC);
	
	if (nRegion == FEAT_REGION_AGLAROND) {
		_GrantLanguage(oPC, LNG_ALGARONDAN);
		
	} else if (nRegion == FEAT_REGION_ALTUMBEL) {
		_GrantLanguage(oPC, LNG_ALGARONDAN);
		
	} else if (nRegion == FEAT_REGION_AMN) {
		_GrantLanguage(oPC, LNG_CHONDATHAN);

	} else if (nRegion == FEAT_REGION_ANAUROCH) {
		_GrantLanguage(oPC, LNG_MIDANI);
		
	} else if (nRegion == FEAT_REGION_CALIMSHAN) {
		_GrantLanguage(oPC, LNG_ALZHEDO);
		
	} else if (nRegion == FEAT_REGION_CHESSENTA) {
		_GrantLanguage(oPC, LNG_CHESSENTAN);
		
	} else if (nRegion == FEAT_REGION_CHONDALWOOD) {
		_GrantLanguage(oPC, LNG_SHAARAN);
			
	} else if (nRegion == FEAT_REGION_CHULT) {
		_GrantLanguage(oPC, LNG_CHULTAN);
	
	} else if (nRegion == FEAT_REGION_CORMYR) {
		_GrantLanguage(oPC, LNG_CHONDATHAN);
		
	} else if (nRegion == FEAT_REGION_DALELANDS) {
		_GrantLanguage(oPC, LNG_CHONDATHAN);
		
	} else if (nRegion == FEAT_REGION_DAMARA) {
		_GrantLanguage(oPC, LNG_DAMARAN);
		
	} else if (nRegion == FEAT_REGION_DAMBRATH) {
		_GrantLanguage(oPC, LNG_DAMBRATHAN);	
			
	} else 	if (nRegion == FEAT_REGION_DRAGON_COAST) {
		_GrantLanguage(oPC, LNG_CHONDATHAN);
		
	} else if (nRegion == FEAT_REGION_EVERMEET) {
		_GrantLanguage(oPC, LNG_ELVEN);
		
	} else if (nRegion == FEAT_REGION_GOLDEN_WATER) {
		_GrantLanguage(oPC, LNG_DURPARI);	
			
	} else if (nRegion == FEAT_REGION_GREAT_DALE) {
		_GrantLanguage(oPC, LNG_DAMARAN);

	} else if (nRegion == FEAT_REGION_GREAT_GLACIER) {
		_GrantLanguage(oPC, LNG_ULUIK);
			
	} else if (nRegion == FEAT_REGION_HALRUAA) {
		_GrantLanguage(oPC, LNG_HALRUAAN);
				
	} else if (nRegion == FEAT_REGION_HIGH_FOREST) {
		_GrantLanguage(oPC, LNG_CHONDATHAN);
		
	} else if (nRegion == FEAT_REGION_HORDELANDS) {
		_GrantLanguage(oPC, LNG_TUIGAN);
		
	} else 	if (nRegion == FEAT_REGION_IMPILTUR) {
		_GrantLanguage(oPC, LNG_DAMARAN);
		
	} else if (nRegion == FEAT_REGION_LAKE_OF_STEAM) {
		_GrantLanguage(oPC, LNG_SHAARAN);
			
	} else if (nRegion == FEAT_REGION_LANTAN) {
		_GrantLanguage(oPC, LNG_LANTANESE);

	} else if (nRegion == FEAT_REGION_LAPALIIYA) {
		_GrantLanguage(oPC, LNG_TASHALAN);
		
	} else if (nRegion == FEAT_REGION_LUIREN) {
		_GrantLanguage(oPC, LNG_HALFLING);
						
	} else if (nRegion == FEAT_REGION_MOONSEA) {
		_GrantLanguage(oPC, LNG_DAMARAN);
											
	} else if (nRegion == FEAT_REGION_MOONSHAE_ISLES) {
		_GrantLanguage(oPC, LNG_ILLUSKAN);
			
	} else if (nRegion == FEAT_REGION_MULHORAND) {
		_GrantLanguage(oPC, LNG_MULHORANDI);
		
	} else if (nRegion == FEAT_REGION_NARFELL) {
		_GrantLanguage(oPC, LNG_DAMARAN);
			
	} else if (nRegion == FEAT_REGION_NELANTHER) {
		_GrantLanguage(oPC, LNG_CHONDATHAN);
				
	} else if (nRegion == FEAT_REGION_NORTH) {
		// DMFI_GrantLanguage(oPC, LNG_CHONDATHAN); PGtF lists Illuskan alone
		_GrantLanguage(oPC, LNG_ILLUSKAN);
		
	} else if (nRegion == FEAT_REGION_RASHEMEN) {
		_GrantLanguage(oPC, LNG_RASHEMI);

	} else if (nRegion == FEAT_REGION_RIDE) {
		_GrantLanguage(oPC, LNG_DAMARAN);
				
	} else if (nRegion == FEAT_REGION_SEMBIA) {
		_GrantLanguage(oPC, LNG_CHONDATHAN);
		
	} else if (nRegion == FEAT_REGION_SESPECH) {
		_GrantLanguage(oPC, LNG_SHAARAN);			

	} else if (nRegion == FEAT_REGION_SHAAR) {
		_GrantLanguage(oPC, LNG_SHAARAN);
			
	} else if (nRegion == FEAT_REGION_SHADOVAR) {
		_GrantLanguage(oPC, LNG_NETHERESE);
		
	} else if (nRegion == FEAT_REGION_SHOU_EXPATRIATE) {
		_GrantLanguage(oPC, LNG_SHOU);
										
	} else if (nRegion == FEAT_REGION_SILVERYMOON) {
		_GrantLanguage(oPC, LNG_CHONDATHAN);
		// DMFI_GrantLanguage(oPC, LNG_ILLUSKAN); PGtF lists Chondathan only
		
	} else if (nRegion == FEAT_REGION_SWORD_COAST) {
		_GrantLanguage(oPC, LNG_ILLUSKAN);
			
	} else if (nRegion == FEAT_REGION_TASHALAR) {
		_GrantLanguage(oPC, LNG_TASHALAN);
		
	} else if (nRegion == FEAT_REGION_TETHYR) {
		_GrantLanguage(oPC, LNG_CHONDATHAN);
			
	} else if (nRegion == FEAT_REGION_THAY) {
		_GrantLanguage(oPC, LNG_MULHORANDI);
			
	} else if (nRegion == FEAT_REGION_THESK) {
		_GrantLanguage(oPC, LNG_DAMARAN);
		
	} else if (nRegion == FEAT_REGION_TURMISH) {
		_GrantLanguage(oPC, LNG_TURMIC);
		
	} else if (nRegion == FEAT_REGION_UNTHER) {
		_GrantLanguage(oPC, LNG_UNTHERIC);
		
	} else if (nRegion == FEAT_REGION_UTHGART) {
		_GrantLanguage(oPC, LNG_ILLUSKAN);
			
	} else if (nRegion == FEAT_REGION_VAASA) {
		_GrantLanguage(oPC, LNG_DAMARAN);
		
	} else if (nRegion == FEAT_REGION_VAST) {
		_GrantLanguage(oPC, LNG_DAMARAN);
		
	} else if (nRegion == FEAT_REGION_VILHON_REACH) {
		_GrantLanguage(oPC, LNG_CHONDATHAN);
						
	} else if (nRegion == FEAT_REGION_WATERDEEP) {
		_GrantLanguage(oPC, LNG_CHONDATHAN);
				
	} else if (nRegion == FEAT_REGION_WESTERN_HEARTLANDS) {
		_GrantLanguage(oPC, LNG_CHONDATHAN);
		
	} else if (nRegion == FEAT_REGION_WIZARDS_REACH) {
		_GrantLanguage(oPC, LNG_UNTHERIC);
			
	} else if ((nRegion == FEAT_REGION_DWARF_GOLD) || (nRegion == FEAT_REGION_DWARF_SHIELD)) {
		_GrantLanguage(oPC, LNG_DWARF);
		
	} else if (nRegion == FEAT_REGION_DWARF_GRAY) {
		_GrantLanguage(oPC, LNG_DWARF);
		_GrantLanguage(oPC, LNG_UNDERCOMMON);	
		
	} else if ((nRegion == FEAT_REGION_ELF_MOON) || (nRegion == FEAT_REGION_ELF_SUN) || (nRegion == FEAT_REGION_ELF_WILD) || (nRegion == FEAT_REGION_ELF_WOOD)) {
		_GrantLanguage(oPC, LNG_ELVEN);		

	} else if (nRegion == FEAT_REGION_ELF_DROW) {
		_GrantLanguage(oPC, LNG_DROW);
		_GrantLanguage(oPC, LNG_UNDERCOMMON);

	} else if (nRegion == FEAT_REGION_GNOME_DEEP) {
		_GrantLanguage(oPC, LNG_GNOME);
		_GrantLanguage(oPC, LNG_UNDERCOMMON);
		
	} else if (nRegion == FEAT_REGION_GNOME_ROCK) {
		_GrantLanguage(oPC, LNG_GNOME);
				
	} else if ((nRegion == FEAT_REGION_HALFLING_GHOSTWISE) || (nRegion == FEAT_REGION_HALFLING_LIGHTFOOT) || (nRegion == FEAT_REGION_HALFLING_STRONGHEART)) {
		_GrantLanguage(oPC, LNG_HALFLING);	

	} else if ((nRegion == FEAT_REGION_ORC) || (nRegion == FEAT_REGION_HALFORC)) {
		_GrantLanguage(oPC, LNG_ORC);
							
	} else {
		SendMessageToPC(oPC, "ERROR: Automatic Languages for Region: Starting region "+IntToString(nRegion)+" not yet implemented.");
		WriteTimestampedLogEntry("Region Language error for region #"+IntToString(nRegion)+", for PC: "+GetName(oPC)+", played by "+GetPCPlayerName(oPC)+".");
	}
}


void _AddBonusLanguagesByClass(object oPC) {

    if (GetLevelByClass(CLASS_TYPE_CLERIC, oPC) || GetLevelByClass(CLASS_TYPE_FAVORED_SOUL, oPC)) {
		_GrantChoosenLang(oPC, LNG_ABYSSAL);
		_GrantChoosenLang(oPC, LNG_CELESTIAL);
		_GrantChoosenLang(oPC, LNG_INFERNAL);
	}
	if (GetLevelByClass(CLASS_TYPE_WIZARD, oPC) || GetLevelByClass(CLASS_TYPE_SORCERER, oPC)) {
		_GrantChoosenLang(oPC, LNG_DRACONIC);
	}
	if (GetLevelByClass(CLASS_TYPE_DRUID, oPC) || GetLevelByClass(CLASS_TYPE_SPIRIT_SHAMAN, oPC)) {
		_GrantChoosenLang(oPC, LNG_SYLVAN);
	}
	if (GetLevelByClass(CLASS_TYPE_PALADIN, oPC)) {
		_GrantChoosenLang(oPC, LNG_CELESTIAL);
	}
	if (GetLevelByClass(CLASS_TYPE_RANGER, oPC)) {
		if (GetHasFeat(FEAT_FAVORED_ENEMY_DRAGON, oPC) || GetHasFeat(FEAT_IMPROVED_FAVORED_ENEMY_DRAGON, oPC))
			_GrantChoosenLang(oPC, LNG_DRACONIC);
		if (GetHasFeat(FEAT_FAVORED_ENEMY_DWARF, oPC) || GetHasFeat(FEAT_IMPROVED_FAVORED_ENEMY_DWARF, oPC))
			_GrantChoosenLang(oPC, LNG_DWARF);
		if (GetHasFeat(FEAT_FAVORED_ENEMY_ELEMENTAL, oPC) || GetHasFeat(FEAT_IMPROVED_FAVORED_ENEMY_ELEMENTAL, oPC)) {
			_GrantChoosenLang(oPC, LNG_AQUAN);
			_GrantChoosenLang(oPC, LNG_AURAN);
			_GrantChoosenLang(oPC, LNG_IGNAN);
			_GrantChoosenLang(oPC, LNG_TERRAN);
		}
		if (GetHasFeat(FEAT_FAVORED_ENEMY_ELF, oPC) || GetHasFeat(FEAT_IMPROVED_FAVORED_ENEMY_ELF, oPC))
			_GrantChoosenLang(oPC, LNG_ELVEN);
		if (GetHasFeat(FEAT_FAVORED_ENEMY_FEY, oPC) || GetHasFeat(FEAT_IMPROVED_FAVORED_ENEMY_FEY, oPC))
			_GrantChoosenLang(oPC, LNG_SYLVAN);
		if (GetHasFeat(FEAT_FAVORED_ENEMY_GIANT, oPC) || GetHasFeat(FEAT_IMPROVED_FAVORED_ENEMY_GIANT, oPC))
			_GrantChoosenLang(oPC, LNG_GIANT);
		if (GetHasFeat(FEAT_FAVORED_ENEMY_GNOME, oPC) || GetHasFeat(FEAT_IMPROVED_FAVORED_ENEMY_GNOME, oPC))
			_GrantChoosenLang(oPC, LNG_GNOME);	
		if (GetHasFeat(FEAT_FAVORED_ENEMY_GOBLINOID, oPC) || GetHasFeat(FEAT_IMPROVED_FAVORED_ENEMY_GOBLINOID, oPC))
			_GrantChoosenLang(oPC, LNG_GOBLIN);
		if (GetHasFeat(FEAT_FAVORED_ENEMY_HALFELF, oPC) || GetHasFeat(FEAT_IMPROVED_FAVORED_ENEMY_HALFELF, oPC))
			_GrantChoosenLang(oPC, LNG_ELVEN);
		if (GetHasFeat(FEAT_FAVORED_ENEMY_HALFLING, oPC) || GetHasFeat(FEAT_IMPROVED_FAVORED_ENEMY_HALFLING, oPC))
			_GrantChoosenLang(oPC, LNG_HALFLING);
		if (GetHasFeat(FEAT_FAVORED_ENEMY_HALFORC, oPC) || GetHasFeat(FEAT_IMPROVED_FAVORED_ENEMY_HALFORC, oPC))
			_GrantChoosenLang(oPC, LNG_ORC);
		if (GetHasFeat(FEAT_FAVORED_ENEMY_HUMAN, oPC) || GetHasFeat(FEAT_IMPROVED_FAVORED_ENEMY_HUMAN, oPC))
			_GrantChoosenLang(oPC, LNG_COMMON);
		if (GetHasFeat(FEAT_FAVORED_ENEMY_MONSTROUS, oPC) || GetHasFeat(FEAT_IMPROVED_FAVORED_ENEMY_MONSTROUS, oPC))
			_GrantChoosenLang(oPC, LNG_GNOLL);
		if (GetHasFeat(FEAT_FAVORED_ENEMY_ORC, oPC) || GetHasFeat(FEAT_IMPROVED_FAVORED_ENEMY_ORC, oPC))
			_GrantChoosenLang(oPC, LNG_ORC);
		if (GetHasFeat(FEAT_FAVORED_ENEMY_OUTSIDER, oPC) || GetHasFeat(FEAT_IMPROVED_FAVORED_ENEMY_OUTSIDER, oPC)) {
			_GrantChoosenLang(oPC, LNG_ABYSSAL);
			_GrantChoosenLang(oPC, LNG_CELESTIAL);
			_GrantChoosenLang(oPC, LNG_INFERNAL);
		}
		if (GetHasFeat(FEAT_FAVORED_ENEMY_REPTILIAN, oPC) || GetHasFeat(FEAT_IMPROVED_FAVORED_ENEMY_REPTILIAN, oPC))
			_GrantChoosenLang(oPC, LNG_YUANTI);
		// other favored enemies (vermin, undead, aberrations, shapechangers) don't really have a common language.
	}
	if (GetLevelByClass(CLASS_TYPE_WARLOCK, oPC)) {
		_GrantChoosenLang(oPC, LNG_INFERNAL);
		_GrantChoosenLang(oPC, LNG_ABYSSAL);
	}
}

void _AddBonusLanguagesByFaith(object oPC) {

	string sDeity = GetDeity(oPC);
	
	//SendMessageToPC(oPC, "Checking LanguagesByFaith: "+sDeity+".");
	
	if (sDeity == "Aerdrie Faenya") 
		_GrantChoosenLang(oPC, LNG_AURAN);
	else if (sDeity == "Deep Sashelas")
		_GrantChoosenLang(oPC, LNG_AQUAN);	
	else if (sDeity == "Shevarash") {
		_GrantChoosenLang(oPC, LNG_DROW);
		//SendMessageToPC(oPC, "Adding Drow as an available Bonus language.");
	} else if (sDeity == "Eilistraee") {
		_GrantChoosenLang(oPC, LNG_DROW);
		//SendMessageToPC(oPC, "Adding Drow as an available Bonus language.");
	} else if ((sDeity == "Dumathoin") || (sDeity == "Moradin"))
		_GrantChoosenLang(oPC, LNG_TERRAN);		
	else if (sDeity == "Sheela Peryroyl")
		_GrantChoosenLang(oPC, LNG_AURAN);	
	else if (sDeity == "Urogalan")
		_GrantChoosenLang(oPC, LNG_TERRAN);	
	else if ((sDeity == "Callarduran Smoothhands") || (sDeity == "Segojan Earthcaller") || (sDeity == "Urdlen"))
		_GrantChoosenLang(oPC, LNG_TERRAN);	
	else if (sDeity == "Luthic")
		_GrantChoosenLang(oPC, LNG_TERRAN);	
	else if ((sDeity == "Akadi") || (sDeity == "Auril") || (sDeity == "Shaundakul"))
		_GrantChoosenLang(oPC, LNG_AURAN);	
	else if (sDeity == "Eldath")
		_GrantChoosenLang(oPC, LNG_AQUAN);
	else if ((sDeity == "Gond") || (sDeity == "Flandal Steelskin")) {
		_GrantChoosenLang(oPC, LNG_TERRAN);	
		_GrantChoosenLang(oPC, LNG_IGNAN);	
	} else if (sDeity == "Grumbar")
		_GrantChoosenLang(oPC, LNG_TERRAN);	
	else if (sDeity == "Istishia")
		_GrantChoosenLang(oPC, LNG_AQUAN);
	else if (sDeity == "Kossuth")
		_GrantChoosenLang(oPC, LNG_IGNAN);
	else if (sDeity == "Silvanus")
		_GrantChoosenLang(oPC, LNG_AQUAN);
	else if (sDeity == "Talos") {
		_GrantChoosenLang(oPC, LNG_AURAN);
		_GrantChoosenLang(oPC, LNG_IGNAN);
	} else if (sDeity == "Tiamat")
		_GrantChoosenLang(oPC, LNG_DRACONIC);
	else if (sDeity == "Umberlee")
		_GrantChoosenLang(oPC, LNG_AQUAN);
	else if (sDeity == "Valkur") {
		_GrantChoosenLang(oPC, LNG_AQUAN);
		_GrantChoosenLang(oPC, LNG_AURAN);
	} else if (sDeity == "Ubtao")
		_GrantChoosenLang(oPC, LNG_CHULTAN);
}


void _AddBonusLanguagesByRace(object oPC) {

	int nRace = GetRacialType(oPC);
	int nSubRace = GetSubRace(oPC);
	// Make racial bonus languages available
	if (nRace==RACIAL_TYPE_DWARF)
	{
		if (nSubRace==RACIAL_SUBTYPE_GOLD_DWARF) {
		    _GrantChoosenLang(oPC, LNG_GNOME);
			_GrantChoosenLang(oPC, LNG_SHAARAN);
			_GrantChoosenLang(oPC, LNG_TERRAN);
			_GrantChoosenLang(oPC, LNG_UNTHERIC);
		} else if (nSubRace==RACIAL_SUBTYPE_SHIELD_DWARF) {
			_GrantChoosenLang(oPC, LNG_CHONDATHAN);
			_GrantChoosenLang(oPC, LNG_DRACONIC);
			_GrantChoosenLang(oPC, LNG_ILLUSKAN);
			_GrantChoosenLang(oPC, LNG_ORC);
		} else if (nSubRace==RACIAL_SUBTYPE_GRAY_DWARF) {
			_GrantChoosenLang(oPC, LNG_COMMON);
			_GrantChoosenLang(oPC, LNG_DRACONIC);
			_GrantChoosenLang(oPC, LNG_DROW);
			_GrantChoosenLang(oPC, LNG_ORC);
			_GrantChoosenLang(oPC, LNG_TERRAN);
		}
		_GrantChoosenLang(oPC, LNG_GIANT);		
		_GrantChoosenLang(oPC, LNG_GOBLIN);
	}
	else if (nRace==RACIAL_TYPE_ELF)
	{
		if (nSubRace==RACIAL_SUBTYPE_DROW) {
			_GrantChoosenLang(oPC, LNG_ABYSSAL);
			_GrantChoosenLang(oPC, LNG_COMMON);
			_GrantChoosenLang(oPC, LNG_DRACONIC);
			_GrantChoosenLang(oPC, LNG_DROWSIGN);
			_GrantChoosenLang(oPC, LNG_ELVEN);
			_GrantChoosenLang(oPC, LNG_ILLUSKAN);
			_GrantChoosenLang(oPC, LNG_GOBLIN);
		} else if (nSubRace==RACIAL_SUBTYPE_SUN_ELF) {
			_GrantChoosenLang(oPC, LNG_AURAN);
			_GrantChoosenLang(oPC, LNG_CELESTIAL);
			_GrantChoosenLang(oPC, LNG_CHONDATHAN);
			_GrantChoosenLang(oPC, LNG_HALFLING);
			_GrantChoosenLang(oPC, LNG_ILLUSKAN);
			_GrantChoosenLang(oPC, LNG_GNOME);
			_GrantChoosenLang(oPC, LNG_SYLVAN);
		} else if (nSubRace==RACIAL_SUBTYPE_MOON_ELF) {
			_GrantChoosenLang(oPC, LNG_AURAN);
			_GrantChoosenLang(oPC, LNG_CHONDATHAN);
			_GrantChoosenLang(oPC, LNG_GNOLL);
			_GrantChoosenLang(oPC, LNG_GNOME);
			_GrantChoosenLang(oPC, LNG_HALFLING);
			_GrantChoosenLang(oPC, LNG_ILLUSKAN);
			_GrantChoosenLang(oPC, LNG_SYLVAN);
		} else if (nSubRace==RACIAL_SUBTYPE_WILD_ELF) {
			_GrantChoosenLang(oPC, LNG_GNOLL);
			_GrantChoosenLang(oPC, LNG_ILLUSKAN);
			_GrantChoosenLang(oPC, LNG_ORC);
			_GrantChoosenLang(oPC, LNG_SYLVAN);
			_GrantChoosenLang(oPC, LNG_TASHALAN);
		} else if (nSubRace==RACIAL_SUBTYPE_WOOD_ELF) {
			_GrantChoosenLang(oPC, LNG_CHONDATHAN);
			_GrantChoosenLang(oPC, LNG_DRACONIC);
			_GrantChoosenLang(oPC, LNG_GNOLL);
			_GrantChoosenLang(oPC, LNG_GNOME);
			_GrantChoosenLang(oPC, LNG_GOBLIN);
			_GrantChoosenLang(oPC, LNG_SYLVAN);
		}
		
	}
	else if ((nRace==RACIAL_TYPE_HUMAN) || (nRace==RACIAL_TYPE_HALFELF))
	{
		/*  Do these by region.
		
		*/ 
	}
	else if (nRace==RACIAL_TYPE_HALFORC)
	{
		/*  Do these by region.
		
		*/ 
	}	
	else if (nRace==RACIAL_TYPE_HALFLING)
	{
		if (nSubRace==RACIAL_SUBTYPE_LIGHTFOOT_HALF) {
			_GrantChoosenLang(oPC, LNG_CHESSENTAN);
			_GrantChoosenLang(oPC, LNG_CHONDATHAN);
			_GrantChoosenLang(oPC, LNG_DAMARAN);
			_GrantChoosenLang(oPC, LNG_DWARF);
			_GrantChoosenLang(oPC, LNG_ELVEN);
			_GrantChoosenLang(oPC, LNG_ILLUSKAN);
			_GrantChoosenLang(oPC, LNG_GOBLIN);
		} else if (nSubRace==RACIAL_SUBTYPE_STRONGHEART_HALF) {
			_GrantChoosenLang(oPC, LNG_DWARF);
			_GrantChoosenLang(oPC, LNG_GNOLL);
			_GrantChoosenLang(oPC, LNG_GOBLIN);
			_GrantChoosenLang(oPC, LNG_HALRUAAN);
			_GrantChoosenLang(oPC, LNG_SHAARAN);
		} else if (nSubRace==RACIAL_SUBTYPE_GHOSTWISE_HALF) {
			_GrantChoosenLang(oPC, LNG_CHONDATHAN);
			_GrantChoosenLang(oPC, LNG_ELVEN);
			_GrantChoosenLang(oPC, LNG_GNOLL);
			_GrantChoosenLang(oPC, LNG_SHAARAN);
			_GrantChoosenLang(oPC, LNG_SYLVAN);
		}	
	}
	else if (nRace==RACIAL_TYPE_GNOME)
	{
		
	    if (nSubRace==RACIAL_SUBTYPE_SVIRFNEBLIN) {
			_GrantChoosenLang(oPC, LNG_COMMON);		
			_GrantChoosenLang(oPC, LNG_ELVEN);
			_GrantChoosenLang(oPC, LNG_DROW);
		} else {
			_GrantChoosenLang(oPC, LNG_CHONDATHAN);
			_GrantChoosenLang(oPC, LNG_GOBLIN);
			_GrantChoosenLang(oPC, LNG_SYLVAN);
		}
		_GrantChoosenLang(oPC, LNG_DRACONIC);
		_GrantChoosenLang(oPC, LNG_DWARF);
		_GrantChoosenLang(oPC, LNG_ILLUSKAN);
		_GrantChoosenLang(oPC, LNG_TERRAN);
	}
	else if (nSubRace==RACIAL_SUBTYPE_AASIMAR)
	{
		_GrantChoosenLang(oPC, LNG_AQUAN);
		_GrantChoosenLang(oPC, LNG_AURAN);
		_GrantChoosenLang(oPC, LNG_CELESTIAL);
		_GrantChoosenLang(oPC, LNG_ELVEN);
		_GrantChoosenLang(oPC, LNG_IGNAN);
		_GrantChoosenLang(oPC, LNG_SYLVAN);
		_GrantChoosenLang(oPC, LNG_TERRAN);
	}	
	else if (nSubRace==RACIAL_SUBTYPE_TIEFLING)
	{
		_GrantChoosenLang(oPC, LNG_ABYSSAL);
		_GrantChoosenLang(oPC, LNG_AQUAN);
		_GrantChoosenLang(oPC, LNG_AURAN);
		_GrantChoosenLang(oPC, LNG_IGNAN);
		_GrantChoosenLang(oPC, LNG_INFERNAL);
		_GrantChoosenLang(oPC, LNG_SYLVAN);
		_GrantChoosenLang(oPC, LNG_TERRAN);
	}	
	else if (nSubRace==RACIAL_SUBTYPE_AIR_GENASI) {
		_GrantChoosenLang(oPC, LNG_AURAN);
	} else if (nSubRace==RACIAL_SUBTYPE_EARTH_GENASI) {
		_GrantChoosenLang(oPC, LNG_TERRAN);
	} else if (nSubRace==RACIAL_SUBTYPE_FIRE_GENASI) {
		_GrantChoosenLang(oPC, LNG_IGNAN);
	} else if (nSubRace==RACIAL_SUBTYPE_WATER_GENASI) {
		_GrantChoosenLang(oPC, LNG_AQUAN);
	}
}


void _AddBonusLanguagesByRegion(int nRegion, object oPC) {

	// we use this to initialize available bonus languages by current
	//  regions for level-ups.  In this case, the Automatic language for the reason
	//  might not already be known to oPC.  So, for any region that is Live or in Beta
	//  for ALFA, we'll add the Automatic regional language to the Bonus list as well.
	if (nRegion == FEAT_REGION_AGLAROND) {
		_GrantChoosenLang(oPC, LNG_CHESSENTAN);
		_GrantChoosenLang(oPC, LNG_DAMARAN);
		_GrantChoosenLang(oPC, LNG_DRACONIC);
		_GrantChoosenLang(oPC, LNG_ELVEN);
		_GrantChoosenLang(oPC, LNG_MULHORANDI);
		_GrantChoosenLang(oPC, LNG_ORC);
		_GrantChoosenLang(oPC, LNG_SYLVAN);	
		_GrantChoosenLang(oPC, LNG_UNTHERIC);
	} else if (nRegion == FEAT_REGION_ALTUMBEL) {
		_GrantChoosenLang(oPC, LNG_AQUAN);
		_GrantChoosenLang(oPC, LNG_CHESSENTAN);
		_GrantChoosenLang(oPC, LNG_CHONDATHAN);
		_GrantChoosenLang(oPC, LNG_RASHEMI);
		_GrantChoosenLang(oPC, LNG_SERUSAN);
		_GrantChoosenLang(oPC, LNG_UNTHERIC);
	} else if (nRegion == FEAT_REGION_AMN) {
		_GrantChoosenLang(oPC, LNG_CHONDATHAN); // Automatic language for Exodus' Amn
		_GrantChoosenLang(oPC, LNG_ALZHEDO);
		_GrantChoosenLang(oPC, LNG_ELVEN);
		_GrantChoosenLang(oPC, LNG_GIANT);
		_GrantChoosenLang(oPC, LNG_GOBLIN);
		//_GrantChoosenLang(oPC, LNG_ILLUSKAN); absent in PGtF list
		_GrantChoosenLang(oPC, LNG_NEXALAN);
		_GrantChoosenLang(oPC, LNG_ORC);
		_GrantChoosenLang(oPC, LNG_SHAARAN);
	} else if (nRegion == FEAT_REGION_ANAUROCH) {
		_GrantChoosenLang(oPC, LNG_CHONDATHAN);
		_GrantChoosenLang(oPC, LNG_DAMARAN);
		_GrantChoosenLang(oPC, LNG_DRACONIC);
		_GrantChoosenLang(oPC, LNG_GNOLL);
		_GrantChoosenLang(oPC, LNG_NETHERESE);  
		_GrantChoosenLang(oPC, LNG_ORC);
	} else if (nRegion == FEAT_REGION_CALIMSHAN) {
		_GrantChoosenLang(oPC, LNG_ALZHEDO);  // Automatic language
		_GrantChoosenLang(oPC, LNG_AURAN); 
		_GrantChoosenLang(oPC, LNG_CHONDATHAN);
		_GrantChoosenLang(oPC, LNG_CHULTAN);
		_GrantChoosenLang(oPC, LNG_DRACONIC);
		_GrantChoosenLang(oPC, LNG_IGNAN);
		_GrantChoosenLang(oPC, LNG_SHAARAN);
		_GrantChoosenLang(oPC, LNG_TASHALAN);
	} else if (nRegion == FEAT_REGION_CHESSENTA) {
		_GrantChoosenLang(oPC, LNG_ALGARONDAN);
		_GrantChoosenLang(oPC, LNG_CHONDATHAN);
		_GrantChoosenLang(oPC, LNG_DRACONIC);
		_GrantChoosenLang(oPC, LNG_MULHORANDI);
		_GrantChoosenLang(oPC, LNG_TURMIC);
		_GrantChoosenLang(oPC, LNG_UNTHERIC);
	} else if (nRegion == FEAT_REGION_CHONDALWOOD) {
		_GrantChoosenLang(oPC, LNG_CHESSENTAN);
		_GrantChoosenLang(oPC, LNG_CHONDATHAN);
		_GrantChoosenLang(oPC, LNG_ELVEN);
		_GrantChoosenLang(oPC, LNG_HALFLING);
		_GrantChoosenLang(oPC, LNG_GNOLL);
		_GrantChoosenLang(oPC, LNG_SHAARAN);
		_GrantChoosenLang(oPC, LNG_SYLVAN);	
		_GrantChoosenLang(oPC, LNG_UNTHERIC);		
	} else if (nRegion == FEAT_REGION_CHULT) {
		_GrantChoosenLang(oPC, LNG_ALZHEDO);
		_GrantChoosenLang(oPC, LNG_DRACONIC);
		_GrantChoosenLang(oPC, LNG_DWARF);
		_GrantChoosenLang(oPC, LNG_GOBLIN);
		_GrantChoosenLang(oPC, LNG_SHAARAN);
		_GrantChoosenLang(oPC, LNG_SYLVAN);
		_GrantChoosenLang(oPC, LNG_TASHALAN);
	} else if (nRegion == FEAT_REGION_CORMYR) {
		_GrantChoosenLang(oPC, LNG_ELVEN);
		_GrantChoosenLang(oPC, LNG_DAMARAN);
		_GrantChoosenLang(oPC, LNG_GNOME);
		_GrantChoosenLang(oPC, LNG_GOBLIN);
		_GrantChoosenLang(oPC, LNG_HALFLING);
		_GrantChoosenLang(oPC, LNG_ORC);	
		_GrantChoosenLang(oPC, LNG_TURMIC);
	} else if (nRegion == FEAT_REGION_DALELANDS) {
		_GrantChoosenLang(oPC, LNG_ELVEN);
		_GrantChoosenLang(oPC, LNG_DAMARAN);
		_GrantChoosenLang(oPC, LNG_GIANT);
		_GrantChoosenLang(oPC, LNG_GNOME);
		_GrantChoosenLang(oPC, LNG_ORC);	
		_GrantChoosenLang(oPC, LNG_SYLVAN);
	} else if (nRegion == FEAT_REGION_DAMARA) {
		_GrantChoosenLang(oPC, LNG_CHONDATHAN);
		_GrantChoosenLang(oPC, LNG_DWARF);
		_GrantChoosenLang(oPC, LNG_GIANT);
		_GrantChoosenLang(oPC, LNG_GOBLIN);
		_GrantChoosenLang(oPC, LNG_ORC);
		_GrantChoosenLang(oPC, LNG_ULUIK);
	} else if (nRegion == FEAT_REGION_DAMBRATH) {
		_GrantChoosenLang(oPC, LNG_DWARF);
		_GrantChoosenLang(oPC, LNG_ELVEN);
		_GrantChoosenLang(oPC, LNG_HALFLING);
		_GrantChoosenLang(oPC, LNG_HALRUAAN);
		_GrantChoosenLang(oPC, LNG_GNOLL);
		_GrantChoosenLang(oPC, LNG_ILLUSKAN);
		_GrantChoosenLang(oPC, LNG_SHAARAN);
		_GrantChoosenLang(oPC, LNG_UNDERCOMMON);
	} else if (nRegion == FEAT_REGION_DRAGON_COAST) {
		_GrantChoosenLang(oPC, LNG_ALGARONDAN);
		_GrantChoosenLang(oPC, LNG_CHESSENTAN);
		_GrantChoosenLang(oPC, LNG_DAMARAN);
		_GrantChoosenLang(oPC, LNG_GOBLIN);
		_GrantChoosenLang(oPC, LNG_HALFLING);
		_GrantChoosenLang(oPC, LNG_ORC);
		_GrantChoosenLang(oPC, LNG_TURMIC);
	} else if (nRegion == FEAT_REGION_DWARF_GOLD) {
		_GrantChoosenLang(oPC, LNG_GIANT);
		_GrantChoosenLang(oPC, LNG_GNOME);
		_GrantChoosenLang(oPC, LNG_GOBLIN);
		_GrantChoosenLang(oPC, LNG_SHAARAN);
		_GrantChoosenLang(oPC, LNG_TERRAN);
		_GrantChoosenLang(oPC, LNG_UNTHERIC);
	} else if (nRegion == FEAT_REGION_DWARF_GRAY) {
		_GrantChoosenLang(oPC, LNG_COMMON);
		_GrantChoosenLang(oPC, LNG_DRACONIC);
		_GrantChoosenLang(oPC, LNG_GIANT);
		_GrantChoosenLang(oPC, LNG_GOBLIN);
		_GrantChoosenLang(oPC, LNG_ORC);
		_GrantChoosenLang(oPC, LNG_TERRAN);
	} else if (nRegion == FEAT_REGION_DWARF_SHIELD) {
		_GrantChoosenLang(oPC, LNG_CHONDATHAN);
		_GrantChoosenLang(oPC, LNG_DRACONIC);
		_GrantChoosenLang(oPC, LNG_GIANT);
		_GrantChoosenLang(oPC, LNG_GOBLIN);
		_GrantChoosenLang(oPC, LNG_ILLUSKAN);
		_GrantChoosenLang(oPC, LNG_ORC);
	} else if (nRegion == FEAT_REGION_ELF_DROW) {
		_GrantChoosenLang(oPC, LNG_ABYSSAL);
		_GrantChoosenLang(oPC, LNG_COMMON);
		_GrantChoosenLang(oPC, LNG_DRACONIC);
		_GrantChoosenLang(oPC, LNG_DROWSIGN);
		_GrantChoosenLang(oPC, LNG_GOBLIN);
		_GrantChoosenLang(oPC, LNG_ILLUSKAN);
	} else if (nRegion == FEAT_REGION_ELF_MOON) {
		_GrantChoosenLang(oPC, LNG_AURAN);
		_GrantChoosenLang(oPC, LNG_CHONDATHAN);
		_GrantChoosenLang(oPC, LNG_GNOLL);
		_GrantChoosenLang(oPC, LNG_GNOME);
		_GrantChoosenLang(oPC, LNG_HALFLING);
		_GrantChoosenLang(oPC, LNG_ILLUSKAN);
		_GrantChoosenLang(oPC, LNG_SYLVAN);
	} else if (nRegion == FEAT_REGION_ELF_SUN) {
		_GrantChoosenLang(oPC, LNG_AURAN);
		_GrantChoosenLang(oPC, LNG_CELESTIAL);
		_GrantChoosenLang(oPC, LNG_CHONDATHAN);
		_GrantChoosenLang(oPC, LNG_GNOME);
		_GrantChoosenLang(oPC, LNG_HALFLING);
		_GrantChoosenLang(oPC, LNG_ILLUSKAN);
		_GrantChoosenLang(oPC, LNG_SYLVAN);
	} else if (nRegion == FEAT_REGION_ELF_WILD) {
		_GrantChoosenLang(oPC, LNG_GNOLL);
		_GrantChoosenLang(oPC, LNG_ILLUSKAN);
		_GrantChoosenLang(oPC, LNG_ORC);
		_GrantChoosenLang(oPC, LNG_SYLVAN);
		_GrantChoosenLang(oPC, LNG_TASHALAN);		
	} else if (nRegion == FEAT_REGION_ELF_WOOD) {
		_GrantChoosenLang(oPC, LNG_CHONDATHAN);
		_GrantChoosenLang(oPC, LNG_DRACONIC);
		_GrantChoosenLang(oPC, LNG_GNOLL);
		_GrantChoosenLang(oPC, LNG_GNOME);
		_GrantChoosenLang(oPC, LNG_GOBLIN);
		_GrantChoosenLang(oPC, LNG_SYLVAN);
	} else if (nRegion == FEAT_REGION_EVERMEET) {
		_GrantChoosenLang(oPC, LNG_AQUAN);
		_GrantChoosenLang(oPC, LNG_AURAN);
		_GrantChoosenLang(oPC, LNG_CELESTIAL);
		_GrantChoosenLang(oPC, LNG_CHONDATHAN);
		_GrantChoosenLang(oPC, LNG_ILLUSKAN);
		_GrantChoosenLang(oPC, LNG_SYLVAN);
	} else if (nRegion == FEAT_REGION_GNOME_DEEP) {
		_GrantChoosenLang(oPC, LNG_COMMON);
		_GrantChoosenLang(oPC, LNG_DRACONIC);
		_GrantChoosenLang(oPC, LNG_DWARF);
		_GrantChoosenLang(oPC, LNG_ELVEN);
		_GrantChoosenLang(oPC, LNG_ILLUSKAN);
		_GrantChoosenLang(oPC, LNG_TERRAN);
	} else if (nRegion == FEAT_REGION_GNOME_ROCK) {
		_GrantChoosenLang(oPC, LNG_CHONDATHAN);
		_GrantChoosenLang(oPC, LNG_DRACONIC);
		_GrantChoosenLang(oPC, LNG_DWARF);
		_GrantChoosenLang(oPC, LNG_GOBLIN);
		_GrantChoosenLang(oPC, LNG_ILLUSKAN);
		_GrantChoosenLang(oPC, LNG_SYLVAN);
		_GrantChoosenLang(oPC, LNG_TERRAN);
	} else if (nRegion == FEAT_REGION_GOLDEN_WATER) {
		_GrantChoosenLang(oPC, LNG_DRACONIC);
		_GrantChoosenLang(oPC, LNG_DWARF);
		_GrantChoosenLang(oPC, LNG_GIANT);
		_GrantChoosenLang(oPC, LNG_HALFLING);		
		_GrantChoosenLang(oPC, LNG_HALRUAAN);
		_GrantChoosenLang(oPC, LNG_MULHORANDI);
		_GrantChoosenLang(oPC, LNG_SHAARAN);
	} else if (nRegion == FEAT_REGION_GREAT_DALE) {
		_GrantChoosenLang(oPC, LNG_GIANT);
		_GrantChoosenLang(oPC, LNG_GOBLIN);
		_GrantChoosenLang(oPC, LNG_RASHEMI);
		_GrantChoosenLang(oPC, LNG_MULHORANDI);
		_GrantChoosenLang(oPC, LNG_SYLVAN);
	} else if (nRegion == FEAT_REGION_GREAT_GLACIER) {
		_GrantChoosenLang(oPC, LNG_AURAN);
		_GrantChoosenLang(oPC, LNG_DWARF);
		_GrantChoosenLang(oPC, LNG_DAMARAN);
		_GrantChoosenLang(oPC, LNG_ELVEN);
		_GrantChoosenLang(oPC, LNG_GIANT);
	} else if (nRegion == FEAT_REGION_HALFORC) {
		_GrantChoosenLang(oPC, LNG_DAMARAN);
		_GrantChoosenLang(oPC, LNG_GIANT);
		_GrantChoosenLang(oPC, LNG_GNOLL);
		_GrantChoosenLang(oPC, LNG_GOBLIN);
		_GrantChoosenLang(oPC, LNG_ILLUSKAN);
		_GrantChoosenLang(oPC, LNG_UNDERCOMMON);		
	} else if (nRegion == FEAT_REGION_HALFLING_GHOSTWISE) {
		_GrantChoosenLang(oPC, LNG_CHONDATHAN);
		_GrantChoosenLang(oPC, LNG_ELVEN);
		_GrantChoosenLang(oPC, LNG_GNOLL);
		_GrantChoosenLang(oPC, LNG_SHAARAN);
		_GrantChoosenLang(oPC, LNG_SYLVAN);
	} else if (nRegion == FEAT_REGION_HALFLING_LIGHTFOOT) {
		_GrantChoosenLang(oPC, LNG_CHESSENTAN);
		_GrantChoosenLang(oPC, LNG_CHONDATHAN);
		_GrantChoosenLang(oPC, LNG_DAMARAN);
		_GrantChoosenLang(oPC, LNG_DWARF);
		_GrantChoosenLang(oPC, LNG_ELVEN);
		_GrantChoosenLang(oPC, LNG_ILLUSKAN);
		_GrantChoosenLang(oPC, LNG_GOBLIN);	
	} else if (nRegion == FEAT_REGION_HALFLING_STRONGHEART) {
		_GrantChoosenLang(oPC, LNG_DWARF);
		_GrantChoosenLang(oPC, LNG_GNOLL);
		_GrantChoosenLang(oPC, LNG_GOBLIN);
		_GrantChoosenLang(oPC, LNG_HALRUAAN);
		_GrantChoosenLang(oPC, LNG_SHAARAN);
	} else if (nRegion == FEAT_REGION_HALRUAA) {
		_GrantChoosenLang(oPC, LNG_DAMBRATHAN);
		_GrantChoosenLang(oPC, LNG_ELVEN);
		_GrantChoosenLang(oPC, LNG_GOBLIN);
		_GrantChoosenLang(oPC, LNG_HALFLING);
		_GrantChoosenLang(oPC, LNG_SHAARAN);
		_GrantChoosenLang(oPC, LNG_TASHALAN);				
	} else if (nRegion == FEAT_REGION_HIGH_FOREST) {
		_GrantChoosenLang(oPC, LNG_ELVEN);
		_GrantChoosenLang(oPC, LNG_GNOLL);
		_GrantChoosenLang(oPC, LNG_GOBLIN);
		_GrantChoosenLang(oPC, LNG_HALFLING);
		_GrantChoosenLang(oPC, LNG_ILLUSKAN);
		_GrantChoosenLang(oPC, LNG_SYLVAN);
	} else if (nRegion == FEAT_REGION_HORDELANDS) {
		_GrantChoosenLang(oPC, LNG_DAMARAN);
		_GrantChoosenLang(oPC, LNG_GOBLIN);
		_GrantChoosenLang(oPC, LNG_MULHORANDI);
		_GrantChoosenLang(oPC, LNG_RASHEMI);
		_GrantChoosenLang(oPC, LNG_SHOU);
	} else 	if (nRegion == FEAT_REGION_IMPILTUR) {
		_GrantChoosenLang(oPC, LNG_ALGARONDAN);
		_GrantChoosenLang(oPC, LNG_CHESSENTAN);
		_GrantChoosenLang(oPC, LNG_CHONDATHAN);
		_GrantChoosenLang(oPC, LNG_DWARF);
		_GrantChoosenLang(oPC, LNG_GIANT);
		_GrantChoosenLang(oPC, LNG_GOBLIN);
		_GrantChoosenLang(oPC, LNG_MULHORANDI);
		_GrantChoosenLang(oPC, LNG_TURMIC);
	} else if (nRegion == FEAT_REGION_LAKE_OF_STEAM) {
		_GrantChoosenLang(oPC, LNG_ALZHEDO);
		_GrantChoosenLang(oPC, LNG_CHONDATHAN);
		_GrantChoosenLang(oPC, LNG_DWARF);
		_GrantChoosenLang(oPC, LNG_GOBLIN);
		_GrantChoosenLang(oPC, LNG_TASHALAN);	
	} else if (nRegion == FEAT_REGION_LAPALIIYA) {
		_GrantChoosenLang(oPC, LNG_ALZHEDO);
		_GrantChoosenLang(oPC, LNG_CHULTAN);
		_GrantChoosenLang(oPC, LNG_GNOLL);		
		_GrantChoosenLang(oPC, LNG_HALRUAAN);
		_GrantChoosenLang(oPC, LNG_SHAARAN);
		_GrantChoosenLang(oPC, LNG_YUANTI);
	} else if (nRegion == FEAT_REGION_LANTAN) {
		_GrantChoosenLang(oPC, LNG_ALZHEDO);
		_GrantChoosenLang(oPC, LNG_CHONDATHAN);
		_GrantChoosenLang(oPC, LNG_DWARF);
		_GrantChoosenLang(oPC, LNG_GNOME);
		_GrantChoosenLang(oPC, LNG_IGNAN);
		_GrantChoosenLang(oPC, LNG_ILLUSKAN);
		_GrantChoosenLang(oPC, LNG_SHAARAN);
	} else if (nRegion == FEAT_REGION_LUIREN) {
		_GrantChoosenLang(oPC, LNG_DWARF);
		_GrantChoosenLang(oPC, LNG_GNOLL);
		_GrantChoosenLang(oPC, LNG_GOBLIN);
		_GrantChoosenLang(oPC, LNG_HALRUAAN);
		_GrantChoosenLang(oPC, LNG_SHAARAN);
		_GrantChoosenLang(oPC, LNG_UNTHERIC);				
	} else if (nRegion == FEAT_REGION_MOONSEA) {
		_GrantChoosenLang(oPC, LNG_DAMARAN); // Automatic for ALFA 006
		_GrantChoosenLang(oPC, LNG_CHONDATHAN);
		_GrantChoosenLang(oPC, LNG_CHESSENTAN);
		_GrantChoosenLang(oPC, LNG_DRACONIC);
		_GrantChoosenLang(oPC, LNG_GIANT);
		_GrantChoosenLang(oPC, LNG_GOBLIN);
		// _GrantChoosenLang(oPC, LNG_MIDANI);  <-- no longer listed in PGtF
		_GrantChoosenLang(oPC, LNG_ORC);									
	} else if (nRegion == FEAT_REGION_MOONSHAE_ISLES) {
		_GrantChoosenLang(oPC, LNG_ILLUSKAN); // Automatic for ALFA 050
		_GrantChoosenLang(oPC, LNG_AQUAN);
		_GrantChoosenLang(oPC, LNG_CHONDATHAN);
		_GrantChoosenLang(oPC, LNG_ELVEN);
		_GrantChoosenLang(oPC, LNG_GIANT);
		_GrantChoosenLang(oPC, LNG_ORC);
		_GrantChoosenLang(oPC, LNG_SYLVAN);	
	} else if (nRegion == FEAT_REGION_MULHORAND) {
		_GrantChoosenLang(oPC, LNG_ALGARONDAN);
		_GrantChoosenLang(oPC, LNG_CHESSENTAN);
		_GrantChoosenLang(oPC, LNG_DRACONIC);		
		_GrantChoosenLang(oPC, LNG_DURPARI);
		_GrantChoosenLang(oPC, LNG_GOBLIN);		
		_GrantChoosenLang(oPC, LNG_TUIGAN);
		_GrantChoosenLang(oPC, LNG_UNTHERIC);
	} else if (nRegion == FEAT_REGION_NARFELL) {
		_GrantChoosenLang(oPC, LNG_GOBLIN);	
		_GrantChoosenLang(oPC, LNG_ORC);
		_GrantChoosenLang(oPC, LNG_RASHEMI);	
		_GrantChoosenLang(oPC, LNG_TUIGAN);
		_GrantChoosenLang(oPC, LNG_ULUIK);		
	} else if (nRegion == FEAT_REGION_NELANTHER) {
		_GrantChoosenLang(oPC, LNG_ALZHEDO);
		_GrantChoosenLang(oPC, LNG_GOBLIN);
		_GrantChoosenLang(oPC, LNG_ILLUSKAN);
		_GrantChoosenLang(oPC, LNG_LANTANESE);
		_GrantChoosenLang(oPC, LNG_ORC);
		_GrantChoosenLang(oPC, LNG_SHAARAN);		
	} else if (nRegion == FEAT_REGION_NORTH) {
		_GrantChoosenLang(oPC, LNG_ILLUSKAN);  // Automatic for ALFA 002
		_GrantChoosenLang(oPC, LNG_DWARF);
		_GrantChoosenLang(oPC, LNG_CHONDATHAN);
		_GrantChoosenLang(oPC, LNG_ELVEN);
		_GrantChoosenLang(oPC, LNG_GIANT);
		_GrantChoosenLang(oPC, LNG_GOBLIN);
		_GrantChoosenLang(oPC, LNG_ORC);
	} else if (nRegion == FEAT_REGION_ORC) { 
		_GrantChoosenLang(oPC, LNG_DAMARAN);
		_GrantChoosenLang(oPC, LNG_GIANT);
		_GrantChoosenLang(oPC, LNG_GNOLL);
		_GrantChoosenLang(oPC, LNG_GOBLIN);
		_GrantChoosenLang(oPC, LNG_ILLUSKAN);
		_GrantChoosenLang(oPC, LNG_UNDERCOMMON);
	} else if (nRegion == FEAT_REGION_RASHEMEN) {
		_GrantChoosenLang(oPC, LNG_ALGARONDAN);
		_GrantChoosenLang(oPC, LNG_DAMARAN);
		_GrantChoosenLang(oPC, LNG_GOBLIN);		
		_GrantChoosenLang(oPC, LNG_MULHORANDI);
		_GrantChoosenLang(oPC, LNG_TUIGAN);
	} else if (nRegion == FEAT_REGION_RIDE) {
		_GrantChoosenLang(oPC, LNG_CHONDATHAN);
		_GrantChoosenLang(oPC, LNG_GIANT);
		_GrantChoosenLang(oPC, LNG_GOBLIN);
		_GrantChoosenLang(oPC, LNG_ORC);		
		_GrantChoosenLang(oPC, LNG_RASHEMI);
	} else if (nRegion == FEAT_REGION_SEMBIA) {
		_GrantChoosenLang(oPC, LNG_CHESSENTAN);
		_GrantChoosenLang(oPC, LNG_DAMARAN);
		_GrantChoosenLang(oPC, LNG_GNOME);
		_GrantChoosenLang(oPC, LNG_HALFLING);
		_GrantChoosenLang(oPC, LNG_MULHORANDI);
		_GrantChoosenLang(oPC, LNG_SHAARAN);	
		_GrantChoosenLang(oPC, LNG_TURMIC);	
	} else if (nRegion == FEAT_REGION_SESPECH) {  
		_GrantChoosenLang(oPC, LNG_CHESSENTAN);
		_GrantChoosenLang(oPC, LNG_CHONDATHAN);
		_GrantChoosenLang(oPC, LNG_DAMARAN);
		_GrantChoosenLang(oPC, LNG_DRACONIC);
		_GrantChoosenLang(oPC, LNG_ELVEN);
		_GrantChoosenLang(oPC, LNG_GOBLIN);
		_GrantChoosenLang(oPC, LNG_TURMIC);		
	} else if (nRegion == FEAT_REGION_SHAAR) {
		_GrantChoosenLang(oPC, LNG_ALZHEDO);
		_GrantChoosenLang(oPC, LNG_DAMBRATHAN);
		_GrantChoosenLang(oPC, LNG_DURPARI);
		_GrantChoosenLang(oPC, LNG_DWARF);
		_GrantChoosenLang(oPC, LNG_GNOLL);
		_GrantChoosenLang(oPC, LNG_HALRUAAN);
		//_GrantChoosenLang(oPC, LNG_MULHORANDI); <-- no longer listed in PGtF
		_GrantChoosenLang(oPC, LNG_TASHALAN);
		_GrantChoosenLang(oPC, LNG_UNTHERIC);
	} else if (nRegion == FEAT_REGION_SHADOVAR) {  
		_GrantChoosenLang(oPC, LNG_CHONDATHAN);
		_GrantChoosenLang(oPC, LNG_DAMARAN);
		_GrantChoosenLang(oPC, LNG_DRACONIC);
		_GrantChoosenLang(oPC, LNG_ELVEN);
		_GrantChoosenLang(oPC, LNG_LOROSS);
		//_GrantChoosenLang(oPC, LNG_THOROSS);	<-- dead language, unimplemented
	} else if (nRegion == FEAT_REGION_SHOU_EXPATRIATE) {  
		_GrantChoosenLang(oPC, LNG_DRACONIC);
		_GrantChoosenLang(oPC, LNG_DURPARI);
		_GrantChoosenLang(oPC, LNG_GOBLIN);
		_GrantChoosenLang(oPC, LNG_MULHORANDI);	
		_GrantChoosenLang(oPC, LNG_RASHEMI);
		_GrantChoosenLang(oPC, LNG_TUIGAN);							
	} else if (nRegion == FEAT_REGION_SILVER_MARCHES) {
		_GrantChoosenLang(oPC, LNG_CHONDATHAN); // Automatic for ALFA 003
		_GrantChoosenLang(oPC, LNG_DWARF);
		_GrantChoosenLang(oPC, LNG_ELVEN);
		_GrantChoosenLang(oPC, LNG_GIANT);
		_GrantChoosenLang(oPC, LNG_ILLUSKAN);
		//_GrantChoosenLang(oPC, LNG_MIDANI); <-- no longer listed in PGtF
		_GrantChoosenLang(oPC, LNG_ORC);
		_GrantChoosenLang(oPC, LNG_SYLVAN);
	} else if (nRegion == FEAT_REGION_SWORD_COAST) {
		_GrantChoosenLang(oPC, LNG_ILLUSKAN); // Automatic for near 010
		_GrantChoosenLang(oPC, LNG_CHONDATHAN);
		_GrantChoosenLang(oPC, LNG_DWARF);		
		_GrantChoosenLang(oPC, LNG_GIANT);
		_GrantChoosenLang(oPC, LNG_HALFLING);
		_GrantChoosenLang(oPC, LNG_ORC);
	} else if (nRegion == FEAT_REGION_TASHALAR) {
		_GrantChoosenLang(oPC, LNG_ALZHEDO);
		_GrantChoosenLang(oPC, LNG_CHULTAN);
		_GrantChoosenLang(oPC, LNG_DRACONIC);
		_GrantChoosenLang(oPC, LNG_ILLUSKAN);
		_GrantChoosenLang(oPC, LNG_ORC);
		_GrantChoosenLang(oPC, LNG_SHAARAN);
		//_GrantChoosenLang(oPC, LNG_SYLVAN); <-- no longer listed in PGtF
		_GrantChoosenLang(oPC, LNG_YUANTI);
	} else if (nRegion == FEAT_REGION_TETHYR) {
		_GrantChoosenLang(oPC, LNG_CHONDATHAN); // Automatic for proposed Tethyr
		_GrantChoosenLang(oPC, LNG_ALZHEDO);
		_GrantChoosenLang(oPC, LNG_ELVEN);
		_GrantChoosenLang(oPC, LNG_GOBLIN);
		//_GrantChoosenLang(oPC, LNG_ILLUSKAN); <-- no longer listed in PGtF
		_GrantChoosenLang(oPC, LNG_LANTANESE);
		//_GrantChoosenLang(oPC, LNG_SHAARAN); <-- no longer listed in PGtF
		//_GrantChoosenLang(oPC, LNG_SYLVAN); <-- no longer listed in PGtF
		_GrantChoosenLang(oPC, LNG_ORC);	
	} else if (nRegion == FEAT_REGION_THAY) {
		_GrantChoosenLang(oPC, LNG_CHESSENTAN);
		_GrantChoosenLang(oPC, LNG_DAMARAN);
		_GrantChoosenLang(oPC, LNG_INFERNAL);
		_GrantChoosenLang(oPC, LNG_RASHEMI);
		_GrantChoosenLang(oPC, LNG_TUIGAN);
		_GrantChoosenLang(oPC, LNG_UNTHERIC);	
	} else if (nRegion == FEAT_REGION_THESK) {
		_GrantChoosenLang(oPC, LNG_ALGARONDAN);
		_GrantChoosenLang(oPC, LNG_CHONDATHAN);
		_GrantChoosenLang(oPC, LNG_GIANT);
		_GrantChoosenLang(oPC, LNG_GNOLL);
		_GrantChoosenLang(oPC, LNG_MULHORANDI);
		_GrantChoosenLang(oPC, LNG_ORC);
		_GrantChoosenLang(oPC, LNG_RASHEMI);
		_GrantChoosenLang(oPC, LNG_TUIGAN);
		// _GrantChoosenLang(oPC, LNG_TURMIC); <-- no longer listed in PGtF
		_GrantChoosenLang(oPC, LNG_SHOU);
	} else if (nRegion == FEAT_REGION_TURMISH) {
		_GrantChoosenLang(oPC, LNG_CHESSENTAN);
		_GrantChoosenLang(oPC, LNG_CHONDATHAN);
		_GrantChoosenLang(oPC, LNG_DRACONIC);
		_GrantChoosenLang(oPC, LNG_DWARF);
		_GrantChoosenLang(oPC, LNG_IGNAN);
		_GrantChoosenLang(oPC, LNG_SHAARAN);
	} else if (nRegion == FEAT_REGION_UNTHER) {
		_GrantChoosenLang(oPC, LNG_CHESSENTAN);
		_GrantChoosenLang(oPC, LNG_DRACONIC);
		_GrantChoosenLang(oPC, LNG_MULHORANDI);
		_GrantChoosenLang(oPC, LNG_ORC);
		_GrantChoosenLang(oPC, LNG_SHAARAN);
	} else if (nRegion == FEAT_REGION_UTHGART) {
		_GrantChoosenLang(oPC, LNG_CHONDATHAN);
		_GrantChoosenLang(oPC, LNG_DWARF);
		_GrantChoosenLang(oPC, LNG_ELVEN);
		_GrantChoosenLang(oPC, LNG_GIANT);
		_GrantChoosenLang(oPC, LNG_ORC);
	} else if (nRegion == FEAT_REGION_VAASA) {
		_GrantChoosenLang(oPC, LNG_ABYSSAL);
		_GrantChoosenLang(oPC, LNG_GIANT);
		_GrantChoosenLang(oPC, LNG_GOBLIN);
		_GrantChoosenLang(oPC, LNG_ORC);
		_GrantChoosenLang(oPC, LNG_ULUIK);
	} else if (nRegion == FEAT_REGION_VAST) {
		_GrantChoosenLang(oPC, LNG_ALGARONDAN);
		_GrantChoosenLang(oPC, LNG_CHONDATHAN);
		_GrantChoosenLang(oPC, LNG_DWARF);
		_GrantChoosenLang(oPC, LNG_GIANT);
		_GrantChoosenLang(oPC, LNG_GOBLIN);
		// _GrantChoosenLang(oPC, LNG_MULHORANDI); <-- no longer listed in PGtF
		_GrantChoosenLang(oPC, LNG_ORC);
		_GrantChoosenLang(oPC, LNG_RASHEMI);
		//_GrantChoosenLang(oPC, LNG_TUIGAN); <-- no longer listed in PGtF
		//_GrantChoosenLang(oPC, LNG_TURMIC); <-- no longer listed in PGtF
		//_GrantChoosenLang(oPC, LNG_SHOU); <-- no longer listed in PGtF
	} else if (nRegion == FEAT_REGION_VILHON_REACH) {
		_GrantChoosenLang(oPC, LNG_CHESSENTAN);
		_GrantChoosenLang(oPC, LNG_DAMARAN);
		_GrantChoosenLang(oPC, LNG_DRACONIC);
		_GrantChoosenLang(oPC, LNG_ELVEN);
		//_GrantChoosenLang(oPC, LNG_GOBLIN); <-- no longer listed in PGtF
		_GrantChoosenLang(oPC, LNG_SHAARAN);
		_GrantChoosenLang(oPC, LNG_TURMIC);				
	} else if (nRegion == FEAT_REGION_WATERDEEP) {
		_GrantChoosenLang(oPC, LNG_CHONDATHAN); // Automatic for ALFA 001
		_GrantChoosenLang(oPC, LNG_DWARF);
		_GrantChoosenLang(oPC, LNG_ELVEN);
		_GrantChoosenLang(oPC, LNG_GIANT);
		//_GrantChoosenLang(oPC, LNG_GOBLIN); <-- no longer listed in PGtF
		_GrantChoosenLang(oPC, LNG_HALFLING);
		_GrantChoosenLang(oPC, LNG_ILLUSKAN);
		_GrantChoosenLang(oPC, LNG_ORC);	
	} else if (nRegion == FEAT_REGION_WESTERN_HEARTLANDS) {
		_GrantChoosenLang(oPC, LNG_CHONDATHAN); // Automatic for ALFA 010 and 011
		_GrantChoosenLang(oPC, LNG_ELVEN);
		_GrantChoosenLang(oPC, LNG_GIANT);
		_GrantChoosenLang(oPC, LNG_GOBLIN);
		_GrantChoosenLang(oPC, LNG_ILLUSKAN);
		_GrantChoosenLang(oPC, LNG_MIDANI);
		_GrantChoosenLang(oPC, LNG_ORC);
		_GrantChoosenLang(oPC, LNG_TURMIC);
	} else if (nRegion == FEAT_REGION_WIZARDS_REACH) {
		_GrantChoosenLang(oPC, LNG_ALGARONDAN);
		_GrantChoosenLang(oPC, LNG_CHESSENTAN);
		_GrantChoosenLang(oPC, LNG_ELVEN);		
		_GrantChoosenLang(oPC, LNG_MULHORANDI);
		_GrantChoosenLang(oPC, LNG_ORC);
		_GrantChoosenLang(oPC, LNG_SERUSAN);
	} else {
		SendMessageToPC(oPC, "ERROR: Bonus Langs by Region: Starting region "+IntToString(nRegion)+" not yet implemented.");
	}
}

object _GetDMFITool(object oPC) {

	object oTool = OBJECT_INVALID;
  	if (GetIsPossessedFamiliar(oPC))
		oTool = GetLocalObject(GetMaster(oPC), "DMFITool");
	else
		oTool = GetLocalObject(oPC, "DMFITool");

	return oTool;
}

int _IsLanguageKnown(object oPC, string sLang)
{ 
    //Purpose: Returns TRUE / FALSE whether sLang is known
    //Original Scripter: Demetrious
    //Last Modified By: Demetrious 6/28/6
    object oTool = _GetDMFITool(oPC);
    int n;
    int nMax = GetLocalInt(oTool, "LanguageMAX");
    string sTest;
    // All languages stored in lower case strings.
    sLang = GetStringLowerCase(sLang);
    for (n=0; n<nMax; n++)
    {
        sTest = GetLocalString(oTool, "Language" + IntToString(n));
        if (sTest == sLang) return TRUE;

        // Elven and drow are different dialects of the same language, and should be treated mechanically
        // as the same language, even though they sound quite different.
        if ((sTest == "drow" || sTest == "elven") &&
            (sLang == "drow" || sLang == "elven"))
              return TRUE;
    }
    return FALSE;
}


void _GrantLanguage(object oPC, string sLang)
{  //Purpose: Sets sLang as a valid Language for oPC.
   //Original Scripter: Demetrious
   //Last Modified By: Demetrious 1/1/7
   	object oTool = _GetDMFITool(oPC);
   	if (!_IsLanguageKnown(oPC, sLang))
   	{   
   		int n = GetLocalInt(oTool, "LanguageMAX");
		SendMessageToPC(oPC, "Language Granted: "+sLang);
   		//SendText(oPC, TXT_LANGUAGE + sLang, FALSE, COLOR_GREY);
   		sLang = GetStringLowerCase(sLang);
   		SetLocalString(oTool, "Language" + IntToString(n), sLang);
   		n++;
   		SetLocalInt(oTool, "LanguageMAX", n);
	}
	else {
	    //SendText(oPC, TXT_LANGUAGE_KNOWN + DMFI_CapitalizeWord(sLang), FALSE, COLOR_GREY);
		//SendMessageToPC(oPC, "Language "+sLang+" already known!");
	}
}

void _GrantChoosenLang(object oPC, string sLang)
{
	// AcadiusLost 2008/09/17 - added check to keep a possible language from adding twice.
	object oTool = _GetDMFITool(oPC);
	
	if (!_IsLanguageKnown(oPC, sLang)) 
		_AddUniqueStringElement(_CapitalizeWord(sLang), "LIST_POSSLANGUAGE", oTool);

}		

// Deletes the list and all contents.  Returns the number
// of elements deleted in the process.
int _DeleteList( string list, object holder = OBJECT_SELF )
{
    int count = _GetElementCount( list, holder );
    if( count == 0 )
        return( count );

    // Delete all elements
    int i;
    for( i = 0; i <= count; i++ )
        {
        string current = _IndexToString( i, list );
        DeleteLocalFloat( holder, current );
        DeleteLocalInt( holder, current );
        DeleteLocalLocation( holder, current );
        DeleteLocalObject( holder, current );
        DeleteLocalString( holder, current );
        }

    // Delete the main list info
    DeleteLocalInt( holder, "pgList:" + list );

    return( count );
}

void _ShowDMFIListUI(object oPC, string sScreen="SCREEN_DMFI_DMLIST")
{ //Purpose: Shows the DM list - builds the 30 entries and handles page updates.
  //Original Scripter: Demetrious
  //Last Modified By: Demetrious 12/27/6
	
    string sDMListTitle;
	string sPage, sTest, sTitle;
	int nPage, n, nCurrent, nModal;
	object oTool = _GetDMFITool(oPC);

	if (sScreen=="SCREEN_DMFI_CHOOSE")
		nModal=TRUE;
	else
		nModal=FALSE;
			
	DisplayGuiScreen(oPC, sScreen, nModal, "dmfidmlist.xml");
	sPage = GetLocalString(oPC, "DMFI_UI_PAGE");
	sTitle = GetLocalString(oPC, "DMFILISTTITLE");
	SetGUIObjectText(oPC, sScreen, "DMListTitle", -1, sTitle);
	
	nPage = GetLocalInt(oPC, sPage + "CURRENT");
		
	n = 0;
	while (n<31)
	{
		nCurrent = (nPage*30) + n;
		sTest = GetLocalString(oTool, "pgList:" + sPage + "." + IntToString(nCurrent));
		
		if (sTest!="")
		{
			SetGUIObjectText(oPC, sScreen, "dmlist"+IntToString(n+1), -1, sTest);
			SetGUIObjectHidden(oPC, sScreen, "btn"+IntToString(n+1), FALSE);
		}	
		else
		{
			SetGUIObjectText(oPC, sScreen, "dmlist"+IntToString(n+1), -1, "");
			SetGUIObjectHidden(oPC, sScreen, "btn"+IntToString(n+1), TRUE);
		}	
		n++;
	}
		
	//next and previous buttons
	sTest = GetLocalString(oTool, "pgList:" + sPage + "." + IntToString(nCurrent));
	
	if ((sTest=="")	|| (sScreen!="SCREEN_DMFI_DMLIST"))
		SetGUIObjectHidden(oPC, sScreen, "btn-next", TRUE);
	else
		SetGUIObjectHidden(oPC, sScreen, "btn-next", FALSE);	
			
	if ((nPage==0) || (sScreen!="SCREEN_DMFI_DMLIST")) 
		SetGUIObjectHidden(oPC, sScreen, "btn-prev", TRUE);
	else 
		SetGUIObjectHidden(oPC, sScreen, "btn-prev", FALSE);	
}

string _CapitalizeWord(string sWord)
{  //Purpose: Will return a capitalized version of sWord.  Will cap any word
   // following a space and includes special cases like PC.
   //Original Scripter: Demetrious
   //Last Modified By: Demetrious 6/18/6

// Special Cases
   if (sWord=="pc") return "PC";
   else if (sWord=="dm") return "DM";
   else if (sWord=="dc") return "DC";

// Routine Phrases
 	int nLength = GetStringLength(sWord);
    string sReturn = GetStringUpperCase(GetStringLeft(sWord, 1)) + GetStringRight(sWord, nLength-1);
	
	return sReturn;
}

// Adds a string item to the list and return the new item count.
int _AddStringElement( string item, string list, object holder = OBJECT_SELF )
{
    int count = _GetElementCount( list, holder );
    SetLocalString( holder, _IndexToString( count, list ), item );
    count++;
    SetLocalInt( holder, "pgList:" + list, count );

    return( count );
}

// Adds a string item to the list and return the new item count (no duplicates).
int _AddUniqueStringElement( string sItem, string sList, object oHolder = OBJECT_SELF )
{
    int count = _GetElementCount( sList, oHolder );
	int nIndex = 0;
	while (nIndex <= count) {
		if (sItem == GetLocalString(oHolder, _IndexToString( nIndex, sList ))) {
			// item is already on the list, skip out
			// SendMessageToPC(GetFirstPC(), "Item: "+sItem+" already in "+sList);
			nIndex = count + 5;
		} else { nIndex = nIndex + 1; }
	}
	if (nIndex != (count + 5)) {
    	SetLocalString( oHolder, _IndexToString( nIndex, sList ), sItem );
    	count++;
    	SetLocalInt( oHolder, "pgList:" + sList, count );
	}
    return( count );
}

// Returns the number of items in the specified list.
int _GetElementCount( string list, object holder = OBJECT_SELF )
{
    return( GetLocalInt( holder, "pgList:" + list ) );
}

// Internal function to get the string for a given
// index
string _IndexToString( int index, string list )
{
    return( "pgList:" + list + "." + IntToString(index) );
}

// junk the DMFI tool so the languages can be reassigned
void _WipeLanguages(object oPC) {

	object oTool = _GetDMFITool(oPC);
	SetPlotFlag(oTool, FALSE);
	DestroyObject(oTool);
	
	//sVersion = GetCampaignString("DMFIDatabase", "DMFIToolVersion");
	oTool = CreateItemOnObject("dmfi_exe_pc", oPC);
	SetLocalObject(oTool, "DMFIToolPC", oPC);
	SetLocalObject(oPC, "DMFITool", oTool);
	SetDroppableFlag(oTool, FALSE);
	
 	// DMFI_InitializeModule(oPC);
  	DelayCommand(2.0, _ReInitializeDMFITool(oPC, oTool));
}


void _ReInitializeDMFITool(object oPC, object oTool) {

		ExecuteScript("dmfi_conv_def_pc", oTool);
		//DelayCommand(20.0, DMFI_StoreTool(oPC, "dmfi_exe_pc", oTool));
		//DelayCommand(22.0, SendTalkText(oPC, PRM_ + TXT_PCTOOL_STORED, COLOR_RED, TALKVOLUME_SHOUT));
		//} else {
		//	DMFI_InitializeLanguage(oPC, oTool);
		//}
}

string ACR_LangIDToString(string s_id)
{
	if (s_id == LNG_COMMON)
		return "Common";
	else if (s_id == LNG_ANIMAL)
		return "Animal";
	else if (s_id == LNG_ASSASSIN)
		return "Assassin";
	else if (s_id == LNG_ASSASSIN)
		return "Abyssal";
	else if (s_id == LNG_ALZHEDO)
		return "Alzhedo";
	else if (s_id == LNG_AQUAN)
		return "Aquan";
	else if (s_id == LNG_AURAN)
		return "Auran";
	else if (s_id == LNG_ALGARONDAN)
		return "Algarondan";
	else if (s_id == LNG_CANT)
		return "Thieves' Cant";
	else if (s_id == LNG_CELESTIAL)
		return "Celestial";
	else if (s_id == LNG_CHESSENTAN)
		return "Chessentan";
	else if (s_id == LNG_CHONDATHAN)
		return "Chondathan";
	else if (s_id == LNG_CHULTAN)
		return "Chultan";
	else if (s_id == LNG_DWARF)
		return "Dwarven";
	else if (s_id == LNG_DROW)
		return "Drow";
	else if (s_id == LNG_DROWSIGN)
		return "Drow Sign";
	else if (s_id == LNG_DRUIDIC)
		return "Druidic";
	else if (s_id == LNG_DRACONIC)
		return "Draconic";
	else if (s_id == LNG_DAMARAN)
		return "Damaran";
	else if (s_id == LNG_DAMBRATHAN)
		return "Dambrathan";
	else if (s_id == LNG_DURPARI)
		return "Durpari";
	else if (s_id == LNG_ELVEN)
		return "Elven";
	else if (s_id == LNG_GNOME)
		return "Gnomish";
	else if (s_id == LNG_GOBLIN)
		return "Goblin";
	else if (s_id == LNG_GIANT)
		return "Giant";
	else if (s_id == LNG_GNOLL)
		return "Gnoll";
	else if (s_id == LNG_HALFLING)
		return "Halfling";
	else if (s_id == LNG_IGNAN)
		return "Ignan";
	else if (s_id == LNG_HALARDRIM)
		return "Halardrim";
	else if (s_id == LNG_HALRUAAN)
		return "Halruaan";
	else if (s_id == LNG_ILLUSKAN)
		return "Illuskan";
	else if (s_id == LNG_IMASKAR)
		return "Imaskar";
	else if (s_id == LNG_INFERNAL)
		return "Infernal";
	else if (s_id == LNG_LEETSPEAK)
		return "Leet";
	else if (s_id == LNG_LANTANESE)
		return "Lantanese";
	else if (s_id == LNG_LOROSS)
		return "Loross";
	else if (s_id == LNG_MIDANI)
		return "Midani";
	else if (s_id == LNG_MULHORANDI)
		return "Mulhorandi";
	else if (s_id == LNG_NETHERESE)
		return "Netherese";
	else if (s_id == LNG_RASHEMI)
		return "Rashemi";
	else if (s_id == LNG_SERUSAN)
		return "Serusan";
	else if (s_id == LNG_SHAARAN)
		return "Sharran";
	else if (s_id == LNG_SHOU)
		return "Shou";
	else if (s_id == LNG_SYLVAN)
		return "Sylvan";
	else if (s_id == LNG_TERRAN)
		return "Terran";
	else if (s_id == LNG_TREANT)
		return "Treant";
	else if (s_id == LNG_TASHALAN)
		return "Tashalan";
	else if (s_id == LNG_TUIGAN)
		return "Tuigan";
	else if (s_id == LNG_TURMIC)
		return "Turmic";
	else if (s_id == LNG_ORC)
		return "Orc";
	else if (s_id == LNG_NEXALAN)
		return "Nexalan";
	else if (s_id == LNG_YUANTI)
		return "Yuan-Ti";
	else if (s_id == LNG_UNDERCOMMON)
		return "Undercommon";
	else if (s_id == LNG_ULUIK)
		return "Uluik";
	else if (s_id == LNG_UNTHERIC)
		return "Untheric";
	else if (s_id == LNG_VAASAN)
		return "Vaasan";

	return "Invalid Language";
}


string ACR_LangAbbToLangID(string sLang)
{
	sLang = GetStringLowerCase(GetStringLeft(sLang,3));

	if (sLang == "com")
		 return LNG_COMMON;
	else if (sLang == "anm")
		 return LNG_ANIMAL;
	else if (sLang == "ass")
		 return LNG_ASSASSIN;
	else if (sLang == "aby")
		 return LNG_ASSASSIN;
	else if (sLang == "alz")
		 return LNG_ALZHEDO;
	else if (sLang == "aqu")
		 return LNG_AQUAN;
	else if (sLang == "aur")
		 return LNG_AURAN;
	else if (sLang == "alg")
		 return LNG_ALGARONDAN;
	else if (sLang == "can")
		 return LNG_CANT;
	else if (sLang == "cel")
		 return LNG_CELESTIAL;
	else if (sLang == "che")
		 return LNG_CHESSENTAN;
	else if (sLang == "cho")
		 return LNG_CHONDATHAN;
	else if (sLang == "chu")
		 return LNG_CHULTAN;
	else if (sLang == "dwa")
		 return LNG_DWARF;
	else if (sLang == "dro")
		 return LNG_DROW;
	else if (sLang == "drs")
		 return LNG_DROWSIGN;
	else if (sLang == "dru")
		 return LNG_DRUIDIC;
	else if (sLang == "dra")
		 return LNG_DRACONIC;
	else if (sLang == "dam")
		 return LNG_DAMARAN;
	else if (sLang == "dmb")
		 return LNG_DAMBRATHAN;
	else if (sLang == "dur")
		 return LNG_DURPARI;
	else if (sLang == "elf")
		 return LNG_ELVEN;
	else if (sLang == "gno")
		 return LNG_GNOME;
	else if (sLang == "gob")
		 return LNG_GOBLIN;
	else if (sLang == "gia")
		 return LNG_GIANT;
	else if (sLang == "gnl")
		 return LNG_GNOLL;
	else if (sLang == "hlf")
		 return LNG_HALFLING;
	else if (sLang == "ign")
		 return LNG_IGNAN;
	else if (sLang == "hdr")
		 return LNG_HALARDRIM;
	else if (sLang == "hlr")
		 return LNG_HALRUAAN;
	else if (sLang == "ill")
		 return LNG_ILLUSKAN;
	else if (sLang == "ims")
		 return LNG_IMASKAR;
	else if (sLang == "inf")
		 return LNG_INFERNAL;
	else if (sLang == "l37")
		 return LNG_LEETSPEAK;
	else if (sLang == "lan")
		 return LNG_LANTANESE;
	else if (sLang == "lor")
		 return LNG_LOROSS;
	else if (sLang == "mid")
		 return LNG_MIDANI;
	else if (sLang == "mul")
		 return LNG_MULHORANDI;
	else if (sLang == "nth")
		 return LNG_NETHERESE;
	else if (sLang == "rsh")
		 return LNG_RASHEMI;
	else if (sLang == "ser")
		 return LNG_SERUSAN;
	else if (sLang == "sha")
		 return LNG_SHAARAN;
	else if (sLang == "sho")
		 return LNG_SHOU;
	else if (sLang == "syl")
		 return LNG_SYLVAN;
	else if (sLang == "ter")
		 return LNG_TERRAN;
	else if (sLang == "tre")
		 return LNG_TREANT;
	else if (sLang == "tsh")
		 return LNG_TASHALAN;
	else if (sLang == "tui")
		 return LNG_TUIGAN;
	else if (sLang == "tur")
		 return LNG_TURMIC;
	else if (sLang == "orc")
		 return LNG_ORC;
	else if (sLang == "nex")
		 return LNG_NEXALAN;
	else if (sLang == "yti")
		 return LNG_YUANTI;
	else if (sLang == "und")
		 return LNG_UNDERCOMMON;
	else if (sLang == "ulu")
		 return LNG_ULUIK;
	else if (sLang == "unt")
		 return LNG_UNTHERIC;
	else if (sLang == "vas")
		 return LNG_VAASAN;
	
	return "invalidlanguage";
}

string _RemoveLangTag(string sText)
{
	string sLeft,sRight;
	int n,len;

	len = GetStringLength(sText);

	n = FindSubString(sText,"@");
	sLeft = GetStringLeft(sText, n);

	n = FindSubString(sText," ",n);
	sRight = GetSubString(sText, n+1, len-n);

	return sLeft+sRight;
}
