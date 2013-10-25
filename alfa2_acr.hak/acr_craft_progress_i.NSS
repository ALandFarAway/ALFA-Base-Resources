////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_craft_i.nss
//       Author : Ronan
//
//  Local Variable Prefix = ACR_CRAFT
//
//  Dependencies external of nwscript:
//	IPRP_SPELL_ROWS must be set to match the 2da file.
//
//  Description
//	Because the logic of progress on crafting projects is seperate from the
//	creation of crafted items themselves, the crafting system is split into
//	two files.
//
////////////////////////////////////////////////////////////////////////////////

#ifndef ACR_CRAFT_PROGRESS_I
#define ACR_CRAFT_PROGRESS_I

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

const float ACR_CRAFTING_XP_PER_GP = 0.08;

const int IPRP_SPELL_ROWS = 1100;

const int ACR_CRAFTING_DAILY_MAGIC_VALUE = 500;

const string ACR_CRAFT_PROJECT_PREFIX = "Unfinished ";

const string ACR_CRAFT_GP_INVESTED = "ACR_CRAFT_GP_INVESTED";
const string ACR_CRAFT_NAME = "ACR_CRAFT_PROJECT_NAME";
const string ACR_CRAFT_DESCRIPTION = "ACR_CRAFT_DESCRIPTION";
const string ACR_CRAFT_XP_INVESTED = "ACR_CRAFT_XP_INVESTED";
const string ACR_CRAFT_PLOT_FLAG = "ACR_CRAFT_PLOT_FLAG";
const string ACR_CRAFT_PROPERTY_ACTIVATION = "ACR_CRAFT_PROPERTY_ACTIVATION";
const string ACR_CRAFT_SPELLS_IMBUED = "ACR_CRAFT_SPELLS_IMBUED";
const string ACR_CRAFT_STACK_SIZE = "ACR_CRAFT_STACK_SIZE";
const string ACR_CRAFT_TAG = "acr_craft_tag";
const string ACR_CRAFT_COST = "ACR_CRAFT_COST";
const string ACR_CRAFT_MINIMUM_CASTER_LEVEL = "ACR_CRAFT_MIN_CL";
const string ACR_CRAFT_XP_COST = "ACR_CRAFT_XP_COST";

const string ACR_CRAFT_CAST_SPELL_IPS = "ACR_CRAFT_CAST_SPELL_";

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

struct CraftingStatus {
	int gpInvested, xpInvested, gpTotal, xpTotal, featRequired, propActivation;
	int isProject, plotFlag, casterLevel, stackSize;
	string name, description, spellsNeeded, spellsImbued, tag;
	object item;
};

struct CraftingProgress {
	int gp, xp;
	// Other ingredients could go here.
};

struct ItemPropertyRequirements {
	int nSpellId, nCasterLevel;
};

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! Increments progress on a crafting item.
void ACR_DoCrafting( object oCrafter, object oTarget );

//! Should be called from the OnEquipItem hook only.
void ACR_CraftOnEquipItem(object oPC, object oItem);

//! Turns a crafting project into its finished item, and returns its reference.
//! Returns OBJECT_INVALID on an error.
object MakeItemFromCraftingProject(struct CraftingStatus status);

//! Turns an item into a crafting project and returns its reference.
//! Returns OBJECT_INVALID on an error.
object MakeCraftingProjectFromItem(object oItem, int gpInvested = 0);

//! Returns TRUE if oItem is a crafting project, and FALSE otherwise.
int GetIsCraftingProject(object oItem);

int CraftingFeatNeeded(object oItem);

string GetCraftingSpellsRequired(object oItem);

string GetCraftingProgressSummary(struct CraftingStatus status);

string _ReadableSpellList(string spellIds);

int _GetCraftingSpellForItemProperty(object oItem, itemproperty ip);

int _GetMinimumCasterLevel(object oItem, int nGP);

int ACR_CraftingSpellhook(object oCaster, object oTarget, object oItem, int nSpellId);

int _GetCraftingXPCost(int nGPCost);

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "x2_inc_itemprop"
#include "acr_i"
#include "acr_tools_i"
#include "acr_tradescroll_i"
#include "acr_array_i"
#include "acr_resting_i"
#include "acr_spells_i"
#include "acr_1984_i"

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

struct CraftingStatus GetCraftingStatus(object oItem) {
	struct CraftingStatus status;
	
	if(GetObjectType(oItem) != OBJECT_TYPE_ITEM) return status;
	
