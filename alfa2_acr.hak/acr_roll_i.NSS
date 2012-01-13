#include "acr_tools_i"
#include "acr_skills_i"

//! Parse a roll command
void ParseRoll(object pc, string cmd);

void ParseRoll(object pc, string cmd)
{
	int b,len,offset;
	string tmp,text=cmd;
	
	// kludge to handle nasty stuff like "craft: "
	
	if (TestStringAgainstPattern("(craft|knowledge|perform)**",cmd)) {

		tmp = "craft";
		if (CompareLeft(cmd,tmp)) {
			len = GetStringLength(cmd);
			offset = GetStringLength(tmp);

			cmd = GetStringRight(cmd,len-offset);
		}
		
		tmp = "knowledge";
		if (CompareLeft(cmd,tmp)) {
			len = GetStringLength(cmd);
			offset = GetStringLength(tmp);

			cmd = GetStringRight(cmd,len-offset);
		}

		tmp = "perform";
		if (CompareLeft(cmd,tmp)) {
			len = GetStringLength(cmd);
			offset = GetStringLength(tmp);

			cmd = GetStringRight(cmd,len-offset);
		}

		// eat characters
		do {
			b = CompareLeft(cmd, " ") + CompareLeft(cmd, "-") + CompareLeft(cmd, "(") + CompareLeft(cmd, ":");
			
			// no alterations needed
			if (!b)
				break;

			len = GetStringLength(cmd);

			cmd = GetStringRight(cmd,len-1);
		} while (b);
	}

	// saves
	if (CompareLeft(cmd,"for")) {
		ACR_Checks(CHECK_TYPE_SAVE, pc, SAVING_THROW_FORT);
	}
	else if (CompareLeft(cmd,"ref")) {
		ACR_Checks(CHECK_TYPE_SAVE, pc, SAVING_THROW_REFLEX);
	}
	else if (CompareLeft(cmd,"wil")) {
		ACR_Checks(CHECK_TYPE_SAVE, pc, SAVING_THROW_WILL);
	}

	// initiative
	else if (CompareLeft(cmd,"ini")) {

		ACR_InitCheck(pc, 0, TRUE, TRUE);
	}

	// abilities
	else if (CompareLeft(cmd,"stre") || cmd == "str") {
		ACR_Checks(CHECK_TYPE_STAT, pc, ABILITY_STRENGTH);
	}
	else if (CompareLeft(cmd,"dex")) {
		ACR_Checks(CHECK_TYPE_STAT, pc, ABILITY_DEXTERITY);
	}
	else if (CompareLeft(cmd,"cons") || cmd == "con") { 
		ACR_Checks(CHECK_TYPE_STAT, pc, ABILITY_CONSTITUTION);
	}
	else if (CompareLeft(cmd,"int")) {
		ACR_Checks(CHECK_TYPE_STAT, pc, ABILITY_INTELLIGENCE);
	}
	else if (CompareLeft(cmd,"wis")) {
		ACR_Checks(CHECK_TYPE_STAT, pc, ABILITY_WISDOM);
	}
	else if (CompareLeft(cmd,"cha")) {
		ACR_Checks(CHECK_TYPE_STAT, pc, ABILITY_CHARISMA);
	}
	
	// Combined skill rolls.
	else if (CompareLeft(cmd,"track")) {
		ACR_Checks(CHECK_TYPE_TRACK, pc);
	}
	else if (CompareLeft(cmd,"stealth")) {
		ACR_Checks(CHECK_TYPE_STEALTH, pc);
	}
	else if (CompareLeft(cmd,"perc")) {
		ACR_Checks(CHECK_TYPE_PERCEPTION, pc);
	}
	
	// Skills.
	else if (CompareLeft(cmd,"app")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_APPRAISE);
	}
	else if (CompareLeft(cmd,"bal")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_BALANCE);
	}
	else if (CompareLeft(cmd,"blu")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_BLUFF);
	}
	else if (CompareLeft(cmd,"cli")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_CLIMB);
	}
	else if (CompareLeft(cmd,"conc")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_CONCENTRATION);
	}
	else if (CompareLeft(cmd,"alc")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_CRAFT__ALCHEMY);
	}
	else if (CompareLeft(cmd,"arm")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_CRAFT_ARMORSMITHING);
	}
	else if (CompareLeft(cmd,"bow")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_CRAFT_BOWMAKING);
	}
	else if (CompareLeft(cmd,"wea")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_CRAFT_WEAPONSMITHING);
	}
	else if (CompareLeft(cmd,"scr") || CompareLeft(cmd,"dec")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_DECIPHER_SCRIPT);
	}
	else if (CompareLeft(cmd,"dip")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_DIPLOMACY);
	}
	else if (CompareLeft(cmd,"tra") || CompareLeft(cmd,"disa") || cmd == "dd") {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_DISABLE_TRAP);
	}
	else if (CompareLeft(cmd,"disg") || cmd == "dis") {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_DISGUISE);
	}
	else if (CompareLeft(cmd,"esc") || CompareLeft(cmd,"art") || cmd == "ea") {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_ESCAPE_ARTIST);
	}
	else if (CompareLeft(cmd,"for")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_FORGERY);
	}
	else if (CompareLeft(cmd,"gat") || CompareLeft(cmd,"inf") || cmd == "gi") {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_GATHER_INFORMATION);
	}
	else if (CompareLeft(cmd,"han")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_HANDLE_ANIMAL);
	}
	else if (CompareLeft(cmd,"hea")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_HEAL);
	}
	else if (CompareLeft(cmd,"hid")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_HIDE);
	}
	else if (CompareLeft(cmd,"jum")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_JUMP);
	}
	else if (CompareLeft(cmd,"arca") || cmd == "arc") {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_KNOWLEDGE_ARCANA);
	}
	else if (CompareLeft(cmd,"arch") || CompareLeft(cmd,"eng")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_KNOWLEDGE_ENGINEERING);
	}
	else if (CompareLeft(cmd,"dun")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_KNOWLEDGE_DUNGEONEERING);
	}
	else if (CompareLeft(cmd,"geo")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_KNOWLEDGE_GEOGRAPHY);
	}
	else if (CompareLeft(cmd,"his")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_KNOWLEDGE_HISTORY);
	}
	else if (CompareLeft(cmd,"loc")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_KNOWLEDGE_LOCAL);
	}
	else if (CompareLeft(cmd,"nat")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_KNOWLEDGE_NATURE);
	}
	else if (CompareLeft(cmd,"nob") || CompareLeft(cmd,"roy")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_KNOWLEDGE_NOBILITY);
	}
	else if (CompareLeft(cmd,"rel")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_KNOWLEDGE_RELIGION);
	}
	else if (CompareLeft(cmd,"pla") || CompareLeft(cmd,"the p")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_KNOWLEDGE_THE_PLANES);
	}
	else if (CompareLeft(cmd,"lis")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_LISTEN);
	}
	else if (CompareLeft(cmd,"mov") || CompareLeft(cmd,"sne") || cmd == "ms") {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_MOVE_SILENTLY);
	}
	else if (CompareLeft(cmd,"pick l") || CompareLeft(cmd,"loc") || CompareLeft(cmd,"ope") || cmd == "ol") {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_OPEN_LOCK);
	}
	else if (CompareLeft(cmd,"par")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_PARRY);
	}
	else if (CompareLeft(cmd,"act")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_PERFORM_ACT);
	}
	else if (CompareLeft(cmd,"com")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_PERFORM_COMEDY);
	}
	else if (CompareLeft(cmd,"dan")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_PERFORM_DANCE);
	}
	else if (CompareLeft(cmd,"key")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_PERFORM_KEYBOARD);
	}
	else if (CompareLeft(cmd,"ora")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_PERFORM_ORATORY);
	}
	else if (CompareLeft(cmd,"dru") || CompareLeft(cmd,"per")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_PERFORM_PERCUSSION);
	}
	else if (CompareLeft(cmd,"stri") || cmd == "si") {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_PERFORM_STRING_INSTRUMENTS);
	}
	else if (CompareLeft(cmd,"win") || CompareLeft(cmd,"woo") || cmd == "wi") {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_PERFORM_WIND_INSTRUMENTS);
	}
	else if (CompareLeft(cmd,"sin")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_PERFORM_SING);
	}
	else if (CompareLeft(cmd,"pro")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_PROFESSION);
	}
	else if (CompareLeft(cmd,"rid")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_RIDE);
	}
	else if (CompareLeft(cmd,"sea")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_SEARCH);
	}
	else if (CompareLeft(cmd,"sen") || cmd == "sm") {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_SENSE_MOTIVE);
	}
	else if (CompareLeft(cmd,"sle") || CompareLeft(cmd,"pock p") || cmd == "pp" || cmd == "soh") {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_SLEIGHT_OF_HAND);
	}
	else if (CompareLeft(cmd,"spe") || cmd == "sc") {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_SPELLCRAFT);
	}
	else if (CompareLeft(cmd,"spo")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_SPOT);
	}
	else if (CompareLeft(cmd,"sur")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_SURVIVAL);
	}
	else if (CompareLeft(cmd,"swi")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_SWIM);
	}
	else if (CompareLeft(cmd,"tum")) {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_TUMBLE);
	}
	else if (CompareLeft(cmd,"use m") || CompareLeft(cmd,"mag") || CompareLeft(cmd,"dev") || cmd == "umd") {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_USE_MAGIC_DEVICE);
	}
	else if (CompareLeft(cmd,"rop") || CompareLeft(cmd,"use r") || cmd == "ur") {
		ACR_Checks(CHECK_TYPE_SKILL, pc, SKILL_USE_ROPE);
	}

	// Bardic knowledge
	else if (CompareLeft(cmd,"bar")) {
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
		SendMessageToPC(pc, "I don't understand the command '"+text+"'");
	}
}