////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_db_persist_i
//    $Revision:: 609        $ current version of the file
//        $Date:: 2011-05-26#$ date the file was created or modified
//       Author : Cipher
//
//    Var Prefix: ACR_SQL
//  Dependencies: NWNX4, MySQL
//
//  Description
//  These functions get and set variables stored in a database external of
//  Neverwinter Nights.
//
//  Based on aps_include by Ingmar Stieger, Adam Colon, Josh Simon.
//
//  Revision History
//  2007/03/30  Cipher  Inception
//  2007/07/13  Cipher  Added SQL table creation function
//  2007/07/21  Cipher  Replaced SetLocalString hooks with new NWNX functions
//  2007/07/23  Cipher  Bug Fix: Added missing SetLocalString hook to SetPersistentObject()
//  2007/07/25  Cipher  Added temporary workaround (use campaign db) for object persistence
//  2007/07/27  Cipher  Added Status column to characters table, dropped ID column from cdkeys table
//  2007/08/20  Cipher  Added spelltrack table initialization
//  2007/09/02  Cipher  Added quests table initialization and fixed CharacterID column size
//  2007/11/03 AcadiusLost  Added table initialization for Heed's PC Tools.
//  2007/12/16 AcadiusLost  Changed handling for persistent variables on corpses, also added function
//                    to end game for players when the DB is down.
//  2008/01/25 AcadiusLost  #included nwnx_system, altered ResetDatabase to restart via NWNx4
//  2008/01/26 AcadiusLost  switched ResetDatabase to a function (code migrated from nwnx_system.nss)
//  2009/01/19 AcadiusLost  Added update to Last field on updating existing pwdata rows.
//  2009/10/11 AcadiusLost  Altered Charaters table to include Class4/level4
//  2011/05/26 Ronan        Added asynchronous queries.
//  2011/07/02 Basilica     Added framework for persistent value caching
//  2011/08/05 Basilica     Added distinguished character id value ACR_CHARACTER_ID_NONE.
//  2011/08/31 Basilica     Added ACR_GetServerAddressFromDatabase.
//  2011/12/26 Basilica     Added ACR_GetPlayerID and ACR_SetPlayerID.
//  2012/04/21 Basilica     Updated database creation statements and statistics.
////////////////////////////////////////////////////////////////////////////////

#ifndef ACR_DB_PERSIST_I
#define ACR_DB_PERSIST_I

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! Define to 1 to use the MySQL Connector/NET SQL provider
#define ACR_DB_PERSIST_USE_CLR_SQL_PROVIDER 1

//! Return status of SQL queries
const int SQL_ERROR = 0;
const int SQL_SUCCESS = 1;

//! Character ID for optimizing database access
const string ACR_CID = "ACR_CID";

//! Player ID for optimizing database access
const string ACR_PID = "ACR_PID";

//! Player Membership status for optimizing database access
const string ACR_MEMBERSHIP = "ACR_ISMEMBER";

//! State variable for whether a character is a server admin
const string ACR_SRVADMIN = "ACR_SRVADMIN";

//! Module configuration setting indicating that statistics are not enabled.
const string ACR_DISABLE_STATISTICS = "ACR_DISABLE_STATISTICS";

//! Module configuration setting indicating that GameObjUpdate backoff is enabled.
const string ACR_GAMEOBJUPDATE = "GameObjUpdateBackoff";

//! Module local variable indicating the content patch path.  This value is
//  consumed and then deleted by the IPC subsystem at module startup.
const string ACR_MOD_CONTENT_PATCH_PATH = "ACR_MOD_CONTENT_PATCH_PATH";

//! Module local variable indicating that WER should be disabled.  This value
//  is consumed and then deleted by the IPC subsystem at module startup.
const string ACR_MOD_WER_DISABLED = "ACR_MOD_WER_DISABLED";

//! Module local variable indicating the compiler options that the content
//  patch system should use if a module recompile was required.
const string ACR_MOD_COMPILER_OPTIONS = "ACR_MOD_COMPILER_OPTIONS";

//! Database configuration setting indicating that module resource files should
//  be tallied.
const string ACR_MODULERESOURCEFILES_DB = "ModuleResourceFiles";

//! Database configuration setting indicating that module resource files should
//  be tallied.
const string ACR_MODULERESOURCEFILES_MOD = "ACR_MODULERESOURCEFILES";

//! Module variable indicating the cached notify service character id from the
//  database config table.
const string ACR_NOTIFY_SERVICE_CHARACTER_ID_MOD = "ACR_NOTIFY_SERVICE_CID";

//! Module variable indicating the cached error notify IRC recipient from the
//  database config table.
const string ACR_ERROR_NOTIFY_IRC_RECIPIENT_MOD = "ACR_ERROR_NOTIFY_IRC_RECIPIENT";

//! Module variable indicating the desired game difficulty level from the
//  database config table.
const string ACR_GAME_DIFFICULTY_LEVEL_MOD = "ACR_GAME_DIFFICULTY_LEVEL";

//! Database configuration setting indicating the location to search for
//  content patches at.
const string ACR_CONTENT_PATCH_PATH = "ContentPatchPath";

//! Database configuration setting indicating that WER should be disabled.
const string ACR_WER_DISABLED = "WerDisabled";

//! Database configuration setting indicating compiler options to use.
const string ACR_COMPILER_OPTIONS = "CompilerOptions";

//! Database configuration setting indicating the notify service character ID.
const string ACR_NOTIFY_SERVICE_CHARACTER_ID = "NotifyServiceCid";

//! Database configuration setting indicating the IRC recipient that error
//  diagnostics should be sent to.
const string ACR_ERROR_NOTIFY_IRC_RECIPIENT = "ErrorNotifyIrcRecipient";

//! Database configuration setting indicating the game difficulty level.
const string ACR_GAME_DIFFICULTY_LEVEL = "GameDifficultyLevel";

//! Values for ACR_SRVADMIN local on PC object.
const int ACR_SRVADMIN_INDETERMINITE = 0;  // Need to query database
const int ACR_SRVADMIN_IS_ADMIN = 1;       // Is an admin
const int ACR_SRVADMIN_NOT_ADMIN = 2;      // Is not an admin

//! Character ID constant to indicate that no actual record exists in the
//  characters table.
const int ACR_CHARACTER_ID_NONE = 0;

//! Status cache variable name.
const string ACR_PLAYERSTATUS_CACHE_VAR = "ACR_PLAYERSTATUS_CACHE";

//! GameObjUpdate backoff variable name.
const string ACR_HEALTHMONITOR_GAMEOBJUPDATE_BACKOFF_VAR = "ACR_HEALTHMONITOR_GAMEOBJUPDATE_BACKOFF";

//! CD Key to facilitate accecss even on exit events
const string ACR_CDKEY = "ACR_CDKEY";

//! local into to track timestamp failures
const string ACR_DB_FAILURES = "ACR_DB_FAILURES";

//! The async heartbeat delay
const float _ACR_DB_SQL_ASYNC_WRITE_HEARTBEAT_DELAY = 12.0;

//! Name of the async queue for local variable use.
const string _ACR_DB_SQL_QUEUE = "ACR_SQL_Q|";

//! Name of the database control flags local on the module.
const string _ACR_DB_CONTROL_FLAGS_VAR = "ACR_SQL_DB_CONTROL_FLAGS";

//! Name of the pending query for query flushing
const string _ACR_DB_SQL_PENDING_QUERY_VAR = "ACR_SQL_DB_PENDING_QUERY";

//! Name of the server boot timestamp variable (on cached objects)
const string _ACR_DB_SQL_SERVER_BOOT_TIME_VAR = "ACR_SQL_DB_SERVER_BOOT_TIME";

//! Name of the server boot timestamp variable (on module)
const string _ACR_DB_SQL_SERVER_BOOT_TIME_MOD_VAR = "ACR_SQL_DB_SERVER_BOOT_TIME_MODULE";

//! Prefix string for ACR persist cache locals
const string _ACR_DB_SQL_PERSIST_CACHE_VAR_PREFIX = "_ACRPERSISTCACHE_";

//! Prefix string used for the campaign object store file provider.
const string _ACR_DB_VDB_FILE = "VDB_File_";

//! Length of persist cache string
const int _ACR_DB_SQL_PERSIST_CACHE_VAR_PREFIX_LEN = 17;

//! Flags for _ServiceAsyncQueriesForObject
const int _ACR_SQL_SAQ_FLUSHALL = 0x00000001;    // flush the whole queue 

//! Flags for _GetDatabaseControlFlags / _SetDatabaseControlFlags
const int _ACR_SQL_DBCTRL_DATABASE_OFFLINE = 0x00000001;  // database link down
const int _ACR_SQL_DBCTRL_ASYNC_PENDING    = 0x00000002;  // have async queries

//! Maximum length of a SQL query

const int _ACR_SQL_QUERY_MAX_LEN = 16384;


//! Death system resrefs/tags

//! ResRef of the player corpse placeable (container)
const string ACR_DTH_CORPSE_RESREF = "abr_pl_co_so_pccorpse";

//! ResRef of the player corpse item (inventory)
const string ACR_DTH_BODY_RESREF = "abr_it_mi_body";


//! PC Local Flags bits.

//! Portal request is live and in progress.
const int ACR_PC_LOCAL_FLAG_PORTAL_IN_PROGRESS = 0x00000001;
//! Portal request has reached the stage where it cannot be rolled back without
//  disconnecting the player forcibly.
const int ACR_PC_LOCAL_FLAG_PORTAL_COMMITTED   = 0x00000002;
//! Help text sent to player about cross server tells and how they work.
const int ACR_PC_LOCAL_FLAG_SERVER_TELL_HELP   = 0x00000004;


//! Query flag bits.

//! Do not immediately initiate a query for an async query.
const int ACR_QUERY_LOW_PRIORITY               = 0x00000001;

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! This function starts the service which executes asynchronous queries.
void ACR_StartAsyncService();

//! This function loads and applies database-side configuration.
void ACR_LoadDatabaseConfiguration();

//! This function initialize database services.  It must be called before any
//  queries will function.
void ACR_InitializeDatabase();

//! This function executes an SQL statement asynchronously.
//! The submitted query is not guarenteed to be executed immediately.
//! This should ONLY be used for fire-and-forget writes unless the user flushes
//! the queue before reading the modified data back.
//!  - sSQL: The SQL string to execute
//!  - Returns: Nothing
void ACR_AsyncSQLQuery(string sSQL);

//! This function executes an SQL statement asynchronously.
//! The submitted query is not guarenteed to be executed immediately.
//! This should ONLY be used for fire-and-forget writes unless the user flushes
//! the queue before reading the modified data back.
//!  - sSQL: The SQL string to execute
//!  - oQueueTo: Supplies the object whose queue is to be used
//!  - nFlags: Supplies control flags (ACR_QUERY_*)
//!  - Returns: Nothing
void ACR_AsyncSQLQueryEx(string sSQL, object oQueueTo, int nFlags = 0);

//! This function executes an SQL statement.
//!  - sSQL: The SQL string to execute
//!  - Returns: Nothing
void ACR_SQLQuery(string sSQL);

//! This function retrieves the next row of the result set returned by the most
//! recent query. Call this before using ACR_SQLGetData().
//!  - mode: Selects a result set in a multi set result
//!    * Leave the parameter empty to advance to the next row in the resultset.
//!    * Pass "NEXT" as parameter to fetch the first row of the next resultset.
//!  - Returns: SQL_SUCCESS if there is a row, SQL_ERROR if there are no more rows.
int ACR_SQLFetch(string mode = " ");

//! This function retrieves the data in a specific column within the current row of the result set.
//!  - nCol: The index of the column to retrieve (max column size 65K) in the result row
//!  - Returns: The data in column nCol
string ACR_SQLGetData(int nCol = 0);

