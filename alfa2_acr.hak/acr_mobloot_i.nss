/******************************************************************
 * Name: acr_mobloot_i
 * ---
 * Author: Cereborn
 * Date: 02/28/03
 * ---
 * These routines provide a mechanism for creatures to loot PCs
 * that they kill.  A (settable) minimum intelligence is required
 * for the creature, as well as (settable) die roll.
 ******************************************************************/

/* Includes */
#include "acr_1984_i"
#include "acr_debug_i"
#include "acr_i"

const int _MOBLOOT_MIN_INT = 5;
const float _MOBLOOT_DELAY = 30.0f;
const float _MOBLOOT_DISTANCE = 60.0f;
const int _MOBLOOT_LOOT_ITEM_CHANCE = 50;
const int _MOBLOOT_LOOT_CREATURE_CHANCE = 20;

const string _MOBLOOT_SYSTEM_NAME = "acr_mobloot_i";

void _TransferAllItems(object oCreature, object oVictim);
void _TransferItem(object oItem, object oCreature, object oVictim);
void _CreatureCheckLoot(object oCreature, string sVictim);
void _CreatureLoot(object oCreature, string sVictim);
void ACR_CheckLootByMob(object oPC);

// This gets called in player death.  If we can figure out the killer, it has
// an intelligence of MIN_INTELLIGENCE or higher
void ACR_CheckLootByMob(object oPC)
{
	int nType,nInt;
	object oKiller;
	string s,k;

	return;

	ACR_CreateDebugSystem(_MOBLOOT_SYSTEM_NAME, DEBUG_TARGET_LOG | DEBUG_TARGET_DMS, DEBUG_TARGET_LOG | DEBUG_TARGET_DMS, DEBUG_TARGET_LOG | DEBUG_TARGET_DMS);

	s = GetName(oPC);

	// Who killed her?
	oKiller = GetLocalObject(oPC, "ACR_DTH_LAST_DAMAGER");

	k = GetName(oKiller);

	ACR_PrintDebugMessage(s + " killed by " + k, _MOBLOOT_SYSTEM_NAME, DEBUG_LEVEL_INFO);


	if (GetIsPC(oKiller) || GetIsPC(GetMaster(oKiller))) {
		ACR_PrintDebugMessage(s + " pked", _MOBLOOT_SYSTEM_NAME, DEBUG_LEVEL_INFO);
		return;
	}

	// Is it smart enough?
	nInt = GetAbilityScore(oKiller, ABILITY_INTELLIGENCE);

	if (nInt < _MOBLOOT_MIN_INT) {
		ACR_PrintDebugMessage(IntToString(nInt) + " too low to loot", _MOBLOOT_SYSTEM_NAME, DEBUG_LEVEL_INFO);
		return;
	}

	nType = GetRacialType(oKiller);


	// If non-standard type, there's a chance of it looting
	if (nType == RACIAL_TYPE_ANIMAL ||
		nType == RACIAL_TYPE_BEAST ||
		nType == RACIAL_TYPE_CONSTRUCT ||
		nType == RACIAL_TYPE_ELEMENTAL ||
		nType == RACIAL_TYPE_OOZE ||
		nType == RACIAL_TYPE_VERMIN) {
		
		if (Random(100)+1 > _MOBLOOT_LOOT_CREATURE_CHANCE)
		{
			ACR_PrintDebugMessage("Wrong creature type to loot.", _MOBLOOT_SYSTEM_NAME, DEBUG_LEVEL_INFO);
			return;
		}
	}

	// There goes my stuff!!
	DelayCommand(_MOBLOOT_DELAY, AssignCommand(oKiller, _CreatureCheckLoot(oKiller, GetName(oPC))));
}

// check every once in a while to see if other PCs are around me. if so, stop looting
void _CreatureCheckLoot(object oKiller, string sPC)
{
	object oNextPC;

	oNextPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oKiller);

	if ((oNextPC != OBJECT_INVALID) && (GetDistanceBetween(oKiller, oNextPC) < _MOBLOOT_DISTANCE)) {
		ACR_PrintDebugMessage("Delaying checking for corpse of "+sPC, _MOBLOOT_SYSTEM_NAME, DEBUG_LEVEL_INFO);
		DelayCommand(_MOBLOOT_DELAY, _CreatureCheckLoot(oKiller, sPC));
		return;
	}
	_CreatureLoot(oKiller, sPC);
}

void _CreatureLoot(object oKiller, string sPC)
{
	object oPC;
	int i=1;

	// Make sure the killer is still alive
	if (GetIsDead(oKiller)) {
		ACR_PrintDebugMessage("Looter is dead", _MOBLOOT_SYSTEM_NAME, DEBUG_LEVEL_INFO);
		return;
	}

	while ((oPC = GetNearestObjectByTag(ACR_DTH_CORPSE_RESREF, oKiller, i)) != OBJECT_INVALID) {
		if (sPC != GetName(oPC))
			++i;
		else
			break;
	}

	// Can't find corpse, leave.
	if (oPC == OBJECT_INVALID) {
		ACR_PrintDebugMessage("Corpse vanished", _MOBLOOT_SYSTEM_NAME, DEBUG_LEVEL_INFO);
		return;
	}

	// add pickup animation
	AssignCommand(oKiller, ActionMoveToObject(oPC, TRUE));
	AssignCommand(oKiller, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW,
	   1.0, 2.0));

	// Grab the goods
	_TransferAllItems(oKiller, oPC);
}

void _TransferItem(object oItem, object oCreature, object oVictim)
{
	int nGold=0;

	if (oItem == OBJECT_INVALID)
		return;
	
	// Always loot gold
	if (GetTag(oItem) == ACR_NWN_GOLD_TAG)
		nGold = 1;

	if (!nGold && (Random(100)+1 > _MOBLOOT_LOOT_ITEM_CHANCE)) {
		ACR_PrintDebugMessage("Skipping " + GetName(oItem) + " (" + GetTag(oItem) + ")", _MOBLOOT_SYSTEM_NAME, DEBUG_LEVEL_INFO);
		return;
	}

	ACR_LogOnUnacquired(oItem, oVictim, FALSE);
	ACR_PrintDebugMessage(GetName(oCreature) + " looted " + GetName(oItem) + " from " + GetName(oVictim), _MOBLOOT_SYSTEM_NAME, DEBUG_LEVEL_INFO);

	CopyObject(oItem, GetLocation(oCreature), oCreature);
	DestroyObject(oItem);
}

// This Function Removes All Items from a Creature
void _TransferAllItems(object oCreature, object oVictim)
{
	object oItem;
	int nTransfer;

	ACR_PrintDebugMessage("Looting "+GetName(oVictim)+"...", _MOBLOOT_SYSTEM_NAME, DEBUG_LEVEL_INFO);

	oItem = GetFirstItemInInventory(oVictim);
	while (oItem != OBJECT_INVALID) {
		// Check for stuff that shouldn't get looted, like visas and death tokens
		nTransfer = TRUE;

		if (GetPlotFlag(oItem) || GetItemCursedFlag(oItem)) {
			nTransfer = FALSE;
			ACR_PrintDebugMessage("Suppress plot item " + GetName(oItem) + " (" + GetTag(oItem) + ")", _MOBLOOT_SYSTEM_NAME, DEBUG_LEVEL_INFO);
		}

		if (nTransfer)
			_TransferItem(oItem, oCreature, oVictim);

		oItem = GetNextItemInInventory(oVictim);
	}
}

