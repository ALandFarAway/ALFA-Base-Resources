////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_server_misc_i
//    $Revision:: 1          $ current version of the file
//        $Date:: 2012-01-08#$ date the file was created or modified
//       Author : Basilica
//
//    Var Prefix: SERVER_MISC
//  Dependencies: NWNX, MYSQL, CLRSCRIPT(acr_servermisc)
//
//  Description
//  This file contains logic for interfacing with the miscellaneous support
//  C# script (acr_servermisc).
//
//  Revision History
//  2012/01/08  Basilica    - Created.
//  2012/01/19  Basilica    - Added area instancing support.
//  2012/06/06  Basilica    - Added auxiliary database connectivity support.
//  2012/09/10  Paazin      - Added limited C# Dictionary access.
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// The server misc support script name.
const string ACR_SERVER_MISC_SUPPORT_SCRIPT                  = "acr_servermisc";

// The local variable (type object) used to return data from the support script.
const string ACR_SERVER_MISC_OBJECT_RETVAL_VAR               = "ACR_SERVER_MISC_RETURN_OBJECT";

// The local variable (type string) used to return data from the support script.
const string ACR_SERVER_MISC_STRING_RETVAL_VAR               = "ACR_SERVER_MISC_RETURN_STRING";

// Flags for database connections, used for ACR_CreateDatabaseConnection.

// Enable debug and diagnostic logging (including query logging) for the
// connection object.
const int SCRIPT_DATABASE_CONNECTION_DEBUG = 0x00000001;

// Commands for the server misc C# script:

// This command runs the updater script for the server, if one is defined.
const int ACR_SERVER_MISC_EXECUTE_UPDATER_SCRIPT             = 0;

// This command creates an instanced area.
const int ACR_SERVER_MISC_CREATE_AREA_INSTANCE               = 1;

// This command releases an instanced area.
const int ACR_SERVER_MISC_RELEASE_AREA_INSTANCE              = 2;

// This command runs a PowerShell scriptlet.
const int ACR_SERVER_MISC_RUN_POWERSHELL_SCRIPTLET           = 3;

// This command creates a database connection.
const int ACR_SERVER_MISC_CREATE_DATABASE_CONNECTION         = 4;

// This command destroys a database connection.
const int ACR_SERVER_MISC_DESTROY_DATABASE_CONNECTION        = 5;

// This command executes a SQL query.
const int ACR_SERVER_MISC_QUERY_DATABASE_CONNECTION          = 6;

// This command fetches a SQL query rowset.
const int ACR_SERVER_MISC_FETCH_DATABASE_CONNECTION          = 7;

// This command gets data from a column in a SQL query rowset.
const int ACR_SERVER_MISC_GET_COLUMN_DATABASE_CONNECTION     = 8;

// This command gets the affected row count from a SQL query rowset.
const int ACR_SERVER_MISC_GET_AFFECTED_ROW_COUNT_DATABASE_CONNECTION = 9;

// This command escapes a string for safe use within a SQL query.
const int ACR_SERVER_MISC_ESCAPE_STRING_DATABASE_CONNECTION  = 10;

// This command obtains a stack trace of the current thread.
const int ACR_SERVER_MISC_GET_STACK_TRACE                    = 11;

// This command sets a Dictionary Key-Value pair.
const int ACR_SERVER_MISC_SET_DICTIONARY_VALUE               = 12;

// This command gets a Dictionary Key-Value pair.
const int ACR_SERVER_MISC_GET_DICTIONARY_VALUE               = 13;

// This command sets the Dictionary Iterator to the First Key-Value pair.
const int ACR_SERVER_MISC_FIRST_ITERATE_DICTIONARY           = 14;

// This command sets the Dictionary Iterator to the Next Key-Value pair.
const int ACR_SERVER_MISC_NEXT_ITERATE_DICTIONARY            = 15;

