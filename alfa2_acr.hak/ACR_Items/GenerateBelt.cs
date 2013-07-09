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
    public class GenerateBelt: CLRScriptBase
    {
        public static int NewBelt(CLRScriptBase script, int maxValue)
        {
            List<int> selectableAbilities = new List<int>();
            foreach (KeyValuePair<int, int> prop in PrimaryAmuletAbility)
            {
                if (prop.Value <= maxValue)
                {
                    selectableAbilities.Add(prop.Key);
                }
            }
            if (selectableAbilities.Count == 0)
            {
                return 0;
            }
            int selectedAbility = selectableAbilities[Generation.rand.Next(selectableAbilities.Count)];
            uint belt = script.CreateItemOnObject("zitem_belt", script.OBJECT_SELF, 1, "", FALSE);
            switch (selectedAbility)
            {
                #region Belt of Shielding
                case ITEM_PROPERTY_AC_BONUS:
                    {
                        if (maxValue >= 50000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyACBonus(5), belt, 0.0f);
                            script.SetFirstName(belt, "Belt of Shielding +5");
                            Pricing.CalculatePrice(script, belt);
                            return 50000;
                        }
                        else if (maxValue >= 32000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyACBonus(4), belt, 0.0f);
                            script.SetFirstName(belt, "Belt of Shielding +4");
                            Pricing.CalculatePrice(script, belt);
                            return 32000;
                        }
                        else if (maxValue >= 18000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyACBonus(3), belt, 0.0f);
                            script.SetFirstName(belt, "Belt of Shielding +3");
                            Pricing.CalculatePrice(script, belt);
                            return 18000;
                        }
                        else if (maxValue >= 8000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyACBonus(2), belt, 0.0f);
                            script.SetFirstName(belt, "Belt of Shielding +2");
                            Pricing.CalculatePrice(script, belt);
                            return 8000;
                        }
                        else if (maxValue >= 2000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyACBonus(1), belt, 0.0f);
                            script.SetFirstName(belt, "Belt of Shielding +1");
                            Pricing.CalculatePrice(script, belt);
                            return 2000;
                        }
                        else
                        {
                            return 0;
                        }
                    }
                #endregion
                #region Ability Bonus
                case ITEM_PROPERTY_ABILITY_BONUS:
                    {
                        int ability = AbilityScores[Generation.rand.Next(AbilityScores.Count)];
                        if (maxValue >= 36000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAbilityBonus(ability, 6), belt, 0.0f);
                            script.SetFirstName(belt, AbilityScoreNames[ability] + " +6");
                            Pricing.CalculatePrice(script, belt);
                            return 36000;
                        }
                        else if (maxValue >= 25000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAbilityBonus(ability, 5), belt, 0.0f);
                            script.SetFirstName(belt, AbilityScoreNames[ability] + " +5");
                            Pricing.CalculatePrice(script, belt);
                            return 25000;
                        }
                        else if (maxValue >= 16000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAbilityBonus(ability, 4), belt, 0.0f);
                            script.SetFirstName(belt, AbilityScoreNames[ability] + " +4");
                            Pricing.CalculatePrice(script, belt);
                            return 16000;
                        }
                        else if (maxValue >= 9000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAbilityBonus(ability, 3), belt, 0.0f);
                            script.SetFirstName(belt, AbilityScoreNames[ability] + " +3");
                            Pricing.CalculatePrice(script, belt);
                            return 9000;
                        }
                        else if (maxValue >= 4000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAbilityBonus(ability, 2), belt, 0.0f);
                            script.SetFirstName(belt, AbilityScoreNames[ability] + " +2");
                            Pricing.CalculatePrice(script, belt);
                            return 4000;
                        }
                        else if (maxValue >= 1000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAbilityBonus(ability, 1), belt, 0.0f);
                            script.SetFirstName(belt, AbilityScoreNames[ability] + " +1");
                            Pricing.CalculatePrice(script, belt);
                            return 1000;
                        }
                        else
                        {
                            return 0;
                        }
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
                        script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyImmunityMisc(selectedImmunity), belt, 0.0f);
                        script.SetFirstName(belt, ImmunityNames[selectedImmunity]);
                        Pricing.CalculatePrice(script, belt);
                        return AvailableImmunities[selectedImmunity];
                    }
                #endregion
                #region Skill Bonuses
                case ITEM_PROPERTY_SKILL_BONUS:
                    {
                        int skillBonus = AvailableSkills[Generation.rand.Next(AvailableSkills.Count)];
                        script.SetFirstName(belt, SkillNames[skillBonus]);
                        if (maxValue >= 10000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 10), belt, 0.0f);
                            script.SetFirstName(belt, script.GetName(belt) + " +10");
                            Pricing.CalculatePrice(script, belt);
                            return 10000;
                        }
                        else if (maxValue >= 8100)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 9), belt, 0.0f);
                            script.SetFirstName(belt, script.GetName(belt) + " +9");
                            Pricing.CalculatePrice(script, belt);
                            return 8100;
                        }
                        else if (maxValue >= 6400)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 8), belt, 0.0f);
                            script.SetFirstName(belt, script.GetName(belt) + " +8");
                            Pricing.CalculatePrice(script, belt);
                            return 6400;
                        }
                        else if (maxValue >= 4900)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 7), belt, 0.0f);
                            script.SetFirstName(belt, script.GetName(belt) + " +7");
                            Pricing.CalculatePrice(script, belt);
                            return 4900;
                        }
                        else if (maxValue >= 3600)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 6), belt, 0.0f);
                            script.SetFirstName(belt, script.GetName(belt) + " +6");
                            Pricing.CalculatePrice(script, belt);
                            return 3600;
                        }
                        else if (maxValue >= 2500)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 5), belt, 0.0f);
                            script.SetFirstName(belt, script.GetName(belt) + " +5");
                            Pricing.CalculatePrice(script, belt);
                            return 2500;
                        }
                        else if (maxValue >= 1600)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 4), belt, 0.0f);
                            script.SetFirstName(belt, script.GetName(belt) + " +4");
                            Pricing.CalculatePrice(script, belt);
                            return 1600;
                        }
                        else if (maxValue >= 900)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 3), belt, 0.0f);
                            script.SetFirstName(belt, script.GetName(belt) + " +3");
                            Pricing.CalculatePrice(script, belt);
                            return 900;
                        }
                        else if (maxValue >= 400)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 2), belt, 0.0f);
                            script.SetFirstName(belt, script.GetName(belt) + " +2");
                            Pricing.CalculatePrice(script, belt);
                            return 400;
                        }
                        else if (maxValue >= 100)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 1), belt, 0.0f);
                            script.SetFirstName(belt, script.GetName(belt) + " +1");
                            Pricing.CalculatePrice(script, belt);
                            return 100;
                        }
                        break;
                    }
                #endregion
            }
            script.DestroyObject(belt, 0.0f, FALSE);
            return 0;
        }

        public static Dictionary<int, int> PrimaryAmuletAbility = new Dictionary<int, int>
        {
            {ITEM_PROPERTY_AC_BONUS, 2000},
            {ITEM_PROPERTY_ABILITY_BONUS, 1000},
            {ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS, 7500},
            {ITEM_PROPERTY_SKILL_BONUS, 100},
        };

        public static List<int> AbilityScores = new List<int>
        {
            IP_CONST_ABILITY_STR,
            IP_CONST_ABILITY_CON,
            IP_CONST_ABILITY_DEX,
        };

        public static Dictionary<int, string> AbilityScoreNames = new Dictionary<int, string>
        {
            {IP_CONST_ABILITY_STR, "Belt of Giant Strength"},
            {IP_CONST_ABILITY_CON, "Girdle of Fortitude"},
            {IP_CONST_ABILITY_DEX, "Sash of Grace"},
        };

        public static Dictionary<int, int> AvailableImmunities = new Dictionary<int, int>
        {
            {IP_CONST_IMMUNITYMISC_DEATH_MAGIC, 80000},
            {IP_CONST_IMMUNITYMISC_DISEASE, 7500},
            {IP_CONST_IMMUNITYMISC_KNOCKDOWN, 22500},
            {IP_CONST_IMMUNITYMISC_LEVEL_ABIL_DRAIN, 40000},
            {IP_CONST_IMMUNITYMISC_PARALYSIS, 15000},
            {IP_CONST_IMMUNITYMISC_POISON, 25000},
        };

        public static Dictionary<int, string> ImmunityNames = new Dictionary<int, string>
        {
            {IP_CONST_IMMUNITYMISC_DEATH_MAGIC, "Belt of Deathward" },
            {IP_CONST_IMMUNITYMISC_DISEASE, "Belt of Good Health" },
            {IP_CONST_IMMUNITYMISC_KNOCKDOWN, "Belt of Stability" },
            {IP_CONST_IMMUNITYMISC_LEVEL_ABIL_DRAIN, "Belt of Enduring Integrity" },
            {IP_CONST_IMMUNITYMISC_PARALYSIS, "Belt of Enduring Mobility" },
            {IP_CONST_IMMUNITYMISC_POISON, "Belt of Good Health" },
        };

        public static List<int> AvailableSkills = new List<int>
        {
            SKILL_BALANCE,
            SKILL_CLIMB,
            SKILL_ESCAPE_ARTIST,
            SKILL_JUMP,
            SKILL_RIDE,
            SKILL_SURVIVAL,
            SKILL_SWIM,
            SKILL_TUMBLE,
        };

        public static Dictionary<int, string> SkillNames = new Dictionary<int, string>
        {
            {SKILL_BALANCE, "Belt of Good Balance" },
            {SKILL_CLIMB, "Belt of Climbing" },
            {SKILL_ESCAPE_ARTIST, "Belt of Escaping" },
            {SKILL_JUMP, "Belt of Leaping" },
            {SKILL_RIDE, "Belt of Riding" },
            {SKILL_SURVIVAL, "Belt of Survival" },
            {SKILL_SWIM, "Belt of Swimming" },
            {SKILL_TUMBLE, "Belt of Tumbling" },
        };
    }
}
