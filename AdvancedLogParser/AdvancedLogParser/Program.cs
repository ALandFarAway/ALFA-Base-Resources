using System;
using System.Configuration;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Forms;

namespace AdvancedLogParser
{
    static class Program
    {
        public const int ServerFocus = -1;
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);

            InfoGather.DatabasePassword = ConfigurationSettings.AppSettings["DatabasePassword"];
            InfoGather.DatabaseSchema = ConfigurationSettings.AppSettings["DatabaseSchema"];
            InfoGather.DatabaseServer = ConfigurationSettings.AppSettings["DatabaseServer"];
            InfoGather.DatabaseUser = ConfigurationSettings.AppSettings["DatabaseUser"];
            InfoGather.BuildConnectionString();
            Players.ListByPlayerId = new Dictionary<uint, Player>();
            Players.ListByKey = new Dictionary<string, Player>();
            Characters.List = new Dictionary<uint, Character>();
            Logs.AdvancementAlerts = new Dictionary<uint, Log>();
            Logs.DeathAlerts = new Dictionary<uint, Log>();
            Logs.EnforcementAlerts = new Dictionary<uint, Log>();
            Logs.RecentLogins = new Dictionary<uint, Log>();
            Servers.List = new Dictionary<uint, Server>();
            if (InfoGather.GetPlayers())
            {
                InfoGather.GetCharacters();
                InfoGather.GetAlerts();
                InfoGather.GetLogins();
                InfoGather.IdentifyLogins();
                InfoGather.GetDMTime();
                InfoGather.currentLoader.Close();
                InfoGather.currentLoader.Dispose();
                if (ServerFocus >= 0)
                {
                    foreach (Server srv in Servers.List.Values)
                    {
                        if (srv.ServerId == Math.Abs(ServerFocus))
                        {
                            Application.Run(new ServerView(srv));
                        }
                    }
                }
                else
                {
                    new ServerView(null).Show();
                    Application.Run(new PrimaryDisplay());
                }
            }
        }
    }
}
