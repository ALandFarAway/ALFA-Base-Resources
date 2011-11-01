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
#include "acr_feat_events_i"

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

// Private

//! Parse a roll command
void _ParseRoll(object pc, string cmd);

//! Parse a new language
string _ParseLang(object pc, string text);

//! Parse a new language
int _HandleLang(object pc, string text, int mode, string lang);

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
	
	// Do custom feat stuff.
	ACR_FeatOnClientEnter(oPC);
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

	// Do feat-specific stuff.
	ACR_FeatOnEquipItem(oPC, oItem);
}

void ACR_ModuleOnPlayerUnequip() {
    object oItem = GetPCItemLastUnequipped();
    object oPC = GetPCItemLastUnequippedBy();
	
	// handle unequipped items
	ACR_ItemOnUnEquip(oItem, oPC);
	
	// Subdual / nonlethal handling
    DelayCommand(0.1, ACR_NLD_OnWeaponSwitch(oPC, oItem, FALSE));
	
	// Do feat-specific stuff.
	ACR_FeatOnUnequipItem(oPC, oItem);	
}

void ACR_ModuleOnCutsceneAbort() {
    object oPC = GetLastPCToCancelCutscene();

    // End the scrying effect for the PC aborting the cutscene
    if (ACR_GetIsScrying(oPC)) { ACR_ScryEnd(oPC); }
}

int ACR_ModuleOnChat(object oSpeaker, object oTarget, int nMode, string sText)
{
	int len;
	string sMessage, sCommand, c, sLangPick;

	// iterate the RPXP function to indicate an active PC
	SetLocalInt(oSpeaker, _RPXP_ACTIVITY, TRUE);

	switch (nMode) {
		case CHAT_MODE_SERVER:
		case CHAT_MODE_SHOUT:
		case CHAT_MODE_SILENT_SHOUT:
		case CHAT_MODE_TELL:
			return TRUE;
	}

	len = GetStringLength(sText);

	c = GetStringLeft(sText, 1);

	// roll command
	if (c == "#" || c == "!")
	{
		sCommand = GetStringRight(GetStringLowerCase(sText), len-1);
		
		_ParseRoll(oSpeaker, sCommand);
		
		return FALSE;
	}

	sLangPick = GetLocalString(oSpeaker, "DefaultLanguage");

	// the player is attempting to specify a different language.
	if (c == "@") {
		sLangPick = _ParseLang(oSpeaker, sText);
		sText = GetStringRight(sText, GetStringLength(sText)-4);
	}
	

	return _HandleLang(oSpeaker, sText, nMode, sLangPick);
}


int ACR_GetModuleStatus(int nStatus) {
    return (GetLocalInt(GetModule(), ACR_MOD_STATUS) & nStatus);
}

void ACR_SetModuleStatus(int nStatus) {
    object oModule = GetModule();
    SetLocalInt(oModule, ACR_MOD_STATUS, GetLocalInt(oModule, ACR_MOD_STATUS) | nStatus);
}

int _CompareLeft(string str, string ref)
{
	int len = GetStringLength(ref);

	return (GetStringLeft(str,len) == ref);
}

