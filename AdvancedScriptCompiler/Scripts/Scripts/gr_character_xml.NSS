// gr_character_xml
/*
	output character data to the log in XML format
*/
// ChazM 10/30/06
// ChazM 10/31/06 - Lots of additions 
// ChazM 11/2/06 - Fixed classes tag
// ChazM 11/8/06 - Added new fields under skills, modified XML tabbing
// ChazM 11/10/06 - Added Spell Class Levels
// ChazM 4/27/07 - Moved constants to ginc_2da

#include "ginc_debug"
#include "ginc_vars"
#include "x2_inc_craft"
#include "ginc_2da"

// ----------------------------------------
// XML Tags
// ----------------------------------------

// Output Text (convert to str refs eventually...
const string TEXT_TRUE 				= "TRUE";
const string TEXT_FALSE				= "FALSE";



// character XML
const string TAG_CHARACTER			= "Character";

// Basic stats XML
const string TAG_FIRST_NAME			= "FirstName";
const string TAG_LAST_NAME			= "LastName";
const string TAG_PLAYER_NAME		= "PlayerName";


const string TAG_ALIGNMENT			= "Alignment";
const string TAG_ALIGNMENT_LC_CONST	= "LawChaosConst";
const string TAG_ALIGNMENT_LC		= "LawChaos";
const string TAG_ALIGNMENT_GE_CONST	= "GoodEvilConst";
const string TAG_ALIGNMENT_GE		= "GoodEvil";

const string TAG_GOLD 				= "Gold";
const string TAG_EXPERIENCE 		= "Experience";
const string TAG_AGE 				= "Age";
const string TAG_ARMOR_CLASS 		= "ArmorClass";
const string TAG_BASE_ATTACK_BONUS 	= "BaseAttackBonus";
const string TAG_HIT_POINTS			= "HitPoints";
const string TAG_GENDER				= "Gender";

const string TAG_RACE				= "Race";
const string TAG_FORT_SAVE			= "FortSave";
const string TAG_WILL_SAVE			= "WillSave";
const string TAG_REFLEX_SAVE		= "ReflexSave";


// abilities XML
const string TAG_ABILITIES			= "Abilities";
const string TAG_ABILITY			= "Ability";
const string TAG_ABILITY_NAME		= "Name";
const string TAG_ABILITY_SCORE		= "Score";
const string TAG_ABILITY_MODIFIER	= "Modifier";

// inventory/equipment XML
const string TAG_INVENTORY_ITEMS	= "Equipment";
const string TAG_EQUIPPED_ITEMS		= "Equipped";

const string TAG_ITEM				= "Item";
const string TAG_ITEM_TYPE			= "Type";
const string TAG_ITEM_NAME			= "Name";
const string TAG_ITEM_WEIGHT		= "Weight";
const string TAG_ITEM_STACK_SIZE	= "StackSize";
const string TAG_ITEM_AC_VALUE		= "ACValue";
const string TAG_ITEM_CHARGES		= "Charges";


const string TAG_ITEM_PROPERTIES	= "ItemProperties";
const string TAG_ITEM_PROPERTY		= "ItemProperty";
const string TAG_ITEM_PROPERTY_TYPE	= "ItemPropertyType";
const string TAG_ITEM_PROPERTY_PARAM1 = "ItemPropertyParam1";
const string TAG_ITEM_PROPERTY_PARAM2 = "ItemPropertyParam2";
const string TAG_ITEM_PROPERTY_PARAM3 = "ItemPropertyParam3";
const string TAG_ITEM_PROPERTY_PARAM4 = "ItemPropertyParam4";


// skills XML
const string TAG_SKILLS				= "Skills";
const string TAG_SKILL				= "Skill";
const string TAG_SKILL_NAME 		= "Name";
const string TAG_SKILL_RANK 		= "Rank";
const string TAG_SKILL_RANK_BASE 	= "Base";
const string TAG_SKILL_TRAINED 		= "Trained";
const string TAG_SKILL_SPECIALTY 	= "Specialty";
const string TAG_SKILL_DESCRIPTION 	= "Description";


