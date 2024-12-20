﻿//
// This module contains logic for interfacing with the ALFA database system.
// 

using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Runtime.InteropServices;
using System.Reflection;
using System.Reflection.Emit;
using CLRScriptFramework;
using ALFA.Shared;
using NWScript;
using NWScript.ManagedInterfaceLayer.NWScriptManagedInterface;

using NWEffect = NWScript.NWScriptEngineStructure0;
using NWEvent = NWScript.NWScriptEngineStructure1;
using NWLocation = NWScript.NWScriptEngineStructure2;
using NWTalent = NWScript.NWScriptEngineStructure3;
using NWItemProperty = NWScript.NWScriptEngineStructure4;

namespace ALFA
{
    /// <summary>
    /// This interface encapsulates the raw ALFA ACR Database API.
    /// </summary>
    public interface IALFADatabase
    {
        /// <summary>
        /// This routine escapes characters for a SQL query.
        /// </summary>
        /// <param name="s">Supplies the string to escape.</param>
        /// <returns>The escaped string is returned.</returns>
        string ACR_SQLEncodeSpecialChars(string s);

        /// <summary>
        /// This routine fetches the next rowset from the database.
        /// </summary>
        /// <returns>Returns true if the query succeeded.</returns>
        bool ACR_SQLFetch();

        /// <summary>
        /// This routine returns the first column of data from the current SQL
        /// rowset.
        /// </summary>
        /// <returns>The column data is returned</returns>
        string ACR_SQLGetData();

        /// <summary>
        /// This routine returns the specified column of data from the current
        /// SQL rowset.
        /// </summary>
        /// <param name="ColumnIndex">Supplies the zero-based column index to
        /// retrieve.</param>
        /// <returns>The column data is returned.</returns>
        string ACR_SQLGetData(int ColumnIndex);

        /// <summary>
        /// This routine returns the number of rows affected by a query.
        /// </summary>
        /// <returns>The row count is returned.</returns>
        int ACR_SQLGetAffectedRows();

        /// <summary>
        /// This routine performs a synchronous SQL query.  If there were
        /// pending asynchronous queries in the queue, the pending queries are
        /// drained first.
        /// </summary>
        /// <param name="SQL">Supplies the SQL query text to execute.</param>
        void ACR_SQLQuery(string SQL);

        /// <summary>
        /// This routine performs a synchronous SQL query.  If there were
        /// pending asynchronous queries in the queue, the pending queries are
        /// drained first.
        /// 
        /// The query must not return any results.
        /// </summary>
        /// <param name="SQL">Supplies the SQL query text to execute.</param>
        void ACR_SQLExecute(string SQL);

        /// <summary>
        /// Increment a global tracking statistic counter stored in the
        /// database (if statistic tracking was enabled).
        /// </summary>
        /// <param name="Statistic">Supplies the counter name.</param>
        void ACR_IncrementStatistic(string Statistic);
    }

    /// <summary>
    /// Control flags for ACR_AsyncSQLQueryEx.
    /// </summary>
    public enum ACR_QUERY_FLAGS : uint
    {
        /// <summary>
        /// No flags set.
        /// </summary>
        None = 0x00000000,

        /// <summary>
        /// Don't immediately initiate a query for an async query.
        /// </summary>
        ACR_QUERY_LOW_PRIORITY = 0x000000001,
    }

    /// <summary>
    /// This class encapsulates database access for ALFA CLR scripts.  Unlike
    /// the ad-hoc ALFA.MySQLDatabase class, this class supports a single,
    /// "canonical" standard default database connection with the following
    /// properties:
    /// 
    /// - There is only one underlying connection so queries are completed in
    ///   order.
    /// 
    /// - The combined query queue ("ACR_AsyncSQLQuery[Ex]") is synchronized
    ///   with queries issued on an ALFA.Database object.
    ///
    /// - All instances of ALFA.Database are synchronized with one another.
    ///
    /// Generally, "state changing" queries that have to synchronize with the
    /// updates performed via NWScript must go through this query.  Queries
    /// that may be processed independently, e.g. the GameWorldManager in the
    /// ACR_ServerCommunicator, may use a standalone connection instead for
    /// better performance if they do not require synchronization with the
    /// canonical database connection.
    /// </summary>
    public class Database : IALFADatabase
    {

        /// <summary>
        /// Create a new database object (which can be shared by multiple
        /// script objects).
        /// </summary>
        /// <param name="ScriptBase">Supplies the associated script base class
        /// object, used to access script APIs.</param>
        public Database(CLRScriptBase ScriptBase)
        {
            Script = ScriptBase;
        }

        /// <summary>
        /// Perform an asynchronous database query.  The query is added to the
        /// module object's query queue.
        /// </summary>
        /// <param name="Query">Supplies the query string.</param>
        public void ACR_AsyncSQLQuery(string Query)
        {
            ACR_AsyncSQLQueryEx(Query, Script.GetModule());
        }

