////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Quest System
//     Filename : acr_quest_i
//    $Revision:: 596        $ current version of the file
//        $Date:: 2010-09-13#$ date the file was created or modified
//       Author : Indio, AcadiusLost, & Cipher - based on implementation by Grim Havoc
//
//    Var Prefix: QST
//  Dependencies: None
//
//  Description
//  This script is the main include for the ALFA quest system.
//
//  Revision History
//  2007/08/16  Indio   Inception
//  2007/08/27  AcadiusLost  Use ALFA ACR functions for the SQL interface
//  2007/09/01  Cipher  Fixed SQL column indexes, optimized code, updated to ACR standards
//  2007/09/02  Cipher  Integrated standalone quest scripts into ACR framework
//  2007/09/15  Cipher  Abstracted quest variable names, minor code refinements
//  2007/09/20  Cipher  Added support for quest item bounties, refined retrigger protection
//  2007/10/15  Cipher  Added tag to variable name to support multi-item errands
//  2008/02/15  Cipher  Added support for triggers with no activation requirements
//  2008/02/15  Cipher  Fixed trigger reactivation bug and xp awards for escort quests
//  2008/03/16  Cipher  Changed GetNearestObjectByTag with GetWaypointByTag for creature spawns
//  2008/03/16  Cipher  Check for quest completion when UPPER state is defined (> 0)
//  2008/03/25  Cipher  Reversed multi-item changes - item removal must be thought through
//  2008/04/15  Cipher  Changed ACR_GiveXPToPC calls to ACR_AwardStaticXP
//  2008/04/17  Cipher  Introduced a distance limiter on awarding quests and xp
//  2008/04/17  Cipher  Ignore players that do not have the quest or have already completed them
//  2008/04/17  AcadiusLost - switched to fDistance for radius
//  2008/04/17  AcadiusLost - added setting ACR_QST_PARTY to define whether a quest state shoult propogate
//  2008/04/27  AcadiusLost - fixes to AddPersistentJournalQuestEntry to fix party iteration, and numerous other functions
//  2008/05/31  AcadiusLost - added timed despawns to quest creatures
//  2008/11/17  AcadiusLost - added localInt cache for Queststate to improve performance
//  2008/12/15  AcadiusLost - added cache initialization at QuestsOnPCLoaded, also added handling for quest items being spawned
//                  inside containers; and a new optional quest trigger setting: ACR_QST_CONTAINER_TAG
//  2010/09/14  AcadiusLost - added special handling for OnAquire/OnUnAcquire for item-based quests
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#include "acr_xp_i"
#include "acr_settings_i"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! database table name to log quests
const string ACR_QST_TABLE = "quests";

//! local variable for setting the quest name (per the module journal)
const string ACR_QST_NAME = "ACR_QST_NAME";

//! local variable for setting the lower state threshold (integer) for a quest
//! typically defines the target state for quest assignment
const string ACR_QST_LOWER_STATE = "ACR_QST_LOWER_STATE";

//! local variable for setting the upper state threshold (integer) for a quest
//! typically defines the target state for quest completion
const string ACR_QST_UPPER_STATE = "ACR_QST_UPPER_STATE";

//! local variable for setting whether a quest advancement state should be propogated to 
//!  other party members. 
const string ACR_QST_PARTY = "ACR_QST_PARTY";

//! local variable cache for referencing quest taker for queststate
const string ACR_QST_PC = "ACR_QST_PC";

//! local variable setting, in seconds, for custom despawn delay on spawn creature despawn.
//!  will default to quest system settings if undefined.
//!  setting -1.0 will result in non-despawning creature.
const string ACR_QST_CUSTOM_DESPAWN = "ACR_QST_CUSTOM_DESPAWN";

//! settings for spawn creature despawn delay, initial and how frequent it checks afterwards, in seconds
const float ACR_QST_DESPAWN_DELAY = 600.0; // 10 minutes initially
const float ACR_QST_DESPAWN_RETRY = 300.0; // 5 minutes therafter

//! local variable cache for referencing quest taker for queststate
const string ACR_QST_BACKUPSTATE = "ACR_QST_BACKUPSTATE";

