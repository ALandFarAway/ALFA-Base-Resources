﻿using System;
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
    class Riding
    {
        public const string ACR_IS_WARHORSE = "ACR_IS_WARHORSE";
        public const string ACR_HORSE_OWNER = "ACR_HORSE_OWNER";
        public const string ACR_CID = "ACR_CID";
        public const string ACR_HORSE_ID = "ACR_HORSE_ID";
        public const string ACR_HORSE_OBJECT = "ACR_HORSE_OBJECT";
        public const string ACR_PAL_WARHORSE = "ACR_PAL_WARHORSE";
        public const string ACR_HORSE_HP = "ACR_HORSE_HP";

        const string ACR_HORSE_PERS_LOC_AREA = "ACR_HORSE_PERS_LOC_AREA";
        const string ACR_HORSE_PERS_LOC_X = "ACR_HORSE_PERS_LOC_X";
        const string ACR_HORSE_PERS_LOC_Y = "ACR_HORSE_PERS_LOC_Y";
        const string ACR_HORSE_PERS_LOC_Z = "ACR_HORSE_PERS_LOC_Z";

        public static Dictionary<uint, bool> isWarhorse = new Dictionary<uint, bool>();

        public static void MountHorse(CLRScriptBase script, uint Character, uint Horse)
        {
            if (!isWarhorse.ContainsKey(Character)) isWarhorse.Add(Character, true);

            string cloakResRef;
            switch(script.GetTag(Horse))
            {
                case "abr_cr_an_horse01":
                    cloakResRef = "acr_ooc_horse01";
                    isWarhorse[Character] = true;
                    break;
                case "abr_cr_an_horse02":
                    cloakResRef = "acr_ooc_horse02";
                    isWarhorse[Character] = true;
                    break;
                case "abr_cr_an_horse03":
                    cloakResRef = "acr_ooc_horse03";
                    isWarhorse[Character] = true;
                    break;
                default:
                    cloakResRef = "acr_ooc_horse03";
                    isWarhorse[Character] = true;
                    break;
            }
            
            uint horseCloak = script.CreateItemOnObject(cloakResRef, Character, 1, "", CLRScriptBase.FALSE);
            if (script.GetLocalInt(Horse, ACR_IS_WARHORSE) == 1)
            {
                script.RemoveHenchman(Character, Horse);
                script.SetLocalInt(horseCloak, ACR_IS_WARHORSE, 1);
            }
            script.SetLocalInt(horseCloak, ACR_HORSE_ID, script.GetLocalInt(Horse, ACR_HORSE_ID));
            script.SetLocalInt(horseCloak, ACR_HORSE_HP, script.GetCurrentHitPoints(Horse));

            uint equippedCloak = script.GetItemInSlot(CLRScriptBase.INVENTORY_SLOT_CLOAK, Character);
            
            if (script.GetIsObjectValid(equippedCloak) == CLRScriptBase.TRUE)
            {
                foreach (NWItemProperty prop in script.GetItemPropertiesOnItem(equippedCloak))
                {
                    // copying property duration type prevents us from turning temporary properties into
                    // permanent ones. But because we don't know how long the non-permanent ones have left,
                    // we pretty much have to assign them with the expectation that they immediately expire.
                    script.AddItemProperty(script.GetItemPropertyDurationType(prop), prop, horseCloak, 0.0f);
                }
                script.SetFirstName(horseCloak, script.GetName(equippedCloak) + "(( Horse Appearance ))");
                script.AddItemProperty(CLRScriptBase.DURATION_TYPE_PERMANENT, script.ItemPropertyWeightReduction(CLRScriptBase.IP_CONST_REDUCEDWEIGHT_80_PERCENT), horseCloak, 0.0f);
            }
            script.SetPlotFlag(horseCloak, CLRScriptBase.TRUE);
            script.SetPlotFlag(Horse, CLRScriptBase.FALSE);
            
            script.AssignCommand(Horse, delegate { script.SetIsDestroyable(CLRScriptBase.TRUE, CLRScriptBase.FALSE, CLRScriptBase.FALSE); });
            script.AssignCommand(Horse, delegate { script.DestroyObject(Horse, 0.0f, CLRScriptBase.FALSE); });
            script.AssignCommand(Character, delegate { script.ActionEquipItem(horseCloak, CLRScriptBase.INVENTORY_SLOT_CLOAK); });

            if (!isWarhorse[Character]) script.DelayCommand(6.0f, delegate { RidingHeartbeat(script, Character); });
        }

        private static void RidingHeartbeat(CLRScriptBase script, uint Character)
        {
            // Character has dismounted
            if (!isWarhorse.ContainsKey(Character)) return;

            script.DelayCommand(6.0f, delegate { RidingHeartbeat(script, Character); });
        }

        public static void Dismount(CLRScriptBase script, uint Character, uint Cloak, NWLocation Location)
        {
            string resRef = "";
            if (script.GetLocalInt(Cloak, ACR_IS_WARHORSE) == 1)
            {
                resRef = "abr_cr_an_horse_pal_";
                int nPalLevel = script.GetLevelByClass(CLRScriptBase.CLASS_TYPE_PALADIN, Character);
                if (nPalLevel >= 15) resRef += "15";
                else if (nPalLevel >= 11) resRef += "11";
                else if (nPalLevel >= 8) resRef += "8";
                else if (nPalLevel >= 5) resRef += "5";
                else resRef = "abr_cr_an_horse03";
            }
            else
            {
                switch (script.GetTag(Cloak))
                {
                    case "acr_ooc_horse01":
                        resRef = "abr_cr_an_horse01";
                        break;
                    case "acr_ooc_horse02":
                        resRef = "abr_cr_an_horse02";
                        break;
                    case "acr_ooc_horse03":
                        resRef = "abr_cr_an_horse03";
                        break;
                    default:
                        // Looks like we're not actually dismounting a horse.
                        return;
                }
            }
            
            uint Horse = script.CreateObject(CLRScriptBase.OBJECT_TYPE_CREATURE, resRef, Location, CLRScriptBase.FALSE, "");
            script.SetLocalInt(Horse, ACR_HORSE_OWNER, script.GetLocalInt(Character, ACR_CID));
            script.SetLocalInt(Horse, ACR_HORSE_ID, script.GetLocalInt(Cloak, ACR_HORSE_ID));
            int damage = script.GetCurrentHitPoints(Horse) - script.GetLocalInt(Cloak, ACR_HORSE_HP);
            if(damage > 0)
            {
                script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_INSTANT, script.EffectDamage(damage, CLRScriptBase.DAMAGE_TYPE_MAGICAL, CLRScriptBase.DAMAGE_POWER_PLUS_TWENTY, CLRScriptBase.TRUE), Horse, 0.0f);
            }
            if (script.GetLocalInt(Cloak, ACR_IS_WARHORSE) == 1)
            {
                script.AddHenchman(Character, Horse);
                script.SetLocalInt(Horse, ACR_IS_WARHORSE, 1);
                script.SetLocalObject(Character, ACR_PAL_WARHORSE, Horse);
            }

            uint Item = GetOwnershipItemById(script, Character, script.GetLocalInt(Cloak, ACR_HORSE_ID));
            script.SetLocalObject(Item , ACR_HORSE_OBJECT, Horse);
            script.SetLocalObject(Horse, ACR_HORSE_OBJECT, Character);

            script.SetLocalString(Item, ACR_HORSE_PERS_LOC_AREA, script.GetTag(script.GetArea(Horse)));
            script.SetLocalFloat(Item, ACR_HORSE_PERS_LOC_X, script.GetPosition(Horse).x);
            script.SetLocalFloat(Item, ACR_HORSE_PERS_LOC_Y, script.GetPosition(Horse).y);
            script.SetLocalFloat(Item, ACR_HORSE_PERS_LOC_Z, script.GetPosition(Horse).z);

            script.SetPlotFlag(Cloak, CLRScriptBase.FALSE);
            script.DestroyObject(Cloak, 0.0f, CLRScriptBase.FALSE);
            isWarhorse.Remove(Character);
        }

        public static uint GetOwnershipItemById(CLRScriptBase script, uint Character, int HorseId)
        {
            uint item = script.GetFirstItemInInventory(Character);
            while(script.GetIsObjectValid(item) == CLRScriptBase.TRUE)
            {
                if(script.GetLocalInt(item, ACR_HORSE_ID) == HorseId)
                {
                    return item;
                }
                item = script.GetNextItemInInventory(Character);
            }
            return CLRScriptBase.OBJECT_INVALID;
        }
    }
}