	status.item = oItem;	
	status.gpInvested = GetLocalInt(oItem, ACR_CRAFT_GP_INVESTED);
	status.xpInvested = GetLocalInt(oItem, ACR_CRAFT_XP_INVESTED);
	status.plotFlag = GetLocalInt(oItem, ACR_CRAFT_PLOT_FLAG);
	SetPlotFlag(oItem, FALSE);
	status.gpTotal = GetLocalInt(oItem, ACR_CRAFT_COST);
	SetPlotFlag(oItem, status.plotFlag);
	status.xpTotal = GetLocalInt(oItem, ACR_CRAFT_XP_COST);
	status.featRequired = CraftingFeatNeeded(oItem);
	status.name = GetLocalString(oItem, ACR_CRAFT_NAME);
	status.description = GetLocalString(oItem, ACR_CRAFT_DESCRIPTION);
	status.propActivation = GetLocalInt(oItem, ACR_CRAFT_PROPERTY_ACTIVATION);
	status.spellsNeeded = GetCraftingSpellsRequired(status.item);
	status.spellsImbued = GetLocalString(oItem, ACR_CRAFT_SPELLS_IMBUED);
	status.isProject = GetIsCraftingProject(oItem);
	status.casterLevel = GetLocalInt(oItem, ACR_CRAFT_MINIMUM_CASTER_LEVEL);
	status.stackSize = GetLocalInt(oItem, ACR_CRAFT_STACK_SIZE);
	status.tag = GetLocalString(oItem, ACR_CRAFT_TAG);
	
	return status;
}

void SaveCraftingStatus(struct CraftingStatus status) {
	SetLocalInt(status.item, ACR_CRAFT_GP_INVESTED, status.gpInvested);
	SetLocalInt(status.item, ACR_CRAFT_XP_INVESTED, status.xpInvested);
	SetLocalInt(status.item, ACR_CRAFT_COST, status.gpTotal);
	SetLocalInt(status.item, ACR_CRAFT_PLOT_FLAG, status.plotFlag);
	SetLocalString(status.item, ACR_CRAFT_NAME, status.name);
	SetLocalString(status.item, ACR_CRAFT_DESCRIPTION, status.description);
	SetLocalInt(status.item, ACR_CRAFT_PROPERTY_ACTIVATION, status.propActivation);
	SetLocalString(status.item, ACR_CRAFT_SPELLS_IMBUED, status.spellsImbued);
	SetLocalInt(status.item, ACR_CRAFT_STACK_SIZE, status.stackSize);
	SetLocalString(status.item, ACR_CRAFT_TAG, status.tag);
	SetDescription(status.item, GetCraftingProgressSummary(status));
	SetLocalInt(status.item, ACR_CRAFT_MINIMUM_CASTER_LEVEL, status.casterLevel);
	SetLocalInt(status.item, ACR_CRAFT_XP_COST, status.xpTotal);
}

void DeleteCraftingStatus(object oItem) {
	DeleteLocalInt(oItem, ACR_CRAFT_GP_INVESTED);
	DeleteLocalInt(oItem, ACR_CRAFT_XP_INVESTED);
	DeleteLocalString(oItem, ACR_CRAFT_NAME);
	DeleteLocalString(oItem, ACR_CRAFT_DESCRIPTION);
	DeleteLocalInt(oItem, ACR_CRAFT_PLOT_FLAG);
	DeleteLocalInt(oItem, ACR_CRAFT_PROPERTY_ACTIVATION);
	DeleteLocalString(oItem, ACR_CRAFT_SPELLS_IMBUED);
	DeleteLocalInt(oItem, ACR_CRAFT_STACK_SIZE);
	DeleteLocalString(oItem, ACR_CRAFT_TAG);
	DeleteLocalInt(oItem, ACR_CRAFT_COST);
	DeleteLocalInt(oItem, ACR_CRAFT_MINIMUM_CASTER_LEVEL);
	DeleteLocalInt(oItem, ACR_CRAFT_XP_COST);
}

int XpAvailableForCrafting(object oCreature) {
	if(!GetIsPC(oCreature) || GetIsDMPossessed(oCreature) || GetIsDM(oCreature)) {
		// Unlimited XP.
		return -1;
	} else {
		// Limited XP.
		return XPGainedSinceLevel(oCreature);
	}
}

struct CraftingProgress PossibleProgress(object oCreature, struct CraftingStatus status, int nDays = 1) {
	// This assumes all crafting is magical.
	
