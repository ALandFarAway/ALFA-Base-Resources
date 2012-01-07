using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ALFA;

namespace ACR_ServerCommunicator
{
    /// <summary>
    /// This object encapsulates configuration data relating to the game system
    /// as a whole.
    /// </summary>
    class GameWorldConfiguration
    {

        /// <summary>
        /// Create a new GameWorldConfiguration object.
        /// </summary>
        public GameWorldConfiguration()
        {
            PlayerPassword = "";
        }

        /// <summary>
        /// This method reads the current configuration data from the
        /// database.
        /// </summary>
        /// <param name="Database">Supplies the database connection.</param>
        public void ReadConfigurationFromDatabase(IALFADatabase Database)
        {
            Database.ACR_SQLQuery(
                "SELECT value FROM config WHERE variable = 'PlayerPassword'");

            if (Database.ACR_SQLFetch())
                PlayerPassword = Database.ACR_SQLGetData(0);
        }

        /// <summary>
        /// This property describes the player password for servers.
        /// </summary>
        public string PlayerPassword { get; set; }

    }
}
