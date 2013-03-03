using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ACR_ChooserCreator
{
    public class NavigatorItem : IComparable<NavigatorItem>
    {
        public volatile string DisplayName;
        public volatile string Name;
        public volatile string Info1;
        public volatile string Info2;
        public volatile string Icon;
        public volatile string ResRef;
        public volatile string Vars;

        public int CompareTo(NavigatorItem other)
        {
            if (other == null) return 1;
            if (other.Name == null) return 1;
            if (String.IsNullOrEmpty(other.Name)) return 1;

            return Name.CompareTo(other.Name);
        }
    }
}
