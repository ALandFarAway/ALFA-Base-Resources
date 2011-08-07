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
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "nwnx_include"
#include "acr_queue_i"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! Return status of SQL queries
const int SQL_ERROR = 0;
const int SQL_SUCCESS = 1;

//! Character ID for optimizing database access
const string ACR_CID = "ACR_CID";

//! Status cache variable name.
const string ACR_PLAYERSTATUS_CACHE_VAR = "ACR_PLAYERSTATUS_CACHE";

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

//! Length of persist cache string
const int _ACR_DB_SQL_PERSIST_CACHE_VAR_PREFIX_LEN = 17;

//! Flags for _ServiceAsyncQueriesForObject
const int _ACR_SQL_SAQ_FLUSHALL = 0x00000001;    // flush the whole queue 

//! Flags for _GetDatabaseControlFlags / _SetDatabaseControlFlags
const int _ACR_SQL_DBCTRL_DATABASE_OFFLINE = 0x00000001;  // database link down
const int _ACR_SQL_DBCTRL_ASYNC_PENDING    = 0x00000002;  // have async queries

//! Maximum length of a SQL query

const int _ACR_SQL_QUERY_MAX_LEN = 16384;

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
//!  - Returns: Nothing
void ACR_AsyncSQLQueryEx(string sSQL, object oQueueTo);

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

//! This function stores a persistent string
//!  - oObject: The object for which the data is being stored
//!  - sVarName: The unique variable name
//!  - sValue: The value to record 
//! Optional parameters:
//!  - iExpiration: The number of days the persistent variable should be kept in database (default: 0=forever)
void ACR_SetPersistentString(object oObject, string sVarName, string sValue, int iExpiration = 0);

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
//!  - Returns: nothing
void ACR_SetCharacterID(object oPC, int nID);

//! This function retrieves the database ID of the character
//!  - oPC: player whose character ID to retrieve
//!  - Returns: oPC's character ID
int ACR_GetCharacterID(object oPC);

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
void _RunQueryQueue();

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
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void ACR_StartAsyncService() {
	// Cache the start time if it hasn't yet been set.
	ACR_GetModuleStartTime();
	// If we already have pending new queries, there's nothing to do.
	if ((_GetDatabaseControlFlags() & _ACR_SQL_DBCTRL_ASYNC_PENDING) != 0)
		return;

	object Module = GetModule();

	// Begin unspooling any uncommitted queries if we need to
	if (GetQueueLength(Module, _ACR_DB_SQL_QUEUE) != 0)
		_RunQueryQueue();
}

void ACR_AsyncSQLQuery(string sSQL) {
	ACR_AsyncSQLQueryEx(sSQL, GetModule());
}

void ACR_AsyncSQLQueryEx(string sSQL, object oQueueTo)
{
	int PrevQueueLength;

	// Only players may own their own query queue as we do not have rundown for
	// other objects to flush the queue cleanly
	if (!GetIsPC(oQueueTo))
		oQueueTo = GetModule();

	PushQueueString(oQueueTo, _ACR_DB_SQL_QUEUE, sSQL);

	// If we don't have a run queue pending, kick one off now
	if ((_GetDatabaseControlFlags() & _ACR_SQL_DBCTRL_ASYNC_PENDING) == 0)
		_RunQueryQueue();
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
    return NWNXGetInt("SQL", "FETCH", mode, 0);
}

string ACR_SQLGetData(int nCol = 0)
{
	return NWNXGetString("SQL", "GETDATA", "", nCol);
}

int ACR_SQLGetAffectedRows()
{
    return NWNXGetInt("SQL", "GET AFFECTED ROWS", "", 0);
}

string ACR_SQLEncodeSpecialChars(string sString)
{
    return NWNXGetString("SQL", "GET ESCAPE STRING", sString, 0);
}

void ACR_SetPersistentString(object oObject, string sVarName, string sValue, int iExpiration = 0)
{
    // PC's don't have tags so use CD key instead
    string sTag = (GetIsPC(oObject)) ? ACR_GetPCPublicCDKey(oObject) : GetTag(oObject);
	// if this is a corpse placeable, drop the CharID suffix to allow it to read the player variable.
    if ((GetResRef(oObject) == "abr_pl_co_so_pccorpse") || (GetResRef(oObject) == "abr_it_mi_body")) { sTag = GetStringLeft(sTag, 8); }

    _MaintainACRPersistCache(oObject, sTag);
    SetLocalString(oObject, _ACR_DB_SQL_PERSIST_CACHE_VAR_PREFIX + sVarName, sValue);
    // insert the record or update the values if it already exists
    ACR_AsyncSQLQueryEx("INSERT INTO pwdata (Name, Tag, `Key`, Value, Expiration) VALUES ('"
	 + ACR_SQLEncodeSpecialChars(GetName(oObject)) + "','" + sTag + "','" + ACR_SQLEncodeSpecialChars(sVarName) + "', '"
     + sValue + "', " + IntToString(iExpiration) + ") ON DUPLICATE KEY UPDATE Value='" + sValue + "', Expiration=" + IntToString(iExpiration) + ", Last=NOW()",
	  oObject);
}