//! This function returns the number of rows that were affected by the last INSERT, UPDATE, or DELETE operation.
//!  - Returns: Number of rows affected
int ACR_SQLGetAffectedRows();

//! This function increments a statistics counter in the database, if statistic
//  counting was not disabled.
//!  - Statistic: Supplies the name of the statistic to bump.
void ACR_IncrementStatistic(string Statistic);

//! This function stores a persistent string
//!  - oObject: The object for which the data is being stored
//!  - sVarName: The unique variable name
//!  - sValue: The value to record 
//! Optional parameters:
//!  - iExpiration: The number of days the persistent variable should be kept in database (default: 0=forever)
void ACR_SetPersistentString(object oObject, string sVarName, string sValue, int iExpiration = 0);

//! This function stores a persistent string without moving the last timestamp forward
//!  - oObject: The object for which the data is being stored
//!  - sVarName: The unique variable name
//!  - sValue: The value to record 
//! Optional parameters:
//!  - iExpiration: The number of days the persistent variable should be kept in database (default: 0=forever)
void ACR_SetPersistentStringNoTimestamp(object oObject, string sVarName, string sValue, int iExpiration = 0);

//! This function stores a persistent integer
//!  - oObject: The object for which the data is being stored
//!  - sVarName: The unique variable name
//!  - iValue: The value to record 
//! Optional parameters:
//!  - iExpiration: The number of days the persistent variable should be kept in database (default: 0=forever)
void ACR_SetPersistentInt(object oObject, string sVarName, int iValue, int iExpiration = 0);

//! This function stores a persistent float
//!  - oObject: The object for which the data is being stored
//!  - sVarName: The unique variable name
//!  - fValue: The value to record 
//! Optional parameters:
//!  - iExpiration: The number of days the persistent variable should be kept in database (default: 0=forever)
void ACR_SetPersistentFloat(object oObject, string sVarName, float fValue, int iExpiration = 0);

//! This function stores a persistent location
//!  - oObject: The object for which the data is being stored
//!  - sVarName: The unique variable name
//!  - lValue: The value to record 
//! Optional parameters:
//!  - iExpiration: The number of days the persistent variable should be kept in database (default: 0=forever)
void ACR_SetPersistentLocation(object oObject, string sVarName, location lValue, int iExpiration = 0);

//! This function stores a persistent vector
//!  - oObject: The object for which the data is being stored
//!  - sVarName: The unique variable name
//!  - vValue: The value to record 
//! Optional parameters:
//!  - iExpiration: The number of days the persistent variable should be kept in database (default: 0=forever)
void ACR_SetPersistentVector(object oObject, string sVarName, vector vValue, int iExpiration = 0);

//! This function stores a persistent object
//!  - oObject: The object for which the data is being stored
//!  - sVarName: The unique variable name
//!  - oItem: The object to record 
//! Optional parameters:
//!  - iExpiration: The number of days the persistent variable should be kept in database (default: 0=forever)
void ACR_SetPersistentObject(object oObject, string sVarName, object oItem, string sDatabaseName, int iExpiration = 0);

//! This function retrieves a persistent string
//!  - oObject: The object for which the data is being retrieved
//!  - sVarName: The unique variable name
//!  - Returns: '' on error 
string ACR_GetPersistentString(object oObject, string sVarName);

//! This function retrieves a persistent int
//!  - oObject: The object for which the data is being retrieved
//!  - sVarName: The unique variable name
//!  - Returns: 0 on error 
int ACR_GetPersistentInt(object oObject, string sVarName);

//! This function retrieves a persistent float
//!  - oObject: The object for which the data is being retrieved
//!  - sVarName: The unique variable name
//!  - Returns: 0 on error 
float ACR_GetPersistentFloat(object oObject, string sVarName);

//! This function retrieves a persistent location
//!  - oObject: The object for which the data is being retrieved
//!  - sVarName: The unique variable name
//!  - Returns: 0 on error 
location ACR_GetPersistentLocation(object oObject, string sVarname);

//! This function retrieves a persistent vector
//!  - oObject: The object for which the data is being retrieved
//!  - sVarName: The unique variable name
//!  - Returns: 0 on error 
vector ACR_GetPersistentVector(object oObject, string sVarName);

//! This function retrieves a persistent object
//!  - oObject: The object for which the data is being retrieved
//!  - sVarName: The unique variable name
//!  - Returns: 0 on error 
object ACR_GetPersistentObject(object oObject, string sVarName, string sDatabaseName);

//! This function retrieves a legacy persistent object
//!  - oObject: The object for which the data is being retrieved
//!  - sVarName: The unique variable name
//!  - Returns: 0 on error 
object ACR_GetLegacyPersistentObject(object oObject, string sVarName, string sDatabaseName);

//! This function deletes a persistent record
//!  - oObject: The object for which the data is being deleted
//!  - sVarName: The unique variable name
void ACR_DeletePersistentVariable(object oObject, string sVarName);

//! This function handles special characters (like ') for database storage
//! Problems can arise with SQL commands if variables or values have single or
//! double quotes in their names. This function encodes these quotes so the
//! underlying database can safely store them.
//!  - sString: The string to encode
string ACR_SQLEncodeSpecialChars(string sString);

//! This function converts a location to a string
//!  - lLocation: The location to convert
//!  - Returns: A string equivalent
string ACR_LocationToString(location lLocation);

//! This function converts a string to a location
//!  - sLocation: The string to convert
//!  - Returns: A location
location ACR_StringToLocation(string sLocation);

//! This function converts a vector to a string
//!  - vVector: The vector to convert
//!  - Returns: A string equivalent
string ACR_VectorToString(vector vVector);

//! This function converts a string to a vector
//!  - sVector: The string to convert
//!  - Returns: A vector
vector ACR_StringToVector(string sVector);

//! This function sets the CD Key of the player - this should be called only once
//!  - oPC: player whose CD Key to set
//!  - Returns: nothing
void ACR_SetPCPublicCDKey(object oPC);

//! This function retrieves the CD Key of the player - always use this with exit events
//!  - oPC: player whose CD Key to retrieve
//!  - Returns: oPC's CD Key
string ACR_GetPCPublicCDKey(object oPC);

//! This function sets the database ID of the character - used to optimize database access
//!  - oPC: player whose character ID to set
//!  - nID: database ID of the character
//!  - nPID: database ID of the character's player
//!  - Returns: nothing
void ACR_SetCharacterID(object oPC, int nID, int nPID);

//! This function retrieves the database ID of the character
//!  - oPC: player whose character ID to retrieve
//!  - Returns: oPC's character ID
int ACR_GetCharacterID(object oPC);

//! This function retrieves the database ID of the character's player
//!  - oPC: player whose player ID to retrieve
//!  - Returns: oPC's player ID
int ACR_GetPlayerID(object oPC);

//! This function retrieves the database setting for if a given player
//! is a member.
//! - oPC: the character whose player we wish to check.
//! - Returns: 0 if the player is not a member. 1 if the player is a member.
int ACR_GetIsMember(object oPC);

//! This function determines whether the player is a server admin on this server
//!  - oPC: player whose admin status should be checked
//!  - Returns: TRUE if the player is a server admin on this server
int ACR_IsServerAdmin(object oPC);

//! This function returns the current PC local flags for a PC.
//!  - oPC: player whose local flags should be retrieved
//!  - Returns: the local flags value.
int ACR_GetPCLocalFlags(object oPC);

//! This function assigns the PC local flags for a PC.
//!  - oPC: player whose local flags should be assigned
//!  - nFlags: Local flags to assign (overwrites entirely).
void ACR_SetPCLocalFlags(object oPC, int nFlags);

//! This function creates the SQL database tables
//!   - Returns: nothing
void ACR_CreateSQLTables();

//!  Warns PCs, then reboots the module to try to reestablish the SQL database connection.
void ACR_ResetDatabase();

//! Checks for presence of columns added post-Live, adjust tables if necessary
void ACR_AdjustTables(); 

//! This function is called when a player joins the server so that the cache
//  spool may be mamanged.
//!  - oPC: player who is logging on
void ACR_DBPersistOnIncomingPlayer(object oPC);

//! This function is called when a player leaves the server so that the cache
//  spool may be managed.
//!  - oPC: player who is logging off
void ACR_DBPersistOnOutgoingPlayer(object oPC);

//! This function returns the real timestamp of the database server's clock,
//  standard time_t epoch.
//!  - Returns: Seconds since 1970.
int ACR_GetUTCTime();

//! This function returns the start time of the module in UTC time.
//!  - Returns: The module start time (seconds since 1970).
int ACR_GetModuleStartTime();

//! This function ensures that the query queue for a player is fully flushed.
void ACR_FlushQueryQueue(object oQueueObject);

//! This function returns the external address of the server based on the
//  connection address observed on the database for the SQL connection.
//! - Returns: The public address (which may be a hostname or raw IP) of the
//             server.  The server data port is not detected nor returned.
string ACR_GetServerAddressFromDatabase();

//! Populate an object's local variables from the persist store.  Note that the
//  existing variables on the Obj object are NOT cleared automatically first!
//!  - Obj: Supplies the object whose variables are to be loaded.
//!  - PCObject: Supplies the PC object id that owns the object.
//!  - DatabaseTag: Supplies the tag to name the variables under in the
//                  database (64 chars).  It need not be a real object tag, but
//                  must be unique among other object variable data stored for
//                  this character.
//!  - Returns: TRUE if the persist store had data for the object.
int ACR_LoadObjectVariablesFromPersistStore(object Obj, object PCObject, string DatabaseTag);

//! Save an object's local variables to the persist store.
//!  - Obj: Supplies the object whose variables are to be saved.
//!  - PCObject: Supplies the PC object id that owns the object.
//!  - DatabaseTag: Supplies the tag to name the variables under in the
//                  database (64 chars).  It need not be a real object tag, but
//                  must be unique among other object variable data stored for
//                  this character.
void ACR_SaveObjectVariablesToPersistStore(object Obj, object PCObject, string DatabaseTag);

//! Passes the reset command to the NWNx4 system plugin, taken from nwnx_system.nss
// Authors  : Ingmar Stieger (Papillon)
// Modified : 08/25/07 (kfw) : Added more useful error messages.
void _ResetServer();

//! Services the queue of asyncronous queries.
void _ServiceAsyncQueries();

//! Service the queue of asynchronous queries (allows per-object queuing)
//!  - oQueuedTo: Supplies the object that owns the queue spool
//!  - nFlags: Supplies control flags (ACR_SQL_SAQ_*)
//!  - nMaxServiced: Maximum elements to use in the queue (unused if flushall).
//!  - oModule: Supplies the module object
//!  - Returns: The number of elements dequeued is returned.
int _ServiceAsyncQueriesForQueue(object oQueuedTo, int nFlags, int nMaxServiced, object oModule);

//! Flush the query queue.  At least the queue for oQueueObject is guaranteed
//  to be flushed.
void _FlushQueryQueue(object oQueueObject);

//! Run queues immediately for all queue objects.
//!  - nMaxServiced: Supplies the maximum number of elements to run from the
//                   queue.
//!  - oModule: Supplies the module object as returned by GetModule().
//!  - oExtraQueueObject: Supplies an additional object whose queue should be
//                        checked, e.g. during player logout.  May be
//                        OBJECT_INVALID.
//!  - bAccumulate: Supplies TRUE if the function should opportunistically not
//                  clear out _ACR_DB_SQL_PENDING_QUERY_VAR but leave the final
//                  query to the caller.  The caller then is responsible for
//                  issuing the final query.
void _ExecuteQueryQueues(int nMaxServiced, object oModule, object oQueueObject, int bAccumulate);

//! Initiate a new async query cycle and run the current queue down when the
//  script returns control.
void _RunQueryQueue(int bDeferred);

