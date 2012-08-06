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
