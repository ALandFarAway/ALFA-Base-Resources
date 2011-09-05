////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_pps_i
//    $Revision:: 640        $ current version of the file
//        $Date:: 2011-05-09#$ date the file was created or modified
//       Author : Cipher & AcadiusLost
//
//    Var Prefix: ACR_PPS
//  Dependencies: None
//
//  Description
//  Persistent PC status system implementation based on ALFA requirements:
//  http://www.alandfaraway.org/phpBB2/viewtopic.php?t=30615
//
//  Revision History
//  2006/07/22  Cipher  Inception
//  2006/07/31  Cipher  Leveraged pc persistence and game location API
//  2006/08/18  Cipher  Leveraged debug system API, added spell restoration, and
//                      enhanced pc status tracking
//  2006/09/09  Cipher  Changed ALFA prefix to ACR
//  2006/09/15  Cipher  Updated global function references with ACR prefix
//  2006/09/19  Cipher  Updated references to PC persistence functions
//  2007/06/01  Cipher  Retrofit persistence calls with NWNX functions
//  2007/07/13  Cipher  Fixed errors with character creation query
//  2007/07/15  Cipher  Revised spell tracking
//  2007/07/21  Cipher  Revised ACR_SQLGetData() calls
//  2007/07/27  Cipher  Replaced all CDKeyID references with CDKey, dropped cdkeys ID column
//  2007/07/29  Cipher  Fixed location restore, removed unused constants, ignore players in quarantine
//  2007/09/14  AcadiusLost  Added ACR_PCSave() call to ACR_PCOnClientLeave(), added a few more
//                      ACR_SQLEncodeSpecialChars() wrappings for sCharacterName where appropriate
//  2007/09/18  AcadiusLost  Added third operand to ACR_PCSave() to skip location save, also to ACR_PCUpdateStatus
//                      also, removed BootPC() for unplayable (decayed) in PCOnClientEnter(). 
//                      added logs and counters for combat-logging and bleed-logging.
//  2008/05/31  AcadiusLost  Added check/controls to block and log CDKey switching. Stopgap until ACR can 
//                      be updated to handle change of CDkey without breaking persistency.  
//                      Also commented out Quarantine code temporarily.
//  2008/08/19  AcadiusLost  Fixed CDKey test exception which was booting new members on first login.
//  2008/12/09  AcadiusLost  Cleaned up PC ID selection OnClientEnter().
//  2009/01/14  AcadiusLost  Amended quarantine settings, enabled quarantine, made location status updates conditional
//  2009/02/01  AcadiusLost  Added more frequent LocalString location caches on oPC.  Changed logout code to use cache.
//					Changed Quarantine enforecement to a (more reliable) LocalInt
//  2009/02/07  AcadiusLost  Autosave cycle to 20 minutes, with cached PC locations every minute.  Added DM channel feedback.
//  2009/02/08  AcadiusLost  Added Passport check code for OnPCLoaded()
//  2009/02/09  AcadiusLost  Refined passport checking and quarantine proceedures.
//  2009/02/13  AcadiusLost  Fixes to logging for portalling events
//  2009/04/06  AcadiusLost  Added login update of Characters.IsOnline for better SQL population tracking.
//  2009/05/06  AcadiusLost  Added update OnClientEnter of the IsDM field of the players table.
//  2011/05/09  Paazin       Fix for location persistency when Start Location is not at Z-axis = 0.0
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#include "acr_debug_i"
#include "acr_settings_i"
#include "acr_spelltrack_i"
#include "acr_db_persist_i"
#include "acr_1984_i"
#include "acr_i"
#include "acr_portal_i"
#include "dmfi_inc_inc_com"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! 20 minute autosave cycle
const float ACR_PPS_CYCLE = 1200.0;

//! Location cache interval (# per PPS cycle)
const int ACR_PPS_CACHE_CYCLE = 20;

//! LocalInt cache on the PC for cycle cache count
const string ACR_PPS_COUNT = "ACR_PPS_COUNT";
//! LocalString cache on the PC for Current Location
const string ACR_PPS_LOCATION = "ACR_PPS_LOCATION";

//! 3 second transition delay
const float ACR_PPS_DELAY = 3.0;

//! Quarantine waypoint local object
const string ACR_PPS_QUARANTINE_WP = "ACR_PPS_QUARANTINE_WP";

//! Quarantine area blueprint tag
const string ACR_PPS_QUARANTINE_AR_TAG = "acr_quarantine_are";

//! Quarantine waypoint blueprint tag
const string ACR_PPS_QUARANTINE_WP_TAG = "acr_quarantine_wp";

//! Quarantine LocalInt
const string ACR_PPS_QUARANTINED = "ACR_PPS_QUARANTINED";

//! Debug ID string for debug messaging
const string ACR_PPS_DEBUG_ID = "acr_pps_i";

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! *** PUBLIC FUNCTIONS ***

