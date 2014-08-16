//
// This module contains logic for interfacing with the ALFA database system via
// the MySQL connection pool.  The MySQL NWNX4 plugin connection is not used.
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
using ALFA.Shared;
using MySql;
using MySql.Data;
using MySql.Data.MySqlClient;

using NWEffect = NWScript.NWScriptEngineStructure0;
using NWEvent = NWScript.NWScriptEngineStructure1;
using NWLocation = NWScript.NWScriptEngineStructure2;
using NWTalent = NWScript.NWScriptEngineStructure3;
using NWItemProperty = NWScript.NWScriptEngineStructure4;

namespace ALFA
{
    /// <summary>
    /// This class encapsulates database access for ALFA CLR scripts that uses
    /// an independent MySQL connection.
    ///
    /// N.B.  Most code should NOT use a MySQLDatabase object, because doing so
    ///       may monopolize a valuable connection pool connection.
    ///
    ///       Use ALFA.ALFADatabase instead for most SQL accesses UNLESS they
    ///       must be done from a dedicated thread context, like the
    ///       ACR_ServerCommunicator GameWorldManager query thread.
    /// </summary>
    public class MySQLDatabase : IALFADatabase, IDisposable
    {

        /// <summary>
        /// Create a new database object (which can be shared by multiple
        /// script objects).
        /// </summary>
        /// <param name="ConnectionString">Optionally supplies an overload
        /// connection string.  If null, the default string is built from the
        /// NWNX MySQL plugin's configuration file.</param>
        /// <param name="Dedicated">Supplies true if the database object is to
        /// use a dedicated connection.</param>
        public MySQLDatabase(string ConnectionString = null, bool Dedicated = false)
        {
            LinkToMySQLAssembly(ConnectionString, Dedicated);
        }

        /// <summary>
        /// This routine escapes characters for a SQL query.
        /// </summary>
        /// <param name="s">Supplies the string to escape.</param>
        /// <returns>The escaped string is returned.</returns>
        public string ACR_SQLEncodeSpecialChars(string s)
        {
            return Implementation.ACR_SQLEncodeSpecialChars(s);
        }

        /// <summary>
        /// This routine fetches the next rowset from the database.
        /// </summary>
        /// <returns>Returns true if the query succeeded.</returns>
        public bool ACR_SQLFetch()
        {
            return Implementation.ACR_SQLFetch();
        }

        /// <summary>
        /// This routine returns the first column of data from the current SQL
        /// rowset.
        /// </summary>
        /// <returns>The column data is returned</returns>
        public string ACR_SQLGetData()
        {
            return Implementation.ACR_SQLGetData();
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
            return Implementation.ACR_SQLGetData(ColumnIndex);
        }

        /// <summary>
        /// This routine returns the number of rows affected by a query.
        /// </summary>
        /// <returns>The row count is returned.</returns>
        public int ACR_SQLGetAffectedRows()
        {
            return Implementation.ACR_SQLGetAffectedRows();
        }

        /// <summary>
        /// This routine performs a synchronous SQL query.  If there were
        /// pending asynchronous queries in the queue, the pending queries are
        /// drained first.
        /// </summary>
        /// <param name="SQL">Supplies the SQL query text to execute.</param>
        public void ACR_SQLQuery(string SQL)
        {
            Implementation.ACR_SQLQuery(SQL);
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
            Implementation.ACR_SQLExecute(SQL);
        }

        /// <summary>
        /// Increment a global tracking statistic counter stored in the
        /// database (if statistic tracking was enabled).
        /// </summary>
        /// <param name="Statistic">Supplies the counter name.</param>
        public void ACR_IncrementStatistic(string Statistic)
        {
            Implementation.ACR_SQLExecute(String.Format(
                "INSERT INTO `stat_counters` (`Name`, `Value`, `LastUpdate`) " +
                "VALUES ('{0}', 1, NOW()) " +
                "ON DUPLICATE KEY UPDATE `Value` = `Value` + 1, " +
                "`LastUpdate`=NOW()",
                Implementation.ACR_SQLEncodeSpecialChars(Statistic)));
        }