//! Get the number of queued queries for all queues
//!  - oExtraQueueObject: Supplies an additional object whose queue should be
//                        checked, e.g. during player logout.
//!  - Returns: The number of queued queries for all queues
int _GetTotalQueuedQueryCount(object oQueueObject);

//! Get the database control flags
//!  - Returns: The database control flags (ACR_SQL_DBCTRL_*)
int _GetDatabaseControlFlags();

//! Set the database control flags
//!  - nControlFlags: The control flags to assign.
void _SetDatabaseControlFlags(int nControlFlags);

//! Maintain the ACR cache for an object.
//!  - oCacheObject: Supplies the object whose cache is to be maintained
//!  - sTag: Supplies the "tag" of the object for database queries.
void _MaintainACRPersistCache(object oCacheObject, string sTag);

//! Clear the ACR cache for an object.
//  oCacheObject: Supplies the object whose cache is to be cleared.
void _ClearACRPersistCache(object oCacheObject);

//! Calculate the typical number of queries to service for running the queue.
//!  - nTotalQueueLength: Suppiles the number of elements in all queues.
//!  - Returns: The target number of queries to dequeue.
//
int _CalculateTargetMaxQueriesServiced(int nTotalQueueLength);

//! This function executes an SQL statement without running the pending SQL
//  queue.  It should only be used by the pending SQL queue code.
//!  - sSQL: The SQL string to execute
//!  - Returns: Nothing
void _SQLQueryInternal(string sSQL);

//! Check whether a query returns values in a resultset or not (only basic
//  queries supported).
//
//!  - sSQL: The SQL string to inspect.
//!  - Returns: TRUE if the query returns a value (assumes TRUE if unrecognized
//              SQL syntax).
int _SQLQueryReturnsValues(string sSQL);

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "nwnx_include"
#include "acr_queue_i"
#include "acr_settings_i"
#include "acr_server_misc_i"

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void ACR_StartAsyncService()
{
	// Cache the start time if it hasn't yet been set.
	ACR_GetModuleStartTime();
	// If we already have pending new queries, there's nothing to do.
	if ((_GetDatabaseControlFlags() & _ACR_SQL_DBCTRL_ASYNC_PENDING) != 0)
		return;

	object Module = GetModule();

	// Begin unspooling any uncommitted queries if we need to
	if (GetQueueLength(Module, _ACR_DB_SQL_QUEUE) != 0)
		_RunQueryQueue(FALSE);
}

void ACR_InitializeDatabase()
{
#if ACR_DB_PERSIST_USE_CLR_SQL_PROVIDER
	// Create the standard database connection.  This always has the connection
	// ID of SCRIPT_STANDARD_DATABASE_CONNECTION_ID and it always uses the SQL
	// connection information for the SQL plugin.
	ACR_CreateDatabaseConnection("", SCRIPT_DATABASE_CONNECTION_STANDARD_QUERY_LOG | SCRIPT_DATABASE_CONNECTION_STANDARD_CONNECTION);
#endif
}

void ACR_LoadDatabaseConfiguration()
{
	object Module;
	string VarName;
	string VarValue;

	Module = GetModule();
	ACR_SQLQuery("SELECT `variable`, `value` FROM `config`");

	while (ACR_SQLFetch() == SQL_SUCCESS)
	{
		VarName = ACR_SQLGetData(0);
		VarValue = ACR_SQLGetData(1);

		if (VarName == ACR_DISABLE_STATISTICS)
		{
			WriteTimestampedLogEntry("acr_db_persist_i: Applying statistics gathering configuration from the database config table.");
			SetLocalInt(Module, ACR_DISABLE_STATISTICS, StringToInt(VarValue));
		}
		else if (VarName == ACR_GAMEOBJUPDATE)
		{
			WriteTimestampedLogEntry("acr_db_persist_i: Applying GameObjUpdate backoff configuration from database.");
			SetLocalInt(Module, ACR_HEALTHMONITOR_GAMEOBJUPDATE_BACKOFF_VAR, StringToInt(VarValue));
		}
		else if (VarName == ACR_MODULERESOURCEFILES_DB)
		{
			WriteTimestampedLogEntry("acr_db_persist_i: Applying ModuleResourceFiles logging configuration from database.");
			SetLocalInt(Module, ACR_MODULERESOURCEFILES_MOD, StringToInt(VarValue));
		}
		else if (VarName == ACR_CONTENT_PATCH_PATH)
		{
			WriteTimestampedLogEntry("acr_db_persist_i: ContentPatchPath: " + VarValue);
			SetLocalString(Module, ACR_MOD_CONTENT_PATCH_PATH, VarValue);
		}
		else if (VarName == ACR_WER_DISABLED)
		{
			WriteTimestampedLogEntry("acr_db_persist_i: WerDisabled: " + VarValue);
			SetLocalInt(Module, ACR_MOD_WER_DISABLED, StringToInt(VarValue));
		}
		else if (VarName == ACR_COMPILER_OPTIONS)
		{
			WriteTimestampedLogEntry("acr_db_persist_i: CompilerOptions: " + VarValue);
			SetLocalString(Module, ACR_MOD_COMPILER_OPTIONS, VarValue);
		}
		else if (VarName == ACR_NOTIFY_SERVICE_CHARACTER_ID)
		{
			WriteTimestampedLogEntry("acr_db_persist_i: NotifyServiceCid: " + VarValue);
			SetLocalInt(Module, ACR_NOTIFY_SERVICE_CHARACTER_ID_MOD, StringToInt(VarValue));
		}
		else if (VarName == ACR_ERROR_NOTIFY_IRC_RECIPIENT)
		{
			WriteTimestampedLogEntry("acr_db_persist_i: ErrorNotifyIrcRecipient: " + VarValue);
			SetLocalInt(Module, ACR_ERROR_NOTIFY_IRC_RECIPIENT_MOD, StringToInt(VarValue));
		}
		else if (VarName == ACR_GAME_DIFFICULTY_LEVEL)
		{
			WriteTimestampedLogEntry("acr_db_persist_i: GameDifficultyLevel: " + VarValue);
			SetLocalInt(Module, ACR_GAME_DIFFICULTY_LEVEL_MOD, StringToInt(VarValue));
		}
	}
}

void ACR_AsyncSQLQuery(string sSQL)
{
	ACR_AsyncSQLQueryEx(sSQL, GetModule());
}

void ACR_AsyncSQLQueryEx(string sSQL, object oQueueTo, int nFlags = 0)
{
	int Deferred = (nFlags & ACR_QUERY_LOW_PRIORITY) != 0;
	int PrevQueueLength;

	// Only players may own their own query queue as we do not have rundown for
	// other objects to flush the queue cleanly
	if (!GetIsPC(oQueueTo))
		oQueueTo = GetModule();

	PushQueueString(oQueueTo, _ACR_DB_SQL_QUEUE, sSQL);

	// If we don't have a run queue pending, kick one off now
	if ((_GetDatabaseControlFlags() & _ACR_SQL_DBCTRL_ASYNC_PENDING) == 0)
		_RunQueryQueue(Deferred);
}

void ACR_SQLQuery(string sSQL)
{
	// If the query returns a value, then we can't combine it opportunistically.
	if (_SQLQueryReturnsValues(sSQL))
	{
		_SQLQueryInternal(sSQL);
		return;
	}

	// Since we are going to have to make a query, go ahead and prepend the
	// queue (to the degree that we can).
	int MaxServiced;
	object Module = GetModule();
	int TotalQueueLength = _GetTotalQueuedQueryCount(OBJECT_INVALID);
	string Query;

	MaxServiced = _CalculateTargetMaxQueriesServiced(TotalQueueLength);

	// Run the queues for each of the objects that have queues, but don't issue
	// the final query (leave that to the next call).
	_ExecuteQueryQueues(MaxServiced, Module, OBJECT_INVALID, TRUE);

	// Prepend the unspooled queries to the query we are about to run
	Query = GetLocalString(Module, _ACR_DB_SQL_PENDING_QUERY_VAR) + sSQL;
	_SQLQueryInternal(Query);
	DeleteLocalString(Module, _ACR_DB_SQL_PENDING_QUERY_VAR);
}

int ACR_SQLFetch(string mode = " ")
{
#if ACR_DB_PERSIST_USE_CLR_SQL_PROVIDER
    return ACR_FetchDatabaseConnection(SCRIPT_STANDARD_DATABASE_CONNECTION_ID);
#else
    return NWNXGetInt("SQL", "FETCH", mode, 0);
#endif
}

string ACR_SQLGetData(int nCol = 0)
{
#if ACR_DB_PERSIST_USE_CLR_SQL_PROVIDER
	return ACR_GetColumnDatabaseConnection(SCRIPT_STANDARD_DATABASE_CONNECTION_ID, nCol);
#else
	return NWNXGetString("SQL", "GETDATA", "", nCol);
#endif
}

int ACR_SQLGetAffectedRows()
{
#if ACR_DB_PERSIST_USE_CLR_SQL_PROVIDER
    return ACR_GetAffectedRowCountDatabaseConnection(SCRIPT_STANDARD_DATABASE_CONNECTION_ID);
#else
    return NWNXGetInt("SQL", "GET AFFECTED ROWS", "", 0);
#endif
}

void ACR_IncrementStatistic(string Statistic)
{
	object Module = GetModule();
	string CounterName = ACR_SQLEncodeSpecialChars(Statistic);

	if (GetLocalInt(Module, ACR_DISABLE_STATISTICS))
		return;

	ACR_AsyncSQLQueryEx(
		"INSERT INTO `stat_counters` (`Name`, `Value`, `LastUpdate`) " +
		"VALUES ('" + CounterName + "', 1, NOW()) " +
		"ON DUPLICATE KEY UPDATE `Value` = `Value` + 1, " +
		"`LastUpdate`=NOW()",
		Module,
		ACR_QUERY_LOW_PRIORITY);
}

string ACR_SQLEncodeSpecialChars(string sString)
{
#if ACR_DB_PERSIST_USE_CLR_SQL_PROVIDER
    return ACR_EscapeStringDatabaseConnection(SCRIPT_STANDARD_DATABASE_CONNECTION_ID, sString);
#else
    return NWNXGetString("SQL", "GET ESCAPE STRING", sString, 0);
#endif
}

void ACR_SetPersistentString(object oObject, string sVarName, string sValue, int iExpiration = 0)
{
    // PC's don't have tags so use CD key instead
    string sTag = (GetIsPC(oObject)) ? ACR_GetPCPublicCDKey(oObject) : GetTag(oObject);
	// if this is a corpse placeable, drop the CharID suffix to allow it to read the player variable.
    if ((GetResRef(oObject) == ACR_DTH_CORPSE_RESREF) || (GetResRef(oObject) == ACR_DTH_BODY_RESREF)) { sTag = GetStringLeft(sTag, 8); }

    _MaintainACRPersistCache(oObject, sTag);
    SetLocalString(oObject, _ACR_DB_SQL_PERSIST_CACHE_VAR_PREFIX + sVarName, sValue);
    // insert the record or update the values if it already exists
    ACR_AsyncSQLQueryEx("INSERT INTO pwdata (Name, Tag, `Key`, Value, Expiration) VALUES ('"
	 + ACR_SQLEncodeSpecialChars(GetName(oObject)) + "','" + sTag + "','" + ACR_SQLEncodeSpecialChars(sVarName) + "', '"
     + sValue + "', " + IntToString(iExpiration) + ") ON DUPLICATE KEY UPDATE Value='" + sValue + "', Expiration=" + IntToString(iExpiration) + ", Last=NOW()",
	  oObject,
	  ACR_QUERY_LOW_PRIORITY);
}