        /// <summary>
        /// Perform an asynchronous database query.  The query is added to a
        /// specific object's query queue (must be a PC or the module).
        /// </summary>
        /// <param name="Query">Supplies the query string.</param>
        /// <param name="QueueTo">Supplies the object to queue the query to,
        /// which should be a PC or the module object.</param>
        /// <param name="Flags">Supplies query flags.</param>
        public void ACR_AsyncSQLQueryEx(string Query, UInt32 QueueTo, ACR_QUERY_FLAGS Flags = ACR_QUERY_FLAGS.None)
        {
            DemandInitialize();

            ACR_AsyncSQLQueryEx_Method.Invoke(DBLibraryScript, new object[] { Query, QueueTo, (Int32)Flags });
        }

        /// <summary>
        /// Retrieve a string from the persistent store.
        /// </summary>
        /// <param name="Object">Supplies the object whose persistent store is
        /// to be accessed.</param>
        /// <param name="VarName">Supplies the variable keyword to query.</param>
        /// <returns>The variable data is returned, else "" if there was no
        /// such variable in the persistent store.</returns>
        public string ACR_GetPersistentString(UInt32 Object, string VarName)
        {
            DemandInitialize();

            return (string)ACR_GetPersistentString_Method.Invoke(DBLibraryScript, new object[] { Object, VarName });
        }

        /// <summary>
        /// Retrieve an int from the persistent store.
        /// </summary>
        /// <param name="Object">Supplies the object whose persistent store is
        /// to be accessed.</param>
        /// <param name="VarName">Supplies the variable keyword to query.</param>
        /// <returns>The variable data is returned, else "" if there was no
        /// such variable in the persistent store.</returns>
        public int ACR_GetPersistentInt(UInt32 Object, string VarName)
        {
            string Data = ACR_GetPersistentString(Object, VarName);

            try
            {
                if (Data == "")
                    return 0;
                else
                    return Convert.ToInt32(Data);
            }
            catch
            {
                return 0;
            }
        }

        /// <summary>
        /// Retrieve a float from the persistent store.
        /// </summary>
        /// <param name="Object">Supplies the object whose persistent store is
        /// to be accessed.</param>
        /// <param name="VarName">Supplies the variable keyword to query.</param>
        /// <returns>The variable data is returned, else "" if there was no
        /// such variable in the persistent store.</returns>
        public float ACR_GetPersistentFloat(UInt32 Object, string VarName)
        {
            string Data = ACR_GetPersistentString(Object, VarName);

            try
            {
                if (Data == "")
                    return 0.0f;
                else
                    return Convert.ToSingle(Data);
            }
            catch
            {
                return 0.0f;
            }
        }

        /// <summary>
        /// Retrieve a vector from the persistent store.
        /// </summary>
        /// <param name="Object">Supplies the object whose persistent store is
        /// to be accessed.</param>
        /// <param name="VarName">Supplies the variable keyword to query.</param>
        /// <returns>The variable data is returned, else "" if there was no
        /// such variable in the persistent store.</returns>
        public Vector3 ACR_GetPersistentVector(UInt32 Object, string VarName)
        {
            string Data = ACR_GetPersistentString(Object, VarName);

            return ACR_StringToVector(Data);
        }

        /// <summary>
        /// Retrieve a location from the persistent store.
        /// </summary>
        /// <param name="Object">Supplies the object whose persistent store is
        /// to be accessed.</param>
        /// <param name="VarName">Supplies the variable keyword to query.</param>
        /// <returns>The variable data is returned, else "" if there was no
        /// such variable in the persistent store.</returns>
        public NWLocation ACR_GetPersistentLocation(UInt32 Object, string VarName)
        {
            string Data = ACR_GetPersistentString(Object, VarName);

            return ACR_StringToLocation(Data);
        }

        /// <summary>
        /// Set a string value in the persistent store.
        /// </summary>
        /// <param name="Object">Supplies the object whose persistent store is
        /// to be accessed.</param>
        /// <param name="VarName">Supplies the variable keyword to set.</param>
        /// <param name="Value">Supplies the variable data.</param>
        public void ACR_SetPersistentString(UInt32 Object, string VarName, string Value)
        {
            DemandInitialize();

            //
            // Call the standard method, which takes four parameters
            // (iExpiration - unused - for the last argument).
            //

            ACR_SetPersistentString_Method.Invoke(DBLibraryScript, new object[] { Object, VarName, Value, (Int32)0 });
        }

        /// <summary>
        /// Set an integer value in the persistent store.
        /// </summary>
        /// <param name="Object">Supplies the object whose persistent store is
        /// to be accessed.</param>
        /// <param name="VarName">Supplies the variable keyword to set.</param>
        /// <param name="Value">Supplies the variable data.</param>
        public void ACR_SetPersistentInt(UInt32 Object, string VarName, int Value)
        {
            ACR_SetPersistentString(Object, VarName, Convert.ToString(Value));
        }

        /// <summary>
        /// Set a floating point value in the persistent store.
        /// </summary>
        /// <param name="Object">Supplies the object whose persistent store is
        /// to be accessed.</param>
        /// <param name="VarName">Supplies the variable keyword to set.</param>
        /// <param name="Value">Supplies the variable data.</param>
        public void ACR_SetPersistentFloat(UInt32 Object, string VarName, float Value)
        {
            ACR_SetPersistentString(Object, VarName, Convert.ToString(Value));
        }