//! This function saves pc status information and exports the character file
//!  - oPC: player to save
//!  - bExport: export bic if TRUE, skip export if FALSE
//!  - bSaveLocation: save location if TRUE, skip if FALSE
//!  - Returns: nothing
void ACR_PCSave(object oPC, int bExport = TRUE, int bSaveLocation = TRUE);

//! This function schedules a periodic character save to the server vault
//!  - oPC: player to save
//!  - Returns: nothing
void ACR_PCAutoSave(object oPC);

//! This function stores one-time lookup information on load
//!  - Returns: nothing
void ACR_PCOnModuleLoad();

//! This function initializes players and processes bans
//!  - oPC: player to initialize
//!  - Returns: nothing
void ACR_PCOnClientEnter(object oPC);

//! This function restores player status, including hit points, spells, and conditions
//!  - oPC: player to restore
//!  - Returns: nothing
void ACR_PCOnPCLoaded(object oPC);

//! This function resets player status
//!  - oPC: player that has left
//!  - Returns: nothing
void ACR_PCOnClientLeave(object oPC);

//! This function stores all relevant pc information that needs to be persistent
//!  - oPC: player whose status to update
//!  - bLocation: determines if the location should export as well.
//!  - Returns: nothing
void ACR_PCUpdateStatus(object oPC, int bLocation = TRUE);

//! Function to validate/normalize a Quarantined PC to the current server.
//!  Called by the DM Quarantine wand.
void ACR_PPSValidatePC(object oTarget);


//! *** PRIVATE FUNCTIONS ***

//! This function transitions the PC to their last saved location upon spawning in
//!  - oPC: player to transition
//!  - Returns: nothing
void _playerRestoreLocation(object oPC, location lLocation, int nCount = 0);

//! This function immobilizes the PC
//!  - oPC: player to immobilize
//!  - Returns: nothing
void _playerFreeze(object oPC);

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// *** BEGIN PUBLIC FUNCTIONS ***
////////////////////////////////////////////////////////////////////////////////

void ACR_PCSave(object oPC, int bExport = TRUE, int bSaveLocation = TRUE)
{
    // ignore DMs
    if (GetIsDM(oPC)) { return; }

	// ignore players in quarantine??
	if (GetLocalInt(oPC, "ACR_PPS_QUARANTINED")) { return; }
    //if (GetTag(GetArea(oPC)) == ACR_PPS_QUARANTINE_AR_TAG) { return; }

    ACR_PrintDebugMessage("acr_pps_i: Saving " + GetName(oPC) + " Character Data", ACR_PPS_DEBUG_ID, DEBUG_LEVEL_WARNING);

    // store player status and ability scores
	//  with or without location, as appropriate.
	if (bSaveLocation) {
        ACR_PCUpdateStatus(oPC);
	} else {
	    ACR_PCUpdateStatus(oPC, FALSE);
	}

    // save the player to the vault
    if (bExport) { 
		ExportSingleCharacter(oPC); 
	}
}

void ACR_PCAutoSave(object oPC)
{
    // stop processing once the player is no longer around
    if (GetIsObjectValid(oPC))
    {
		int nCycleIndex = GetLocalInt(oPC, ACR_PPS_COUNT) + 1;
		if (nCycleIndex == ACR_PPS_CACHE_CYCLE) {
			// it's time for an export/external update
        	// save the player to the vault
			SendMessageToAllDMs("Auto-exporting PC: "+GetName(oPC));
        	ACR_PCSave(oPC);
			// restart the counter
			SetLocalInt(oPC, ACR_PPS_COUNT, 0);
		} else {
			SetLocalInt(oPC, ACR_PPS_COUNT, nCycleIndex);
		}
		if (GetLocalInt(oPC, "ACR_PPS_QUARANTINED") == FALSE) {
			SetLocalString(oPC, ACR_PPS_LOCATION, ACR_LocationToString(GetLocation(oPC)));
		}
        // schedule the next auto save check
        DelayCommand((ACR_PPS_CYCLE / IntToFloat(ACR_PPS_CACHE_CYCLE)), ACR_PCAutoSave(oPC));
    }
}

