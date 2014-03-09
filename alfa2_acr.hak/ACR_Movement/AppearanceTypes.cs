using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using CLRScriptFramework;
using ALFA;
using NWScript;
using NWScript.ManagedInterfaceLayer.NWScriptManagedInterface;

using NWEffect = NWScript.NWScriptEngineStructure0;
using NWEvent = NWScript.NWScriptEngineStructure1;
using NWLocation = NWScript.NWScriptEngineStructure2;
using NWTalent = NWScript.NWScriptEngineStructure3;
using NWItemProperty = NWScript.NWScriptEngineStructure4;

namespace ACR_Movement
{
    class AppearanceTypes
    {
        #region Constants
        const int DwarfBase = 0;
        const int ElfBase = 1;
        const int GnomeBase = 2;
        const int HalflingBase = 3;
        const int HalfElfBase = 4;
        const int HalfOrcBase = 5;
        const int HumanBase = 6;
        const int AasimarBase = 7;
        const int TieflingBase = 8;
        const int ElfSunBase = 9;
        const int ElfWoodBase = 10;
        const int ElfDrowBase = 11;
        const int SvirfBase = 12;
        const int DwarfGoldBase = 13;
        const int DuergarBase = 14;
        const int HalfStrongBase = 15;
        const int ElfWildBase = 16;
        const int EarthGenasiBase = 17;
        const int FireGenasiBase = 18;
        const int AirGenasiBase = 19;
        const int WaterGenasiBase = 20;
        const int HalfDrowBase = 21;
        const int YuantiPurebloodBase = 22;

        const int Swim = 3500;
        const int Ride_12 = 3525;
        const int Walk_01 = 3800;
        const int Ride_02 = 3825;
        const int Walk_05 = 3850;
        const int Walk_10 = 3875;
        const int Walk_11 = 3900;
        const int Walk_12 = 3925;
        const int Walk_13 = 3950;
        const int Walk_14 = 3975;
        const int Walk_15 = 4000;
        const int Walk_16 = 4025;
        const int Walk_17 = 4050;
        const int Walk_18 = 4075;
        const int Walk_19 = 4100;
        const int Walk_20 = 4125;
        const int Walk_21 = 4150;
        const int Walk_22 = 4175;
        #endregion

        #region Storage of Movement Types
        public static Dictionary<uint, MovementType> characterMovement = new Dictionary<uint, MovementType>();
        public static Dictionary<uint, bool> overlandMap = new Dictionary<uint, bool>();

        public enum MovementType
        {
            Walking = 0,
            Swimming = 1,
            Riding = 2
        }
        #endregion