// Feats XML
const string TAG_FEATS				= "Feats";
const string TAG_FEAT				= "Feat";
const string TAG_FEAT_NAME 			= "Name";
const string TAG_FEAT_DESCRIPTION	= "Description";

// Spells XML
const string TAG_SPELLS_MEMORIZED	= "SpellsMemorized";
const string TAG_SPELL				= "Spell";
const string TAG_SPELL_NAME 		= "Name";
const string TAG_SPELL_INNATE_LEVEL = "InnateLevel";
const string TAG_SPELL_DESCRIPTION	= "Description";

const string TAG_SPELL_CLASS_LEVELS	= "ClassLevels";
const string TAG_SPELL_CLASS_LEVEL	= "ClassLevel";
const string TAG_SPELL_CLASS		= "Class";
const string TAG_SPELL_LEVEL		= "Level";



// Classes XML
const string TAG_CLASSES			= "Classes";
const string TAG_CLASS				= "Class";
const string TAG_CLASS_NAME			= "ClassName";
const string TAG_CLASS_LEVEL		= "ClassLevel";

// ----------------------------------------
// Various Constants
// ----------------------------------------
const string LF						= "";
const string TAB					= "    ";
const int TAB_SPACES				= 4;
//                                          1         2         3         4         5         6         7         8         9         0   
//            				       1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
const string BLANK_SPACE_100 	= "                                                                                                    ";


// ----------------------------------------
// globals
// ----------------------------------------
int giXMLTabLevel = -1;	// -1 will skip spacing for the outer <character> tag"



// =======================================================================
// Helper funcs
// =======================================================================
// output opening tag and increment tab level
string XMLOpen(string sTag)
{
	string sRet = "<"+sTag+">";
	giXMLTabLevel++;
	int iNumSpaces = (giXMLTabLevel) * TAB_SPACES;
	string sSpaces = GetStringLeft(BLANK_SPACE_100, iNumSpaces);
	PrintString(sSpaces + sRet);
	return sRet;
}

// decrement tab level, and output closing tag
string XMLClose(string sTag)
{
	string sRet = "</"+sTag+">" + LF;
	int iNumSpaces = (giXMLTabLevel) * TAB_SPACES;
	string sSpaces = GetStringLeft(BLANK_SPACE_100, iNumSpaces);
	PrintString(sSpaces + sRet);
	giXMLTabLevel--;
	return sRet;
}

string ReplaceSpecialChars(string sValue)
{
	int nPostion = FindSubString(sValue,"<");
	if (nPostion >= 0)
		sValue = "";
		
	nPostion = FindSubString(sValue,"&");
	if (nPostion >= 0)
		sValue = "";
		
	return (sValue);
}

// output all on one line tabbed out 1 additional level
string XML(string sTag, string sValue)
{
	sValue = ReplaceSpecialChars(sValue);
	string sRet = "<"+sTag+">" + sValue + "</"+sTag+">" + LF;
	int iNumSpaces = (giXMLTabLevel + 1) * TAB_SPACES;
	string sSpaces = GetStringLeft(BLANK_SPACE_100, iNumSpaces);
	PrintString(sSpaces + sRet);
	return sRet;
}

// =======================================================================
// ABILITIES
// =======================================================================

string GetAbilityName(int iAbility)
{
	string sRet;
	switch (iAbility)
	{		
		case ABILITY_STRENGTH:		sRet = "Strength";		break;
		case ABILITY_CONSTITUTION:	sRet = "Constitution";	break;
		case ABILITY_DEXTERITY:		sRet = "Dexterity";		break;
		case ABILITY_INTELLIGENCE:	sRet = "Intelligence";	break;
		case ABILITY_WISDOM:		sRet = "Wisdom";		break;
		case ABILITY_CHARISMA:		sRet = "Charisma";		break;
	}		
	return (sRet);
}

// Create a single Ability XML output
void XMLAbility(object oPC, int iAbility)
{
	XMLOpen(TAG_ABILITY);
		XML(TAG_ABILITY_NAME, GetAbilityName(iAbility));
		XML(TAG_ABILITY_SCORE, IntToString(GetAbilityScore(oPC, iAbility)));
		XML(TAG_ABILITY_MODIFIER, IntToString(GetAbilityModifier(iAbility, oPC)));
	XMLClose(TAG_ABILITY);
}

