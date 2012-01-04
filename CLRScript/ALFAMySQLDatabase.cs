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
        /// <param name="ScriptBase">Supplies the associated script base class
        /// object, used to access script APIs.</param>
        public MySQLDatabase(CLRScriptBase ScriptBase)
        {
            Script = ScriptBase;

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
        /// A link to the associated script program object is maintained here.
        /// </summary>
        private CLRScriptBase Script;

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