void ACR_SetPersistentStringNoTimestamp(object oObject, string sVarName, string sValue, int iExpiration = 0)
{
    // PC's don't have tags so use CD key instead
    string sTag = (GetIsPC(oObject)) ? ACR_GetPCPublicCDKey(oObject) : GetTag(oObject);
	// if this is a corpse placeable, drop the CharID suffix to allow it to read the player variable.
    if ((GetResRef(oObject) == ACR_DTH_CORPSE_RESREF) || (GetResRef(oObject) == ACR_DTH_BODY_RESREF)) { sTag = GetStringLeft(sTag, 8); }

    _MaintainACRPersistCache(oObject, sTag);
    SetLocalString(oObject, _ACR_DB_SQL_PERSIST_CACHE_VAR_PREFIX + sVarName, sValue);
    // insert the record or update the values if it already exists
    ACR_AsyncSQLQueryEx("INSERT INTO pwdata (Name, Tag, `Key`, Value, Expiration) VALUES ('"
	 + ACR_SQLEncodeSpecialChars(GetName(oObject)) + "','" + sTag + "','" + ACR_SQLEncodeSpecialChars(sVarName) + "', '"
     + sValue + "', " + IntToString(iExpiration) + ") ON DUPLICATE KEY UPDATE Value='" + sValue + "', Expiration=" + IntToString(iExpiration),
	  oObject,
	  ACR_QUERY_LOW_PRIORITY);
}

string ACR_GetPersistentString(object oObject, string sVarName)
{
    // PC's don't have tags so use CD key instead
    string sTag = (GetIsPC(oObject)) ? ACR_GetPCPublicCDKey(oObject) : GetTag(oObject);
	// if this is a corpse placeable, drop the CharID suffix to allow it to read the player variable.
    if ((GetResRef(oObject) == ACR_DTH_CORPSE_RESREF) || (GetResRef(oObject) == ACR_DTH_BODY_RESREF)) { sTag = GetStringLeft(sTag, 8); }
    _MaintainACRPersistCache(oObject, sTag);
    return GetLocalString(oObject, _ACR_DB_SQL_PERSIST_CACHE_VAR_PREFIX + sVarName);
}

void ACR_SetPersistentInt(object oObject, string sVarName, int iValue, int iExpiration = 0)
{
    ACR_SetPersistentString(oObject, sVarName, IntToString(iValue), iExpiration);
}

int ACR_GetPersistentInt(object oObject, string sVarName)
{
    return StringToInt(ACR_GetPersistentString(oObject, sVarName));
}

void ACR_SetPersistentFloat(object oObject, string sVarName, float fValue, int iExpiration = 0)
{
    ACR_SetPersistentString(oObject, sVarName, FloatToString(fValue), iExpiration);
}

float ACR_GetPersistentFloat(object oObject, string sVarName)
{
    return StringToFloat(ACR_GetPersistentString(oObject, sVarName));
}

void ACR_SetPersistentLocation(object oObject, string sVarName, location lValue, int iExpiration = 0)
{
    ACR_SetPersistentString(oObject, sVarName, ACR_LocationToString(lValue), iExpiration);
}

location ACR_GetPersistentLocation(object oObject, string sVarName)
{
    return ACR_StringToLocation(ACR_GetPersistentString(oObject, sVarName));
}

void ACR_SetPersistentVector(object oObject, string sVarName, vector vValue, int iExpiration = 0)
{
    ACR_SetPersistentString(oObject, sVarName, ACR_VectorToString(vValue), iExpiration);
}

vector ACR_GetPersistentVector(object oObject, string sVarName)
{
    return ACR_StringToVector(ACR_GetPersistentString(oObject, sVarName));
}

void ACR_SetPersistentObject(object oObject, string sVarName, object oItem, string sDatabaseName, int iExpiration = 0)
{
    // PC's don't have tags so use CD key instead
    string sTag = (GetIsPC(oObject)) ? ACR_GetPCPublicCDKey(oObject) : GetTag(oObject);
	
	// if this is a corpse placeable, drop the CharID suffix to allow it to read the player variable.
    if ((GetResRef(oObject) == ACR_DTH_CORPSE_RESREF) || (GetResRef(oObject) == ACR_DTH_BODY_RESREF)) { sTag = GetStringLeft(sTag, 8); }

	 // flush queue for the object so that any pending writes are visible
	 // TODO:  This can and should go away when we start caching these values
	 //        on the object itself.  There is no reason to hit the database
	 //        each time for them.
	 _FlushQueryQueue(oObject);

    StoreCampaignObject(_ACR_DB_VDB_FILE + sDatabaseName, sVarName, oItem);
}

object ACR_GetPersistentObject(object oObject, string sVarName, string sDatabaseName)
{
    // PC's don't have tags so use CD key instead
    string sTag = (GetIsPC(oObject)) ? ACR_GetPCPublicCDKey(oObject) : GetTag(oObject);
	
	// if this is a corpse placeable, drop the CharID suffix to allow it to read the player variable.
    if ((GetResRef(oObject) == ACR_DTH_CORPSE_RESREF) || (GetResRef(oObject) == ACR_DTH_BODY_RESREF)) { sTag = GetStringLeft(sTag, 8); }

	 // flush queue for the object so that any pending writes are visible
	 // TODO:  This can and should go away when we start caching these values
	 //        on the object itself.  There is no reason to hit the database
	 //        each time for them.
	 _FlushQueryQueue(oObject);

    return RetrieveCampaignObject(_ACR_DB_VDB_FILE + sDatabaseName, sVarName, GetLocation(oObject), oObject);
}

object ACR_GetLegacyPersistentObject(object oObject, string sVarName, string sDatabaseName)
{
    // PC's don't have tags so use CD key instead
    string sTag = (GetIsPC(oObject)) ? ACR_GetPCPublicCDKey(oObject) : GetTag(oObject);
	
	// if this is a corpse placeable, drop the CharID suffix to allow it to read the player variable.
    if ((GetResRef(oObject) == ACR_DTH_CORPSE_RESREF) || (GetResRef(oObject) == ACR_DTH_BODY_RESREF)) { sTag = GetStringLeft(sTag, 8); }

    // retrieve the record from the database
    string sSQL = "SELECT Value FROM pwobject WHERE Name='" + ACR_SQLEncodeSpecialChars(GetName(oObject)) + "' and Tag='" + sTag + "' and `Key`='" + ACR_SQLEncodeSpecialChars(sVarName) + "'";
	 // flush queue for the object so that any pending writes are visible
	 // TODO:  This can and should go away when we start caching these values
	 //        on the object itself.  There is no reason to hit the database
	 //        each time for them.
	 _FlushQueryQueue(oObject);

    SetLocalString(GetModule(), "NWNX!SQL!SETSCORCOSQL", sSQL);
    //return RetrieveCampaignObject("NWNX", "-", GetLocation(oObject), oObject);
    return RetrieveCampaignObject(sDatabaseName, sVarName, GetLocation(oObject), oObject);
}

void ACR_DeletePersistentVariable(object oObject, string sVarName)
{
    // PC's don't have tags so use CD key instead
    string sTag = (GetIsPC(oObject)) ? ACR_GetPCPublicCDKey(oObject) : GetTag(oObject);
	// if this is a corpse placeable, drop the CharID suffix to allow it to read the player variable.
    if ((GetResRef(oObject) == ACR_DTH_CORPSE_RESREF) || (GetResRef(oObject) == ACR_DTH_BODY_RESREF)) { sTag = GetStringLeft(sTag, 8); }
    _MaintainACRPersistCache(oObject, sTag);
    DeleteLocalString(oObject, _ACR_DB_SQL_PERSIST_CACHE_VAR_PREFIX + sVarName);
    // retrieve the record from the database
    ACR_AsyncSQLQueryEx("DELETE FROM pwdata WHERE Name='" + ACR_SQLEncodeSpecialChars(GetName(oObject)) + "' and Tag='" + sTag + "' and `Key`='" + ACR_SQLEncodeSpecialChars(sVarName) + "'", oObject, ACR_QUERY_LOW_PRIORITY);
}

string ACR_VectorToString(vector vVector)
{
    return "X" + FloatToString(vVector.x) + "Y" + FloatToString(vVector.y) + "Z" + FloatToString(vVector.z);
}

vector ACR_StringToVector(string sVector)
{
    float fX, fY, fZ;
    int iPos, iCount, iLen = GetStringLength(sVector);

    if (iLen > 0)
    {
        iPos = FindSubString(sVector, "X") + 1;
        iCount = FindSubString(GetSubString(sVector, iPos, iLen - iPos), "Y");
        fX = StringToFloat(GetSubString(sVector, iPos, iCount));

        iPos = FindSubString(sVector, "Y") + 1;
        iCount = FindSubString(GetSubString(sVector, iPos, iLen - iPos), "Z");
        fY = StringToFloat(GetSubString(sVector, iPos, iCount));

        iPos = FindSubString(sVector, "Z") + 1;
        fZ = StringToFloat(GetSubString(sVector, iPos, iLen - iPos));
    }

    return Vector(fX, fY, fZ);
}

string ACR_LocationToString(location lLocation)
{
    object oArea = GetAreaFromLocation(lLocation);
    vector vPosition = GetPositionFromLocation(lLocation);
    float fOrientation = GetFacingFromLocation(lLocation);

	return ("#A#" + GetTag(oArea) +
			"#X#" + FloatToString(vPosition.x, 0) +
            "#Y#" + FloatToString(vPosition.y, 0) +
			"#Z#" + FloatToString(vPosition.z, 0) +
            "#O#" + FloatToString(fOrientation, 0));
}

location ACR_StringToLocation(string sLocation)
{
    object oArea;
    vector vPosition;
    float fOrientation, fX, fY, fZ;

    int iPos, iCount, iLen = GetStringLength(sLocation);

    if (iLen > 0)
    {
        iPos = FindSubString(sLocation, "#A#") + 3;
        iCount = FindSubString(GetSubString(sLocation, iPos, iLen - iPos), "#");
        oArea = GetObjectByTag(GetSubString(sLocation, iPos, iCount));

        iPos = FindSubString(sLocation, "#X#") + 3;
        iCount = FindSubString(GetSubString(sLocation, iPos, iLen - iPos), "#");
        fX = StringToFloat(GetSubString(sLocation, iPos, iCount));

        iPos = FindSubString(sLocation, "#Y#") + 3;
        iCount = FindSubString(GetSubString(sLocation, iPos, iLen - iPos), "#");
        fY = StringToFloat(GetSubString(sLocation, iPos, iCount));

        iPos = FindSubString(sLocation, "#Z#") + 3;
        iCount = FindSubString(GetSubString(sLocation, iPos, iLen - iPos), "#");
        fZ = StringToFloat(GetSubString(sLocation, iPos, iCount));

        vPosition = Vector(fX, fY, fZ);

        iPos = FindSubString(sLocation, "#O#") + 3;
        fOrientation = StringToFloat(GetSubString(sLocation, iPos, iLen - iPos));
    }

    return Location(oArea, vPosition, fOrientation);
}

void ACR_SetPCPublicCDKey(object oPC)
{
	SetLocalString(oPC, ACR_CDKEY, GetPCPublicCDKey(oPC));
}

string ACR_GetPCPublicCDKey(object oPC)
{
	return GetLocalString(oPC, ACR_CDKEY);
}

void ACR_SetCharacterID(object oPC, int nID, int nPID)
{
	SetLocalInt(oPC, ACR_CID, nID);
	SetLocalInt(oPC, ACR_PID, nPID);

	// If this isn't a player, don't try and initialize the cache as nobody will
	// be using it anyway.  Even more importantly, corpse restoration assumes
	// that invoking ACR_SetCharacterID will not reset the current query rowset.
	if (!GetIsPC(oPC))
		return;

	ACR_SQLQuery("SELECT Status FROM characters WHERE id=" + IntToString(nID));

	if (ACR_SQLFetch() == SQL_SUCCESS)
		SetLocalInt(oPC, ACR_PLAYERSTATUS_CACHE_VAR, StringToInt(ACR_SQLGetData(0)));
}