        public static int GetBaseAppearance(CLRScriptBase script, uint Character)
        {
            int race = script.GetRacialType(Character);
            if (race == CLRScriptBase.RACIAL_TYPE_ABERRATION ||
               race == CLRScriptBase.RACIAL_TYPE_ANIMAL ||
               race == CLRScriptBase.RACIAL_TYPE_BEAST ||
               race == CLRScriptBase.RACIAL_TYPE_CONSTRUCT ||
               race == CLRScriptBase.RACIAL_TYPE_DRAGON ||
               race == CLRScriptBase.RACIAL_TYPE_ELEMENTAL ||
               race == CLRScriptBase.RACIAL_TYPE_FEY ||
               race == CLRScriptBase.RACIAL_TYPE_GIANT ||
               race == CLRScriptBase.RACIAL_TYPE_HUMANOID_GOBLINOID ||
               race == CLRScriptBase.RACIAL_TYPE_HUMANOID_MONSTROUS ||
               race == CLRScriptBase.RACIAL_TYPE_HUMANOID_ORC ||
               race == CLRScriptBase.RACIAL_TYPE_HUMANOID_REPTILIAN ||
               race == CLRScriptBase.RACIAL_TYPE_INCORPOREAL ||
               race == CLRScriptBase.RACIAL_TYPE_INVALID ||
               race == CLRScriptBase.RACIAL_TYPE_MAGICAL_BEAST ||
               race == CLRScriptBase.RACIAL_TYPE_OOZE ||
               race == CLRScriptBase.RACIAL_TYPE_OUTSIDER ||
               race == CLRScriptBase.RACIAL_TYPE_SHAPECHANGER ||
               race == CLRScriptBase.RACIAL_TYPE_UNDEAD ||
               race == CLRScriptBase.RACIAL_TYPE_VERMIN ||
               race == CLRScriptBase.RACIAL_TYPE_YUANTI)
            {
                return -1;
            }
            else if (race == CLRScriptBase.RACIAL_TYPE_DWARF)
            {
                int subrace = script.GetSubRace(Character);
                if(subrace == CLRScriptBase.RACIAL_SUBTYPE_GOLD_DWARF)
                {
                    return DwarfGoldBase;
                }
                else if(subrace == CLRScriptBase.RACIAL_SUBTYPE_GRAY_DWARF)
                {
                    return DuergarBase;
                }
                return DwarfBase;
            }
            else if (race == CLRScriptBase.RACIAL_TYPE_ELF)
            {
                int subrace = script.GetSubRace(Character);
                if(subrace == CLRScriptBase.RACIAL_SUBTYPE_DROW)
                {
                    return ElfDrowBase;
                }
                else if(subrace == CLRScriptBase.RACIAL_SUBTYPE_SUN_ELF)
                {
                    return ElfSunBase;
                }
                else if(subrace == CLRScriptBase.RACIAL_SUBTYPE_WILD_ELF)
                {
                    return ElfWildBase;
                }
                else if(subrace == CLRScriptBase.RACIAL_SUBTYPE_WOOD_ELF)
                {
                    return ElfWoodBase;
                }
                return ElfBase;
            }
            else if(race == CLRScriptBase.RACIAL_TYPE_GNOME)
            {
                int subrace = script.GetSubRace(Character);
                if(subrace == CLRScriptBase.RACIAL_SUBTYPE_SVIRFNEBLIN)
                {
                    return SvirfBase;
                }
                return GnomeBase;
            }
            else if (race == CLRScriptBase.RACIAL_TYPE_GRAYORC)
            {
                return HalfOrcBase;
            }
            else if (race == CLRScriptBase.RACIAL_TYPE_HALFELF)
            {
                int subrace = script.GetSubRace(Character);
                if(subrace == CLRScriptBase.RACIAL_SUBTYPE_HALFDROW)
                {
                    return HalfDrowBase;
                }
                return HalfElfBase;
            }
            else if (race == CLRScriptBase.RACIAL_TYPE_HALFLING)
            {
                int subrace = script.GetSubRace(Character);
                if(subrace == CLRScriptBase.RACIAL_SUBTYPE_STRONGHEART_HALF)
                {
                    return HalfStrongBase;
                }
                return HalflingBase;
            }
            else if(race == CLRScriptBase.RACIAL_TYPE_HALFORC)
            {
                return HalfOrcBase;
            }
            else if(race == CLRScriptBase.RACIAL_TYPE_HUMAN)
            {
                int subrace = script.GetSubRace(Character);
                if(subrace == CLRScriptBase.RACIAL_SUBTYPE_AASIMAR)
                {
                    return AasimarBase;
                }
                else if(subrace == CLRScriptBase.RACIAL_SUBTYPE_AIR_GENASI)
                {
                    return AirGenasiBase;
                }
                else if(subrace == CLRScriptBase.RACIAL_SUBTYPE_EARTH_GENASI)
                {
                    return EarthGenasiBase;
                }
                else if(subrace == CLRScriptBase.RACIAL_SUBTYPE_FIRE_GENASI)
                {
                    return FireGenasiBase;
                }
                else if(subrace == CLRScriptBase.RACIAL_SUBTYPE_TIEFLING)
                {
                    return TieflingBase;
                }
                else if (subrace == CLRScriptBase.RACIAL_SUBTYPE_WATER_GENASI)
                {
                    return WaterGenasiBase;
                }
                return HumanBase;
            }
            return -1;
        }

