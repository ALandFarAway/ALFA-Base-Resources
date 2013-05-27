using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace AdvancedLogParser
{
    public static class Servers
    {
        public static Dictionary<uint, Server> List;
    }

    public class Server
    {
        public Server()
        {
            RecentCharacters = new List<Character>();
            RecentPlayers = new List<Player>();
            RecentDMs = new List<Player>();
        }
        public uint ServerId;
        public List<Character> RecentCharacters;
        public List<Player> RecentPlayers;
        public List<Player> RecentDMs;
    }
}
