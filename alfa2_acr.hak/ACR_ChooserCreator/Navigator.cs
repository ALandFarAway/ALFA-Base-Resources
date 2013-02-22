using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ACR_ChooserCreator
{
    public static class Navigators
    {
        public static Navigator CreatureNavigator = new Navigator();
        public static Navigator ItemNavigator = new Navigator();
        public static Navigator PlaceableNavigator = new Navigator();
    }

    public class Navigator: ALFA.Shared.IBackgroundLoadedResource
    {
        public bool ResourcesLoaded { get; set; }
        public NavigatorCategory bottomCategory = new NavigatorCategory();
    }
}
