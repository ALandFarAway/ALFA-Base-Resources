////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_mod_events_i.nss
//    $Revision:: 616        $ current version of the file
//        $Date:: 2009-12-29#$ date the file was created or modified
//       Author : Ronan & Cipher & AcadiusLost
//
//  Description
//  This file contains functions which process all module event scripts for
//  ALFA modules.
//
//  Of note is the presence of only a single loop in each event. Subsystems
//  residing in an event should not contain their own inventory or effect loops,
//  instead the subsystems should share a single loop. This is done for reasons
//  of efficiency, NWScript is not quick when doing things like looping through
//  items in an inventory, or objects in an area.
//
//  Revision History
//  2006/08/18  Cipher  Added pc initialization, rest processing, & minor reformatting
//  2006/09/09  Cipher  Changed ALFA prefix to ACR
//  2006/09/15  Ronan   Added game constant cache system, and updated to ACR_ convention
//  2006/09/15  Cipher  Added support for scrying spells
//  2006/09/15  Cipher  Added death system functions
//  2006/12/22  Cipher  Added OnModuleStart and OnPCLoaded event handlers
//  2007/01/20  Cipher  Moved ExecuteScript() item script to ACR_ModuleOnActivateItem()
//  2007/03/31  AcadiusLost  commented out calls to Death system scripts, for now.
//  2007/04/15  AcadiusLost  edited OnActivate to explicitly pass oItem in ExecuteScript
//  2007/04/26  AcadiusLost  Added Module Switches to OnModuleLoad handler
//  2007/05/03  AcadiusLost  Added death effect to ACR_ModuleOnPlayerDying()- temporarily
//  2007/05/03  Cipher  Added call to ACR_PlayerOnDying() and initialized spell hooking
//  2007/05/25  Cipher  Added NWNX initialization and 1984 logging hooks
//  2007/07/01  Cipher  Added OnPCLoaded() event calls. This solves PC instantiation workarounds
//  2007/07/13  Cipher  Added SQL table creation function call
//  2007/07/14  AcadiusLost  Moved DM item granting to OnPCLoaded, added starting equipment handling.
//                      Also changed ACR_ModuleOnPlayerDeath() to use GetLastHostileActor(), and 
//                      ACR_ModuleOnUnacquireItem() to check GetIsObjectValid(oItem), and ACR_ModuleOnAcquireItem
//                      to use GetItemPossessor(GetModuleItemAquired()) to avoid strange cases.
//  2007/07/18  AcadiusLost  Moved ACR_RestOnClientEnter to OnPCLoaded
//  2007/07/21  Cipher  Revised ACR_SQLGetData() calls, skip item acquisition logging on logins
//  2007/09/02  Cipher  Added rebuild journal quest entries on login
//  2007/09/15  AcadiusLost Pushed back RestOnClientEnter with a DelayCommand() to give PC status 
//                      adjust a chance to apply damage before calculating offcamera rest healing.
//  2007/09/15  Cipher  Moved journal rebuild to the OnPCLoaded event
//  2007/09/20  Cipher  Added quest hook for item bounties
//  2007/09/21  Cipher  Moved inventory item checks on login to the ItemOnAcquired function to avoid redundancy
//  2007/10/28  AcadiusLost Merged with DMFI 1.05 for OnPCLoad event.  Added "#include "dmfi_inc_initial"
//  2007/10/31  AcadiusLost Changed DMFI call to an ExecuteScript() so it isn't needed to compile the ACR.
//  2007/11/02  AcadiusLost Shifted DMFI call outside the DM/Player conditional so it is called for both.
//  2007/11/15  AcadiusLost removed module switch for UMD scrolls (adding ALFA scrolls) 
//  2007/11/25  AcadiusLost added OnEquip handling for Martial Bastardswords
//  2007/11/30  AcadiusLost added OnModuleLoad call to initialize chat plugin cache
//  2007/12/16  AcadiusLost added calls to acr_items_i to handle item scripts, moved bastardsword code.
//  2007/12/17  AcadiusLost - pushed death and resting includes to acr_items_i, shifted item activation code as well.
//  2008/03/19  AcadiusLost - shifted death logging into acr_death_i, due to addition of "death floor"
//  2008/04/16  Cipher  Fixed logout logging.
//  2008/04/16  Cipher  Fixed acquire logging.
//  2008/08/27  AcadiusLost - added hooks for nonlethal damage system
//  2008/09/19  AcadiusLost - prepare for Custom skills, regions, logging fix for NLD
//  2008/09/21  AcadiusLost - Nonlethal OnExit event added.
//  2008/12/08  AcadiusLost - Added handling for server names with apostrophes eg. "Baldur's Gate"
//					Item acquire/unacquire optimizations (commented out SQL illegal item checks), deprecated storageobjects 
//                  also amended spawn debug wand tag for GetItemPossessedBy() for DMs.
//  2008/12/10  AcadiusLost - optimized class checking OnPCLoaded()
//  2009/01/19  AcadiusLost - switched Servers table update to take GetName(oModule) to allow synchronicity with pwdata entries.
//  2009/02/07  AcadiusLost - Changed initialization of the AutoSave() cycle for PCs.
//  2009/03/10  AcadiusLost - Added initialization for the DM Client Extension suite in OnClientEnter.
//  2009/07/07  AcadiusLost - updated to add custom skill framework with 1.23
//  2009/07/18  AcadiusLost - Added language and region hooks into PC Load and Levelup events.
//  2009/08/03  AcadiusLost - Added IP-logging onLogin
//  2009/08/08  AcadiusLost - Added handling for OnChat event (1.23)
//  2009/12/29  AcadiusLost - Removed autoassignment of subdual widget OnPCLoaded (no longer needed)
//	2011/05/29	Ronan		- Added OnModuleLoad parameters for global module settings.
//      2011/06/04      Zelknolf        - Added hook for display of NPC creator GUI
//	2011/06/24	AcadiusLost	- merged in fix for clearing IsOnline bits in Characters table OnModuleLoad()
//	2011/06/25	Ronan - Added in the service heartbeats for asynchronous SQL writes.
// 2011/07/02  Basilica - Added persistent database callouts for cache management.
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#include "acr_settings_i"
#include "acr_debug_i"
#include "acr_time_i"
#include "acr_xp_i"
//#include "acr_storageobj_i"
#include "acr_spawn_i"
#include "acr_db_persist_i"
//#include "acr_game_const_i"
#include "acr_scry_i"
#include "acr_tools_i"
#include "acr_1984_i"
#include "acr_quest_i"
#include "acr_chat_i"
#include "acr_xp_i"
#include "acr_items_i"
#include "acr_skills_i"
#include "acr_nonlethal_i"
#include "acr_language_i"

