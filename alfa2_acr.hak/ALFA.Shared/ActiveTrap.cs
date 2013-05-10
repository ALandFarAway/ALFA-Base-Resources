using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using CLRScriptFramework;
using NWScript;

using NWEffect = NWScript.NWScriptEngineStructure0;
using NWEvent = NWScript.NWScriptEngineStructure1;
using NWLocation = NWScript.NWScriptEngineStructure2;
using NWTalent = NWScript.NWScriptEngineStructure3;
using NWItemProperty = NWScript.NWScriptEngineStructure4;

namespace ALFA.Shared
{
    public class ActiveTrap : IListBoxItem
    {
        // For all traps
        public NWLocation Location;
        public int EffectArea;
        public float EffectSize;
        public int NumberOfShots;
        public uint TrapOrigin;
        public int TargetAlignment;
        public int TargetRace;
        public int MinimumToTrigger;
        public int DetectDC;
        public int DisarmDC;
        public bool Detected;

        // For generic traps
        public int DamageType;
        public int DiceNumber;
        public int DiceType;
        public int SaveDC;
        public int AttackBonus;

        // For spell traps
        public bool SpellTrap;
        public int SpellId;

        // For the chooser
        public string AreaName;
        public string Tag;
        public string DetectTag;
        public string DisplayName;
        public float ChallengeRating;

        public void ConfigureDisplayName()
        {
            if (!SpellTrap)
            {
                if (EffectArea > 7.5f)
                {
                    DisplayName = "Big ";
                }
                else
                {
                    DisplayName = "Small ";
                }
                // There might be more than one damage type done by this trap, so use
                // bitwise to check every type.
                if ((DamageType & CLRScriptBase.DAMAGE_TYPE_ACID) == CLRScriptBase.DAMAGE_TYPE_ACID)
                {
                    DisplayName += "A";
                }
                if ((DamageType & CLRScriptBase.DAMAGE_TYPE_BLUDGEONING) == CLRScriptBase.DAMAGE_TYPE_BLUDGEONING)
                {
                    DisplayName += "B";
                }
                if ((DamageType & CLRScriptBase.DAMAGE_TYPE_COLD) == CLRScriptBase.DAMAGE_TYPE_COLD)
                {
                    DisplayName += "C";
                }
                if ((DamageType & CLRScriptBase.DAMAGE_TYPE_DIVINE) == CLRScriptBase.DAMAGE_TYPE_DIVINE)
                {
                    DisplayName += "D";
                }
                if ((DamageType & CLRScriptBase.DAMAGE_TYPE_ELECTRICAL) == CLRScriptBase.DAMAGE_TYPE_ELECTRICAL)
                {
                    DisplayName += "E";
                }
                if ((DamageType & CLRScriptBase.DAMAGE_TYPE_FIRE) == CLRScriptBase.DAMAGE_TYPE_FIRE)
                {
                    DisplayName += "F";
                }
                if ((DamageType & CLRScriptBase.DAMAGE_TYPE_MAGICAL) == CLRScriptBase.DAMAGE_TYPE_MAGICAL)
                {
                    DisplayName += "M";
                }
                if ((DamageType & CLRScriptBase.DAMAGE_TYPE_NEGATIVE) == CLRScriptBase.DAMAGE_TYPE_NEGATIVE)
                {
                    DisplayName += "N";
                }
                if ((DamageType & CLRScriptBase.DAMAGE_TYPE_PIERCING) == CLRScriptBase.DAMAGE_TYPE_PIERCING)
                {
                    DisplayName += "Pr";
                }
                if ((DamageType & CLRScriptBase.DAMAGE_TYPE_POSITIVE) == CLRScriptBase.DAMAGE_TYPE_POSITIVE)
                {
                    DisplayName += "Po";
                }
                if ((DamageType & CLRScriptBase.DAMAGE_TYPE_SLASHING) == CLRScriptBase.DAMAGE_TYPE_SLASHING)
                {
                    DisplayName += "Sl";
                }
                if ((DamageType & CLRScriptBase.DAMAGE_TYPE_SONIC) == CLRScriptBase.DAMAGE_TYPE_SONIC)
                {
                    DisplayName += "So";
                }
                if (DamageType == 0)
                {
                    DisplayName += "Phys";
                }
                DisplayName += " ";
            }
            else
            {
                // TODO: Write the spells portion of ALFA.Shared, and grab the spell
                // name from it.
                DisplayName = "Spell ";
            }
            DisplayName += "Trap";
        }

        public string RowName
        {
            get
            {
                return this.Tag;
            }
        }

        public string TextFields
        {
            get
            {
                return String.Format("LISTBOX_ITEM_TEXT={0};LISTBOX_ITEM_TEXT2= {1:N1}", DisplayName, ChallengeRating);
            }
        }

        public string Icon
        {
            get
            {
                return "LISTBOX_ITEM_ICON=trap.tga";
            }
        }

        public string Variables
        {
            get
            {
                return String.Format("5={0}", this.Tag);
            }
        }

        public string Classification
        {
            get
            {
                return String.Format("{0}|Traps", AreaName);
            }
        }

        public int CompareTo(IListBoxItem other)
        {
            ActiveTrap trap = other as ActiveTrap;
            if (trap != null) return CompareTo(trap);
            return 0;
        }

        public int CompareTo(ActiveTrap other)
        {
            if (Sorting.Column == 2)
            {
                return ChallengeRating.CompareTo(other.ChallengeRating);
            }
            else if (Sorting.Column == 3)
            {
                return ChallengeRating.CompareTo(other.ChallengeRating);
            }
            else
            {
                return DisplayName.CompareTo(other.DisplayName);
            }
        }
    }
}