//! local variable for setting the resref of the creature object to spawn
const string ACR_QST_SPAWN_CRESREF = "ACR_QST_SPAWN_CRESREF";

//! local variable for setting the resref of the item object to spawn
const string ACR_QST_SPAWN_IRESREF = "ACR_QST_SPAWN_IRESREF";

//! local variable for setting the tag of the object spawn location
const string ACR_QST_SPAWN_WAYPOINT = "ACR_QST_SPAWN_WAYPOINT";

//! local variable for setting the spawn animation boolean
const string ACR_QST_APPEAR_ANIMATION = "ACR_QST_APPEAR_ANIMATION";

//! local variable for setting the delay for spawning the object
const string ACR_QST_SPAWN_DELAY = "ACR_QST_SPAWN_DELAY";

//! local variable for setting the message text to send to the player
const string ACR_QST_MESSAGE = "ACR_QST_MESSAGE";

//! local variable for defining the radius limit for awarding quests and xp
const float ACR_QST_RADIUS = 120.0;

//! local variable for setting the tag of a placeable container, creature, 
//! or store to place a quest item inside when the quest trigger is activated.
const string ACR_QST_CONTAINER_TAG = "ACR_QST_CONTAINER_TAG";

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! transparent wrapper to AddJournalQuestEntry
//! use this function instead of the original one to store quest/journal data
//! persistently using the bio DB. all function parameters work similar to the original function
//!
//! Add a journal quest entry to oCreature
//!   - sPlotID: the plot identifier used in the toolset's Journal Editor
//!   - nState: the state of the plot as seen in the toolset's Journal Editor
//!   - oCreature: the creature that will receive the quest and quest xp
//!   - bAllPartyMembers: If this is TRUE, the entry will show up in the journal of everyone in the party
//!   - bAllPlayers: If this is TRUE, the entry will show up in the journal of everyone in the world
//!   - bAllowOverrideHigher: If this is TRUE, you can set the state to a lower number than the one it is currently on
//!   - nQuestXP: The experience to award
void ACR_AddPersistentJournalQuestEntry(string sPlotID, int nState, object oCreature, int bAllPartyMembers=TRUE, int bAllPlayers=FALSE, int bAllowOverrideHigher=FALSE, int nQuestXP=0, float fCR=0.0f);

//! transparent wrapper to RemoveJournalQuestEntry()
//! use this function instead of the original one to remove quest/journal data
//! persistently using the bio DB. all function parameters work similar to the original function
//!
//! Remove a journal quest entry from oCreature.
//!   - sPlotID: the plot identifier used in the toolset's Journal Editor
//!   - oCreature: the creature that has completed the quest
//!   - bAllPartyMembers: If this is TRUE, the entry will be removed from the journal of everyone in the party 
//!   - bAllPlayers: If this is TRUE, the entry will be removed from the journal of everyone in the world 
void ACR_RemovePersistentJournalQuestEntry(string sPlotID, object oCreature, int bAllPartyMembers=TRUE, int bAllPlayers=FALSE);

//! use this function to rebuild the journal for oCreature - call this from OnClientEnter()
void ACR_RebuildJournalQuestEntries(object oPC);

//! retrieve persistent quest state from the database
//!   - sPlotID: the plot identifier used in the toolset's Journal Editor
int ACR_RetrieveQuestState(string sPlotID, object oPC);

//! retrieves the lowest quest state on any of the PC's party
int ACR_RetrieveLowestPartyQuestState(string sPlotID, object oPC);

//! retrieves the highest quest state on any of the PC's party
int ACR_RetrieveHighestPartyQuestState(string sPlotID, object oPC);

//! process the quest attached to the trigger
void ACR_QuestTriggerEnter(object oPC);

//! process quest creature bounties
void ACR_QuestCreatureOnDeath(object oKiller);

//! process quest item bounties
void ACR_QuestItemOnAcquire(object oPC, object oItem);

//! process quest item loss
void ACR_QuestItemOnUnAcquire(object oPC, object oItem);