        public static void RecalculateMovement(CLRScriptBase script, uint Creature)
        {
            int appType = GetBaseAppearance(script, Creature);
            if (appType < 0)
            {
                return;
            }
            if(overlandMap[Creature])
            {
                if(characterMovement[Creature] == MovementType.Riding)
                {
                    appType += Ride_02;
                    script.SetCreatureAppearanceType(Creature, appType);
                    return;
                }
                else
                {
                    appType += Walk_01;
                    script.SetCreatureAppearanceType(Creature, appType);
                    return;
                }
            }
            else if(characterMovement[Creature] == MovementType.Riding)
            {
                appType += Ride_12;
                script.SetCreatureAppearanceType(Creature, appType);
                return;
            }
            else if (characterMovement[Creature] == MovementType.Swimming)
            {
                appType += Swim;
                script.SetCreatureAppearanceType(Creature, appType);
                return;
            }
            else
            {
                int moveRate = 10;
                if(script.GetHasFeat(CLRScriptBase.FEAT_BARBARIAN_ENDURANCE, Creature, CLRScriptBase.TRUE) == CLRScriptBase.TRUE)
                {
                    // Barbarians get +0.4m/s when not wearing heavy armor and not carrying a heavy load.
                    if (script.GetEncumbranceState(Creature) != CLRScriptBase.ENCUMBRANCE_STATE_OVERLOADED &&
                        script.GetArmorRank(script.GetItemInSlot(CLRScriptBase.INVENTORY_SLOT_CHEST, Creature)) != CLRScriptBase.ARMOR_RANK_HEAVY)
                    {
                        moveRate += 1;
                    }
                }
                if(script.GetLevelByClass(CLRScriptBase.CLASS_TYPE_MONK, Creature) >= 3)
                {
                    // Unarmored monks get +0.4m/s of movement for every 3 levels, up to level 18.
                    if(script.GetEncumbranceState(Creature) != CLRScriptBase.ENCUMBRANCE_STATE_HEAVY &&
                       script.GetEncumbranceState(Creature) != CLRScriptBase.ENCUMBRANCE_STATE_OVERLOADED &&
                       script.GetArmorRank(script.GetItemInSlot(CLRScriptBase.INVENTORY_SLOT_CHEST, Creature)) == CLRScriptBase.ARMOR_RANK_NONE)
                    {
                        if (script.GetLevelByClass(CLRScriptBase.CLASS_TYPE_MONK, Creature) >= 18) moveRate++;
                        if (script.GetLevelByClass(CLRScriptBase.CLASS_TYPE_MONK, Creature) >= 15) moveRate++;
                        if (script.GetLevelByClass(CLRScriptBase.CLASS_TYPE_MONK, Creature) >= 12) moveRate++;
                        if (script.GetLevelByClass(CLRScriptBase.CLASS_TYPE_MONK, Creature) >= 9) moveRate++;
                        if (script.GetLevelByClass(CLRScriptBase.CLASS_TYPE_MONK, Creature) >= 6) moveRate++;
                        moveRate++;
                    }
                }
                if(script.GetHasFeat(CLRScriptBase.FEAT_NW9_FRANTIC_REACTIONS, Creature, CLRScriptBase.TRUE) == CLRScriptBase.TRUE)
                {
                    // Level 3+ knight protectors have frantic reactions, and thus +0.4m/s
                    moveRate++;
                }
                switch (moveRate)
                {
                    case 10:
                        appType += Walk_10;
                        break;
                    case 11:
                        appType += Walk_11;
                        break;
                    case 12:
                        appType += Walk_12;
                        break;
                    case 13:
                        appType += Walk_13;
                        break;
                    case 14:
                        appType += Walk_14;
                        break;
                    case 15:
                        appType += Walk_15;
                        break;
                    case 16:
                        appType += Walk_16;
                        break;
                    case 17:
                        appType += Walk_17;
                        break;
                    case 18:
                        appType += Walk_18;
                        break;
                    case 19:
                        appType += Walk_19;
                        break;
                    case 20:
                        appType += Walk_20;
                        break;
                    case 21:
                        appType += Walk_21;
                        break;
                    case 22:
                        appType += Walk_22;
                        break;
                }

                script.SetCreatureAppearanceType(Creature, appType);
                return;
            }
        }
    }
}