// Create all Abilities XML output
void XMLAbilities(object oPC)
{
	XMLOpen(TAG_ABILITIES);
		XMLAbility(oPC, ABILITY_STRENGTH);
		XMLAbility(oPC, ABILITY_CONSTITUTION);
		XMLAbility(oPC, ABILITY_DEXTERITY);
		XMLAbility(oPC, ABILITY_INTELLIGENCE);
		XMLAbility(oPC, ABILITY_WISDOM);
		XMLAbility(oPC, ABILITY_CHARISMA);
	XMLClose(TAG_ABILITIES);
}

// =======================================================================
// ITEMS
// =======================================================================

void XMLItemProperty(itemproperty ipItemProperty)
{
	int iPropType = GetItemPropertyType(ipItemProperty);
	int iPropTypeStrRef = StringToInt(Get2DAString(ITEM_PROPS_2DA, ITEM_PROPS_NAME_COL, iPropType));
	string sPropType = GetStringByStrRef(iPropTypeStrRef);
		
	XMLOpen(TAG_ITEM_PROPERTY);
		XML(TAG_ITEM_PROPERTY_TYPE, sPropType);
	XMLClose(TAG_ITEM_PROPERTY);
}

void XMLItemProperties(object oItem)
{
	XMLOpen(TAG_ITEM_PROPERTIES);
	
	//Get the first itemproperty
	itemproperty ipLoop=GetFirstItemProperty(oItem);
	
	//Loop for as long as the ipLoop variable is valid
	while (GetIsItemPropertyValid(ipLoop))
	{
		XMLItemProperty(ipLoop);		
		//Next itemproperty on the list...
		ipLoop=GetNextItemProperty(oItem);
	}
	XMLClose(TAG_ITEM_PROPERTIES);
}

void XMLBaseItemType(object oItem)
{
	int iBIT = GetBaseItemType(oItem);
	int iBITStrRef = StringToInt(Get2DAString(BIT_2DA, BIT_NAME_COL, iBIT));
	string sBITName = GetStringByStrRef(iBITStrRef);

	XML(TAG_ITEM_TYPE, sBITName);
}


// Create a single Item XML output
void XMLItem(object oItem)
{
	XMLOpen(TAG_ITEM);
		XML(TAG_ITEM_NAME, GetName(oItem));
		//XML(TAG_ITEM_VALUE, IntToString(GetValue(oItem)));
		XML(TAG_ITEM_WEIGHT, IntToString(GetWeight(oItem)));
		XML(TAG_ITEM_STACK_SIZE, IntToString(GetItemStackSize(oItem)));
		XML(TAG_ITEM_AC_VALUE, IntToString(GetItemACValue(oItem)));
		XML(TAG_ITEM_CHARGES, IntToString(GetItemCharges(oItem)));
		XMLBaseItemType(oItem);
		XMLItemProperties(oItem);
	XMLClose(TAG_ITEM);
}

// =======================================================================
// EQUIPPED ITEMS
// =======================================================================

void XMLEquippedItems(object oPC)
{
    int iSlot;
	object oInventoryItem;
	
    for (iSlot = 0; iSlot < NUM_INVENTORY_SLOTS; iSlot++)
    {
		oInventoryItem = GetItemInSlot(iSlot, oPC);
		if (oInventoryItem != OBJECT_INVALID)
			XMLItem(oInventoryItem);
	}		
}


// Create all EQUIPPED ITEMS XML output
void XMLEquipment(object oPC)
{
	XMLOpen(TAG_EQUIPPED_ITEMS);
		XMLEquippedItems(oPC);
	XMLClose(TAG_EQUIPPED_ITEMS);
}


// =======================================================================
// INVENTORY ITEMS
// =======================================================================

