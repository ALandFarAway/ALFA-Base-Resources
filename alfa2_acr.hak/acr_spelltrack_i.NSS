////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_spelltrack_i
//    $Revision:: 556        $ current version of the file
//        $Date:: 2010-03-16#$ date the file was created or modified
//       Author : Cipher
//
//    Var Prefix: ACR_SPT
//  Dependencies: None
//
//  Description
//  This file contains the spell tracking code necessary to support both the
//  resting and persistent pc status systems.
//
//  Revision History
//  2006/08/18  Cipher  Inception
//  2006/09/09  Cipher  Changed ALFA prefix to ACR
//  2006/09/19  Cipher  Updated references to PC persistence functions
//  2007/06/06  Cipher  Graduated _playerHasCasterClass() to a public function
//  2007/06/25  Cipher  Retrofit persistence calls with NWNX functions
//  2007/07/15  Cipher  Revised spell tracking method
//  2007/08/20  Cipher  Reworked spell tracking per class
//  2007/10/24 AcadiusLost Added handling for Favored Soul and Spirit Shaman to 
//           ACR_HasCasterClass()
//  2007/11/13 AcadiusLost Added handling for scroll use by PnP rules.
//  2007/11/17 AcadiusLost Added UMD checks, ACR_GetCasterLevel(), ACR_GetMinSpellCL()
//  2007/11/19 AcadiusLost Improved mishap handling, abstracted mishap function.
//  2008/08/30 AcadiusLost Switched out RandomFloat for ACR_RandomFloat
//  2009/03/24 AcadiusLost Added special handling for UMD activation of cantrip scrolls.
//  2010/03/16 AcadiusLost Added synergy bonus for Decipher Script ranks in UMD scroll activation.
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#include "acr_i"
#include "x2_inc_switches"
#include "acr_tools_i"

#include "acr_db_persist_i"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! this is the total number of spells in the game
//! this is a workaround for knowing the spells a player has in their spell book
const int SPELL_ID_COUNT = 1123;

//! this local variable is used as a prefix for tracking uses per spell
const string ACR_SPT_SPELL_USES = "ACR_SPT_SPELL_USES";
const string ACR_SPT_SPELL = "ACR_SPT_SPELL";

//! spell use array string delimiter
const string ACR_SPT_DELIMITER = "#";

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! *** PUBLIC FUNCTIONS ***

//! This function updates the persistent spell uses for a specific spell
//! This should be called from the global spell hook function
//!  - oCaster: player who cast the spell
//!  - Returns: nothing
void ACR_RecordSpellUses(object oCaster, int nSpellId);

//! This function removes all the caster's logged spell uses
//!  - oCaster: player who's spell uses to remove
//!  - sClasses: comma separated list of CLASS_TYPE_* integers to clear logs for, or empty for all
//!  - Returns: nothing
void ACR_RemoveSpellUses(object oCaster, string sClasses = "");

//! This function restores the caster's spell uses from persistent spell logs
//!  - oCaster: player who's spell uses to restore
//!  - Returns: nothing
void ACR_RestoreSpellUses(object oCaster);

//! This function determines if a player has any levels in casting base classes.
//!  - oPC: player being examined
//!  - sType:
//!  -  ALL - All caster classes
//!  -  ARCANE - All arcane caster classes that need to prepare spells
//!  -  INNATE - All arcane caster classes that need not prepare spells
//!  -  DIVINE - All divine caster classes that needs to pray for spells
//!  - Returns:
//!     1 - has caster base class levels
//!     0 - has no caster base class levels
int ACR_HasCasterClass(object oPC, string sType = "ALL");

//!  This function calculates a PC's effective caster level, based on their 
//!   levels in the requested class.  Handles special cases like paladin/rangers too.
//!     - oPC: target to calculate caster level for
//!     - nCasterClass = CLASS_TYPE_*
//!   Returns:
//!     -1 : no caster level
//!      0 : CL 0 , etc
int ACR_GetCasterLevel(object oPC, int nCasterClass);

//!  This function returns the minimum caster level for a given spell of a
//!   given caster class.  It does calculations based on the spell progression
//!   of the caster class in question.
int ACR_GetMinSpellCL(int nSpellLevel, int nSpellClass);


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

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// *** BEGIN PUBLIC FUNCTIONS ***
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// *** BEGIN PUBLIC FUNCTIONS ***
////////////////////////////////////////////////////////////////////////////////