void ACR_PCUpdateStatus(object oPC, int bLocation = TRUE)
{
    // retrieve the character ID
    int nCID = ACR_GetCharacterID(oPC);

    // update the character data
	if (bLocation) {
	    // normal save, with location included
		location lPC = GetLocation(oPC);
		string sLoc = ACR_LocationToString(lPC);
		if (!GetIsObjectValid(GetAreaFromLocation(lPC))) {
			// PC has likely logged out, use the cached location.
			sLoc = GetLocalString(oPC, ACR_PPS_LOCATION);
		} else {
			// valid location, update the cache
			SetLocalString(oPC, ACR_PPS_LOCATION, sLoc);
		}
		// do the SQL DB update
        ACR_SQLQuery("UPDATE characters SET" +
	    	"  ServerID=" + IntToString(ACR_GetServerId()) +
		    ", Location='" + sLoc + "'" +
    	    ", Level=" + IntToString(GetHitDice(oPC)) +
    	    ", Deity='" + GetDeity(oPC) + "'" +
    	    ", HP=" + IntToString(GetMaxHitPoints(oPC)) +
    	    ", XP=" + IntToString(GetXP(oPC)) +
    	    ", GP=" + IntToString(GetGold(oPC)) +
     	    ", Morals=" + IntToString(GetGoodEvilValue(oPC)) +
     	    ", Ethics=" + IntToString(GetLawChaosValue(oPC)) +
     	    ", Damage=" + IntToString(GetMaxHitPoints(oPC) - GetCurrentHitPoints(oPC)) +
     	    ", Class1=" + IntToString(GetClassByPosition(1, oPC)) +
     	    ", Class2=" + IntToString(GetClassByPosition(2, oPC)) +
     	    ", Class3=" + IntToString(GetClassByPosition(3, oPC)) +
     	    ", Level1=" + IntToString(GetLevelByPosition(1, oPC)) +
     	    ", Level2=" + IntToString(GetLevelByPosition(2, oPC)) +
     	    ", Level3=" + IntToString(GetLevelByPosition(3, oPC)) +
     	    ", STR=" + IntToString(GetAbilityScore(oPC, ABILITY_STRENGTH)) +
     	    ", CON=" + IntToString(GetAbilityScore(oPC, ABILITY_CONSTITUTION)) +
     	    ", DEX=" + IntToString(GetAbilityScore(oPC, ABILITY_DEXTERITY)) +
     	    ", `INT`=" + IntToString(GetAbilityScore(oPC, ABILITY_INTELLIGENCE)) +
     	    ", WIS=" + IntToString(GetAbilityScore(oPC, ABILITY_WISDOM)) +
     	    ", CHA=" + IntToString(GetAbilityScore(oPC, ABILITY_CHARISMA)) +
			", Wealth=" + IntToString(DMFI_GetNetWorth(oPC)) +
     	    " WHERE ID=" + IntToString(nCID));
	} else {
	    // special save, with location omitted
        ACR_SQLQuery("UPDATE characters SET" +
	    	"  ServerID=" + IntToString(ACR_GetServerId()) +
    	    ", Level=" + IntToString(GetHitDice(oPC)) +
    	    ", Deity='" + GetDeity(oPC) + "'" +
    	    ", HP=" + IntToString(GetMaxHitPoints(oPC)) +
    	    ", XP=" + IntToString(GetXP(oPC)) +
    	    ", GP=" + IntToString(GetGold(oPC)) +
     	    ", Morals=" + IntToString(GetGoodEvilValue(oPC)) +
     	    ", Ethics=" + IntToString(GetLawChaosValue(oPC)) +
     	    ", Damage=" + IntToString(GetMaxHitPoints(oPC) - GetCurrentHitPoints(oPC)) +
     	    ", Class1=" + IntToString(GetClassByPosition(1, oPC)) +
     	    ", Class2=" + IntToString(GetClassByPosition(2, oPC)) +
     	    ", Class3=" + IntToString(GetClassByPosition(3, oPC)) +
     	    ", Level1=" + IntToString(GetLevelByPosition(1, oPC)) +
     	    ", Level2=" + IntToString(GetLevelByPosition(2, oPC)) +
     	    ", Level3=" + IntToString(GetLevelByPosition(3, oPC)) +
     	    ", STR=" + IntToString(GetAbilityScore(oPC, ABILITY_STRENGTH)) +
     	    ", CON=" + IntToString(GetAbilityScore(oPC, ABILITY_CONSTITUTION)) +
     	    ", DEX=" + IntToString(GetAbilityScore(oPC, ABILITY_DEXTERITY)) +
     	    ", `INT`=" + IntToString(GetAbilityScore(oPC, ABILITY_INTELLIGENCE)) +
     	    ", WIS=" + IntToString(GetAbilityScore(oPC, ABILITY_WISDOM)) +
     	    ", CHA=" + IntToString(GetAbilityScore(oPC, ABILITY_CHARISMA)) +
			", Wealth=" + IntToString(DMFI_GetNetWorth(oPC)) +
     	    " WHERE ID=" + IntToString(nCID));
	}
	//save effects
}

