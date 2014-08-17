//
// This script encapsulates a script-managed database connection.
//

using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Text;
using CLRScriptFramework;
using ALFA;
using ALFA.Shared;
using NWScript;
using NWScript.ManagedInterfaceLayer.NWScriptManagedInterface;

using NWEffect = NWScript.NWScriptEngineStructure0;
using NWEvent = NWScript.NWScriptEngineStructure1;
using NWLocation = NWScript.NWScriptEngineStructure2;
using NWTalent = NWScript.NWScriptEngineStructure3;
using NWItemProperty = NWScript.NWScriptEngineStructure4;

namespace ACR_ServerMisc
{
    /// <summary>
    /// Connection flags for a ScriptDatabaseConnection.
    /// </summary>
    public enum ScriptDatabaseConnectionFlags : int
    {
        None = 0x00000000,

        /// <summary>
        /// Enable debug logging (query logging).
        /// </summary>
        Debug = 0x00000001,

        /// <summary>
        /// This connection should be logged to the standard query log file.
        /// </summary>
        StandardQueryLog = 0x00000002,

        /// <summary>
        /// This connection should use the standard default connection
        /// parameters.  The query string is determined from the NWNX4 SQL
        /// plugin configuration, and the connection ID is always zero.
        /// </summary>
        StandardConnection = 0x00000004,
    }

    /// <summary>
    /// This class encapsulates a script-managed database connection.
    /// </summary>
    public class ScriptDatabaseConnection
    {

        /// <summary>
        /// Create a new database connection object.
        /// </summary>
        /// <param name="ConnectionString">Supplies the connection string.
        /// </param>
        /// <param name="Flags">Supplies control flags.</param>
        private ScriptDatabaseConnection(string ConnectionString, ScriptDatabaseConnectionFlags Flags)
        {
            Database = new ALFA.MySQLDatabase(ConnectionString, Flags.HasFlag(ScriptDatabaseConnectionFlags.StandardConnection));
            this.Flags = Flags;
        }

        /// <summary>
        /// Create a new database connection object and return a handle to it.
        /// </summary>
        /// <param name="ConnectionString">Supplies the connection string.
        /// </param>
        /// <param name="Flags">Supplies control flags.</param>
        /// <returns>The connection handle.</returns>
        public static int CreateScriptDatabaseConnection(string ConnectionString, ScriptDatabaseConnectionFlags Flags)
        {
            int Handle;
            ScriptDatabaseConnection Connection;

            if (Flags.HasFlag(ScriptDatabaseConnectionFlags.StandardConnection))
            {
                Handle = 0;

                if (StandardConnection == null)
                {
                    ConnectionString = GetStandardDatabaseConnectionString();
                    Connection = new ScriptDatabaseConnection(ConnectionString, Flags);
                    StandardConnection = Connection;
                    ModuleLinkage.DefaultDatabase = StandardConnection.Database;
                    ConnectionTable.Add(Handle, Connection);
                }
            }
            else
            {
                Connection = new ScriptDatabaseConnection(ConnectionString, Flags);
                Handle = ++NextConnectionHandle;

                if (Handle == 0)
                    Handle = ++NextConnectionHandle;

                ConnectionTable.Add(Handle, Connection);
            }

            if (Flags.HasFlag(ScriptDatabaseConnectionFlags.StandardQueryLog) && StandardQueryLogger == null)
            {
                try
                {
                    StandardQueryLogger = new StreamWriter(ALFA.SystemInfo.GetNWNX4InstallationDirectory() + "StandardQueryLog.txt");
                }
                catch (Exception e)
                {
                    Logger.Log("ScriptDatabaseConnection.CreateScriptDatabaseConnection: Couldn't open standard query log (StandardQueryLog.txt in NWNX4 directory): Exception: {0}", e);
                }
            }

            return Handle;
        }

        /// <summary>
        /// Remove a database connection object by handle.
        /// </summary>
        /// <param name="ConnectionHandle">Supplies a handle to the database
        /// connection to delete.</param>
        /// <returns>True of the operation succeeded.</returns>
        public static bool DestroyDatabaseConnection(int ConnectionHandle)
        {
            return ConnectionTable.Remove(ConnectionHandle);
        }

