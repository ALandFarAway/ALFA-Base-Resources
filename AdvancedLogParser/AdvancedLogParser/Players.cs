using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace AdvancedLogParser
{
    public static class Players
    {
        public static Dictionary<string, Player> ListByKey;
        public static Dictionary<uint, Player> ListByPlayerId;
    }

    public class Player
    {
        public List<uint> playerIds;
        public string CDKey;
        public List<string> CommunityIds;
        public DateTime FirstLogin;
        public DateTime LastLogin;
        public uint Logins;
        public bool IsDM;
        public bool IsBanned;
        public bool Is18Plus;
        public bool IsMember;
        public float DMTime;
        public List<Character> Characters;
    }
}