void ACR_PCOnModuleLoad()
{
    // store the quarantine waypoint object for quick reference later
    // avoids performing costly object searches multiple times
    SetLocalObject(GetModule(), ACR_PPS_QUARANTINE_WP, GetWaypointByTag(ACR_PPS_QUARANTINE_WP_TAG));
	
	SendMessageToAllDMs("Initializing Quarantine: found "+GetName(GetLocalObject(GetModule(), ACR_PPS_QUARANTINE_WP)));
		
    // create the debug system ID for reporting if it doesn't exist
    ACR_CreateDebugSystem(ACR_PPS_DEBUG_ID, DEBUG_TARGET_TALK, DEBUG_TARGET_LOG, DEBUG_TARGET_LOG | DEBUG_TARGET_DMS);
}

void ACR_PCOnClientEnter(object oPC)
{
    string sCDKey = GetPCPublicCDKey(oPC), sPlayerName = GetPCPlayerName(oPC), sCharacterName = GetName(oPC);
	
    // hide the screen during initialization
    BlackScreen(oPC);

	//////////////////////////////////////////////////////
	// *** STEP 1: RETRIEVE/CREATE DATABASE RECORDS *** //
	//////////////////////////////////////////////////////

    ACR_PrintDebugMessage("acr_pps_i: Initializing " + GetName(oPC) + " Status", ACR_PPS_DEBUG_ID, DEBUG_LEVEL_INFO);
		
    // first, retrieve the CD Key information
    ACR_SQLQuery("SELECT IsBanned FROM cdkeys WHERE CDKey='" + sCDKey + "'");

    // record the CD Key if it does not already exist
    if (ACR_SQLFetch() != SQL_SUCCESS)
    {
        ACR_SQLQuery("INSERT INTO cdkeys (CDKey, IsBanned) VALUES('" + sCDKey + "', 0)");		
        ACR_SQLQuery("SELECT IsBanned FROM cdkeys WHERE CDKey='" + sCDKey + "'");
		
		// if there's a problem with the database - log an error and boot the player

		if (ACR_SQLFetch() != SQL_SUCCESS)
		{
 			if (! GetIsDM(oPC))	{ BootPC(oPC); return; }
	       	ACR_PrintDebugMessage("acr_pps_i: ERROR - Could not create cdkey record for " + GetName(oPC) + ". The database may be down. Aborting login processing.", ACR_PPS_DEBUG_ID, DEBUG_LEVEL_FATAL);
		}
    }
    // otherwise, check if this is a banned CD Key
    else if (ACR_SQLGetData(0) == "1")
    {
        // log the event then boot the player
        ACR_LogEvent(oPC, ACR_LOG_LOGIN_BANNED, "CDKey: " + sCDKey);
        BootPC(oPC); return;
    }

    // second, retrieve the IP address from the database
    ACR_SQLQuery("SELECT IsBanned FROM ipaddress WHERE CDKey='" + sCDKey + "'");

    // record the IP address if it does not already exist
    if (ACR_SQLFetch() != SQL_SUCCESS)
    {
        ACR_SQLQuery("INSERT INTO ipaddress (CDKey, IPAddress, IsBanned) VALUES('" + sCDKey + "','" + GetPCIPAddress(oPC) + "',0)");

		// if there's a problem with the database - transmit a warning
		if (ACR_SQLGetAffectedRows() == -1)
		{
        	ACR_PrintDebugMessage("acr_pps_i: WARNING - Could not create IP address record for " + GetName(oPC) + ". The database may be down.", ACR_PPS_DEBUG_ID, DEBUG_LEVEL_WARNING);
		}
    }
    // otherwise, check if this is a banned IP address
    else if (ACR_SQLGetData(0) == "1")
    {
        // log the event then boot the player
        ACR_LogEvent(oPC, ACR_LOG_LOGIN_BANNED, "IPAddress: " + GetPCIPAddress(oPC));
        BootPC(oPC); return;
    }

    // third, retrieve the player ID from the database
    //ACR_SQLQuery("SELECT ID, IsBanned FROM players WHERE CDKey='" + sCDKey + "' and Name='" + ACR_SQLEncodeSpecialChars(sPlayerName) + "'");
    ACR_SQLQuery("SELECT ID, IsBanned, CDKey, IsDM FROM players WHERE Name='" + ACR_SQLEncodeSpecialChars(sPlayerName) + "'");

    // record the player if it does not already exist
    if (ACR_SQLFetch() != SQL_SUCCESS)
    {
        ACR_SQLQuery("INSERT INTO players (CDKey, Name, FirstLogin, LastLogin, Logins, IsDM, IsBanned) VALUES ('" + sCDKey + "','" + ACR_SQLEncodeSpecialChars(sPlayerName) + "', now(), now(), 0, " + IntToString(GetIsDM(oPC)) + ", 0)");
        ACR_SQLQuery("SELECT ID, IsBanned, CDKey FROM players WHERE CDKey='" + sCDKey + "' and Name='" + ACR_SQLEncodeSpecialChars(sPlayerName) + "'");

		// if there's a problem with the database - log an error and boot the player
		if (ACR_SQLFetch() != SQL_SUCCESS)
		{
			if (! GetIsDM(oPC))	{ BootPC(oPC); return; }
        	ACR_PrintDebugMessage("acr_pps_i: ERROR - Could not create player record for " + GetName(oPC) + ". The database may be down. Aborting login processing.", ACR_PPS_DEBUG_ID, DEBUG_LEVEL_FATAL);
		}
    }
    // otherwise, check if this is a banned player
    else if (ACR_SQLGetData(1) == "1")
    {
        // log the event then boot the player
        ACR_LogEvent(oPC, ACR_LOG_LOGIN_BANNED, "Player: " + sPlayerName);
        BootPC(oPC); return;
    }
    string sPID = ACR_SQLGetData(0);
	string sWasDM = ACR_SQLGetData(3);
	string sIsDM = IntToString(GetIsDM(oPC));
		
	// Next, check if the CDKey has changed
	string sDBKey = ACR_SQLGetData(2);
	if (sDBKey != sCDKey) {
        // log the event then boot the player
        ACR_LogEvent(oPC, ACR_LOG_LOGIN_BANNED, "CDKey Mismatch- "+sCDKey+" Player: " + sPlayerName);
        BootPC(oPC); return;
	}
	if (sIsDM != sWasDM) {
		// This GSID is being used as a DM / Player and needs to be switched.
		ACR_SQLQuery("UPDATE players SET IsDm="+sIsDM+" WHERE ID=" + sPID);  
	} 	    
	// retrieve the character ID from the database
    ACR_SQLQuery("SELECT ID, IsDeleted, IsPlayable FROM characters WHERE PlayerID=" + sPID + " and Name='" + ACR_SQLEncodeSpecialChars(sCharacterName) + "'");
	
    // if it does not exist, create it
    if (ACR_SQLFetch() != SQL_SUCCESS)
    {
        ACR_SQLQuery("INSERT INTO characters (ServerID, PlayerID, Name, Level, Race, Subrace, Deity, Gender, HP, XP, GP, Ethics, Morals, Class1, Class2, Class3, Level1, Level2, Level3, STR, CON, DEX, `INT`, WIS, CHA, Damage, Deaths, IsOnline, IsDeleted, IsPlayable) VALUES (" +
	 		IntToString(ACR_GetServerId()) + "," +
           	sPID + ",'" + 
           	ACR_SQLEncodeSpecialChars(sCharacterName) + "'," + 
           	IntToString(GetHitDice(oPC)) + "," +
           	IntToString(GetRacialType(oPC)) + "," +
           	IntToString(GetSubRace(oPC)) + ",'" +
           	GetDeity(oPC) + "'," +
           	IntToString(GetGender(oPC)) + "," +
			IntToString(GetMaxHitPoints(oPC)) + "," +
           	IntToString(GetXP(oPC)) + "," +
           	IntToString(GetGold(oPC)) + "," +
           	IntToString(GetLawChaosValue(oPC)) + "," +
           	IntToString(GetGoodEvilValue(oPC)) + "," +
           	IntToString(GetClassByPosition(1, oPC)) + "," +
           	IntToString(GetClassByPosition(2, oPC)) + "," +
           	IntToString(GetClassByPosition(3, oPC)) + ",1,0,0," +
           	IntToString(GetAbilityScore(oPC, ABILITY_STRENGTH)) + "," +
           	IntToString(GetAbilityScore(oPC, ABILITY_CONSTITUTION)) + "," +
           	IntToString(GetAbilityScore(oPC, ABILITY_DEXTERITY)) + "," +
           	IntToString(GetAbilityScore(oPC, ABILITY_INTELLIGENCE)) + "," +
           	IntToString(GetAbilityScore(oPC, ABILITY_WISDOM)) + "," +
           	IntToString(GetAbilityScore(oPC, ABILITY_CHARISMA)) + ",0,0,1,0,1)");
        ACR_SQLQuery("SELECT ID, IsDeleted, IsPlayable FROM characters WHERE PlayerID=" + sPID + " and Name='" + ACR_SQLEncodeSpecialChars(sCharacterName) + "'");

		// if there's a problem with the database - log an error and boot the player
		if (ACR_SQLFetch() != SQL_SUCCESS)
		{
 			if (! GetIsDM(oPC))	{ BootPC(oPC); return; }
	       	ACR_PrintDebugMessage("acr_pps_i: ERROR - Could not create character record for " + sCharacterName + ". The database may be down. Aborting login processing.", ACR_PPS_DEBUG_ID, DEBUG_LEVEL_FATAL);
		}
	}
	
	string sCharID = ACR_SQLGetData(0);
	// boot deleted players
    if (ACR_SQLGetData(1) == "1")
    {
      	// log the event then boot the player
       	ACR_LogEvent(oPC, ACR_LOG_LOGIN_DELETED, "Character: " + sCharacterName);
       	BootPC(oPC); return;
    }
	// take note of unplayable characters (decayed corpses)
    else if (ACR_SQLGetData(2) == "0")
    {
       	// log the event
		// but do not boot the player (may be appealing for a tech rez, etc)
       	ACR_LogEvent(oPC, ACR_LOG_LOGIN_UNPLAYABLE, "Character: " + sCharacterName);
    }
	else 
	{
		// else player is valid.  Mark them as online.
		ACR_SQLQuery("UPDATE characters SET IsOnline=1 WHERE ID=" + sCharID);
	}
   	// assign the database ID to this PC
	ACR_SetCharacterID(oPC, StringToInt(sCharID));

	// store the player's CD Key so it can be retrieved even on exit events
	ACR_SetPCPublicCDKey(oPC);
}