	struct CraftingProgress possible;
	possible.gp = status.gpTotal - status.gpInvested;
	possible.xp = status.xpTotal - status.xpInvested;
	if(possible.gp < 0) possible.gp = 0;
	if(possible.xp < 0) possible.xp = 0;
	
	if(nDays > 0 && GetObjectType(status.item) != BASE_ITEM_POTIONS) {
		// Limited-time available and not a potion? We can only craft so much.
		// In the future we might have to distinguish between magical and non-magical potions.
		int gpPerDays = FloatToInt(IntToFloat(nDays) * ACR_CRAFTING_DAILY_MAGIC_VALUE);
		int xpPerDays = FloatToInt(IntToFloat(gpPerDays) * ACR_CRAFTING_XP_PER_GP);
		possible.gp = (gpPerDays > possible.gp) ? possible.gp : gpPerDays;
		possible.xp = (xpPerDays > possible.xp) ? possible.xp : xpPerDays;
	}
	
	return possible;
}

string GetCraftingProgressSummary(struct CraftingStatus status) {

	string featName = GetFeatName(status.featRequired);

	return "Item name: " + status.name +
		"\nGP Invested / Total: " + IntToString(status.gpInvested) + " / " + IntToString(status.gpTotal) +
		"\nXP Invested / Total: " + IntToString(status.xpInvested) + " / " + IntToString(status.xpTotal) +
		"\nFeat required: " + (featName=="" ? "None" : featName) +
		"\nCaster level required: " + IntToString(status.casterLevel) +
		"\nSpells required: " + _ReadableSpellList(status.spellsNeeded) +
		"\nSpells currently imbued: " + _ReadableSpellList(status.spellsImbued);
}

void CraftingOnPCLoaded(object oPC) {
	FeatAdd(oPC, FEAT_CRAFT, FALSE);
}

int GetIsCraftingProject(object oItem) { return FindSubString(GetStringLowerCase(GetTag(oItem)), ACR_CRAFT_TAG) != -1; }

object MakeCraftingProjectFromItem(object oItem, int gpInvested = 0) {
	struct CraftingStatus status = GetCraftingStatus(oItem);
	if(status.isProject) return OBJECT_INVALID;
	
	status.name = GetName(status.item);
	status.description = GetDescription(status.item);
	status.propActivation = GetItemPropActivation(status.item);
	status.plotFlag = GetPlotFlag(status.item);
	status.gpInvested = gpInvested;
	status.stackSize = GetItemStackSize(oItem);
	status.tag = GetTag(oItem);
	SetPlotFlag(status.item, FALSE);
	
	status.gpTotal = GetGoldPieceValue(oItem) / 2;
	if(status.gpTotal * 2 < GetGoldPieceValue(oItem))
	{
		status.gpTotal++;
	}
	
	status.xpTotal = FloatToInt(IntToFloat(status.gpTotal) * ACR_CRAFTING_XP_PER_GP);
	if(FloatToInt(IntToFloat(status.xpTotal) / ACR_CRAFTING_XP_PER_GP) * 2 < GetGoldPieceValue(oItem))
	{
		status.xpTotal++;
	}
	SetPlotFlag(status.item, TRUE);
	status.casterLevel = _GetMinimumCasterLevel(oItem, status.gpTotal);
	
	SetFirstName(oItem, "Unfinished " + status.name);
	SetItemPropActivation(status.item, 0);	
	SetTag(oItem, ACR_CRAFT_TAG + "_" + IntToString(GenerateRandomSeed()));
	
	// Remove cast-spell properties on scrolls, so scrolls in-crafting cannot be scribed.
	if(GetBaseItemType(oItem) == BASE_ITEM_SPELLSCROLL) {
		itemproperty ip = GetFirstItemProperty(oItem);
		int i = 0;
		while(GetIsItemPropertyValid(ip)) {
			if(GetItemPropertyType(ip) == ITEM_PROPERTY_CAST_SPELL && GetItemPropertyCostTableValue(ip) == IP_CONST_CASTSPELL_NUMUSES_SINGLE_USE && GetItemPropertyDurationType(ip) == DURATION_TYPE_PERMANENT) {
				// Handle the special case of acid fog ip being zero.
				int ipst = GetItemPropertySubType(ip) ? GetItemPropertySubType(ip) : -1;
				SetLocalArrayInt(oItem, ACR_CRAFT_CAST_SPELL_IPS, i, GetItemPropertySubType(ip));
				RemoveItemProperty(oItem, ip);
				i++;
			}
			ip = GetNextItemProperty(oItem);
		}
	}
	
