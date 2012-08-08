////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_roll_i
//    $Revision:: 1          $ current version of the file
//        $Date:: 2012-01-12#$ date the file was created or modified
//       Author : Ronan
//
//    Var Prefix: ROLL
//  Dependencies: NWNX, MYSQL
//
//  Description
//  This file contains logic for managing chat text roll commands.
//
//  Revision History
//  2012/01/12  Ronan       - Created.
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_tools_i"
#include "acr_skills_i"

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

//! Parse a roll command
void ParseRoll(object pc, string cmd);

//! Perform a left-justified string comparison.
//!  - str: Supplies the string to compare against.
//!  - ref: Supplies the string to compare with.
//!  - Returns: TRUE if there was a match, else FALE.
int ACR_RollCompareLeft(string str, string ref);

//! Custom dice roll.
int ACR_Roll( int nDieCount, int nDieSides );

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

int ACR_RollCompareLeft(string str, string ref)
{
	int len = GetStringLength(ref);

	return (GetStringLeft(str, len) == ref);
}

void ParseRoll(object pc, string cmd)
{
	int b,len,offset;
	string tmp,text=cmd;
	
	// kludge to handle nasty stuff like "craft: "
	
	if (TestStringAgainstPattern("(craft|knowledge|perform)**",cmd)) {

		tmp = "craft";
		if (ACR_RollCompareLeft(cmd,tmp)) {
			len = GetStringLength(cmd);
			offset = GetStringLength(tmp);

			cmd = GetStringRight(cmd,len-offset);
		}
		
		tmp = "knowledge";
		if (ACR_RollCompareLeft(cmd,tmp)) {
			len = GetStringLength(cmd);
			offset = GetStringLength(tmp);

			cmd = GetStringRight(cmd,len-offset);
		}

		tmp = "perform";
		if (ACR_RollCompareLeft(cmd,tmp)) {
			len = GetStringLength(cmd);
			offset = GetStringLength(tmp);

			cmd = GetStringRight(cmd,len-offset);
		}

		// eat characters
		do {
			b = ACR_RollCompareLeft(cmd, " ") + ACR_RollCompareLeft(cmd, "-") + ACR_RollCompareLeft(cmd, "(") + ACR_RollCompareLeft(cmd, ":");
			
			// no alterations needed
			if (!b)
				break;

			len = GetStringLength(cmd);

			cmd = GetStringRight(cmd,len-1);
		} while (b);
	}

	// saves
	if (ACR_RollCompareLeft(cmd,"for")) {
		ACR_Checks(CHECK_TYPE_SAVE, pc, SAVING_THROW_FORT);
	}
	else if (ACR_RollCompareLeft(cmd,"ref")) {
		ACR_Checks(CHECK_TYPE_SAVE, pc, SAVING_THROW_REFLEX);
	}
	else if (ACR_RollCompareLeft(cmd,"wil")) {
		ACR_Checks(CHECK_TYPE_SAVE, pc, SAVING_THROW_WILL);
	}

	// initiative
	else if (ACR_RollCompareLeft(cmd,"ini")) {

		ACR_InitCheck(pc, 0, TRUE, TRUE);
	}

	// abilities
	else if (ACR_RollCompareLeft(cmd,"stre") || cmd == "str") {
		ACR_Checks(CHECK_TYPE_STAT, pc, ABILITY_STRENGTH);
	}
	else if (ACR_RollCompareLeft(cmd,"dex")) {
		ACR_Checks(CHECK_TYPE_STAT, pc, ABILITY_DEXTERITY);
	}
	else if (ACR_RollCompareLeft(cmd,"cons") || cmd == "con") { 
		ACR_Checks(CHECK_TYPE_STAT, pc, ABILITY_CONSTITUTION);
	}
	else if (ACR_RollCompareLeft(cmd,"inte") || cmd == "int") {
		ACR_Checks(CHECK_TYPE_STAT, pc, ABILITY_INTELLIGENCE);
	}
	else if (ACR_RollCompareLeft(cmd,"wis")) {
		ACR_Checks(CHECK_TYPE_STAT, pc, ABILITY_WISDOM);
	}
	else if (ACR_RollCompareLeft(cmd,"cha")) {
		ACR_Checks(CHECK_TYPE_STAT, pc, ABILITY_CHARISMA);
	}
	
	// Combined skill rolls.
	else if (ACR_RollCompareLeft(cmd,"track")) {
		ACR_Checks(CHECK_TYPE_TRACK, pc);
	}
	else if (ACR_RollCompareLeft(cmd,"stealth")) {
		ACR_Checks(CHECK_TYPE_STEALTH, pc);
	}
	else if (ACR_RollCompareLeft(cmd,"perc")) {
		ACR_Checks(CHECK_TYPE_PERCEPTION, pc);
	}
	
	// Skills.
	else if (ACR_RollCompareLeft(cmd,"app")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_APPRAISE);
	}
	else if (ACR_RollCompareLeft(cmd,"bal")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_BALANCE);
	}
	else if (ACR_RollCompareLeft(cmd,"blu")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_BLUFF);
	}
	else if (ACR_RollCompareLeft(cmd,"cli")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_CLIMB);
	}
	else if (ACR_RollCompareLeft(cmd,"conc")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_CONCENTRATION);
	}
	else if (ACR_RollCompareLeft(cmd,"alc")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_CRAFT__ALCHEMY);
	}
	else if (ACR_RollCompareLeft(cmd,"arm")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_CRAFT_ARMORSMITHING);
	}
	else if (ACR_RollCompareLeft(cmd,"bow")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_CRAFT_BOWMAKING);
	}
	else if (ACR_RollCompareLeft(cmd,"wea")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_CRAFT_WEAPONSMITHING);
	}
	else if (ACR_RollCompareLeft(cmd,"scr") || ACR_RollCompareLeft(cmd,"dec")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_DECIPHER_SCRIPT);
	}
	else if (ACR_RollCompareLeft(cmd,"dip")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_DIPLOMACY);
	}
	else if (ACR_RollCompareLeft(cmd,"tra") || ACR_RollCompareLeft(cmd,"disa") || cmd == "dd") {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_DISABLE_TRAP);
	}
	else if (ACR_RollCompareLeft(cmd,"disg") || cmd == "dis") {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_DISGUISE);
	}
	else if (ACR_RollCompareLeft(cmd,"esc") || ACR_RollCompareLeft(cmd,"art") || cmd == "ea") {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_ESCAPE_ARTIST);
	}
	else if (ACR_RollCompareLeft(cmd,"inti")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_INTIMIDATE);
	}
	else if (ACR_RollCompareLeft(cmd,"for")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_FORGERY);
	}
	else if (ACR_RollCompareLeft(cmd,"gat") || ACR_RollCompareLeft(cmd,"inf") || cmd == "gi") {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_GATHER_INFORMATION);
	}
	else if (ACR_RollCompareLeft(cmd,"han")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_HANDLE_ANIMAL);
	}
	else if (ACR_RollCompareLeft(cmd,"hea")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_HEAL);
	}
	else if (ACR_RollCompareLeft(cmd,"hid")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_HIDE);
	}
	else if (ACR_RollCompareLeft(cmd,"jum")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_JUMP);
	}
	else if (ACR_RollCompareLeft(cmd,"arca") || cmd == "arc") {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_KNOWLEDGE_ARCANA);
	}
	else if (ACR_RollCompareLeft(cmd,"arch") || ACR_RollCompareLeft(cmd,"eng")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_KNOWLEDGE_ENGINEERING);
	}
	else if (ACR_RollCompareLeft(cmd,"dun")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_KNOWLEDGE_DUNGEONEERING);
	}
	else if (ACR_RollCompareLeft(cmd,"geo")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_KNOWLEDGE_GEOGRAPHY);
	}
	else if (ACR_RollCompareLeft(cmd,"his")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_KNOWLEDGE_HISTORY);
	}
	else if (ACR_RollCompareLeft(cmd,"loc")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_KNOWLEDGE_LOCAL);
	}
	else if (ACR_RollCompareLeft(cmd,"nat")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_KNOWLEDGE_NATURE);
	}
	else if (ACR_RollCompareLeft(cmd,"nob") || ACR_RollCompareLeft(cmd,"roy")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_KNOWLEDGE_NOBILITY);
	}
	else if (ACR_RollCompareLeft(cmd,"rel")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_KNOWLEDGE_RELIGION);
	}
	else if (ACR_RollCompareLeft(cmd,"pla") || ACR_RollCompareLeft(cmd,"the p")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_KNOWLEDGE_THE_PLANES);
	}
	else if (ACR_RollCompareLeft(cmd,"lis")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_LISTEN);
	}
	else if (ACR_RollCompareLeft(cmd,"mov") || ACR_RollCompareLeft(cmd,"sne") || cmd == "ms") {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_MOVE_SILENTLY);
	}
	else if (ACR_RollCompareLeft(cmd,"pick l") || ACR_RollCompareLeft(cmd,"loc") || ACR_RollCompareLeft(cmd,"ope") || cmd == "ol") {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_OPEN_LOCK);
	}
	else if (ACR_RollCompareLeft(cmd,"par")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_PARRY);
	}
	else if (ACR_RollCompareLeft(cmd,"act")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_PERFORM_ACT);
	}
	else if (ACR_RollCompareLeft(cmd,"com")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_PERFORM_COMEDY);
	}
	else if (ACR_RollCompareLeft(cmd,"dan")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_PERFORM_DANCE);
	}
	else if (ACR_RollCompareLeft(cmd,"key")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_PERFORM_KEYBOARD);
	}
	else if (ACR_RollCompareLeft(cmd,"ora")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_PERFORM_ORATORY);
	}
	else if (ACR_RollCompareLeft(cmd,"dru") || ACR_RollCompareLeft(cmd,"per")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_PERFORM_PERCUSSION);
	}
	else if (ACR_RollCompareLeft(cmd,"stri") || cmd == "si") {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_PERFORM_STRING_INSTRUMENTS);
	}
	else if (ACR_RollCompareLeft(cmd,"win") || ACR_RollCompareLeft(cmd,"woo") || cmd == "wi") {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_PERFORM_WIND_INSTRUMENTS);
	}
	else if (ACR_RollCompareLeft(cmd,"sin")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_PERFORM_SING);
	}
	else if (ACR_RollCompareLeft(cmd,"pro")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_PROFESSION);
	}
	else if (ACR_RollCompareLeft(cmd,"rid")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_RIDE);
	}
	else if (ACR_RollCompareLeft(cmd,"sea")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_SEARCH);
	}
	else if (ACR_RollCompareLeft(cmd,"sen") || cmd == "sm") {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_SENSE_MOTIVE);
	}
	else if (ACR_RollCompareLeft(cmd,"sle") || ACR_RollCompareLeft(cmd,"pock p") || cmd == "pp" || cmd == "soh") {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_SLEIGHT_OF_HAND);
	}
	else if (ACR_RollCompareLeft(cmd,"spe") || cmd == "sc") {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_SPELLCRAFT);
	}
	else if (ACR_RollCompareLeft(cmd,"spo")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_SPOT);
	}
	else if (ACR_RollCompareLeft(cmd,"sur")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_SURVIVAL);
	}
	else if (ACR_RollCompareLeft(cmd,"swi")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_SWIM);
	}
	else if (ACR_RollCompareLeft(cmd,"tum")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_TUMBLE);
	}
	else if (ACR_RollCompareLeft(cmd,"use m") || ACR_RollCompareLeft(cmd,"mag") || ACR_RollCompareLeft(cmd,"dev") || cmd == "umd") {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_USE_MAGIC_DEVICE);
	}
	else if (ACR_RollCompareLeft(cmd,"rop") || ACR_RollCompareLeft(cmd,"use r") || cmd == "ur") {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_USE_ROPE);
	}

	// Bardic knowledge
	else if (ACR_RollCompareLeft(cmd,"bar")) {
		int nRank = GetLevelByClass(CLASS_TYPE_BARD, pc);
		if(nRank == 0)
		{
			SendMessageToPC(pc, "You are not a bard.");
			return;
		}
		nRank += GetAbilityModifier(ABILITY_INTELLIGENCE, pc);
		if(GetSkillRank(SKILL_KNOWLEDGE_HISTORY, pc, TRUE) >= 5)
			nRank+= 2;

		_HandleRoll(pc, "Bardic Knowledge", nRank, 0, TRUE, TRUE);
	}
	else 
	{
		SendMessageToPC(pc, "I don't understand the command '"+text+"'.  (Try #help for a list of commands.)");
	}
}

int ACR_Roll( int nDieCount, int nDieSides ) {
	int nTotal = 0;
	int i = 0;
	for ( i = 0; i < nDieCount; i++ ) {
		nTotal += Random( nDieSides ) + 1;
	}
	return nTotal;
}