#include "acf_spawn_i"
#include "acf_settings_i"

#include "x2_inc_switches"
#include "dmfi_inc_initial"
#include "dmfi_inc_lang"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

const string _ONLOAD_DEBUG = "ACR_ModuleOnModuleLoad";
const string ACR_MOD_STATUS = "ACR_MOD_STATUS";

//! Local variable definitions
const string ACR_MOD_SPELLBOOK = "ACR_MOD_SPELLBOOK";
const string ACR_MOD_HOLYSYMBOL = "ACR_MOD_HOLYSYMBOL";
const string ACR_MOD_STARTINGGOLD = "ACR_MOD_STARTINGGOLD";
const string ACR_MOD_STARTARMORX = "ACR_MOD_STARTARMORX";
const string ACR_MOD_FIRSTAID_IT = "ACR_MOD_FIRSTAID_IT";

//! ACR_MOD_STATUS Module Status Flags (bitmask)
const int ACR_MOD_NWNX_FAILED = 0x01;

//! The time period for OnModuleLoad() rescheduling, necessary for NWNX failures.
const float ACR_MOD_RELOAD_CYCLE = 10.0;

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// Runs the ALFA OnModuleLoad event.

void ACR_ModuleOnModuleLoad();
void ACR_ModuleOnModuleStart();
void ACR_ModuleOnClientEnter();
void ACR_ModuleOnClientLeave();
void ACR_ModuleOnAcquireItem();
void ACR_ModuleOnUnacquireItem();
void ACR_ModuleOnActivateItem();
void ACR_ModuleOnPCLoaded();
void ACR_ModuleOnPlayerDeath();
void ACR_ModuleOnPlayerDying();
void ACR_ModuleOnPlayerLevelUp();
void ACR_ModuleOnPlayerRespawn();
void ACR_ModuleOnPlayerRest();
void ACR_ModuleOnHeartbeat();
void ACR_ModuleOnUserDefined();
void ACR_ModuleOnPlayerEquip();
void ACR_ModuleOnPlayerUnequip();
void ACR_ModuleOnCutsceneAbort();

// special handler for the OnChat event (new in 1.23)
int ACR_ModuleOnChat(object oSpeaker, object oTarget, int nMode, string sText);

//! Returns the state of the desired module status bit
//! - nStatus: One of the status flags defined for ACR_MOD_STATUS
//! - returns: TRUE is set, FALSE if not set
int ACR_GetModuleStatus(int nStatus);

//! Sets the state of the desired module status bit
//! - nStatus: One of the status flags defined for ACR_MOD_STATUS
//! - returns: Nothing
void ACR_SetModuleStatus(int nStatus);

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void ACR_ModuleOnModuleLoad()
{
	// Set global module settings.
	SetServerData(ACR_SERVER_ID, ACR_SERVER_NAME, ACR_SERVER_REGION, ACR_SERVER_IP);

    object oModule = GetModule();
    
    // ORDER MATTERS !!

    // Start the debuging system and create debugging ids for the module event scripts
    ACR_InitializeDebugging();
    ACR_CreateDebugSystem(_ONLOAD_DEBUG, DEBUG_TARGET_LOG | DEBUG_TARGET_DB, DEBUG_TARGET_LOG | DEBUG_TARGET_DB, DEBUG_TARGET_LOG | DEBUG_TARGET_DB);
    string sServerId = IntToString(ACR_GetServerId());
    ACR_PrintDebugMessage("acr_mod_events_i: ALFA " + sServerId + " loading the ALFA Core Rules.", _ONLOAD_DEBUG, DEBUG_LEVEL_INFO);

    // Check NWNX status
    if (! NWNXInstalled())
    {
        // record the status
        ACR_SetModuleStatus(ACR_MOD_NWNX_FAILED);
        ACR_PrintDebugMessage("acr_mod_events_i: NWNX unavailable on ALFA server " + sServerId + ". Rescheduling OnModuleLoad(). Server restart may be required.", _ONLOAD_DEBUG, DEBUG_LEVEL_FATAL);

        // reschedule the OnModuleLoad() handler
        DelayCommand(ACR_MOD_RELOAD_CYCLE, ACR_ModuleOnModuleLoad());
        return;
    }
	else
	{
		// create the SQL tables if need be
		ACR_CreateSQLTables();
	}
	
	// Initialize asynchronous writes
	ACR_StartAsyncService();

    // Initialize spell hook
    SetLocalString(oModule, "X2_S_UD_SPELLSCRIPT", "acr_spellhook");

    // Initialize storage objects used by many systems.
    // ACR_InitializeStorageObjects();

    // Initialize game engine constants.
    //ACR_InitializeGameConstants();

    // Initialize the spawn system.
    ACR_InitializeSpawns(_SPAWN_AREA_DESPAWN_DELAY, _SPAWN_REFRESH_DELAY, _SPAWN_PRESPAWN_SEAMLESS, _SPAWN_PRESPAWN_PREDICTION);

    // Initialize the time system.
    ACR_InitializeTime();
//    ACR_PrintDebugMessage("acr_mod_events_i: Starting date: " + GetDateAsString(), _ONLOAD_DEBUG, DEBUG_LEVEL_INFO);
//    ACR_PrintDebugMessage("acr_mod_events_i: Sarting time: " + GetTimeAsString(), _ONLOAD_DEBUG, DEBUG_LEVEL_INFO);
    ACR_PrintDebugMessage("acr_mod_events_i: Time compression ratio: " + FloatToString(ACR_GetGameToRealTimeRatio()), _ONLOAD_DEBUG, DEBUG_LEVEL_INFO);

    // Initialize one-time PC status setups
    ACR_PCOnModuleLoad();

    // Recreate player corpses
    ACR_RestoreCorpsesOnModuleLoad();

    // Set bioware/obsidian module switches as desired:
    SetModuleSwitch(MODULE_SWITCH_ENABLE_INVISIBLE_GLYPH_OF_WARDING, TRUE);
    SetModuleSwitch(MODULE_SWITCH_ENABLE_CROSSAREA_WALKWAYPOINTS, TRUE);
    //SetModuleSwitch(MODULE_SWITCH_ENABLE_UMD_SCROLLS, TRUE);
    SetModuleSwitch(MODULE_SWITCH_ENABLE_NPC_AOE_HURT_ALLIES, TRUE);
    SetModuleSwitch(MODULE_SWITCH_ENABLE_MULTI_HENCH_AOE_DAMAGE, TRUE);
    SetModuleSwitch(MODULE_SWITCH_AOE_HURT_NEUTRAL_NPCS, TRUE);
    SetModuleSwitch(MODULE_VAR_AI_STOP_EXPERTISE_ABUSE, TRUE);
    SetModuleSwitch(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS, TRUE);

	string sSID = IntToString(ACR_SERVER_ID);
	// grab the server name from the module properties so it will be updated.
	string sServerName = GetName(oModule);

	// Try and discover the external address of the server from the database
	// connection.  If that fails, fall back to the hardcoded default in the
	// configuration file.
	string sExtAddress = ACR_GetServerAddressFromDatabase();

	if (sExtAddress == "")
		sExtAddress = ACR_SERVER_IP;

    // check that the server information is in the database
    ACR_SQLQuery("SELECT * FROM servers WHERE ID=" + sSID);

    // create the record if it does not already exist
    if (ACR_SQLFetch() != SQL_SUCCESS)
    {
        ACR_SQLQuery("INSERT INTO servers (ID, Name, IPAddress) VALUES(" + sSID + ",'" + ACR_SQLEncodeSpecialChars(sServerName) + "','" + sExtAddress + "')"); 
    }
	else
	{	
		// update server name and ip address if they've changed
		if (ACR_SQLGetData(1) != sServerName || ACR_SQLGetData(2) != sExtAddress)
		{
			ACR_SQLQuery("UPDATE servers SET Name='" + ACR_SQLEncodeSpecialChars(sServerName) + "', IPAddress='" + sExtAddress + "' WHERE ID=" + sSID);
		}
	}

	//  EDIT: Only where ServerID = the ID of the server that has just finished loading.
        ACR_SQLQuery("UPDATE characters SET IsOnline=0 WHERE ServerID=" + sSID);
	
	// Initialize chatlogging buffer
	ACR_InitializeChat();

    // This should be the last time in this function.
    ACR_PrintDebugMessage("acr_mod_events_i: ALFA server " + sServerId + " loaded.", _ONLOAD_DEBUG, DEBUG_LEVEL_INFO);

	ACR_LogEvent(OBJECT_INVALID, ACR_LOG_SERVER_LOAD, "Server " + sServerId + " loaded module " + GetName(GetModule()) + ".");
}

