using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ALFA.Shared
{
    public class ItemResource: IListBoxItem
    {
        public volatile string LocalizedName;
        public volatile string DisplayName;
        public volatile string Classification;
        public volatile string TemplateResRef;
        public volatile string Tag;
        private volatile int _cost;
        public int Cost
        {
            get
            {
                return _cost;
            }
            set
            {
                if (value > 188500) AppropriateLevel = 20;
                else if (value > 143000) AppropriateLevel = 19;
                else if (value > 110500) AppropriateLevel = 18;
                else if (value > 84500) AppropriateLevel = 17;
                else if (value > 65000) AppropriateLevel = 16;
                else if (value > 48750) AppropriateLevel = 15;
                else if (value > 35750) AppropriateLevel = 14;
                else if (value > 28650) AppropriateLevel = 13;
                else if (value > 21450) AppropriateLevel = 12;
                else if (value > 15925) AppropriateLevel = 11;
                else if (value > 11700) AppropriateLevel = 10;
                else if (value > 8775) AppropriateLevel = 9;
                else if (value > 6175) AppropriateLevel = 8;
                else if (value > 4225) AppropriateLevel = 7;
                else if (value > 2925) AppropriateLevel = 6;
                else if (value > 1750) AppropriateLevel = 5;
                else if (value > 875) AppropriateLevel = 4;
                else if (value > 300) AppropriateLevel = 3;
                else AppropriateLevel = 1;
                _cost = value;
            }
        }
        public int AppropriateLevel
        {
            get;
            private set;
        }
        public volatile int BaseItem;
        public volatile bool Cursed;
        public volatile bool Plot;
        public volatile bool Stolen;

        public ItemResource() { }

        public void ConfigureDisplayName()
        {
            DisplayName = "  " + this.LocalizedName;
            DisplayName = DisplayString.ShortenStringToWidth(DisplayName, 150);
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
                return String.Format("LISTBOX_ITEM_TEXT={0};LISTBOX_ITEM_TEXT2= {1};LISTBOX_ITEM_TEXT3= {2}", this.DisplayName, this.Cost, this.AppropriateLevel);
            }
        }

        public string Icon
        {
            get
            {
                return "LISTBOX_ITEM_ICON=item.tga";
            }
        }

        public string Variables
        {
            get
            {
                return String.Format("5={0}", this.TemplateResRef);
            }
        }

        public int CompareTo(IListBoxItem other)
        {
            ItemResource item = other as ItemResource;
            if (item != null) return CompareTo(item);
            return 0;
        }

        public int CompareTo(ItemResource other)
        {
            if (Sorting.Column == 2)
            {
                return Cost.CompareTo(other.Cost);
            }
            else if (Sorting.Column == 3)
            {
                return AppropriateLevel.CompareTo(other.AppropriateLevel);
            }
            else
            {
                return LocalizedName.CompareTo(other.LocalizedName);
            }
        }
    }
}

