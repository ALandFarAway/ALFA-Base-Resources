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

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "x2_inc_itemprop"
#include "acr_i"
#include "acr_tools_i"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

const float ACR_CRAFTING_COST = 0.50;

const float ACR_CRAFTING_XP_PER_GP = 0.08;

const int IPRP_SPELL_ROWS = 1100;

const int ACR_CRAFTING_DAILY_MAGIC_VALUE = 1000;

const string ACR_CRAFT_PROJECT_PREFIX = "Unfinished ";

const string _IS_CRAFT_PROJECT = "ACR_CRAFT_PROJECT";
const string _CRAFT_PROJECT_INVESTED = "ACR_CRAFT_GP_INVESTED";

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! Increments the crafting project by nDays days. Removes gp and xp from oCrafter.
//! If nDays = -1, time is not a limiting factor on item creation (e.g., for potions).
//! Returns TRUE if the project is complete, FALSE otherwise.
int IncrementCrafting(object oCrafter, object oProjet, int nDays = 1);

//! Returns the amount of gp invested in oProjet.
//! Returns 0 if oProject is not a crafting project.
int GetProjectInvestment(object oProjet);

//! Returns the total amount of gp that would be invested in oItem if it was completed.
//! Returns 0 if oProject is not a crafting project.
int GetCompletedProjectInvestment(object oProjet);

//! Should be called from the OnEquipItem hook only.
void ACR_CraftOnEquipItem(object oPC, object oItem);

//! Turns a crafting project into its finished item, and returns its reference.
//! Returns OBJECT_INVALID on an error.
object MakeItemFromCraftingProject(object oItem);

//! Turns an item into a crafting project and returns its reference.
//! Returns OBJECT_INVALID on an error.
object MakeCraftingProjectFromItem(object oItem);

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

object GetCraftingIndexObject() { return GetModule(); }

int GetIsCraftingProject(object oItem) {
	return (GetLocalInt(oItem, _IS_CRAFT_PROJECT));
}

/*string GetProjectTag(object oItem) {
	if(!GetIsCraftingProject(oItem)) return "";
	
	return ""; // FIX ME !! Return the proper tag.
}*/

void IndexSpellCastItemProperties() {
	int i;
	for(i=0; i<IPRP_SPELL_ROWS; i++) {
		string sIndex = Get2DAString("iprp_spells", "SpellIndex", i);
		string sCasterLevel = Get2DAString("iprp_spells", "CasterLvl", i);
		if(sIndex != "" && sCasterLevel != "") {
			// Add spell/caster level to array of caster levels / iprp_spell IDs.
		}
	}
}

int GetProjectInvestment(object oProject) {
	return GetLocalInt(oProject, _CRAFT_PROJECT_INVESTED);
}

int GetCompletedProjectInvestment(object oProject) {
	int nPlot = GetPlotFlag(oProject);
	SetPlotFlag(oProject, FALSE);
	
	int nTotal = GetGoldPieceValue(oProject);
	
	SetPlotFlag(oProject, nPlot);
	
	return nTotal;
}

void _SetProjectInvestment(object oProject, int nGP) {
	SetLocalInt(oProject, _CRAFT_PROJECT_INVESTED, nGP);
}