void ACR_ModuleOnModuleStart()
{
}

void ACR_ModuleOnClientEnter()
{
    object oPC = GetEnteringObject(), oCorpse = OBJECT_INVALID;

    // exit if the database is unavailable
    if (ACR_GetModuleStatus(ACR_MOD_NWNX_FAILED))
	{
       	// boot players and log the error
       	if (! GetIsDM(oPC)) { BootPC(oPC); return; }
	    ACR_PrintDebugMessage("acr_mod_events_i: ERROR - NWNX Unavailable on " + GetName(oPC) + " login.", _ONLOAD_DEBUG, DEBUG_LEVEL_FATAL);
	}

    // Code executed for DMs and PCs goes here

    // initialize the player - RUN THIS BEFORE INITIALIZING OTHER SYSTEMS
    ACR_PCOnClientEnter(oPC);

    // notify database system of login
    ACR_DBPersistOnIncomingPlayer(oPC);

	//initialize for chatlogging
	ACR_ChatOnClientEnter(oPC);

	// Initialize DM Client Extension pack (optional)
	ExecuteScript("wand_init", oPC);
	
    if (GetIsDM(oPC) || GetIsDMPossessed(oPC))
    {
	    // log the entry
	    ACR_LogEvent(oPC, ACR_LOG_LOGIN, "Dungeon Master: " + ACR_SQLEncodeSpecialChars(GetName(oPC)) + " from IP: "+GetPCIPAddress(oPC));
            DisplayGuiScreen(oPC, "zspawn_b", FALSE, "zspawn_b.xml");
    }
    else
    {
	    // log the entry
    	ACR_LogEvent(oPC, ACR_LOG_LOGIN, "Character: " + ACR_SQLEncodeSpecialChars(GetName(oPC))+ " from IP: "+GetPCIPAddress(oPC));
		
        // manage dead PCs - important for this to be done first
        ACR_DeathOnClientEnter(oPC);
		ACR_SkillsOnClientEnter(oPC);
    }
}

void ACR_ModuleOnPCLoaded()
{
	object oPC = GetEnteringObject();
	
	// process DMs
    if (GetIsDM(oPC) || GetIsDMPossessed(oPC))
    {
	    if (GetItemPossessedBy(oPC, "abr_spawn_debug") == OBJECT_INVALID) { CreateItemOnObject("acr_spawn_debug", oPC); }
		if (GetItemPossessedBy(oPC, "acr_dcsetter") == OBJECT_INVALID) { CreateItemOnObject("abr_it_dmdcsetter", oPC); }
		ExecuteScript("dmfi_mod_pcload", GetModule());
    }
	// process players
    else
    {
		int bSave = FALSE;
		
        // PC has Wizard levels, issue them a spellbook if they weren't issued one already
        if (ACR_HasCasterClass(oPC, "ARCANE")) {
		    if (!ACR_GetPersistentInt(oPC, ACR_MOD_SPELLBOOK)) {
			    bSave = TRUE;
                SetIdentified(CreateItemOnObject(ACR_MOD_SPELLBOOK_RESREF, oPC), TRUE);
                ACR_SetPersistentInt(oPC, ACR_MOD_SPELLBOOK, TRUE);
			}
        }
        // PC has Cleric/Ranger/Druid levels, issue them a holy symbol if they weren't issued one already
        if (ACR_HasCasterClass(oPC, "DIVINE")) {
		    if  (!ACR_GetPersistentInt(oPC, ACR_MOD_HOLYSYMBOL)) {
				bSave = TRUE;
            	SetIdentified(CreateItemOnObject(ACR_MOD_HOLYSYMBOL_RESREF, oPC), TRUE);
            	ACR_SetPersistentInt(oPC, ACR_MOD_HOLYSYMBOL, TRUE);
			}    
        }
		if (!ACR_GetPersistentInt(oPC, ACR_MOD_STARTINGGOLD))
		{
		    GiveGoldToCreature(oPC, 300);
			ACR_SetPersistentInt(oPC, ACR_MOD_STARTINGGOLD, TRUE);
			bSave = TRUE;
	    }
		if ((GetXP(oPC) <= 1) && !ACR_GetPersistentInt(oPC, ACR_MOD_STARTARMORX))
		{
		    DestroyObject(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC));
			ACR_SetPersistentInt(oPC, ACR_MOD_STARTARMORX, TRUE);
			bSave = TRUE;
	    }
		if (!ACR_GetPersistentInt(oPC, ACR_MOD_FIRSTAID_IT))
		{
		    SetIdentified(CreateItemOnObject(ACR_MOD_HEALKIT_RESREF, oPC), TRUE);
			ACR_SetPersistentInt(oPC, ACR_MOD_FIRSTAID_IT, TRUE);
			bSave = TRUE;
		}

		// DO THIS FIRST
		// restore the player's status and location
    	ACR_PCOnPCLoaded(oPC);

		// process dead players
		ACR_DeathOnPCLoaded(oPC);

        // rebuild the characters journal quest entries
        ACR_RebuildJournalQuestEntries(oPC);
		
		// queue up the skillpoint convo if it's an unconverted PC
		ACR_SkillsOnPCLoaded(oPC);

		// save the bic if inventory has been modified
		if (bSave) { ACR_PCSave(oPC, FALSE); }
							
	    // Initialize nonlethal damage system for the PC
	    DelayCommand(4.0, ACR_NLD_OnPCLoaded(oPC));
	
		//  only do this if the PC is already adapted to custom skills.
		if (GetSkillRank(0, oPC, TRUE) == 2) {
			// Initialize DMFI for the entering player or DM
			ExecuteScript("dmfi_mod_pcload", GetModule());
			// initialize/award RP XP, start this after the PC is already in.
			DelayCommand(30.0, ACR_XPOnClientLoaded(oPC));
			// process simulated rest (spell uses handled accordingly)
			//  delay this long enough for the status restore to take effect for HP.
        	DelayCommand(1.5, ACR_RestOnClientEnter(oPC));
		}
	}
}