// This command deletes a Key-Value pair from a Dictionary.
const int ACR_SERVER_MISC_DELETE_DICTIONARY_KEY              = 16;

// This command empties a Dictionary.
const int ACR_SERVER_MISC_CLEAR_DICTIONARY                   = 17;

// This command gets a salted MD5 of a string using a salt that is random,
// per server start.
const int ACR_SERVER_MISC_GET_SALTED_MD5                     = 18;

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! Execute the server's updater script, if one is defined.
//!  - Returns: TRUE if the updater was launched.
int ACR_ExecuteServerUpdaterScript();

//! Set a Dictionary's Key-Value pair.  Doing so resets any active iterator for
//  the dictionary.
//!  - DictionaryID: Dictionary to reference
//!  - Key: Key-Value pair to reference
//!  - Value: String Value to set for Key-Value pair
void ACR_DictionarySet(string DictionaryID, string Key, string Value);

//! Get a Dictionary's Key-Value pair
//!  - DictionaryID: Dictionary to reference
//!  - Key: Key-Value pair to reference
//!  - Returns: String Value of Key-Value pair or empty string
//              upon error
string ACR_DictionaryGet(string DictionaryID, string Key);

//! Get a Dictionary's first Key, sorted alphanumerically, and then set the
//  dictionary iterator to that element.
//!  - DictionaryID: Dictionary to reference
//!  - Returns: String Key of current location of Iterator or
//              empty string upon error/end of list
string ACR_DictionaryIterateFirst(string DictionaryID);

//! Get a Dictionary's next Key, sorted alphanumerically, and then set the
//  dictionary iterator to that element.
//!  - DictionaryID: Dictionary to reference
//!  - Returns: String Key of current location of Iterator or
//              empty string upon error/end of list
string ACR_DictionaryIterateNext(string DictionaryID);

//! Delete a Key-Value pair from a Dictionary by Key.  Doing so resets any
//  active iterator in the dictionary.
//!  - DictionaryID: Dictionary to reference
//!  - Key: Key-Value pair to reference
void ACR_DictionaryDeleteKey(string DictionaryID, string Key);

//! Clear a dictionary (deleting its contents entirely).  Doing so  resets any
//  active iterator in the dictionary.
//!  - DictionaryID: Dictionary to reference
void ACR_DictionaryClear(string DictionaryID);

//! Create an instanced area.  If an available instance in the free pool can be
//  found, it will be reused.
//!  - TemplateArea: Supplies the area that serves as the template for the new
//                   instanced area.
//!  - Returns: The area instance, else OBJECT_INVALID on failure.
object ACR_InternalCreateAreaInstance(object TemplateArea);

//! Release an instanced area.  It will be put back onto the free list of the
//  area supports free list pooling, otherwise the area is deleted.
//!  - InstancedArea: Supplies the area instance to release.
void ACR_InternalReleaseAreaInstance(object InstancedArea);

//! Run a PowerShell scriptlet.  $s is passed as a parameter pointing to a
//  CLRScriptBase, and $OBJECT_INVALID and $OBJECT_SELF are passed to the
//  script as well.
//!  - Script: Supplies the script text to run.
//!  - ObjectSelf: Supplies the OBJECT_SELF value, and the object to whom
//                 results (if any) should be sent.  If OBJECT_INVALID, then
//                 results are sent to the server log file instead.
//!  - Returns: TRUE if the script ran without an exception.
int ACR_RunPowerShellScriptlet(string Script, object ObjectSelf = OBJECT_SELF);

//! Create a database connection object.
//!  - ConnectionString: Supplies the database connection string.
//!  - Flags: Supplies connection flags.  Legal values are drawn from the
//              SCRIPT_DATABASE_CONNECTION_* family of constants.
//!  - Returns: A database connection handle, or 0 on failure.
//              The handle is used for subsequent database requests.  It
//              remains valid until explicitly destroyed via a call to the
//              ACR_DestroyDatabaseConnection function.
//
//              The handle can be saved as a module local variable, or in any
//              other convenient location where an int can be stored.
int ACR_CreateDatabaseConnection(string ConnectionString, int Flags = 0);