        /// <summary>
        /// Execute a database query.
        /// </summary>
        /// <param name="ConnectionHandle">Supplies a database connection
        /// handle.</param>
        /// <param name="Query">Supplies the query.</param>
        /// <param name="Script">Supplies the script object.</param>
        /// <returns>True if the operation succeeded.</returns>
        public static bool QueryDatabaseConnection(int ConnectionHandle, string Query, ACR_ServerMisc Script)
        {
            ScriptDatabaseConnection Connection;

            if (!ConnectionTable.TryGetValue(ConnectionHandle, out Connection))
            {
                Script.WriteTimestampedLogEntry(String.Format(
                    "ScriptDatabaseConnection({0}): Invalid connection handle in QueryDatabaseConnection({1}).", ConnectionHandle, Query));
                return false;
            }

            if (Connection.Flags.HasFlag(ScriptDatabaseConnectionFlags.Debug))
            {
                Script.WriteTimestampedLogEntry(String.Format(
                    "ScriptDatabaseConnection({0}): Executing query '{1}'", ConnectionHandle, Query));
            }

            if (Connection.Flags.HasFlag(ScriptDatabaseConnectionFlags.StandardQueryLog))
                LogQuery(String.Format("* Executing: {0}", Query));

            try
            {
                Connection.Database.ACR_SQLQuery(Query);
            }
            catch (Exception e)
            {
                Logger.Log("ScriptDatabaseConnection.QueryDatabaseConnection: Exception: {0}", e);

                if (Connection.Flags.HasFlag(ScriptDatabaseConnectionFlags.StandardQueryLog))
                    LogQuery("! ACR_SQLQuery failed.");

                return false;
            }

            return true;
        }

        /// <summary>
        /// Fetch a database rowset.
        /// </summary>
        /// <param name="ConnectionHandle">Supplies a database connection
        /// handle.</param>
        /// <param name="Script">Supplies the script object.</param>
        /// <returns>True if the operation succeeded.</returns>
        public static bool FetchDatabaseConnection(int ConnectionHandle, ACR_ServerMisc Script)
        {
            ScriptDatabaseConnection Connection;

            if (!ConnectionTable.TryGetValue(ConnectionHandle, out Connection))
            {
                Script.WriteTimestampedLogEntry(String.Format(
                    "ScriptDatabaseConnection({0}): Invalid connection handle in FetchDatabaseConnection().", ConnectionHandle));
                return false;
            }

            try
            {
                return Connection.Database.ACR_SQLFetch();
            }
            catch (Exception e)
            {
                if (Connection.Flags.HasFlag(ScriptDatabaseConnectionFlags.StandardQueryLog))
                    LogQuery("! ACR_SQLFetch failed.");

                Logger.Log("ScriptDatabaseConnection.FetchDatabaseConnection: Exception: {0}", e);
                return false;
            }
        }

        /// <summary>
        /// Get a column from a fetched a database rowset.
        /// </summary>
        /// <param name="ConnectionHandle">Supplies a database connection
        /// handle.</param>
        /// <param name="ColumnIndex">Supplies the column index.</param>
        /// <param name="Script">Supplies the script object.</param>
        /// <returns>True if the operation succeeded.</returns>
        public static string GetColumnDatabaseConnection(int ConnectionHandle, int ColumnIndex, ACR_ServerMisc Script)
        {
            ScriptDatabaseConnection Connection;

            if (!ConnectionTable.TryGetValue(ConnectionHandle, out Connection))
            {
                Script.WriteTimestampedLogEntry(String.Format(
                    "ScriptDatabaseConnection({0}): Invalid connection handle in GetColumnDatabaseConnection({1}).", ConnectionHandle, ColumnIndex));
                return null;
            }

            string Data;
            bool Succeeded = true;

            try
            {
                Data = Connection.Database.ACR_SQLGetData(ColumnIndex);
            }
            catch (Exception e)
            {
                Logger.Log("ScriptDatabaseConnection.GetColumnDatabaseConnection: Exception: {0}", e);
                Data = "";
                Succeeded = false;
            }

            if (Connection.Flags.HasFlag(ScriptDatabaseConnectionFlags.Debug))
            {
                Script.WriteTimestampedLogEntry(String.Format(
                    "ScriptDatabaseConnection({0}): Column {1} data: {2}", ConnectionHandle, ColumnIndex, Data));
            }

            if (Connection.Flags.HasFlag(ScriptDatabaseConnectionFlags.StandardQueryLog))
            {
                if (Succeeded)
                    LogQuery(String.Format("* Returning: {0} (column {1})", Data, ColumnIndex));
                else
                    LogQuery("! ACR_SQLGetData failed.");
            }

            return Data;
        }