void ACR_ModuleOnClientLeave()
{
    object oPC = GetExitingObject();

    // Code executed for DMs and PCs goes here.

    if(GetIsDM(oPC) || GetIsDMPossessed(oPC))
    {
        // Code only executed for DMs goes here.

        // log the departure
	    ACR_LogEvent(oPC, ACR_LOG_LOGOUT, "Dungeon Master: " + ACR_SQLEncodeSpecialChars(GetName(oPC)));
    }
    else
    {
        // Code only executed for PCs goes here.

        // log the departure
    	ACR_LogOnExit(oPC);

        object oItem = GetFirstItemInInventory(oPC);
		// Commented this loop out for now, since we don't do anything there
		/*
        while(oItem != OBJECT_INVALID)
        {
            // Code which executes on a PC's items goes here.
            oItem = GetNextItemInInventory();
        }
		*/
        // track resting across sessions
        ACR_RestOnClientLeave(oPC);
		
		// clean up Subdual mode leftovers
		ACR_NonLethalOnClientExit(oPC);
   	    ACR_SkillsOnClientExit(oPC);
    }
	
	ACR_PCOnClientLeave(oPC);
	
	// bank logged XP
	ACR_XPOnClientExit(oPC);

	// clean up chatlogging pointers
	ACR_ChatOnClientExit(oPC);

	// notify database system of logout
	ACR_DBPersistOnOutgoingPlayer(oPC);
}

void ACR_ModuleOnAcquireItem()
{
    object oItem = GetModuleItemAcquired();
    object oAcquiredFrom = GetModuleItemAcquiredFrom();
    object oAcquiredBy = GetModuleItemAcquiredBy();
    int nItemStackSize = GetModuleItemAcquiredStackSize(), bLogEvent = TRUE;
    string sTag;

	// SendMessageToAllDMs("Acquired Item: "+GetName(oItem)+" by "+GetName(oAcquiredBy)+" with valid: "+IntToString(GetIsObjectValid(oAcquiredBy))+ " in area "+GetName(GetArea(oAcquiredBy))+" with valid: "+IntToString(GetIsObjectValid(GetArea(oAcquiredBy))));
 
	// only process player acquisitions
	if (! GetIsPC(oAcquiredBy)) { return; }

	// ignore acquisition events triggered by DMs (for logging only)
	if (GetIsDM(oAcquiredBy) || GetIsDMPossessed(oAcquiredBy)) { bLogEvent = FALSE; }

	// ignore acquisition events triggered by logins (for logging only)
	else if (! GetIsObjectValid(GetArea(oAcquiredBy))) { bLogEvent = FALSE; }
	
	ACR_ItemOnAcquire(oItem, oAcquiredBy, oAcquiredFrom);
	
    // track the presence of non-detection items
	//  We don't use these yet, skip this call.
    //ACR_ManageNonDetectionOnAcquire(oItem, oAcquiredBy);

    // trap items with illegal properties
	// Since we don't use this yet, commenting out.
	//  if/when this is restored, should cache the list to a local array on the module
	//   as querying the database each time is extremely inefficient.
	/*
    if (ACR_GetHasIllegalProperties(oItem))
    {
        sEvent = ACR_LOG_ACQUIRE_ILLEGAL;
                
        // quarantine the item?
    }
	*/
	
    // log item acquisitions
    	sTag = GetTag(oItem);

	if ((sTag == "acr_nld_fist") || (sTag == "acr_ignore_acquire")) {
	    // don't need to log this, OOC from toggling subdual mode
	} else if (bLogEvent) {
		ACR_LogOnAcquired(oItem, oAcquiredBy, GetStolenFlag(oItem));
		// Also only need to process quest item acquisitions if PC is already in the mod.
		// grant quest XP for acquired quest items
    	ACR_QuestItemOnAcquire(oAcquiredBy, oItem);
    }
}

void ACR_ModuleOnUnAcquireItem() {
    object oItem = GetModuleItemLost();
    object oLostBy = GetModuleItemLostBy();
	
	// only process player drops
	if (! GetIsPC(oLostBy)) { return; }
 
	// fire handler for special items.
	ACR_ItemOnUnAcquire(oItem, oLostBy);

	// Nonlethal / subdual handling:
	ACR_NLD_OnWeaponSwitch(oLostBy, oItem, FALSE);
	
	// destroyed item in inventory are invalid but not OBJECT_INVALID
	// Items sold to stores fall into this category, so run scripts on them anyway
	//if (! GetIsObjectValid(oItem)) {
	//	SendMessageToPC(oLostBy, "Item has been destroyed.");
	//	return; 
	//}
	
    // track the presence of non-detection items
    ACR_ManageNonDetectionOnUnAcquire(oItem, oLostBy);

    // trap items with illegal properties
	//  Again, we don't have this managed via SQL tables, large waste of resources.
	//  commenting out for now, will replace with a locally cached version if it comes back later.
	/*
    if (ACR_GetHasIllegalProperties(oItem))
    {
        // log the event
        ACR_LogEvent(oLostBy, ACR_LOG_DROP_ILLEGAL, "Item: " + ACR_SQLEncodeSpecialChars(GetName(oItem)) + ", By: " + ACR_SQLEncodeSpecialChars(GetName(oLostBy)));
                
        // quarantine the item?
    }
    else */
	if (GetTag(oItem) == "acr_nld_fist")
	{
	    // don't need to log this, OOC from toggling subdual mode
	} else {
        // log item acquisitions
		ACR_LogOnUnacquired(oItem, oLostBy, GetStolenFlag(oItem));
    }
}