        /// <summary>
        /// Dispose the object.
        /// </summary>
        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        /// <summary>
        /// Dispose the object.
        /// </summary>
        /// <param name="Disposing">Supplies true if called from Dispose.</param>
        private void Dispose(bool Disposing)
        {
            if (Implementation != null)
            {
                Implementation.Dispose();
                Implementation = null;
            }
        }

        /// <summary>
        /// This method links to the MySQL assembly, ensuring that the
        /// assembly is loaded.  If necessary the assembly is loaded from the
        /// NWNX4 installation directory.
        /// </summary>
        /// <param name="ConnectionString">Optionally supplies an overload
        /// connection string.  If null, the default string is built from the
        /// NWNX MySQL plugin's configuration file.</param>
        /// <param name="Dedicated">Supplies true if the database object is to
        /// use a dedicated connection.</param>
        private void LinkToMySQLAssembly(string ConnectionString = null, bool Dedicated = false)
        {
            AppDomain CurrentDomain = AppDomain.CurrentDomain;

            MySQLAssembly = SystemInfo.LoadAssemblyFromNWNX4("MySql.Data.dll");

            CurrentDomain.AssemblyResolve += new ResolveEventHandler(LinkToMySQLAssembly_AssemblyResolve);

            try
            {
                ForceLoadMySQL();
            }
            finally
            {
                CurrentDomain.AssemblyResolve -= new ResolveEventHandler(LinkToMySQLAssembly_AssemblyResolve);
            }

            Implementation = new MySQLDatabaseInternal(ConnectionString, Dedicated);
        }

        /// <summary>
        /// This method forces MySQL.Data.dll to be loaded and linked.
        /// </summary>
        private void ForceLoadMySQL()
        {
            //
            // Just create and delete a dummy connection object.  This will
            // force a type reference to MySql.Data.dll while we have the
            // assembly resolve handler setup.
            //

            using (MySqlConnection DummyConnection = new MySqlConnection())
            {
                GC.KeepAlive(DummyConnection);
            }
        }

        /// <summary>
        /// This assembly resolve handler is designed to handle a failure to
        /// resolve the MySQL.Data.dll assembly.  It returns the pre-loaded
        /// assembly for linkage.
        /// </summary>
        /// <param name="sender">Supplies the object sender.</param>
        /// <param name="args">Supplies the event arguments.</param>
        /// <returns>The located assembly, else null.</returns>
        private Assembly LinkToMySQLAssembly_AssemblyResolve(object sender, ResolveEventArgs args)
        {
            if (args.RequestingAssembly == Assembly.GetExecutingAssembly() &&
                args.Name == MySQLAssembly.FullName)
            {
                return MySQLAssembly;
            }

            return null;
        }

        /// <summary>
        /// The database implementation is stored here.
        /// </summary>
        private MySQLDatabaseInternal Implementation;

        /// <summary>
        /// The MySQL assembly is stored here, for the assembly resolve event.
        /// </summary>
        private Assembly MySQLAssembly = null;
    }

    /// <summary>
    /// This wrapper class shields callers of MySQLDatabase from needing to
    /// immediately demand that the MySql.Data.dll assembly be loaded.
    /// </summary>
    internal class MySQLDatabaseInternal : IDisposable
    {

        /// <summary>
        /// Create a new MySQLDatabaseInternal object.
        /// </summary>
        /// <param name="ConnectionString">Optionally supplies an overload
        /// connection string.  If null, the default string is built from the
        /// NWNX MySQL plugin's configuration file.</param>
        /// <param name="Dedicated">Supplies true if the database object is to
        /// use a dedicated connection.</param>
        internal MySQLDatabaseInternal(string ConnectionString = null, bool Dedicated = false)
        {
            this.Dedicated = Dedicated;

            if (ConnectionString == null)
                SetupConnectionString();
            else
                this.ConnectionString = ConnectionString;
        }

        /// <summary>
        /// This routine escapes characters for a SQL query.
        /// </summary>
        /// <param name="s">Supplies the string to escape.</param>
        /// <returns>The escaped string is returned.</returns>
        public string ACR_SQLEncodeSpecialChars(string s)
        {
            return MySqlHelper.EscapeString(s);
        }

