using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ALFA.Shared
{
    public class PlaceableResource: IListBoxItem
    {
        public volatile string Name;
        public volatile string DisplayName;
        public string Classification { get; set; }
        public volatile string ResourceName;
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
                string inventory = "";
                if (this.HasInventory) inventory = "Inv";
                string lockTrap = "";
                if (this.Locked && this.Trapped) lockTrap = String.Format("L{0}/T{1}", this.LockDC, this.TrapDisarmDC);
                else if (this.Locked) lockTrap = String.Format("L{0}", this.LockDC);
                else if (this.Trapped) lockTrap = String.Format("T{0}", this.TrapDisarmDC);

                return String.Format("LISTBOX_ITEM_TEXT={0};LISTBOX_ITEM_TEXT2= {1};LISTBOX_ITEM_TEXT3= {2}", this.DisplayName, lockTrap, inventory);
            }
        }

        public string Icon
        {
            get
            {
                return "LISTBOX_ITEM_ICON=placeable.tga";
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
            PlaceableResource place = other as PlaceableResource;
            if (place != null) return CompareTo(place);
            return 0;
        }

        public int CompareTo(PlaceableResource other)
        {
            if (Sorting.Column == 2)
            {
                if (LockDC == other.LockDC)
                {
                    return TrapDisarmDC.CompareTo(other.TrapDisarmDC);
                }
                else return LockDC.CompareTo(other.LockDC);
            }
            else if (Sorting.Column == 3)
            {
                return HasInventory.CompareTo(other.HasInventory);
            }
            else
            {
                return Name.CompareTo(other.Name);
            }
        }
    }
}