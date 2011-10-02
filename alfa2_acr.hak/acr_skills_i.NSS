////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_skills_i.nss
//    $Revision::         $ current version of the file
//        $Date:: 2010-03-14 #$ date the file was created or modified
//       Author : AcadiusLost
//
//  Description
//  This file contains functions which process all events relating to custom skills
//  as well as the modification of base skill ranks via 1.23 functions.
//
//  Revision History
//  2008/1/25 AcadiusLost: Inception
//  2009/7/7  AcadiusLost: Revisions to use 1.23 functions for Custom Skills
//  2009/7/26  AcadiusLost: many fixes to these functions
//  2009/8/10  AcadiusLost: Patch to multiclass PC rebuilds
//  2009/8/15  AcadiusLost: removed debugging info from rebuild effect removal.
//  2010/3/14  AcadiusLost: Added ACR_SkillCheck() function
//
/////////////////////////////////////////////////////////////////////////////////

#include "acr_i"
#include "acr_resting_i"
#include "acr_tools_i"
#include "acr_xp_i"
#include "acr_db_persist_i"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// Number of the final row of skills.2da, used to iterate through all possible custom skills.
const int ACR_SKILLS_NUMBER = 67;

// Public functions

//!! Official skill check function for ALFA, takes into account skill synergy and whatever circumstance
//!!   modifiers it can; returns 0 (FALSE) or 1 (TRUE).  
//!! If no DC is provided, the function will return the roll result.
int ACR_SkillCheck(int nSkillID, object oPC, int nDC=0, int bShowRoll=FALSE, int bBroadcast=FALSE, int nModifier=0);

//!! Returns a prediction for a PC's .bic file name for LETO modification.
//!!  adapted from a NWN1-NWNx2 letoscript function from demux
string ACR_GetBicFileName(object oPC);

//!! Determines the path to a PC's .bic file
string ACR_GetBicPath(object oPC);

//! checks the skills.2da to see if this skill has been deleted.
int ACR_GetIsSkillRemoved(int nSkill);


//!! Caches LETO string for adjustment of perform and/or lore increases to match new ranks in
//!!  Knowledge:arcana and the perform subskills.
void ACR_SkillsOnPCLevelUp(object oLeveled);

//!! Cleans up any leftoever variables from LETO skill adjusts.
void ACR_SkillsOnClientEnter(object oEntered);

//!! Handles firing of the skill point allocation convo if a PC has not been adapted
void ACR_SkillsOnPCLoaded(object oEntered);

//!! Handles the actual LETO write on the bic for hidden skill total changes (lore, perform)
//!!  to reflect skill points invested in Knowledge: Arcana or Perform skills at levelup.
void ACR_SkillsOnClientExit(object oLeaving);

//!! Checks PCs OnClientEnter to see if they have been adapted / need adapting to the custom skills framework
int ACR_SkillsCheckIsPCAdapted(object oPC);

//!! Caches important data on the PC in order to implement the automated rebuild. 
void ACR_SkillsPrepareAdaption(object oPC);

// Private functions

//!! checks to see if a given skill is a class or crossclass skill for the PC.
//!!  Currently assumes a 1st level PC, uses their first class to decide.
int _IsClassSkill(int nSkill, object oTarget);

//!! Forces a repeat of a levelup screen, for use in the Skill rebuild process
void _ReLevelPC (object oPC);

//!! Adjusts alignment to allow leveling in next class, for rebuilding
void _AdjustAlignmentForLevel(int nClass, object oPC);

//!! Returns XP to PC for releveling during rebuild (also records stat investments).
void _ReturnXPforRebuild(object oPC);

//!! Cleans up all the local variables once the process is complete.
void _RebuildCleanup(object oPC);

//!! Strips paladin feats OnLeveledUp for non-LG PCs with one or more paladin levels.
//!!  Should get moved somewhere more appropriate eventually.
void _StripDivineFeats(object oPC);

//!! Sets up VFX and ethereality for rebuild process
void _ApplyAdaptionEffects(object oPC);

//!! Clears VFX and ethereality for rebuild process
void _StripAdaptionEffects(object oPC);

//!! Broadcast message to all dms
void _BroadcastToDMs(string sText);

//!! Color a block of text
string _Colorize(string sText, string sColor);

//
//  Function bodies
//

