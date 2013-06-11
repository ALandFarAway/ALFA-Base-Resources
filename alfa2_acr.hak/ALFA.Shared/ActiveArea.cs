using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ALFA.Shared
{
    public class ActiveArea : IComparable
    {
        public uint Id;
        public string Name;
        public string Tag;
        public Dictionary<ActiveTransition, ActiveArea> ExitTransitions = new Dictionary<ActiveTransition, ActiveArea>();

        public int CompareTo(object other)
        {
            ActiveArea otherArea = other as ActiveArea;
            if (otherArea != null)
            {
                return CompareTo(otherArea);
            }
            return 0;
        }
        public int CompareTo(ActiveArea other)
        {
            return Name.CompareTo(other.Name);
        }
    }
}
