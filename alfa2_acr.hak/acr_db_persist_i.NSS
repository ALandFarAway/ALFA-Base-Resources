////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_db_persist_i
//    $Revision:: 609        $ current version of the file
//        $Date:: 2009-10-11#$ date the file was created or modified
//       Author : Cipher
//
//    Var Prefix: N/A
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
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#include "nwnx_include"
#include "acf_settings_i"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! Return status of SQL queries
const int SQL_ERROR = 0;
const int SQL_SUCCESS = 1;

//! Character ID for optimizing database access
const string ACR_CID = "ACR_CID";

//! CD Key to facilitate accecss even on exit events
const string ACR_CDKEY = "ACR_CDKEY";

//! local into to track timestamp failures
const string ACR_DB_FAILURES = "ACR_DB_FAILURES";

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

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

//! Passes the reset command to the NWNx4 system plugin, taken from nwnx_system.nss
// Authors  : Ingmar Stieger (Papillon)
// Modified : 08/25/07 (kfw) : Added more useful error messages.
void _ResetServer();

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void ACR_SQLQuery(string sSQL)
{
	NWNXSetString("SQL", "EXEC", sSQL, 0, "");
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

    // insert the record or update the values if it already exists
    ACR_SQLQuery("INSERT INTO pwdata (Name, Tag, `Key`, Value, Expiration) VALUES ('"
	 + ACR_SQLEncodeSpecialChars(GetName(oObject)) + "','" + sTag + "','" + ACR_SQLEncodeSpecialChars(sVarName) + "', '"
     + sValue + "', " + IntToString(iExpiration) + ") ON DUPLICATE KEY UPDATE Value='" + sValue + "', Expiration=" + IntToString(iExpiration) + ", Last=NOW()");
}

string ACR_GetPersistentString(object oObject, string sVarName)
{
    // PC's don't have tags so use CD key instead
    string sTag = (GetIsPC(oObject)) ? ACR_GetPCPublicCDKey(oObject) : GetTag(oObject);
	// if this is a corpse placeable, drop the CharID suffix to allow it to read the player variable.
    if ((GetResRef(oObject) == "abr_pl_co_so_pccorpse") || (GetResRef(oObject) == "abr_it_mi_body")) { sTag = GetStringLeft(sTag, 8); }
    // retrieve the record from the database
    ACR_SQLQuery("SELECT Value FROM pwdata WHERE Name='" + ACR_SQLEncodeSpecialChars(GetName(oObject)) + "' and Tag='" + sTag + "' and `Key`='" + ACR_SQLEncodeSpecialChars(sVarName) + "'");

    return (ACR_SQLFetch() == SQL_SUCCESS) ? ACR_SQLGetData(0) : "";
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
	
    // retrieve the record from the database
    ACR_SQLQuery("DELETE FROM pwdata WHERE Name='" + ACR_SQLEncodeSpecialChars(GetName(oObject)) + "' and Tag='" + sTag + "' and `Key`='" + ACR_SQLEncodeSpecialChars(sVarName) + "'");
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

void _ResetServer() {
	// Variables.
	object oModule			= GetModule( );
	object oPC				= GetFirstPC( );		
	// Boot all the players from the server first, so they don't timeout.
	while( GetIsPC( oPC ) ){
		// Boot this player.
		BootPC( oPC );
		// Get the next player in our server player list.
		oPC = GetNextPC( );
	}	
	// Reset the server in 1 round's time.
	DelayCommand( 6.0, NWNXSetString( "SYSTEM", "RESET", "", 0, "" ) );	
	return;
}

