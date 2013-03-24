using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ACR_ChooserCreator
{
    public class NavigatorCategory : IComparable<NavigatorCategory>
    {
        public volatile string DisplayName;
        public volatile string Name;
        public volatile NavigatorCategory ParentCategory = null;
        public volatile List<NavigatorCategory> ContainedCategories = new List<NavigatorCategory>();
        public volatile List<ALFA.Shared.IListBoxItem> ContainedItems = new List<ALFA.Shared.IListBoxItem>();

        public int CompareTo(NavigatorCategory other)
        {
            if (other == null) return 1;
            if (other.Name == null) return 1;
            if (String.IsNullOrEmpty(other.Name)) return 1;

            return Name.CompareTo(other.Name);
        }
    }
}