//! insert a quest into the database
void _insertQuestEntry(string sPlotID, int nState, object oCreature, int bAllowOverrideHigher=FALSE);

//! delete a quest from the database
void _deleteQuestEntry(string sPlotID, object oCreature);

//! spawn the quest encounter defined on oTrigger
//  - oTrigger: trigger object which contains the quest details
//  - nType: OBJECT_TYPE_* of the object to spawn
//  - sTemplate: RESREF of the object to spawn
//  - oPC: triggering PC, pointer for later checks
//  - nBackupState, in case oPC logs or crashes before the quest is done
void _spawnQuestObject(object oTrigger, int nType, string sTemplate, object oPC=OBJECT_INVALID, int nBackupState=0);

//!  Handles despawning of orphaned quest creatures if too much time passes.
void _despawnQuestCreature(object oCreature);

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//  *** BEGIN PUBLIC FUNCTIONS
////////////////////////////////////////////////////////////////////////////////

void ACR_AddPersistentJournalQuestEntry(string sPlotID, int nState, object oCreature, int bAllPartyMembers=TRUE, int bAllPlayers=FALSE, int bAllowOverrideHigher=FALSE, int nQuestXP=0, float fCR=0.0f)
{

    float fDistance = 0.0;
    // add the quest data to the database
    if (bAllPlayers) {
		// branch for quests that effect all PCs onserver, unlikely to be used much
        object oPC = GetFirstPC();
		int nGlobalCachedState = 0;
        // create a quest entry for all the players in the roster
        while (GetIsObjectValid(oPC))
        {
            fDistance = GetDistanceBetween(oCreature, oPC);

            // ignore players beyond a reasonable distance from the target creature
            if ((fDistance > 0.0) && (fDistance <= ACR_QST_RADIUS))
            {
                // check that the player has the quest but has not completed it
				nGlobalCachedState = ACR_RetrieveQuestState(sPlotID, oPC);
                if ((nGlobalCachedState > 0) && (nGlobalCachedState < nState))
                {
				    // add the quest data to the journal
   					AddJournalQuestEntry(sPlotID, nState, oPC, FALSE, FALSE, bAllowOverrideHigher);
                    _insertQuestEntry(sPlotID, nState, oPC, bAllowOverrideHigher);
                    if (nQuestXP > 0) { ACR_AwardStaticQuestXP(oPC, sPlotID, nQuestXP, fCR); }
                }
            }
		oPC = GetNextPC();
        }
    } else if (bAllPartyMembers) {
		// branch for quests that automatically extend to all party members
        object oPartyMember = GetFirstFactionMember(oCreature);
		int nMemberState = 0;
        // create a quest entry for all the players in the party
        while (GetIsObjectValid(oPartyMember))
        {
            fDistance = GetDistanceBetween(oCreature, oPartyMember);
			if (oCreature == oPartyMember) { fDistance = 0.1; }
            // ignore players beyond a reasonable distance from the target creature
            if ((fDistance > 0.0) && (fDistance <= ACR_QST_RADIUS))
            {
				nMemberState = ACR_RetrieveQuestState(sPlotID, oPartyMember);
                // check that the player has the quest but has not completed it
                if ((nMemberState > 0) && (nMemberState < nState))
                {
				    // add the quest data to the journal
    				AddJournalQuestEntry(sPlotID, nState, oPartyMember, FALSE, FALSE, bAllowOverrideHigher);
                    _insertQuestEntry(sPlotID, nState, oPartyMember, bAllowOverrideHigher);
                    if (nQuestXP > 0) { ACR_AwardStaticQuestXP(oPartyMember, sPlotID, nQuestXP, fCR); }
                }
            }
		oPartyMember = GetNextFactionMember(oCreature);
        }
    } else {
        // create a quest entry for this player only
		//  Most quests will use this branch.
		// add the quest data to the journal
    	AddJournalQuestEntry(sPlotID, nState, oCreature, bAllPartyMembers, bAllPlayers, bAllowOverrideHigher);
        _insertQuestEntry(sPlotID, nState, oCreature, bAllowOverrideHigher);
        if (nQuestXP > 0) { ACR_AwardStaticQuestXP(oCreature, sPlotID, nQuestXP, fCR); }
    }
}

