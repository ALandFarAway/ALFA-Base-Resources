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
    /// </summary>
    public class MySQLDatabase : IALFADatabase
    {

        /// <summary>
        /// Create a new database object (which can be shared by multiple
        /// script objects).
        /// </summary>
        public MySQLDatabase()
        {
            LinkToMySQLAssembly();
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
        /// This routine returns the specified column of data form the current
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
        /// This method links to the MySQL assembly, ensuring that the
        /// assembly is loaded.  If necessary the assembly is loaded from the
        /// NWNX4 installation directory.
        /// </summary>
        private void LinkToMySQLAssembly()
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

            Implementation = new MySQLDatabaseInternal();
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
    internal class MySQLDatabaseInternal
    {

        /// <summary>
        /// Create a new MySQLDatabaseInternal object.
        /// </summary>
        internal MySQLDatabaseInternal()
        {
            SetupConnectionString();
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
            return DataReader.Read();
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
            DataReader = MySqlHelper.ExecuteReader(ConnectionString, SQL);
        }

        /// <summary>
        /// This method sets up the database connection string based on the
        /// default connection information set for the MySQL plugin.
        /// </summary>
        private void SetupConnectionString()
        {
            SystemInfo.SQLConnectionSettings ConnectionSettings = SystemInfo.GetSQLConnectionSettings();

            ConnectionString = String.Format("Server={0};Uid={1};Password={2};Database={3}",
                ConnectionSettings.Server,
                ConnectionSettings.User,
                ConnectionSettings.Password,
                ConnectionSettings.Schema);
        }

        /// <summary>
        /// The database connection string is maintained here.
        /// </summary>
        private string ConnectionString;

        /// <summary>
        /// The current data reader is stored here (if any).
        /// </summary>
        private MySqlDataReader DataReader = null;
    }
}