void ACR_PCOnPCLoaded(object oPC)
{
	string sCID = IntToString(ACR_GetCharacterID(oPC)), sLocation, sServerID;
	
	vector vPosLoc = GetPosition(oPC), vPosStart = GetPositionFromLocation(GetStartingLocation());
	///////////////////////////////////////////
	// *** STEP 2: RESTORE PLAYER STATUS *** //
	///////////////////////////////////////////

	// retrieve the character ID from the database
	ACR_SQLQuery("SELECT ServerID, XP, GP, STR, CON, DEX, `INT`, WIS, CHA, Damage, Location FROM characters WHERE ID=" + sCID);

	// exit if the character information cannot be retrieved (possible database failure)
	if (ACR_SQLFetch() != SQL_SUCCESS)
	{
       	// log the event then boot the player
       	ACR_LogEvent(oPC, ACR_LOG_LOGIN, "Could not load character: " + GetName(oPC));
       	BootPC(oPC); return;
	}
	sLocation = ACR_SQLGetData(10);
	sServerID = ACR_SQLGetData(0);
	// restore status if this is not a newly created character
	if (sLocation != "" && sServerID != "") {
		int nServerID = StringToInt(sServerID);
	   	int nXP  = StringToInt(ACR_SQLGetData(1));
   		int nGP  = StringToInt(ACR_SQLGetData(2));
   		int nSTR = StringToInt(ACR_SQLGetData(3));
   		int nCON = StringToInt(ACR_SQLGetData(4));
   		int nDEX = StringToInt(ACR_SQLGetData(5));
   		int nINT = StringToInt(ACR_SQLGetData(6));
   		int nWIS = StringToInt(ACR_SQLGetData(7));
   		int nCHA = StringToInt(ACR_SQLGetData(8));
   		int nDamage = StringToInt(ACR_SQLGetData(9));
	   	location lLocation = ACR_StringToLocation(sLocation);
		
		// update the character and player status fields
		ACR_SQLQuery("UPDATE characters, players SET characters.IsOnline=1, players.LastLogin=now(), players.Logins=players.Logins+1, players.IsDM=" + IntToString(GetIsDM(oPC)) + " WHERE characters.ID=" + sCID + " and players.ID=characters.PlayerID");		
		
		// Check to see if the PC is logging into the right server:
   		if (nServerID != ACR_GetServerId()) {
			object oModule = GetModule();
			string sPassport = "";
			object oDestWP = OBJECT_INVALID;
			int bQuarantined = FALSE;
			SendMessageToPC(oPC, "Your PC registers as being from ALFA server "+IntToString(nServerID)+", checking for a valid server portalling pass.");
			if (ACR_PortalCheckPass(oPC, ACR_GetServerId())) {
				// gather passport to determine destination waypoint
				sPassport = GetLocalString(oPC, _ACR_PTL_PASSPORT);
				oDestWP = GetLocalObject(oModule, sPassport);
				if (oDestWP == OBJECT_INVALID) {
					// destination waypoint is not yet cached, find it
					oDestWP = GetObjectByTag(sPassport);
				}
				if (oDestWP == OBJECT_INVALID) {
					// still can't find it? report the error, quarantine, but leave the passport
					SendMessageToPC(oPC, "No Destination waypoint could be found; jumping you to Quarantine.");
					bQuarantined = TRUE;
				} else {
					// Passport looks fine, notify player, write portalling log
					SendMessageToPC(oPC, "Passport accepted.  Welcome to "+GetName(GetModule())+".");
					AssignCommand(oPC, ActionSpeakString("Passport accepted.  Welcome to "+GetName(GetModule())));
					ACR_SetPersistentString(oPC, _ACR_PTL_RECORD, "Succesful server portal from ServerID "+IntToString(nServerID)+" to serverID "+IntToString(ACR_GetServerId()));
					ACR_DeletePersistentVariable(oPC, _ACR_PTL_PASSPORT);
				}
			} else {
				// no Portalling Pass found; Quarantine.
				bQuarantined = TRUE;
		    }
			// done checking passport for Foreign PC, Quarantine if necessary
			if (bQuarantined) {
       			ACR_PrintDebugMessage("Quarantining " + GetName(oPC) + " - Unauthorized Access", ACR_PPS_DEBUG_ID, DEBUG_LEVEL_INFO);
        		SendMessageToPC(oPC, "You are not permitted to login to this server directly. You are being quarantined.");
				AssignCommand(oPC, ActionSpeakString("You are not permitted to login to this server directly. You are being quarantined."));
				SendMessageToAllDMs(GetName(oPC)+" has been Quarantined; prior ServerID was "+IntToString(nServerID)+".");
				SetLocalInt(oPC, ACR_PPS_QUARANTINED, TRUE);
       			// log the event
       			ACR_LogEvent(oPC, ACR_LOG_LOGIN_QUARANTINED, "Character: " + GetName(oPC));
        
       			// deposit the player in quarantine
       			AssignCommand(oPC, JumpToObject(GetLocalObject(oModule, ACR_PPS_QUARANTINE_WP), FALSE)); 
				DelayCommand(0.5, (_playerFreeze(oPC)));
				return;
			} else {
				// not Quarantined; jump to the destination and proceed to status restoration
				DeleteLocalInt(oPC, ACR_PPS_QUARANTINED);					
				effect ePC = GetFirstEffect(oPC);
				while (GetIsEffectValid(ePC)) {
					// loop through effects till we find the cutscene freeze, then remove it
					if (GetEffectType(ePC) == EFFECT_TYPE_CUTSCENEIMMOBILIZE) {
						RemoveEffect(oPC, ePC);
					} 
					ePC = GetNextEffect(oPC);
				}	
				ACR_LogEvent(oPC, ACR_LOG_TRANSITION, "Successful Server Portal from Server "+IntToString(nServerID)+" to Server "+ACR_GetServerName()+".");
				AssignCommand(oPC, JumpToObject(oDestWP, FALSE));
			}
   		} else { 
		 		
			// Returning player, restore status, etc
			//
			// clear any existing portalling passports, since the PC is relogging to the same server
			ACR_DeletePersistentVariable(oPC, _ACR_PTL_PASSPORT);
			DeleteLocalInt(oPC, ACR_PPS_QUARANTINED);
       		ACR_PrintDebugMessage("Restoring " + GetName(oPC) + " Status", ACR_PPS_DEBUG_ID, DEBUG_LEVEL_INFO);

			// DO THIS FIRST - LOCATION MAY BE OVERWRITTEN BY OTHER SYSTEMS IF NOT RESTORED FIRST
			// check if this is the character's first login	
			//  Removed Z coordinate check as per Paazin's recommendations
			if (vPosLoc.x == vPosStart.x && vPosLoc.y == vPosStart.y)
			{
       			// restore last known location if it's different
       			if (lLocation != GetLocation(oPC)) { AssignCommand(oPC, JumpToLocation(lLocation)); }
			}
		}
		// restore last saved status   
       	// initialize the returning player
       	int nDelta = 0;

        // restore condition (disease, curse, poison, level and ability damage effects)
       	// TBD - effects tracking not yet in place - do this before restoring ability damage
       	// because diseases and curses can affect ability scores

       	// restore attributes
       	if (GetAbilityScore(oPC, ABILITY_STRENGTH) > nSTR) {
            nDelta = GetAbilityScore(oPC, ABILITY_STRENGTH) - nSTR;
           	ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAbilityDecrease(ABILITY_STRENGTH, nDelta), oPC);
       	}
       	if (GetAbilityScore(oPC, ABILITY_DEXTERITY) > nDEX)
       	{
            nDelta = GetAbilityScore(oPC, ABILITY_DEXTERITY) - nDEX;
           	ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAbilityDecrease(ABILITY_DEXTERITY, nDelta), oPC);
       	}
       	if (GetAbilityScore(oPC, ABILITY_CONSTITUTION) > nCON) 
        {
            nDelta = GetAbilityScore(oPC, ABILITY_CONSTITUTION) - nCON;
           	ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAbilityDecrease(ABILITY_CONSTITUTION, nDelta), oPC);
       	}
       	if (GetAbilityScore(oPC, ABILITY_INTELLIGENCE) > nINT) 
        {
            nDelta = GetAbilityScore(oPC, ABILITY_INTELLIGENCE) - nINT;
           	ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAbilityDecrease(ABILITY_INTELLIGENCE, nDelta), oPC);
       	}
       	if (GetAbilityScore(oPC, ABILITY_WISDOM) > nWIS) 
        {
            nDelta = GetAbilityScore(oPC, ABILITY_WISDOM) - nWIS;
           	ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAbilityDecrease(ABILITY_WISDOM, nDelta), oPC);
       	}
       	if (GetAbilityScore(oPC, ABILITY_CHARISMA) > nCHA) 
        {
            nDelta = GetAbilityScore(oPC, ABILITY_CHARISMA) - nCHA;
           	ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAbilityDecrease(ABILITY_CHARISMA, nDelta), oPC);
       	}

       	// restore hit points - do this at the conclusion of the script to make sure it doesn't preempt location restores
       	if (nDamage > 0) 
        {
            effect eDamage = EffectDamage(nDamage);
           	DelayCommand(0.3, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oPC));
       	}
			
			
       	// restore spell uses
       	ACR_RestoreSpellUses(oPC);
   	} else {
		// New PC not previously in the database.
		// no previous location on record.
		// update the character and player status fields
		ACR_SQLQuery("UPDATE characters, players SET characters.Location='" + ACR_LocationToString(GetLocation(oPC)) + "', players.LastLogin=now(), players.Logins=players.Logins+1, players.IsDM=" + IntToString(GetIsDM(oPC)) + " WHERE characters.ID=" + sCID + " and players.ID=characters.PlayerID");
	}

    // schedule the auto save (since this only exports after a PPS_CYCLE, start counting after 60 seconds)
    DelayCommand(60.0, ACR_PCAutoSave(oPC));

    // reveal the screen
    DelayCommand(0.3, FadeFromBlack(oPC));
}

