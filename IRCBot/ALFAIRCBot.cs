using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;
using System.Threading;
using Meebey.SmartIrc4net;
using MySql.Data.MySqlClient;
using MySql.Data.Types;
using MySql.Data.Common;

namespace ALFAIRCBot
{
    internal class ALFAIRCBot
    {

        public ALFAIRCBot()
        {
            Client = new IrcClient();
            Client.OnChannelMessage += new IrcEventHandler(Client_OnChannelMessage);
            Client.OnErrorMessage += new IrcEventHandler(Client_OnErrorMessage);
            Client.OnError += new ErrorEventHandler(Client_OnError);
            Client.OnRawMessage += new IrcEventHandler(Client_OnRawMessage);
        }

        public void Run()
        {
            SetConnectionString();

            for (; ; )
            {
                Console.WriteLine("Connecting to server...");

                try
                {
                    string ClientVersion = "ALFAIRCBotv" + Assembly.GetExecutingAssembly().GetName().Version.ToString();

                    Client.ActiveChannelSyncing = true;
                    Client.AutoRejoinOnKick = true;
                    Client.AutoNickHandling = true;

                    Client.CtcpVersion = ClientVersion;
                    Client.Connect(ServerHostname, ServerPort);
                    Client.Login(Nickname, "ALFAStatus", 4, "ALFAStatus");
                    Client.SendMessage(SendType.Message, "NickServ", "identify " + NickservPassword);
                    Client.RfcJoin(HomeChannel);
                    Client.Listen();
                }
                catch (Exception e)
                {
                    Console.WriteLine("Exception: {0}", e);
                }

                if (Client.IsConnected)
                    Client.Disconnect();

                Console.WriteLine("Waiting to reconnect...");

                Thread.Sleep(60000);
            }
        }

        public string Nickname { get; set; }
        public string ServerHostname { get; set; }
        public int ServerPort { get; set; }
        public string HomeChannel { get; set; }
        public string NickservPassword { get; set; }

        public string DatabaseServer { get; set; }
        public string DatabaseUser { get;set; }
        public string DatabasePassword { get; set; }
        public string DatabaseSchema { get; set; }

        private void SetConnectionString()
        {
            ConnectionString = String.Format("Server={0};Uid={1};Password={2};Database={3};Max Pool Size=2;Pooling=true;Allow Batch=true",
                DatabaseServer,
                DatabaseUser,
                DatabasePassword,
                DatabaseSchema);
        }

        private void Client_OnChannelMessage(object sender, IrcEventArgs e)
        {
            if (e.Data.Channel != HomeChannel)
                return;

//          Console.WriteLine("Channel {0}: [{1}] {2}", e.Data.Channel, e.Data.From, e.Data.Message);

            if (e.Data.Message == "!players")
            {
                try
                {
                    ShowOnlinePlayers();
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Exception {0} handling !players query.", ex);

                    Client.SendMessage(SendType.Message, HomeChannel, "Internal error handling !players request.  The database server may be offline or unreachable.");
                }
            }
        }

        private void Client_OnErrorMessage(object sender, IrcEventArgs e)
        {
            Console.WriteLine("Error message: {0}", e.Data.Message);
        }

        private void Client_OnError(object sender, ErrorEventArgs e)
        {
            Console.WriteLine("Error: {0}", e.ErrorMessage);
        }

        private void Client_OnRawMessage(object sender, IrcEventArgs e)
        {
            Console.WriteLine("Raw: {0}", e.Data.RawMessage);
        }

        private class SERVER_DATA
        {
            public string Name;
            public int ServerId;
            public int Players;
            public int DMs;
        }

