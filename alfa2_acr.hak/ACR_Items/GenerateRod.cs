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
    public class GenerateRod: CLRScriptBase
    {
        public static int NewRod(CLRScriptBase script, int maxValue)
        {
            #region Check if collections need to be loaded. Load them if so
            if (FireSpells.Count == 0)
            {
                convertToRodPrice(GenerateStaff.FireSpells, FireSpells);
                convertToRodPrice(GenerateStaff.ColdSpells, ColdSpells);
                convertToRodPrice(GenerateStaff.AcidSpells, AcidSpells);
                convertToRodPrice(GenerateStaff.ElectricSpells, ElectricSpells);
                convertToRodPrice(GenerateStaff.SoundSpells, SoundSpells);
                convertToRodPrice(GenerateStaff.PhysicalAttackSpells, PhysicalAttackSpells);
                convertToRodPrice(GenerateStaff.ForceSpells, ForceSpells);
                convertToRodPrice(GenerateStaff.MoraleSpells, MoraleSpells);
                convertToRodPrice(GenerateStaff.AntimoraleSpells, AntimoraleSpells);
                convertToRodPrice(GenerateStaff.MindControlSpells, MindControlSpells);
                convertToRodPrice(GenerateStaff.PerceptionSpells, PerceptionSpells);
                convertToRodPrice(GenerateStaff.PhysicalSpells, PhysicalSpells);
                convertToRodPrice(GenerateStaff.MentalSpells, MentalSpells);
                convertToRodPrice(GenerateStaff.Transmutations, Transmutations);
                convertToRodPrice(GenerateStaff.AntiMagicSpells, AntiMagicSpells);
                convertToRodPrice(GenerateStaff.IllusionSpells, IllusionSpells);
                convertToRodPrice(GenerateStaff.DeathSpells, DeathSpells);
                convertToRodPrice(GenerateStaff.EvilSpells, EvilSpells);
                convertToRodPrice(GenerateStaff.GoodSpells, GoodSpells);
                convertToRodPrice(GenerateStaff.ProtectionSpells, ProtectionSpells);
                convertToRodPrice(GenerateStaff.HealingSpells, HealingSpells);
                convertToRodPrice(GenerateStaff.SummonSpells, SummonSpells);
            }
            #endregion

            Dictionary<int, int> currentAvailableSpells = new Dictionary<int,int>();
            List<string> possibleNames = new List<string>();
            #region Get Starting Collections
            switch (Generation.rand.Next(22))
            {
                case 0:
                    GenerateStaff.copyDictionary(FireSpells, currentAvailableSpells);
                    GenerateStaff.copyList(GenerateStaff.FireNames, possibleNames);
                    break;
                case 1:
                    GenerateStaff.copyDictionary(ColdSpells, currentAvailableSpells);
                    GenerateStaff.copyList(GenerateStaff.ColdNames, possibleNames);
                    break;
                case 2:
                    GenerateStaff.copyDictionary(AcidSpells, currentAvailableSpells);
                    GenerateStaff.copyList(GenerateStaff.AcidNames, possibleNames);
                    break;
                case 3:
                    GenerateStaff.copyDictionary(ElectricSpells, currentAvailableSpells);
                    GenerateStaff.copyList(GenerateStaff.ElectricNames, possibleNames);
                    break;
                case 4:
                    GenerateStaff.copyDictionary(SoundSpells, currentAvailableSpells);
                    GenerateStaff.copyList(GenerateStaff.SoundNames, possibleNames);
                    break;
                case 5:
                    GenerateStaff.copyDictionary(PhysicalAttackSpells, currentAvailableSpells);
                    GenerateStaff.copyList(GenerateStaff.PhysicalAttackNames, possibleNames);
                    break;
                case 6:
                    GenerateStaff.copyDictionary(ForceSpells, currentAvailableSpells);
                    GenerateStaff.copyList(GenerateStaff.ForceNames, possibleNames);
                    break;
                case 7: 
                    GenerateStaff.copyDictionary(MoraleSpells, currentAvailableSpells);
                    GenerateStaff.copyList(GenerateStaff.MoraleNames, possibleNames);
                    break;
                case 8:
                    GenerateStaff.copyDictionary(AntimoraleSpells, currentAvailableSpells);
                    GenerateStaff.copyList(GenerateStaff.AntimoraleNames, possibleNames);
                    break;
                case 9:
                    GenerateStaff.copyDictionary(MindControlSpells, currentAvailableSpells);
                    GenerateStaff.copyList(GenerateStaff.MindControlNames, possibleNames);
                    break;
                case 10:
                    GenerateStaff.copyDictionary(PerceptionSpells, currentAvailableSpells);
                    GenerateStaff.copyList(GenerateStaff.PerceptionNames, possibleNames);
                    break;
                case 11:
                    GenerateStaff.copyDictionary(PhysicalSpells, currentAvailableSpells);
                    GenerateStaff.copyList(GenerateStaff.PhysicalNames, possibleNames);
                    break;
                case 12:
                    GenerateStaff.copyDictionary(MentalSpells, currentAvailableSpells);
                    GenerateStaff.copyList(GenerateStaff.MentalNames, possibleNames);
                    break;
                case 13:
                    GenerateStaff.copyDictionary(Transmutations, currentAvailableSpells);
                    GenerateStaff.copyList(GenerateStaff.TransmutNames, possibleNames);
                    break;
                case 14:
                    GenerateStaff.copyDictionary(AntiMagicSpells, currentAvailableSpells);
                    GenerateStaff.copyList(GenerateStaff.AntiMagicNames, possibleNames);
                    break;
                case 15:
                    GenerateStaff.copyDictionary(IllusionSpells, currentAvailableSpells);
                    GenerateStaff.copyList(GenerateStaff.IllusionNames, possibleNames);
                    break;
                case 16:
                    GenerateStaff.copyDictionary(DeathSpells, currentAvailableSpells);
                    GenerateStaff.copyList(GenerateStaff.DeathNames, possibleNames);
                    break;
                case 17:
                    GenerateStaff.copyDictionary(EvilSpells, currentAvailableSpells);
                    GenerateStaff.copyList(GenerateStaff.EvilNames, possibleNames);
                    break;
                case 18:
                    GenerateStaff.copyDictionary(GoodSpells, currentAvailableSpells);
                    GenerateStaff.copyList(GenerateStaff.GoodNames, possibleNames);
                    break;
                case 19:
                    GenerateStaff.copyDictionary(ProtectionSpells, currentAvailableSpells);
                    GenerateStaff.copyList(GenerateStaff.ProtectionNames, possibleNames);
                    break;
                case 20:
                    GenerateStaff.copyDictionary(HealingSpells, currentAvailableSpells);
                    GenerateStaff.copyList(GenerateStaff.HealingNames, possibleNames);
                    break;
                case 21:
                    GenerateStaff.copyDictionary(SummonSpells, currentAvailableSpells);
                    GenerateStaff.copyList(GenerateStaff.SummonNames, possibleNames);
                    break;
            }
            if (currentAvailableSpells.Count == 0 || possibleNames.Count == 0)
            {
                return 0;
            }
            #endregion

            #region Select Spells from Collections Based on Price
            Dictionary<int, int> SelectedSpells = new Dictionary<int, int>();
            List<int> SelectedPrices = new List<int>();
            int currentCharges = 5;
            int maxSpellValue = maxValue;
            while (true)
            {
                List<int> spellsToRemove = new List<int>();
                foreach (int spell in currentAvailableSpells.Keys)
                {
                    if (((currentAvailableSpells[spell] * 50) / currentCharges) > maxValue ||
                        currentAvailableSpells[spell] > maxSpellValue)
                    {
                        spellsToRemove.Add(spell);
                    }
                }
                foreach (int spell in spellsToRemove)
                {
                    currentAvailableSpells.Remove(spell);
                }
                if (currentAvailableSpells.Count == 0)
                {
                    if(SelectedSpells.Count == 0)
                    {
                        return 0;
                    }
                    else
                    {
                        break;
                    }
                }
                List<int> spellOptions = new List<int>();
                foreach (int key in currentAvailableSpells.Keys)
                {
                    spellOptions.Add(key);
                }
                int spellSelection = spellOptions[Generation.rand.Next(spellOptions.Count)];
                switch (currentCharges)
                {
                    case 1:
                        SelectedSpells.Add(spellSelection, IP_CONST_CASTSPELL_NUMUSES_1_CHARGE_PER_USE);
                        SelectedPrices.Add(currentAvailableSpells[spellSelection] * 50);
                        currentCharges--;
                        break;
                    case 2:
                        SelectedSpells.Add(spellSelection, IP_CONST_CASTSPELL_NUMUSES_2_CHARGES_PER_USE);
                        SelectedPrices.Add(currentAvailableSpells[spellSelection] * 25);
                        maxSpellValue = currentAvailableSpells[spellSelection] - 1;
                        maxValue -= currentAvailableSpells[spellSelection] * 25;
                        currentCharges--;
                        break;
                    case 3:
                        SelectedSpells.Add(spellSelection, IP_CONST_CASTSPELL_NUMUSES_3_CHARGES_PER_USE);
                        SelectedPrices.Add(currentAvailableSpells[spellSelection] * 16);
                        maxSpellValue = currentAvailableSpells[spellSelection] - 1;
                        maxValue -= currentAvailableSpells[spellSelection] * 16;
                        currentCharges--;
                        break;
                    case 4:
                        SelectedSpells.Add(spellSelection, IP_CONST_CASTSPELL_NUMUSES_4_CHARGES_PER_USE);
                        SelectedPrices.Add(currentAvailableSpells[spellSelection] * 12);
                        maxSpellValue = currentAvailableSpells[spellSelection] - 1;
                        maxValue -= currentAvailableSpells[spellSelection] * 12;
                        currentCharges--;
                        break;
                    case 5:
                        SelectedSpells.Add(spellSelection, IP_CONST_CASTSPELL_NUMUSES_5_CHARGES_PER_USE);
                        SelectedPrices.Add(currentAvailableSpells[spellSelection] * 10);
                        maxSpellValue = currentAvailableSpells[spellSelection] - 1;
                        maxValue -= currentAvailableSpells[spellSelection] * 10;
                        currentCharges--;
                        break;
                }
                if (currentCharges == 0)
                {
                    break;
                }
            }
            #endregion

            #region Sum Predicted Values of Properties
            SelectedPrices.Sort();
            int value = SelectedPrices[0];
            if (SelectedPrices.Count > 1)
            {
                value += (SelectedPrices[1] * 3 / 4);
            }
            if (SelectedPrices.Count > 2)
            {
                value += (SelectedPrices[2] / 2);
            }
            if (SelectedPrices.Count > 3)
            {
                value += (SelectedPrices[3] / 2);
            }
            if (SelectedPrices.Count > 4)
            {
                value += (SelectedPrices[4] / 2);
            }
            #endregion

            #region Build the Actual Staff
            uint staff = script.CreateItemOnObject(GenerateWeapon.WeaponResrefs[BASE_ITEM_LIGHTMACE], script.OBJECT_SELF, 1, "", FALSE);
            script.SetItemCharges(staff, 50);
            foreach (KeyValuePair<int, int> Spell in SelectedSpells)
            {
                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyCastSpell(Spell.Key, Spell.Value), staff, 0.0f);
            }
            script.SetFirstName(staff, String.Format(possibleNames[Generation.rand.Next(possibleNames.Count)], "Rod"));
            Pricing.CalculatePrice(script, staff);
            #endregion
            return value;
        }

        #region Rod-Specific Dictionaries and Their Converter
        public static Dictionary<int, int> FireSpells = new Dictionary<int,int>();
        public static Dictionary<int, int> ColdSpells = new Dictionary<int, int>();
        public static Dictionary<int, int> AcidSpells = new Dictionary<int, int>();
        public static Dictionary<int, int> ElectricSpells = new Dictionary<int, int>();
        public static Dictionary<int, int> SoundSpells = new Dictionary<int, int>();
        public static Dictionary<int, int> PhysicalAttackSpells = new Dictionary<int, int>();
        public static Dictionary<int, int> ForceSpells = new Dictionary<int, int>();
        public static Dictionary<int, int> MoraleSpells = new Dictionary<int, int>();
        public static Dictionary<int, int> AntimoraleSpells = new Dictionary<int, int>();
        public static Dictionary<int, int> MindControlSpells = new Dictionary<int, int>();
        public static Dictionary<int, int> PerceptionSpells = new Dictionary<int, int>();
        public static Dictionary<int, int> PhysicalSpells = new Dictionary<int, int>();
        public static Dictionary<int, int> MentalSpells = new Dictionary<int, int>();
        public static Dictionary<int, int> Transmutations = new Dictionary<int, int>();
        public static Dictionary<int, int> AntiMagicSpells = new Dictionary<int, int>();
        public static Dictionary<int, int> IllusionSpells = new Dictionary<int, int>();
        public static Dictionary<int, int> DeathSpells = new Dictionary<int, int>();
        public static Dictionary<int, int> EvilSpells = new Dictionary<int, int>();
        public static Dictionary<int, int> GoodSpells = new Dictionary<int, int>();
        public static Dictionary<int, int> ProtectionSpells = new Dictionary<int, int>();
        public static Dictionary<int, int> HealingSpells = new Dictionary<int, int>();
        public static Dictionary<int, int> SummonSpells = new Dictionary<int, int>();

        private static void convertToRodPrice(Dictionary<int, int> from, Dictionary<int, int> to)
        {
            foreach (KeyValuePair<int, int> key in from)
            {
                to.Add(key.Key, key.Value * 36 / 15);
            }
        }
        #endregion
    }
}
