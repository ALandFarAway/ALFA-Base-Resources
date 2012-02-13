using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;
using System.Configuration;

namespace ALFAIRCBot
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("ALFAIRCbot - version {0} starting up.", Assembly.GetExecutingAssembly().GetName().Version.ToString());
            ALFAIRCBot IRCBot = new ALFAIRCBot();

            try
            {
                IRCBot.Nickname = Properties.Settings.Default.Nickname;
                IRCBot.ServerHostname = Properties.Settings.Default.ServerHostname;
                IRCBot.ServerPort = Properties.Settings.Default.ServerPort;
                IRCBot.HomeChannels = Properties.Settings.Default.HomeChannels;
                IRCBot.NickservPassword = Properties.Settings.Default.NickservPassword;
                IRCBot.DatabaseServer = Properties.Settings.Default.DatabaseServer;
                IRCBot.DatabaseUser = Properties.Settings.Default.DatabaseUser;
                IRCBot.DatabasePassword = Properties.Settings.Default.DatabasePassword;
                IRCBot.DatabaseSchema = Properties.Settings.Default.DatabaseSchema;
                IRCBot.BingAppID = Properties.Settings.Default.BingAppID;
                IRCBot.PageFromPlayerName = Properties.Settings.Default.PageFromPlayerName;
            }
            catch (Exception e)
            {
                Console.WriteLine("Exception reading configuration file: {0}", e);
                return;
            }

            Console.WriteLine("Configuration processed.");

            IRCBot.Run();
        }
    }
}