        /// <summary>
        /// Set a vector value in the persistent store.
        /// </summary>
        /// <param name="Object">Supplies the object whose persistent store is
        /// to be accessed.</param>
        /// <param name="VarName">Supplies the variable keyword to set.</param>
        /// <param name="Value">Supplies the variable data.</param>
        public void ACR_SetPersistentVector(UInt32 Object, string VarName, Vector3 Value)
        {
            ACR_SetPersistentString(Object, VarName, ACR_VectorToString(Value));
        }

        /// <summary>
        /// Set a vector value in the persistent store.
        /// </summary>
        /// <param name="Object">Supplies the object whose persistent store is
        /// to be accessed.</param>
        /// <param name="VarName">Supplies the variable keyword to set.</param>
        /// <param name="Value">Supplies the variable data.</param>
        public void ACR_SetPersistentLocation(UInt32 Object, string VarName, NWLocation Value)
        {
            ACR_SetPersistentString(Object, VarName, ACR_LocationToString(Value));
        }

        /// <summary>
        /// Delete a persistent record.
        /// </summary>
        /// <param name="Object">Supplies the object whose persistent store is
        /// to be accessed.</param>
        /// <param name="VarName">Supplies the variable keyword to remove.
        /// </param>
        public void ACR_DeletePersistentVariable(UInt32 Object, string VarName)
        {
            DemandInitialize();

            ACR_DeletePersistentVariable_Method.Invoke(DBLibraryScript, new object[] { Object, VarName });
        }

        /// <summary>
        /// Convert a string to a vector.
        /// </summary>
        /// <param name="sVector">Supplies the string to convert.</param>
        /// <returns>The converted vector.</returns>
        public Vector3 ACR_StringToVector(string sVector)
        {
            float fX = 0.0f, fY = 0.0f, fZ = 0.0f;
            int iPos, iCount, iLen = Script.GetStringLength(sVector);

            if (iLen > 0)
            {
                iPos = Script.FindSubString(sVector, "X", 0) + 1;
                iCount = Script.FindSubString(Script.GetSubString(sVector, iPos, iLen - iPos), "Y", 0);
                fX = Script.StringToFloat(Script.GetSubString(sVector, iPos, iCount));

                iPos = Script.FindSubString(sVector, "Y", 0) + 1;
                iCount = Script.FindSubString(Script.GetSubString(sVector, iPos, iLen - iPos), "Z", 0);
                fY = Script.StringToFloat(Script.GetSubString(sVector, iPos, iCount));

                iPos = Script.FindSubString(sVector, "Z", 0) + 1;
                fZ = Script.StringToFloat(Script.GetSubString(sVector, iPos, iLen - iPos));
            }

            Vector3 v;

            v.x = fX;
            v.y = fY;
            v.z = fZ;
            return v;
        }

        /// <summary>
        /// This structure contains raw data for a stored position in the
        /// database.
        /// </summary>
        public class LOCATION_DATA
        {
            public string AreaTag;
            public Vector3 Position;
            public float Facing;
        }

        /// <summary>
        /// This routine converts a string to a location.
        /// </summary>
        /// <param name="sLocation">Supplies the string to convert.</param>
        /// <returns>The converted location.</returns>
        public NWLocation ACR_StringToLocation(string sLocation)
        {
            UInt32 oArea;
            Vector3 vPosition;
            float fOrientation, fX, fY, fZ;

            int iPos, iCount, iLen = Script.GetStringLength(sLocation);

            if (iLen > 0)
            {
                iPos = Script.FindSubString(sLocation, "#A#", 0) + 3;
                iCount = Script.FindSubString(Script.GetSubString(sLocation, iPos, iLen - iPos), "#", 0);
                oArea = Script.GetObjectByTag(Script.GetSubString(sLocation, iPos, iCount), 0);

                iPos = Script.FindSubString(sLocation, "#X#", 0) + 3;
                iCount = Script.FindSubString(Script.GetSubString(sLocation, iPos, iLen - iPos), "#", 0);
                fX = Script.StringToFloat(Script.GetSubString(sLocation, iPos, iCount));

                iPos = Script.FindSubString(sLocation, "#Y#", 0) + 3;
                iCount = Script.FindSubString(Script.GetSubString(sLocation, iPos, iLen - iPos), "#", 0);
                fY = Script.StringToFloat(Script.GetSubString(sLocation, iPos, iCount));

                iPos = Script.FindSubString(sLocation, "#Z#", 0) + 3;
                iCount = Script.FindSubString(Script.GetSubString(sLocation, iPos, iLen - iPos), "#", 0);
                fZ = Script.StringToFloat(Script.GetSubString(sLocation, iPos, iCount));

                vPosition.x = fX;
                vPosition.y = fY;
                vPosition.z = fZ;

                iPos = Script.FindSubString(sLocation, "#O#",0) + 3;
                fOrientation = Script.StringToFloat(Script.GetSubString(sLocation, iPos, iLen - iPos));

                return Script.Location(oArea, vPosition, fOrientation);
            }

            vPosition.x = 0.0f;
            vPosition.y = 0.0f;
            vPosition.z = 0.0f;

            return Script.Location(CLRScriptBase.OBJECT_INVALID, vPosition, 0.0f);
        }