string ACR_GetPersistentString(object oObject, string sVarName)
{
    // PC's don't have tags so use CD key instead
    string sTag = (GetIsPC(oObject)) ? ACR_GetPCPublicCDKey(oObject) : GetTag(oObject);
	// if this is a corpse placeable, drop the CharID suffix to allow it to read the player variable.
    if ((GetResRef(oObject) == "abr_pl_co_so_pccorpse") || (GetResRef(oObject) == "abr_it_mi_body")) { sTag = GetStringLeft(sTag, 8); }
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
    if ((GetResRef(oObject) == "abr_pl_co_so_pccorpse") || (GetResRef(oObject) == "abr_it_mi_body")) { sTag = GetStringLeft(sTag, 8); }

    // generate the SQL - insert the record or update the values if it already exists
    string sSQL = "INSERT INTO pwobject (Name, Tag, `Key`, Value, Expiration) VALUES ('"
	 + ACR_SQLEncodeSpecialChars(GetName(oObject)) + "','" + sTag + "','" + ACR_SQLEncodeSpecialChars(sVarName) + "',%s,"
     + IntToString(iExpiration) + ") ON DUPLICATE KEY UPDATE Value=%s, Expiration=" + IntToString(iExpiration);
	 // flush queue for the object so that any pending writes are visible
	 // TODO:  This can and should go away when we start caching these values
	 //        on the object itself.  There is no reason to hit the database
	 //        each time for them.
	 _FlushQueryQueue(oObject);

    SetLocalString(GetModule(), "NWNX!SQL!SETSCORCOSQL", sSQL);
    //StoreCampaignObject("NWNX", "-", oItem);
    StoreCampaignObject(sDatabaseName, sVarName, oItem);
}

object ACR_GetPersistentObject(object oObject, string sVarName, string sDatabaseName)
{
    // PC's don't have tags so use CD key instead
    string sTag = (GetIsPC(oObject)) ? ACR_GetPCPublicCDKey(oObject) : GetTag(oObject);
	
	// if this is a corpse placeable, drop the CharID suffix to allow it to read the player variable.
    if ((GetResRef(oObject) == "abr_pl_co_so_pccorpse") || (GetResRef(oObject) == "abr_it_mi_body")) { sTag = GetStringLeft(sTag, 8); }

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
    if ((GetResRef(oObject) == "abr_pl_co_so_pccorpse") || (GetResRef(oObject) == "abr_it_mi_body")) { sTag = GetStringLeft(sTag, 8); }
    _MaintainACRPersistCache(oObject, sTag);
    DeleteLocalString(oObject, _ACR_DB_SQL_PERSIST_CACHE_VAR_PREFIX + sVarName);
    // retrieve the record from the database
    ACR_AsyncSQLQueryEx("DELETE FROM pwdata WHERE Name='" + ACR_SQLEncodeSpecialChars(GetName(oObject)) + "' and Tag='" + sTag + "' and `Key`='" + ACR_SQLEncodeSpecialChars(sVarName) + "'", oObject);
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

void ACR_SetCharacterID(object oPC, int nID)
{
	SetLocalInt(oPC, ACR_CID, nID);

	ACR_SQLQuery("SELECT Status FROM characters WHERE id=" + IntToString(nID));

	if (ACR_SQLFetch() == SQL_SUCCESS)
		SetLocalInt(oPC, ACR_PLAYERSTATUS_CACHE_VAR, StringToInt(ACR_SQLGetData(0)));
}

int ACR_GetCharacterID(object oPC)
{
	return GetLocalInt(oPC, ACR_CID);
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
		"`IPAddress` varchar(16) NOT NULL," +
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

	ACR_SQLQuery("CREATE TABLE IF NOT EXISTS `logs` (" +         
		"`ID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT," +
		"`ServerID` smallint(5) UNSIGNED NOT NULL," +
		"`CharacterID` mediumint(8) UNSIGNED default NULL," +
		"`Event` varchar(32) NOT NULL," +
		"`Description` varchar(128) default NULL," +
		"`Date` timestamp NOT NULL default CURRENT_TIMESTAMP," +
		"PRIMARY KEY  (`ID`)" +
	") ENGINE=MyISAM DEFAULT CHARSET=latin1;");

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
		"PRIMARY KEY (`ID`)" +
	") ENGINE=MyISAM DEFAULT CHARSET=latin1;");

	ACR_SQLQuery("CREATE TABLE IF NOT EXISTS `spelltrack` (" +
        "`ID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT," +
        "`CharacterID` mediumint(11) UNSIGNED NOT NULL," +
        "`Class` smallint(5) NOT NULL," +
        "`Uses` varchar(128) default NULL," +
        "PRIMARY KEY (`ID`), UNIQUE KEY (`CharacterID`, `Class`)" +
    ") ENGINE=MyISAM DEFAULT CHARSET=latin1;");
		
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
	return;
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
		_RunQueryQueue();
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

void _RunQueryQueue()
{
	// Record that we will have a continuation pending
	_SetDatabaseControlFlags(_GetDatabaseControlFlags() | _ACR_SQL_DBCTRL_ASYNC_PENDING);

	// Run the queue down when the script returns control all the way, which
	// lets us collect any additional queries that the script might add to the
	// queue right away
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
	NWNXSetString("SQL", "EXEC", sSQL, 0, "");
}

int _SQLQueryReturnsValues(string sSQL)
{
	string Verb = GetStringUpperCase(GetSubString(sSQL, 0, 6));

	if (Verb == "INSERT" || Verb == "UPDATE" || Verb == "CREATE")
		return FALSE;
	else
		return TRUE;
}