void ACR_RemovePersistentJournalQuestEntry(string sPlotID, object oCreature, int bAllPartyMembers=TRUE, int bAllPlayers=FALSE)
{
    // remove the quest data from the journal
    RemoveJournalQuestEntry(sPlotID, oCreature, bAllPartyMembers, bAllPlayers);

    // remove the quest data from the database
    if (bAllPlayers)
    {
        object oPC = GetFirstPC();

        // delete the quest for all the players in the roster
        while (GetIsObjectValid(oPC))
        {
            _deleteQuestEntry(sPlotID, oPC);
            oPC = GetNextPC();
        }
    }
    else if (bAllPartyMembers)
    {
        object oPartyMember = GetFirstFactionMember(oCreature);

        // delete the quest for all the players in the party
        while (GetIsObjectValid(oPartyMember))
        {
            _deleteQuestEntry(sPlotID, oPartyMember);
            oPartyMember = GetNextFactionMember(oCreature);
        }
    }
    else
    {
        // delete the quest for this player only
        _deleteQuestEntry(sPlotID, oCreature);
    }
}

void ACR_RebuildJournalQuestEntries(object oPC)
{
	string sQuestID;
	int nQuestState;
    // ignore non player characters
    if (GetIsPC(oPC))
    {
        // retrieve the current quest states for this character
        ACR_SQLQuery("SELECT PlotID, PlotState FROM " + ACR_QST_TABLE + " WHERE ServerID=" + IntToString(ACR_GetServerId()) + " AND CharacterID=" + IntToString(ACR_GetCharacterID(oPC)));

        // loop through the results
        while (ACR_SQLFetch() == SQL_SUCCESS)
        {
			sQuestID = ACR_SQLGetData(0);
			nQuestState = StringToInt(ACR_SQLGetData(1));
			// Cache the queststates on the PC
			SetLocalInt(oPC, "ACR_"+sQuestID+"_CACHE", TRUE);
			SetLocalInt(oPC, "ACR_"+sQuestID+"_STATE", nQuestState);
            // update the player's journal with the quest id and state
            AddJournalQuestEntry(sQuestID, nQuestState, oPC, FALSE, FALSE, FALSE);
        }
    }
}

int ACR_RetrieveQuestState(string sPlotID, object oPC)
{
	// Added cached queststate check
    int nState = 0;

    // ignore non player characters
    if (GetIsPC(oPC))
    {
		// First, check if the PC has a cached quest state for this quest.
		if (GetLocalInt(oPC, "ACR_"+sPlotID+"_CACHE")) {
		    // hand back the cached version, no need for SQL query
			return (GetLocalInt(oPC, "ACR_"+sPlotID+"_STATE"));
		} else {
            // retrieve the quest state for this character
            ACR_SQLQuery("SELECT PlotState FROM " + ACR_QST_TABLE + " WHERE ServerID=" + IntToString(ACR_GetServerId()) + " AND CharacterID=" + IntToString(ACR_GetCharacterID(oPC)) + " AND PlotID='" + sPlotID + "'");
            // return the quest state, if the quest exists
            if (ACR_SQLFetch() == SQL_SUCCESS) { nState = StringToInt(ACR_SQLGetData(0)); }
			SetLocalInt(oPC, "ACR_"+sPlotID+"_CACHE", TRUE); 
			SetLocalInt(oPC, "ACR_"+sPlotID+"_STATE", nState); 
		}
    }

    return nState;
}

int ACR_RetrieveLowestPartyQuestState(string sPlotID, object oPC)
{
    int nValue, nLowestValue = ACR_RetrieveQuestState(sPlotID, oPC);
    object oMember = GetFirstFactionMember(oPC);

    // loop through all the players in the party
    while (GetIsObjectValid(oMember))
    {
        nValue = ACR_RetrieveQuestState(sPlotID, oMember);
        if (nValue < nLowestValue) { nLowestValue = nValue; }
        oMember = GetNextFactionMember(oPC);
    }
    return nLowestValue;
}