        /// <summary>
        /// This routine converts a string to its component location data
        /// fields.
        /// </summary>
        /// <param name="sLocation">Supplies the string to convert.</param>
        /// <returns>The converted location data fields.</returns>
        public LOCATION_DATA ACR_StringToLocationData(string sLocation)
        {
            LOCATION_DATA LocationData = new LOCATION_DATA();

            int iPos, iCount, iLen = Script.GetStringLength(sLocation);

            if (iLen > 0)
            {
                iPos = Script.FindSubString(sLocation, "#A#", 0) + 3;
                iCount = Script.FindSubString(Script.GetSubString(sLocation, iPos, iLen - iPos), "#", 0);
                LocationData.AreaTag = Script.GetSubString(sLocation, iPos, iCount);

                iPos = Script.FindSubString(sLocation, "#X#", 0) + 3;
                iCount = Script.FindSubString(Script.GetSubString(sLocation, iPos, iLen - iPos), "#", 0);
                LocationData.Position.y = Script.StringToFloat(Script.GetSubString(sLocation, iPos, iCount));

                iPos = Script.FindSubString(sLocation, "#Y#", 0) + 3;
                iCount = Script.FindSubString(Script.GetSubString(sLocation, iPos, iLen - iPos), "#", 0);
                LocationData.Position.y = Script.StringToFloat(Script.GetSubString(sLocation, iPos, iCount));

                iPos = Script.FindSubString(sLocation, "#Z#", 0) + 3;
                iCount = Script.FindSubString(Script.GetSubString(sLocation, iPos, iLen - iPos), "#", 0);
                LocationData.Position.z = Script.StringToFloat(Script.GetSubString(sLocation, iPos, iCount));

                iPos = Script.FindSubString(sLocation, "#O#", 0) + 3;
                LocationData.Facing = Script.StringToFloat(Script.GetSubString(sLocation, iPos, iLen - iPos));
            }

            return LocationData;
        }
        
        /// <summary>
        /// This routine queries the database in order to return the public IP
        /// address of the game server host.
        /// </summary>
        /// <returns>The server public IP, which may be either a hostname or
        /// raw dotted quad.</returns>
        public string ACR_GetServerAddressFromDatabase()
        {
            DemandInitialize();

            return (string)ACR_GetServerAddressFromDatabase_Method.Invoke(DBLibraryScript, null);
        }

        /// <summary>
        /// This routine escapes characters for a SQL query.
        /// </summary>
        /// <param name="s">Supplies the string to escape.</param>
        /// <returns>The escaped string is returned.</returns>
        public string ACR_SQLEncodeSpecialChars(string s)
        {
            IALFADatabase DefaultDatabase = ModuleLinkage.DefaultDatabase;

            if (DefaultDatabase != null)
                return DefaultDatabase.ACR_SQLEncodeSpecialChars(s);

            return Script.NWNXGetString("SQL", "GET ESCAPE STRING", s, 0);
        }

        /// <summary>
        /// This routine fetches the next rowset from the database.
        /// </summary>
        /// <returns>Returns true if the query succeeded.</returns>
        public bool ACR_SQLFetch()
        {
            //const int SQL_ERROR = 0;
            const int SQL_SUCCESS = 1;

            IALFADatabase DefaultDatabase = ModuleLinkage.DefaultDatabase;

            if (DefaultDatabase != null)
                return DefaultDatabase.ACR_SQLFetch();

            if (Script.NWNXGetInt("SQL", "FETCH", " ", 0) != SQL_SUCCESS)
                return false;
            else
                return true;
        }

        /// <summary>
        /// This routine returns the first column of data from the current SQL
        /// rowset.
        /// </summary>
        /// <returns>The column data is returned</returns>
        public string ACR_SQLGetData()
        {
            return ACR_SQLGetData(0);
        }

        /// <summary>
        /// This routine returns the specified column of data from the current
        /// SQL rowset.
        /// </summary>
        /// <param name="ColumnIndex">Supplies the zero-based column index to
        /// retrieve.</param>
        /// <returns>The column data is returned.</returns>
        public string ACR_SQLGetData(int ColumnIndex)
        {
            IALFADatabase DefaultDatabase = ModuleLinkage.DefaultDatabase;

            if (DefaultDatabase != null)
                return DefaultDatabase.ACR_SQLGetData(ColumnIndex);

            return Script.NWNXGetString("SQL", "GETDATA", "", ColumnIndex);
        }

        /// <summary>
        /// This routine returns the number of rows affected by a query.
        /// </summary>
        /// <returns>The row count is returned.</returns>
        public int ACR_SQLGetAffectedRows()
        {
            IALFADatabase DefaultDatabase = ModuleLinkage.DefaultDatabase;

            if (DefaultDatabase != null)
                return DefaultDatabase.ACR_SQLGetAffectedRows();

            return Script.NWNXGetInt("SQL", "GET AFFECTED ROWS", "", 0);
        }