int ACR_GetCharacterID(object oPC)
{
	return GetLocalInt(oPC, ACR_CID);
}

int ACR_GetPlayerID(object oPC)
{
	return GetLocalInt(oPC, ACR_PID);
}

int ACR_GetIsMember(object oPC)
{
	int PlayerID;

	// We assume that a player who loses membership is a player
	// who is banned, so we don't refresh if we've already checked and seen "yes"
	// once before.
	if(GetLocalInt(oPC, ACR_MEMBERSHIP))
	{
		return TRUE;
	}

	//
	// Allow player ID zero - as this isn't actually a PC, it shouldn't be
	// beholden to restrictions.
	//

	PlayerID = ACR_GetPlayerID(oPC);

	if (PlayerID == 0)
	{
		return TRUE;
	}
	
	string sPlayerID = IntToString(PlayerID);
	ACR_SQLQuery("SELECT players.IsMember FROM players WHERE ID = '"+sPlayerID+"'");
	if(ACR_SQLFetch() != SQL_SUCCESS)
	{
		return FALSE;
	}
	if(ACR_SQLGetData(0) == "1")
	{
		SetLocalInt(oPC, ACR_MEMBERSHIP, TRUE);
		return TRUE;
	}
	return FALSE;
}

int ACR_IsServerAdmin(object oPC)
{
	switch (GetLocalInt(oPC, ACR_SRVADMIN))
	{

	case ACR_SRVADMIN_INDETERMINITE:
		//
		// We don't yet know if the player is an admin, ask the database and save
		// the result.  If we get any rows back, then we're an admin.
		// 

		ACR_SQLQuery("SELECT PlayerID FROM server_admins WHERE ServerID=" + IntToString(ACR_GetServerId()) + " AND PlayerID=" + IntToString(ACR_GetPlayerID(oPC)));

		if (ACR_SQLFetch() == SQL_SUCCESS)
		{
			SetLocalInt(oPC, ACR_SRVADMIN, ACR_SRVADMIN_IS_ADMIN);
			return TRUE;
		}
		else
		{
			SetLocalInt(oPC, ACR_SRVADMIN, ACR_SRVADMIN_NOT_ADMIN);
			return FALSE;
		}
		break;

	case ACR_SRVADMIN_IS_ADMIN:
		return TRUE;

	default:
	case ACR_SRVADMIN_NOT_ADMIN:
		return FALSE;

	}

	return FALSE;
}

int ACR_GetPCLocalFlags(object oPC)
{
	return GetLocalInt(oPC, "ACR_PC_LOCAL_FLAGS");
}

void ACR_SetPCLocalFlags(object oPC, int nFlags)
{
	SetLocalInt(oPC, "ACR_PC_LOCAL_FLAGS", nFlags);
}