void ACR_RecordSpellUses(object oCaster, int nSpellId)
{
    // make sure the caster is a PC
    if (!GetIsPC(oCaster) || GetIsDM(oCaster) || GetIsDMPossessed(oCaster)) { return; }
	
	string sValues, sSpellId, sSpellUses, sClass = IntToString(GetLastSpellCastClass());
	int nEnd, nStart, nUses = 0, nLength = GetStringLength(sSpellUses);

	// retrieve the logged spell uses for the caster class
	ACR_SQLQuery("SELECT Uses FROM spelltrack WHERE CharacterID=" + IntToString(ACR_GetCharacterID(oCaster)) + " and Class=" + sClass);
		
	// fetch the data
	ACR_SQLFetch();	sSpellUses = ACR_SQLGetData(0);

	// loop through the spell uses string and search for the spell being cast
	while ((nEnd = FindSubString(sSpellUses, ":")) != -1)
	{
		// get the spell ID
		sSpellId = GetStringLeft(sSpellUses, nEnd);
		
		// get the index of the next element
		if ((nStart = FindSubString(sSpellUses, ACR_SPT_DELIMITER)) == -1) { nStart = nLength; }
	
		// get the spell uses
		nUses = StringToInt(GetSubString(sSpellUses, nEnd + 1, nStart - nEnd));
		
		// recalculate the spell uses array
		nLength -= nStart; sSpellUses = GetSubString(sSpellUses, nStart + 1, nLength);

		// break the loop if we found the index of the spell being cast
		if (StringToInt(sSpellId) == nSpellId) { break; }
	
		// construct the spell uses array and reset the uses counter
		sValues += sSpellId + ":" + IntToString(nUses) + ACR_SPT_DELIMITER; nUses=0;
	}
	sValues += IntToString(nSpellId) + ":" + IntToString(nUses + 1); if (nLength) { sValues += ACR_SPT_DELIMITER; }
	
	// update the spell logs
	ACR_SQLQuery("INSERT INTO spelltrack (CharacterID, Class, Uses) VALUES (" + IntToString(ACR_GetCharacterID(oCaster)) + "," + sClass + ",'" + sValues + sSpellUses + "') ON DUPLICATE KEY UPDATE Uses='" + sValues + sSpellUses + "'");
}

void ACR_RemoveSpellUses(object oCaster, string sClasses = "")
{
	// remove persistent spell logs
	if (sClasses == "")
	{
		// clear all logs for this character
		ACR_SQLQuery("DELETE FROM spelltrack WHERE CharacterID=" + IntToString(ACR_GetCharacterID(oCaster)));
	}
	else
	{
		// clear the logs for a specific class
		ACR_SQLQuery("DELETE FROM spelltrack WHERE CharacterID=" + IntToString(ACR_GetCharacterID(oCaster)) + " and Class in (" + sClasses + ")");
	}
}

void ACR_RestoreSpellUses(object oCaster)
{
    // make sure the caster is a PC
    if (!GetIsPC(oCaster) || GetIsDM(oCaster) || GetIsDMPossessed(oCaster)) { return; }

    // limit this function to caster base classes
    if (ACR_HasCasterClass(oCaster))
    {
		string sValues, sSpellUses;
		int nEnd, nStart, nSpellId, nUses, nLength = GetStringLength(sSpellUses);
		
		// retrieve the logged spell uses
		ACR_SQLQuery("SELECT Uses FROM spelltrack WHERE CharacterID=" + IntToString(ACR_GetCharacterID(oCaster)));
		
		// loop through the logs
		while (ACR_SQLFetch() == SQL_SUCCESS)
		{
			sSpellUses = ACR_SQLGetData(0);
			
			// loop through the spell uses string and search for the spell being cast
			while ((nEnd = FindSubString(sSpellUses, ":")) != -1)
			{
				// get the spell ID
				nSpellId = StringToInt(GetSubString(sSpellUses, 0, nEnd));
		
				// get the index of the next element
				if ((nStart = FindSubString(sSpellUses, ACR_SPT_DELIMITER)) == -1) { nStart = nLength; }
	
            	// restore spell uses
            	for(nUses=StringToInt(GetSubString(sSpellUses, nEnd + 1, nStart - nEnd)); nUses > 0; nUses--) { DecrementRemainingSpellUses(oCaster, nSpellId); }

				// recalculate the spell uses array
				nLength -= nStart; sSpellUses = GetSubString(sSpellUses, nStart + 1, nLength);
			}
		}
	}
}

int ACR_HasCasterClass(object oPC, string sType = "ALL")
{
    if (sType == "ARCANE")
    {
        // check for levels in arcane casting base classes that require spell preparation
        return (GetLevelByClass(CLASS_TYPE_WIZARD, oPC))
        ? TRUE : FALSE;
    }
    else if (sType == "INNATE")
    {
        // check for levels in arcane casting base classes that require no spell preparation
        return (GetLevelByClass(CLASS_TYPE_BARD, oPC) || GetLevelByClass(CLASS_TYPE_SORCERER, oPC) || 
                GetLevelByClass(CLASS_TYPE_FAVORED_SOUL, oPC) || GetLevelByClass(CLASS_TYPE_SPIRIT_SHAMAN, oPC))
        ? TRUE : FALSE;
    }
    else if (sType == "DIVINE")
    {
        // check for levels in divine casting base classes
        return (GetLevelByClass(CLASS_TYPE_CLERIC, oPC) || GetLevelByClass(CLASS_TYPE_RANGER, oPC) ||
                GetLevelByClass(CLASS_TYPE_PALADIN, oPC) || GetLevelByClass(CLASS_TYPE_DRUID, oPC))
        ? TRUE : FALSE;
    }
    else
    {
        // check for levels in all casting base classes
        return (GetLevelByClass(CLASS_TYPE_BARD, oPC)   || GetLevelByClass(CLASS_TYPE_SORCERER, oPC) ||
                GetLevelByClass(CLASS_TYPE_WIZARD, oPC) || GetLevelByClass(CLASS_TYPE_CLERIC, oPC) ||
                GetLevelByClass(CLASS_TYPE_RANGER, oPC) || GetLevelByClass(CLASS_TYPE_PALADIN, oPC) ||
                GetLevelByClass(CLASS_TYPE_FAVORED_SOUL, oPC) || GetLevelByClass(CLASS_TYPE_SPIRIT_SHAMAN, oPC) ||
                GetLevelByClass(CLASS_TYPE_DRUID, oPC))
        ? TRUE : FALSE;
    }
}


