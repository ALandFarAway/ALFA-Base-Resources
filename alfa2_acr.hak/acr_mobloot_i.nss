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

int MIN_INTELLIGENCE = 5;
int CHANCE_TO_LOOT = 50;
int nMobLootDebug = 1;

void MobLootDebug(string str);
void TransferAllItems(object oCreature, object oVictim);
void TransferItem(object oItem, object oCreature, object oVictim);
void CreatureLoot(object oCreature, object oVictim);
void ACR_CheckLootByMob(object oPC);

// This gets called in player death.  If we can figure out the killer, it has
// an intelligence of MIN_INTELLIGENCE or higher, and can roll at or below
// CHANCE_TO_LOOT, the mob gets the loot
void ACR_CheckLootByMob(object oPC)
{
    int nType;
    object oKiller;
    
    return;

    // Who got killed?
    MobLootDebug(GetName(oPC) + " killed");

    // Who killed her?
    oKiller = GetLocalObject(oPC, "ACR_DTH_LAST_DAMAGER");

    nType = GetRacialType(oKiller);


    if (GetIsPC(oKiller) || GetIsPC(GetMaster(oKiller)))
    {
        MobLootDebug("PK'd!");
        return;
    }

    MobLootDebug(GetName(oPC) + " killed by " + GetName(oKiller));

    // Is it smart enough?
    int nCreatureInt = GetAbilityScore(oKiller, ABILITY_INTELLIGENCE);
    if (nCreatureInt < MIN_INTELLIGENCE)
    {
        MobLootDebug("too dumb - int: " + IntToString(nCreatureInt));
        return;
    }

    MobLootDebug("smart enough - int: " + IntToString(nCreatureInt));

    // Is it lucky enough?
    if (nType == RACIAL_TYPE_ANIMAL ||
	nType == RACIAL_TYPE_BEAST ||
        nType == RACIAL_TYPE_CONSTRUCT ||
        nType == RACIAL_TYPE_ELEMENTAL ||
        nType == RACIAL_TYPE_OOZE ||
        nType == RACIAL_TYPE_VERMIN) {
	    
	    if (Random(100) > CHANCE_TO_LOOT)
	    {
        	MobLootDebug("not lucky enough");
	        return;
	    }
    }
    MobLootDebug("got lucky");

    // There goes my stuff!!
    CreatureLoot(oKiller, oPC);
}

void CreatureLoot(object oKiller, object oPC)
{
    // Make sure the killer is still alive
    if (GetIsDead(oKiller))
        return;

    // add pickup animation
    AssignCommand(oKiller, ActionMoveToObject(oPC, TRUE));
    AssignCommand(oKiller, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW,
       1.0, 2.0));

    // Go for the gold!
    int nAmtGold = GetGold(oPC);
    if (nAmtGold > 0)
    {
    	MobLootDebug("took "+IntToString(nAmtGold)+" gold");
	ACR_LogEvent(oPC, ACR_LOG_DROP, "Gold loss to Monster, "+IntToString(nAmtGold)+" gp.");
        TakeGoldFromCreature(nAmtGold, oPC, TRUE);
    }

    // Grab the goods
    TransferAllItems(oKiller, oPC);
}

//
void TransferItem(object oItem, object oCreature, object oVictim)
{
    if (Random(100) > CHANCE_TO_LOOT)
	    return;

    if (oItem != OBJECT_INVALID)
    {
	ACR_LogOnUnacquired(oItem, oVictim, FALSE);
        MobLootDebug(GetName(oCreature) + " looted " + GetName(oItem) +
           " from " + GetName(oVictim));

        //+++ AssignCommand(oCreature, ActionTakeItem(oItem, oVictim));
        //
        //ActionTakeItem doesn't seem to be a very reliable method.  Time
        // to bring out the big guns...
        CopyObject(oItem, GetLocation(oCreature), oCreature);
        DestroyObject(oItem);
    }
}

// This Function Removes All Items from a Creature
void TransferAllItems(object oCreature, object oVictim)
{
    object oItem;

    MobLootDebug("looting " + GetName(oVictim));

    TransferItem(GetItemInSlot(INVENTORY_SLOT_ARMS, oVictim), oCreature, oVictim);
    TransferItem(GetItemInSlot(INVENTORY_SLOT_ARROWS, oVictim), oCreature, oVictim);
    TransferItem(GetItemInSlot(INVENTORY_SLOT_BELT, oVictim), oCreature, oVictim);
    TransferItem(GetItemInSlot(INVENTORY_SLOT_BOLTS, oVictim), oCreature, oVictim);
    TransferItem(GetItemInSlot(INVENTORY_SLOT_BOOTS, oVictim), oCreature, oVictim);
    TransferItem(GetItemInSlot(INVENTORY_SLOT_BULLETS, oVictim), oCreature, oVictim);
    TransferItem(GetItemInSlot(INVENTORY_SLOT_CHEST, oVictim), oCreature, oVictim);
    TransferItem(GetItemInSlot(INVENTORY_SLOT_CLOAK, oVictim), oCreature, oVictim);
    TransferItem(GetItemInSlot(INVENTORY_SLOT_HEAD, oVictim), oCreature, oVictim);
    TransferItem(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oVictim), oCreature, oVictim);
    TransferItem(GetItemInSlot(INVENTORY_SLOT_LEFTRING, oVictim), oCreature, oVictim);
    TransferItem(GetItemInSlot(INVENTORY_SLOT_NECK, oVictim), oCreature, oVictim);
    TransferItem(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oVictim), oCreature, oVictim);
    TransferItem(GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oVictim), oCreature, oVictim);


    oItem = GetFirstItemInInventory(oVictim);
    while (oItem != OBJECT_INVALID)
    {
        // Check for stuff that shouldn't get looted, like visas and death tokens
        int nOkayToTransfer = TRUE;

        if (GetPlotFlag(oItem) || GetItemCursedFlag(oItem))
        {
            nOkayToTransfer = FALSE;
            MobLootDebug("suppress plot items");
        }

        //+++
        if (nOkayToTransfer)
            TransferItem(oItem, oCreature, oVictim);

        oItem = GetNextItemInInventory(oVictim);
    }
}

void MobLootDebug(string str)
{
    if (nMobLootDebug)
    {
        SendMessageToAllDMs(str);
        WriteTimestampedLogEntry(str);
    }
}