        /// <summary>
        /// This routine performs a synchronous SQL query.  If there were
        /// pending asynchronous queries in the queue, the pending queries are
        /// drained first.
        /// </summary>
        /// <param name="SQL">Supplies the SQL query text to execute.</param>
        public void ACR_SQLQuery(string SQL)
        {
            DemandInitialize();

            ACR_SQLQuery_Method.Invoke(DBLibraryScript, new object[] { SQL });
        }

        /// <summary>
        /// This routine flushes the query queue for an object.  It is useful,
        /// for example, in server portal scenarios.  Normally, the query queue
        /// is flushed automatically.
        /// </summary>
        /// <param name="ObjectToFlush">Supplies the object whose query queue
        /// should be flushed.</param>
        public void ACR_FlushQueryQueue(uint ObjectToFlush)
        {
            DemandInitialize();

            ACR_FlushQueryQueue_Method.Invoke(DBLibraryScript, new object[] { ObjectToFlush });
        }

        /// <summary>
        /// This routine validates a character from quarantine.
        /// </summary>
        /// <param name="PCToValidate"></param>
        public void ACR_PPSValidatePC(uint PCToValidate)
        {
            DemandInitialize();

            ACR_PPSValidatePC_Method.Invoke(DBLibraryScript, new object[] { PCToValidate });
        }

        /// <summary>
        /// This method updates regularly-saved persistent information.
        /// </summary>
        /// <param name="PCToUpdate">the PC to be updated</param>
        /// <param name="UpdateLocation">whether or not to also update location</param>
        public void ACR_PCUpdateStatus(uint PCToUpdate, bool UpdateLocation)
        {
            DemandInitialize();

            ACR_PCUpdateStatus_Method.Invoke(DBLibraryScript, new object[] { PCToUpdate, UpdateLocation ? CLRScriptBase.TRUE : CLRScriptBase.FALSE });
        }

        /// <summary>
        /// This method calculates offline resting for a PC after logging in.
        /// </summary>
        /// <param name="PCToRest">the PC to be rested</param>
        public void ACR_RestOnClientEnter(uint PCToRest)
        {
            DemandInitialize();

            ACR_RestOnClientEnter_Method.Invoke(DBLibraryScript, new object[] { PCToRest });
        }

        /// <summary>
        /// This method calculates RPXP for the last playing session.
        /// </summary>
        /// <param name="PCToXP">the PC to XP</param>
        public void ACR_XPOnClientLoaded(uint PCToXP)
        {
            DemandInitialize();

            ACR_XPOnClientLoaded_Method.Invoke(DBLibraryScript, new object[] { PCToXP });
        }

        /// <summary>
        /// This routine performs a character save.
        /// </summary>
        /// <param name="PCToSave">Supplies the object id of the player to
        /// save.</param>
        /// <param name="Export">If true, save the character file to disk too.
        /// </param>
        /// <param name="SaveLocation">If true, update the location of the
        /// player in the database.</param>
        public void ACR_PCSave(uint PCToSave, bool Export, bool SaveLocation)
        {
            DemandInitialize();

            ACR_PCSave_Method.Invoke(DBLibraryScript, new object[] { PCToSave, Export ? CLRScriptBase.TRUE : CLRScriptBase.FALSE, SaveLocation ? CLRScriptBase.TRUE : CLRScriptBase.FALSE });
        }

        /// <summary>
        /// Get the version string of the ACR release that the module was
        /// compiled against.  For example, "1.84".
        /// </summary>
        /// <returns>The ACR version string that the DB Library Script was
        /// compiled against is returned.</returns>
        public string ACR_GetVersion()
        {
            DemandInitialize();

            return (string)ACR_GetVersion_Method.Invoke(DBLibraryScript, null);
        }

        /// <summary>
        /// Get the build date of the module OnLoad script (i.e. the time at
        /// which the module had its scripts nominally compiled).
        /// </summary>
        /// <returns>The module build date string, e.g.
        /// Apr 16 2012 22:10:35.</returns>
        public string ACR_GetBuildDate()
        {
            DemandInitialize();

            return (string)ACR_GetBuildDate_Method.Invoke(DBLibraryScript, null);
        }

        /// <summary>
        /// Get the version string of the ACR release that the HAK corresponds
        /// to.  For example, "1.84".
        /// </summary>
        /// <returns>The ACR version string that the HAK was designated as is
        /// returned.</returns>
        public string ACR_GetHAKVersion()
        {
            DemandInitialize();

            return (string)ACR_GetHAKVersion_Method.Invoke(DBLibraryScript, null);
        }

        /// <summary>
        /// Get the build date of the HAK version check script (i.e. the time
        /// at which the ACR HAK had its scripts nominally compiled).
        /// </summary>
        /// <returns>The HAK build date string, e.g.
        /// Apr 16 2012 22:10:35.</returns>
        public string ACR_GetHAKBuildDate()
        {
            DemandInitialize();

            return (string)ACR_GetHAKBuildDate_Method.Invoke(DBLibraryScript, null);
        }