int ACR_RetrieveHighestPartyQuestState(string sPlotID, object oPC)
{
    int nValue, nHighestValue = 0; 
    object oMember = GetFirstFactionMember(oPC); 

    // loop through all the players in the party
    while (GetIsObjectValid(oMember))
    {
        nValue = ACR_RetrieveQuestState(sPlotID, oMember);
        if (nValue > nHighestValue) { nHighestValue = nValue; }
        oMember = GetNextFactionMember(oPC);
    }
    return nHighestValue;
}

void ACR_QuestTriggerEnter(object oPC)
{
    string sQuest, sResRef;

    // exit if the PC has already triggered this
    if (GetLocalInt(oPC, GetTag(OBJECT_SELF))) { return; }

    // process PC triggers
    if (GetIsPC(oPC))
    {
        sQuest = GetLocalString(OBJECT_SELF, ACR_QST_NAME);
        int bParty = GetLocalInt(OBJECT_SELF, ACR_QST_PARTY);
        // exit if a quest is not attached to this trigger
        if (sQuest == "") { return; }

        // retrieve the quest state requirements for this trigger
        int nLower = GetLocalInt(OBJECT_SELF, ACR_QST_LOWER_STATE);
        int nUpper = GetLocalInt(OBJECT_SELF, ACR_QST_UPPER_STATE);

        // retrieve the current state of the quest
        int nState = ACR_RetrieveQuestState(sQuest, oPC);

        // determine if the activation requirements have been met
        if ((nState == nLower) || (nLower == 0))
        {
            // display any configured message
            FloatingTextStringOnCreature(GetLocalString(OBJECT_SELF, ACR_QST_MESSAGE), oPC);

            // determine if an encounter exists for this quest
            if ((sResRef = GetLocalString(OBJECT_SELF, ACR_QST_SPAWN_CRESREF)) != "")
            {
                // spawn the quest encounter
                DelayCommand(GetLocalFloat(OBJECT_SELF, ACR_QST_SPAWN_DELAY), _spawnQuestObject(OBJECT_SELF, OBJECT_TYPE_CREATURE, sResRef, oPC, nState));
            }
            // determine if an item exists for this quest
            else if ((sResRef = GetLocalString(OBJECT_SELF, ACR_QST_SPAWN_IRESREF)) != "")
            {
                // spawn the quest item
                DelayCommand(GetLocalFloat(OBJECT_SELF, ACR_QST_SPAWN_DELAY), _spawnQuestObject(OBJECT_SELF, OBJECT_TYPE_ITEM, sResRef, oPC, nState));
            }
            else
            {
                int nXP = 0; nState++;

                // award quest XP if the quest has reached its end state
                if (nState >= nUpper && nUpper > 0) { nXP = GetJournalQuestExperience(sQuest); }

                // update the quest state
                ACR_AddPersistentJournalQuestEntry(sQuest, nState, oPC, bParty, FALSE, FALSE, nXP);
            }
        
            // prevent the trigger from being tripped again (once activated) - this may need to be persistent across resets
            SetLocalInt(oPC, GetTag(OBJECT_SELF), 1);
			if (bParty) {
			    // if this is a party quest, block this trigger activation for everyone to avoid multispawn
			    object oAlly = GetFirstFactionMember(oPC);
			    while (GetIsObjectValid(oAlly)) {
					// iterate through the party, block activation for anyone else with the quest.
					if (oAlly == oPC) { // then already done, skip the extra query
				    } else if (ACR_RetrieveQuestState(sQuest, oAlly) > 0) {
				        SetLocalInt(oAlly, GetTag(OBJECT_SELF), 1);
					}
					oAlly = GetNextFactionMember(oPC);
				}
			}
					
        }
    }
    // process NPC triggers for escort quests
    else if ((sQuest = GetLocalString(oPC, ACR_QST_NAME)) != "")
    {
        object oNPC = oPC; oPC = GetMaster(oPC);

        // retrieve the quest state requirements for this trigger
        int nLower = GetLocalInt(OBJECT_SELF, ACR_QST_LOWER_STATE);
        int nUpper = GetLocalInt(OBJECT_SELF, ACR_QST_UPPER_STATE);
		int bParty2 = GetLocalInt(OBJECT_SELF, ACR_QST_PARTY);
        // retrieve the current state of the quest
        int nState = ACR_RetrieveQuestState(sQuest, oPC);

        // determine if the activation requirements have been met
        if ((nState == nLower) || (nLower == 0))
        {
            // display any configured message
            FloatingTextStringOnCreature(GetLocalString(OBJECT_SELF, ACR_QST_MESSAGE), oPC);

            // stop the NPC from following the PC
            AssignCommand(oNPC, ClearAllActions());

            // start a conversation with the PC
            AssignCommand(oNPC, ActionStartConversation(oPC, "", FALSE, FALSE, FALSE, TRUE));

            int nXP = 0;

            // award quest XP if the quest has reached its end state (escort destination)
            if (nState >= nUpper && nUpper > 0) { RemoveHenchman(oPC, oNPC); nXP = GetJournalQuestExperience(sQuest); }

            // update the quest state and award the quest XP
            ACR_AddPersistentJournalQuestEntry(sQuest, nState + 1, oPC, bParty2, FALSE, FALSE, nXP);
        
            // prevent the trigger from being tripped again (once activated) - this may need to be persistent across resets
            SetLocalInt(oPC, GetTag(OBJECT_SELF), 1);
        }
    }
}