        /// <summary>
        /// This routine fetches the next rowset from the database.
        /// </summary>
        /// <returns>Returns true if the query succeeded.</returns>
        public bool ACR_SQLFetch()
        {
            bool Status = DataReader.Read();

            if (Status == false)
            {
                DataReader.Dispose();
                DataReader = null;
            }

            return Status;
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
            if (DataReader.IsDBNull(ColumnIndex))
                return null;
            else
                return DataReader.GetString(ColumnIndex);
        }

        /// <summary>
        /// This routine returns the number of rows affected by a query.
        /// </summary>
        /// <returns>The row count is returned.</returns>
        public int ACR_SQLGetAffectedRows()
        {
            return DataReader.RecordsAffected;
        }

        /// <summary>
        /// This routine performs a synchronous SQL query.  If there were
        /// pending asynchronous queries in the queue, the pending queries are
        /// drained first.
        /// </summary>
        /// <param name="SQL">Supplies the SQL query text to execute.</param>
        public void ACR_SQLQuery(string SQL)
        {
            if (DataReader != null)
            {
                DataReader.Dispose();
                DataReader = null;
            }

            SQL = PrepareSQL(SQL);

            if (Dedicated == false)
            {
                DataReader = MySqlHelper.ExecuteReader(ConnectionString, SQL);
            }
            else
            {
                bool Succeeded = false;

                ConnectDatabase();

                try
                {
                    DataReader = MySqlHelper.ExecuteReader(Connection, SQL);
                    Succeeded = true;
                }
                finally
                {
                    if (Succeeded == false)
                        FailedQueries += 1;
                    else
                        FailedQueries = 0;
                }
            }
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
            if (DataReader != null)
            {
                DataReader.Dispose();
                DataReader = null;
            }

            SQL = PrepareSQL(SQL);

            if (Dedicated == false)
            {
                using (MySqlDataReader Reader = MySqlHelper.ExecuteReader(ConnectionString, SQL))
                {

                }
            }
            else
            {
                bool Succeeded = false;

                ConnectDatabase();

                try
                {
                    using (MySqlDataReader Reader = MySqlHelper.ExecuteReader(Connection, SQL))
                    {

                    }

                    Succeeded = true;
                }
                finally
                {
                    if (!Succeeded)
                        FailedQueries += 1;
                    else
                        FailedQueries = 0;
                }
            }
        }

        /// <summary>
        /// This routine advances to the next result set of a multi-result
        /// query.
        /// </summary>
        /// <returns>True if the operation succeeded.</returns>
        private bool ACR_SQLNextResult()
        {
            return DataReader.NextResult();
        }

        /// <summary>
        /// This method sets up the database connection string based on the
        /// default connection information set for the MySQL plugin.
        /// 
        /// The pool size of 3 is based on :
        /// 
        /// - One connection for polling for input by the GameWorldManager
        ///   synchronization thread.
        /// 
        /// - One connection for background ad-hoc queries kicked off by the
        ///   server communicator on work items (account record lookup, etc.).
        /// 
        /// - One connection for miscellaneous use.
        /// </summary>
        private void SetupConnectionString()
        {
            SystemInfo.SQLConnectionSettings ConnectionSettings = SystemInfo.GetSQLConnectionSettings();

            ConnectionString = String.Format("Server={0};Uid={1};Password={2};Allow Batch=true",
                ConnectionSettings.Server,
                ConnectionSettings.User,
                ConnectionSettings.Password,
                ConnectionSettings.Schema);

            //
            // If a dedicated connection is not in use, prepend the database
            // with a USE statement to slightly increase performance.
            //

            if (Dedicated == false)
            {
                ConnectionString += ";Max Pool Size=3;Pooling=true";

                this.DatabaseName = ConnectionSettings.Schema;
                this.QueryPrepend = String.Format("USE {0}; ", DatabaseName);
            }
            else
            {
                //
                // Explicitly set the database for a dedicated connection.
                //

                ConnectionString += String.Format(";Database={0}", ConnectionSettings.Schema);
            }
        }