int ACR_SkillCheck(int nSkillID, object oPC, int nDC=0, int bShowRoll=FALSE, int bBroadcast=FALSE, int nModifier=0) {

	int nBaseRank = GetSkillRank(nSkillID, oPC, TRUE);
	int nModifiedRank = GetSkillRank(nSkillID, oPC, FALSE);
	string sMsg,sSkill,sColor="EFD4AC";

	switch (nSkillID) {
		case SKILL_CONCENTRATION: sSkill = "Concentration"; break;
		case SKILL_DISABLE_TRAP: sSkill = "DisableDevice"; break;
		case SKILL_HEAL: sSkill = "Heal"; break;
		case SKILL_HIDE: sSkill = "Hide"; break;
		case SKILL_LISTEN: sSkill = "Listen"; break;
		case SKILL_MOVE_SILENTLY: sSkill = "MoveSilently"; break;
		case SKILL_OPEN_LOCK: sSkill = "OpenLock"; break;
		case SKILL_PARRY: sSkill = "Parry"; break;
		case SKILL_DIPLOMACY: sSkill = "Diplomacy"; break;
		case SKILL_SLEIGHT_OF_HAND: sSkill = "SleightOfHand"; break;
		case SKILL_SEARCH: sSkill = "Search"; break;
		case SKILL_SPELLCRAFT: sSkill = "Spellcraft"; break;
		case SKILL_SPOT: sSkill = "Spot"; break;
		case SKILL_USE_MAGIC_DEVICE: sSkill = "UseMagicDevice"; break;
		case SKILL_APPRAISE: sSkill = "Appraise"; break;
		case SKILL_TUMBLE: sSkill = "Tumble"; break;
		case SKILL_BLUFF: sSkill = "Bluff"; break;
		case SKILL_INTIMIDATE: sSkill = "Intimidate"; break;
		case SKILL_RIDE: sSkill = "Ride"; break;
		case SKILL_SURVIVAL: sSkill = "Survival"; break;
		case SKILL_BALANCE: sSkill = "Balance"; break;
		case SKILL_CLIMB: sSkill = "Climb"; break;
		case SKILL_DECIPHER_SCRIPT: sSkill = "DecipherScript"; break;
		case SKILL_KNOWLEDGE_DUNGEONEERING: sSkill = "Knowledge(dungeoneering)"; break;
		case SKILL_DISGUISE: sSkill = "Disguise"; break;
		case SKILL_ESCAPE_ARTIST: sSkill = "EscapeArtist"; break;
		case SKILL_FORGERY: sSkill = "Forgery"; break;
		case SKILL_GATHER_INFORMATION: sSkill = "GatherInformation"; break;
		case SKILL_HANDLE_ANIMAL: sSkill = "HandleAnimal"; break;
		case SKILL_JUMP: sSkill = "Jump"; break;
		case SKILL_KNOWLEDGE_ARCANA: sSkill = "Knowledge(arcana)"; break;
		case SKILL_KNOWLEDGE_HISTORY: sSkill = "Knowledge(history)"; break;
		case SKILL_KNOWLEDGE_NATURE: sSkill = "Knowledge(nature)"; break;
		case SKILL_KNOWLEDGE_RELIGION: sSkill = "Knowledge(religion)"; break;
		case SKILL_KNOWLEDGE_THE_PLANES: sSkill = "Knowledge(theplanes)"; break;
		case SKILL_PERFORM_ACT: sSkill = "Perform(act)"; break;
		case SKILL_PERFORM_DANCE: sSkill = "Perform(dance)"; break;
		case SKILL_PERFORM_ORATORY: sSkill = "Perform(oratory)"; break;
		case SKILL_PERFORM_STRING_INSTRUMENTS: sSkill = "Perform(string instruments)"; break;
		case SKILL_PERFORM_SING: sSkill = "Perform(sing)"; break;
		case SKILL_PROFESSION: sSkill = "Profession"; break;
		case SKILL_SENSE_MOTIVE: sSkill = "SenseMotive"; break;
		case SKILL_SPEAK_LANGUAGE: sSkill = "SpeakLanguage"; break;
		case SKILL_SWIM: sSkill = "Swim"; break;
		case SKILL_USE_ROPE: sSkill = "UseRope"; break;
		case SKILL_KNOWLEDGE_GEOGRAPHY: sSkill = "Knowledge(geography)"; break;
		case SKILL_KNOWLEDGE_NOBILITY: sSkill = "Knowledge(nobility)"; break;
		case SKILL_KNOWLEDGE_ENGINEERING: sSkill = "Knowledge(engineering)"; break;
		case SKILL_KNOWLEDGE_LOCAL: sSkill = "Knowledge(local)"; break;
		case SKILL_PERFORM_PERCUSSION: sSkill = "Perform(percussion)"; break;
		case SKILL_PERFORM_KEYBOARD: sSkill = "Perform(keyboards)"; break;
		case SKILL_PERFORM_WIND_INSTRUMENTS: sSkill = "Perform(wind instruments)"; break;
		case SKILL_PERFORM_COMEDY: sSkill = "Perform(comedy)"; break;
		case SKILL_CRAFT__ALCHEMY: sSkill = "Craft(Alchemy)"; break;
		case SKILL_CRAFT_ARMORSMITHING: sSkill = "Craft(Armorsmithing)"; break;
		case SKILL_CRAFT_BOWMAKING: sSkill = "Craft(Bowmaking)"; break;
		case SKILL_CRAFT_WEAPONSMITHING: sSkill = "Craft(Weaponsmithing)"; break;
	}

	if (nBaseRank < 1) {
		// Skill is being attempted untrained, check for autofail
		if ((nSkillID == 2) || (nSkillID == 9) || (nSkillID == 13) || (nSkillID == 16) || (nSkillID == 19) || (nSkillID == 21) || (nSkillID == 32) || (nSkillID == 33) || (nSkillID == 38) || (nSkillID == 16) || ((nSkillID >= 40) && (nSkillID <= 44)) || (nSkillID == 50) || (nSkillID == 52) || ((nSkillID >= 55) && (nSkillID <= 59))) {
			// Skill is not usable untrained.  Report if appropriate, and return FALSE
			if (bShowRoll) { SendMessageToPC(oPC, "ACR Skills: Use of this skill requires training."); }
			return FALSE;
		}
	}
	// Apply any circumstance or synergy modifiers here.
	if (nSkillID == SKILL_BALANCE) {
		if (GetSkillRank(SKILL_TUMBLE, oPC, TRUE) >= 5) {
			if (bShowRoll) { SendMessageToPC(oPC, "Synergy bonus applied from Tumble ranks"); }
			nModifiedRank = nModifiedRank+2;
		}
	} else if (nSkillID == SKILL_CLIMB) {
		if (GetRacialType(oPC) == RACIAL_TYPE_HALFLING) {
			if (bShowRoll) { SendMessageToPC(oPC, "Racial bonus applied from halfling heritage"); }
			nModifiedRank = nModifiedRank+2;		
		}
	} else if (nSkillID == SKILL_DIPLOMACY) {
		// Diplomacy is synergized by Race:HalfElf, Bluff, Knowledge(Nobility), and Sense Motive.
		if (GetSkillRank(SKILL_BLUFF, oPC, TRUE) >= 5) {
			if (bShowRoll) { SendMessageToPC(oPC, "Synergy bonus applied from Bluff ranks"); }
			nModifiedRank = nModifiedRank+2;
		}
		if (GetSkillRank(SKILL_KNOWLEDGE_NOBILITY, oPC, TRUE) >= 5) {
			if (bShowRoll) { SendMessageToPC(oPC, "Synergy bonus applied from Knowledge (Nobility) ranks"); }
			nModifiedRank = nModifiedRank+2;
		}
		if (GetSkillRank(SKILL_SENSE_MOTIVE, oPC, TRUE) >= 5) {
			if (bShowRoll) { SendMessageToPC(oPC, "Synergy bonus applied from Sense Motive ranks"); }
			nModifiedRank = nModifiedRank+2;
		}
	} else if (nSkillID == SKILL_GATHER_INFORMATION) {
		if (GetSkillRank(SKILL_KNOWLEDGE_LOCAL, oPC, TRUE) >= 5) {
			if (bShowRoll) { SendMessageToPC(oPC, "Synergy bonus applied from Knowledge(Local) ranks"); }
			nModifiedRank = nModifiedRank+2;
		}
		if (GetSubRace(oPC) == RACIAL_SUBTYPE_HALFELF) {
			if (bShowRoll) { SendMessageToPC(oPC, "Racial bonus applied from half-elven heritage"); }
			nModifiedRank = nModifiedRank+2;		
		}
	} else if (nSkillID == SKILL_INTIMIDATE) {
		if (GetSkillRank(SKILL_BLUFF, oPC, TRUE) >= 5) {
			if (bShowRoll) { SendMessageToPC(oPC, "Synergy bonus applied from Bluff ranks"); }
			nModifiedRank = nModifiedRank+2;
		}
	} else if (nSkillID == SKILL_JUMP) {
		if (GetSkillRank(SKILL_TUMBLE, oPC, TRUE) >= 5) {
			if (bShowRoll) { SendMessageToPC(oPC, "Synergy bonus applied from Tumble ranks"); }
			nModifiedRank = nModifiedRank+2;
		}
		if (GetRacialType(oPC) == RACIAL_TYPE_HALFLING) {
			if (bShowRoll) { SendMessageToPC(oPC, "Racial bonus applied from halfling heritage"); }
			nModifiedRank = nModifiedRank+2;		
		}
	} else if (nSkillID == SKILL_KNOWLEDGE_NATURE) {
		if (GetSkillRank(SKILL_SURVIVAL, oPC, TRUE) >= 5) {
			if (bShowRoll) { SendMessageToPC(oPC, "Synergy bonus applied from Survival ranks"); }
			nModifiedRank = nModifiedRank+2;
		}
	} else if (nSkillID == SKILL_RIDE) {
		if (GetSkillRank(SKILL_HANDLE_ANIMAL, oPC, TRUE) >= 5) {
			if (bShowRoll) { SendMessageToPC(oPC, "Synergy bonus applied from Handle Animal ranks"); }
			nModifiedRank = nModifiedRank+2;
		}
	} else if (nSkillID == SKILL_SLEIGHT_OF_HAND) {
		if (GetSkillRank(SKILL_BLUFF, oPC, TRUE) >= 5) {
			if (bShowRoll) { SendMessageToPC(oPC, "Synergy bonus applied from Bluff ranks"); }
			nModifiedRank = nModifiedRank+2;
		}
	} else if (nSkillID == SKILL_SPELLCRAFT) {
		if (GetSkillRank(SKILL_KNOWLEDGE_ARCANA, oPC, TRUE) >= 5) {
			if (bShowRoll) { SendMessageToPC(oPC, "Synergy bonus applied from Knowledge(Arcana) ranks"); }
			nModifiedRank = nModifiedRank+2;
		}
	} else if (nSkillID == SKILL_SURVIVAL) {
		// Survival is synergized by Dungeoneering when underground, and Knowledge(Nature) when aboveground/Natural.
		if (!GetIsAreaAboveGround(GetArea(oPC))) {
			if (GetSkillRank(SKILL_KNOWLEDGE_DUNGEONEERING, oPC, TRUE) >= 5) {
				if (bShowRoll) { SendMessageToPC(oPC, "Synergy bonus applied from Knowledge(Dungeoneering) ranks"); }
				nModifiedRank = nModifiedRank+2;
			}
		} else if (GetIsAreaNatural(GetArea(oPC))) {
			if (GetSkillRank(SKILL_KNOWLEDGE_NATURE, oPC, TRUE) >= 5) {
				if (bShowRoll) { SendMessageToPC(oPC, "Synergy bonus applied from Knowledge(Nature) ranks"); }
				nModifiedRank = nModifiedRank+2;
			}
		}
	} else if (nSkillID == SKILL_TUMBLE) {
		if (GetSkillRank(SKILL_JUMP, oPC, TRUE) >= 5) {
			if (bShowRoll) { SendMessageToPC(oPC, "Synergy bonus applied from Jump ranks"); }
			nModifiedRank = nModifiedRank+2;
		}	
	}
	// on to the roll itself.
	int nRoll = d20();
	int nResult = nRoll + nModifiedRank + nModifier;
	
	sMsg = _Colorize("ACR Skill ",sColor)+sSkill+_Colorize(": Rolled a ",sColor)+IntToString(nRoll)+_Colorize(" + "+IntToString(nModifiedRank)+" modified skill ranks, total = ",sColor)+IntToString(nResult)+".";
	if (nDC == 0) {
		//openended check
		if (bBroadcast) {
			SendChatMessage(oPC, oPC, CHAT_MODE_TALK, sMsg, TRUE);
		}
		else if (bShowRoll) {
			SendMessageToPC(oPC, sMsg);
		}
		_BroadcastToDMs("[" + GetName(oPC) + "]" + sMsg);
		return nResult;
	}
	if (nResult >= nDC) {
		if (bShowRoll) {
			SendMessageToPC(oPC, sMsg+"; SUCCESSFUL.");
		}
		return TRUE;
	}
	else {
		if (bShowRoll) {
			SendMessageToPC(oPC, sMsg+"; FAILED.");
		}
		return FALSE;
	}
}

void _BroadcastToDMs(string sText)
{
	object pc = GetFirstPC();
	while (GetIsObjectValid(pc)) {
		if (GetIsDM(pc))
			SendMessageToPC(pc, sText);

		pc = GetNextPC();
	}
}

string _Colorize(string sText, string sColor)
{
	return "<color=#"+sColor+">"+sText+"</c>";
}

//credit to demux
string ACR_GetBicFileName(object oPC)
{
	// no longer necessary, as we don't use LETO
    string sChar, sBicName;
    string sPCName = GetStringLowerCase(GetName(oPC));
    int i, iNameLength = GetStringLength(sPCName);

    for(i=0; i < iNameLength; i++) {
        sChar = GetSubString(sPCName, i, 1);
        if (TestStringAgainstPattern("(*a|*n|*w|'|-|_)", sChar)) {
            if (sChar != " ") sBicName += sChar;
        }
    }
    return GetStringLeft(sBicName, 30);
}