void XMLInventoryItems(object oPC)
{
    object oInventoryItem = GetFirstItemInInventory(oPC);
    while (oInventoryItem != OBJECT_INVALID)
    {
		XMLItem(oInventoryItem);
        oInventoryItem = GetNextItemInInventory(oPC);
    }
}

	
// Create all INVENTORY XML output
void XMLInventory(object oPC)
{
	XMLOpen(TAG_INVENTORY_ITEMS); 
		XMLInventoryItems(oPC);
	XMLClose(TAG_INVENTORY_ITEMS); 
}

// =======================================================================
// SKILLS
// =======================================================================

// Create a single Skill XML output (if creature has the skill)
void XMLSkill (int nSkill, object oPC)
{
	int iSkillRank = GetSkillRank(nSkill, oPC);
	int iBaseSkillRank = GetSkillRank(nSkill, oPC, TRUE);
	if (GetHasSkill(nSkill, oPC) && (iBaseSkillRank>=0))
	{
		int iSkillName = StringToInt(Get2DAString(SKILLS_2DA, SKILLS_NAME_COL, nSkill));
		string sSkillName = GetStringByStrRef(iSkillName);

		int iSkillDesc = StringToInt(Get2DAString(SKILLS_2DA, SKILLS_DESC_COL, nSkill));
		string sSkillDesc = GetStringByStrRef(iSkillDesc);
	
		string sTrained;
		if (iBaseSkillRank == 0)
			sTrained = TEXT_FALSE;
		else
			sTrained = TEXT_TRUE;
		
		
		XMLOpen(TAG_SKILL);
			XML(TAG_SKILL_NAME, sSkillName);
			XML(TAG_SKILL_RANK, IntToString(iSkillRank));
			XML(TAG_SKILL_RANK_BASE, IntToString(iBaseSkillRank));
			XML(TAG_SKILL_TRAINED, sTrained);
			//XML(TAG_SKILL_DESCRIPTION, sSkillDesc);
		XMLClose(TAG_SKILL);
	}				
}

// Create all Skills XML output
void XMLSkills(object oPC)
{
	int i;
	
	XMLOpen(TAG_SKILLS);
	
	for (i=1;i<=SKILLS_ROW_COUNT; i++)
		XMLSkill(i, oPC);
		
	XMLClose(TAG_SKILLS);
}


// =======================================================================
// FEATS
// =======================================================================

// Create a single feat XML output (if creature has the feat)
void XMLFeat (int nFeat, object oPC)
{
	if (GetHasFeat(nFeat, oPC, TRUE))
	{
		int iFeatName = StringToInt(Get2DAString(FEATS_2DA, FEATS_NAME_COL, nFeat));
		string sFeatName = GetStringByStrRef(iFeatName);
		
		int iFeatDescription = StringToInt(Get2DAString(FEATS_2DA, FEATS_DESC_COL, nFeat));
		string sFeatDescription = GetStringByStrRef(iFeatDescription);
		
		XMLOpen(TAG_FEAT);
			XML(TAG_FEAT_NAME, sFeatName);
			//XML(TAG_FEAT_DESCRIPTION, sFeatDescription);
		XMLClose(TAG_FEAT);
	}				
}

// Create all Feats XML output
void XMLFeats(object oPC)
{
	int i;
	
	XMLOpen(TAG_FEATS);
	
	for (i=1;i<=FEATS_ROW_COUNT; i++)
		XMLFeat(i, oPC);
		
	XMLClose(TAG_FEATS);
}

// =======================================================================
// SPELLS
// =======================================================================
// <SpellClassLevel>
// 	<SpellClass> Bard</SpellClass>
// 	<SpellLevel> 1</SpellLevel>

void XMLSpellClassLevel(int nSpell, int iClass)
{
	string sSpellClassLevel;
	int iSpellClassLevel = GetSpellLevelForClass(nSpell, iClass);
	if (iSpellClassLevel >= 0)
	{
		int iClassName = StringToInt(Get2DAString(CLASSES_2DA,CLASSES_NAME_COL, iClass));
		string sClassName = GetStringByStrRef(iClassName);
		XMLOpen(TAG_SPELL_CLASS_LEVEL);
	
			XML(TAG_SPELL_CLASS, sClassName);
			XML(TAG_SPELL_LEVEL, IntToString(iSpellClassLevel));
		XMLClose(TAG_SPELL_CLASS_LEVEL);
	}
}

