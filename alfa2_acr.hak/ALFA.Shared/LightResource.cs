using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ALFA.Shared
{
    public class LightResource: IListBoxItem
    {
        public string Name;
        public string DisplayName;
        public string Classification { get; set; }
        public string ResourceName;
        public string TemplateResRef;
        public string Tag;

        public float ShadowIntensity;
        public float LightRange;
        public float LightIntensity;

        public LightResource() { }

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
                return String.Format("LISTBOX_ITEM_TEXT={0};LISTBOX_ITEM_TEXT2= {1:N1}/{2:N1};LISTBOX_ITEM_TEXT3= {3:N0}%", this.DisplayName, this.LightIntensity, this.LightRange, this.ShadowIntensity);
            }
        }

        public string Icon
        {
            get
            {
                return "LISTBOX_ITEM_ICON=light.tga";
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
            LightResource light = other as LightResource;
            if (light != null) return CompareTo(light);
            return 0;
        }

        public int CompareTo(LightResource other)
        {
            return Name.CompareTo(other.Name);
        }
    }
}