//credit to demux
string ACR_GetBicPath(object oPC)
{
	// no longer necessary, as we don't use LETO
	
    // Gets a local var stored on oPC on "event client enter". I do this because
    // "on even client leave", function GetPCPlayerName() can not be used. Since
    // a .bic file can not be changed while the owner is logged in, it is typical
    // to execute leto scripts when the client leaves (on event client leave).
    string PlayerName = GetLocalString(oPC, "PlayerName");
    if(PlayerName == "") {
        PlayerName = GetPCPlayerName(oPC);
		SetLocalString(oPC, "PlayerName", PlayerName);
	}
	return "";
    // Retruns the full path to a .bic file.
    //return (ACR_SERVER_DIR+"/servervault/"+PlayerName+"/"+ACR_GetBicFileName(oPC)+".bic");
}


int ACR_GetIsSkillRemoved(int nSkill) {

    if ((nSkill == 0) || (nSkill == 3) || (nSkill == 7) || (nSkill == 11) || (nSkill == 15) || (nSkill == 18) ||
        (nSkill == 22) || (nSkill == 25) || (nSkill == 26) || (nSkill == 27)) {
        return TRUE;
    } else {
        return FALSE;
    }  

}



void ACR_SkillsOnPCLevelUp(object oLeveled) {

    // first, check for a Knowledge: Arcana increase
	//  - note: LETO is no longer used for this.
	int nLoreDeficit = (GetSkillRank(SKILL_KNOWLEDGE_ARCANA, oLeveled, TRUE) - GetSkillRank(SKILL_LORE, oLeveled, TRUE));
	if (nLoreDeficit > 0) {
		// We can adjust this immediately with SetBaseSkillRank()
	    //SendMessageToPC(oLeveled, "Your Knowledge:Arcana skill increase will apply to checks to identify items after your next login.");
		//SetLocalInt(oLeveled, "ACR_LETO", TRUE);
		//SetLocalInt(oLeveled, "ACR_LETO_LORE", GetSkillRank(SKILL_KNOWLEDGE_ARCANA, oLeveled, TRUE));
		SetBaseSkillRank(oLeveled, SKILL_LORE, GetSkillRank(SKILL_KNOWLEDGE_ARCANA, oLeveled, TRUE), TRUE);
	}
	// next, set a base Perform rank based on Perform subskills
	int nPerformBase = GetSkillRank(SKILL_PERFORM, oLeveled, TRUE);
	int nRank = 0;
	int nSubskill = 45;
	int bPerformChange = FALSE;
	object oMod = GetModule();
	while (nSubskill <= 49) {
	    nRank = GetSkillRank(nSubskill, oLeveled, TRUE);
		if (nRank > nPerformBase) {
		    //SendMessageToPC(oLeveled, "Your Perform subskill increase will apply to hardcoded bard abilities after your next login.");
			bPerformChange = TRUE;
			//SetLocalInt(oLeveled, "ACR_LETO_PERFORM", nRank);
			nPerformBase = nRank;
		}
		nSubskill = nSubskill + 1;
	}
	if (bPerformChange) {
		// A Perform skill update is called for
		SetBaseSkillRank(oLeveled, SKILL_PERFORM, nPerformBase, TRUE);
	}
	if (GetLevelByClass(CLASS_TYPE_PALADIN, oLeveled) > 0) {
		if ((GetAlignmentGoodEvil(oLeveled) == ALIGNMENT_GOOD) && (GetAlignmentLawChaos(oLeveled) == ALIGNMENT_LAWFUL)) {
			// paladin's alignment is OK, no worries
		} else {
			// ex-paladin, no longer LG.  Strip all paladin feats
			_StripDivineFeats(oLeveled);
		}
	}
	if (GetSkillRank(0, oLeveled, TRUE) == 1) {
		//PC is in the skills rebuild process, check to see that they put their level/points in an appropriate place.
		//Determine which level was just taken
		int nPCID = ACR_GetCharacterID(oLeveled);
		int nLastLevel = (GetLevelByPosition(1, oLeveled) + GetLevelByPosition(2, oLeveled) + GetLevelByPosition(3, oLeveled) + GetLevelByPosition(4, oLeveled));
		//SendMessageToPC(oLeveled, "LevelUP for rebuild, LastLevel:"+IntToString(nLastLevel));
		// Mod record deprecated, just make sure they haven't leveled in something they shouldn't have.
		//int nCorrectClass = GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_"+IntToString(nLastLevel));
		//SendMessageToPC(oLeveled, "Should have leveled into class "+IntToString(nCorrectClass));
		//
		// First, make sure they haven't exceeded their prior levels in their base class
		int nRecordedClass1 = GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_CLASS1");
		int nRecordedLevel1 = GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_LEVEL1");
		int nRecordedClass2 = GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_CLASS2");
		int nRecordedLevel2 = GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_LEVEL2");
		int nRecordedClass3 = GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_CLASS3");
		int nRecordedLevel3 = GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_LEVEL3");
		int nRecordedClass4 = GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_CLASS4");
		int nRecordedLevel4 = GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_LEVEL4");

		// base class can't be changed, so just check the level on this one.
		// SendMessageToPC(oLeveled, "RecordedLevel1: "+IntToString(nRecordedLevel1)+", LevelByPosition1: "+IntToString(GetLevelByPosition(1, oLeveled)));
		if (GetLevelByPosition(1, oLeveled) > nRecordedLevel1) {
			// PC has rebuilt into too many levels in his/her base class, redo the leveling
			AssignCommand(oLeveled, ActionSpeakString("((Incorrect leveling error: Too many levels in your base class.  Please repeat leveling.))"));
			WriteTimestampedLogEntry("ACR Automated Skills Rebuild Error: PC "+GetName(oLeveled)+" took too many levels in its base class. Re-Leveling.");
			_ReLevelPC(oLeveled);
			return;
		} else if (nRecordedClass2 != GetClassByPosition(2, oLeveled)) {
			// PC had before or has now a secondary class, which does not match.
			if (GetLevelByPosition(2, oLeveled) > 0) {
				// PC took a level in the wrong secondary class. re-level
				AssignCommand(oLeveled, ActionSpeakString("((Incorrect leveling error: PC leveled into an incorrect secondary class.  Please repeat leveling.))"));
				WriteTimestampedLogEntry("ACR Automated Skills Rebuild Error: PC "+GetName(oLeveled)+" leveled into an incorrect secondary class. Re-Leveling.");
				_ReLevelPC(oLeveled);
				return;
			}  // if the PC has a mismatch, but no levels, that just means he/she hasn't taken any secondary class levels yet.
		} else {
			// PC has already started leveling into the correct secondary class (or correctly has no secondary class).
			if (GetLevelByPosition(2, oLeveled) > nRecordedLevel2) {
				// leveled too far in secondary class.
				AssignCommand(oLeveled, ActionSpeakString("((Incorrect leveling error: took too many levels in secondary class.  Please repeat leveling.))"));
				WriteTimestampedLogEntry("ACR Automated Skills Rebuild Error: PC "+GetName(oLeveled)+" leveled too far into the correct secondary class. Re-Leveling.");
				_ReLevelPC(oLeveled);
				return;
			}
		}
		// check if the PC is done leveling in the base class, if so, move on to check/adjust alignment for secondary class (if any)
		if ((GetLevelByPosition(1, oLeveled) == nRecordedLevel1) && (nRecordedClass2 != 0)) {
			_AdjustAlignmentForLevel(nRecordedClass2, oLeveled);
		} else if ((GetLevelByPosition(2, oLeveled) == nRecordedLevel2) && (nRecordedClass3 != 0)) {
			// PC has finished leveling in secondary class, but has a teriary. check for needed alignment shifts
			_AdjustAlignmentForLevel(nRecordedClass3, oLeveled);
		}
		if (GetLevelByPosition(3, oLeveled) > 0) {
			// PC has a tertiary class, check to see if it's the right one and appropriate for levels
			if((GetClassByPosition(3, oLeveled) != nRecordedClass3) || (GetLevelByPosition(3, oLeveled) > nRecordedLevel3)) {
				// either way, needs to be re-leveled.
				AssignCommand(oLeveled, ActionSpeakString("((Incorrect leveling error: improperly leveled into teriary class.  Please repeat leveling.))"));
				WriteTimestampedLogEntry("ACR Automated Skills Rebuild Error: PC "+GetName(oLeveled)+" incorrect leveling into tertiary class. Re-Leveling.");
				_ReLevelPC(oLeveled);
				return;
			} else if (GetLevelByPosition(4, oLeveled) > 0) {
				// can't have a 4th class without a third one.  check as above.
				if((GetClassByPosition(4, oLeveled) != nRecordedClass4) || (GetLevelByPosition(4, oLeveled) > nRecordedLevel4)) {
					// either way, needs to be re-leveled.
					AssignCommand(oLeveled, ActionSpeakString("((Incorrect leveling error: improperly leveled into quartenary class.  Please repeat leveling.))"));
					WriteTimestampedLogEntry("ACR Automated Skills Rebuild Error: PC "+GetName(oLeveled)+" incorrect leveling into quartenary class. Re-Leveling.");
					_ReLevelPC(oLeveled);
					return;
				}
			}
		}
		// check if the PC is done leveling in the tertiary class, if so, move on to check/adjust alignment for quartenry class (if any)
		if ((GetLevelByPosition(3, oLeveled) == nRecordedLevel3) && (nRecordedClass4 != 0)) {
			_AdjustAlignmentForLevel(nRecordedClass4, oLeveled);
		}
		// deprecated, skip these checks until/unless we have a levelling matrix
		/*
		if (nLastLevel == 2) {
			// first levelup (to 2nd level), is it in the base class or the start of a new one?
			if (nCorrectClass == GetClassByPosition(1, oLeveled)) {
				// level should have been in the PC's base class.
				if (GetLevelByPosition(1, oLeveled) != 2) {
					ActionSpeakString("Incorrect leveling error: Should have continued with base class this level.  Please repeat leveling.");
					WriteTimestampedLogEntry("ACR Automated Skills Rebuild Error: PC "+GetName(oLeveled)+" took an incorrect level outside its base class. Re-Leveling.");
					_ReLevelPC(oLeveled);
				}
			} else if (nCorrectClass == GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_CLASS2")) {
				// level should have started the PC's secondary class
				if (GetClassByPosition(2, oLeveled) != nCorrectClass) {
					ActionSpeakString("Incorrect leveling error: Should have started a second character class this level.  Please repeat leveling.");
					WriteTimestampedLogEntry("ACR Automated Skills Rebuild Error: PC "+GetName(oLeveled)+" failed to level into its secondary class. Re-Leveling.");
					_ReLevelPC(oLeveled);
				}
			}
		} else {
			// This is the second or later levelup of the rebuild, compare with the cached last level to determine
			//  which level has been taken, and whether it is appropriate
			if (GetLevelByPosition(1, oLeveled) > GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_CURRENTCLASS1")) {
				// new level appears to be in the base class
				//  is this on-schedule?
				if (GetLevelByPosition(1, oLeveled) != nCorrectClass) {
					ActionSpeakString("Incorrect leveling error: Should not have continued with base class this level.  Please repeat leveling.");
					WriteTimestampedLogEntry("ACR Automated Skills Rebuild Error: PC "+GetName(oLeveled)+" leveled in its base class out of schedule. Re-Leveling.");
					_ReLevelPC(oLeveled);
				}
			} else if (GetLevelByPosition(2, oLeveled) > GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_CURRENTCLASS2")) {
				// new level appears to have been in the secondary class
				//  is this on-schedule?
				if (GetLevelByPosition(2, oLeveled) != nCorrectClass) {
					ActionSpeakString("Incorrect leveling error: Should have leveled in secondary class this level.  Please repeat leveling.");
					WriteTimestampedLogEntry("ACR Automated Skills Rebuild Error: PC "+GetName(oLeveled)+" should have leveled in secondary class. Re-Leveling.");
					_ReLevelPC(oLeveled);
				}
			} else if (GetLevelByPosition(3, oLeveled) > GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_CURRENTCLASS3")) {
				// new level appears to have been in the secondary class
				//  is this on-schedule?
				if (GetLevelByPosition(3, oLeveled) != nCorrectClass) {
					ActionSpeakString("Incorrect leveling error: Should have leveled in tertiary class this level.  Please repeat leveling.");
					WriteTimestampedLogEntry("ACR Automated Skills Rebuild Error: PC "+GetName(oLeveled)+" should have leveled in tertiary class. Re-Leveling.");
					_ReLevelPC(oLeveled);
				}
			} else if (GetLevelByPosition(4, oLeveled) > GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_CURRENTCLASS4")) {
				// new level appears to have been in the secondary class
				//  is this on-schedule?
				if (GetLevelByPosition(4, oLeveled) != nCorrectClass) {
					ActionSpeakString("Incorrect leveling error: Should have leveled in quartenary class this level.  Please repeat leveling.");
					WriteTimestampedLogEntry("ACR Automated Skills Rebuild Error: PC "+GetName(oLeveled)+" should have leveled in quartenary class. Re-Leveling.");
					_ReLevelPC(oLeveled);
				}
			}				
		} */
		// This section deals with stat increases.
		//   try to make sure they end up in the right place(s)
		if (nLastLevel == 3) {
			// next levelup will be a stat point. Cache the scheduled attribute.
			int nNextStat = GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_MOD1_ABILITY");
			SetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_CURRENTSTAT1", nNextStat);	
			SetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_CURRENTSCORE1", GetAbilityScore(oLeveled, nNextStat, TRUE));
		} else if (nLastLevel == 4) {
			// 4th level means first new attribute point.  Check to see if it went in the right place.
			int nIntendedStat = GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_CURRENTSTAT1");
			int nPriorScore = GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_CURRENTSCORE1");
			if (GetAbilityScore(oLeveled, nIntendedStat, TRUE) != (nPriorScore + 1)) {
				// attribute point went into the wrong stat
				AssignCommand(oLeveled, ActionSpeakString("((Incorrect leveling error: Assigned 4th level ability point to the wrong attribute.  Please repeat leveling.))"));
				WriteTimestampedLogEntry("ACR Automated Skills Rebuild Error: PC "+GetName(oLeveled)+" assigned 4th level ability point to the wrong attribute. Re-Leveling.");
				_ReLevelPC(oLeveled);
				return;
			} else {
				SetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_CURRENTSCORE1", (nPriorScore+1));
			}
		} else if (nLastLevel == 7) {
			// next levelup will be a stat point. Cache the scheduled attribute.
			//  this is more complicated if the same attribute was bumped twice.  Allow either.
			int nInitialStatIncrease = 	GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_MOD1_AMOUNT");
			if (nInitialStatIncrease > 1) {
				// will allow another boost in STAT1, cache it	
				SetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_CURRENTSCORE1", GetAbilityScore(oLeveled, GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_MOD1_ABILITY"), TRUE));	
			}
			// also, if a second stat should have been boosted at some point, prepare for that as well.
			if (GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_MOD2_AMOUNT") > 0) {
				// secondary stat might be next, cache that too.
				SetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_CURRENTSCORE2", GetAbilityScore(oLeveled, GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_MOD2_ABILITY"), TRUE));
			}
		} else if (nLastLevel == 8) {
			// second stat point; check for either acceptable investment
			int bApproved = FALSE;
			int nStatMod1 = GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_MOD1_ABILITY");
			int nStatMod2 = GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_MOD2_ABILITY");
			int nStatMod1Increase = GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_MOD1_AMOUNT");
			int nStatMod2Increase = GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_MOD2_AMOUNT");
			
			if (nStatMod1Increase > 1) {			
				if (GetAbilityScore(oLeveled, nStatMod1, TRUE) > GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_CURRENTSCORE1")) {
					// point was placed in the same stat again, should be OK
					bApproved = TRUE;
					SetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_CURRENTSCORE1", (GetAbilityScore(oLeveled, nStatMod1, TRUE)+1));
				}
			} else if (nStatMod2Increase > 0) {
				if (GetAbilityScore(oLeveled, nStatMod2, TRUE) > GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_CURRENTSCORE2")) {
					bApproved = TRUE;
					SetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_CURRENTSCORE2", (GetAbilityScore(oLeveled, nStatMod2, TRUE)+1));
				}
			} 
			if (!bApproved) {
				// attribute point went into the wrong stat
				AssignCommand(oLeveled, ActionSpeakString("((Incorrect leveling error: Assigned 8th level ability point to the wrong attribute.  Please repeat leveling.))"));
				WriteTimestampedLogEntry("ACR Automated Skills Rebuild Error: PC "+GetName(oLeveled)+" assigned 8th level ability point to the wrong attribute. Re-Leveling.");
				_ReLevelPC(oLeveled);	
				return;
			}
		} else if (nLastLevel == 11) {
			// increasingly convoluted, next level could mean investment in any of three abilities.

		} else if (nLastLevel == 12) {
			// Third stat point investment
			int nStatMod1Inc = GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_MOD1_AMOUNT");
			int nStatMod2Inc = GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_MOD2_AMOUNT");
			int nStatMod3Inc = GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_MOD3_AMOUNT");
			int nSMod1 = GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_MOD1_ABILITY");
			int nSMod2 = GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_MOD2_ABILITY");
			int nSMod3 = GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_MOD3_ABILITY");
			int nPriorStat1 = GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_CURRENTSCORE1");
			int nPriorStat2 = GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_CURRENTSCORE2");
			int nPriorStat3 = GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_CURRENTSCORE3");
			if (nStatMod2Inc == 0) {
				// only one attribute will ever be raised, check to see if MOD1 ability is up 3 points yet.
				if (nPriorStat1 < GetAbilityScore(oLeveled, nSMod1, TRUE)) {
					// point was invested in the only attribute being boosted, so OK.
					SetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_CURRENTSCORE1", GetAbilityScore(oLeveled, nSMod1, TRUE));
				} else {
					// record has only one stat boosted, but the 12th level boost must have gone elsewhere.  Re-level.
					WriteTimestampedLogEntry("ACR Automated Skills Rebuild Error: PC "+GetName(oLeveled)+" assigned 12th level ability point to the wrong attribute. Re-Leveling.");
					AssignCommand(oLeveled, ActionSpeakString("((Incorrect leveling error: Assigned 12th level ability point to the wrong attribute.  Please repeat leveling.))"));	
					_ReLevelPC(oLeveled);	
					return;
				}
			} else if (nStatMod3Inc == 0) {
				// Two attributes recorded originally boosted.  If neither of the two have increased, point must have gone into the wrong place.
				if ((nPriorStat1 < GetAbilityScore(oLeveled, nSMod1, TRUE)) && (GetAbilityScore(oLeveled, nSMod1, TRUE) <= nStatMod1Inc)) {
					// point was invested in one of the attributes being boosted, didn't push it above prior levels.
					SetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_CURRENTSCORE1", GetAbilityScore(oLeveled, nSMod1, TRUE));
				} else if ((nPriorStat2 < GetAbilityScore(oLeveled, nSMod2, TRUE)) && (GetAbilityScore(oLeveled, nSMod2, TRUE) <= nStatMod2Inc)) {
					// point was invested in one of the attributes being boosted, didn't push it above prior levels.
					SetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_CURRENTSCORE2", GetAbilityScore(oLeveled, nSMod2, TRUE));
				} else {
					// point must have gone somewhere it shouldn't have.
					WriteTimestampedLogEntry("ACR Automated Skills Rebuild Error: PC "+GetName(oLeveled)+" assigned 12th level ability point to the wrong attribute. Re-Leveling.");
					AssignCommand(oLeveled, ActionSpeakString("((Incorrect leveling error: Assigned 12th level ability point to the wrong attribute.  Please repeat leveling.))"));	
					_ReLevelPC(oLeveled);	
					return;
				}
			} else {
				// three or more stats were eventually boosted by this PC.  Check the first 3.
				if ((nPriorStat1 < GetAbilityScore(oLeveled, nSMod1, TRUE)) && (GetAbilityScore(oLeveled, nSMod1, TRUE) <= nStatMod1Inc)) {
					// point was invested in one of the attributes being boosted, didn't push it above prior levels.
					SetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_CURRENTSCORE1", GetAbilityScore(oLeveled, nSMod1, TRUE));
				} else if ((nPriorStat2 < GetAbilityScore(oLeveled, nSMod2, TRUE)) && (GetAbilityScore(oLeveled, nSMod2, TRUE) <= nStatMod2Inc)) {
					// point was invested in one of the attributes being boosted, didn't push it above prior levels.
					SetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_CURRENTSCORE2", GetAbilityScore(oLeveled, nSMod2, TRUE));
				} else if ((nPriorStat3 < GetAbilityScore(oLeveled, nSMod3, TRUE)) && (GetAbilityScore(oLeveled, nSMod3, TRUE) <= nStatMod3Inc)) {
					// point was invested in one of the attributes being boosted, didn't push it above prior levels.
					SetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_CURRENTSCORE3", GetAbilityScore(oLeveled, nSMod3, TRUE));
				} else {
					// point must have gone somewhere it shouldn't have.
					WriteTimestampedLogEntry("ACR Automated Skills Rebuild Error: PC "+GetName(oLeveled)+" assigned 12th level ability point to the wrong attribute. Re-Leveling.");
					AssignCommand(oLeveled, ActionSpeakString("((Incorrect leveling error: Assigned 12th level ability point to the wrong attribute.  Please repeat leveling.))"));	
					_ReLevelPC(oLeveled);	
					return;
				}
			}
		} else if (nLastLevel == 15) {
			// increasingly convoluted, next level could mean investment in any of four abilities.
			int nStatMod1 = GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_MOD1_AMOUNT");
			int nStatMod2 = GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_MOD2_AMOUNT");
			int nStatMod3 = GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_MOD3_AMOUNT");
			int nStatMod4 = GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_MOD4_AMOUNT");
			if (nStatMod4 > 0) {

				// 
			}
			int nMod1 = GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_MOD1_ABILITY");
			int nMod2 = GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_MOD2_ABILITY");
			int nMod3 = GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_MOD3_ABILITY");
			int nMod4 = GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_MOD4_ABILITY");		
		}		
	 	int nTargetLevel = GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_TOTAL_LEVELS");
		if (nLastLevel < nTargetLevel) {
			// more levels needed to finish rebuild, adjust alignment if necessary and keep going
			//_AdjustAlignmentForLevel(nNextClass, oLeveled);
			// record level progress
			//SetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_CURRENTCLASS1", GetLevelByPosition(1, oLeveled));
			//SetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_CURRENTCLASS2", GetLevelByPosition(2, oLeveled));
			//SetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_CURRENTCLASS3", GetLevelByPosition(3, oLeveled));
			//SetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_CURRENTCLASS4", GetLevelByPosition(4, oLeveled)); 
		} else {
			// this was the last level needed. Finalize and clean up!
			
			// fix alignment if necessary
			int nGoodness = GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_GoodEvil");
			int nLawness = GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_LawChaos");
			// SendMessageToPC(oLeveled, "cached Goodness: "+IntToString(nGoodness)+", cached Lawness: "+IntToString(nLawness));
			if (nGoodness != GetGoodEvilValue(oLeveled)) {
				// SendMessageToPC(oLeveled, "Mismatch, read Goodness as "+IntToString(GetGoodEvilValue(oLeveled)));
				WriteTimestampedLogEntry("ACR Automated Skills Rebuild for: "+GetName(oLeveled)+", Alignment restoration, Good/Evil shift: "+IntToString(nGoodness - GetGoodEvilValue(oLeveled)));
				AdjustAlignment(oLeveled, ALIGNMENT_GOOD, nGoodness - GetGoodEvilValue(oLeveled));
			}
			if (nLawness != GetLawChaosValue(oLeveled)) {
				// SendMessageToPC(oLeveled, "Mismatch, read Lawness as "+IntToString(GetLawChaosValue(oLeveled)));
				WriteTimestampedLogEntry("ACR Automated Skills Rebuild for : "+GetName(oLeveled)+", Alignment restoration, Law/Chaos shift: "+IntToString(nLawness - GetLawChaosValue(oLeveled)));			
				AdjustAlignment(oLeveled, ALIGNMENT_LAWFUL, nLawness - GetLawChaosValue(oLeveled));
			}
			// fix diety if necessary
			string sPriorFaith = GetLocalString(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_DEITY");
			if (GetDeity(oLeveled) != sPriorFaith) {
				string sInterimDeity = GetDeity(oLeveled);
				WriteTimestampedLogEntry("ACR Automated Rebuild for: "+GetName(oLeveled)+", Deity restoration to "+sPriorFaith+".");
				SendMessageToPC(oLeveled, "Restoring patron: "+sPriorFaith+", from interim faith: "+sInterimDeity);
				SetDeity(oLeveled, sPriorFaith);
			}
			// final check, now that alignment is restored
			if (GetLevelByClass(CLASS_TYPE_PALADIN, oLeveled) > 0) {
				if ((GetAlignmentGoodEvil(oLeveled) == ALIGNMENT_GOOD) && (GetAlignmentLawChaos(oLeveled) == ALIGNMENT_LAWFUL)) {
					// paladin's alignment is OK, no worries
				} else {
					// ex-paladin, no longer LG.  Strip all paladin feats
					_StripDivineFeats(oLeveled);
				}
			}
			
			// mark PC as adjusted
			SetBaseSkillRank(oLeveled, 0, 2, FALSE);
			WriteTimestampedLogEntry("ACR Automated Skills Rebuild Completed successfully for PC: "+GetName(oLeveled));
			AssignCommand(oLeveled, ActionSpeakString("((ACR Skills Adaption Rebuild: Completed Successfully.))"));
			
			_StripAdaptionEffects(oLeveled);
			
			ACR_PCSave(oLeveled, FALSE);
			_RebuildCleanup(oLeveled);
			// start up deferred systems
			// ExecuteScript("dmfi_mod_pcload", GetModule());
			ACR_XPOnClientLoaded(oLeveled);
			ACR_RestOnClientEnter(oLeveled);
		}
	}
}