void ACR_ModuleOnActivateItem() {
    object oItem = GetItemActivated();
    object oActivator = GetItemActivator();
    object oTarget = GetItemActivatedTarget();
    location locTarget = GetItemActivatedTargetLocation();

	// handle items.
    ACR_ItemOnActivate(oItem, oActivator, oTarget, locTarget);

    // log item activation
    ACR_LogEvent(oActivator, ACR_LOG_ACTIVATE, "Item: " + ACR_SQLEncodeSpecialChars(GetName(oItem)) + ", By: " + ACR_SQLEncodeSpecialChars(GetName(oActivator)));
}

void ACR_ModuleOnPlayerDeath() {
    object oDead = GetLastPlayerDied();
    object oKiller = GetLastHostileActor();

	// *** check for disguises here - player names need to be restored for proper data logging on death ***
	
    // process the player death
    ACR_PlayerOnDeath(oDead, oKiller);
	// logging handled in ACR_PlayerOnDeath() - so we don't log false-positives from instakill protection.
	ACR_NLD_OnDeath(oDead);
}

void ACR_ModuleOnPlayerDying() {
    object oDying = GetLastPlayerDying();
    object oAttacker = GetLastAttacker();

    // process the player dying
    ACR_PlayerOnDying(oDying, oAttacker);
}

void ACR_ModuleOnPlayerLevelUp() {
    object oPC = GetPCLevellingUp();

    // handle the level up attempt
    ACR_ProcessLevelUpAttempt(oPC);
	
	// apply any hidden skill changes  
	ACR_SkillsOnPCLevelUp(oPC);

	// apply extra languages if necessary
	ACR_LanguagesOnLevelUp(oPC);
	
    // log the level up attempt
    ACR_LogEvent(oPC, ACR_LOG_LEVELUP, "Character: " + ACR_SQLEncodeSpecialChars(GetName(oPC)) + ", Level: " + IntToString(GetHitDice(oPC)));
}

void ACR_ModuleOnPlayerRespawn() {
    object oPC = GetLastRespawnButtonPresser();
}

void ACR_ModuleOnPlayerRest() {
    object oPC = GetLastPCRested();
    int nRestState = GetLastRestEventType();

    ACR_OnPlayerRest(oPC, nRestState);
}

void ACR_ModuleOnHeartbeat() {
}

void ACR_ModuleOnUserDefined() {
    int nEvent = GetUserDefinedEventNumber();
}

void ACR_ModuleOnPlayerEquip() {
    object oItem = GetPCItemLastEquipped();
	object oPC = GetPCItemLastEquippedBy();
	
	// handle equipped items.
    ACR_ItemOnEquip(oItem, oPC);
	
	// handle nonlethal damage modes
	ACR_NLD_OnWeaponSwitch(oPC, oItem);

}

void ACR_ModuleOnPlayerUnequip() {
    object oItem = GetPCItemLastUnequipped();
    object oPC = GetPCItemLastUnequippedBy();
	
	// handle unequipped items
	ACR_ItemOnUnEquip(oItem, oPC);
	
	// Subdual / nonlethal handling
    DelayCommand(0.1, ACR_NLD_OnWeaponSwitch(oPC, oItem, FALSE));
}

void ACR_ModuleOnCutsceneAbort() {
    object oPC = GetLastPCToCancelCutscene();

    // End the scrying effect for the PC aborting the cutscene
    if (ACR_GetIsScrying(oPC)) { ACR_ScryEnd(oPC); }
}