void XMLSpellLevels(int nSpell, object oPC)
{
	XMLOpen(TAG_SPELL_CLASS_LEVELS);
	/*
		XMLSpellClassLevel(nSpell, CLASS_TYPE_BARD);
		XMLSpellClassLevel(nSpell, CLASS_TYPE_CLERIC);
		XMLSpellClassLevel(nSpell, CLASS_TYPE_DRUID);
		XMLSpellClassLevel(nSpell, CLASS_TYPE_PALADIN);
		XMLSpellClassLevel(nSpell, CLASS_TYPE_RANGER);
		XMLSpellClassLevel(nSpell, CLASS_TYPE_WIZARD);
		XMLSpellClassLevel(nSpell, CLASS_TYPE_WARLOCK);
	*/		
	int i=1;
	int iClass = GetClassByPosition(i, oPC);
	while (iClass != CLASS_TYPE_INVALID)
	{
		XMLSpellClassLevel(nSpell, iClass);
		i++;
		iClass = GetClassByPosition(i, oPC);
	}

	XMLClose(TAG_SPELL_CLASS_LEVELS);
}

// Create a single spell XML output (if creature has the spell memorised)
void XMLSpell (int nSpell, object oPC)
{
	int iSpellName = StringToInt(Get2DAString(SPELLS_2DA, SPELLS_NAME_COL, nSpell));
	string sSpellName = GetStringByStrRef(iSpellName);

	int iSpellDesc = StringToInt(Get2DAString(SPELLS_2DA, SPELLS_DESC_COL, nSpell));
	string sSpellDesc = GetStringByStrRef(iSpellDesc);

	string sSpellInnateLevel = Get2DAString(SPELLS_2DA, SPELLS_INNATE_LEVEL_COL, nSpell);
	
	XMLOpen(TAG_SPELL);
		XML(TAG_SPELL_NAME, sSpellName);
		XML(TAG_SPELL_INNATE_LEVEL, sSpellInnateLevel);
		XMLSpellLevels(nSpell, oPC);
		//XML(TAG_SPELL_DESCRIPTION, sSpellDesc);
	XMLClose(TAG_SPELL);
}

// Create all Spells XML output
void XMLSpellsMemorized(object oPC)
{
	int i;
	
	XMLOpen(TAG_SPELLS_MEMORIZED);
	
	for (i=1;i<=SPELLS_ROW_COUNT; i++)
	{
		if (GetHasSpell(i, oPC))
			XMLSpell(i, oPC);
	}	
	XMLClose(TAG_SPELLS_MEMORIZED);
}

// =======================================================================
// CLASSES/Levels
// =======================================================================

void XMLClass(int iClassPos, object oPC)
{
	int iClass = GetClassByPosition(iClassPos, oPC);
	int iClassName = StringToInt(Get2DAString(CLASSES_2DA,CLASSES_NAME_COL, iClass));
	string sClassName = GetStringByStrRef(iClassName);
	int iClassLevel = GetLevelByPosition(iClassPos, oPC);
	
	XMLOpen(TAG_CLASS);
		XML(TAG_CLASS_NAME, sClassName);
		XML(TAG_CLASS_LEVEL, IntToString(iClassLevel));
	XMLClose(TAG_CLASS);
}

void XMLClasses(object oPC)
{
	int i = 1;
	
	XMLOpen(TAG_CLASSES);
	while (GetClassByPosition(i, oPC) != CLASS_TYPE_INVALID)
	{
		XMLClass(i, oPC);
		i++;
	}
	XMLClose(TAG_CLASSES);
}

// =======================================================================
// MISC CHARACTER
// =======================================================================

// XML declaration and stylesheet attachment
void XMLHeader()
{
	string sRet;
	PrintString("<?xml version='1.0' encoding='ISO-8859-1'?>");
	PrintString("<?xml-stylesheet type='text/xsl' href='character.xsl'?>");
	// return sRet;
}