void ACR_QuestCreatureOnDeath(object oKiller)
{
    string sQuest = GetLocalString(OBJECT_SELF, ACR_QST_NAME);

    // exit if there is no bounty on this creature
    if (sQuest == "") { return; }

    // determine if the killer is controlled by a player
    if (GetIsObjectValid(GetMaster(oKiller))) { oKiller = GetMaster(oKiller); }

    // ignore non player characters
    if (GetIsPC(oKiller))
    {
        int bPartyQuest = GetLocalInt(OBJECT_SELF, ACR_QST_PARTY);
        int nUpper = GetLocalInt(OBJECT_SELF, ACR_QST_UPPER_STATE);
		object oQuestPC = GetLocalObject(OBJECT_SELF, ACR_QST_PC);
        int nState = 0;
		// use the cached pointer to work out what the quest state advance should be, based on the PC who triggered it
		if (GetIsObjectValid(oQuestPC)) {
			nState = ACR_RetrieveQuestState(sQuest, oQuestPC);

			// also, swap killer to owner of quest if not party
			if (!bPartyQuest)
				oKiller = oQuestPC;
		}
		else {
			nState = GetLocalInt(OBJECT_SELF, ACR_QST_BACKUPSTATE);
		}
		
        // determine if conditions for the bounty have been met
        // lower boundry prevents a PC who hasn't taken the quest from earning quest XP
	// upper boundry prevents inadvertant overiteration
        if (nState > 0 && nState < nUpper)
        {
            int nXP = 0; nState++;

            // award quest XP if the quest has reached its end state
            if (nState >= nUpper) { nXP = GetJournalQuestExperience(sQuest); }

            // update the quest state
            ACR_AddPersistentJournalQuestEntry(sQuest, nState, oKiller, bPartyQuest, FALSE, FALSE, nXP);
			
        }
    }
}

void ACR_QuestItemOnAcquire(object oPC, object oItem)
{
    string sQuest = GetLocalString(oItem, ACR_QST_NAME);

    // exit if there is no bounty on this item
    if (sQuest == "") { return; }

    // ignore non player characters
    if (GetIsPC(oPC))
    {
        int nUpper = GetLocalInt(oItem, ACR_QST_UPPER_STATE);
        int nState = ACR_RetrieveQuestState(sQuest, oPC);
		int bPartyQuest = GetLocalInt(oItem, ACR_QST_PARTY);
        // determine if conditions for the bounty have been met
        // lower boundary prevents a PC who hasn't taken the quest from earning quest XP
        if (nState > 0 && nState <= nUpper)
        {
            int nXP = 0; nState++;

            // award quest XP if the quest has reached its end state
            if (nState >= nUpper)
            {
                nXP = GetJournalQuestExperience(sQuest);
            }

            // update the quest state
            ACR_AddPersistentJournalQuestEntry(sQuest, nState, oPC, bPartyQuest, FALSE, FALSE, nXP);
        }

        // store an object reference on the PC for easy retrieval (avoids costly inventory loops)
        SetLocalObject(oPC, sQuest, oItem);
    }
}