	SaveCraftingStatus(status);
	
	return status.item;
}

object MakeItemFromCraftingProject(struct CraftingStatus status) {
	if(!status.isProject) return OBJECT_INVALID;
	
	SetFirstName(status.item, status.name);
	SetDescription(status.item, status.description);
	SetItemPropActivation(status.item, status.propActivation);
	SetPlotFlag(status.item, status.plotFlag);
	SetItemStackSize(status.item, status.stackSize);
	SetTag(status.item, status.tag);
	
	// Add cast-spell properties back onto scrolls.
	if(GetBaseItemType(status.item) == BASE_ITEM_SPELLSCROLL) {
		int i = 0;
		while(TRUE) {
			int ip = GetLocalArrayInt(status.item, ACR_CRAFT_CAST_SPELL_IPS, i);
			if(!ip) break;
			// Handle the special case of acid fog ip being zero.
			if(ip == -1) ip = 0;
			AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyCastSpell(ip, IP_CONST_CASTSPELL_NUMUSES_SINGLE_USE), status.item);
			i++;
		}
	}

	DeleteCraftingStatus(status.item);
	
	return status.item;
}

int _GetMinimumCasterLevel(object oItem, int nGP) {
	int nValueLevel;
	
	int nHighestCastSpellLevel;
	itemproperty ip;
	ip = GetFirstItemProperty(oItem);
	while(GetIsItemPropertyValid(ip)) {
		int type = GetItemPropertyType(ip);
		if(type == ITEM_PROPERTY_CAST_SPELL || type == ITEM_PROPERTY_ONHITCASTSPELL) {
			int level = GetSpellLevelOfItemProperty(ip);
			nHighestCastSpellLevel = (level > nHighestCastSpellLevel) ? level : nHighestCastSpellLevel;
		}
		ip = GetNextItemProperty(oItem);
	}
	
	int type = GetBaseItemType(oItem);
	if(type == BASE_ITEM_POTIONS || type == BASE_ITEM_MAGICWAND || type == BASE_ITEM_SCROLL)
		return nHighestCastSpellLevel;
	
	if(nGP <= 300) nValueLevel = 1;
	else if(nGP <= 875) nValueLevel = 3;
	else if(nGP <= 1750) nValueLevel = 4;
	else if(nGP <= 2925) nValueLevel = 5;
	else if(nGP <= 4225) nValueLevel = 6;
	else if(nGP <= 6175) nValueLevel = 7;
	else if(nGP <= 8775) nValueLevel = 8;
	else if(nGP <= 11700) nValueLevel = 9;
	else if(nGP <= 15925) nValueLevel = 10;
	else if(nGP <= 21450) nValueLevel = 11;
	else if(nGP <= 28600) nValueLevel = 12;
	else if(nGP <= 35750) nValueLevel = 13;
	else if(nGP <= 48750) nValueLevel = 14;
	else if(nGP <= 65000) nValueLevel = 15;
	else if(nGP <= 84500) nValueLevel = 16;
	else if(nGP <= 110500) nValueLevel = 17;
	else if(nGP <= 143000) nValueLevel = 18;
	else if(nGP <= 188500) nValueLevel = 19;
	else if(nGP <= 252200) nValueLevel = 20;
	else nValueLevel = 21;
	
	if(nHighestCastSpellLevel > nValueLevel)
		return nHighestCastSpellLevel;
		else return nValueLevel;
}

