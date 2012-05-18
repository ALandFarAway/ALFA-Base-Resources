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
            RestartWatchdogTimeout = 0;
            AccountAssociationSecret = "";
            AccountAssociationUrl = "";
            GetHostnameUrl = "";
            DefaultIrcGatewayId = 0;
            DefaultIrcRecipient = "";
        }

        /// <summary>
        /// This method reads the current configuration data from the
        /// database.
        /// </summary>
        /// <param name="Database">Supplies the database connection.</param>
        public void ReadConfigurationFromDatabase(IALFADatabase Database)
        {
            Database.ACR_SQLQuery("SELECT `variable`, `value` FROM `config`");

            while (Database.ACR_SQLFetch())
            {
                string VarName = Database.ACR_SQLGetData(0);
                string VarValue = Database.ACR_SQLGetData(1);

                if (VarName == "PlayerPassword")
                    PlayerPassword = VarValue;
                else if (VarName == "RestartWatchdogTimeout")
                    RestartWatchdogTimeout = Convert.ToInt32(VarValue);
                else if (VarName == "AccountAssociationSecret")
                    AccountAssociationSecret = VarValue;
                else if (VarName == "AccountAssociationUrl")
                    AccountAssociationUrl = VarValue;
                else if (VarName == "GetHostnameUrl")
                    GetHostnameUrl = VarValue;
                else if (VarName == "DefaultIrcGatewayId")
                    DefaultIrcGatewayId = Convert.ToInt32(VarValue);
                else if (VarName == "DefaultIrcRecipient")
                    DefaultIrcRecipient = VarValue;
            }
        }

        /// <summary>
        /// This property describes the player password for servers.
        /// </summary>
        public string PlayerPassword { get; set; }

        /// <summary>
        /// This property describes the number of seconds before the server is
        /// forcibly terminated after a restart request has begun.
        /// </summary>
        public int RestartWatchdogTimeout { get; set; }

        /// <summary>
        /// This property defines the association secret used to create the
        /// verification hash in the URL that is used to connect a game account
        /// to a forum account.
        /// </summary>
        public string AccountAssociationSecret { get; set; }

        /// <summary>
        /// This property defines the base URL of the account association
        /// service.
        /// </summary>
        public string AccountAssociationUrl { get; set; }

        /// <summary>
        /// This property defines the base URL of the get hostname service.
        /// </summary>
        public string GetHostnameUrl { get; set; }

        /// <summary>
        /// The default IRC gateway ID to use for server-to-IRC messages.  The
        /// value matches a configured ALFA IRC Bot's IRCGateway config.xml
        /// entry.
        /// </summary>
        public int DefaultIrcGatewayId { get; set; }

        /// <summary>
        /// The default IRC recipient to use for server-to-IRC messages.
        /// </summary>
        public string DefaultIrcRecipient { get; set; }

    }
}
