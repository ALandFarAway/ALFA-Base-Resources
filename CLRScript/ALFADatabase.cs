//
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
    /// This class encapsulates database access for ALFA CLR scripts.
    /// </summary>
    public class Database
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
        public void ACR_AsyncSQLQueryEx(string Query, UInt32 QueueTo)
        {
            DemandInitialize();

            ACR_AsyncSQLQueryEx_Method.Invoke(DBLibraryScript, new object[] { Query, QueueTo });
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
        /// This routine returns the specified column of data form the current
        /// SQL rowset.
        /// </summary>
        /// <param name="ColumnIndex">Supplies the zero-based column index to
        /// retrieve.</param>
        /// <returns>The column data is returned.</returns>
        public string ACR_SQLGetData(int ColumnIndex)
        {
            return Script.NWNXGetString("SQL", "GETDATA", "", ColumnIndex);
        }

        /// <summary>
        /// This routine returns the number of rows affected by a query.
        /// </summary>
        /// <returns>The row count is returned.</returns>
        public int ACR_SQLGetAffectedRows()
        {
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
        /// <param name="PCObject">Supplies the object ID of the player to</param>
        /// query.
        /// <returns>The database player ID of the player is returned.</returns>
        public int ACR_GetPlayerID(UInt32 PCObject)
        {
            return Script.GetLocalInt(PCObject, "ACR_PID");
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
        /// This method performs demand initialization of the database system
        /// on the first database call.
        /// </summary>
        private void DemandInitialize()
        {
            if (DBLibraryScript != null)
                return;

            //
            // Link to the module load script, as it will always be already
            // loaded, and it references database functions.
            //

            IGeneratedScriptProgram ScriptObject = ScriptLoader.LoadScript("acf_mod_onmoduleload", false, Script);
            ACR_AsyncSQLQueryEx_Method = ScriptLoader.GetScriptFunction(ScriptObject, "ACR_AsyncSQLQueryEx");
            ACR_GetPersistentString_Method = ScriptLoader.GetScriptFunction(ScriptObject, "ACR_GetPersistentString");
            ACR_GetServerAddressFromDatabase_Method = ScriptLoader.GetScriptFunction(ScriptObject, "ACR_GetServerAddressFromDatabase");
            ACR_SetPersistentString_Method = ScriptLoader.GetScriptFunction(ScriptObject, "ACR_SetPersistentString");
            ACR_SQLQuery_Method = ScriptLoader.GetScriptFunction(ScriptObject, "ACR_SQLQuery");

            DBLibraryScript = ScriptObject;
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
        private static MethodInfo ACR_SQLQuery_Method;
    }
}