int _GetCraftingSpellForItemProperty(object oItem, itemproperty ip) {

	if(GetItemPropertyDurationType(ip) != DURATION_TYPE_PERMANENT) return -1;

	int itemType = GetBaseItemType(oItem);
	int type = GetItemPropertyType(ip);
	int subType = GetItemPropertySubType(ip);
	int param1 = GetItemPropertyParam1(ip);
	int param1Value = GetItemPropertyParam1Value(ip);
	int costTable = GetItemPropertyCostTable(ip);
	int costTableValue = GetItemPropertyCostTableValue(ip);
	
	switch(type) {
		case ITEM_PROPERTY_ABILITY_BONUS:
			switch(subType) {
				case ABILITY_STRENGTH: return SPELL_BULLS_STRENGTH;
				case ABILITY_DEXTERITY: return SPELL_CATS_GRACE;
				case ABILITY_CONSTITUTION: return SPELL_BEARS_ENDURANCE;
				case ABILITY_INTELLIGENCE: return SPELL_FOXS_CUNNING;
				case ABILITY_WISDOM: return SPELL_OWLS_WISDOM;
				case ABILITY_CHARISMA: return SPELL_EAGLES_SPLENDOR;
			} break;
		case ITEM_PROPERTY_AC_BONUS:
		case ITEM_PROPERTY_AC_BONUS_VS_ALIGNMENT_GROUP:
		case ITEM_PROPERTY_AC_BONUS_VS_DAMAGE_TYPE:
		case ITEM_PROPERTY_AC_BONUS_VS_RACIAL_GROUP:
		case ITEM_PROPERTY_AC_BONUS_VS_SPECIFIC_ALIGNMENT:
		switch(itemType) {
				// +Armor bonus
				case BASE_ITEM_HELMET:
				case BASE_ITEM_BRACER:
				case BASE_ITEM_ARMOR:
					return -1;
				
				// +Natural armor bonus
				case BASE_ITEM_AMULET:
					return SPELL_BARKSKIN;
				
				// +Dodge bonus
				case BASE_ITEM_BOOTS:
					return SPELL_HASTE;
				
				// +Deflection bonus
				default:
					return SPELL_SHIELD_OF_FAITH;
			} break;
			
		case ITEM_PROPERTY_ARCANE_SPELL_FAILURE:
			return -1;
			
		case ITEM_PROPERTY_ATTACK_BONUS:
		case ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP:
		case ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP:
		case ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT:
			return SPELL_TRUE_STRIKE;
			
		case ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION:
			return -1; // Add feather fall here, when we  get it?
		
		case ITEM_PROPERTY_BONUS_FEAT: // Only bothering with ALFA-legal feats.
			switch(subType) {
				case IPRP_FEATS_ALERTNESS: return SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE;
				case IPRP_FEATS_COMBAT_CASTING: return SPELL_SHIELD;
				case IPRP_FEATS_DODGE: return SPELL_HASTE;
				case IPRP_FEATS_EXTRA_TURNING: return 3001;
				case IPRP_FEATS_MOBILITY: return SPELL_EXPEDITIOUS_RETREAT;
				case IPRP_FEATS_SPELL_PENETRATION: return SPELL_ASSAY_RESISTANCE;
				case IPRP_FEATS_TWO_WEAPON_FIGHTING: return SPELL_TRUE_STRIKE;
				case IPRP_FEATS_WEAPON_FINESSE: return SPELL_TRUE_STRIKE;
			} break;
		
		case ITEM_PROPERTY_BONUS_HITPOINTS:
			return SPELL_AID;
			
		case ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N:
			return -1;
			
		case ITEM_PROPERTY_CAST_SPELL:
			return GetSpellIdOfItemPropertySubtype(subType);
		
		case ITEM_PROPERTY_DAMAGE_BONUS:
		case ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP:
		case ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP:
		case ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT:
			return -1;
		
		case ITEM_PROPERTY_DAMAGE_REDUCTION:
		case ITEM_PROPERTY_DAMAGE_REDUCTION_DEPRECATED:
		case ITEM_PROPERTY_DAMAGE_RESISTANCE:
			return SPELL_STONESKIN;
		
		case ITEM_PROPERTY_DAMAGE_VULNERABILITY:
			return -1;
			
		case ITEM_PROPERTY_DARKVISION:
			return SPELL_LOW_LIGHT_VISION;		
		
		case ITEM_PROPERTY_DECREASED_ABILITY_SCORE:
		case ITEM_PROPERTY_DECREASED_AC:
		case ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER:
		case ITEM_PROPERTY_DECREASED_DAMAGE:
		case ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER:
		case ITEM_PROPERTY_DECREASED_SAVING_THROWS:
		case ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC:
		case ITEM_PROPERTY_DECREASED_SKILL_MODIFIER:
			return SPELL_BESTOW_CURSE;
		
		case ITEM_PROPERTY_ENHANCED_CONTAINER_REDUCED_WEIGHT:
			return -1; // Maybe feather fall? 3.5 requires Secret Chest.
		
		case ITEM_PROPERTY_ENHANCEMENT_BONUS:
		case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP:
		case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP:
		case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT:		
		case ITEM_PROPERTY_EXTRA_MELEE_DAMAGE_TYPE:
		case ITEM_PROPERTY_EXTRA_RANGED_DAMAGE_TYPE:
			return -1;
		
		case ITEM_PROPERTY_FREEDOM_OF_MOVEMENT:
			return SPELL_FREEDOM_OF_MOVEMENT;
		
		case ITEM_PROPERTY_HASTE:
			return SPELL_HASTE;
			
		case ITEM_PROPERTY_HEALERS_KIT:
			return SPELL_HEAL; // A silly BW item property.
			
		case ITEM_PROPERTY_HOLY_AVENGER:
			return SPELL_HOLY_SWORD;
			
		case ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE:
		case ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS:
		
		case ITEM_PROPERTY_IMMUNITY_SPECIFIC_SPELL:
			return costTableValue;
		
		case ITEM_PROPERTY_IMMUNITY_SPELL_SCHOOL:
		case ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL:
			return SPELL_LESSER_GLOBE_OF_INVULNERABILITY;
			
		case ITEM_PROPERTY_IMPROVED_EVASION:
			return SPELL_HASTE;
		
		case ITEM_PROPERTY_KEEN:
			return SPELL_KEEN_EDGE;
		
		case ITEM_PROPERTY_LIGHT:
			return SPELL_LIGHT;
		
		case ITEM_PROPERTY_MASSIVE_CRITICALS:
		case ITEM_PROPERTY_MIGHTY:
			return -1;
			
		case ITEM_PROPERTY_MIND_BLANK:
			return SPELL_MIND_BLANK;
		
		case ITEM_PROPERTY_MONSTER_DAMAGE:
		case ITEM_PROPERTY_NO_DAMAGE:
		case ITEM_PROPERTY_ON_HIT_PROPERTIES:
		case ITEM_PROPERTY_ON_MONSTER_HIT:
			return -1;
		
		case ITEM_PROPERTY_ONHITCASTSPELL:
			return GetSpellIdOfItemPropertySubtype(subType);
		
		case ITEM_PROPERTY_POISON:
			return SPELL_POISON;
			
		case ITEM_PROPERTY_REGENERATION:
			return SPELL_REGENERATE;
		
		case ITEM_PROPERTY_REGENERATION_VAMPIRIC:
			return SPELL_VAMPIRIC_TOUCH;
		
		case ITEM_PROPERTY_SAVING_THROW_BONUS:
		case ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC:
			return SPELL_RESISTANCE;
		
		case ITEM_PROPERTY_SKILL_BONUS:
			return SPELL_HEROISM;
		
		case ITEM_PROPERTY_SPECIAL_WALK:
			return -1;
		
		case ITEM_PROPERTY_SPELL_RESISTANCE:
			return SPELL_SPELL_RESISTANCE;
		
		case ITEM_PROPERTY_THIEVES_TOOLS:
			return SPELL_KNOCK;
		
		case ITEM_PROPERTY_TRAP:
			return -1;
		
		case ITEM_PROPERTY_TRUE_SEEING:
			return SPELL_TRUE_SEEING;
		
		case ITEM_PROPERTY_TURN_RESISTANCE:
			return SPELL_CREATE_UNDEAD;
		
		case ITEM_PROPERTY_UNLIMITED_AMMUNITION:
		case ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP:
		case ITEM_PROPERTY_USE_LIMITATION_CLASS:
		case ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE:
		case ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT:
		case ITEM_PROPERTY_VISUALEFFECT:
		case ITEM_PROPERTY_WEIGHT_INCREASE:
		default: -1;
	}
	
	return -1;
}