void ACR_SkillsOnClientEnter(object oEntered) {
    if (!GetIsPC(oEntered)) { return; }
	if (GetLocalInt(oEntered, "ACR_SKILL_START") == TRUE) {
	    // PC has arrived with leftover info from a failed LETO write- clear it up.
		int nSkillIndex = 0;
		while (nSkillIndex <= 55) {
		    DeleteLocalInt(oEntered, "ACR_SKILL_"+IntToString(nSkillIndex));
			nSkillIndex = nSkillIndex + 1;
		}
    }		
}

void ACR_SkillsOnPCLoaded(object oEntered) {

    if (!GetIsPC(oEntered)) { return; }
	if (GetIsDM(oEntered)) { return; }

	if (!ACR_SkillsCheckIsPCAdapted(oEntered)) {
		SendMessageToPC(oEntered, "Queuing Adaption Convo"); 
		// Need the PC at 1st level to manage the conversion, but will do it via the convo.
		AssignCommand(oEntered, ActionStartConversation(oEntered, "acr_convo_skill", TRUE, FALSE));
	}
	
}


void ACR_SkillsOnClientExit(object oLeaving) {

	// no longer need to LETO PCs to do this, so don't need this code.
	
    //if (GetLocalInt(oLeaving, "ACR_LETO_FULL") == TRUE) {
	//    // PC is flagged for a full skill write attempt from custom skill adaption.
	//	string sLetoString = GetLocalString(oLeaving, "ACR_LETO_STRING");
	//	SetLocalString(GetModule(), "NWNX!LETO!SPAWN", sLetoString);
    //} else if (GetLocalInt(oLeaving, "ACR_LETO") == TRUE) {
	//    // PC is flagged for a bic edit from a previous levelup.
	//	string sLetoString = "%bob = '"+GetLocalString(oLeaving, "ACR_LETO_PATH")+"';";
	//	int nLore = GetLocalInt(oLeaving, "ACR_LETO_LORE");
	//	if (nLore > 0) {
	//	    sLetoString = sLetoString + " /SkillList/[7]/Rank = "+IntToString(nLore)+";";
	//	}
	//	int nPerform = GetLocalInt(oLeaving, "ACR_LETO_PERFORM");
	//	if (nPerform > 0) {
	//	    sLetoString = sLetoString + " /SkillList/[11]/Rank = "+IntToString(nPerform)+";";
	//	}
	//	sLetoString = sLetoString + " %bob = '>'; close %bob; ";
	//	SetLocalString(GetModule(), "NWNX!LETO!SPAWN", sLetoString);
	//
	//}
}