        /// <summary>
        /// Increment a global tracking statistic counter stored in the
        /// database (if statistic tracking was enabled).
        /// </summary>
        /// <param name="Statistic">Supplies the counter name.</param>
        public void ACR_IncrementStatistic(string Statistic)
        {
            DemandInitialize();

            ACR_IncrementStatistic_Method.Invoke(DBLibraryScript, new object [] { Statistic });
        }

        /// <summary>
        /// Run a script on a remote server.  The script must exist on the
        /// server.  If acknowledgement is desired, it must be implemented in
        /// the form of a reply IPC request initiated by the script invoked.
        /// 
        /// A script executed by this function must follow this prototype:
        /// 
        /// void main(int SourceServerID, string Argument);
        /// </summary>
        /// <param name="DestinationServerID">Supplies the destination server
        /// ID.</param>
        /// <param name="ScriptName">Supplies the name of the script.</param>
        /// <param name="ScriptArgument">Supplies an optional argument to pass
        /// to the script.</param>
        public bool ACR_RunScriptOnServer(int DestinationServerID, string ScriptName, string ScriptArgument)
        {
            DemandInitialize();

            return (int)ACR_RunScriptOnServer_Method.Invoke(DBLibraryScript, new object[] { DestinationServerID, ScriptName, ScriptArgument }) != CLRScriptBase.FALSE ? true : false;
        }

        /// <summary>
        /// Log an event to the database log.
        /// </summary>
        /// <param name="Character">Supplies an optional character that is
        /// associated with the log event, else OBJECT_INVALID if none.</param>
        /// <param name="EventName">Supplies the log event name.</param>
        /// <param name="EventDescription">Supplies the log event description.
        /// </param>
        /// <param name="DM">Supplies an optional DM character that is
        /// associated with the log event, else OBJECT_INVALID if none.</param>
        public void ACR_LogEvent(uint Character, string EventName, string EventDescription, uint DM)
        {
            DemandInitialize();

            ACR_LogEvent_Method.Invoke(DBLibraryScript, new object[] { Character, EventName, EventDescription, DM });
        }

        /// <summary>
        /// Returns whether a PC is a fully approved ALFA member (vs. a new
        /// account that might be a throw-away, etc.).
        /// </summary>
        /// <param name="PCObject">Supplies the PC object.</param>
        /// <returns>True is returned if the PC belongs to an approved member.
        /// </returns>
        public bool ACR_GetIsMember(UInt32 PCObject)
        {
            DemandInitialize();

            return (int)ACR_GetIsMember_Method.Invoke(DBLibraryScript, new object[] { PCObject }) != 0;
        }

        /// <summary>
        /// This routine performs a synchronous SQL query.  If there were
        /// pending asynchronous queries in the queue, the pending queries are
        /// drained first.
        /// 
        /// The query must not return any results.
        /// </summary>
        /// <param name="SQL">Supplies the SQL query text to execute.</param>
        public void ACR_SQLExecute(string SQL)
        {
            ACR_SQLQuery(SQL);
        }

        /// <summary>
        /// This routine returns the database character ID for a player given
        /// their PC object id.
        /// </summary>
        /// <param name="PCObject">Supplies the object ID of the player to
        /// query.</param>
        /// <returns>The database character ID of the player is returned.
        /// </returns>
        public int ACR_GetCharacterID(UInt32 PCObject)
        {
            return Script.GetLocalInt(PCObject, "ACR_CID");
        }

        /// <summary>
        /// This routine returns the database player ID for a player given
        /// their PC object id.
        /// </summary>
        /// <param name="PCObject">Supplies the object ID of the player to
        /// query.</param>
        /// <returns>The database player ID of the player is returned.</returns>
        public int ACR_GetPlayerID(UInt32 PCObject)
        {
            return Script.GetLocalInt(PCObject, "ACR_PID");
        }

        /// <summary>
        /// Return the current PC local flags value for a PC.
        /// </summary>
        /// <param name="PCObject">Supplies the PC object.</param>
        /// <returns>The PC Local Flags value.</returns>
        public int ACR_GetPCLocalFlags(UInt32 PCObject)
        {
            return Script.GetLocalInt(PCObject, "ACR_PC_LOCAL_FLAGS");
        }

        /// <summary>
        /// Assigns the current PC local flags value for a PC.
        /// </summary>
        /// <param name="PCObject">Supplies the PC object.</param>
        /// <param name="Flags">Supplies the new Local Flags value.</param>
        public void ACR_SetPCLocalFlags(UInt32 PCObject, int Flags)
        {
            Script.SetLocalInt(PCObject, "ACR_PC_LOCAL_FLAGS", Flags);
        }

