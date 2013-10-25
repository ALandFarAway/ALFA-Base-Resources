////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_craft_creation_i.nss
//       Author : Ronan
//
//  Local Variable Prefix = ACR_CRAFT
//
//  Dependencies external of nwscript:
//	CRAFTING_IPRP_SPELL_ROWS must be set to match the 2da file.
//	Resource names must match existing module resources.
//
//  Description
//	Because the logic of progress on crafting projects is seperate from the
//	creation of crafted items themselves, the crafting system is split into
//	two files.
//
////////////////////////////////////////////////////////////////////////////////

#ifndef ACR_CRAFT_CREATION_I
#define ACR_CRAFT_CREATION_I

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

const string ACR_CRAFT_STORE_PREFIX = "acr_craft_";
const string ACR_CRAFT_STORE_POTION = "acr_craft_potion";
const string ACR_CRAFT_STORE_WAND = "acr_craft_wand";
const string ACR_CRAFT_STORE_SCROLL = "acr_craft_scroll";

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "x2_inc_itemprop"
#include "acr_i"
#include "acr_tools_i"
#include "acr_craft_progress_i"
#include "acr_spells_i"

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

int GetIsCraftingStore(object oObject) {
	return GetObjectType(oObject) == OBJECT_TYPE_STORE && 
		GetSubString(GetTag(oObject), 0, GetStringLength(ACR_CRAFT_STORE_PREFIX)) == ACR_CRAFT_STORE_PREFIX;
}

void CraftingCreatorStoreOnClose(object oStore) {
	if(GetIsCraftingStore(oStore))
		ACR_DestroyObject(oStore);
}

void ACR_CraftingOnAcquireObject(object oItem, object oAcquiredBy, object oAcquiredFrom) {
	if(GetIsCraftingStore(oAcquiredFrom))
		MakeCraftingProjectFromItem(oItem, GetGoldPieceValue(oItem) / 2);
	
	if(GetIsDM(oAcquiredBy) && GetIsCraftingProject(oItem)) {
		FloatingTextStringOnCreature("Warning! Crafting projects saved on DM avatars will break! Give it to a player or put it in persistent storage.", oAcquiredBy, FALSE);
	}
}

void OpenCraftingInterface(string sName, object oPC) {
	object oStore = CreateObject(OBJECT_TYPE_STORE, sName, GetLocation(oPC), FALSE);
	if(oStore == OBJECT_INVALID)
		SendMessageToPC(oPC, "OBJECT_INVALID returned on CreateObject('" + sName + "') call, preventing crafting store creation. If this bug is not already reported, please report it!");
	else {
		OpenStore(oStore, oPC);
		object oItem = GetFirstItemInInventory(oStore);
		int nCasterLevel = ACR_GetHighestCasterLevel(oPC);
		while(oItem != OBJECT_INVALID) {
			if(_GetMinimumCasterLevel(oItem, GetGoldPieceValue(oItem)) > nCasterLevel || !GetHasFeat(CraftingFeatNeeded(oItem), oPC)) {
				DestroyObject(oItem);
			}
			oItem = GetNextItemInInventory(oStore);
		}
	}
}

#endif