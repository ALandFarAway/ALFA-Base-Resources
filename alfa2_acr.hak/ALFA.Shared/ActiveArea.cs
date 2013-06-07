using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ALFA.Shared
{
    public class ActiveArea
    {
        public uint Id;
        public string Name;
        public string Tag;
        public Dictionary<ActiveTransition, ActiveArea> ExitTransitions = new Dictionary<ActiveTransition, ActiveArea>();
    }
}