void ACR_CreateSQLTables()
{
	// since this is called on each modloaded(), insert call to alter tables if necessary here.
	ACR_AdjustTables();
	// continue on as usual from here.
	
	ACR_SQLQuery(" CREATE TABLE IF NOT EXISTS `areas` (" +
		"`ID` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT," +
		"`ServerID` smallint(8) UNSIGNED NOT NULL," +
		"`Name` varchar(64) NOT NULL," +
		"`Tag` varchar(64) NOT NULL," +
		"`Visits` int(10) UNSIGNED NOT NULL default 0," +
		"`X` smallint(5) default NULL," +
		"`Y` smallint(5) default NULL," +
		"`Z` smallint(5) default NULL," +
		"`IsSafe` bool NOT NULL default false," +
		"`IsInside` bool NOT NULL default false," +
		"`IsNatural` bool NOT NULL default false," +
		"PRIMARY KEY (`ID`), UNIQUE KEY (`ServerID`, `Tag`)" +
	") ENGINE=MyISAM DEFAULT CHARSET=latin1;");

	ACR_SQLQuery("CREATE TABLE IF NOT EXISTS `cdkeys` (" +
    		"`CDKey` varchar(8) NOT NULL," +
		"`IsBanned` bool NOT NULL default false," +
		"PRIMARY KEY (`CDKey`)" +
	") ENGINE=MyISAM DEFAULT CHARSET=latin1;");

	ACR_SQLQuery("CREATE TABLE IF NOT EXISTS `characters` (" +
		"`ID` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT," +
		"`ServerID` smallint(5) UNSIGNED NOT NULL," +
		"`PlayerID` mediumint(8) UNSIGNED NOT NULL," +
		"`Name` varchar(32) NOT NULL," +
		"`Level` tinyint(3) UNSIGNED NOT NULL default 1," +
		"`Race` tinyint(3) UNSIGNED NOT NULL," +
		"`Subrace` tinyint(3) UNSIGNED default NULL," +
		"`Deity` varchar(32) default NULL," +
		"`Gender` tinyint(3) UNSIGNED NOT NULL," +
		"`HP` smallint(5) UNSIGNED NOT NULL," +
		"`XP` mediumint(8) UNSIGNED NOT NULL default 0," +
		"`GP` int(10) UNSIGNED NOT NULL default 0," +
		"`Wealth` int(10) UNSIGNED NOT NULL default 0," +
		"`Ethics` tinyint(3) UNSIGNED NOT NULL," +
		"`Morals` tinyint(3) UNSIGNED NOT NULL," +
		"`Class1` smallint(5) UNSIGNED NOT NULL," +
		"`Level1` tinyint(3) UNSIGNED NOT NULL default 1," +
		"`Class2` smallint(5) UNSIGNED default NULL," +
		"`Level2` tinyint(3) UNSIGNED default NULL," +
		"`Class3` smallint(5) UNSIGNED default NULL," +
		"`Level3` tinyint(3) UNSIGNED default NULL," +
		"`Class4` smallint(5) UNSIGNED default NULL," +
		"`Level4` tinyint(3) UNSIGNED default NULL," +
		"`STR` tinyint(3) UNSIGNED NOT NULL," +
		"`CON` tinyint(3) UNSIGNED NOT NULL," +
		"`DEX` tinyint(3) UNSIGNED NOT NULL," +
		"`INT` tinyint(3) UNSIGNED NOT NULL," +
		"`WIS` tinyint(3) UNSIGNED NOT NULL," +
		"`CHA` tinyint(3) UNSIGNED NOT NULL," +
		"`Location` varchar(128) default NULL," +
		"`Damage` smallint(5) UNSIGNED NOT NULL default 0," +
		"`Deaths` smallint(5) UNSIGNED NOT NULL default 0," +
		"`Status` int(10) UNSIGNED NOT NULL default 0," +
		"`IsOnline` bool NOT NULL default false," +
		"`IsDeleted` bool NOT NULL default false," +
		"`IsPlayable` bool NOT NULL default true," +
		"`NaturalHair` varchar(128) default NULL," +
		"`CharacterFileName` varchar(36) DEFAULT NULL COMMENT 'BIC name (36 from 32-byte BIC resref name, plus .bic.)'," +
		"`RetiredStatus` TINYINT( 3 ) NOT NULL DEFAULT 0 COMMENT '0 is default, 1 is temp retired, 2 is back from retirement, 3 is retired definitely'," +
                "`AcrVersion` varchar(8) default NULL," +
		"PRIMARY KEY (`ID`), UNIQUE KEY (`PlayerID`, `Name`)" +
	") ENGINE=MyISAM DEFAULT CHARSET=latin1;");
	
	ACR_SQLQuery("CREATE TABLE IF NOT EXISTS `heedspwdata` (" +
		"`player` varchar(64) NOT NULL," +
		"`tag` varchar(64) NOT NULL," +
		"`name` varchar(64) NOT NULL," +
		"`val` varchar(128) default NULL," +
		"`expire` mediumint(8) UNSIGNED NOT NULL default 0," +
		"`index` int(10) UNSIGNED NOT NULL AUTO_INCREMENT," +
		"PRIMARY KEY (`index`)" +
	") ENGINE=MyISAM DEFAULT CHARSET=latin1;");
	
	ACR_SQLQuery("CREATE TABLE IF NOT EXISTS `ipaddress` (" +
		"`ID` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT," +
		"`CDKey` varchar(8) NOT NULL," +
		"`IPAddress` varchar(256) NOT NULL," +
		"`IsBanned` bool NOT NULL default false," +
		"PRIMARY KEY (`ID`), UNIQUE KEY (`CDKey`, `IPAddress`)" +
	") ENGINE=MyISAM DEFAULT CHARSET=latin1;");

	ACR_SQLQuery("CREATE TABLE IF NOT EXISTS `item_properties` (" +
		"`ID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT," +
		"`ItemProperty` smallint(5) NOT NULL," +
		"`Description` varchar(128) default NULL," +
		"`IsIllegal` bool NOT NULL default 0," +
		"PRIMARY KEY  (`ID`), UNIQUE KEY (`ItemProperty`)" +
	") ENGINE=MyISAM DEFAULT CHARSET=latin1;");

	//
	// This table is never used and the creation statement isn't valid either.
	//

	/*
	ACR_SQLQuery("CREATE TABLE IF NOT EXISTS `login_stats` (" +         
		"`ID` int(11) NOT NULL AUTO_INCREMENT," +
		"`ServerID` tinyint(5) NOT NULL," +
		"`CharacterID` mediumint(9) default NULL," +
		"`Duration` int(11) default NULL," +
		"`LoginDate` timestamp default NULL," +
		"`LogoutDate` timestamp default NULL," +
		"PRIMARY KEY  (`ID`)" +
	") ENGINE=MyISAM DEFAULT CHARSET=latin1;");
	*/

	ACR_SQLQuery("CREATE TABLE IF NOT EXISTS `logs` (" +         
		"`ID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT," +
		"`ServerID` smallint(5) UNSIGNED NOT NULL," +
		"`CharacterID` mediumint(8) UNSIGNED default NULL," +
		"`DMCharacterID` mediumint(8) UNSIGNED default NULL," +
		"`Event` varchar(32) NOT NULL," +
		"`Description` varchar(128) default NULL," +
		"`Date` timestamp NOT NULL default CURRENT_TIMESTAMP," +
		"PRIMARY KEY  (`ID`)" +
	") ENGINE=MyISAM DEFAULT CHARSET=latin1;");
	
	ACR_SQLQuery("CREATE TABLE IF NOT EXISTS `offline_messages` (" +
		"`ID` int(11) NOT NULL AUTO_INCREMENT," +
		"`CharacterID` int(10) unsigned DEFAULT NULL," +
		"`Date` timestamp NOT NULL default CURRENT_TIMESTAMP," +
		"`Date_IG` varchar(64) DEFAULT NULL," +
		"`Message` varchar(256) DEFAULT NULL," +
		"PRIMARY KEY (`ID`)," +
		"UNIQUE KEY `id_UNIQUE` (`ID`)" +
	") ENGINE=MyISAM DEFAULT CHARSET=latin1;" );

	ACR_SQLQuery("CREATE TABLE IF NOT EXISTS `players` (" +
		"`ID` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT," +
		"`CDKey` varchar(8) NOT NULL," +
		"`Name` varchar(32) NOT NULL," +
		"`FirstLogin` datetime," +
		"`LastLogin` datetime," +
		"`LastLogout` datetime," +
		"`Logins` int(10) UNSIGNED NOT NULL default 0," +
		"`TimeOnline` mediumint(8) UNSIGNED NOT NULL default 0," +
		"`IsDM` bool NOT NULL default false," +
		"`IsBanned` bool NOT NULL default false," +
		"`Is18Plus` bool NOT NULL default false," +
		"`IsMember` bool NOT NULL default true," +
		"PRIMARY KEY (`ID`), UNIQUE KEY(`CDKey`, `Name`)" +
	") ENGINE=MyISAM DEFAULT CHARSET=latin1;");

	ACR_SQLQuery("CREATE TABLE IF NOT EXISTS `pwdata` (" +
		"`Name` varchar(64) NOT NULL," +
		"`Tag` varchar(64) NOT NULL," +
		"`Key` varchar(64) NOT NULL," +
		"`Value` varchar(128) default NULL," +
		"`Expiration` smallint(5) UNSIGNED NOT NULL default 0," +
		"`Last` timestamp NOT NULL default CURRENT_TIMESTAMP," +
		"PRIMARY KEY (`Name`, `Tag`, `Key`)" +
	") ENGINE=MyISAM DEFAULT CHARSET=latin1;");

	ACR_SQLQuery("CREATE TABLE IF NOT EXISTS `pwobject` (" +
		"`Name` varchar(64) NOT NULL," +
		"`Tag` varchar(64) NOT NULL," +
		"`Key` varchar(64) NOT NULL," +
		"`Value` varchar(128) default NULL," +
		"`Expiration` smallint(5) UNSIGNED NOT NULL default 0," +
		"`Last` timestamp NOT NULL default CURRENT_TIMESTAMP," +
		"PRIMARY KEY (`Name`, `Tag`, `Key`)" +
	") ENGINE=MyISAM DEFAULT CHARSET=latin1;");

    ACR_SQLQuery("CREATE TABLE IF NOT EXISTS `quests` (" +
        "`ID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT," +
		"`ServerID` smallint(5) UNSIGNED NOT NULL," +
        "`CharacterID` mediumint(8) UNSIGNED NOT NULL," +
        "`PlotID` varchar(32) NOT NULL DEFAULT ''," +
        "`PlotState` varchar(4) NOT NULL DEFAULT ''," +
        "PRIMARY KEY (`ID`), UNIQUE KEY(`ServerID`, `CharacterID`, `PlotID`)" +
    ") ENGINE=MyISAM DEFAULT CHARSET=latin1;");

	ACR_SQLQuery("CREATE TABLE IF NOT EXISTS `servers` (" +
		"`ID` smallint(5) UNSIGNED NOT NULL," +
		"`Name` varchar(64) NOT NULL," +
		"`IPAddress` varchar(21) NOT NULL," +
		"`IsPublic` bool NOT NULL default true," +
		"`MachineName` varchar(256) NULL DEFAULT NULL COMMENT 'Machine name that host computer must have to start server (or else NULL for any machine), for recovery use.'" +
		"PRIMARY KEY (`ID`)" +
	") ENGINE=MyISAM DEFAULT CHARSET=latin1;");

	ACR_SQLQuery("CREATE TABLE IF NOT EXISTS `spelltrack` (" +
        "`ID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT," +
        "`CharacterID` mediumint(11) UNSIGNED NOT NULL," +
        "`Class` smallint(5) NOT NULL," +
        "`Uses` varchar(128) default NULL," +
        "PRIMARY KEY (`ID`), UNIQUE KEY (`CharacterID`, `Class`)" +
    ") ENGINE=MyISAM DEFAULT CHARSET=latin1;");

	ACR_SQLQuery("CREATE TABLE IF NOT EXISTS `server_admins` (" +
		"`ServerID` smallint(5) UNSIGNED NOT NULL," +
		"`PlayerID` mediumint(8) UNSIGNED NOT NULL," +
		"PRIMARY KEY (`ServerID`, `PlayerID`)" +
	") ENGINE=MyISAM DEFAULT CHARSET=latin1;");
		
	ACR_SQLQuery("CREATE TABLE IF NOT EXISTS `character_script_variables` (" +
		"`CharacterID` mediumint(11) UNSIGNED NOT NULL," +
		"`Tag` varchar(64) NOT NULL," +
		"`VariableName` varchar(64) NOT NULL," +
		"`VariableType` tinyint(3) UNSIGNED NOT NULL," +
		"`VariableValue` varchar(256) NOT NULL," +
		"PRIMARY KEY (`CharacterID`, `Tag`, `VariableName`), INDEX (`CharacterID`, `Tag`, `VariableName`)" +
	") ENGINE=MyISAM DEFAULT CHARSET=latin1;");

	ACR_SQLQuery("CREATE TABLE IF NOT EXISTS `config` (" +
		"`variable` varchar(25) NOT NULL," +
		"`value` varchar(255) NOT NULL," +
		"PRIMARY KEY (`variable`)" +
	") ENGINE=MyISAM DEFAULT CHARSET=latin1;");

	ACR_SQLQuery("CREATE TABLE IF NOT EXISTS `alfa_gsids` (" +
		"`uid` int(10) NOT NULL," +
		"`gsid` varchar(32) NOT NULL," +
		"PRIMARY KEY (`uid`)" +
	") ENGINE=InnoDB DEFAULT CHARSET=latin1;");

	ACR_SQLQuery("CREATE TABLE IF NOT EXISTS `stat_counters` (" +
		"`Name` varchar(64) NOT NULL," +
		"`Value` int(10) NOT NULL," +
		"`LastUpdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP," +
		"PRIMARY KEY (`Name`)" +
	") ENGINE=InnoDB DEFAULT CHARSET=latin1;");

	ACR_SQLQuery("CREATE TABLE IF NOT EXISTS `server_ipc_events` ( " +
		"`ID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, " +
		"`SourcePlayerID` mediumint(8) UNSIGNED NOT NULL, " +
		"`SourceServerID` smallint(5) UNSIGNED NOT NULL, " +
		"`DestinationPlayerID` mediumint(8) UNSIGNED NOT NULL, " +
		"`DestinationServerID` smallint(5) UNSIGNED NOT NULL, " +
		"`EventType` smallint(5) UNSIGNED NOT NULL, " +
		" `EventText` varchar(256) NOT NULL, " +
		"PRIMARY KEY(`ID`), UNIQUE KEY(`ID`, `DestinationServerID`), INDEX(`DestinationServerID`) " +
	") ENGINE=MyISAM DEFAULT CHARSET=latin1;");

	ACR_SQLQuery("CREATE TABLE IF NOT EXISTS `server_resource_files` ( " +
		"`ServerID` smallint(5) UNSIGNED NOT NULL, " +
		"`ResourceFileName` varchar(36) NOT NULL, " +
		"PRIMARY KEY(`ServerID`, `ResourceFileName`), INDEX (`ServerID`) " +
	") ENGINE=MyISAM DEFAULT CHARSET=latin1;");

	ACR_SQLQuery("CREATE TABLE IF NOT EXISTS `content_patch_files` (" +
		"`FileName` varchar(256) NOT NULL," +
		"`Location` varchar(32) NOT NULL," +
		"`HakVersion` varchar(16) NOT NULL," +
		"`Checksum` varchar(32) NOT NULL," +
		"`RecompileModule` bool NOT NULL default false," +
		"PRIMARY KEY (`FileName`, `Location`, `HakVersion`), INDEX (`HakVersion`)" +
	") ENGINE=InnoDB DEFAULT CHARSET=latin1;");

	ACR_SQLQuery("CREATE TABLE IF NOT EXISTS `content_download_config` (" +
		"`Hash` varchar(256) NOT NULL," +
		"`DownloadHash` varchar(256) NOT NULL," +
		"`Name` varchar(256) NOT NULL," +
		"`DLSize` varchar(256) NOT NULL," +
		"`Size` varchar(256) NOT NULL," +
		"PRIMARY KEY (`Name`), INDEX (`Name`)" +
	") ENGINE=InnoDB DEFAULT CHARSET=latin1;");

	ACR_SQLQuery("CREATE TABLE IF NOT EXISTS `irc_gateway_messages` (" +
		"`ID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, " +
		"`GatewayID` int(10) UNSIGNED NOT NULL," +
		"`SourceCharacterID` mediumint(8) UNSIGNED NOT NULL," +
		"`Recipient` varchar(51) NOT NULL," +
		"`Message` varchar(256) NOT NULL," +
		"PRIMARY KEY (`ID`), INDEX(`GatewayID`)" +
	") ENGINE=InnoDB DEFAULT CHARSET=latin1;");


	ACR_SQLQuery("CREATE TABLE IF NOT EXISTS `bulletin_board` (" +
		"`ID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, " +
		"`BoardID` int(10) UNSIGNED NOT NULL, " +
		"`Category` tinyint(1) UNSIGNED NOT NULL," +
		"`CharacterID` mediumint(11) UNSIGNED NOT NULL," +
		"`Title` varchar(32) NOT NULL," +
		"`Message` varchar(256) NOT NULL," +
		"`Parent` int(10) UNSIGNED, " +
		"PRIMARY KEY (`ID`), INDEX(`Parent`, `CharacterID`, `BoardID`)" +
	") ENGINE=InnoDB DEFAULT CHARSET=latin1;");
}

void ACR_ResetDatabase()  {

    object oMod = GetModule();
	string sModName = GetName(oMod);
	_SetDatabaseControlFlags(_GetDatabaseControlFlags() | _ACR_SQL_DBCTRL_DATABASE_OFFLINE);
    AssignCommand(oMod, SpeakString("Connection to the SQL database has been lost.   Please log out now.", TALKVOLUME_SHOUT));
	DelayCommand(90.0, AssignCommand(oMod, SpeakString("Server will drop you in 30 seconds.", TALKVOLUME_SHOUT)));
	DelayCommand(120.0, _ResetServer());
}