void ACR_PCOnClientLeave(object oPC)
{
	// store stats, etc
	// no need to export, since this will happen naturally in this case.
	//   save location anyway (as it will default to the PPS location cache)
	ACR_PCSave(oPC, FALSE, TRUE);
	
	// if PC is in combat, log the event as suspicious, increment tracking number
	if (GetIsInCombat(oPC)) {
	    int nCombatLogs = ACR_GetPersistentInt(oPC, "ACR_1984_NUM_COMBAT_LOGS") + 1;
	    ACR_LogEvent(oPC, ACR_LOG_COMBATLOGOUT, ACR_SQLEncodeSpecialChars(GetName(oPC))+", Number of times disconnected in combat: "+IntToString(nCombatLogs));
		ACR_SetPersistentInt(oPC, "ACR_1984_NUM_COMBAT_LOGS", nCombatLogs);
	} else if (ACR_GetIsPlayerBleeding(oPC)) {
	    int nBleedLogs = ACR_GetPersistentInt(oPC, "ACR_1984_NUM_BLEED_LOGS") + 1;
	    ACR_LogEvent(oPC, ACR_LOG_BLEEDLOG, ACR_SQLEncodeSpecialChars(GetName(oPC))+", Number of times disconnected during bleeding: "+IntToString(nBleedLogs));
		ACR_SetPersistentInt(oPC, "ACR_1984_NUM_BLEED_LOGS", nBleedLogs);	
	}
    // set the character online status
    ACR_SQLQuery("UPDATE characters SET IsOnline=0 WHERE ID=" + IntToString(ACR_GetCharacterID(oPC)));
}