string GetCraftingSpellsRequired(object oItem) {
	string spells;
	itemproperty ip = GetFirstItemProperty(oItem);
	while(GetIsItemPropertyValid(ip)) {
		int nSpell = _GetCraftingSpellForItemProperty(oItem, ip);
		if(nSpell > -1) 
			spells += "#" + IntToString(nSpell);
		ip = GetNextItemProperty(oItem);
	}
	
	int i = 0;
	while(TRUE) {
		int nSpell = GetLocalArrayInt(oItem, ACR_CRAFT_CAST_SPELL_IPS, i);
		if(!nSpell) break;
		spells += "#" + IntToString(GetSpellIdOfItemPropertySubtype(nSpell));
		i++;
	}
	
	if(spells == "")
		return "";
	else return spells + "#";
}

string _ReadableSpellList(string spellIds) {

	if(spellIds == "" || spellIds == "#") return "";

	string spellNames;
	struct IntListIterator it;
	int first = TRUE;

	for (it = ACR_GetFirstInIntList(spellIds);
	     !ACR_IsIntListAtEnd(it);
		  it = ACR_GetNextInIntList(spellIds, it)) {

		if (first == TRUE)
			first = FALSE;
		else
			spellNames += ", ";

		spellNames += GetSpellName(ACR_GetIntListValue(spellIds, it));
	}
	
	return spellNames;
}

