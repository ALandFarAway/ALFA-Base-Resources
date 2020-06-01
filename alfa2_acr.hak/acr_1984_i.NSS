////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_1984_i
//    $Revision:: 580        $ current version of the file
//        $Date:: 2009-08-02#$ date the file was created or modified
//       Author : Cipher & AcadiusLost
//
//    Var Prefix: LOG
//  Dependencies: NWNX, MYSQL
//
//  Description
//  This file contains the functions which monitor the activity of both PCs and
//  DMs. All data is logged to a central database for reporting purposes.
//
//  Revision History
//  2007/05/25  Cipher  Inception
//  2007/09/02  AcadiusLost - changed handling of ACR_GetHasIllegalProperties() to
//    account for and log possible null returns on GetItemPropertyType(), fixed the 
//    string concatenation. also added log types for combat XP and Resurrection
//  2007/09/18  AcadiusLost - added log types for combat-logging, bleed-logging,
//    and looting one's own corpse (with another PC)
//  2007/10/22  AcadiusLost - added log types for pchest access.
//  2007/12/01  AcadiusLost - added log type for RP XP 
//  2007/12/11  AcadiusLost - added log type of tech rez
//  2007/12/12  AcadiusLost - changed ACR_LogEvent to use ACR_SQLEncodeSpecialChars()
//  2008/04/11  Cipher  Added DM XP gain events
//  2008/04/15  Cipher  Added optional oDM parameter to LogEvent to record DM events
//  2008/09/27  AcadiusLost - added Area and Leader to logged events, also SUBDUAL log event type.
//  2008/11/15  AcadiusLost - added OverCR logging event, handling for oversized log event descriptions
//  2009/01/14  AcadiusLost - added Module Load log type/event.
//  2009/02/01  AcadiusLost - Migrated improved code into Acquired/Unacquired logs. Added number of items.
//  2009/02/11  AcadiusLost - Added log type for DM Validation from Quarantine
//  2009/03/01  AcadiusLost - Added exception handling to avoid logging script-destroyed items OnUnAcquire
//  2009/08/02  AcadiusLost - Added IPlogging OnLogout
//  2011/06/26  Ronan       - Changed all log writes to be asynchronous.
//  2011/08/05  Basilica    - Actually log server startup, allow log writes to not include a character (uses CharacterID == 0).
//  2011/12/26  Basilica    - Added server admin command log type.
//
////////////////////////////////////////////////////////////////////////////////

#ifndef ACR_1984_I
#define ACR_1984_I

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! These are all the possible event names
const string ACR_LOG_BAN = "Ban";
const string ACR_LOG_LOAD = "Load";
const string ACR_LOG_LOGIN = "Login";
const string ACR_LOG_LOGIN_BANNED = "Login, Banned";
const string ACR_LOG_LOGIN_DELETED = "Login, Deleted";
const string ACR_LOG_LOGIN_UNPLAYABLE = "Login, Unplayable";
const string ACR_LOG_LOGIN_QUARANTINED = "Login, Quarantined";
const string ACR_LOG_LOGIN_BAD_PLAYER_NAME = "Login, Illegal Player Name";
const string ACR_LOG_LOGIN_BAD_CHARACTER_NAME = "Login, Illegal Character Name";
const string ACR_LOG_LOGIN_PLAYER_NAME_NON_NORMALIZED = "Login, Player Name Non-Normalized";
const string ACR_LOG_LOGIN_CHARACTER_NAME_NON_NORMALIZED = "Login, Character Name Non-Normalized";
const string ACR_LOG_LOGOUT = "Logout";
const string ACR_LOG_DROP = "Drop";
const string ACR_LOG_DROP_ILLEGAL = "Drop, Illegal";
const string ACR_LOG_ACQUIRE = "Acquire";
const string ACR_LOG_ACQUIRE_ILLEGAL = "Acquire, Illegal";
const string ACR_LOG_ACTIVATE = "Activate";
const string ACR_LOG_TRANSITION = "Transition";
const string ACR_LOG_LEVELUP = "Level Up";
const string ACR_LOG_COMBAT = "Combat";
const string ACR_LOG_DEATH = "Death";
const string ACR_LOG_DYING = "Dying";
const string ACR_LOG_KILL = "Kill";
const string ACR_LOG_REZ = "Resurrection";
const string ACR_LOG_TECHREZ = "Tech Resurrection";
const string ACR_LOG_COMBATLOGOUT = "LOGOUT DURING COMBAT";
const string ACR_LOG_LOOTSELF = "SELF-LOOTING ATTEMPT";
const string ACR_LOG_BLEEDLOG = "LOGOUT WHILE BLEEDING";
const string ACR_LOG_PCHEST_O = "Persistant Storage, Opened";
const string ACR_LOG_PCHEST_C = "Persistant Storage, Closed";
const string ACR_LOG_COMBATXP = "XP Gain, Combat";
const string ACR_LOG_RPXP = "XP Gain, RP Scripts";
const string ACR_LOG_DMRPXP = "XP Gain, DM RP";
const string ACR_LOG_QUESTXP = "XP Gain, DM Quest";
const string ACR_LOG_BONUSXP = "XP Gain, DM Bonus";
const string ACR_LOG_STATICXP = "XP Gain, NPC Quest";
const string ACR_LOG_SETXP = "XP Change";
const string ACR_LOG_SUBDUAL = "Subdual";
const string ACR_LOG_OVERCR = "Over-CR combat kill";
const string ACR_LOG_SERVER_LOAD = "Server Loaded";
const string ACR_LOG_VALIDATED = "Validated";
const string ACR_LOG_SERVER_ADMIN_COMMAND = "Server Admin Command";
const string ACR_LOG_DEATH_FLOOR = "Death Floor";
const string ACR_LOG_SPAWN = "DM Spawn";
const string ACR_LOG_TSCROLL_CREATE = "Tradescroll, Created";
const string ACR_LOG_TSCROLL_LEARNED = "Tradescroll, Learned";

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! Log a specific event
//!  - oPC: the character that triggered the event; supply OBJECT_INVALID to
//          make the log entry not specific to any character.
//!  - sEventName: the name of the event - heading or classification
//!  - sEventDescription: the description of the event
//!  - oDM: optional DM object for logging DM events
//!  - Returns: Nothing
void ACR_LogEvent(object oPC, string sEventName, string sEventDescription, object oDM = OBJECT_INVALID);

