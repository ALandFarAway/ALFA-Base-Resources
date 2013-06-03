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
    public class TrapResource : IListBoxItem
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
        public int TriggerArea;
        public string TrapTriggerVFX;
        public string Description;

        // For generic traps
        public int DamageType;
        public int DiceNumber;
        public int DiceType;
        public int SaveDC;
        public int AttackBonus;

        // For spell traps
        public bool SpellTrap;
        public int SpellId;

        public string ResRef;
        public virtual string Classification { get; set; }
        public string Tag;

        // For the chooser
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
                return this.ResRef;
            }
        }

        public string TextFields
        {
            get
            {
                return String.Format("LISTBOX_ITEM_TEXT={0};LISTBOX_ITEM_TEXT2= {1};LISTBOX_ITEM_TEXT3=  {2:N1}", DisplayName, DisarmDC, ChallengeRating);
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
                return String.Format("5={0}", this.ResRef);
            }
        }

        public void CalculateCR()
        {
            float cr = 0.0f;
            if (SpellTrap)
            {
                // TODO: Finish the spells portion of Candlekeep,
                // and then use it to calculate CR as spell level + 1
                // here. In the mean time, we grossly overestimate
                // spell trap CRs, so everyone knows they're wrong.
                cr = 99.0f;
            }
            else
            {
                cr = ((float)DiceType / 2 * (float)DiceNumber) / 7;
                int baseNumber = (int)cr;
                if (SaveDC > 0)
                {
                    int numberToSave = SaveDC - ((baseNumber / 2) + 4);
                    if (numberToSave < 2)
                    {
                        // We only fail on a natural 1. Any respectable rogue is totally
                        // unthreatened by this trap.
                        cr *= 0.05f;
                    }
                    else if (numberToSave > 19)
                    {
                        // We only succeed on a natural 20. Almost everyone in this trap
                        // is going to get hurt by it.
                        cr *= 0.95f;
                    }
                    else
                    {
                        // Remember this is the target rolling, so low numbers are
                        // an easier trap.
                        cr *= (numberToSave * 0.05f);
                    }
                }
                else
                {
                    int numberToHit = baseNumber + 14 - AttackBonus;
                    if (numberToHit < 2)
                    {
                        // The trap only misses on a natural 1. Everyone gets punctured
                        cr *= 0.95f;
                    }
                    else if (numberToHit > 19)
                    {
                        // The trap only hits on a natural 20. Tanks march through with impunity, 
                        // and rogues are probably fine.
                        cr *= 0.05f;
                    }
                    else
                    {
                        // Remember this is the trap rolling, so low numbers are
                        // a harder trap.
                        cr *= ((20 - numberToHit) * 0.05f);
                    }
                }
                
                if (DetectDC < 0)
                {
                    cr /= 2;
                }
                else
                {
                    float adjust = ((float)DetectDC - 16.0f - cr) * 0.2f;
                    if (adjust < -1.0f)
                    {
                        adjust = -1.0f;
                    }
                    if (adjust > 1.0f)
                    {
                        adjust = 1.0f;
                    }
                    cr += adjust;
                }
                if (DisarmDC < 0)
                {
                    cr /= 2;
                }
                else
                {
                    float adjust = ((float)DisarmDC - 16.0f - cr) * 0.2f;
                    if (adjust < -1.0f)
                    {
                        adjust = -1.0f;
                    }
                    if (adjust > 1.0f)
                    {
                        adjust = 1.0f;
                    }
                    cr += adjust;
                }
                if ((DamageType & CLRScriptBase.DAMAGE_TYPE_PIERCING) == CLRScriptBase.DAMAGE_TYPE_PIERCING ||
                   (DamageType & CLRScriptBase.DAMAGE_TYPE_SLASHING) == CLRScriptBase.DAMAGE_TYPE_SLASHING ||
                   (DamageType & CLRScriptBase.DAMAGE_TYPE_BLUDGEONING) == CLRScriptBase.DAMAGE_TYPE_BLUDGEONING)
                {
                    cr *= 1.05f;
                }
            }
            if ((DamageType & CLRScriptBase.DAMAGE_TYPE_NEGATIVE) == CLRScriptBase.DAMAGE_TYPE_NEGATIVE)
            {
                cr *= 1.1f;
            }
            if ((DamageType & CLRScriptBase.DAMAGE_TYPE_MAGICAL) == CLRScriptBase.DAMAGE_TYPE_MAGICAL)
            {
                cr *= 1.15f;
            }
            if (EffectSize > 1.0f)
            {
                cr *= 1.1f;
            }
            if (TargetAlignment != CLRScriptBase.ALIGNMENT_ALL ||
               TargetRace != CLRScriptBase.RACIAL_TYPE_ALL)
            {
                cr *= 1.1f;
            }
            if (NumberOfShots < 0)
            {
                cr *= 1.5f;
            }
            else
            {
                float multiplier = 1.0f + (0.05f * (NumberOfShots - 1));
                cr *= multiplier;
            }
            ChallengeRating = cr;
        }

        public int CompareTo(IListBoxItem other)
        {
            TrapResource trap = other as TrapResource;
            if (trap != null) return CompareTo(trap);
            return 0;
        }

        public int CompareTo(TrapResource other)
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
