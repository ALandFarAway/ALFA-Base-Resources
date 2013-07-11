////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ACR Configuration File
//     Filename : acf_plc_onunlock.nss
//    $Revision:: 183        $ current version of the file
//        $Date:: 2006-12-21#$ date the file was created or modified
//       Author : Ronan
//
//  Local Variable Prefix =
//
//  Dependencies external of nwscript:
//
//  Description
//  This script calls the ACR's OnUnlock code for placeables, and any
//  custom code a server may need. It is not updated in ACR updates.
//
//  Revision History
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_items_i"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

int ACR_LOOTGEN_GENERATE_TRINKETS = 1;
int ACR_LOOTGEN_GENERATE_SPLITTABLE = 2;
int ACR_LOOTGEN_GENERATE_MAXVAL = 3;

int ACR_LOOTGEN_CURRENTLOOT_VPOOR = 1;
int ACR_LOOTGEN_CURRENTLOOT_POOR = 2;
int ACR_LOOTGEN_CURRENTLOOT_NORMAL = 3;
int ACR_LOOTGEN_CURRENTLOOT_RICH = 4;
int ACR_LOOTGEN_CURRENTLOOT_VRICH = 5;
int ACR_LOOTGEN_CURRENTLOOT_CUTOFF = 6;

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void main(int nCurrentLoot, int nLowestLevel, int nExperience, int nPCCount, int nDistribution, int nSpawnPriority) 
{
	if(!GetIsDM(OBJECT_SELF) && !GetIsDMPossessed(OBJECT_SELF))
	{
		SendMessageToPC(OBJECT_SELF, "This command is only for DMs");
		return;
	}
	if(nCurrentLoot == ACR_LOOTGEN_CURRENTLOOT_CUTOFF)
	{
		SendMessageToPC(OBJECT_SELF, "If any PC in the party is above the wealth cutoff, you should withhold any drops from the party until the affected PC reduces wealth or gains enough experience to no longer be at the cutoff. Please make note of experience awarded to poorer PCs so you may drop for them when the cut off PC is not present.");
		return;
	}
	if(nCurrentLoot < 1 || nCurrentLoot > 6)
	{
		SendMessageToPC(OBJECT_SELF, "That current wealth level is not recognized.");
		return;
	}
	if(nLowestLevel < 1 || nLowestLevel > 20)
	{
		SendMessageToPC(OBJECT_SELF, "The valid PC levels that can have loot generated for them are 1 to 20.");
		return;
	}
	if(nExperience == 0)
	{
		SendMessageToPC(OBJECT_SELF, "Cannot generate loot for a PC who has gained no experience.");
		return;
	}
	if(nPCCount == 0)
	{
		SendMessageToPC(OBJECT_SELF, "Cannot generate loot if there are not any PCs to generate loot for.");
		return;
	}
	if(nDistribution > 3 || nDistribution < 1)
	{
		SendMessageToPC(OBJECT_SELF, "That loot value distribution scheme is not recognized.");
		return;
	}
	
	
	object oContainer = GetPlayerCurrentTarget(OBJECT_SELF);
	if(GetObjectType(oContainer) != OBJECT_TYPE_PLACEABLE ||
	   GetHasInventory(oContainer) == FALSE)
	{
		oContainer = OBJECT_SELF;
	}
	
	// Multiply loot by the lowest multiplier for the party.
	int nLoot = nExperience;
	if(nLowestLevel < 9)
	{
		nLoot = (nLoot * 5) / 4;
	}
	else if(nLowestLevel < 13)
	{
		nLoot = (nLoot * 3) / 2;
	}
	else if(nLowestLevel < 17)
	{
		nLoot = nLoot * 5;
	}
	else
	{
		nLoot = nLoot * 10;
	}
	
	// Multiply loot by the number of people to be rewarded.
	nLoot *= nPCCount;
	
	// "Buyback adjustment" listed in session awards page
	nLoot = (nLoot * 11) / 10;
	
	// Adjustment for "non average" parties, 0-50% adjustment for a DMed session
	if(nCurrentLoot == ACR_LOOTGEN_CURRENTLOOT_POOR)
	{
		nLoot = (nLoot * 5) / 4;
	}
	else if(nCurrentLoot == ACR_LOOTGEN_CURRENTLOOT_VPOOR)
	{
		nLoot = (nLoot * 3) / 2;
	}
	else if(nCurrentLoot == ACR_LOOTGEN_CURRENTLOOT_RICH)
	{
		nLoot = (nLoot * 3) / 4;
	}
	else if(nCurrentLoot == ACR_LOOTGEN_CURRENTLOOT_VRICH)
	{
		nLoot = nLoot / 2;
	}

	int nMaxItem = 0;
	if(nDistribution == ACR_LOOTGEN_GENERATE_TRINKETS)
	{
		nMaxItem = nLoot / nPCCount;
		int nMaxItemByLevel = GetMaxItemValue(nLowestLevel);
		if(nMaxItemByLevel < nMaxItem)
		{
			nMaxItem = nMaxItemByLevel;
		}
		nMaxItem /= 2;
		if(nMaxItem > 750)      nMaxItem = 750;
		else if(nMaxItem > 300) nMaxItem = 300;
		else if(nMaxItem > 50)  nMaxItem = 50;
	}
	else if(nDistribution == ACR_LOOTGEN_GENERATE_MAXVAL)
	{
		nMaxItem = GetMaxItemValue(nLowestLevel);
	}
	else
	{
		nMaxItem = nLoot / nPCCount;
		int nMaxItemByLevel = GetMaxItemValue(nLowestLevel);
		if(nMaxItemByLevel < nMaxItem)
		{
			nMaxItem = nMaxItemByLevel;
		}
	}
	
	SendMessageToPC(OBJECT_SELF, "Generating "+IntToString(nLoot)+" gold worth of loot in "+GetName(oContainer)+"'s inventory, with no single item worth more than "+IntToString(nMaxItem)+" gold.");
	ACR_GenerateLoot(oContainer, nLoot, nMaxItem, nSpawnPriority);
}