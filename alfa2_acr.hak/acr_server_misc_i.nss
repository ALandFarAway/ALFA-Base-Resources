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
const int ACR_SERVER_MISC_ESCAPE_STRING_DATABASE_CONNECTION = 10;

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

//! Make a raw call to the support script.
//!  - Command: Supplies the command to request (e.g. ACR_SERVER_MISC_EXECUTE_UPDATER_SCRIPT).
//!  - P0: Supplies the first command-specific parameter.
//!  - P1: Supplies the second command-specific parameter.
//!  - P2: Supplies the third command-specific parameter.
//!  - P3: Supplies the fourth command-specific parameter.
//!  - P4: Supplies the fifth command-specific parameter.
//!  - ObjectSelf: Supplies the OBJECT_SELF to run the script on.
//!  - Returns: The command-specific return code is returned.
int ACR_CallServerMiscScript(int Command, int P0, int P1, string P2, string P3, object P4, object ObjectSelf = OBJECT_SELF);

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
		TemplateArea) == FALSE)
	{
		return OBJECT_INVALID;
	}

	object Module = GetModule();
	object InstancedArea = GetLocalObject(Module, ACR_SERVER_MISC_OBJECT_RETVAL_VAR);
	DeleteLocalObject(Module, ACR_SERVER_MISC_OBJECT_RETVAL_VAR);

	return InstancedArea;
}

void ACR_InternalReleaseAreaInstance(object InstancedArea)
{
	ACR_CallServerMiscScript(
		ACR_SERVER_MISC_RELEASE_AREA_INSTANCE,
		0,
		0,
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
		OBJECT_INVALID))
	{
		return "";
	}

	object Module = GetModule();
	string Data = GetLocalString(Module, ACR_SERVER_MISC_STRING_RETVAL_VAR);
	DeleteLocalString(Module, ACR_SERVER_MISC_STRING_RETVAL_VAR);

	return Data;
}

int ACR_GetAffectedRowCountDatabaseConnection(int ConnectionHandle)
{
	return ACR_CallServerMiscScript(
		ACR_SERVER_MISC_GET_AFFECTED_ROW_COUNT_DATABASE_CONNECTION,
		ConnectionHandle,
		0,
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
		OBJECT_INVALID))
	{
		return "";
	}

	object Module = GetModule();
	string Data = GetLocalString(Module, ACR_SERVER_MISC_STRING_RETVAL_VAR);
	DeleteLocalString(Module, ACR_SERVER_MISC_STRING_RETVAL_VAR);

	return Data;
}

int ACR_CallServerMiscScript(int Command, int P0, int P1, string P2, string P3, object P4, object ObjectSelf = OBJECT_SELF)
{
	AddScriptParameterInt(Command);
	AddScriptParameterInt(P0);
	AddScriptParameterInt(P1);
	AddScriptParameterString(P2);
	AddScriptParameterString(P3);
	AddScriptParameterObject(P4);

	return ExecuteScriptEnhanced(ACR_SERVER_MISC_SUPPORT_SCRIPT, ObjectSelf, TRUE);
}