int IncrementMagicalCrafting(object oCrafter, object oProject, int nDays = 1) {

	int nCompletedInvestment =  GetCompletedProjectInvestment(oProject);

	// First we figure out how much can be invested given the gp, xp and time allotted.
	int nMaxGPInvestment = (nDays > -1) ? (nDays * ACR_CRAFTING_DAILY_MAGIC_VALUE) : nCompletedInvestment;
	
	// Check if we're limited by the work remaining on the project.
	int nCurrentInvestment = GetProjectInvestment(oProject);
	int nInvestmentRemaining = nCompletedInvestment - nCurrentInvestment;
	if(nMaxGPInvestment > nInvestmentRemaining)
		nMaxGPInvestment = nInvestmentRemaining;
	
	// Check if we're limited by the PC's GP.
	int nAvailableGold = GetGold(oCrafter);
	if(nAvailableGold < nMaxGPInvestment) {
		nMaxGPInvestment = nAvailableGold;
		FloatingTextStringOnCreature("You only have " + IntToString(nMaxGPInvestment) + " free GP today and cannot purchase as many crafting materials as you could use.", oCrafter, FALSE);
	}
	
	int nAvailableXP = XPGainedSinceLevel(oCrafter);
	int nMaxXPInvestment = FloatToInt(IntToFloat(nMaxGPInvestment) * ACR_CRAFTING_XP_PER_GP);
	
	// Check if we're limited by the PC's XP.
	if(nAvailableXP < nMaxXPInvestment) {
		nMaxGPInvestment = FloatToInt(IntToFloat(nAvailableXP) / ACR_CRAFTING_XP_PER_GP);
		FloatingTextStringOnCreature("You only have " + IntToString(nMaxGPInvestment) + " free XP today and cannot craft to use any more than that.", oCrafter, FALSE);
	}

	TakeGoldFromCreature(nMaxGPInvestment, oCrafter, TRUE, TRUE);
	GiveXPToCreature(oCrafter, -nMaxXPInvestment);
	nCurrentInvestment = nCurrentInvestment + nMaxGPInvestment;
	FloatingTextStringOnCreature("You work on " + GetName(oProject) + ", putting " + IntToString(nMaxGPInvestment) + " GP worth of materials into it for a total of " + IntToString(nCurrentInvestment) + " GP invested. You have " + IntToString(nCompletedInvestment - nCurrentInvestment) + " GP left.", oCrafter, FALSE);
	
	if(nCurrentInvestment == nCompletedInvestment) {		
		MakeItemFromCraftingProject(oProject);
		FloatingTextStringOnCreature("You've completed " + GetName(oProject) + "!", oCrafter, FALSE);
		return TRUE;
	}
	
	return FALSE;
}

object MakeCraftingProjectFromItem(object oItem) {
	if(GetIsCraftingProject(oItem)) return OBJECT_INVALID;

	SetPlotFlag(oItem, TRUE);
	
	SetFirstName(oItem, ACR_CRAFT_PROJECT_PREFIX + GetName(oItem));
	
	// Add item property.
	return OBJECT_INVALID;
}

object MakeItemFromCraftingProject(object oItem) {
	
	if(!GetIsCraftingProject(oItem)) return OBJECT_INVALID;

	string sName = GetName(oItem);
	if(GetStringLeft(sName, GetStringLength(ACR_CRAFT_PROJECT_PREFIX)) == ACR_CRAFT_PROJECT_PREFIX)
		SetFirstName(oItem, GetStringRight(sName, GetStringLength(sName) - GetStringLength(ACR_CRAFT_PROJECT_PREFIX)));
	
	SetPlotFlag(oItem, FALSE);
	
	IPRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_CRAFTING_PROJECT, -1);
	
	return oItem;
}

int CraftingFeatNeeded(object oProject) {
	int nBaseItemType = GetBaseItemType(oProject);
	switch(nBaseItemType) {
		case BASE_ITEM_ENCHANTED_POTION:
		case BASE_ITEM_POTIONS:
			return FEAT_BREW_POTION;
		
		case BASE_ITEM_ENCHANTED_SCROLL:
		case BASE_ITEM_SCROLL:
		case BASE_ITEM_SPELLSCROLL:
			return FEAT_SCRIBE_SCROLL;
		
		case BASE_ITEM_ENCHANTED_WAND:
		case BASE_ITEM_MAGICWAND:
			return FEAT_CRAFT_WAND;
		
		case BASE_ITEM_RING: return FEAT_FORGE_RING;
		
		case BASE_ITEM_MAGICROD: return FEAT_CRAFT_ROD;
		
		case BASE_ITEM_GLOVES: return FEAT_CRAFT_WONDROUS_ITEMS;
		
		case BASE_ITEM_MAGICSTAFF:
		case BASE_ITEM_SHORT_MAGICSTAFF:
			return FEAT_CRAFT_STAFF;
		
		case BASE_ITEM_ARMOR:
		case BASE_ITEM_BOLT:
		case BASE_ITEM_ARROW:
		case BASE_ITEM_BULLET:
			return FEAT_CRAFT_MAGIC_ARMS_AND_ARMOR;
	}
	
	if(Get2DAString("baseitems", "PrefAttackDist", nBaseItemType) != "")
		return FEAT_CRAFT_MAGIC_ARMS_AND_ARMOR;
	
	return FEAT_CRAFT_WONDROUS_ITEMS;
}

void ACR_CraftOnEquipItem(object oPC, object oItem) {
	if(GetIsCraftingProject(oItem)) {
		FloatingTextStringOnCreature("This item is an unfinished crafting project and cannot be used!", oPC, FALSE);
		AssignCommand(oPC, ActionUnequipItem(oItem));
	}
}