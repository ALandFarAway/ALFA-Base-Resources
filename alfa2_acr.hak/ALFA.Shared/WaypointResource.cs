using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ALFA.Shared
{
    public class WaypointResource: IListBoxItem
    {
        public string Name;
        public string DisplayName;
        public string Classification { get; set; }
        public volatile string ResourceName;
        public string TemplateResRef;
        public string Tag;

        public WaypointResource() { }

        public void ConfigureDisplayName()
        {
            DisplayName = "  " + this.Name;
            DisplayName = DisplayString.ShortenStringToWidth(DisplayName, 214);
        }

        public string RowName
        {
            get
            {
                return this.TemplateResRef;
            }
        }

        public string TextFields
        {
            get
            {
                return String.Format("LISTBOX_ITEM_TEXT={0}", this.DisplayName);
            }
        }

        public string Icon
        {
            get
            {
                return "LISTBOX_ITEM_ICON=waypoint.tga";
            }
        }

        public string Variables
        {
            get
            {
                return String.Format("5={0}", this.ResourceName);
            }
        }

        public int CompareTo(IListBoxItem other)
        {
            WaypointResource way = other as WaypointResource;
            if (way != null) return CompareTo(way);
            return 0;
        }

        public int CompareTo(WaypointResource other)
        {
            return Name.CompareTo(other.Name);
        }
    }
}