        /// <summary>
        /// Get the affected row count from a database rowset.
        /// </summary>
        /// <param name="ConnectionHandle">Supplies a database connection
        /// handle.</param>
        /// <param name="Script">Supplies the script object.</param>
        /// <returns>The affected row count is returned.</returns>
        public static int GetAffectedRowCountDatabaseConnection(int ConnectionHandle, ACR_ServerMisc Script)
        {
            ScriptDatabaseConnection Connection;

            if (!ConnectionTable.TryGetValue(ConnectionHandle, out Connection))
            {
                Script.WriteTimestampedLogEntry(String.Format(
                    "ScriptDatabaseConnection({0}): Invalid connection handle in GetAffectedRowCountDatabaseConnection().", ConnectionHandle));
                return 0;
            }

            try
            {
                return Connection.Database.ACR_SQLGetAffectedRows();
            }
            catch (Exception e)
            {
                Logger.Log("ScriptDatabaseConnection.GetAffectedRowCountDatabaseConnection: Exception: {0}", e);
                return 0;
            }
        }

        /// <summary>
        /// GetEscape a string for subsequent safe use in a database query.
        /// </summary>
        /// <param name="ConnectionHandle">Supplies a database connection
        /// handle.</param>
        /// <param name="Str">Supplies the string to escape.</param>
        /// <param name="Script">Supplies the script object.</param>
        /// <returns>The escaped string if the operation succeeded, else null.
        /// </returns>
        public static string EscapeStringDatabaseConnection(int ConnectionHandle, string Str, ACR_ServerMisc Script)
        {
            ScriptDatabaseConnection Connection;

            if (!ConnectionTable.TryGetValue(ConnectionHandle, out Connection))
            {
                Script.WriteTimestampedLogEntry(String.Format(
                    "ScriptDatabaseConnection({0}): Invalid connection handle in EscapeStringDatabaseConnection({1}).", ConnectionHandle, Str));
                return null;
            }

            return Connection.Database.ACR_SQLEncodeSpecialChars(Str);
        }

        /// <summary>
        /// Log text to the standard query log.
        /// </summary>
        /// <param name="LogText">Supplies a line to write to the standard query log.</param>
        private static void LogQuery(string LogText)
        {
            if (StandardQueryLogger == null)
                return;

            try
            {
                string Timestamp = DateTime.Now.ToString("ddd dd MMM HH:mm:ss:fff");
                StandardQueryLogger.WriteLine("[{0}]: {1}", Timestamp, LogText);
                StandardQueryLogger.Flush();
            }
            catch
            {
            }
        }

        /// <summary>
        /// Generate the query string used for the standard database
        /// connection.
        /// </summary>
        /// <returns>A database connection string.</returns>
        private static string GetStandardDatabaseConnectionString()
        {
            return null;
        }


        /// <summary>
        /// The global table mapping database connection handles (type int) to
        /// database connection objects.
        /// </summary>
        private static Dictionary<int, ScriptDatabaseConnection> ConnectionTable = new Dictionary<int, ScriptDatabaseConnection>();

        /// <summary>
        /// The next database connection handle.
        /// </summary>
        private static int NextConnectionHandle = 0;

        /// <summary>
        /// The standard query logger.
        /// </summary>
        static private StreamWriter StandardQueryLogger = null;

        /// <summary>
        /// The standard database connection.
        /// </summary>
        private static ScriptDatabaseConnection StandardConnection = null;

        /// <summary>
        /// The underlying database connection.
        /// </summary>
        private ALFA.MySQLDatabase Database = null;

        /// <summary>
        /// Control flags.
        /// </summary>
        private ScriptDatabaseConnectionFlags Flags;
    }
}
