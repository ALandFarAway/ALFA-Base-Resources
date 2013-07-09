using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;
using System.Reflection;
using System.Reflection.Emit;
using System.Threading;
using CLRScriptFramework;
using ALFA;
using NWScript;
using NWScript.ManagedInterfaceLayer.NWScriptManagedInterface;

using OEIShared.IO.GFF;

using NWEffect = NWScript.NWScriptEngineStructure0;
using NWEvent = NWScript.NWScriptEngineStructure1;
using NWLocation = NWScript.NWScriptEngineStructure2;
using NWTalent = NWScript.NWScriptEngineStructure3;
using NWItemProperty = NWScript.NWScriptEngineStructure4;

namespace ACR_Items
{
    public class GenerateBoots : CLRScriptBase
    {
        public static int NewBoots(CLRScriptBase script, int maxValue)
        {
            List<int> potentialAbilities = new List<int>();
            foreach (KeyValuePair<int, int> ability in AvailableAbilities)
            {
                if (ability.Value <= maxValue)
                {
                    potentialAbilities.Add(ability.Key);
                }
            }
            if (potentialAbilities.Count == 0)
            {
                return 0;
            }
            int selectedAbility = potentialAbilities[Generation.rand.Next(potentialAbilities.Count)];
            uint Boots = script.CreateItemOnObject("zitem_boot2", script.OBJECT_SELF, 1, "", FALSE);
            switch (selectedAbility)
            {
                #region Boots of Ability Boosts
                case ITEM_PROPERTY_ABILITY_BONUS:
                    {
                        int abilityScore = AvailableAbilityScores[Generation.rand.Next(AvailableAbilityScores.Count)];
                        string name = AbilityScoreNames[abilityScore];
                        if (maxValue >= 36000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAbilityBonus(abilityScore, 6), Boots, 0.0f);
                            script.SetFirstName(Boots, name + " +6");
                            Pricing.CalculatePrice(script, Boots);
                            return 36000;
                        }
                        else if (maxValue >= 25000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAbilityBonus(abilityScore, 5), Boots, 0.0f);
                            script.SetFirstName(Boots, name + " +5");
                            Pricing.CalculatePrice(script, Boots);
                            return 25000;
                        }
                        else if (maxValue >= 16000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAbilityBonus(abilityScore, 4), Boots, 0.0f);
                            script.SetFirstName(Boots, name + " +4");
                            Pricing.CalculatePrice(script, Boots);
                            return 16000;
                        }
                        else if (maxValue >= 9000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAbilityBonus(abilityScore, 3), Boots, 0.0f);
                            script.SetFirstName(Boots, name + " +3");
                            Pricing.CalculatePrice(script, Boots);
                            return 9000;
                        }
                        else if (maxValue >= 4000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAbilityBonus(abilityScore, 2), Boots, 0.0f);
                            script.SetFirstName(Boots, name + " +2");
                            Pricing.CalculatePrice(script, Boots);
                            return 4000;
                        }
                        else if (maxValue >= 1000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAbilityBonus(abilityScore, 1), Boots, 0.0f);
                            script.SetFirstName(Boots, name + " +1");
                            Pricing.CalculatePrice(script, Boots);
                            return 1000;
                        }
                        else
                        {
                            return 0;
                        }
                    }
                #endregion
                #region Freedom of Movement
                case ITEM_PROPERTY_FREEDOM_OF_MOVEMENT:
                    {
                        script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyFreeAction(), Boots, 0.0f);
                        script.SetFirstName(Boots, "Boots of Freedom");
                        Pricing.CalculatePrice(script, Boots);
                        return 40000;
                    }
                #endregion
                #region Immunities
                case ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS:
                    {
                        List<int> possibleImmunities = new List<int>();
                        foreach (KeyValuePair<int, int> immunity in AvailableImmunities)
                        {
                            if (immunity.Value <= maxValue)
                            {
                                possibleImmunities.Add(immunity.Key);
                            }
                        }
                        if (possibleImmunities.Count == 0)
                        {
                            return 0;
                        }
                        int selectedImmunity = possibleImmunities[Generation.rand.Next(possibleImmunities.Count)];
                        script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyImmunityMisc(selectedImmunity), Boots, 0.0f);
                        script.SetFirstName(Boots, ImmunityNames[selectedImmunity]);
                        Pricing.CalculatePrice(script, Boots);
                        return AvailableImmunities[selectedImmunity];
                    }
                #endregion
                #region Skill Bonus
                case ITEM_PROPERTY_SKILL_BONUS:
                    {
                        int skillBonus = AvailableSkills[Generation.rand.Next(AvailableSkills.Count)];
                        script.SetFirstName(Boots, SkillNames[skillBonus]);
                        if (maxValue >= 10000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 10), Boots, 0.0f);
                            script.SetFirstName(Boots, script.GetName(Boots) + " +10");
                            Pricing.CalculatePrice(script, Boots);
                            return 10000;
                        }
                        else if (maxValue >= 8100)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 9), Boots, 0.0f);
                            script.SetFirstName(Boots, script.GetName(Boots) + " +9");
                            Pricing.CalculatePrice(script, Boots);
                            return 8100;
                        }
                        else if (maxValue >= 6400)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 8), Boots, 0.0f);
                            script.SetFirstName(Boots, script.GetName(Boots) + " +8");
                            Pricing.CalculatePrice(script, Boots);
                            return 6400;
                        }
                        else if (maxValue >= 4900)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 7), Boots, 0.0f);
                            script.SetFirstName(Boots, script.GetName(Boots) + " +7");
                            Pricing.CalculatePrice(script, Boots);
                            return 4900;
                        }
                        else if (maxValue >= 3600)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 6), Boots, 0.0f);
                            script.SetFirstName(Boots, script.GetName(Boots) + " +6");
                            Pricing.CalculatePrice(script, Boots);
                            return 3600;
                        }
                        else if (maxValue >= 2500)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 5), Boots, 0.0f);
                            script.SetFirstName(Boots, script.GetName(Boots) + " +5");
                            Pricing.CalculatePrice(script, Boots);
                            return 2500;
                        }
                        else if (maxValue >= 1600)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 4), Boots, 0.0f);
                            script.SetFirstName(Boots, script.GetName(Boots) + " +4");
                            Pricing.CalculatePrice(script, Boots);
                            return 1600;
                        }
                        else if (maxValue >= 900)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 3), Boots, 0.0f);
                            script.SetFirstName(Boots, script.GetName(Boots) + " +3");
                            Pricing.CalculatePrice(script, Boots);
                            return 900;
                        }
                        else if (maxValue >= 400)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 2), Boots, 0.0f);
                            script.SetFirstName(Boots, script.GetName(Boots) + " +2");
                            Pricing.CalculatePrice(script, Boots);
                            return 400;
                        }
                        else if (maxValue >= 100)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 1), Boots, 0.0f);
                            script.SetFirstName(Boots, script.GetName(Boots) + " +1");
                            Pricing.CalculatePrice(script, Boots);
                            return 100;
                        }
                        else
                        {
                            return 0;
                        }
                    }
                #endregion
            }
            script.DestroyObject(Boots, 0.0f, FALSE);
            return 0;
        }

        #region Ability Categories
        public static Dictionary<int, int> AvailableAbilities = new Dictionary<int, int>
        {
            {ITEM_PROPERTY_ABILITY_BONUS, 1000},
            {ITEM_PROPERTY_FREEDOM_OF_MOVEMENT, 40000},
            {ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS, 15000},
            {ITEM_PROPERTY_SKILL_BONUS, 100},
        };

        public static Dictionary<int, string> AbilityNames = new Dictionary<int, string>
        {
            {ITEM_PROPERTY_ABILITY_BONUS, "" },
            {ITEM_PROPERTY_FREEDOM_OF_MOVEMENT, "Boots of Freedom" },
            {ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS, "" },
            {ITEM_PROPERTY_SKILL_BONUS, "" },
        };
        #endregion

        #region Ability Scores
        static List<int> AvailableAbilityScores = new List<int>
        {
            IP_CONST_ABILITY_DEX,
        };

        static Dictionary<int, string> AbilityScoreNames = new Dictionary<int, string>
        {
            {IP_CONST_ABILITY_DEX, "Boots of Agility" },
        };
        #endregion

        #region Immunities
        public static Dictionary<int, int> AvailableImmunities = new Dictionary<int, int>
        {
            {IP_CONST_IMMUNITYMISC_KNOCKDOWN, 22500},
            {IP_CONST_IMMUNITYMISC_PARALYSIS, 15000},
        };

        public static Dictionary<int, string> ImmunityNames = new Dictionary<int, string>
        {
            {IP_CONST_IMMUNITYMISC_KNOCKDOWN, "Boots of Stability" },
            {IP_CONST_IMMUNITYMISC_PARALYSIS, "Boots of Enduring Mobility" },
        };
        #endregion

        #region Skills
        public static List<int> AvailableSkills = new List<int>
        {
            SKILL_BALANCE,
            SKILL_CLIMB,
            SKILL_ESCAPE_ARTIST,
            SKILL_JUMP,
            SKILL_MOVE_SILENTLY,
            SKILL_PERFORM_DANCE,
            SKILL_RIDE,
            SKILL_SWIM,
            SKILL_TUMBLE,
        };

        public static Dictionary<int, string> SkillNames = new Dictionary<int, string>
        {
            {SKILL_BALANCE, "Boots of Balance" },
            {SKILL_CLIMB, "Boots of Climbing" },
            {SKILL_ESCAPE_ARTIST, "Boots of Escape" },
            {SKILL_JUMP, "Boots of Jumping" },
            {SKILL_MOVE_SILENTLY, "Boots of Prowling" },
            {SKILL_PERFORM_DANCE, "Boots of Dancing" },
            {SKILL_RIDE, "Boots of Horsemanship" },
            {SKILL_SWIM, "Boots of Swimming" },
            {SKILL_TUMBLE, "Boots of Tumbling" },
        };
        #endregion
    }
}