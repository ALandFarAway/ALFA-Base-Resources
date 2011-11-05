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

const int _MOBLOOT_MIN_INT = 5;
int _MOBLOOT_LOOT_CHANCE = 50;

const string _MOBLOOT_SYSTEM_NAME = "acr_mobloot_i";

void _TransferAllItems(object oCreature, object oVictim);
void _TransferItem(object oItem, object oCreature, object oVictim);
void _CreatureLoot(object oCreature, object oVictim);
void ACR_CheckLootByMob(object oPC);

// This gets called in player death.  If we can figure out the killer, it has
// an intelligence of MIN_INTELLIGENCE or higher, and can roll at or below
// CHANCE_TO_LOOT, the mob gets the loot
void ACR_CheckLootByMob(object oPC)
{
    int nType;
    object oKiller;
    string s,k;
    
    return;

    ACR_CreateDebugSystem(_MOBLOOT_SYSTEM_NAME, DEBUG_TARGET_LOG | DEBUG_TARGET_DMS, DEBUG_TARGET_LOG | DEBUG_TARGET_DMS, DEBUG_TARGET_LOG | DEBUG_TARGET_DMS);

    s = GetName(oPC);

    // Who killed her?
    oKiller = GetLocalObject(oPC, "ACR_DTH_LAST_DAMAGER");

    k = GetName(oKiller);

    ACR_PrintDebugMessage(s + " killed by " + k, _MOBLOOT_SYSTEM_NAME, DEBUG_LEVEL_INFO);


    if (GetIsPC(oKiller) || GetIsPC(GetMaster(oKiller)))
    {
	ACR_PrintDebugMessage(s + " pked", _MOBLOOT_SYSTEM_NAME, DEBUG_LEVEL_INFO);
        return;
    }

    // Is it smart enough?
    int nCreatureInt = GetAbilityScore(oKiller, ABILITY_INTELLIGENCE);
    if (nCreatureInt < _MOBLOOT_MIN_INT)
    {
	ACR_PrintDebugMessage(IntToString(nCreatureInt) + " too low to loot", _MOBLOOT_SYSTEM_NAME, DEBUG_LEVEL_INFO);
        return;
    }

    nType = GetRacialType(oKiller);


    // Is it lucky enough?
    if (nType == RACIAL_TYPE_ANIMAL ||
	nType == RACIAL_TYPE_BEAST ||
        nType == RACIAL_TYPE_CONSTRUCT ||
        nType == RACIAL_TYPE_ELEMENTAL ||
        nType == RACIAL_TYPE_OOZE ||
        nType == RACIAL_TYPE_VERMIN) {
	    
	    if (Random(100) > _MOBLOOT_LOOT_CHANCE)
	    {
	        ACR_PrintDebugMessage("Wrong type to loot.", _MOBLOOT_SYSTEM_NAME, DEBUG_LEVEL_INFO);
	        return;
	    }
    }

    // There goes my stuff!!
    _CreatureLoot(oKiller, oPC);
}

void _CreatureLoot(object oKiller, object oPC)
{
    // Make sure the killer is still alive
    if (GetIsDead(oKiller)) {
        ACR_PrintDebugMessage("Looter is dead", _MOBLOOT_SYSTEM_NAME, DEBUG_LEVEL_INFO);
        return;
    }


    // add pickup animation
    AssignCommand(oKiller, ActionMoveToObject(oPC, TRUE));
    AssignCommand(oKiller, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW,
       1.0, 2.0));

    // Go for the gold!
    int nAmtGold = GetGold(oPC);
    if (nAmtGold > 0)
    {
	ACR_LogEvent(oPC, ACR_LOG_DROP, "Gold loss to Monster, "+IntToString(nAmtGold)+" gp.");
        ACR_PrintDebugMessage("Gold loss to Monster, "+IntToString(nAmtGold)+" gp.", _MOBLOOT_SYSTEM_NAME, DEBUG_LEVEL_INFO);
        TakeGoldFromCreature(nAmtGold, oPC, TRUE);
    }

    // Grab the goods
    _TransferAllItems(oKiller, oPC);
}