int _IsClassSkill(int nSkill, object oTarget) {

    int nPCClass = GetClassByPosition(1, oTarget);
	// check to see if the class 2da has been cached on the PC
	string sClass = GetLocalString(oTarget, "ACR_SKILL_CLASS2DA");
	if ( sClass == "") {
	if (nPCClass == CLASS_TYPE_BARBARIAN) {
	    sClass = "barb";
	} else if (nPCClass == CLASS_TYPE_BARD) {
	    sClass = "bard";
	} else if (nPCClass == CLASS_TYPE_CLERIC) {
	    sClass = "cler";
	} else if (nPCClass == CLASS_TYPE_DRUID) {
	    sClass = "dru";
	} else if (nPCClass == CLASS_TYPE_FAVORED_SOUL) {
	    sClass = "favored_soul";
	} else if (nPCClass == CLASS_TYPE_FIGHTER) {
	    sClass = "fight";
	} else if (nPCClass == CLASS_TYPE_MONK) {
	    sClass = "monk";
	} else if (nPCClass == CLASS_TYPE_PALADIN) {
	    sClass = "pal";
	} else if (nPCClass == CLASS_TYPE_RANGER) {
	    sClass = "rang";
	} else if (nPCClass == CLASS_TYPE_ROGUE) {
	    sClass = "rog";
	} else if (nPCClass == CLASS_TYPE_SORCERER) {
	    sClass = "sorc";
	} else if (nPCClass == CLASS_TYPE_SPIRIT_SHAMAN) {
	    sClass = "spiritshaman";
	} else if (nPCClass == CLASS_TYPE_SWASHBUCKLER) {
	    sClass = "swashbuckler";
	} else if (nPCClass == CLASS_TYPE_WARLOCK) {
	    sClass = "wlck";
	} else if (nPCClass == CLASS_TYPE_WIZARD) {
	    sClass = "wiz";
    }
	// cache for next time
	SetLocalString(oTarget, "ACR_SKILL_CLASS2DA", sClass);
	}
	string sClassSkill2da = "cls_skill_"+sClass;
	
	return StringToInt(Get2DAString(sClassSkill2da, "ClassSkill", nSkill));
}


