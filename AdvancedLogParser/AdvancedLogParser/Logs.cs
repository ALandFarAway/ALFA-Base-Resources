using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace AdvancedLogParser
{
    static class Logs
    {
        public static List<Log> AdvancementAlerts;
        public static List<Log> EnforcementAlerts;
        public static List<Log> DeathAlerts;
        public static List<Log> RecentLogins;
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