//! Delete a database connection created by ACR_CreateDatabaseConnection.
//!  - ConnectionHandle: Supplies the connection handle that was returned by a
//                       prior call to ACR_CreateDatabaseConnection.
//!  - Returns: TRUE on success.
int ACR_DestroyDatabaseConnection(int ConnectionHandle);

//! Execute a query.  The function is similar to ACR_SQLQuery.
//!  - ConnectionHandle: Supplies the connection handle that was returned by a
//                       prior call to ACR_CreateDatabaseConnection.
//!  - Query: Supplies the query string.
//!  - Returns: TRUE on success.
int ACR_QueryDatabaseConnection(int ConnectionHandle, string Query);

//! Fetch a rowset from the database.  The function is similar to ACR_SQLFetch.
//!  - ConnectionHandle: Supplies the connection handle that was returned by a
//                       prior call to ACR_CreateDatabaseConnection.
//!  - Returns: TRUE on success.
int ACR_FetchDatabaseConnection(int ConnectionHandle);

//! Get a column from a rowset in a database query.  The function is similar to
//  ACR_SQLGetData.
//!  - ConnectionHandle: Supplies the connection handle that was returned by a
//                       prior call to ACR_CreateDatabaseConnection.
//!  - ColumnIndex: Supplies the column index (zero for the first column).
//!  - Returns: The column value, or "" on failure.
string ACR_GetColumnDatabaseConnection(int ConnectionHandle, int ColumnIndex = 0);

//! Get the affected row count in a database query rowset.  The function is
//  similar to ACR_SQLGetAffectedRows.
//!  - ConnectionHandle: Supplies the connection handle that was returned by a
//                       prior call to ACR_CreateDatabaseConnection.
//!  - Returns: The count of affected rows.
int ACR_GetAffectedRowCountDatabaseConnection(int ConnectionHandle);

//! Escape a string for use in a database query.  The function is similar to
//  ACR_SQLEncodeSpecialChars.
//!  - ConnectionHandle: Supplies the connection handle that was returned by a
//                       prior call to ACR_CreateDatabaseConnection.
//!  - String: Supplies the string to escape.
//!  - Returns: The escaped string is returned.
string ACR_EscapeStringDatabaseConnection(int ConnectionHandle, string String);

//! Obtain a stack trace for use in debug logging.  The stack trace includes
//  the frames for the call into ACR_ServerMisc itself.
//!  - Returns: The stack trace string.
string ACR_GetStackTrace();

//! Obtain a salted MD5 of a given string.  The salt is a random value that is
//  generated on server startup.  Useful for hashed values that are only used
//  while a server is running.
//!  - Returns: The salted MD5 checksum as a hex string.
string ACR_GetSaltedMD5(string s);


//! Make a raw call to the support script.
//!  - Command: Supplies the command to request (e.g. ACR_SERVER_MISC_EXECUTE_UPDATER_SCRIPT).
//!  - P0: Supplies the first command-specific parameter.
//!  - P1: Supplies the second command-specific parameter.
//!  - P2: Supplies the third command-specific parameter.
//!  - P3: Supplies the fourth command-specific parameter.
//!  - P4: Supplies the fifth command-specific parameter.
//!  - P5: Supplies the sixth command-specific parameter.
//!  - ObjectSelf: Supplies the OBJECT_SELF to run the script on.
//!  - Returns: The command-specific return code is returned.
int ACR_CallServerMiscScript(int Command, int P0, int P1, string P2, string P3, string P4, object P5, object ObjectSelf = OBJECT_SELF);

//! Get the server misc script return string.  The return value is cleared on
//  return.
//!  - Returns: The return value of the script.
string ACR__GetServerMiscReturnString();