int ACR_SkillsCheckIsPCAdapted(object oPC) {
	
	// we use ranks in the NWN1 deleted skill ANIMAL_EMPATHY to track a PC's skills adaption status.
	//  0 ranks: not skill-adapted
	//  1 rank: incomplete adaption or adaption still in progress
	//  2 ranks: adaption complete.
	int nMarkRank = GetSkillRank(0, oPC, TRUE);	
	//SendMessageToPC(oPC, "Checking for adaption; nMarkRank = "+IntToString(nMarkRank));	
	if (nMarkRank == 2) {
		return TRUE;
	} else if (nMarkRank == 1) {
		WriteTimestampedLogEntry("PC "+GetName(oPC)+" played by "+GetPCPlayerName(oPC)+" ("+GetPCPublicCDKey(oPC)+") is incompletely or incorrectly adapted to the ACR Custom Skill framework.");
		SendMessageToPC(oPC, "Your skills adaption is incomplete.  If this problem persists, please contact the ALFA Tech department.");
		return FALSE;
	} else {
		return FALSE;
	}
}

void ACR_SkillsPrepareAdaption(object oPC) {
	
	// This script will be called from the skills adaption convo as a step 2.
	int nCharID = ACR_GetCharacterID(oPC);
	object oMod = GetModule();
	// OK, so we have a PC that needs rebuilding.  
	// First, we store XP totals for later restoration.
	int nTotalXP = GetXP(oPC);
	SetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nCharID)+"_XP", nTotalXP);
	// gather Alignment Info
	int nAlignGoodEvil = GetGoodEvilValue(oPC);
	int nAlignLawChaos = GetLawChaosValue(oPC);
	SetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nCharID)+"_GoodEvil", nAlignGoodEvil);
	SetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nCharID)+"_LawChaos", nAlignLawChaos);
	// Cache Diety selection
	string sDeity = GetDeity(oPC);
	SetLocalString(oMod, "ACR_REBUILD_"+IntToString(nCharID)+"_DEITY", sDeity);
	// build up the leveling record
	int nClass1 = GetClassByPosition(1, oPC);
	int nLevel1 = GetLevelByClass(nClass1, oPC);
	int nClass2 = GetClassByPosition(2, oPC);
	int nLevel2 = GetLevelByClass(nClass2, oPC);
	int nClass3 = GetClassByPosition(3, oPC);
	int nLevel3 = GetLevelByClass(nClass3, oPC); 
	int nClass4 = GetClassByPosition(4, oPC);
	int nLevel4 = GetLevelByClass(nClass4, oPC); 
	int nTotalLevels = GetLevelByPosition(1, oPC) + GetLevelByPosition(2, oPC) + GetLevelByPosition(3, oPC) + GetLevelByPosition(4, oPC);
	SetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nCharID)+"_CLASS1", nClass1);
	SetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nCharID)+"_LEVEL1", nLevel1);
	SetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nCharID)+"_CLASS2", nClass2);
	SetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nCharID)+"_LEVEL2", nLevel2);
	SetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nCharID)+"_CLASS3", nClass3);
	SetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nCharID)+"_LEVEL3", nLevel3);
	SetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nCharID)+"_CLASS4", nClass4);
	SetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nCharID)+"_LEVEL4", nLevel4);
	SetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nCharID)+"_TOTAL_LEVELS", nTotalLevels);
	// now we know the PC's total levels in each class, and which order they took them in, roughly.
	//
	//  next, determine if they took more than one level in their base class, and if so,
	//  whether that class has alignment restrictions.
	if (nLevel1 > 1) {
		_AdjustAlignmentForLevel(nClass1, oPC);
	}
	// could cache attributes too
	SetLocalInt(oPC, "FormerSTR", GetAbilityScore(oPC, ABILITY_STRENGTH, TRUE));
	SetLocalInt(oPC, "FormerDEX", GetAbilityScore(oPC, ABILITY_DEXTERITY, TRUE));
	SetLocalInt(oPC, "FormerCON", GetAbilityScore(oPC, ABILITY_CONSTITUTION, TRUE));
	SetLocalInt(oPC, "FormerINT", GetAbilityScore(oPC, ABILITY_INTELLIGENCE, TRUE));
	SetLocalInt(oPC, "FormerWIS", GetAbilityScore(oPC, ABILITY_WISDOM, TRUE));
	SetLocalInt(oPC, "FormerCHA", GetAbilityScore(oPC, ABILITY_CHARISMA, TRUE));
	
	// Has this PC received PrC Validation?
	int bHasValidation = GetHasFeat(3500, oPC);
	SetLocalInt(oPC, "Validated", bHasValidation);
	
	// incremental de-leveling isn't working, so skip this part.
	/*
	// drop the PC down to 1st level to remove levels gained without custom skills
	WriteTimestampedLogEntry("ACR automated skills rebuild started for PC "+GetName(oPC)+". Removing "+IntToString(nTotalXP - 10)+" XP for rebuilding.");
	int nCountDown = nTotalLevels;
	string sLevelRecord = "";
	while (nCountDown > 1) {
		SetXP(oPC, (GetXpNeededForLevel(ACR_GetECL(oPC))-10));
		if (GetLevelByPosition(1, oPC) < nLevel1) {
			// this level dropped, so the prior level was in the base class.
			SetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nCharID)+"_"+IntToString(nCountDown), nClass1);
			sLevelRecord = "|"+IntToString(nClass1)+sLevelRecord;
			nLevel1 = GetLevelByPosition(1, oPC);
		} else if (GetLevelByPosition(2, oPC) < nLevel2) {
			// prior level was in secondary class.
			SetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nCharID)+"_"+IntToString(nCountDown), nClass2);
			sLevelRecord = "|"+IntToString(nClass2)+sLevelRecord;
			nLevel2 = GetLevelByPosition(2, oPC);
		} else if (GetLevelByPosition(3, oPC) < nLevel3) {
			// prior level was in secondary class.
			SetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nCharID)+"_"+IntToString(nCountDown), nClass2);
			sLevelRecord = "|"+IntToString(nClass3)+sLevelRecord;
			nLevel3 = GetLevelByPosition(3, oPC);
		} else if (GetLevelByPosition(4, oPC) < nLevel4) {
			// prior level was in secondary class.
			SetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nCharID)+"_"+IntToString(nCountDown), nClass2);
			sLevelRecord = "|"+IntToString(nClass1)+sLevelRecord;
			nLevel4 = GetLevelByPosition(4, oPC);
		}
		nCountDown = nCountDown -1;
	}
	WriteTimestampedLogEntry("ACR Skills Rebuild: Level matrix for PC "+GetName(oPC)+": "+sLevelRecord);		
	*/
	if (nTotalLevels > 1) {
		// PCs over 1st level will need to be de-leveled and re-leveled.
		WriteTimestampedLogEntry("ACR automated skills releveling started for PC "+GetName(oPC)+". Removing "+IntToString(nTotalXP - 10)+" XP for rebuilding.");
		SetXP(oPC, 10);
		// mark the PC as undergoing releveling rebuild
		SetBaseSkillRank(oPC, 0, 1, FALSE);
	} else {
		// 1st level PC undergoing adaption
		WriteTimestampedLogEntry("ACR automated skills adaption started for 1st level PC "+GetName(oPC)+".");
	}
	// Apply the rebuild FX
	_ApplyAdaptionEffects(oPC);
			
	// finally, remove any invalid background feats
	FeatRemove(oPC, FEAT_BACKGROUND_APPRAISER);
	FeatRemove(oPC, FEAT_BACKGROUND_CONFIDANT);
	FeatRemove(oPC, FEAT_BACKGROUND_FARMER);
	FeatRemove(oPC, FEAT_BACKGROUND_FOREIGNER);
	FeatRemove(oPC, FEAT_BACKGROUND_MILITIA);
	FeatRemove(oPC, FEAT_BACKGROUND_TALE_TELLER);
	FeatRemove(oPC, FEAT_BACKGROUND_TALENT);
	FeatRemove(oPC, FEAT_BACKGROUND_TROUBLE_MAKER);
	FeatRemove(oPC, FEAT_BACKGROUND_WILD_CHILD);
	FeatRemove(oPC, FEAT_BACKGROUND_WIZARDS_APPRENTICE);
}