void XMLAlignment(object oPC)
{
	XMLOpen(TAG_ALIGNMENT);
		XML(TAG_ALIGNMENT_LC_CONST, IntToString(GetAlignmentLawChaos(oPC)));
		XML(TAG_ALIGNMENT_GE_CONST, IntToString(GetAlignmentGoodEvil(oPC)));
	XMLClose(TAG_ALIGNMENT);
}

void XMLGender(object oPC)
{
	XML(TAG_GENDER, IntToString(GetGender(oPC)));
}

void XMLRace(object oPC)
{
	int iRace = GetRacialType(oPC);
	int iRaceNameStrRef = StringToInt(Get2DAString(RACES_2DA, RACES_NAME_COL, iRace));
	string sRaceName = GetStringByStrRef(iRaceNameStrRef);

	XML(TAG_RACE, sRaceName);
}


void XMLSaves(object oPC)
{
    XML(TAG_FORT_SAVE, IntToString(GetFortitudeSavingThrow(oPC)));
    XML(TAG_REFLEX_SAVE, IntToString(GetReflexSavingThrow(oPC)));
    XML(TAG_WILL_SAVE, IntToString(GetWillSavingThrow(oPC)));
}

void XMLMiscInfo(object oPC)
{
	XML(TAG_FIRST_NAME, GetFirstName(oPC));
	XML(TAG_LAST_NAME, GetLastName(oPC));
	XML(TAG_PLAYER_NAME, GetPCPlayerName(oPC));
	//XML(TAG_PLAYER_CDKEY, GetPCPublicCDKey(oPC));
	
	
	XML(TAG_GOLD, IntToString(GetGold(oPC)));
	XML(TAG_EXPERIENCE, IntToString(GetXP(oPC)));
	XML(TAG_AGE, IntToString(GetAge(oPC)));
	XML(TAG_ARMOR_CLASS, IntToString(GetAC(oPC)));
	XML(TAG_BASE_ATTACK_BONUS, IntToString(GetBaseAttackBonus(oPC)));
	XML(TAG_HIT_POINTS, IntToString(GetMaxHitPoints(oPC)));

	XMLGender(oPC);
	XMLAlignment(oPC);
	XMLRace(oPC);
	XMLSaves(oPC);
}


// =======================================================================
// MAIN
// =======================================================================

// script calls iteself so as to avoid 
const string VAR_LOOP_COUNT 	= "char_loop_count";


// Use ExecuteScript to run this script on the desired object.
// ExecuteScript("ga_character_xml", oTarget));

void main()
{
    // object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
    object oPC = OBJECT_SELF;

	int iSetupCount = ModifyGlobalInt(VAR_LOOP_COUNT, 1);
	int bDone = FALSE;
	
	switch (iSetupCount)
	{
		case 1: 
	   		PrettyMessage("Export started, please wait...");

			PrintString("Save the following as '" + GetName(oPC) + ".xml'");
			PrintString("===================================================");
		
    		//PrettyMessage(IntToString(iSetupCount) + " - header");
			XMLHeader();	
			XMLOpen(TAG_CHARACTER);
			break;
	
		case 2: 
   			//PrettyMessage(IntToString(iSetupCount) + " - abilities, equipment, etc.");

			XMLMiscInfo(oPC);
			XMLClasses(oPC);
			XMLAbilities(oPC);
			XMLEquipment(oPC);
			break;
			
		case 3: 
   			//PrettyMessage(IntToString(iSetupCount) + " - inventory.");
			XMLInventory(oPC);
			break;

		case 4: 
			XMLSkills(oPC);
			XMLSpellsMemorized(oPC);
			break;

		case 5: 
			XMLFeats(oPC);		
			break;
			
		case 6: 
			break;
									
		default:
			XMLClose(TAG_CHARACTER);
			PrintString("===================================================");
			bDone = TRUE;
			PrettyMessage("Character data exported to XML format.");
			PrettyMessage("Data can be copied from the log to an XML file.");
	}

	if (!bDone)
	{
		DelayCommand(0.1f, ExecuteScript("gr_character_xml", OBJECT_SELF));
	}
	else
	{
		SetGlobalInt(VAR_LOOP_COUNT, 0);	// reset for next export.
	}

}