        /// <summary>
        /// Dispose the object.
        /// </summary>
        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        /// <summary>
        /// Dispose the object.
        /// </summary>
        /// <param name="Disposing">Supplies true if called from Dispose.</param>
        private void Dispose(bool Disposing)
        {
            if (DataReader != null)
            {
                DataReader.Dispose();
                DataReader = null;
            }

            if (Connection != null)
            {
                Connection.Dispose();
                Connection = null;
            }
        }

        /// <summary>
        /// Prepare a query string for execution.  Currently, this prepend a
        /// USE DatabaseName; statement to improve latency (see discussion
        /// below with DatabaseName).
        /// </summary>
        /// <param name="SQL">Supplies the query text.</param>
        /// <returns>The actual query text to execute is returned.</returns>
        private string PrepareSQL(string SQL)
        {
            if (String.IsNullOrEmpty(QueryPrepend))
                return SQL;

            return QueryPrepend + SQL;
        }

        /// <summary>
        /// Connect a dedicated connection to the database.
        /// </summary>
        private void ConnectDatabase()
        {
            if (Connection != null)
            {
                try
                {
                    if (Connection.State != System.Data.ConnectionState.Open)
                    {
                        Logger.Log("MySQLDatabaseInternal.ConnectDatabase: Reconnecting to the database...");
                        Connection.Open();
                        FailedQueries = 0;
                        return;
                    }
                    else if (FailedQueries >= FAILED_QUERY_LIMIT)
                    {
                        Logger.Log("MySQLDatabaseInternal.ConnectDatabase: Too many consecutive failed queries, abandoning existing connection.");
                        Connection.Dispose();
                        Connection = null;
                    }
                    else
                    {
                        return;
                    }
                }
                catch (Exception e)
                {
                    Logger.Log("MySQLDatabaseInternal.ConnectDatabase: Trying new connection due to exception opening existing connection: {0}", e);
                    Connection.Dispose();
                    Connection = null;
                }
            }

            Logger.Log("MySQLDatabaseInternal.ConnectDatabase: Connecting to the database...");

            MySqlConnection NewConnection = new MySqlConnection(ConnectionString);
            bool Succeeded = false;

            try
            {
                NewConnection.Open();
                Succeeded = true;
                FailedQueries = 0;
            }
            finally
            {
                if (!Succeeded)
                    NewConnection.Dispose();
                else
                    Connection = NewConnection;
            }
        }

        /// <summary>
        /// The database connection string is maintained here.
        /// </summary>
        private string ConnectionString;

        /// <summary>
        /// The database name to use for the connection.
        /// 
        /// This could be set via the connection string.  Doing so, however,
        /// imposes a substantial latency penalty because the MySQL library
        /// sends a change database packet (a full round trip delay) for each
        /// query even over a pooled connection even if the previous database
        /// of the connection matched.
        /// 
        /// As a result, explicitly prepend a "USE DatabaseName;" to each query
        /// and do not use an explicit database in the connection string.
        /// </summary>
        private string DatabaseName = null;

        /// <summary>
        /// The prepended string for each query.
        /// </summary>
        private string QueryPrepend = null;

        /// <summary>
        /// The current data reader is stored here (if any).
        /// </summary>
        private MySqlDataReader DataReader = null;

        /// <summary>
        /// True if this instance uses a dedicated database connection.
        /// </summary>
        private bool Dedicated = false;

        /// <summary>
        /// The dedicated database connection object, if it exists.  Only used
        /// if Dedicated is true.
        /// </summary>
        private MySqlConnection Connection = null;

        /// <summary>
        /// Count of queries failed on this connection, to guard against an
        /// issue with the connection library where it does not recycle a
        /// broken connection properly.
        /// </summary>
        private int FailedQueries = 0;

        /// <summary>
        /// The maximum number of queries that can fail before a reconnect
        /// will be forced.
        /// </summary>
        private const int FAILED_QUERY_LIMIT = 3;
    }
}