void _ParseRoll(object pc, string cmd)
{
	int b,len,offset,mod = 0;
	string tmp,text=cmd;
	
	// kludge to handle nasty stuff like "craft: "
	
	if (TestStringAgainstPattern("(craft|knowledge|perform)**",cmd)) {

		tmp = "craft";
		if (_CompareLeft(cmd,tmp)) {
			len = GetStringLength(cmd);
			offset = GetStringLength(tmp);

			cmd = GetStringRight(cmd,len-offset);
		}
		
		tmp = "knowledge";
		if (_CompareLeft(cmd,tmp)) {
			len = GetStringLength(cmd);
			offset = GetStringLength(tmp);

			cmd = GetStringRight(cmd,len-offset);
		}

		tmp = "perform";
		if (_CompareLeft(cmd,tmp)) {
			len = GetStringLength(cmd);
			offset = GetStringLength(tmp);

			cmd = GetStringRight(cmd,len-offset);
		}

		// eat characters
		do {
			b = _CompareLeft(cmd, " ") + _CompareLeft(cmd, "-") + _CompareLeft(cmd, "(") + _CompareLeft(cmd, ":");
			
			// no alterations needed
			if (!b)
				break;

			len = GetStringLength(cmd);

			cmd = GetStringRight(cmd,len-1);
		} while (b);
	}

	// saves
	if (_CompareLeft(cmd,"for")) {
		ACR_SaveCheck(SAVING_THROW_FORT, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"ref")) {
		ACR_SaveCheck(SAVING_THROW_REFLEX, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"wil")) {
		ACR_SaveCheck(SAVING_THROW_WILL, pc, 0, TRUE, TRUE);
	}

	// initiative
	else if (_CompareLeft(cmd,"ini")) {
		// add bonus for improved initiative feat(s)
		mod += (GetHasFeat(FEAT_IMPROVED_INITIATIVE,pc) ? 4 : 0);
		mod += (GetHasFeat(FEAT_THUG,pc) ? 2 : 0);
		mod += (GetHasFeat(FEAT_BLOODED,pc) ? 2 : 0);
		
		ACR_StatCheck(ABILITY_DEXTERITY, pc, 0, TRUE, TRUE, mod);
	}

	// abilities
	else if (_CompareLeft(cmd,"str") || cmd == "str") {
		ACR_StatCheck(ABILITY_STRENGTH, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"dex")) {
		ACR_StatCheck(ABILITY_DEXTERITY, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"cons") || cmd == "con") { 
		ACR_StatCheck(ABILITY_CONSTITUTION, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"int")) {
		ACR_StatCheck(ABILITY_INTELLIGENCE, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"wis")) {
		ACR_StatCheck(ABILITY_WISDOM, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"cha")) {
		ACR_StatCheck(ABILITY_CHARISMA, pc, 0, TRUE, TRUE);
	}

	// skills
	else if (_CompareLeft(cmd,"app")) {
		ACR_SkillCheck(SKILL_APPRAISE, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"bal")) {
		ACR_SkillCheck(SKILL_BALANCE, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"blu")) {
		ACR_SkillCheck(SKILL_BLUFF, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"cli")) {
		ACR_SkillCheck(SKILL_CLIMB, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"conc")) {
		ACR_SkillCheck(SKILL_CONCENTRATION, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"alc")) {
		ACR_SkillCheck(SKILL_CRAFT__ALCHEMY, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"arm")) {
		ACR_SkillCheck(SKILL_CRAFT_ARMORSMITHING, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"bow")) {
		ACR_SkillCheck(SKILL_CRAFT_BOWMAKING, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"wea")) {
		ACR_SkillCheck(SKILL_CRAFT_WEAPONSMITHING, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"scr") || _CompareLeft(cmd,"dec")) {
		ACR_SkillCheck(SKILL_DECIPHER_SCRIPT, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"dip")) {
		ACR_SkillCheck(SKILL_DIPLOMACY, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"tra") || _CompareLeft(cmd,"disa") || cmd == "dd") {
		ACR_SkillCheck(SKILL_DISABLE_TRAP, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"disg") || cmd == "dis") {
		ACR_SkillCheck(SKILL_DISGUISE, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"esc") || _CompareLeft(cmd,"art") || cmd == "ea") {
		ACR_SkillCheck(SKILL_ESCAPE_ARTIST, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"for")) {
		ACR_SkillCheck(SKILL_FORGERY, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"gat") || _CompareLeft(cmd,"inf") || cmd == "gi") {
		ACR_SkillCheck(SKILL_GATHER_INFORMATION, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"han")) {
		ACR_SkillCheck(SKILL_HANDLE_ANIMAL, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"hea")) {
		ACR_SkillCheck(SKILL_HEAL, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"hid")) {
		ACR_SkillCheck(SKILL_HIDE, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"jum")) {
		ACR_SkillCheck(SKILL_JUMP, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"arca") || cmd == "arc") {
		ACR_SkillCheck(SKILL_KNOWLEDGE_ARCANA, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"arch") || _CompareLeft(cmd,"eng")) {
		ACR_SkillCheck(SKILL_KNOWLEDGE_ENGINEERING, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"dun")) {
		ACR_SkillCheck(SKILL_KNOWLEDGE_DUNGEONEERING, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"geo")) {
		ACR_SkillCheck(SKILL_KNOWLEDGE_GEOGRAPHY, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"his")) {
		ACR_SkillCheck(SKILL_KNOWLEDGE_NATURE, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"loc")) {
		ACR_SkillCheck(SKILL_KNOWLEDGE_LOCAL, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"nat")) {
		ACR_SkillCheck(SKILL_KNOWLEDGE_NATURE, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"nob") || _CompareLeft(cmd,"roy")) {
		ACR_SkillCheck(SKILL_KNOWLEDGE_NOBILITY, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"rel")) {
		ACR_SkillCheck(SKILL_KNOWLEDGE_RELIGION, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"pla") || _CompareLeft(cmd,"the p")) {
		ACR_SkillCheck(SKILL_KNOWLEDGE_THE_PLANES, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"lis")) {
		ACR_SkillCheck(SKILL_LISTEN, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"mov") || _CompareLeft(cmd,"sne") || cmd == "ms") {
		ACR_SkillCheck(SKILL_MOVE_SILENTLY, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"pick l") || _CompareLeft(cmd,"loc") || _CompareLeft(cmd,"ope") || cmd == "ol") {
		ACR_SkillCheck(SKILL_OPEN_LOCK, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"par")) {
		ACR_SkillCheck(SKILL_PARRY, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"act")) {
		ACR_SkillCheck(SKILL_PERFORM_ACT, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"com")) {
		ACR_SkillCheck(SKILL_PERFORM_ACT, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"dan")) {
		ACR_SkillCheck(SKILL_PERFORM_DANCE, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"key")) {
		ACR_SkillCheck(SKILL_PERFORM_KEYBOARD, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"ora")) {
		ACR_SkillCheck(SKILL_PERFORM_ORATORY, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"dru") || _CompareLeft(cmd,"per")) {
		ACR_SkillCheck(SKILL_PERFORM_PERCUSSION, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"stri") || cmd == "si") {
		ACR_SkillCheck(SKILL_PERFORM_STRING_INSTRUMENTS, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"win") || _CompareLeft(cmd,"woo") || cmd == "wi") {
		ACR_SkillCheck(SKILL_PERFORM_WIND_INSTRUMENTS, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"sin")) {
		ACR_SkillCheck(SKILL_PERFORM_SING, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"pro")) {
		ACR_SkillCheck(SKILL_PROFESSION, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"rid")) {
		ACR_SkillCheck(SKILL_RIDE, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"sea")) {
		ACR_SkillCheck(SKILL_SEARCH, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"sen") || cmd == "sm") {
		ACR_SkillCheck(SKILL_SENSE_MOTIVE, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"sle") || _CompareLeft(cmd,"pock p") || cmd == "pp" || cmd == "soh") {
		ACR_SkillCheck(SKILL_SLEIGHT_OF_HAND, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"spe") || cmd == "sc") {
		ACR_SkillCheck(SKILL_SPELLCRAFT, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"spo")) {
		ACR_SkillCheck(SKILL_SPOT, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"sur")) {
		ACR_SkillCheck(SKILL_SURVIVAL, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"swi")) {
		ACR_SkillCheck(SKILL_SWIM, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"tum")) {
		ACR_SkillCheck(SKILL_TUMBLE, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"use m") || _CompareLeft(cmd,"mag") || _CompareLeft(cmd,"dev") || cmd == "umd") {
		ACR_SkillCheck(SKILL_USE_MAGIC_DEVICE, pc, 0, TRUE, TRUE);
	}
	else if (_CompareLeft(cmd,"rop") || _CompareLeft(cmd,"use r") || cmd == "ur") {
		ACR_SkillCheck(SKILL_USE_ROPE, pc, 0, TRUE, TRUE);
	}
	else 
	{
		SendMessageToPC(pc, "I don't understand the command '"+text+"'");
	}
}