int ACR_ModuleOnChat(object oSpeaker, object oTarget, int nMode, string sText)
{
	//iterate the RPXP function to indicate an active PC
	SetLocalInt(oSpeaker, _RPXP_ACTIVITY, TRUE);

	if(GetStringLeft(sText, 1) == "#")
	{
		string sCommand = GetStringLowerCase(sText);
		
		string sMessage = "";
		
		if(sCommand == "#fort" || sCommand == "#fortitude")
		{
			int nRoll = d20();
			int nMod = GetFortitudeSavingThrow(oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Fortitude Save : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#ref" || sCommand == "#reflex")
		{
			int nRoll = d20();
			int nMod = GetReflexSavingThrow(oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Reflex Save : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#will")
		{
			int nRoll = d20();
			int nMod = GetWillSavingThrow(oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Will Save : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#str" || sCommand == "#strength")
		{
			int nRoll = d20();
			int nMod = GetAbilityModifier(ABILITY_STRENGTH, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Strength Check : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#dex" || sCommand == "#dexterity")
		{
			int nRoll = d20();
			int nMod = GetAbilityModifier(ABILITY_DEXTERITY, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Dexterity Check : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#con" || sCommand == "#constitution")
		{
			int nRoll = d20();
			int nMod = GetAbilityModifier(ABILITY_CONSTITUTION, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Constitution Check : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#int" || sCommand == "#intelligence")
		{
			int nRoll = d20();
			int nMod = GetAbilityModifier(ABILITY_INTELLIGENCE, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Intelligence Check : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#wis" || sCommand == "#wisdom")
		{
			int nRoll = d20();
			int nMod = GetAbilityModifier(ABILITY_WISDOM, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Wisdom Check : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#cha" || sCommand == "#charisma")
		{
			int nRoll = d20();
			int nMod = GetAbilityModifier(ABILITY_CHARISMA, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Charisma Check : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#app" || sCommand == "#appraise")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(SKILL_APPRAISE, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Appraise : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#bal" || sCommand == "#balance")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(30, oSpeaker); // balance
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Balance : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#bluff")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(SKILL_BLUFF, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Bluff : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#climb")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(31, oSpeaker); // climb
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Climb : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#con" || sCommand == "#concentration")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(SKILL_CONCENTRATION, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Concentration : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#alch" || sCommand == "#alchemy" || sCommand == "#craft alchemy" || sCommand == "#craft (alchemy)" || sCommand == "#craft: alchemy")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(64, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Craft (Alchemy) : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#arm" || sCommand == "#armor" || sCommand == "#craft armor" || sCommand == "#craft (armor)" || sCommand == "#craft: armor")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(65, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Craft (Armorer) : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#bowyer" || sCommand == "#craft bow" || sCommand == "#craft (bow)" || sCommand == "#craft: bow")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(66, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Craft (Bowyer) : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#weap" || sCommand == "#weapon" || sCommand == "#craft weapon" || sCommand == "#craft (weapon)" || sCommand == "#craft: weapon")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(67, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Craft (Weaponsmith) : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#script" || sCommand == "#decipher" || sCommand == "#decipher script")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(32, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Decipher Script : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#dip" || sCommand == "#diplo" || sCommand == "#diplomacy")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(SKILL_DIPLOMACY, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Diplomacy : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#trap" || sCommand == "#disarm" || sCommand == "#disable" || sCommand == "#disable device" || sCommand == "#dd")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(SKILL_DISABLE_TRAP, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Disable Device : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#disguise")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(34, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Disguise : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#escape" || sCommand == "#escape artist")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(35, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Escape Artist : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#forge" || sCommand == "#forgery")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(36, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Forgery : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#gather" || sCommand == "#information" || sCommand == "#info" || sCommand == "#gather info" || sCommand == "#gather information")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(37, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Gather Information : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#handle animal")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(38, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Handle Animal : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#heal")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(SKILL_HEAL, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Heal : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#hide")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(SKILL_HIDE, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Hide : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#jump")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(39, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Jump : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#arc" || sCommand == "#arcana" || sCommand == "#knowledge arcana" || sCommand == "#knowledge (arcana)" || sCommand == "#knowledge: arcana")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(40, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Knowledge (Arcana) : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#arch" || sCommand == "#architect" || sCommand == "#knowledge arch" || sCommand == "#knowledge (architecture and engineering)" || sCommand == "#knowledge: architecture and engineering")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(58, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Knowledge (Architecture and Engineering) : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#dung" || sCommand == "#dungeon" || sCommand == "#knowledge dungeoneering" || sCommand == "#knowledge (dungeoneering)" || sCommand == "#knowledge: dungeoneering")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(33, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Knowledge (Dungeoneering) : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#geo" || sCommand == "#geography" || sCommand == "#knowledge geography" || sCommand == "#knowledge (geography)" || sCommand == "#knowledge: geography")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(55, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Knowledge (Geography) : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#hist" || sCommand == "#histroy" || sCommand == "#knowledge history" || sCommand == "#knowledge (history)" || sCommand == "#knowledge: history")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(41, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Knowledge (History) : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#local" || sCommand == "#knowledge local" || sCommand == "#knowledge (local)" || sCommand == "#knowledge: local")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(59, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Knowledge (Local) : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#nat" || sCommand == "#nature" || sCommand == "#knowledge nature" || sCommand == "#knowledge (nature)" || sCommand == "#knowledge: nature")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(42, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Knowledge (Nature) : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#nob" || sCommand == "#nobility" || sCommand == "#knowledge nobility" || sCommand == "#knowledge (nobility and royalty)" || sCommand == "#knowledge: nobility and royalty")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(42, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Knowledge (Nature) : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#rel" || sCommand == "#religion" || sCommand == "#knowledge religion" || sCommand == "#knowledge (religion)" || sCommand == "#knowledge: religion")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(43, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Knowledge (Religion) : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#planes" || sCommand == "#the planes" || sCommand == "#knowledge planes" || sCommand == "#knowledge (the planes)" || sCommand == "#knowledge: the planes")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(44, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Knowledge (The Planes) : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#list" || sCommand == "#listen")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(SKILL_LISTEN, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Listen : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#ms" || sCommand == "#sneak" || sCommand == "#move silently")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(SKILL_MOVE_SILENTLY, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Move Silently : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#ol" || sCommand == "#lock" || sCommand == "#open lock" || sCommand == "#pick lock" || sCommand == "#open locks")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(SKILL_OPEN_LOCK, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Open Lock : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#parry")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(SKILL_PARRY, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Parry : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#act" || sCommand == "#acting" || sCommand == "#perform acting" || sCommand == "#perform (acting)" || sCommand == "#perform: acting")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(45, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Perform (Acting) : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#comedy" || sCommand == "#perform comedy" || sCommand == "#perform (comedy)" || sCommand == "#perform: comedy")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(63, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Perform (Comedy) : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#dance" || sCommand == "#perform dance" || sCommand == "#perform (dance)" || sCommand == "#perform: dance")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(46, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Perform (Dance) : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#keyboard" || sCommand == "#perform keyboard" || sCommand == "#perform (keyboard)" || sCommand == "#perform: keyboard")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(61, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Perform (Keyboard) : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#oratory" || sCommand == "#perform oratory" || sCommand == "#perform (oratory)" || sCommand == "#perform: oratory")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(47, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Perform (Oratory) : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#drums" || sCommand == "#perform drums" || sCommand == "#perform (drums)" || sCommand == "#perform: drums")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(60, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Perform (Drums) : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#string" || sCommand == "#perform string" || sCommand == "#perform (string)" || sCommand == "#perform: string")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(48, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Perform (String Instruments) : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#wind" || sCommand == "#woodwind" || sCommand == "#perform wind" || sCommand == "#perform (wind)" || sCommand == "#perform: wind")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(62, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Perform (Wind Instruments) : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#sing" || sCommand == "#perform sing" || sCommand == "#perform (sing)" || sCommand == "#perform: sing")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(62, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Perform (Sing) : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#profession")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(62, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Perform (Sing) : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#ride")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(28, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Ride : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#search")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(SKILL_SEARCH, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Search : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#sense motive" || sCommand == "#sm")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(51, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Sense Motive : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#sleight of hand" || sCommand == "#soh" || sCommand == "#pick pockets" || sCommand == "#pp")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(13, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Sleight of Hands : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#spellcraft" || sCommand == "#sc")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(SKILL_SPELLCRAFT, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Spellcraft : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#spot")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(SKILL_SPOT, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Spot : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#surv" || sCommand == "#survival")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(SKILL_SURVIVAL, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Survival : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#swim")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(53, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Swim : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#tumb" || sCommand == "#tumble")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(SKILL_TUMBLE, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Tumble : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#umd" || sCommand == "#use magic device")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(SKILL_USE_MAGIC_DEVICE, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Use Magic Device : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else if(sCommand == "#use rope")
		{
			int nRoll = d20();
			int nMod = GetSkillRank(54, oSpeaker);
			int nFinal = nRoll + nMod;
			sMessage = "<color=#8699D3>"+GetName(oSpeaker)+"</color><color=#203F91> : Use Rope : "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nFinal)+".";
		}
		else 
		{
			SendMessageToPC(oSpeaker, "I don't understand the command: "+sCommand+".");
			return FALSE;
		}
		
		object oPC = GetFirstPC();
		while(GetIsObjectValid(oPC))
		{
			if(GetIsDM(oPC) ||
			   GetIsDMPossessed(oPC) ||
			   ( GetArea(oPC) == GetArea(oSpeaker) && GetDistanceBetween(oPC, oSpeaker) < 40.0f ) ||
			   oPC == oSpeaker)
				SendMessageToPC(oPC, sMessage);
			oPC = GetNextPC();
		}
		return FALSE;	
	}
	
	if(nMode == CHAT_MODE_SERVER)
		return TRUE;
	if(nMode == CHAT_MODE_SHOUT)
		return TRUE;
	if(nMode == CHAT_MODE_SILENT_SHOUT)
		return TRUE;
	if(nMode == CHAT_MODE_TELL)
		return TRUE;

	// for now, this is all we'll place here.
	string sLangPick = GetLocalString(oSpeaker, "DefaultLanguage");
	if(GetStringLeft(sText, 1) == "@")
	{ // the player is attempting to specify a different language.
		string sNewPick = GetStringLowerCase(GetStringLeft(sText, 4));
		sText = GetStringRight(sText, GetStringLength(sText)-4);
		if(sNewPick == "@com")
		{
			sLangPick = "common";
		}
		else if(sNewPick == "@anm")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_ANIMAL) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_ANIMAL;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Animal.");
				return FALSE;
			}
		}
		else if(sNewPick == "@ass")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_ASSASSIN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_ASSASSIN;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Assassin.");
				return FALSE;
			}
		}
		else if(sNewPick == "@aby")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_ASSASSIN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_ASSASSIN;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Abyssal.");
				return FALSE;
			}
		}
		else if(sNewPick == "@alz")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_ALZHEDO) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_ALZHEDO;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Alzhedo.");
				return FALSE;
			}
		}
		else if(sNewPick == "@aqu")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_AQUAN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_AQUAN;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Aquan.");
				return FALSE;
			}
		}
		else if(sNewPick == "@aur")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_AURAN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_AURAN;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Auran.");
				return FALSE;
			}
		}
		else if(sNewPick == "@alg")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_ALGARONDAN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_ALGARONDAN;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Algarondan.");
				return FALSE;
			}
		}
		else if(sNewPick == "@can")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_CANT) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_CANT;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Thieves' Cant.");
				return FALSE;
			}
		}
		else if(sNewPick == "@cel")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_CELESTIAL) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_CELESTIAL;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Celestial.");
				return FALSE;
			}
		}
		else if(sNewPick == "@che")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_CHESSENTAN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_CHESSENTAN;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Chessentan.");
				return FALSE;
			}
		}
		else if(sNewPick == "@cho")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_CHONDATHAN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_CHONDATHAN;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Chondathan.");
				return FALSE;
			}
		}
		else if(sNewPick == "@chu")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_CHULTAN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_CHULTAN;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Chultan.");
				return FALSE;
			}
		}
		else if(sNewPick == "@dwa")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_DWARF) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_DWARF;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Dwarven.");
				return FALSE;
			}
		}
		else if(sNewPick == "@dro")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_DROW) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_DROW;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Drow.");
				return FALSE;
			}
		}
		else if(sNewPick == "@drs")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_DROWSIGN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_DROWSIGN;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Drow Sign.");
				return FALSE;
			}
		}
		else if(sNewPick == "@dru")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_DRUIDIC) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_DRUIDIC;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Druidic.");
				return FALSE;
			}
		}
		else if(sNewPick == "@dra")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_DRACONIC) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_DRACONIC;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Draconic.");
				return FALSE;
			}
		}
		else if(sNewPick == "@dam")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_DAMARAN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_DAMARAN;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Damaran.");
				return FALSE;
			}
		}
		else if(sNewPick == "@dmb")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_DAMBRATHAN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_DAMBRATHAN;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Dambrathan.");
				return FALSE;
			}
		}
		else if(sNewPick == "@dur")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_DURPARI) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_DURPARI;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Durpari.");
				return FALSE;
			}
		}
		else if(sNewPick == "@elf")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_ELVEN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_ELVEN;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Elven.");
				return FALSE;
			}
		}
		else if(sNewPick == "@gno")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_GNOME) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_GNOME;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Gnomish.");
				return FALSE;
			}
		}
		else if(sNewPick == "@gob")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_GOBLIN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_GOBLIN;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Goblin.");
				return FALSE;
			}
		}
		else if(sNewPick == "@gia")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_GIANT) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_GIANT;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Giant.");
				return FALSE;
			}
		}
		else if(sNewPick == "@gnl")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_GNOLL) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_GNOLL;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Gnoll.");
				return FALSE;
			}
		}
		else if(sNewPick == "@hlf")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_HALFLING) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_HALFLING;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Halfling.");
				return FALSE;
			}
		}
		else if(sNewPick == "@ign")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_IGNAN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_IGNAN;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Ignan.");
				return FALSE;
			}
		}
		else if(sNewPick == "@hdr")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_HALARDRIM) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_HALARDRIM;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Halardrim.");
				return FALSE;
			}
		}
		else if(sNewPick == "@hlr")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_HALRUAAN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_HALRUAAN;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Halruaan.");
				return FALSE;
			}
		}
		else if(sNewPick == "@ill")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_ILLUSKAN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_ILLUSKAN;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Illuskan.");
				return FALSE;
			}
		}
		else if(sNewPick == "@ims")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_IMASKAR) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_IMASKAR;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Imaskar.");
				return FALSE;
			}
		}
		else if(sNewPick == "@inf")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_INFERNAL) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_INFERNAL;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Infernal.");
				return FALSE;
			}
		}
		else if(sNewPick == "@l37")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_LEETSPEAK) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_LEETSPEAK;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Leet.");
				return FALSE;
			}
		}
		else if(sNewPick == "@lan")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_LANTANESE) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_LANTANESE;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Lantanese.");
				return FALSE;
			}
		}
		else if(sNewPick == "@lor")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_LOROSS) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_LOROSS;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Loross.");
				return FALSE;
			}
		}
		else if(sNewPick == "@mid")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_MIDANI) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_MIDANI;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Midani.");
				return FALSE;
			}
		}
		else if(sNewPick == "@mul")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_MULHORANDI) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_MULHORANDI;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Mulhorandi.");
				return FALSE;
			}
		}
		else if(sNewPick == "@nth")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_NETHERESE) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_NETHERESE;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Netherese.");
				return FALSE;
			}
		}
		else if(sNewPick == "@rsh")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_RASHEMI) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_RASHEMI;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Rashemi.");
				return FALSE;
			}
		}
		else if(sNewPick == "@ser")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_SERUSAN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_SERUSAN;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Serusan.");
				return FALSE;
			}
		}
		else if(sNewPick == "@sha")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_SHAARAN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_SHAARAN;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Sharran.");
				return FALSE;
			}
		}
		else if(sNewPick == "@sho")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_SHOU) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_SHOU;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Shou.");
				return FALSE;
			}
		}
		else if(sNewPick == "@syl")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_SYLVAN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_SYLVAN;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Sylvan.");
				return FALSE;
			}
		}
		else if(sNewPick == "@ter")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_TERRAN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_TERRAN;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Terran.");
				return FALSE;
			}
		}
		else if(sNewPick == "@tre")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_TREANT) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_TREANT;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Treant.");
				return FALSE;
			}
		}
		else if(sNewPick == "@tsh")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_TASHALAN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_TASHALAN;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Tashalan.");
				return FALSE;
			}
		}
		else if(sNewPick == "@tui")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_TUIGAN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_TUIGAN;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Tuigan.");
				return FALSE;
			}
		}
		else if(sNewPick == "@tur")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_TURMIC) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_TURMIC;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Turmic.");
				return FALSE;
			}
		}
		else if(sNewPick == "@orc")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_ORC) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_ORC;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Orc.");
				return FALSE;
			}
		}
		else if(sNewPick == "@nex")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_NEXALAN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_NEXALAN;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Nexalan.");
				return FALSE;
			}
		}
		else if(sNewPick == "@yti")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_YUANTI) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_YUANTI;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Yuan-Ti.");
				return FALSE;
			}
		}
		else if(sNewPick == "@und")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_UNDERCOMMON) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_UNDERCOMMON;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Undercommon.");
				return FALSE;
			}
		}
		if(sNewPick == "@ulu")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_ULUIK) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_ULUIK;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Uluik.");
				return FALSE;
			}
		}
		else if(sNewPick == "@unt")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_UNTHERIC) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_UNTHERIC;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Untheric.");
				return FALSE;
			}
		}
		else if(sNewPick == "@vas")
		{
			if(_IsLanguageKnown(oSpeaker, LNG_VAASAN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
				sLangPick = LNG_VAASAN;
			else
			{
				SendMessageToPC(oSpeaker, "You don't know how to speak Vaasan.");
				return FALSE;
			}
		}
	}
	
	if(sLangPick == "common" || sLangPick == "")
	{
		if(GetStringLeft(sText, 4) == "@com")
			sText = GetStringRight(sText, GetStringLength(sText)-4);
		return TRUE;
	}
	
	object oTool = _GetDMFITool(oSpeaker);
	string sNewString = DMFI_ProcessLanguage(sText, sLangPick, oTool);
	
	if(nMode == CHAT_MODE_PARTY)
	{
		string sMessage = "<color=#D7C5B9>"+GetName(oSpeaker)+" : </color><color=#FFFFFF>["+_CapitalizeWord(sLangPick)+", Party] "+sText;
		object oListener = GetFirstPC();
		while(GetIsObjectValid(oListener))
		{

			if(GetFactionEqual(oSpeaker, oListener) || GetIsDM(oListener) || GetIsDMPossessed(oListener) || oListener == oSpeaker)
			{
				if(_IsLanguageKnown(oListener, sLangPick) || GetIsDM(oListener) || GetIsDMPossessed(oListener))
					SendMessageToPC(oListener, sMessage);
			}
			oListener = GetNextPC();
		}	
		SendChatMessage(oSpeaker, oSpeaker, nMode, sNewString);
		return FALSE;
	}
	if(nMode == CHAT_MODE_TALK)
	{
		string sMessage = "<color=#D7C5B9>"+GetName(oSpeaker)+" : </color><color=#FFFFFF>["+_CapitalizeWord(sLangPick)+"] "+sText;
		location lSelf = GetLocation(oSpeaker);
		object oListener = GetFirstObjectInShape(SHAPE_SPHERE, 20.0f, lSelf);
		while(GetIsObjectValid(oListener))
		{
			if(_IsLanguageKnown(oListener, sLangPick))
					SendMessageToPC(oListener, sMessage);
			oListener = GetNextObjectInShape(SHAPE_SPHERE, 20.0f, lSelf);
		}
		oListener = GetFirstPC();
		while(GetIsObjectValid(oListener))
		{

			if((GetIsDM(oListener) || GetIsDMPossessed(oListener)) && GetArea(oSpeaker) == GetArea(oListener) && GetDistanceBetween(oSpeaker, oListener) <= 20.0f)
				SendMessageToPC(oListener, sMessage);
			oListener = GetNextPC();
		}
		SendChatMessage(oSpeaker, oSpeaker, nMode, sNewString);
		return FALSE;
	}
	if(nMode == CHAT_MODE_WHISPER)
	{
		string sMessage = "<color=#D7C5B9>"+GetName(oSpeaker)+" : </color><color=#808080>["+_CapitalizeWord(sLangPick)+", Whisper] "+sText;
		location lSelf = GetLocation(oSpeaker);
		object oListener = GetFirstObjectInShape(SHAPE_SPHERE, 3.0f, lSelf);
		while(GetIsObjectValid(oListener))
		{
			if(_IsLanguageKnown(oListener, sLangPick))
					SendMessageToPC(oListener, sMessage);
			oListener = GetNextObjectInShape(SHAPE_SPHERE, 3.0f, lSelf);
		}
		SendChatMessage(oSpeaker, oSpeaker, nMode, sNewString);
		oListener = GetFirstPC();
		while(GetIsObjectValid(oListener))
		{

			if((GetIsDM(oListener) || GetIsDMPossessed(oListener)) && GetArea(oSpeaker) == GetArea(oListener) && GetDistanceBetween(oSpeaker, oListener) <= 3.0f)
				SendMessageToPC(oListener, sMessage);
			oListener = GetNextPC();
		}
		return FALSE;
	}

	return TRUE;
}


int ACR_GetModuleStatus(int nStatus) {
    return (GetLocalInt(GetModule(), ACR_MOD_STATUS) & nStatus);
}

void ACR_SetModuleStatus(int nStatus) {
    object oModule = GetModule();
    SetLocalInt(oModule, ACR_MOD_STATUS, GetLocalInt(oModule, ACR_MOD_STATUS) | nStatus);
}