int CraftingFeatNeeded(object oItem) {
	int nBaseItemType = GetBaseItemType(oItem);
	
	if(Get2DAString("baseitems", "PrefAttackDist", nBaseItemType) != "")
		return FEAT_CRAFT_MAGIC_ARMS_AND_ARMOR;
	
	int nFeat;
	switch(nBaseItemType) {
		case BASE_ITEM_ENCHANTED_POTION:
		case BASE_ITEM_POTIONS:
			nFeat = FEAT_BREW_POTION;
			break;
		
		case BASE_ITEM_ENCHANTED_SCROLL:
		case BASE_ITEM_SCROLL:
		case BASE_ITEM_SPELLSCROLL:
			nFeat = FEAT_SCRIBE_SCROLL;
			break;
		
		case BASE_ITEM_ENCHANTED_WAND:
		case BASE_ITEM_MAGICWAND:
			nFeat = FEAT_CRAFT_WAND;
			break;
		
		case BASE_ITEM_RING: nFeat = FEAT_FORGE_RING; break;
		
		case BASE_ITEM_MAGICROD: nFeat = FEAT_CRAFT_ROD; break;
		
		case BASE_ITEM_MAGICSTAFF:
		case BASE_ITEM_SHORT_MAGICSTAFF:
			nFeat = FEAT_CRAFT_STAFF;
			break;
					
		case BASE_ITEM_ARMOR:
		case BASE_ITEM_BOLT:
		case BASE_ITEM_ARROW:
		case BASE_ITEM_BULLET:
			nFeat = FEAT_CRAFT_MAGIC_ARMS_AND_ARMOR;
			break;
			
		default:
			nFeat = FEAT_CRAFT_WONDROUS_ITEMS;
	}
	
	return nFeat;
}

void ACR_CraftOnEquipItem(object oPC, object oItem) {
	if(GetIsCraftingProject(oItem)) {
		FloatingTextStringOnCreature("This item is an unfinished crafting project and cannot be used!", oPC, FALSE);
		AssignCommand(oPC, ActionUnequipItem(oItem));
	}
}

int GetIsProjectReadyForWork(struct CraftingStatus status) {
	return GetStringLength(status.spellsImbued) == GetStringLength(status.spellsNeeded);
}

int ACR_CraftingSpellhook(object oCaster, object oTarget, object oItem, int nSpellId) {
	if(GetIsCraftingProject(oItem)) {
		SendMessageToPC(oCaster, "You cannot use an unfinished crafting project!");
		
		if(GetBaseItemType(oItem) == BASE_ITEM_MAGICWAND) 
			DelayCommand(0.1, SetItemCharges(oItem, GetItemCharges(oItem) + 1));
			
		SetModuleOverrideSpellScriptFinished();
		return TRUE;
	} else if(GetIsCraftingProject(oTarget)) {
		int nMasterId = GetMasterSpellId(nSpellId);
		if(nMasterId) nSpellId = nMasterId;
	
		struct CraftingStatus status = GetCraftingStatus(oTarget);

		if(status.spellsImbued == "") status.spellsImbued = "#";

		if(IsElementInStringList(status.spellsImbued, nSpellId))
			SendMessageToPC(oCaster, "This spell was already imbued in the item.");
		else if(!IsElementInStringList(status.spellsNeeded, nSpellId))
			SendMessageToPC(oCaster, "This spell is not needed to craft this item.");
		else if(GetItemStackSize(oTarget) > 1)
			SendMessageToPC(oCaster, "You can only imbue one item at a time. Separate one from the stack and try again.");
		else {
			status.spellsImbued += IntToString(nSpellId) + "#";
			SaveCraftingStatus(status);
			string message = "You imbue the spell into the item. ";
			message += (GetIsProjectReadyForWork(status)) ? ("It is ready to be worked on. Use the Craft feat on the item from within a rest zone.") : ("The item needs more spells imbued. Examine it for details.");
			SendMessageToPC(oCaster, message);
		}
		
		SetModuleOverrideSpellScriptFinished();
		return TRUE;
	}
	
	return FALSE;
}

