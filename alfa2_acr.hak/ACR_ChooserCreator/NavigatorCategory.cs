using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ACR_ChooserCreator
{
    public class NavigatorCategory
    {
        public string Name;
        public NavigatorCategory ParentCategory;
        public List<NavigatorCategory> ContainedCategories;
        public List<NavigatorItem> ContainedItems;
    }
}