int ACR_GetCasterLevel(object oPC, int nCasterClass) {

    int nLevel = GetLevelByClass(nCasterClass, oPC);
	if (nLevel == 0) { return -1; }
	
    if ((nCasterClass == CLASS_TYPE_BARD) || (nCasterClass == CLASS_TYPE_CLERIC) || (nCasterClass == CLASS_TYPE_DRUID) || (nCasterClass == CLASS_TYPE_FAVORED_SOUL) 
	     || (nCasterClass == CLASS_TYPE_SORCERER) || (nCasterClass == CLASS_TYPE_SPIRIT_SHAMAN) || (nCasterClass == CLASS_TYPE_WIZARD)) {
		// Querying for a primary caster class, where class level in the class = caster level.
        return nLevel;
		
	} else if ((nCasterClass == CLASS_TYPE_PALADIN) || (nCasterClass == CLASS_TYPE_RANGER)) {
	    // secondary caster class, CL 0 until 4th, then CL = 1/2 class level.
		if (nLevel < 4) {
		    return 0;
		} else {
		    return (nLevel/2);
		} 
		
	} else {
	    // queried class is not a caster class
		return -1;
	}
}

int ACR_GetMinSpellCL(int nSpellLevel, int nSpellClass) {

    if (nSpellClass == CLASS_TYPE_BARD) {
	    if (nSpellLevel == 0) {
		    return 1;		
	    } else if (nSpellLevel <= 2) {
		    return (nSpellLevel*2);
		} else {
		    return (nSpellLevel*3 -2);
		}
	
	// clerics, druids, and wizards all gain spell level access at the same rate	
	} else if ((nSpellClass == CLASS_TYPE_CLERIC) || (nSpellClass == CLASS_TYPE_DRUID) || (nSpellClass == CLASS_TYPE_WIZARD))  { 
	    if (nSpellLevel == 0) {
		    return 1;
		} else {
	        return ((nSpellLevel*2) -1);
		}
	
	// sorcerors, spirit shamans, and favored souls all use a staggered spell level advancement	
	} else if ((nSpellClass == CLASS_TYPE_SORCERER) || (nSpellClass == CLASS_TYPE_FAVORED_SOUL) || (nSpellClass == CLASS_TYPE_SPIRIT_SHAMAN)) {
	    if (nSpellLevel <= 1) {
		    return 1;
		} else {
            return (nSpellLevel*2);
		}

	// Paladins and Rangers use the same delayed spell level table
	} else if ((nSpellClass == CLASS_TYPE_PALADIN) || (nSpellClass == CLASS_TYPE_RANGER)) {
	    if (nSpellLevel <= 2) {
		    return (nSpellLevel*2);
		} else if (nSpellLevel == 3) {
		    // they actually get 3rd level spells at 11th level, so still CL5
		    return 5;
		} else {
		    // spell is 4th level
		    return 7;
		} 
	} else {
	   return 99;
	}

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
	int nPCCasterLevel = GetLevelByClass(CLASS_TYPE_BARD, oCaster);
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
	nPCCasterLevel = GetLevelByClass(CLASS_TYPE_CLERIC, oCaster);
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
	nPCCasterLevel = GetLevelByClass(CLASS_TYPE_DRUID, oCaster);
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
	nPCCasterLevel = GetLevelByClass(CLASS_TYPE_PALADIN, oCaster);
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
	nPCCasterLevel = GetLevelByClass(CLASS_TYPE_RANGER, oCaster);
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
	nPCCasterLevel = GetLevelByClass(CLASS_TYPE_WIZARD, oCaster);
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
	nPCCasterLevel = GetLevelByClass(CLASS_TYPE_SPIRIT_SHAMAN, oCaster);
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
	nPCCasterLevel = GetLevelByClass(CLASS_TYPE_FAVORED_SOUL, oCaster);
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
	nPCCasterLevel = GetLevelByClass(CLASS_TYPE_SORCERER, oCaster);
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
