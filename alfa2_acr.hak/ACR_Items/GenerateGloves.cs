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
    public class GenerateGloves : CLRScriptBase
    {
        public static int NewGloves(CLRScriptBase script, int maxValue)
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
            uint gloves = script.CreateItemOnObject("zitem_glove2", script.OBJECT_SELF, 1, "", FALSE);
            switch (selectedAbility)
            {
                #region Gloves of Ability Scores
                case ITEM_PROPERTY_ABILITY_BONUS:
                    {
                        int abilityScore = AvailableAbilityScores[Generation.rand.Next(AvailableAbilityScores.Count)];
                        string name = AbilityScoreNames[abilityScore];
                        if (maxValue >= 36000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAbilityBonus(abilityScore, 6), gloves, 0.0f);
                            script.SetFirstName(gloves, name + " +6");
                            Pricing.CalculatePrice(script, gloves);
                            return 36000;
                        }
                        else if (maxValue >= 25000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAbilityBonus(abilityScore, 5), gloves, 0.0f);
                            script.SetFirstName(gloves, name + " +5");
                            Pricing.CalculatePrice(script, gloves);
                            return 25000;
                        }
                        else if (maxValue >= 16000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAbilityBonus(abilityScore, 4), gloves, 0.0f);
                            script.SetFirstName(gloves, name + " +4");
                            Pricing.CalculatePrice(script, gloves);
                            return 16000;
                        }
                        else if (maxValue >= 9000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAbilityBonus(abilityScore, 3), gloves, 0.0f);
                            script.SetFirstName(gloves, name + " +3");
                            Pricing.CalculatePrice(script, gloves);
                            return 9000;
                        }
                        else if (maxValue >= 4000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAbilityBonus(abilityScore, 2), gloves, 0.0f);
                            script.SetFirstName(gloves, name + " +2");
                            Pricing.CalculatePrice(script, gloves);
                            return 4000;
                        }
                        else if (maxValue >= 1000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAbilityBonus(abilityScore, 1), gloves, 0.0f);
                            script.SetFirstName(gloves, name + " +1");
                            Pricing.CalculatePrice(script, gloves);
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
                        script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyFreeAction(), gloves, 0.0f);
                        script.SetFirstName(gloves, "Gloves of Freedom");
                        Pricing.CalculatePrice(script, gloves);
                        return 40000;
                    }
                #endregion
                #region Skill Bonus
                case ITEM_PROPERTY_SKILL_BONUS:
                    {
                        int skillBonus = AvailableSkills[Generation.rand.Next(AvailableSkills.Count)];
                        script.SetFirstName(gloves, SkillNames[skillBonus]);
                        if (maxValue >= 10000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 10), gloves, 0.0f);
                            script.SetFirstName(gloves, script.GetName(gloves) + " +10");
                            Pricing.CalculatePrice(script, gloves);
                            return 10000;
                        }
                        else if (maxValue >= 8100)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 9), gloves, 0.0f);
                            script.SetFirstName(gloves, script.GetName(gloves) + " +9");
                            Pricing.CalculatePrice(script, gloves);
                            return 8100;
                        }
                        else if (maxValue >= 6400)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 8), gloves, 0.0f);
                            script.SetFirstName(gloves, script.GetName(gloves) + " +8");
                            Pricing.CalculatePrice(script, gloves);
                            return 6400;
                        }
                        else if (maxValue >= 4900)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 7), gloves, 0.0f);
                            script.SetFirstName(gloves, script.GetName(gloves) + " +7");
                            Pricing.CalculatePrice(script, gloves);
                            return 4900;
                        }
                        else if (maxValue >= 3600)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 6), gloves, 0.0f);
                            script.SetFirstName(gloves, script.GetName(gloves) + " +6");
                            Pricing.CalculatePrice(script, gloves);
                            return 3600;
                        }
                        else if (maxValue >= 2500)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 5), gloves, 0.0f);
                            script.SetFirstName(gloves, script.GetName(gloves) + " +5");
                            Pricing.CalculatePrice(script, gloves);
                            return 2500;
                        }
                        else if (maxValue >= 1600)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 4), gloves, 0.0f);
                            script.SetFirstName(gloves, script.GetName(gloves) + " +4");
                            Pricing.CalculatePrice(script, gloves);
                            return 1600;
                        }
                        else if (maxValue >= 900)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 3), gloves, 0.0f);
                            script.SetFirstName(gloves, script.GetName(gloves) + " +3");
                            Pricing.CalculatePrice(script, gloves);
                            return 900;
                        }
                        else if (maxValue >= 400)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 2), gloves, 0.0f);
                            script.SetFirstName(gloves, script.GetName(gloves) + " +2");
                            Pricing.CalculatePrice(script, gloves);
                            return 400;
                        }
                        else if (maxValue >= 100)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 1), gloves, 0.0f);
                            script.SetFirstName(gloves, script.GetName(gloves) + " +1");
                            Pricing.CalculatePrice(script, gloves);
                            return 100;
                        }
                        else
                        {
                            return 0;
                        }
                    }
                #endregion
            }
            script.DestroyObject(gloves, 0.0f, FALSE);
            return 0;
        }

        #region Ability Categories
        public static Dictionary<int, int> AvailableAbilities = new Dictionary<int, int>
        {
            {ITEM_PROPERTY_ABILITY_BONUS, 1000},
            {ITEM_PROPERTY_FREEDOM_OF_MOVEMENT, 40000},
            {ITEM_PROPERTY_SKILL_BONUS, 100},
        };

        public static Dictionary<int, string> AbilityNames = new Dictionary<int, string>
        {
            {ITEM_PROPERTY_ABILITY_BONUS, "" },
            {ITEM_PROPERTY_FREEDOM_OF_MOVEMENT, "Gloves of Freedom" },
            {ITEM_PROPERTY_SKILL_BONUS, "" },
        };
        #endregion

        #region Ability Scores
        static List<int> AvailableAbilityScores = new List<int>
        {
            IP_CONST_ABILITY_DEX,
            IP_CONST_ABILITY_STR,
        };

        static Dictionary<int, string> AbilityScoreNames = new Dictionary<int, string>
        {
            {IP_CONST_ABILITY_DEX, "Gloves of Agility" },
            {IP_CONST_ABILITY_STR, "Gloves of Might" },
        };
        #endregion

        #region Skills
        public static List<int> AvailableSkills = new List<int>
        {
            SKILL_HANDLE_ANIMAL,
            SKILL_HEAL,
            SKILL_RIDE,
        };

        public static Dictionary<int, string> SkillNames = new Dictionary<int, string>
        {
            {SKILL_HANDLE_ANIMAL, "Gloves of the Trainer" },
            {SKILL_HEAL, "Gloves of Medicine" },
            {SKILL_RIDE, "Gloves of Horsemanship" },
        };
        #endregion
    }
}