//! Get the server misc script return object.  The return value is cleared on
//   return.
//!  - Returns: The return value of the script.
object ACR__GetServerMiscReturnObject();

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

int ACR_ExecuteServerUpdaterScript()
{
	return ACR_CallServerMiscScript(
		ACR_SERVER_MISC_EXECUTE_UPDATER_SCRIPT,
		0,
		0,
		"",
		"",
		"",
		OBJECT_INVALID);
}

void ACR_DictionarySet(string DictionaryID, string Key, string Value)
{
	ACR_CallServerMiscScript(
		ACR_SERVER_MISC_SET_DICTIONARY_VALUE,
		0,
		0,
		DictionaryID,
		Key,
		Value,
		OBJECT_INVALID);
}

string ACR_DictionaryGet(string DictionaryID, string Key)
{
	if (!ACR_CallServerMiscScript(
		ACR_SERVER_MISC_GET_DICTIONARY_VALUE,
		0,
		0,
		DictionaryID,
		Key,
		"",
		OBJECT_INVALID))
	{
		return "";
	}

	return ACR__GetServerMiscReturnString();
}

string ACR_DictionaryIterateFirst(string DictionaryID)
{
	if (!ACR_CallServerMiscScript(
		ACR_SERVER_MISC_FIRST_ITERATE_DICTIONARY,
		0,
		0,
		DictionaryID,
		"",
		"",
		OBJECT_INVALID))
	{
		return "";
	}

	return ACR__GetServerMiscReturnString();
}

string ACR_DictionaryIterateNext(string DictionaryID)
{
	if (!ACR_CallServerMiscScript(
		ACR_SERVER_MISC_NEXT_ITERATE_DICTIONARY,
		0,
		0,
		DictionaryID,
		"",
		"",
		OBJECT_INVALID))
	{
		return "";
	}

	return ACR__GetServerMiscReturnString();
}

void ACR_DictionaryDeleteKey(string DictionaryID, string Key)
{
	ACR_CallServerMiscScript(
		ACR_SERVER_MISC_DELETE_DICTIONARY_KEY,
		0,
		0,
		DictionaryID,
		Key,
		"",
		OBJECT_INVALID);
}

void ACR_DictionaryClear(string DictionaryID)
{
	ACR_CallServerMiscScript(
		ACR_SERVER_MISC_CLEAR_DICTIONARY,
		0,
		0,
		DictionaryID,
		"",
		"",
		OBJECT_INVALID);
}

object ACR_InternalCreateAreaInstance(object TemplateArea)
{
	if (ACR_CallServerMiscScript(
		ACR_SERVER_MISC_CREATE_AREA_INSTANCE,
		0,
		0,
		"",
		"",
		"",
		TemplateArea) == FALSE)
	{
		return OBJECT_INVALID;
	}

	return ACR__GetServerMiscReturnObject();
}

void ACR_InternalReleaseAreaInstance(object InstancedArea)
{
	ACR_CallServerMiscScript(
		ACR_SERVER_MISC_RELEASE_AREA_INSTANCE,
		0,
		0,
		"",
		"",
		"",
		InstancedArea);
}

int ACR_RunPowerShellScriptlet(string Script, object ObjectSelf = OBJECT_SELF)
{
	return ACR_CallServerMiscScript(
		ACR_SERVER_MISC_RUN_POWERSHELL_SCRIPTLET,
		0,
		0,
		Script,
		"",
		"",
		ObjectSelf,
		ObjectSelf);
}

int ACR_CreateDatabaseConnection(string ConnectionString, int Flags = 0)
{
	return ACR_CallServerMiscScript(
		ACR_SERVER_MISC_CREATE_DATABASE_CONNECTION,
		Flags,
		0,
		ConnectionString,
		"",
		"",
		OBJECT_INVALID);
}