void ACR_QuestItemOnUnAcquire(object oPC, object oItem)
{
	string sQuest = GetLocalString(oItem, "ACR_QST_NAME");

    // exit if there is no quest regarding this item
    if (sQuest == "") { return; }

    // ignore non player characters
    if (GetIsPC(oPC))
    {
        int nUpper = GetLocalInt(oItem, ACR_QST_UPPER_STATE);
        int nState = ACR_RetrieveQuestState(sQuest, oPC);
		int bPartyQuest = GetLocalInt(oItem, ACR_QST_PARTY);
		
		//SendMessageToPC(oPC, "ItemQuestUnAcquire: nState = "+IntToString(nState)+", Upper = "+IntToString(nUpper));
        // determine if conditions for the quest have been met
        // lower boundary prevents a PC who hasn't taken the quest from earning quest XP
        if (nState > 0 && nState <= nUpper)
        {
			// as the quest item has been lost, decrement QuestState
            nState = nState -1;
			// if cached, roll back the cached QuestState as well, so it doesn't throw off the next function
			if (GetLocalInt(oPC, "ACR_"+sQuest+"_CACHE")) {		    
				SetLocalInt(oPC, "ACR_"+sQuest+"_STATE", nState);
			}
            // update the quest state (roll back to prior state)
            ACR_AddPersistentJournalQuestEntry(sQuest, nState, oPC, bPartyQuest, FALSE, TRUE);
        }

        // clear any residual object reference on the PC 
        DeleteLocalObject(oPC, sQuest);
    }
}

////////////////////////////////////////////////////////////////////////////////
//  *** BEGIN PRIVATE FUNCTIONS
////////////////////////////////////////////////////////////////////////////////

void _insertQuestEntry(string sPlotID, int nState, object oCreature, int bAllowOverrideHigher=FALSE)
{
    // ignore non player characters
    if (GetIsPC(oCreature))
    {
        string sSQL, sServerID = IntToString(ACR_GetServerId()), sCharacterID = IntToString(ACR_GetCharacterID(oCreature));
        // retrieve the current state for this character's quest
		// actually need to query this so we have the row number to update later
        ACR_SQLQuery("SELECT ID, PlotState FROM " + ACR_QST_TABLE + " WHERE ServerID=" + sServerID + " AND CharacterID=" + sCharacterID + " AND PlotID='" + sPlotID + "'");
       	 // if the quest exists, update its state
        if (ACR_SQLFetch() == SQL_SUCCESS) {
            // only update the quest state if it's higher than the current state or it is expressly overriden
            if (bAllowOverrideHigher || nState > StringToInt(ACR_SQLGetData(1))) {
                sSQL = "UPDATE " + ACR_QST_TABLE + " SET PlotState = '" + IntToString(nState) + "' WHERE ID=" + ACR_SQLGetData(0);
            }
        }
        // otherwise create a new quest record
        else
        {
            sSQL = "INSERT INTO " + ACR_QST_TABLE + " (ServerID, CharacterID, PlotID, PlotState) VALUES (" + sServerID + "," + sCharacterID + ",'" + sPlotID + "','" + IntToString(nState) + "')";
        }
        ACR_SQLQuery(sSQL);
		if (sSQL != "") {
			// set a cache of the QuestState on the PC object
			SetLocalInt(oCreature, "ACR_"+sPlotID+"_CACHE", TRUE);
			SetLocalInt(oCreature, "ACR_"+sPlotID+"_STATE", nState);
		}
    }
}