//! Log the PC attempting to enter, including:
//!  a new character
//!  a dungeon master
//!  an attempted login by a player who is not a member
//!  an attempted login by a DM who is not a registered DM
//!  an attempted login by a DM who is not a registered DM on the server
//!  an attempted login where the authorization encountered an error
//!  - oPC: the PC entering the module
//!  - Returns: Nothing
void ACR_LogOnEnter(object oPC);

//! Log the PC attempting to exit
//!  - oPC: the new PC to log
//!  - Returns: Nothing
void ACR_LogOnExit(object oPC);

//! Log item acquisitions by barter or stealth
//!  - oItem: the item being acquired
//!  - oTaker: the player taking the item
//!  - Returns: Nothing
void ACR_LogOnAcquired(object oItem, object oTaker, int bStolen=FALSE);

//! Log discarded items by players 
//!  - oItem: the item being discarded
//!  - oGiver: the player losing the item
//!  - Returns: Nothing
void ACR_LogOnUnacquired(object oItem, object oGiver, int bStolen=FALSE);

//! Log gold acquisition from the ground
//!  - oTaker: the player taking the gold
//!  - nQuantity: amount of gold
//!  - Returns: Nothing
void ACR_LogOnAcquiredGold(object oTaker, int nQuantity);

//! Log discarded gold by players 
//!  - oGiver: the player losing the item
//!  - oContainer: the placeable container (if any) it is being put in
//!  - Returns: Nothing
void ACR_LogOnUnacquiredGold(object oGiver, int nQuantity, object oContainer = OBJECT_INVALID);

//! log item activation
//!  - oItem: the item being activated
//!  - oActivator: the player activating the item
//!  - oTarget: the target of the activation
//!  - Returns: Nothing
void ACR_LogOnActivate(object oItem, object oActivator, object oTarget);

//! log level up attempt
//!  - oPC: the PC trying to level up
//!  - Returns: Nothing
void ACR_LogOnLevelUp(object oPC);

//! Log combat statistics
//!  - oSource: the attacker
//!  - oTarget: the defender
//!  - Returns: Nothing
void ACR_LogOnCombat(object oSource, object oTarget);

//! Log death statistics
//!  - oKilled: the PC that died
//!  - oKiller: the creature that scored the kill
//!  - Returns: Nothing
void ACR_LogOnDeath(object oKilled, object oKiller);

//! Log the XP reward given to a PC
//!  - oPC: the PC that received the reward
//!  - Returns: Nothing
void ACR_LogXPReward(object oPC, int nXP);