void _ReLevelPC (object oLeveled) {

	int nPCID = ACR_GetCharacterID(oLeveled);
	object oMod = GetModule();
	
	_SetALFAXp(oLeveled, (10 + GetXpNeededForLevel(ACR_GetECL(oLeveled) - 1)));
	// Then, return full XP again so they can retry.
	int nTargetXP = GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_XP");
	SendMessageToPC(oLeveled, "Preparing to boost XP to "+IntToString(nTargetXP));
	DelayCommand(1.0, _SetALFAXp(oLeveled, nTargetXP));
}

void _AdjustAlignmentForLevel(int nClass, object oPC) {
	
	// only for use in the automated skills rebuild process.  Alignment will be restored 
	//  when all class levels are corrected.
	int nAlignGoodEvil = GetGoodEvilValue(oPC);
	int nAlignLawChaos = GetLawChaosValue(oPC);
	
	if ((nClass == CLASS_TYPE_BARD) || (nClass == CLASS_TYPE_BARBARIAN)) {
		// base class is non-lawful only, is the PC lawful? 
		if (nAlignLawChaos >= 70) {
			// PC will need to be made nonlawful to relevel in this base class.
			AdjustAlignment(oPC, ALIGNMENT_CHAOTIC, 70);
			WriteTimestampedLogEntry("ACR Automated Skills Rebuild: Shifted alignment of PC "+GetName(oPC)+" away from Lawful to allow relevelling in former base class (Bard/Barb).");
		}
	} else if (nClass == CLASS_TYPE_DRUID) {
		// base class requires some neutrality
		if (((30 < nAlignGoodEvil) && (nAlignGoodEvil < 70)) || ((30 < nAlignLawChaos) && (nAlignLawChaos < 70))) {
			// PC still has some neutrality, should be able to level into druid.
		} else {	
			// Need to shift back towards some neutrality.
			AdjustAlignment(oPC, ALIGNMENT_NEUTRAL, 50);
			WriteTimestampedLogEntry("ACR Automated Skills Rebuild: Shifted alignment of PC "+GetName(oPC)+" to Neutral to allow relevelling in former base class (Druid).");
		}
	} else if (nClass == CLASS_TYPE_MONK) {
		// if the PC isn't lawful anymore, bump them back to it
		if (nAlignLawChaos <= 70) {
			AdjustAlignment(oPC, ALIGNMENT_LAWFUL, 70);
			WriteTimestampedLogEntry("ACR Automated Skills Rebuild: Shifted alignment of PC "+GetName(oPC)+" to Lawful to allow relevelling in former base class (Monk).");
		}
	} else if (nClass == CLASS_TYPE_PALADIN) {
		// check for LG alignment
		if ((nAlignGoodEvil < 70) || (nAlignLawChaos < 70)) {
			AdjustAlignment(oPC, ALIGNMENT_ALL, 70);
			WriteTimestampedLogEntry("ACR Automated Skills Rebuild: Shifted alignment of PC "+GetName(oPC)+" to Lawful Good to allow relevelling in former base class (Paladin).");
		}
	} else if (nClass == CLASS_TYPE_WARLOCK) {
		// check for evil or chaotic
		if ((nAlignGoodEvil > 30) && (nAlignLawChaos > 30)) {
			AdjustAlignment(oPC, ALIGNMENT_ALL, -70);		
			WriteTimestampedLogEntry("ACR Automated Skills Rebuild: Shifted alignment of PC "+GetName(oPC)+" to Chaotic Evil to allow relevelling in former base class (Warlock).");		
		}
	}

}