void ACR_DoCrafting( object oCrafter, object oTarget ) {
	if(oTarget == OBJECT_INVALID || GetObjectType(oTarget) != OBJECT_TYPE_ITEM) {
		// If we are not targeting an item, print error and abort.
		SendMessageToPC(oCrafter, "Crafting only works on items.");
		IncrementRemainingFeatUses(oCrafter, FEAT_CRAFT);
		return;
	}
	
	struct CraftingStatus status = GetCraftingStatus(oTarget);
	
	if(GetIsDM(oCrafter) && !GetIsDMPossessed(oCrafter)) {
		// We're a DM.
		if(status.isProject) {
			// When a DM targets a crafting project, complete the project.
			SendMessageToPC(oCrafter, "Completing " + GetName(oTarget));
			MakeItemFromCraftingProject(status);
		} else {
			// When a DM targets a normal item, turn it into a crafting project.
			if(GetNumStackedItems(oTarget) > 1) {
				// Don't convert stacks of items - who knows what would happen. Later we might want to autmatically seperate them.
				SendMessageToPC(oCrafter, "You cannot convert a stack of items into a crafting project. Seperate one a single item first.");
				IncrementRemainingFeatUses(oCrafter, FEAT_CRAFT);
				return;
			}
			SendMessageToPC(oCrafter, "Turning " + GetName(oTarget) + " into a crafting project.");
			MakeCraftingProjectFromItem(oTarget);
		}
	} else {
		// We're a (N)PC.
		if(status.isProject) {
			// Targetting a crafting project. Try to craft.
			struct CraftingProgress possible = PossibleProgress(oCrafter, status);
			int bIsNPC = GetIsDMPossessed(oCrafter);
			int highestCasterLevel = ACR_GetHighestCasterLevel(oCrafter);
			string errors;
			
			if(GetItemStackSize(oTarget) > 1)
				errors += "\nCrafting projects should not be stackable! This is a bug; please report it and ask for a refund for the stacked projects.";
			if(GetLocalInt(oCrafter, ACR_FREE_SPELL_PREP))
				errors += "\nYou must finish selecting spells before you can craft.";
			if(highestCasterLevel < status.casterLevel) 
				errors += "\nYou need a caster level of " + IntToString(status.casterLevel) + ", but your highest is " + IntToString(highestCasterLevel) + ".";
			if(GetIsInCombat(oCrafter))
				errors += "\nYou can't craft while in combat.";
			if(!GetLocalInt(oCrafter, ACR_REST_ZONE))
				errors += "\nYou must be inside a rest zone (such as an inn, home, etc.). This represents the PC having a quiet place to work with tools and other implements handy. Tents in the wilderness don't cut it.";
			if(!GetHasFeat(status.featRequired, oCrafter))
				errors += "\nYou need the feat " + GetFeatName(status.featRequired) + ".";
			if(possible.gp > GetGold(oCrafter) && !bIsNPC)
				errors += "\nYou need " + IntToString(possible.gp) + " GP.";
			if(possible.xp > XPGainedSinceLevel(oCrafter) && !bIsNPC)
				errors += "\nYou need " + IntToString(possible.xp) + " free XP.";
			if(!GetIsProjectReadyForWork(status))
				errors += "\nThe project needs additional spells imbued before any crafting can be done. See the item's description for details, and cast the indicated spells on the item.";
			
			if(errors == "") {
				// Craft!
				if(possible.xp > 0) SetXP(oCrafter, GetXP(oCrafter) - possible.xp);
				if(possible.gp > 0) TakeGoldFromCreature(possible.gp, oCrafter, TRUE);				
				
				status.gpInvested += possible.gp;
				status.xpInvested += possible.xp;
				string invested = "Invested " + IntToString(possible.gp) + " GP, " + IntToString(possible.xp) + " XP.";
				if(status.gpInvested >= status.gpTotal && status.xpInvested >= status.xpTotal) {
					MakeItemFromCraftingProject(status);
					SendMessageToPC(oCrafter, invested + " Crafting complete.");
					ACR_LogEvent(oCrafter, "Crafting", "Created " + status.name + " costing a total of " + IntToString(status.gpTotal) + " GP.");
				}
				else {
					status.spellsImbued = "";
					SaveCraftingStatus(status);
					SendMessageToPC(oCrafter, "Crafting progress made: " + invested);
				}
			} else {
				SendMessageToPC(oCrafter, "You cannot craft " + status.name + " for the following reason(s):" + errors);
				IncrementRemainingFeatUses(oCrafter, FEAT_CRAFT);
			}
			
		} else {
			// Targeting something dumb.
			SendMessageToPC(oCrafter, "Use this feat to work on crafting projects. To start a crafting project, use the associated feat. Currently only Brew Potion, Craft Wand and Scribe Scroll are supported without DM aid.");
			IncrementRemainingFeatUses(oCrafter, FEAT_CRAFT);
		}
	}
}

#endif