//! Log the GP reward given to a PC
//!  - oPC: the PC that received the reward
//!  - Returns: Nothing
void ACR_LogGPReward(object oPC, int nGP);

//! Log the item reward given to a PC
//!  - oPC: the PC that received the reward
//!  - Returns: Nothing
void ACR_LogItemReward(object oPC, object oItem);

//! Log the the banned PC being booted
//!  - oPC: the banned PC that is being booted
//!  - Returns: Nothing
void ACR_LogBanBoot(object oPC);

//! Log the quarantined PC
//!  - oPC: the quarantined PC
//!  - Returns: Nothing
void ACR_LogQuarantine(object oPC);

//! Log the items possessed by a PC
//!  - oPC: the PC whose item possessions we are logging
//!  - Returns: Cumulative Inventory Value
int ACR_LogInventory(object oPC);

//! Check if an item has illegal properties
//!  - oItem: the item to evaluate
//!  - Returns: TRUE if illegal properties exist, FALSE if not
int ACR_GetHasIllegalProperties(object oItem);

//! Log when a module is loaded, so we get an idea of where/when crashes or 
//!  server resets are happening.  
void ACR_LogModuleLoaded();

//! Log a server admin command
//!  - oPC: the PC that issued the server admin command
//!  - sCmd: The server admin command that was issued
void ACR_LogServerAdminCommand(object oPC, string sCmd);

//! Log that a DM has spawned something
//!  - oDM: The DM performing the spawn
//!  - sSpawnMessage: Descriptive text of what is being spawned.
void ACR_LogDMSpawn(object oDM, string sSpawnMessage);

//! This is a copy of ACR_LogEvent, which can be run when the DM isn't necessarily logged
//! on at the time of the event.
void ACR_LogDMedEvent(object oPC, string sEventName, string sEventDescription, string sDMID);

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_db_persist_i"
#include "acr_settings_i"

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void ACR_LogEvent(object oPC, string sEventName, string sEventDescription, object oDM = OBJECT_INVALID)
{
	object oModule = GetModule();
	int nCharacterID;

	if (oPC == OBJECT_INVALID)
		nCharacterID = ACR_CHARACTER_ID_NONE;
	else
		nCharacterID = ACR_GetCharacterID(oPC);

    // log the event
	// add the area and party leader
	if (GetIsObjectValid(GetArea(oPC))) {
		sEventDescription = sEventDescription + " in area "+GetName(GetArea(oPC));
	}
	if (GetFactionLeader(oPC) != oPC) {
		sEventDescription = sEventDescription + " with leader: "+GetName(GetFactionLeader(oPC));
	}
	// check the overall length and truncate if necessary (varchar 128 field)
	if (GetStringLength(sEventDescription) > 128) {
		sEventDescription = GetStringLeft(sEventDescription, 128);
	}
    if (oDM != OBJECT_INVALID)
    {
        // include the DM character ID
        ACR_AsyncSQLQueryEx("INSERT INTO logs (ServerID, CharacterID, DMCharacterID, Event, Description) VALUES (" + IntToString(ACR_GetServerId()) + "," + IntToString(nCharacterID)  + "," + IntToString(ACR_GetCharacterID(oDM)) + ",'" + sEventName + "','" + ACR_SQLEncodeSpecialChars(sEventDescription) + "')", oModule);
    }
    else
    {
        ACR_AsyncSQLQueryEx("INSERT INTO logs (ServerID, CharacterID, Event, Description) VALUES (" + IntToString(ACR_GetServerId()) + "," + IntToString(nCharacterID) + ",'" + sEventName + "','" + ACR_SQLEncodeSpecialChars(sEventDescription) + "')", oModule);
    }
}

void ACR_LogDMedEvent(object oPC, string sEventName, string sEventDescription, string sDMID)
{
	object oModule = GetModule();
	int nCharacterID;

	if (oPC == OBJECT_INVALID)
		nCharacterID = ACR_CHARACTER_ID_NONE;
	else
		nCharacterID = ACR_GetCharacterID(oPC);

    // log the event
	// add the area and party leader
	if (GetIsObjectValid(GetArea(oPC))) {
		sEventDescription = sEventDescription + " in area "+GetName(GetArea(oPC));
	}
	if (GetFactionLeader(oPC) != oPC) {
		sEventDescription = sEventDescription + " with leader: "+GetName(GetFactionLeader(oPC));
	}
	// check the overall length and truncate if necessary (varchar 128 field)
	if (GetStringLength(sEventDescription) > 128) {
		sEventDescription = GetStringLeft(sEventDescription, 128);
	}
	
    ACR_AsyncSQLQueryEx("INSERT INTO logs (ServerID, CharacterID, DMCharacterID, Event, Description) VALUES (" + IntToString(ACR_GetServerId()) + "," + IntToString(nCharacterID)  + "," + sDMID + ",'" + sEventName + "','" + ACR_SQLEncodeSpecialChars(sEventDescription) + "')", oModule);
}

