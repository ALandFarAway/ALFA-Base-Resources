using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ALFA.Shared
{
    public class PlaceableResource
    {
        public volatile string Name;
        public volatile string Classification;
        public volatile string TemplateResRef;
        public volatile string Tag;
        public volatile bool Useable;
        public volatile bool HasInventory;
        public volatile bool Trapped;
        public volatile int TrapDetectDC;
        public volatile int TrapDisarmDC;
        public volatile bool Locked;
        public volatile int LockDC;

        public PlaceableResource() { }

        public int CompareTo(PlaceableResource other)
        {
            if (other == null) return 1;
            if (other.Name == null) return 1;
            if (String.IsNullOrEmpty(other.Name)) return 1;
            if (this == null) return -1;
            if (Name == null) return -1;
            if (String.IsNullOrEmpty(Name)) return -1;

            return Name.CompareTo(other.Name);
        }
    }
}