//
void _TransferItem(object oItem, object oCreature, object oVictim)
{
    if (Random(100) > _MOBLOOT_LOOT_CHANCE) {
        ACR_PrintDebugMessage("Skipping " + GetName(oItem) + " (" + GetTag(oItem) + ")", _MOBLOOT_SYSTEM_NAME, DEBUG_LEVEL_INFO);
        return;
    }

    if (oItem != OBJECT_INVALID)
    {
	ACR_LogOnUnacquired(oItem, oVictim, FALSE);
        ACR_PrintDebugMessage(GetName(oCreature) + " looted " + GetName(oItem) +
           " from " + GetName(oVictim), _MOBLOOT_SYSTEM_NAME, DEBUG_LEVEL_INFO);

        //+++ AssignCommand(oCreature, ActionTakeItem(oItem, oVictim));
        //
        //ActionTakeItem doesn't seem to be a very reliable method.  Time
        // to bring out the big guns...
        CopyObject(oItem, GetLocation(oCreature), oCreature);
        DestroyObject(oItem);
    }
}

// This Function Removes All Items from a Creature
void _TransferAllItems(object oCreature, object oVictim)
{
    object oItem;

    ACR_PrintDebugMessage("Looting GetName(oVictim)...", _MOBLOOT_SYSTEM_NAME, DEBUG_LEVEL_INFO);

    _TransferItem(GetItemInSlot(INVENTORY_SLOT_ARMS, oVictim), oCreature, oVictim);
    _TransferItem(GetItemInSlot(INVENTORY_SLOT_ARROWS, oVictim), oCreature, oVictim);
    _TransferItem(GetItemInSlot(INVENTORY_SLOT_BELT, oVictim), oCreature, oVictim);
    _TransferItem(GetItemInSlot(INVENTORY_SLOT_BOLTS, oVictim), oCreature, oVictim);
    _TransferItem(GetItemInSlot(INVENTORY_SLOT_BOOTS, oVictim), oCreature, oVictim);
    _TransferItem(GetItemInSlot(INVENTORY_SLOT_BULLETS, oVictim), oCreature, oVictim);
    _TransferItem(GetItemInSlot(INVENTORY_SLOT_CHEST, oVictim), oCreature, oVictim);
    _TransferItem(GetItemInSlot(INVENTORY_SLOT_CLOAK, oVictim), oCreature, oVictim);
    _TransferItem(GetItemInSlot(INVENTORY_SLOT_HEAD, oVictim), oCreature, oVictim);
    _TransferItem(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oVictim), oCreature, oVictim);
    _TransferItem(GetItemInSlot(INVENTORY_SLOT_LEFTRING, oVictim), oCreature, oVictim);
    _TransferItem(GetItemInSlot(INVENTORY_SLOT_NECK, oVictim), oCreature, oVictim);
    _TransferItem(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oVictim), oCreature, oVictim);
    _TransferItem(GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oVictim), oCreature, oVictim);


    oItem = GetFirstItemInInventory(oVictim);
    while (oItem != OBJECT_INVALID)
    {
        // Check for stuff that shouldn't get looted, like visas and death tokens
        int nOkayToTransfer = TRUE;

        if (GetPlotFlag(oItem) || GetItemCursedFlag(oItem))
        {
            nOkayToTransfer = FALSE;
            ACR_PrintDebugMessage("Suppress plot item " + GetName(oItem) + " (" + GetTag(oItem) + ")", _MOBLOOT_SYSTEM_NAME, DEBUG_LEVEL_INFO);
        }

        //+++
        if (nOkayToTransfer)
            _TransferItem(oItem, oCreature, oVictim);

        oItem = GetNextItemInInventory(oVictim);
    }
}