void ACR_PPSValidatePC(object oTarget) {

	// need to activate all the ACR systems that were suspended by Quarantine
	effect eTest = GetFirstEffect(oTarget);
	while (GetIsEffectValid(eTest)) {
		// loop through effects till we find the cutscene freeze, then remove it
		if (GetEffectType(eTest) == EFFECT_TYPE_CUTSCENEIMMOBILIZE) {
			RemoveEffect(oTarget, eTest);
		} 
		eTest = GetNextEffect(oTarget);
	}	
	// then re-run the OnLoaded event.
	ACR_PCOnPCLoaded(oTarget);
		
}


////////////////////////////////////////////////////////////////////////////////
// *** BEGIN PRIVATE FUNCTIONS ***
////////////////////////////////////////////////////////////////////////////////

void _playerRestoreLocation(object oPC, location lLocation, int nCount = 0)
{
    // check if the player object is valid - otherwise they left
    if (GetIsObjectValid(oPC))
    {
        // check if the player has instantiated (spawned in)
        if (GetIsObjectValid(GetArea(oPC)))
        {
            ACR_PrintDebugMessage("Restoring " + GetName(oPC) + " Last Saved Location", ACR_PPS_DEBUG_ID, DEBUG_LEVEL_WARNING);

            // jump the player to their last saved location
            AssignCommand(oPC, JumpToLocation(lLocation));
        }
        // otherwise the player has yet to spawn - try again after a delay
        else
        {
            // schedule another attempt
            DelayCommand(ACR_PPS_DELAY + nCount, _playerRestoreLocation(oPC, lLocation, nCount + 1));
        }
    }
}

void _playerFreeze(object oPC)
{
    effect eFreeze = EffectCutsceneImmobilize();
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFreeze, oPC);
}