void ACR_LogOnEnter(object oPC)
{
//!  a new character
//!  a dungeon master
//!  an attempted login by a player who is not a member
//!  an attempted login by a DM who is not a registered DM
//!  an attempted login by a DM who is not a registered DM on the server
//!  an attempted login where the authorization encountered an error
}

void ACR_LogOnExit(object oPC)
{
	object oExitedArea = GetAreaFromLocation(ACR_StringToLocation(GetLocalString(oPC, "ACR_PPS_LOCATION"))); 
	ACR_LogEvent(oPC, ACR_LOG_LOGOUT, "Character: " + ACR_SQLEncodeSpecialChars(GetName(oPC)) + " in area " + ACR_SQLEncodeSpecialChars(GetName(oExitedArea))+ " using IP: "+GetPCIPAddress(oPC));
}

void ACR_LogOnAcquired(object oItem, object oTaker, int bStolen=FALSE)
{
	object oAcquiredFrom = GetModuleItemAcquiredFrom();
	string sAcquireLog = "";
	int nStack = GetItemStackSize(oItem);
	
	if (bStolen) {
		// flag as stolen in the logs
		sAcquireLog = "STOLEN; ";
	}
	if (GetObjectType(oAcquiredFrom) == OBJECT_TYPE_STORE) {
		// Item has been bought, log the purchase price.
		int nCost = GetLocalInt(oItem, "ACR_RETURNS_VALUE");
		sAcquireLog += "Bought ";
		if (nStack > 1) { sAcquireLog += IntToString(nStack) + " of "; }
		sAcquireLog += ACR_SQLEncodeSpecialChars(GetName(oItem)) + " for " + IntToString(nCost) + " gp from " + GetLocalString(oItem, "ACR_RETURNS_MERCHANT");
	} else {
		// item has been picked up
		sAcquireLog += "Item: ";
		if (nStack > 1) { sAcquireLog += IntToString(nStack) + " of "; }
		sAcquireLog += ACR_SQLEncodeSpecialChars(GetName(oItem)) + " with ResRef: " + GetResRef(oItem) + " and value " + IntToString(GetGoldPieceValue(oItem));
    	if (GetIsObjectValid(oAcquiredFrom)) { 
			sAcquireLog += ", From: " + ACR_SQLEncodeSpecialChars(GetName(oAcquiredFrom)); 
		}
	}
	if(GetLocalInt(oItem, "DM_MULED"))
	{
		ACR_LogDMedEvent(oTaker, ACR_LOG_ACQUIRE, sAcquireLog, IntToString(GetLocalInt(oItem, "DM_MULED")));
	}
	else
	{
		ACR_LogEvent(oTaker, ACR_LOG_ACQUIRE, sAcquireLog);
	}
	// SendMessageToPC(oTaker, sAcquireLog);
}


void ACR_LogOnUnacquired(object oItem, object oGiver, int bStolen=FALSE)
{
	// check for a merchant pointer
	object oStore = GetLocalObject(oGiver, "ACR_STORE");
	object oNewOwner = GetItemPossessor(oItem);
	int nLost = GetItemStackSize(oItem);
	string sUnAcquireDesc = "";
	if (bStolen) {
		sUnAcquireDesc = "Robbed of ";
	} else if (!GetIsObjectValid(oItem)) {
		if (GetIsObjectValid(oStore)) {
			// Items exist but register as invalid if they've just been sold.
			// PC is likely interacting with a store. Try to calculate and adjust for cost of item sold
			int nStoredGold = GetLocalInt(oGiver, "ACR_GOLD");
			int nGold = GetGold(oGiver);
			int nPrice = nGold - nStoredGold;
			string sMerchResRef = GetResRef(oStore);
			sUnAcquireDesc = "Sold: ";
			if (nLost > 1) { sUnAcquireDesc += IntToString(nLost) + " of "; }
			sUnAcquireDesc += ACR_SQLEncodeSpecialChars(GetName(oItem)) + " for "+IntToString(nPrice)+" gp to "+sMerchResRef;
			SetLocalInt(oGiver, "ACR_GOLD", nGold);
			// log the event here.
			ACR_LogEvent(oGiver, ACR_LOG_DROP, sUnAcquireDesc);
			// SendMessageToPC(oGiver, sUnAcquireDesc);
			return;
		} else {
			// Item was likely script-destroyed. nothing to log here
			// SendMessageToPC(oGiver, "Script-lost item: "+GetName(oItem));
			return;
		}
	} 
	sUnAcquireDesc += "Item: ";
	if (nLost > 1) { sUnAcquireDesc += IntToString(nLost) + " of "; }
	sUnAcquireDesc += ACR_SQLEncodeSpecialChars(GetName(oItem))  + " of value " + IntToString(GetGoldPieceValue(oItem));
	if ( GetIsObjectValid(oNewOwner)) {	
		sUnAcquireDesc += ", to: " + ACR_SQLEncodeSpecialChars(GetName(oNewOwner)); 
	} 
	ACR_LogEvent(oGiver, ACR_LOG_DROP, sUnAcquireDesc);
	// SendMessageToPC(oGiver, sUnAcquireDesc);
}