string _ParseLang(object oSpeaker, string sText)
{
	string sLangPick, c, sNewPick, sErr;

	sErr = GetLocalString(oSpeaker, "DefaultLanguage");
	sNewPick = GetStringLowerCase(GetStringLeft(sText, 4));

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
			return sErr;
		}
	}
	else if(sNewPick == "@ass")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_ASSASSIN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_ASSASSIN;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Assassin.");
			return sErr;
		}
	}
	else if(sNewPick == "@aby")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_ASSASSIN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_ASSASSIN;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Abyssal.");
			return sErr;
		}
	}
	else if(sNewPick == "@alz")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_ALZHEDO) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_ALZHEDO;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Alzhedo.");
			return sErr;
		}
	}
	else if(sNewPick == "@aqu")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_AQUAN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_AQUAN;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Aquan.");
			return sErr;
		}
	}
	else if(sNewPick == "@aur")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_AURAN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_AURAN;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Auran.");
			return sErr;
		}
	}
	else if(sNewPick == "@alg")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_ALGARONDAN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_ALGARONDAN;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Algarondan.");
			return sErr;
		}
	}
	else if(sNewPick == "@can")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_CANT) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_CANT;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Thieves' Cant.");
			return sErr;
		}
	}
	else if(sNewPick == "@cel")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_CELESTIAL) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_CELESTIAL;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Celestial.");
			return sErr;
		}
	}
	else if(sNewPick == "@che")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_CHESSENTAN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_CHESSENTAN;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Chessentan.");
			return sErr;
		}
	}
	else if(sNewPick == "@cho")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_CHONDATHAN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_CHONDATHAN;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Chondathan.");
			return sErr;
		}
	}
	else if(sNewPick == "@chu")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_CHULTAN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_CHULTAN;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Chultan.");
			return sErr;
		}
	}
	else if(sNewPick == "@dwa")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_DWARF) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_DWARF;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Dwarven.");
			return sErr;
		}
	}
	else if(sNewPick == "@dro")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_DROW) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_DROW;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Drow.");
			return sErr;
		}
	}
	else if(sNewPick == "@drs")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_DROWSIGN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_DROWSIGN;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Drow Sign.");
			return sErr;
		}
	}
	else if(sNewPick == "@dru")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_DRUIDIC) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_DRUIDIC;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Druidic.");
			return sErr;
		}
	}
	else if(sNewPick == "@dra")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_DRACONIC) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_DRACONIC;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Draconic.");
			return sErr;
		}
	}
	else if(sNewPick == "@dam")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_DAMARAN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_DAMARAN;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Damaran.");
			return sErr;
		}
	}
	else if(sNewPick == "@dmb")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_DAMBRATHAN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_DAMBRATHAN;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Dambrathan.");
			return sErr;
		}
	}
	else if(sNewPick == "@dur")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_DURPARI) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_DURPARI;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Durpari.");
			return sErr;
		}
	}
	else if(sNewPick == "@elf")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_ELVEN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_ELVEN;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Elven.");
			return sErr;
		}
	}
	else if(sNewPick == "@gno")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_GNOME) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_GNOME;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Gnomish.");
			return sErr;
		}
	}
	else if(sNewPick == "@gob")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_GOBLIN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_GOBLIN;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Goblin.");
			return sErr;
		}
	}
	else if(sNewPick == "@gia")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_GIANT) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_GIANT;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Giant.");
			return sErr;
		}
	}
	else if(sNewPick == "@gnl")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_GNOLL) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_GNOLL;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Gnoll.");
			return sErr;
		}
	}
	else if(sNewPick == "@hlf")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_HALFLING) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_HALFLING;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Halfling.");
			return sErr;
		}
	}
	else if(sNewPick == "@ign")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_IGNAN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_IGNAN;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Ignan.");
			return sErr;
		}
	}
	else if(sNewPick == "@hdr")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_HALARDRIM) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_HALARDRIM;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Halardrim.");
			return sErr;
		}
	}
	else if(sNewPick == "@hlr")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_HALRUAAN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_HALRUAAN;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Halruaan.");
			return sErr;
		}
	}
	else if(sNewPick == "@ill")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_ILLUSKAN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_ILLUSKAN;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Illuskan.");
			return sErr;
		}
	}
	else if(sNewPick == "@ims")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_IMASKAR) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_IMASKAR;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Imaskar.");
			return sErr;
		}
	}
	else if(sNewPick == "@inf")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_INFERNAL) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_INFERNAL;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Infernal.");
			return sErr;
		}
	}
	else if(sNewPick == "@l37")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_LEETSPEAK) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_LEETSPEAK;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Leet.");
			return sErr;
		}
	}
	else if(sNewPick == "@lan")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_LANTANESE) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_LANTANESE;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Lantanese.");
			return sErr;
		}
	}
	else if(sNewPick == "@lor")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_LOROSS) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_LOROSS;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Loross.");
			return sErr;
		}
	}
	else if(sNewPick == "@mid")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_MIDANI) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_MIDANI;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Midani.");
			return sErr;
		}
	}
	else if(sNewPick == "@mul")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_MULHORANDI) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_MULHORANDI;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Mulhorandi.");
			return sErr;
		}
	}
	else if(sNewPick == "@nth")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_NETHERESE) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_NETHERESE;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Netherese.");
			return sErr;
		}
	}
	else if(sNewPick == "@rsh")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_RASHEMI) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_RASHEMI;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Rashemi.");
			return sErr;
		}
	}
	else if(sNewPick == "@ser")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_SERUSAN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_SERUSAN;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Serusan.");
			return sErr;
		}
	}
	else if(sNewPick == "@sha")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_SHAARAN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_SHAARAN;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Sharran.");
			return sErr;
		}
	}
	else if(sNewPick == "@sho")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_SHOU) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_SHOU;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Shou.");
			return sErr;
		}
	}
	else if(sNewPick == "@syl")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_SYLVAN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_SYLVAN;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Sylvan.");
			return sErr;
		}
	}
	else if(sNewPick == "@ter")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_TERRAN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_TERRAN;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Terran.");
			return sErr;
		}
	}
	else if(sNewPick == "@tre")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_TREANT) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_TREANT;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Treant.");
			return sErr;
		}
	}
	else if(sNewPick == "@tsh")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_TASHALAN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_TASHALAN;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Tashalan.");
			return sErr;
		}
	}
	else if(sNewPick == "@tui")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_TUIGAN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_TUIGAN;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Tuigan.");
			return sErr;
		}
	}
	else if(sNewPick == "@tur")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_TURMIC) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_TURMIC;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Turmic.");
			return sErr;
		}
	}
	else if(sNewPick == "@orc")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_ORC) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_ORC;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Orc.");
			return sErr;
		}
	}
	else if(sNewPick == "@nex")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_NEXALAN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_NEXALAN;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Nexalan.");
			return sErr;
		}
	}
	else if(sNewPick == "@yti")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_YUANTI) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_YUANTI;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Yuan-Ti.");
			return sErr;
		}
	}
	else if(sNewPick == "@und")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_UNDERCOMMON) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_UNDERCOMMON;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Undercommon.");
			return sErr;
		}
	}
	if(sNewPick == "@ulu")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_ULUIK) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_ULUIK;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Uluik.");
			return sErr;
		}
	}
	else if(sNewPick == "@unt")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_UNTHERIC) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_UNTHERIC;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Untheric.");
			return sErr;
		}
	}
	else if(sNewPick == "@vas")
	{
		if(_IsLanguageKnown(oSpeaker, LNG_VAASAN) || GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
			sLangPick = LNG_VAASAN;
		else
		{
			SendMessageToPC(oSpeaker, "You don't know how to speak Vaasan.");
			return sErr;
		}
	}

	return sLangPick;
}


int _HandleLang(object oSpeaker, string sText, int nMode, string sLangPick)
{
	if (sLangPick == "common" || sLangPick == "")
	{
		if(GetStringLeft(sText, 4) == "@com")
			sText = GetStringRight(sText, GetStringLength(sText)-4);
		return TRUE;
	}
	
	object oTool = _GetDMFITool(oSpeaker);
	string sNewString = DMFI_ProcessLanguage(sText, sLangPick, oTool);
	
	if (nMode == CHAT_MODE_PARTY)
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
	else if (nMode == CHAT_MODE_TALK)
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
	else if (nMode == CHAT_MODE_WHISPER)
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