        /// <summary>
        /// This routine determines whether a player is a server admin for the
        /// current server.
        /// </summary>
        /// <param name="PCObject">Supplies the object ID of the player to
        /// query.</param>
        /// <returns>True if the player is a server admin.</returns>
        public bool ACR_IsServerAdmin(UInt32 PCObject)
        {
            const int ACR_SRVADMIN_INDETERMINITE = 0;
            const int ACR_SRVADMIN_IS_ADMIN = 1;
            const int ACR_SRVADMIN_NOT_ADMIN = 2;

            switch (Script.GetLocalInt(PCObject, "ACR_SRVADMIN"))
            {
                
                case ACR_SRVADMIN_INDETERMINITE:
                    //
                    // We don't yet know if the player is an admin, ask the
                    // database and save the result.  If we get any rows back,
                    // then we're an admin.
                    //

                    ACR_SQLQuery(String.Format("SELECT PlayerID FROM server_admins WHERE ServerID={0} AND PlayerID={1}", ACR_GetServerID(), ACR_GetPlayerID(PCObject)));

                    if (ACR_SQLFetch())
                    {
                        Script.SetLocalInt(PCObject, "ACR_SRVADMIN", ACR_SRVADMIN_IS_ADMIN);
                        return true;
                    }
                    else
                    {
                        Script.SetLocalInt(PCObject, "ACR_SRVADMIN", ACR_SRVADMIN_NOT_ADMIN);
                        return false;
                    }

                case ACR_SRVADMIN_IS_ADMIN:
                    return true;

                default:
                case ACR_SRVADMIN_NOT_ADMIN:
                    return false;

            }
        }

        /// <summary>
        /// This routine returns the database server ID of the current server.
        /// </summary>
        /// <returns>The server ID is returned.</returns>
        public int ACR_GetServerID()
        {
            return Script.GetGlobalInt("ACR_SET_SID");
        }

        /// <summary>
        /// Return whether a PC is quarantined.
        /// </summary>
        /// <param name="PCObject">Supplies the PC object.</param>
        /// <returns>True is returned if the PC is quarantined.</returns>
        public bool ACR_GetIsPCQuarantined(UInt32 PCObject)
        {
            return Script.GetLocalInt(PCObject, "ACR_PPS_QUARANTINED") != CLRScriptBase.FALSE;
        }

        /// <summary>
        /// This routine packages a location object into a string.
        /// </summary>
        /// <param name="Location">Supplies the location to convert.</param>
        /// <returns>The converted string is returned.</returns>
        public string ACR_LocationToString(NWLocation Location)
        {
            Vector3 Position = Script.GetPositionFromLocation(Location);

            return String.Format(
                "#A#{0}#X#{1}#Y#{2}#Z#{3}#O#{4}",
                Script.GetTag(Script.GetAreaFromLocation(Location)),
                Script.FloatToString(Position.x, 0, 9),
                Script.FloatToString(Position.y, 0, 9),
                Script.FloatToString(Position.z, 0, 9),
                Script.FloatToString(Script.GetFacingFromLocation(Location), 0, 9));
        }

        /// <summary>
        /// This routine packages a vector into a string.
        /// </summary>
        /// <param name="v">Supplies the vector to convert.</param>
        /// <returns>The converted string is returned.</returns>
        public string ACR_VectorToString(Vector3 v)
        {
            return String.Format("X{0}Y{1}Z{2}", v.x, v.y, v.z);
        }

        /// <summary>
        /// Flush all query queues in the system out to the database.
        /// </summary>
        public void ACR_FlushAllQueryQueues()
        {
            foreach (uint PCObject in Script.GetPlayers(true))
                ACR_FlushQueryQueue(PCObject);

            ACR_FlushQueryQueue(Script.GetModule());
        }

        /// <summary>
        /// Convert a database string to a Boolean value.
        /// </summary>
        /// <param name="Str">Supplies the database string.</param>
        /// <returns>The corresponding Boolean value is returned.</returns>
        public static bool ACR_ConvertDatabaseStringToBoolean(string Str)
        {
            Str = Str.ToLowerInvariant();

            if (Str.StartsWith("t"))
                return true;
            else if (Str.StartsWith("f"))
                return false;
            else
                return Convert.ToInt32(Str) != 0;
        }



        //
        // PC Local Flags.
        //

        /// <summary>
        /// Portal request is live and in progress.
        /// </summary>
        public const int ACR_PC_LOCAL_FLAG_PORTAL_IN_PROGRESS = 0x00000001;
        /// <summary>
        /// Portal request has reached the stage where it cannot be rolled back
        /// without disconnecting the player forcibly.
        /// </summary>
        public const int ACR_PC_LOCAL_FLAG_PORTAL_COMMITTED = 0x00000002;
        /// <summary>
        /// Help text sent to player about cross server tells and how they
        /// work.
        /// </summary>
        public const int ACR_PC_LOCAL_FLAG_SERVER_TELL_HELP = 0x00000004;