        private void ShowOnlinePlayers()
        {
            Dictionary<int, SERVER_DATA> ServerInfoTable = new Dictionary<int, SERVER_DATA>();
            SERVER_DATA ServerData = new SERVER_DATA();

            string QueryFmt =
                "SELECT " +
                    "COUNT(`characters`.`ID`) AS character_count, " +
                    "`servers`.`Name` AS server_name, " +
                    "`servers`.`ID` as server_id " +
                "FROM `characters` " +
                "INNER JOIN `players` ON `players`.`ID` = `characters`.`PlayerID` " +
                "INNER JOIN `servers` ON `servers`.`ID` = `characters`.`ServerID` " +
                "INNER JOIN `pwdata` ON `pwdata`.`Name` = `servers`.`Name` " +
                "WHERE `characters`.`IsOnline` = 1 " +
                "AND `players`.IsDM = {0} " +
                "AND pwdata.`Key` = 'ACR_TIME_SERVERTIME' " +
                "AND pwdata.`Last` >= DATE_SUB(CURRENT_TIMESTAMP, INTERVAL 10 MINUTE) " +
                "GROUP BY `characters`.`ServerID` "
                ;

            using (MySqlDataReader Reader = ExecuteQuery(String.Format(QueryFmt, 0)))
            {
                while (Reader.Read())
                {
                    int ServerId = Reader.GetInt32(2);

                    if (!ServerInfoTable.TryGetValue(ServerId, out ServerData))
                        ServerInfoTable.Add(ServerId, new SERVER_DATA());

                    ServerInfoTable[ServerId].Players = Reader.GetInt32(0);
                    ServerInfoTable[ServerId].Name = Reader.GetString(1);
                    ServerInfoTable[ServerId].ServerId = Reader.GetInt32(2);
                }
            }

            using (MySqlDataReader Reader = ExecuteQuery(String.Format(QueryFmt, 1)))
            {
                while (Reader.Read())
                {
                    int ServerId = Reader.GetInt32(2);

                    if (!ServerInfoTable.TryGetValue(ServerId, out ServerData))
                        continue;

                    ServerInfoTable[ServerId].DMs = Reader.GetInt32(0);
                }
            }

            StringBuilder Output = new StringBuilder("Servers with activity: " );
            bool First = true;

            if (ServerInfoTable.TryGetValue(3, out ServerData))
                ServerData.Name = "TSM";
            if (ServerInfoTable.TryGetValue(9, out ServerData))
                ServerData.Name = "MS";
            if (ServerInfoTable.TryGetValue(10, out ServerData))
                ServerData.Name = "BG";

            //
            // Now show the results.
            //

            foreach (SERVER_DATA Entry in ServerInfoTable.Values)
            {
                if (First == false)
                {
                    Output.Append("; ");
                }
                else
                {
                    First = false;
                }

                Output.AppendFormat("{0}: {1} player(s), {2} DM(s)",
                    Entry.Name,
                    Entry.Players,
                    Entry.DMs);
            }

            if (First)
                Client.SendMessage(SendType.Message, HomeChannel, "No players are logged on to any servers.");
            else
                Client.SendMessage(SendType.Message, HomeChannel, Output.ToString());

            /*
            ServerInfoTable[3].Name = "TSM";
            ServerInfoTable[9].Name = "BG";
            ServerInfoTable[10].Name = "MS";

            Console.WriteLine(String.Format(
                "{0}: {1} player(s), {2}DM(s); {3}: {4} player(s) and {5} DM(s); {6}: {7} player(s) and {8} DM(s)",
                ServerInfoTable[3].Name,
                ServerInfoTable[3].Players,
                ServerInfoTable[3].DMs,
                ServerInfoTable[10].Name,
                ServerInfoTable[10].Players,
                ServerInfoTable[10].DMs,
                ServerInfoTable[9].Name,
                ServerInfoTable[9].Players,
                ServerInfoTable[9].DMs));

            Client.SendMessage(SendType.Message, HomeChannel, String.Format(
                "{0}: {1} player(s), {2}DM(s); {3}: {4} player(s) and {5} DM(s); {6}: {7} player(s) and {8} DM(s)",
                ServerInfoTable[3].Name,
                ServerInfoTable[3].Players,
                ServerInfoTable[3].DMs,
                ServerInfoTable[10].Name,
                ServerInfoTable[10].Players,
                ServerInfoTable[10].DMs,
                ServerInfoTable[9].Name,
                ServerInfoTable[9].Players,
                ServerInfoTable[9].DMs));
             */
        }

        private MySqlDataReader ExecuteQuery(string Query)
        {
            return MySqlHelper.ExecuteReader(ConnectionString, Query);
        }

        private IrcClient Client;

        private string ConnectionString;
    }
}