void _deleteQuestEntry(string sPlotID, object oCreature)
{
    // ignore non player characters
    if (GetIsPC(oCreature))
    {
        // delete the quest entry for this player
        ACR_SQLQuery("DELETE FROM " + ACR_QST_TABLE + " WHERE ServerID=" + IntToString(ACR_GetServerId()) + " AND CharacterID=" + IntToString(ACR_GetCharacterID(oCreature)) + " AND PlotID='" + sPlotID + "'");
		// also delete the cached version
		DeleteLocalInt(oCreature, "ACR_"+sPlotID+"_CACHE");
		DeleteLocalInt(oCreature, "ACR_"+sPlotID+"_STATE");
    }
}

void _spawnQuestObject(object oTrigger, int nType, string sTemplate, object oPC=OBJECT_INVALID, int nBackupState=0)
{
    // retrieve the spawn details
    object oWaypoint = GetWaypointByTag(GetLocalString(oTrigger, ACR_QST_SPAWN_WAYPOINT));
	object oObject = OBJECT_INVALID;
    int bUseAppearAnimation = GetLocalInt(oTrigger, ACR_QST_APPEAR_ANIMATION);
    
    // compute the spawn location - spawn on the trigger if no valid location is assigned
    location lLocation = (GetIsObjectValid(oWaypoint)) ? GetLocation(oWaypoint) : GetLocation(oTrigger);
	
	// check to see if the spawn object is an item, if so, try to put it into a container.
	if (nType == OBJECT_TYPE_ITEM) {
		object oContainer = GetObjectByTag(GetLocalString(oTrigger, ACR_QST_CONTAINER_TAG));
		if (GetIsObjectValid(oContainer) && GetHasInventory(oContainer)) {
		    // target container found, create inside inventory
			oObject = CreateItemOnObject(sTemplate, oContainer);
		} else {
		    // could not find container, report to DM channel and spawn at waypoint location.
			oObject = CreateObject(nType, sTemplate, lLocation, bUseAppearAnimation);
			SendMessageToAllDMs("Could not find an inventoried quest container for "+GetLocalString(oTrigger, ACR_QST_NAME)+" in area "+GetName(GetArea(oTrigger))+" with tag = "+GetLocalString(oTrigger, ACR_QST_CONTAINER_TAG)+". Quest object spawned on the ground instead.");
		}	
	} else {
        // all other cases, just spawn the object at the waypoint.
        oObject = CreateObject(nType, sTemplate, lLocation, bUseAppearAnimation);
    }
	
    // set the quest name and target state threshold for quest XP
    SetLocalString(oObject, ACR_QST_NAME, GetLocalString(oTrigger, ACR_QST_NAME));
    SetLocalInt(oObject, ACR_QST_UPPER_STATE, GetLocalInt(oTrigger, ACR_QST_UPPER_STATE));
	SetLocalInt(oObject, ACR_QST_PARTY, GetLocalInt(oTrigger, ACR_QST_PARTY));
	SetLocalInt(oObject, ACR_QST_BACKUPSTATE, nBackupState);
	SetLocalObject(oObject, ACR_QST_PC, oPC);
	
	if (nType == OBJECT_TYPE_CREATURE) {
	    // check despawn settings
	    float fDelay = GetLocalFloat(oTrigger, ACR_QST_CUSTOM_DESPAWN);
	    if (fabs(fDelay) < EPSILON) {
	        // undefined, use system default
	        fDelay = ACR_QST_DESPAWN_DELAY;
	    } else if (fabs(fDelay - -1.0) < EPSILON) {
	        // builder override, no despawn
		    return;
	    }
	    DelayCommand(fDelay, _despawnQuestCreature(oObject));
	}
}

void _despawnQuestCreature(object oCreature)
{
    // work out who the trigerring PC was
	object oQuester = GetLocalObject(oCreature, ACR_QST_PC);
	if (!GetIsObjectValid(oQuester)) {
	    // PC pointer is invalid, despawn
	    DestroyObject(oCreature);
	} else if (GetArea(oQuester) != GetArea(oCreature)) {
	    // PC has left the area (chickened out) despawn
	    DestroyObject(oCreature);
    } else {
	    // PC is valid and still in area, wait and try again in a few min
		DelayCommand(ACR_QST_DESPAWN_RETRY, _despawnQuestCreature(oCreature));
	}
}
	    		