void _ReturnXPforRebuild(object oPC) {

	// DelayCommand this function to pick up changes from de-leveling.
	//SendMessageToPC(oPC, "_ReturnXPforRebuild");
	int nCharID = ACR_GetCharacterID(oPC);
	object oMod = GetModule();
	int nTotalLevels = GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nCharID)+"_TOTAL_LEVELS");
	int nXP = GetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nCharID)+"_XP");
	//  retrieve former ratings from locals
	int nSTR = GetLocalInt(oPC, "FormerSTR");
	int nDEX = GetLocalInt(oPC, "FormerDEX");
	int nCON = GetLocalInt(oPC, "FormerCON");
	int nINT = GetLocalInt(oPC, "FormerINT");
	int nWIS = GetLocalInt(oPC, "FormerWIS");
	int nCHA = GetLocalInt(oPC, "FormerCHA");
	// now check for changed attributes
	int nNumStatsChanged = 0;
	int nChangeAmount = 0;
	int nTotalChange = 0;
	if (nSTR > GetAbilityScore(oPC, ABILITY_STRENGTH, TRUE)) {
		SetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nCharID)+"_MOD1_ABILITY", ABILITY_STRENGTH);
		nChangeAmount = nSTR - GetAbilityScore(oPC, ABILITY_STRENGTH, TRUE);
		SetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nCharID)+"_MOD1_AMOUNT", nChangeAmount);
		nNumStatsChanged = 1;
		nTotalChange = nChangeAmount;
	}
	if (nDEX > GetAbilityScore(oPC, ABILITY_DEXTERITY, TRUE)) {
		nNumStatsChanged = nNumStatsChanged +1;
		SetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nCharID)+"_MOD"+IntToString(nNumStatsChanged)+"_ABILITY", ABILITY_DEXTERITY);
		nChangeAmount = nDEX - GetAbilityScore(oPC, ABILITY_DEXTERITY, TRUE);
		SetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nCharID)+"_MOD"+IntToString(nNumStatsChanged)+"_AMOUNT", nChangeAmount);
		nTotalChange = nTotalChange + nChangeAmount;		
	}	 
	if (nCON > GetAbilityScore(oPC, ABILITY_CONSTITUTION, TRUE)) {
		nNumStatsChanged = nNumStatsChanged +1;
		SetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nCharID)+"_MOD"+IntToString(nNumStatsChanged)+"_ABILITY", ABILITY_CONSTITUTION);
		nChangeAmount = nCON - GetAbilityScore(oPC, ABILITY_CONSTITUTION, TRUE);
		SetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nCharID)+"_MOD"+IntToString(nNumStatsChanged)+"_AMOUNT", nChangeAmount);		
		nTotalChange = nTotalChange + nChangeAmount;
	}	 
	if (nINT > GetAbilityScore(oPC, ABILITY_INTELLIGENCE, TRUE)) {
		nNumStatsChanged = nNumStatsChanged +1;
		SetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nCharID)+"_MOD"+IntToString(nNumStatsChanged)+"_ABILITY", ABILITY_INTELLIGENCE);
		nChangeAmount = nINT - GetAbilityScore(oPC, ABILITY_INTELLIGENCE, TRUE);
		SetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nCharID)+"_MOD"+IntToString(nNumStatsChanged)+"_AMOUNT", nChangeAmount);		
		nTotalChange = nTotalChange + nChangeAmount;
	}
	if (nWIS > GetAbilityScore(oPC, ABILITY_WISDOM, TRUE)) {
		nNumStatsChanged = nNumStatsChanged +1;
		SetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nCharID)+"_MOD"+IntToString(nNumStatsChanged)+"_ABILITY", ABILITY_WISDOM);
		nChangeAmount = nWIS - GetAbilityScore(oPC, ABILITY_WISDOM, TRUE);
		SetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nCharID)+"_MOD"+IntToString(nNumStatsChanged)+"_AMOUNT", nChangeAmount);		
		nTotalChange = nTotalChange + nChangeAmount;
	}	 	 
	if (nCHA > GetAbilityScore(oPC, ABILITY_CHARISMA, TRUE)) {
		nNumStatsChanged = nNumStatsChanged +1;
		SetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nCharID)+"_MOD"+IntToString(nNumStatsChanged)+"_ABILITY", ABILITY_CHARISMA);
		nChangeAmount = nCHA - GetAbilityScore(oPC, ABILITY_CHARISMA, TRUE);
		SetLocalInt(oMod, "ACR_REBUILD_"+IntToString(nCharID)+"_MOD"+IntToString(nNumStatsChanged)+"_AMOUNT", nChangeAmount);		
		nTotalChange = nTotalChange + nChangeAmount;
	}
	if (nTotalChange > 4) {
		// player must be 20th or greater in level?
		if (nTotalLevels < 20) {
			WriteTimestampedLogEntry("ACR Skills Rebuild error: Stat change overrun. "+IntToString(nTotalChange)+" attribute bonus points possessed by PC "+GetName(oPC)+" from "+IntToString(nTotalLevels)+" total levels.");
		}
	} else if ((nTotalChange > 3) && (nTotalLevels < 16)) {
		WriteTimestampedLogEntry("ACR Skills Rebuild error: Stat change overrun. "+IntToString(nTotalChange)+" attribute bonus points possessed by PC "+GetName(oPC)+" from "+IntToString(nTotalLevels)+" total levels.");
	} else if ((nTotalChange > 2) && (nTotalLevels < 12)) {
		WriteTimestampedLogEntry("ACR Skills Rebuild error: Stat change overrun. "+IntToString(nTotalChange)+" attribute bonus points possessed by PC "+GetName(oPC)+" from "+IntToString(nTotalLevels)+" total levels.");
	} else if ((nTotalChange > 1) && (nTotalLevels < 8)) {
		WriteTimestampedLogEntry("ACR Skills Rebuild error: Stat change overrun. "+IntToString(nTotalChange)+" attribute bonus points possessed by PC "+GetName(oPC)+" from "+IntToString(nTotalLevels)+" total levels.");
	} else if ((nTotalChange > 0) && (nTotalLevels < 4)) {
		WriteTimestampedLogEntry("ACR Skills Rebuild error: Stat change overrun. "+IntToString(nTotalChange)+" attribute bonus points possessed by PC "+GetName(oPC)+" from "+IntToString(nTotalLevels)+" total levels.");
	}
	
	// check if the de-leveling	removed a PrC Validation feat
	if (GetLocalInt(oPC, "Validated") && !GetHasFeat(3500, oPC)) {
		WriteTimestampedLogEntry("ACR Skills Rebuild error: PrC Validation Feat Lost by PC: "+GetName(oPC)+", re-granting Validation Feat.");
		FeatAdd(oPC, 3500, FALSE, TRUE, TRUE);
	}
	
	// Finally, return the XP so the PC can begin re-leveling.
	_SetALFAXp(oPC, nXP);

}

void _RebuildCleanup(object oPC) {

	// start with the variables leftover on the PC
	DeleteLocalInt(oPC, "FormerSTR");
	DeleteLocalInt(oPC, "FormerDEX");
	DeleteLocalInt(oPC, "FormerCON");
	DeleteLocalInt(oPC, "FormerINT");
	DeleteLocalInt(oPC, "FormerWIS");
	DeleteLocalInt(oPC, "FormerCHA");
	DeleteLocalInt(oPC, "Validated");
	// now, get the ones on the module
	int nPCID = ACR_GetCharacterID(oPC);
	object oMod = GetModule();
	// Clean up module cache
	int nIndex = 1;
	//while (nIndex <= nLastLevel) {
	//	DeleteLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_"+IntToString(nLastLevel));
	//	nIndex = nIndex + 1;
	//}
	DeleteLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_LEVEL1");
	DeleteLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_LEVEL2");
	DeleteLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_LEVEL3");
	DeleteLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_LEVEL4");
	DeleteLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_CLASS1");
	DeleteLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_CLASS2");
	DeleteLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_CLASS3");
	DeleteLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_CLASS4");
			
	nIndex = 1;
	while (nIndex <= 4) {
		DeleteLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_CURRENTCLASS"+IntToString(nIndex));
		nIndex = nIndex + 1;
	}
			
	DeleteLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_GoodEvil");
	DeleteLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_LawChaos");

	DeleteLocalString(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_DEITY");
				
	DeleteLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_MOD1_ABILITY");
	DeleteLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_MOD1_AMOUNT");
	DeleteLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_MOD2_ABILITY");
	DeleteLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_MOD2_AMOUNT");
	DeleteLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_MOD3_ABILITY");
	DeleteLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_MOD3_AMOUNT");
	DeleteLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_MOD4_ABILITY");
	DeleteLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_MOD4_AMOUNT");
	DeleteLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_MOD5_ABILITY");
	DeleteLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_MOD5_AMOUNT");
	DeleteLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_MOD6_ABILITY");
	DeleteLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_MOD6_AMOUNT");
			
	nIndex = 1;
	while (nIndex <= 6) {
		DeleteLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_CURRENTSCORE"+IntToString(nIndex));
		nIndex = nIndex + 1;
	}
			
	DeleteLocalInt(oMod, "ACR_REBUILD_"+IntToString(nPCID)+"_XP");
}	


void _StripDivineFeats(object oPC) {

	SendMessageToPC(oPC, "Removing all Divine feats from paladin levels due to incompatible alignment.");
	WriteTimestampedLogEntry("Stripped all divine feats from PC: "+GetName(oPC)+" due to alignment incompatibilities with Paldin class levels.");
	// run down the list with FeatRemove()
	FeatRemove(oPC, FEAT_SMITE_EVIL);
	FeatRemove(oPC, FEAT_SMITE_EVIL_2);
	FeatRemove(oPC, FEAT_SMITE_EVIL_3);
	FeatRemove(oPC, FEAT_SMITE_EVIL_4);
	FeatRemove(oPC, FEAT_SMITE_EVIL_5);
	FeatRemove(oPC, FEAT_DIVINE_GRACE);
	FeatRemove(oPC, FEAT_LAY_ON_HANDS);
	FeatRemove(oPC, FEAT_DIVINE_HEALTH);
	FeatRemove(oPC, FEAT_AURA_OF_COURAGE);
	FeatRemove(oPC, FEAT_TURN_UNDEAD);
	FeatRemove(oPC, FEAT_REMOVE_DISEASE);
}

void _ApplyAdaptionEffects(object oPC) {

	//effect eAdapt = SetEffectSpellId(EffectNWN2SpecialEffectFile("fx_hss_afk_01"), -999);
	//effect eAdapt2 = SetEffectSpellId(EffectNWN2SpecialEffectFile("fx_hss_afk_03"), -999);
	effect eAdapt = EffectEthereal();
	effect eAdapt2 = EffectVisualEffect(VFX_DUR_SHINING_SHIELD);
	effect eAdapt3 = EffectCutsceneImmobilize();
	eAdapt = EffectLinkEffects(eAdapt2, eAdapt);
	eAdapt = EffectLinkEffects(eAdapt3, eAdapt);
	//eAdapt = EffectLinkEffects(eAdapt, eAdapt5);
	//eAdapt = SupernaturalEffect(EffectLinkEffects(eAdapt, eAdapt5));
	eAdapt = SupernaturalEffect(eAdapt);
	
	DelayCommand(0.5, AssignCommand(GetArea(oPC), ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAdapt, oPC)));
}

void _StripAdaptionEffects(object oPC) {

	object oArea = GetArea(oPC);
	effect eTest = GetFirstEffect(oPC);
	int nEffectType = GetEffectType(eTest);
	while (GetIsEffectValid(eTest)) {
		//SendMessageToPC(oPC, "Checking effect: "+IntToString(nEffectType)+", owned by "+GetName(GetEffectCreator(eTest)));
		if ((nEffectType == EFFECT_TYPE_CUTSCENEIMMOBILIZE) || (nEffectType == EFFECT_TYPE_ETHEREAL) || (nEffectType == EFFECT_TYPE_VISUALEFFECT)) {
			RemoveEffect(oPC, eTest);
			//SendMessageToPC(oPC, "Removing effect: "+IntToString(nEffectType)+".");
		}
		eTest = GetNextEffect(oPC);
	}
}