int ACR_DestroyDatabaseConnection(int ConnectionHandle)
{
	return ACR_CallServerMiscScript(
		ACR_SERVER_MISC_DESTROY_DATABASE_CONNECTION,
		ConnectionHandle,
		0,
		"",
		"",
		"",
		OBJECT_INVALID);
}

int ACR_QueryDatabaseConnection(int ConnectionHandle, string Query)
{
	return ACR_CallServerMiscScript(
		ACR_SERVER_MISC_QUERY_DATABASE_CONNECTION,
		ConnectionHandle,
		0,
		Query,
		"",
		"",
		OBJECT_INVALID);
}

int ACR_FetchDatabaseConnection(int ConnectionHandle)
{
	return ACR_CallServerMiscScript(
		ACR_SERVER_MISC_FETCH_DATABASE_CONNECTION,
		ConnectionHandle,
		0,
		"",
		"",
		"",
		OBJECT_INVALID);
}

string ACR_GetColumnDatabaseConnection(int ConnectionHandle, int ColumnIndex = 0)
{
	if (!ACR_CallServerMiscScript(
		ACR_SERVER_MISC_GET_COLUMN_DATABASE_CONNECTION,
		ConnectionHandle,
		ColumnIndex,
		"",
		"",
		"",
		OBJECT_INVALID))
	{
		return "";
	}

	return ACR__GetServerMiscReturnString();
}

int ACR_GetAffectedRowCountDatabaseConnection(int ConnectionHandle)
{
	return ACR_CallServerMiscScript(
		ACR_SERVER_MISC_GET_AFFECTED_ROW_COUNT_DATABASE_CONNECTION,
		ConnectionHandle,
		0,
		"",
		"",
		"",
		OBJECT_INVALID);
}

string ACR_EscapeStringDatabaseConnection(int ConnectionHandle, string String)
{
	if (!ACR_CallServerMiscScript(
		ACR_SERVER_MISC_ESCAPE_STRING_DATABASE_CONNECTION,
		ConnectionHandle,
		0,
		String,
		"",
		"",
		OBJECT_INVALID))
	{
		return "";
	}

	return ACR__GetServerMiscReturnString();
}

string ACR_GetStackTrace()
{
	if (!ACR_CallServerMiscScript(
		ACR_SERVER_MISC_GET_STACK_TRACE,
		0,
		0,
		"",
		"",
		"",
		OBJECT_INVALID))
	{
		return "";
	}

	return ACR__GetServerMiscReturnString();
}

string ACR_GetSaltedMD5(string s)
{
	if (!ACR_CallServerMiscScript(
		ACR_SERVER_MISC_GET_SALTED_MD5,
		0,
		0,
		s,
		"",
		"",
		OBJECT_INVALID))
	{
		return "";
	}

	return ACR__GetServerMiscReturnString();
}

int ACR_CallServerMiscScript(int Command, int P0, int P1, string P2, string P3, string P4, object P5, object ObjectSelf = OBJECT_SELF)
{
	AddScriptParameterInt(Command);
	AddScriptParameterInt(P0);
	AddScriptParameterInt(P1);
	AddScriptParameterString(P2);
	AddScriptParameterString(P3);
	AddScriptParameterString(P4);
	AddScriptParameterObject(P5);

	return ExecuteScriptEnhanced(ACR_SERVER_MISC_SUPPORT_SCRIPT, ObjectSelf, TRUE);
}

string ACR__GetServerMiscReturnString()
{
	object Module = GetModule();
	string Data = GetLocalString(Module, ACR_SERVER_MISC_STRING_RETVAL_VAR);

	DeleteLocalString(Module, ACR_SERVER_MISC_STRING_RETVAL_VAR);

	return Data;
}

object ACR__GetServerMiscReturnObject()
{
	object Module = GetModule();
	object Data = GetLocalObject(Module, ACR_SERVER_MISC_OBJECT_RETVAL_VAR);

	DeleteLocalObject(Module, ACR_SERVER_MISC_OBJECT_RETVAL_VAR);

	return Data;
}
