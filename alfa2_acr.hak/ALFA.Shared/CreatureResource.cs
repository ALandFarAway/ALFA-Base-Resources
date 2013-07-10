using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


namespace ALFA.Shared
{
    public class CreatureResource : IListBoxItem
    {
        public volatile string FirstName;
        public volatile string LastName;
        public volatile string DisplayName;
        public string Classification { get; set; }
        public volatile string ResourceName;
        public volatile string TemplateResRef;
        public volatile string Tag;
        public volatile bool IsImmortal;
        public volatile float ChallengeRating;
        public volatile int FactionID;
        public volatile int LawfulChaotic;
        public volatile int GoodEvil;
        public volatile string AlignmentSummary;

        public CreatureResource() { }

        public void ConfigureDisplayName()
        {
            DisplayName = String.Format("  {0} {1}", this.FirstName, this.LastName);
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
                string faction = "Unknown";
                if (ALFA.Shared.Modules.InfoStore.ModuleFactions.Keys.Contains(this.FactionID))
                {
                    faction = ALFA.Shared.Modules.InfoStore.ModuleFactions[this.FactionID].Name;
                }
                return String.Format("LISTBOX_ITEM_TEXT={0};LISTBOX_ITEM_TEXT2= {1};LISTBOX_ITEM_TEXT3= {2:N1}", DisplayName, faction, this.ChallengeRating);
            }
        }

        public string Icon
        {
            get
            {
                return "LISTBOX_ITEM_ICON=creature.tga";
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
            CreatureResource creature = other as CreatureResource;
            if (creature != null) return CompareTo(creature);
            return 0;
        }

        public int CompareTo(CreatureResource other)
        {
            if (Sorting.Column == 2)
            {
                return FactionID.CompareTo(other.FactionID);
            }
            else if (Sorting.Column == 3)
            {
                return ChallengeRating.CompareTo(other.ChallengeRating);
            }
            else
            {
                if (FirstName == other.FirstName)
                {
                    return LastName.CompareTo(other.LastName);
                }
                return FirstName.CompareTo(other.FirstName);
            }
        }
    }
}