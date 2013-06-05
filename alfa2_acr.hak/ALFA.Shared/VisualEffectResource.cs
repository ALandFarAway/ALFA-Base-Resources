using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ALFA.Shared
{
    public class VisualEffectResource: IListBoxItem
    {
        public string Name;
        public string DisplayName;
        public string Classification { get; set; }
        public volatile string ResourceName;
        public string TemplateResRef;
        public string Tag;

        public VisualEffectResource() { }

        public void ConfigureDisplayName()
        {
            DisplayName = "  " + this.Name;
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
                return String.Format("LISTBOX_ITEM_TEXT={0}", this.DisplayName);
            }
        }

        public string Icon
        {
            get
            {
                return "LISTBOX_ITEM_ICON=vfx.tga";
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
            VisualEffectResource vfx = other as VisualEffectResource;
            if (vfx != null) return CompareTo(vfx);
            return 0;
        }

        public int CompareTo(VisualEffectResource other)
        {
            return Name.CompareTo(other.Name);
        }
    }
}