void ACR_AdjustTables() {
	// check to see if Characters has the Class4/Level4 columns
	ACR_SQLQuery("SHOW COLUMNS from `characters` WHERE Field = 'Class4';");
	if (ACR_SQLFetch() != SQL_SUCCESS) {
		// couldn't find the column, add both
		ACR_SQLQuery("ALTER TABLE `characters` ADD COLUMN `Class4` smallint(5) UNSIGNED default NULL AFTER `Level3`, ADD COLUMN `Level4` tinyint(3) UNSIGNED default NULL AFTER `Class4`;");	
		WriteTimestampedLogEntry("ACR_DB_PERSIST: Characters table altered to accomodate 4th class/level.");
	} else {
		WriteTimestampedLogEntry("ACR_DB_PERSIST: Class4 column existence confirmed.");
	}

	// check to see if the Characters table has the CharacterFileName column
	ACR_SQLQuery("SHOW COLUMNS from `characters` WHERE Field = 'CharacterFileName';");
	if (ACR_SQLFetch() != SQL_SUCCESS) {
		ACR_SQLQuery("ALTER TABLE `characters` ADD `CharacterFileName` varchar(36) NULL DEFAULT NULL COMMENT 'BIC name (36 from 32-byte BIC resref name, plus .bic.)'");
		WriteTimestampedLogEntry("ACR_DB_PERSIST: Characters table altered to record BIC filename.");
	} else {
		WriteTimestampedLogEntry("ACR_DB_PERSIST: CharacterFileName column existance confirmed.");
	}

	// check to see if the Characters table has the RetiredStatus column
	ACR_SQLQuery("SHOW COLUMNS from `characters` WHERE Field = 'RetiredStatus';");
	if (ACR_SQLFetch() != SQL_SUCCESS) {
		ACR_SQLQuery("ALTER TABLE `characters` ADD `RetiredStatus` TINYINT( 3 ) NOT NULL DEFAULT 0 COMMENT '0 is default, 1 is temp retired, 2 is back from retirement, 3 is retired definitely'");
		WriteTimestampedLogEntry("ACR_DB_PERSIST: Characters table altered to record retirement status.");
	} else {
		WriteTimestampedLogEntry("ACR_DB_PERSIST: RetiredStatus column existance confirmed.");
	}

	// check to see if the Characters table has the AcrVersion column
	ACR_SQLQuery("SHOW COLUMNS from `characters` WHERE Field = 'AcrVersion';");
	if (ACR_SQLFetch() != SQL_SUCCESS) {
		ACR_SQLQuery("ALTER TABLE `characters` ADD `AcrVersion` varchar( 8 ) default NULL;");
		WriteTimestampedLogEntry("ACR_DB_PERSIST: Characters table altered to record acr version.");
	} else {
		WriteTimestampedLogEntry("ACR_DB_PERSIST: AcrVersion column existance confirmed.");
	}

	// check to see if the Players table has the Is18Plus column
	ACR_SQLQuery("SHOW COLUMNS from `players` WHERE Field = 'Is18Plus';");
	if (ACR_SQLFetch() != SQL_SUCCESS) {
		ACR_SQLQuery("ALTER TABLE `players` ADD `Is18Plus` bool NOT NULL default false");
		WriteTimestampedLogEntry("ACR_DB_PERSIST: Players table altered to record 18Plus status.");
	} else {
		WriteTimestampedLogEntry("ACR_DB_PERSIST: Is18Plus column existance confirmed.");
	}
	
	// check to see if the Players table has the IsMember column
	ACR_SQLQuery("SHOW COLUMNS from `players` WHERE Field = 'IsMember';");
	if (ACR_SQLFetch() != SQL_SUCCESS) {
		ACR_SQLQuery("ALTER TABLE `players` ADD `IsMember` bool NOT NULL default true");
		WriteTimestampedLogEntry("ACR_DB_PERSIST: Players table altered to record IsMember status.");
	} else {
		WriteTimestampedLogEntry("ACR_DB_PERSIST: IsMember column existance confirmed.");
	}

	// check to see if content_patch_files table has the RecompileModule column
	ACR_SQLQuery("SHOW COLUMNS from `content_patch_files` WHERE Field = 'RecompileModule';");
	if (ACR_SQLFetch() != SQL_SUCCESS) {
		ACR_SQLQuery("ALTER TABLE `content_patch_files` ADD `RecompileModule` bool NOT NULL default false");
		WriteTimestampedLogEntry("ACR_DB_PERSIST: content_patch_files table altered to record RecompileModule.");
	} else {
		WriteTimestampedLogEntry("ACR_DB_PERSIST: RecompileModule column existance confirmed.");
	}
	
	// check to see if the Servers table has the IsPublic column
	ACR_SQLQuery("SHOW COLUMNS from `servers` WHERE Field = 'IsPublic';");
	if (ACR_SQLFetch() != SQL_SUCCESS) {
		ACR_SQLQuery("ALTER TABLE `servers` ADD `IsPublic` bool NOT NULL default true");
		WriteTimestampedLogEntry("ACR_DB_PERSIST: Servers table altered to record IsPublic status.");
	} else {
		WriteTimestampedLogEntry("ACR_DB_PERSIST: IsPublic column existance confirmed.");
	}
	
	// check to see if the Servers table has the MachineName column
	ACR_SQLQuery("SHOW COLUMNS from `servers` WHERE Field = 'MachineName';");
	if (ACR_SQLFetch() != SQL_SUCCESS) {
		ACR_SQLQuery("ALTER TABLE `servers` ADD `MachineName` varchar(256) NULL DEFAULT NULL COMMENT 'Machine name that host computer must have to start server (or else NULL for any machine), for recovery use.'");
		WriteTimestampedLogEntry("ACR_DB_PERSIST: Servers table altered to record MachineName.");
	} else {
		WriteTimestampedLogEntry("ACR_DB_PERSIST: MachineName column existance confirmed.");
	}
}


void ACR_DBPersistOnIncomingPlayer(object oPC)
{
	// Dump the cache for the player as their data may have been written to on
	// another server.
	_ClearACRPersistCache(oPC);

	// If we already have pending new queries, there's nothing to do.
	if ((_GetDatabaseControlFlags() & _ACR_SQL_DBCTRL_ASYNC_PENDING) != 0)
		return;

	// Begin unspooling any uncommitted queries if we need to
	if (GetQueueLength(oPC, _ACR_DB_SQL_QUEUE) != 0)
		_RunQueryQueue(FALSE);
}

void ACR_DBPersistOnOutgoingPlayer(object oPC)
{
	// Flush all uncommitted queries
	_FlushQueryQueue(oPC);

	// Check whether there is more than the departing player on the server
	GetFirstPC();

	if (GetNextPC() != OBJECT_INVALID)
		return;

	// The last player is leaving, flush the queue on the module as we might be
	// shutting down cleanly.  Note that we could try and combine this with the
	// above query but it's the last player anyway, so it's not a performance
	// path.
	_FlushQueryQueue(GetModule());
}

int ACR_GetUTCTime()
{
	ACR_SQLQuery("SELECT UNIX_TIMESTAMP();");

	if (ACR_SQLFetch() != SQL_SUCCESS)
		return 0;
	else
		return StringToInt(ACR_SQLGetData(0));
}

int ACR_GetModuleStartTime()
{
	object Module = GetModule();
	int StartTime = GetLocalInt(Module, _ACR_DB_SQL_SERVER_BOOT_TIME_MOD_VAR);

	// If the cache isn't yet valid, then make it so.  The first call is during
	// module initialization.

	if (StartTime == 0)
	{
		StartTime = ACR_GetUTCTime();
		SetLocalInt(Module, _ACR_DB_SQL_SERVER_BOOT_TIME_MOD_VAR, StartTime);
	}

	return StartTime;
}

void _ResetServer() {
	// Variables.
	object oModule			= GetModule( );
	object oPC				= GetFirstPC( );		
	// Boot all the players from the server first, so they don't timeout.
	while( GetIsPC( oPC ) ){
		// Boot this player.
		_FlushQueryQueue( oPC );
		BootPC( oPC );
		// Get the next player in our server player list.
		oPC = GetNextPC( );
	}
	// Reset the server in 1 round's time.
	_FlushQueryQueue( GetModule( ) );
	DelayCommand( 6.0, NWNXSetString( "SYSTEM", "RESET", "", 0, "" ) );	
	return;
}

// We could have more logic here, like longer delays if PCs
// are in combat.
void _ServiceAsyncQueries()
{
	int MaxServiced;
	object Module = GetModule();
	int TotalQueueLength = _GetTotalQueuedQueryCount(OBJECT_INVALID);

	// If we have nothing in the queue then stop the continuation, so that the
	// next write happens quickly
	if (TotalQueueLength == 0)
	{
		_SetDatabaseControlFlags(_GetDatabaseControlFlags() & (~_ACR_SQL_DBCTRL_ASYNC_PENDING));
		return;
	}

	MaxServiced = _CalculateTargetMaxQueriesServiced(TotalQueueLength);

	// Run the queues for each of the objects that have queues
	_ExecuteQueryQueues(MaxServiced, Module, OBJECT_INVALID, FALSE);

	// Start the next continuation up

	if (OBJECT_SELF != Module)
		AssignCommand(Module, DelayCommand(_ACR_DB_SQL_ASYNC_WRITE_HEARTBEAT_DELAY, _ServiceAsyncQueries()));
	else
		DelayCommand(_ACR_DB_SQL_ASYNC_WRITE_HEARTBEAT_DELAY, _ServiceAsyncQueries());
}

int _ServiceAsyncQueriesForQueue(object oQueuedTo, int nFlags, int nMaxServiced, object oModule)
{
	int i;
	int Length;
	int MaxQueries;
	int QueriesLeft;
	string Query;

	Length = GetQueueLength(oQueuedTo, _ACR_DB_SQL_QUEUE);
	
	// Nothing to do if the queue spool is empty
	if (Length == 0)
		return 0;

	// If we're to flush the entire queue, do it, otherwise perform a gated 
	// flush of the queue
	if ((nFlags & _ACR_SQL_SAQ_FLUSHALL) != 0)
	{
		MaxQueries = Length;
	}
	else
	{
		MaxQueries = nMaxServiced;

		if (MaxQueries > Length)
			MaxQueries = Length;
	}

	// If this is a per-player queue and the database connection has failed, do
	// not try and issue queries but instead keep them in the local queue
	if ((oQueuedTo != oModule) &&
		(Length != 0) &&
		(MaxQueries != 0) &&
		((_GetDatabaseControlFlags() & _ACR_SQL_DBCTRL_DATABASE_OFFLINE) != 0))
	{
		WriteTimestampedLogEntry("acr_db_persist_i!_ServiceAsyncQueriesForQueue(): Database access is disabled, spooling queries for " +
			GetName(oQueuedTo) + "...");
		MaxQueries = 0;
	}

	Query = GetLocalString(oModule, _ACR_DB_SQL_PENDING_QUERY_VAR);

	// Drain the queue
	for (i = 0; i < MaxQueries; i += 1)
	{
		Query = Query + PopQueueString(oQueuedTo, _ACR_DB_SQL_QUEUE) + ";";

		if (GetStringLength(Query) > _ACR_SQL_QUERY_MAX_LEN)
		{
			_SQLQueryInternal(Query);
			Query = "";
		}
	}

	if (GetStringLength(Query) > 0)
	{
		SetLocalString(oModule, _ACR_DB_SQL_PENDING_QUERY_VAR, Query);
	}
	else
	{
		DeleteLocalString(oModule, _ACR_DB_SQL_PENDING_QUERY_VAR);
	}

	return i;
}

void _FlushQueryQueue(object oQueueObject)
{
	// Only players may own their own query queue as we do not have rundown for
	// other objects to flush the queue cleanly
	if (!GetIsPC(oQueueObject))
		oQueueObject = GetModule();

	if (GetQueueLength(oQueueObject, _ACR_DB_SQL_QUEUE) == 0)
		return;

	_ExecuteQueryQueues(_GetTotalQueuedQueryCount(oQueueObject), GetModule(), oQueueObject, FALSE);
}

void ACR_FlushQueryQueue(object oQueueObject)
{
	_FlushQueryQueue(oQueueObject);
}

string ACR_GetServerAddressFromDatabase()
{
	ACR_SQLQuery("SELECT host from information_schema.processlist where id = connection_id()");

	if (ACR_SQLFetch() == SQL_SUCCESS)
	{
		string Address = ACR_SQLGetData(0);
		int i;

		i = FindSubString(Address, ":");

		if (i != -1)
			Address = GetStringLeft(Address, i);

		WriteTimestampedLogEntry("ACR_GetServerAddressFromDatabase(): Detected server external address as " + Address + ".");

		return Address;
	}
	else
	{
		WriteTimestampedLogEntry("ACR_GetServerAddressFromDatabase(): Failed to determine server external address!");

		return "";
	}
}

