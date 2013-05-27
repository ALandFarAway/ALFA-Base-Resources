using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace AdvancedLogParser
{
    static class Logs
    {
        public static Dictionary<uint, Log> AdvancementAlerts;
        public static Dictionary<uint, Log> EnforcementAlerts;
        public static Dictionary<uint, Log> DeathAlerts;
        public static Dictionary<uint, Log> RecentLogins;
    }

    public class Log
    {
        public uint Id;
        public ushort ServerId;
        public uint CharacterId;
        public string Event;
        public string EventDescription;
        public DateTime Time;
        public uint DMId;
    }
}