        /// <summary>
        /// This method performs demand initialization of the database system
        /// on the first database call.
        /// </summary>
        private void DemandInitialize()
        {
            if (DBLibraryScript != null)
            {
                RegisterScriptSituationDelegate(DBLibraryScript);
                return;
            }

            //
            // Link to the module load script, as it will always be already
            // loaded, and it references database functions.
            //

            IGeneratedScriptProgram ScriptObject = ScriptLoader.LoadScript("acf_mod_onmoduleload", false, Script);
            ACR_AsyncSQLQueryEx_Method = ScriptLoader.GetScriptFunction(ScriptObject, "ACR_AsyncSQLQueryEx");
            ACR_GetPersistentString_Method = ScriptLoader.GetScriptFunction(ScriptObject, "ACR_GetPersistentString");
            ACR_GetServerAddressFromDatabase_Method = ScriptLoader.GetScriptFunction(ScriptObject, "ACR_GetServerAddressFromDatabase");
            ACR_SetPersistentString_Method = ScriptLoader.GetScriptFunction(ScriptObject, "ACR_SetPersistentString");
            ACR_DeletePersistentVariable_Method = ScriptLoader.GetScriptFunction(ScriptObject, "ACR_DeletePersistentVariable");
            ACR_SQLQuery_Method = ScriptLoader.GetScriptFunction(ScriptObject, "ACR_SQLQuery");
            ACR_FlushQueryQueue_Method = ScriptLoader.GetScriptFunction(ScriptObject, "ACR_FlushQueryQueue");
            ACR_PPSValidatePC_Method = ScriptLoader.GetScriptFunction(ScriptObject, "ACR_PPSValidatePC");
            ACR_PCUpdateStatus_Method = ScriptLoader.GetScriptFunction(ScriptObject, "ACR_PCUpdateStatus");
            ACR_RestOnClientEnter_Method = ScriptLoader.GetScriptFunction(ScriptObject, "ACR_RestOnClientEnter");
            ACR_XPOnClientLoaded_Method = ScriptLoader.GetScriptFunction(ScriptObject, "ACR_XPOnClientLoaded");
            ACR_PCSave_Method = ScriptLoader.GetScriptFunction(ScriptObject, "ACR_PCSave");
            ACR_GetVersion_Method = ScriptLoader.GetScriptFunction(ScriptObject, "ACR_GetVersion");
            ACR_GetBuildDate_Method = ScriptLoader.GetScriptFunction(ScriptObject, "ACR_GetBuildDate");
            ACR_GetHAKVersion_Method = ScriptLoader.GetScriptFunction(ScriptObject, "ACR_GetHAKVersion");
            ACR_GetHAKBuildDate_Method = ScriptLoader.GetScriptFunction(ScriptObject, "ACR_GetHAKBuildDate");
            ACR_IncrementStatistic_Method = ScriptLoader.GetScriptFunction(ScriptObject, "ACR_IncrementStatistic");
            ACR_RunScriptOnServer_Method = ScriptLoader.GetScriptFunction(ScriptObject, "ACR_RunScriptOnServer");
            ACR_LogEvent_Method = ScriptLoader.GetScriptFunction(ScriptObject, "ACR_LogEvent");
            ACR_GetIsMember_Method = ScriptLoader.GetScriptFunction(ScriptObject, "ACR_GetIsMember");

            DBLibraryScript = ScriptObject;

            RegisterScriptSituationDelegate(ScriptObject);
        }

        /// <summary>
        /// This method sets the user's script object to delegate unrecognized
        /// script situations to the NWScript library script, allowing a delay
        /// continuation started by called NWScript code to function properly.
        /// </summary>
        /// <param name="DelegateScript"></param>
        private void RegisterScriptSituationDelegate(IGeneratedScriptProgram DelegateScript)
        {
            //
            // Dispatch delay continuations from the DBLibraryScript over to
            // NWScript code.
            //

            if (Script.DelegateScriptObject != DelegateScript)
            {
                if (Script.DelegateScriptObject != null)
                    throw new ApplicationException("Duplicate delegate script registration.");

                Script.DelegateScriptObject = DelegateScript;
            }

        }

        /// <summary>
        /// A link to the associated script program object is maintained here.
        /// </summary>
        private CLRScriptBase Script;

        /// <summary>
        /// This field contains the library script that contains the database
        /// interface functions.
        /// </summary>
        private static IGeneratedScriptProgram DBLibraryScript;

        //
        // These fields contain the methods linked to from the DB library script.
        //

        private static MethodInfo ACR_AsyncSQLQueryEx_Method;
        private static MethodInfo ACR_GetPersistentString_Method;
        private static MethodInfo ACR_GetServerAddressFromDatabase_Method;
        private static MethodInfo ACR_SetPersistentString_Method;
        private static MethodInfo ACR_DeletePersistentVariable_Method;
        private static MethodInfo ACR_SQLQuery_Method;
        private static MethodInfo ACR_FlushQueryQueue_Method;
        private static MethodInfo ACR_PPSValidatePC_Method;
        private static MethodInfo ACR_PCUpdateStatus_Method;
        private static MethodInfo ACR_RestOnClientEnter_Method;
        private static MethodInfo ACR_XPOnClientLoaded_Method;
        private static MethodInfo ACR_PCSave_Method;
        private static MethodInfo ACR_GetVersion_Method;
        private static MethodInfo ACR_GetBuildDate_Method;
        private static MethodInfo ACR_GetHAKVersion_Method;
        private static MethodInfo ACR_GetHAKBuildDate_Method;
        private static MethodInfo ACR_IncrementStatistic_Method;
        private static MethodInfo ACR_RunScriptOnServer_Method;
        private static MethodInfo ACR_LogEvent_Method;
        private static MethodInfo ACR_GetIsMember_Method;
    }
}
