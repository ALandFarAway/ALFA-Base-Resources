using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ALFA.Shared
{
    public class PlaceableResource
    {
        public string Name;
        public string Classification;
        public string TemplateResRef;
        public string Tag;
        public bool Useable;
        public bool HasInventory;
        public bool Trapped;
        public int TrapDetectDC;
        public int TrapDisarmDC;
        public bool Locked;
        public int LockDC;

        public PlaceableResource() { }
    }
}