int ACR_LoadObjectVariablesFromPersistStore(object Obj, object PCObject, string DatabaseTag)
{
	int LoadedVariables = 0;

	if (!GetIsPC(PCObject))
	{
		WriteTimestampedLogEntry("ACR_LoadObjectVariablesFromPersistStore(" + GetName(Obj) + ", " + GetName(PCObject) + ", " + DatabaseTag + "): Cannot load variables associated with a non-PC object.");
		return FALSE;
	}

	// Flush the query queue for the object and spin up a query to fetch the
	// object data from the database.  Flushing the queue is necessary in case
	// we had a pending ACR_StoreObjectVariablesToPersistStore() for the same
	// PC and tag waiting to be written out.
	ACR_FlushQueryQueue(PCObject);
	ACR_SQLQuery(
		"SELECT `VariableType`, `VariableName`, `VariableValue` " +
		"FROM `character_script_variables` " +
		"WHERE `CharacterID` = " + IntToString(ACR_GetCharacterID(PCObject)) + " " +
		"AND `Tag` = '" + ACR_SQLEncodeSpecialChars(DatabaseTag) + "'");

	while (ACR_SQLFetch() == SQL_SUCCESS)
	{
		int VariableType = StringToInt(ACR_SQLGetData(0));
		string VariableName = ACR_SQLGetData(1);
		string VariableValue = ACR_SQLGetData(2);

		LoadedVariables += 1;

		switch (VariableType)
		{

		case VARIABLE_TYPE_INT:
			SetLocalInt(Obj, VariableName, StringToInt(VariableValue));
			break;

		case VARIABLE_TYPE_FLOAT:
			SetLocalFloat(Obj, VariableName, StringToFloat(VariableValue));
			break;

		case VARIABLE_TYPE_STRING:
			SetLocalString(Obj, VariableName, VariableValue);
			break;

		case VARIABLE_TYPE_DWORD:
			WriteTimestampedLogEntry("ACR_LoadObjectVariablesFromPersistStore(" + GetName(Obj) + ", " + GetName(PCObject) + ", " + DatabaseTag + "): Cannot restore a variable of type Object.");
			break;

		case VARIABLE_TYPE_LOCATION:
			SetLocalLocation(Obj, VariableName, ACR_StringToLocation(VariableValue));
			break;

		}
	}

	return (LoadedVariables != 0);
}

void ACR_SaveObjectVariablesToPersistStore(object Obj, object PCObject, string DatabaseTag)
{
	string CharID;
	string EscapedTag;
	int VariableCount;
	int VariableType;
	string VariableValue;
	int i;

	if (!GetIsPC(PCObject))
	{
		WriteTimestampedLogEntry("ACR_StoreObjectVariablesToPersistStore(" + GetName(Obj) + ", " + GetName(PCObject) + ", " + DatabaseTag + "): Cannot save variables associated with a non-PC object.");
		return;
	}

	CharID = IntToString(ACR_GetCharacterID(PCObject));
	EscapedTag = ACR_SQLEncodeSpecialChars(DatabaseTag);
	VariableCount = GetVariableCount(Obj);

	//
	// Delete existing variable contents and update.
	//

	ACR_AsyncSQLQueryEx(
		"DELETE FROM `character_script_variables` WHERE `CharacterID` = " + CharID + " AND `Tag` = '" + EscapedTag + "'",
		PCObject,
		ACR_QUERY_LOW_PRIORITY);

	for (i = 0; i < VariableCount; i += 1)
	{
		VariableType = GetVariableType(Obj, i);

		switch (VariableType)
		{

		case VARIABLE_TYPE_INT:
			VariableValue = IntToString(GetVariableValueInt(Obj, i));
			break;

		case VARIABLE_TYPE_FLOAT:
			VariableValue = FloatToString(GetVariableValueFloat(Obj, i));
			break;

		case VARIABLE_TYPE_STRING:
			VariableValue = GetVariableValueString(Obj, i);
			break;

		case VARIABLE_TYPE_DWORD:
			WriteTimestampedLogEntry("ACR_StoreObjectVariablesToPersistStore(" + GetName(Obj) + ", " + GetName(PCObject) + ", " + DatabaseTag + "): Cannot save a variable of type Object.");
			continue;

		case VARIABLE_TYPE_LOCATION:
			VariableValue = ACR_LocationToString(GetVariableValueLocation(Obj, i));
			break;

		}

		ACR_AsyncSQLQueryEx(
			"INSERT INTO `character_script_variables` " +
				"(`CharacterID`, `Tag`, `VariableName`, `VariableType`, `VariableValue`) " +
			"VALUES " +
				"(" + CharID + ", '" + EscapedTag + "', '" + ACR_SQLEncodeSpecialChars(GetVariableName(Obj, i)) + "', " + IntToString(VariableType) + ", '" + ACR_SQLEncodeSpecialChars(VariableValue) + "')",
			PCObject,
			ACR_QUERY_LOW_PRIORITY);
	}
}

void _ExecuteQueryQueues(int nMaxServiced, object oModule, object oExtraQueueObject, int bAccumulate)
{
	int Processed;
	string Query;
	object QueueObject;

	// Run the module's queue
	Processed = _ServiceAsyncQueriesForQueue(oModule, 0, nMaxServiced, oModule);
	nMaxServiced -= Processed;

	if (oModule == oExtraQueueObject)
		oExtraQueueObject = OBJECT_INVALID;

	// If we still have more queue data to run
	if (nMaxServiced != 0)
	{
		// Run the queue for each other object with a queue, i.e. each player
		//for (QueueObject = GetFirstPC(); QueueObject != OBJECT_INVALID; QueueObject = GetNextPC())
		QueueObject = GetFirstPC();
		while(QueueObject != OBJECT_INVALID)
		{
			Processed = _ServiceAsyncQueriesForQueue(QueueObject, 0, nMaxServiced, oModule);
			nMaxServiced -= Processed;

			if (QueueObject == oExtraQueueObject)
				oExtraQueueObject = OBJECT_INVALID;

			// If we haven't anything in the queue anymore, exit early
			if (nMaxServiced == 0)
				break;
			
			QueueObject = GetNextPC();
		}
	}

	// If we didn't observe the extra queue object in the list, handle it now.
	if (oExtraQueueObject != OBJECT_INVALID)
	{
		Processed = _ServiceAsyncQueriesForQueue(oExtraQueueObject, 0, nMaxServiced, oModule);
		nMaxServiced -= Processed;

		oExtraQueueObject = OBJECT_INVALID;
	}

	// If the caller is assuming responsibility for the final write, stop here.
	if (bAccumulate)
		return;

	// Finally, execute the combined query if there was one
	Query = GetLocalString(oModule, _ACR_DB_SQL_PENDING_QUERY_VAR);

	if (GetStringLength(Query) > 0)
	{
		_SQLQueryInternal(Query);
		DeleteLocalString(oModule, _ACR_DB_SQL_PENDING_QUERY_VAR);
	}
}

void _RunQueryQueue(int bDeferred)
{
	// Record that we will have a continuation pending
	_SetDatabaseControlFlags(_GetDatabaseControlFlags() | _ACR_SQL_DBCTRL_ASYNC_PENDING);

	// Run the queue down when the script returns control all the way, which
	// lets us collect any additional queries that the script might add to the
	// queue right away (unless we are in deferred mode).

	if (bDeferred)
		AssignCommand(GetModule(), DelayCommand(_ACR_DB_SQL_ASYNC_WRITE_HEARTBEAT_DELAY, _ServiceAsyncQueries()));
	else
		AssignCommand(GetModule(), _ServiceAsyncQueries());
}

int _GetTotalQueuedQueryCount(object oExtraQueueObject)
{
	object Module;
	object Player;
	int QueryCount;

	Module = GetModule();
	QueryCount = GetQueueLength(Module, _ACR_DB_SQL_QUEUE);

	if (oExtraQueueObject == Module)
		oExtraQueueObject = OBJECT_INVALID;

	//for (Player = GetFirstPC(); Player != OBJECT_INVALID; Player = GetNextPC())
	Player = GetFirstPC();
	while(Player != OBJECT_INVALID)
	{
		QueryCount += GetQueueLength(Player, _ACR_DB_SQL_QUEUE);

		if (oExtraQueueObject == Player)
			oExtraQueueObject = OBJECT_INVALID;

		Player = GetNextPC();
	}

	// Tally the extra queue object if it wasn't already accounted for.
	if (oExtraQueueObject != OBJECT_INVALID)
	{
		QueryCount += GetQueueLength(oExtraQueueObject, _ACR_DB_SQL_QUEUE);

		oExtraQueueObject = OBJECT_INVALID;
	}

	return QueryCount;
}

int _GetDatabaseControlFlags()
{
	return GetLocalInt(GetModule(), _ACR_DB_CONTROL_FLAGS_VAR);
}

void _SetDatabaseControlFlags(int nControlFlags)
{
	SetLocalInt(GetModule(), _ACR_DB_CONTROL_FLAGS_VAR, nControlFlags);
}

void _MaintainACRPersistCache(object oCacheObject, string sTag)
{
	int CacheModuleStartTime = GetLocalInt(oCacheObject, _ACR_DB_SQL_SERVER_BOOT_TIME_VAR);
	int ModuleStartTime = ACR_GetModuleStartTime();
	int VarCount;

	// If the cache belongs to this module start cycle then the cache is valid.
	if (ModuleStartTime == CacheModuleStartTime)
		return;

	// We have to clear out all of the persist cache data on the object, if any
	// existed (i.e. saved item).  Then we'll need to update the cache from the
	// database.

	_ClearACRPersistCache(oCacheObject);

	// Now retrieve all of the persist items from the database and cache them.
	VarCount = 0;

	ACR_SQLQuery("SELECT `Key`, Value FROM pwdata WHERE Name='" + ACR_SQLEncodeSpecialChars(GetName(oCacheObject)) + "' AND Tag='" + sTag + "'");
	while (ACR_SQLFetch() == SQL_SUCCESS)
	{
		VarCount += 1;
		SetLocalString(oCacheObject,
			_ACR_DB_SQL_PERSIST_CACHE_VAR_PREFIX + ACR_SQLGetData(0),
			ACR_SQLGetData(1));
	}

	// If we returned the query successfully and there were rows, mark the cache
	// as valid.
	//
	// N.B.  It would be legal to have a cache with no rows as valid but we
	//       cannot distinguish between failed queries and no rows with the SQL
	//       API that NWNX4 provides.
	if (VarCount != 0)
		SetLocalInt(oCacheObject, _ACR_DB_SQL_SERVER_BOOT_TIME_VAR, ModuleStartTime);
}

void _ClearACRPersistCache(object oCacheObject)
{
	int i;
	int VarCount;

	// We have to clear out all of the persist cache data on the object, if any
	// existed (i.e. saved item).  Then we'll need to update the cache from the
	// database.

	VarCount = GetVariableCount(oCacheObject);

	for (i = VarCount; i != 0; i -= 1)
	{
		string VarName = GetVariableName(oCacheObject, i-1);
		string VarPrefix = GetSubString(VarName, 0, _ACR_DB_SQL_PERSIST_CACHE_VAR_PREFIX_LEN);

		// Skip past the variable if it is not one of the cache ones.
		if (VarPrefix != _ACR_DB_SQL_PERSIST_CACHE_VAR_PREFIX)
			continue;

		// Delete the variable and stay on the current variable position as it
		// will point to the next variable now.  It's an old cache.
		DeleteLocalString(oCacheObject, VarName);
		i += 1;
	}

	DeleteLocalInt(oCacheObject, _ACR_DB_SQL_SERVER_BOOT_TIME_VAR);
}

int _CalculateTargetMaxQueriesServiced(int nTotalQueueLength)
{
	int MaxServiced;

	// Figure out how many queue entries we want to dispatch this time around
	MaxServiced = 18 + nTotalQueueLength / 5;

	if (MaxServiced > nTotalQueueLength)
		MaxServiced = nTotalQueueLength;
	// Your average packet size is about 4k, minus 20B for the header. The queries are about 150B each,
	// so we might be able to fit 26 in a packet.

	return MaxServiced;
}

void _SQLQueryInternal(string sSQL)
{
#if ACR_DB_PERSIST_USE_CLR_SQL_PROVIDER
	ACR_QueryDatabaseConnection(SCRIPT_STANDARD_DATABASE_CONNECTION_ID, sSQL);
#else
	NWNXSetString("SQL", "EXEC", sSQL, 0, "");
#endif
}

int _SQLQueryReturnsValues(string sSQL)
{
	string Verb = GetStringUpperCase(GetSubString(sSQL, 0, 6));

	if (Verb == "INSERT" || Verb == "UPDATE" || Verb == "CREATE")
		return FALSE;
	else
		return TRUE;
}


#endif