void ACR_LogOnAcquiredGold(object oTaker, int nQuantity)
{
    string sGoldGainedDesc = "Gold of value " + IntToString(nQuantity);
    ACR_LogEvent(oTaker, ACR_LOG_ACQUIRE, sGoldGainedDesc);
}

void ACR_LogOnUnacquiredGold(object oGiver, int nQuantity, object oContainer = OBJECT_INVALID)
{
    string sGoldLostDesc = "Gold of value " + IntToString(nQuantity);

    if (GetIsObjectValid(oContainer)) {
        sGoldLostDesc += ", to: " + ACR_SQLEncodeSpecialChars(GetName(oContainer));
    } 

    ACR_LogEvent(oGiver, ACR_LOG_DROP, sGoldLostDesc);
}

void ACR_LogOnActivate(object oItem, object oActivator, object oTarget)
{
}

void ACR_LogOnCombat(object oSource, object oTarget)
{
}

void ACR_LogOnDeath(object oKilled, object oKiller)
{
}

void ACR_LogOnLevelUp(object oPC)
{
}

void ACR_LogXPReward(object oPC, int nXP)
{
}

void ACR_LogGPReward(object oPC, int nGP)
{
}

void ACR_LogItemReward(object oPC, object oItem)
{
}

void ACR_LogBanBoot(object oPC)
{
}

void ACR_LogQuarantine(object oPC)
{
}

int ACR_LogInventory(object oPC)
{
    return 0;
}

int ACR_GetHasIllegalProperties(object oItem)
{
    string sProperties = "";
	string comma = "";

    // get the first property on the item
    itemproperty ipProperty = GetFirstItemProperty(oItem);

    // loop through all the item properties
    while (GetIsItemPropertyValid(ipProperty))
    {
	    if (IntToString(GetItemPropertyType(ipProperty)) != "") {
            // construct the property type list
            sProperties = sProperties + comma + IntToString(GetItemPropertyType(ipProperty));		
            comma = ",";
		} else {
		    ACR_LogEvent(GetItemPossessor(oItem), "Null Property Type", ACR_SQLEncodeSpecialChars(GetName(oItem)));
		}
		// get the next property on the item
        ipProperty = GetNextItemProperty(oItem);
	}
	
    // check if any of the item properties are illegal
    if (sProperties != "" )
	{
		ACR_SQLQuery("SELECT ID FROM item_properties WHERE ItemProperty in (" + sProperties + ") and IsIllegal=1");
	    return ACR_SQLFetch();
	}
	else
	{
		return FALSE;
	}
}


void ACR_LogModuleLoaded()
{
    ACR_SQLQuery("INSERT INTO logs (ServerID, CharacterID, Event, Description) VALUES (" + IntToString(ACR_GetServerId()) + ", 0,'" + ACR_LOG_SERVER_LOAD + "','" + ACR_SQLEncodeSpecialChars(ACR_GetServerName()) + "')");
}

void ACR_LogServerAdminCommand(object oPC, string sCmd)
{
	ACR_LogEvent(oPC, ACR_LOG_SERVER_ADMIN_COMMAND, sCmd);
}

void ACR_LogDMSpawn(object oDM, string sSpawnMessage)
{
	ACR_LogEvent(oDM, ACR_LOG_SPAWN, sSpawnMessage, oDM);
}

#endif
