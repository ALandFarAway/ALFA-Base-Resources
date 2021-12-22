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
    public partial class ACR_Items : CLRScriptBase, IGeneratedScriptProgram
    {
        public ACR_Items([In] NWScriptJITIntrinsics Intrinsics, [In] INWScriptProgram Host)
        {
            InitScript(Intrinsics, Host);
        }

        private ACR_Items([In] ACR_Items Other)
        {
            InitScript(Other);

            LoadScriptGlobals(Other.SaveScriptGlobals());
        }

        public static Type[] ScriptParameterTypes =
        { typeof(uint), typeof(int), typeof(int), typeof(int) };

        public Int32 ScriptMain([In] object[] ScriptParameters, [In] Int32 DefaultReturnCode)
        {
            uint Target = (uint)ScriptParameters[0];
            int Command = (int)ScriptParameters[1];
            int Param1 = (int)ScriptParameters[2];
            int Param2 = (int)ScriptParameters[3];

            switch((ItemCommand)Command)
            {
                #region Alter Prices of Existing Items
                case ItemCommand.AdjustPrice:
                    {
                        Pricing.AdjustPrice(this, Target, Param1);
                        break;
                    }
                case ItemCommand.CalculatePrice:
                    {
                        Pricing.CalculatePrice(this, Target);
                        break;
                    }
                #endregion
                #region Generate New Random Items
                case ItemCommand.GenerateLoot:
                    {
                        Generation.GenerateLoot(this, Param1, Param2);
                        break;
                    }
                case ItemCommand.GenerateArmorFirst:
                    {
                        if (Param2 > Param1) Param2 = Param1;
                        Param1 -= GenerateArmor.NewArmor(this, Param2);
                        Generation.GenerateLoot(this, Param1, Param2);
                        break;
                    }
                case ItemCommand.GenerateAmuletFirst:
                    {
                        if (Param2 > Param1) Param2 = Param1;
                        Param1 -= GenerateAmulet.NewAmulet(this, Param2);
                        Generation.GenerateLoot(this, Param1, Param2);
                        break;
                    }
                case ItemCommand.GenerateBeltFirst:
                    {
                        if (Param2 > Param1) Param2 = Param1;
                        Param1 -= GenerateBelt.NewBelt(this, Param2);
                        Generation.GenerateLoot(this, Param1, Param2);
                        break;
                    }
                case ItemCommand.GenerateBootsFirst:
                    {
                        if (Param2 > Param1) Param2 = Param1;
                        Param1 -= GenerateBoots.NewBoots(this, Param2);
                        Generation.GenerateLoot(this, Param1, Param2);
                        break;
                    }
                case ItemCommand.GenerateCloakFirst:
                    {
                        if (Param2 > Param1) Param2 = Param1;
                        Param1 -= GenerateCloak.NewCloak(this, Param2);
                        Generation.GenerateLoot(this, Param1, Param2);
                        break;
                    }
                case ItemCommand.GenerateGlovesFirst:
                    {
                        if (Param2 > Param1) Param2 = Param1;
                        Param1 -= GenerateGloves.NewGloves(this, Param2);
                        Generation.GenerateLoot(this, Param1, Param2);
                        break;
                    }
                case ItemCommand.GenerateHelmetFirst:
                    {
                        if (Param2 > Param1) Param2 = Param1;
                        Param1 -= GenerateHelmet.NewHelmet(this, Param2);
                        Generation.GenerateLoot(this, Param1, Param2);
                        break;
                    }
                case ItemCommand.GenerateRingFirst:
                    {
                        if (Param2 > Param1) Param2 = Param1;
                        Param1 -= GenerateRing.NewRing(this, Param2);
                        Generation.GenerateLoot(this, Param1, Param2);
                        break;
                    }
                case ItemCommand.GenerateRodFirst:
                    {
                        if (Param2 > Param1) Param2 = Param1;
                        Param1 -= GenerateRod.NewRod(this, Param2);
                        Generation.GenerateLoot(this, Param1, Param2);
                        break;
                    }
                case ItemCommand.GenerateStaffFirst:
                    {
                        if (Param2 > Param1) Param2 = Param1;
                        Param1 -= GenerateStaff.NewStaff(this, Param2);
                        Generation.GenerateLoot(this, Param1, Param2);
                        break;
                    }
                case ItemCommand.GenerateWandFirst:
                    {
                        if (Param2 > Param1) Param2 = Param1;
                        Param1 -= GenerateWand.NewWand(this, Param2);
                        Generation.GenerateLoot(this, Param1, Param2);
                        break;
                    }
                case ItemCommand.GenerateWeaponFirst:
                    {
                        if (Param2 > Param1) Param2 = Param1;
                        Param1 -= GenerateWeapon.NewWeapon(this, Param2);
                        Generation.GenerateLoot(this, Param1, Param2);
                        break;
                    }
                case ItemCommand.GenerateScrolls:
                    {
                        while (Param1 >= 25)
                        {
                            if (Param2 > Param1) Param2 = Param1;
                            Param1 -= GenerateScroll.NewScroll(this, Param2);
                        }
                        break;
                    }
                case ItemCommand.GeneratePotions:
                    {
                        while (Param1 >= 50)
                        {
                            if (Param2 > Param1) Param2 = Param1;
                            Param1 -= GeneratePotion.NewPotion(this, Param2);
                        }
                        break;
                    }
                #endregion
                #region Get Accessory Models
                case ItemCommand.GetLeftAnkleModel:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { return ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtAnkle"].ValueStruct["Accessory"].ValueByte; }
                            catch { return -1; }
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetLeftArmModel:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { return ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtArm"].ValueStruct["Accessory"].ValueByte; }
                            catch { return -1; }
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetLeftBracerModel:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { return ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtBracer"].ValueStruct["Accessory"].ValueByte; }
                            catch { return -1; }
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetLeftElbowModel:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { return ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtElbow"].ValueStruct["Accessory"].ValueByte; }
                            catch { return -1; }
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetLeftFootModel:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { return ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtFoot"].ValueStruct["Accessory"].ValueByte; }
                            catch { return -1; }
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetLeftHipModel:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { return ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtHip"].ValueStruct["Accessory"].ValueByte; }
                            catch { return -1; }
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetLeftKneeModel:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { return ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtKnee"].ValueStruct["Accessory"].ValueByte; }
                            catch { return -1; }
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetLeftLegModel:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { return ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtLeg"].ValueStruct["Accessory"].ValueByte; }
                            catch { return -1; }
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetLeftShinModel:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { return ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtShin"].ValueStruct["Accessory"].ValueByte; }
                            catch { return -1; }
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetLeftShoulderModel:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { return ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtShoulder"].ValueStruct["Accessory"].ValueByte; }
                            catch { return -1; }
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetRightAnkleModel:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { return ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtAnkle"].ValueStruct["Accessory"].ValueByte; }
                            catch { return -1; }
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetRightArmModel:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { return ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtArm"].ValueStruct["Accessory"].ValueByte; }
                            catch { return -1; }
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetRightBracerModel:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { return ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtBracer"].ValueStruct["Accessory"].ValueByte; }
                            catch { return -1; }
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetRightElbowModel:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { return ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtElbow"].ValueStruct["Accessory"].ValueByte; }
                            catch { return -1; }
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetRightFootModel:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { return ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtFoot"].ValueStruct["Accessory"].ValueByte; }
                            catch { return -1; }
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetRightHipModel:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { return ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtHip"].ValueStruct["Accessory"].ValueByte; }
                            catch { return -1; }
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetRightKneeModel:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { return ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtKnee"].ValueStruct["Accessory"].ValueByte; }
                            catch { return -1; }
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetRightLegModel:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { return ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtLeg"].ValueStruct["Accessory"].ValueByte; }
                            catch { return -1; }
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetRightShinModel:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { return ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtShin"].ValueStruct["Accessory"].ValueByte; }
                            catch { return -1; }
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetRightShoulderModel:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { return ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtShoulder"].ValueStruct["Accessory"].ValueByte; }
                            catch { return -1; }
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetFrontHipModel:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { return ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACFtHip"].ValueStruct["Accessory"].ValueByte; }
                            catch { return -1; }
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetBackHipModel:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { return ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACBkHip"].ValueStruct["Accessory"].ValueByte; }
                            catch { return -1; }
                        }
                        else
                        {
                            return -1;
                        }
                    }
                #endregion
                #region Get Visual-Type-Driven Models
                case ItemCommand.GetArmorVariation:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { return ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Variation"].ValueByte; }
                            catch { return -1; }
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetArmorVisualType:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { return ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ArmorVisualType"].ValueByte; }
                            catch { return -1; }
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetBeltVariation:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { return ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Belt"].ValueStruct["Variation"].ValueByte; }
                            catch { return -1; }
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetBeltVisualType:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { return ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Belt"].ValueStruct["ArmorVisualType"].ValueByte; }
                            catch { return -1; }
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetBootsVariation:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { return ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Boots"].ValueStruct["Variation"].ValueByte; }
                            catch { return -1; }
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetBootsVisualType:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { return ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Boots"].ValueStruct["ArmorVisualType"].ValueByte; }
                            catch { return -1; }
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetCloakVariation:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { return ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Cloak"].ValueStruct["Variation"].ValueByte; }
                            catch { return -1; }
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetCloakVisualType:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { return ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Cloak"].ValueStruct["ArmorVisualType"].ValueByte; }
                            catch { return -1; }
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetGlovesVariation:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { return ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Gloves"].ValueStruct["Variation"].ValueByte; }
                            catch { return -1; }
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetGlovesVisualType:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { return ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Gloves"].ValueStruct["ArmorVisualType"].ValueByte; }
                            catch { return -1; }
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetHelmetVariation:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { return ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Helm"].ValueStruct["Variation"].ValueByte; }
                            catch { return -1; }
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetHelmetVisualType:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { return ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Helm"].ValueStruct["Variation"].ValueByte; }
                            catch { return -1; }
                        }
                        else
                        {
                            return -1;
                        }
                    }
                #endregion
                #region Get Accessory Colors
                case ItemCommand.GetLeftAnkleColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        if (Param2 > 3 || Param2 < 0) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            return ItemColors.GetAccessoryColor("ACLtAnkle", Param1, (ColorType)Param2);
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetLeftArmColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        if (Param2 > 3 || Param2 < 0) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            return ItemColors.GetAccessoryColor("ACLtArm", Param1, (ColorType)Param2);
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetLeftBracerColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        if (Param2 > 3 || Param2 < 0) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            return ItemColors.GetAccessoryColor("ACLtBracer", Param1, (ColorType)Param2);
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetLeftElbowColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        if (Param2 > 3 || Param2 < 0) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            return ItemColors.GetAccessoryColor("ACLtElbow", Param1, (ColorType)Param2);
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetLeftFootColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        if (Param2 > 3 || Param2 < 0) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            return ItemColors.GetAccessoryColor("ACLtFoot", Param1, (ColorType)Param2);
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetLeftHipColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        if (Param2 > 3 || Param2 < 0) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            return ItemColors.GetAccessoryColor("ACLtHip", Param1, (ColorType)Param2);
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetLeftKneeColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        if (Param2 > 3 || Param2 < 0) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            return ItemColors.GetAccessoryColor("ACLtKnee", Param1, (ColorType)Param2);
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetLeftLegColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        if (Param2 > 3 || Param2 < 0) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            return ItemColors.GetAccessoryColor("ACLtLeg", Param1, (ColorType)Param2);
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetLeftShinColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        if (Param2 > 3 || Param2 < 0) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            return ItemColors.GetAccessoryColor("ACLtShin", Param1, (ColorType)Param2);
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetLeftShoulderColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        if (Param2 > 3 || Param2 < 0) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            return ItemColors.GetAccessoryColor("ACLtShoulder", Param1, (ColorType)Param2);
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetRightAnkleColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        if (Param2 > 3 || Param2 < 0) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            return ItemColors.GetAccessoryColor("ACRtAnkle", Param1, (ColorType)Param2);
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetRightArmColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        if (Param2 > 3 || Param2 < 0) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            return ItemColors.GetAccessoryColor("ACRtArm", Param1, (ColorType)Param2);
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetRightBracerColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        if (Param2 > 3 || Param2 < 0) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            return ItemColors.GetAccessoryColor("ACRtBracer", Param1, (ColorType)Param2);
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetRightElbowColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        if (Param2 > 3 || Param2 < 0) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            return ItemColors.GetAccessoryColor("ACRtAnkle", Param1, (ColorType)Param2);
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetRightFootColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        if (Param2 > 3 || Param2 < 0) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            return ItemColors.GetAccessoryColor("ACRtFoot", Param1, (ColorType)Param2);
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetRightHipColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        if (Param2 > 3 || Param2 < 0) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            return ItemColors.GetAccessoryColor("ACRtHip", Param1, (ColorType)Param2);
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetRightKneeColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        if (Param2 > 3 || Param2 < 0) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            return ItemColors.GetAccessoryColor("ACRtKnee", Param1, (ColorType)Param2);
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetRightLegColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        if (Param2 > 3 || Param2 < 0) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            return ItemColors.GetAccessoryColor("ACRtLeg", Param1, (ColorType)Param2);
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetRightShinColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        if (Param2 > 3 || Param2 < 0) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            return ItemColors.GetAccessoryColor("ACRtShin", Param1, (ColorType)Param2);
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetRightShoulderColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        if (Param2 > 3 || Param2 < 0) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            return ItemColors.GetAccessoryColor("ACRtShoulder", Param1, (ColorType)Param2);
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetFrontHipColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        if (Param2 > 3 || Param2 < 0) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            return ItemColors.GetAccessoryColor("ACFtHip", Param1, (ColorType)Param2);
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetBackHipColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        if (Param2 > 3 || Param2 < 0) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            return ItemColors.GetAccessoryColor("ACBkHip", Param1, (ColorType)Param2);
                        }
                        else
                        {
                            return -1;
                        }
                    }
                #endregion
                #region Get Visual-Type-Driven Colors
                case ItemCommand.GetArmorColor:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            return ItemColors.GetArmorColor(Param1, (ColorType)Param2);
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetBeltColor:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            return ItemColors.GetArmorPieceColor("Belt", Param1, (ColorType)Param2);
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetBootsColor:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            return ItemColors.GetArmorPieceColor("Boots", Param1, (ColorType)Param2);
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetCloakColor:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            return ItemColors.GetArmorPieceColor("Cloak", Param1, (ColorType)Param2);
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetGlovesColor:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            return ItemColors.GetArmorPieceColor("Gloves", Param1, (ColorType)Param2);
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.GetHelmetColor:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            return ItemColors.GetArmorPieceColor("Helm", Param1, (ColorType)Param2);
                        }
                        else
                        {
                            return -1;
                        }
                    }
                #endregion
                #region Set Accessory Models
                case ItemCommand.SetLeftAnkleModel:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try 
                            {
                                if (Param1 < 0) Param1 = ItemModels.GetPreviousModel(LeftAnkleVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtAnkle"].ValueStruct["Accessory"].ValueByte);
                                if (Param1 > 255) Param1 = ItemModels.GetNextModel(LeftAnkleVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtAnkle"].ValueStruct["Accessory"].ValueByte);
                                ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtAnkle"].ValueStruct["Accessory"].ValueByte = (byte)Param1; 
                            }
                            catch { return -1; }
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetLeftArmModel:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try 
                            {
                                if (Param1 < 0) Param1 = ItemModels.GetPreviousModel(LeftArmVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtArm"].ValueStruct["Accessory"].ValueByte);
                                if (Param1 > 255) Param1 = ItemModels.GetNextModel(LeftArmVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtArm"].ValueStruct["Accessory"].ValueByte);
                                ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtArm"].ValueStruct["Accessory"].ValueByte = (byte)Param1; 
                            }
                            catch { return -1; }
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetLeftBracerModel:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try 
                            {
                                if (Param1 < 0) Param1 = ItemModels.GetPreviousModel(LeftBracerVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtBracer"].ValueStruct["Accessory"].ValueByte);
                                if (Param1 > 255) Param1 = ItemModels.GetNextModel(LeftBracerVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtBracer"].ValueStruct["Accessory"].ValueByte);
                                ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtBracer"].ValueStruct["Accessory"].ValueByte = (byte)Param1; 
                            }
                            catch { return -1; }
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetLeftElbowModel:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try 
                            {
                                if (Param1 < 0) Param1 = ItemModels.GetPreviousModel(LeftElbowVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtElbow"].ValueStruct["Accessory"].ValueByte);
                                if (Param1 > 255) Param1 = ItemModels.GetNextModel(LeftElbowVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtElbow"].ValueStruct["Accessory"].ValueByte);
                                ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtElbow"].ValueStruct["Accessory"].ValueByte = (byte)Param1; 
                            }
                            catch { return -1; }
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetLeftFootModel:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try 
                            {
                                if (Param1 < 0) Param1 = ItemModels.GetPreviousModel(LeftFootVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtFoot"].ValueStruct["Accessory"].ValueByte);
                                if (Param1 > 255) Param1 = ItemModels.GetNextModel(LeftFootVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtFoot"].ValueStruct["Accessory"].ValueByte);
                                ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtFoot"].ValueStruct["Accessory"].ValueByte = (byte)Param1; 
                            }
                            catch { return -1; }
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetLeftHipModel:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try 
                            {
                                if (Param1 < 0) Param1 = ItemModels.GetPreviousModel(LeftHipVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtHip"].ValueStruct["Accessory"].ValueByte);
                                if (Param1 > 255) Param1 = ItemModels.GetNextModel(LeftHipVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtHip"].ValueStruct["Accessory"].ValueByte);
                                ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtHip"].ValueStruct["Accessory"].ValueByte = (byte)Param1; 
                            }
                            catch { return -1; }
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetLeftKneeModel:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try 
                            {
                                if (Param1 < 0) Param1 = ItemModels.GetPreviousModel(LeftKneeVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtKnee"].ValueStruct["Accessory"].ValueByte);
                                if (Param1 > 255) Param1 = ItemModels.GetNextModel(LeftKneeVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtKnee"].ValueStruct["Accessory"].ValueByte);
                                ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtKnee"].ValueStruct["Accessory"].ValueByte = (byte)Param1; 
                            }
                            catch { return -1; }
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetLeftLegModel:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try 
                            {
                                if (Param1 < 0) Param1 = ItemModels.GetPreviousModel(LeftLegVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtLeg"].ValueStruct["Accessory"].ValueByte);
                                if (Param1 > 255) Param1 = ItemModels.GetNextModel(LeftLegVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtLeg"].ValueStruct["Accessory"].ValueByte);
                                ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtLeg"].ValueStruct["Accessory"].ValueByte = (byte)Param1; 
                            }
                            catch { return -1; }
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetLeftShinModel:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try 
                            {
                                if (Param1 < 0) Param1 = ItemModels.GetPreviousModel(LeftShinVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtShin"].ValueStruct["Accessory"].ValueByte);
                                if (Param1 > 255) Param1 = ItemModels.GetNextModel(LeftShinVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtShin"].ValueStruct["Accessory"].ValueByte);
                                ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtShin"].ValueStruct["Accessory"].ValueByte = (byte)Param1; 
                            }
                            catch { return -1; }
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetLeftShoulderModel:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try 
                            {
                                if (Param1 < 0) Param1 = ItemModels.GetPreviousModel(LeftShoulderVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtShoulder"].ValueStruct["Accessory"].ValueByte);
                                if (Param1 > 255) Param1 = ItemModels.GetNextModel(LeftShoulderVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtShoulder"].ValueStruct["Accessory"].ValueByte);
                                ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtShoulder"].ValueStruct["Accessory"].ValueByte = (byte)Param1; 
                            }
                            catch { return -1; }
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetRightAnkleModel:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try 
                            {
                                if (Param1 < 0) Param1 = ItemModels.GetPreviousModel(RightAnkleVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtAnkle"].ValueStruct["Accessory"].ValueByte);
                                if (Param1 > 255) Param1 = ItemModels.GetNextModel(RightAnkleVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtAnkle"].ValueStruct["Accessory"].ValueByte);
                                ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtAnkle"].ValueStruct["Accessory"].ValueByte = (byte)Param1; 
                            }
                            catch { return -1; }
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetRightArmModel:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try 
                            {
                                if (Param1 < 0) Param1 = ItemModels.GetPreviousModel(RightArmVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtArm"].ValueStruct["Accessory"].ValueByte);
                                if (Param1 > 255) Param1 = ItemModels.GetNextModel(RightArmVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtArm"].ValueStruct["Accessory"].ValueByte);
                                ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtArm"].ValueStruct["Accessory"].ValueByte = (byte)Param1; 
                            }
                            catch { return -1; }
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetRightBracerModel:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try 
                            {
                                if (Param1 < 0) Param1 = ItemModels.GetPreviousModel(RightBracerVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtBracer"].ValueStruct["Accessory"].ValueByte);
                                if (Param1 > 255) Param1 = ItemModels.GetNextModel(RightBracerVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtBracer"].ValueStruct["Accessory"].ValueByte);
                                ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtBracer"].ValueStruct["Accessory"].ValueByte = (byte)Param1; 
                            }
                            catch { return -1; }
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetRightElbowModel:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try 
                            {
                                if (Param1 < 0) Param1 = ItemModels.GetPreviousModel(RightElbowVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtElbow"].ValueStruct["Accessory"].ValueByte);
                                if (Param1 > 255) Param1 = ItemModels.GetNextModel(RightElbowVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtElbow"].ValueStruct["Accessory"].ValueByte);
                                ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtElbow"].ValueStruct["Accessory"].ValueByte = (byte)Param1; 
                            }
                            catch { return -1; }
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetRightFootModel:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try 
                            {
                                if (Param1 < 0) Param1 = ItemModels.GetPreviousModel(RightFootVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtFoot"].ValueStruct["Accessory"].ValueByte);
                                if (Param1 > 255) Param1 = ItemModels.GetNextModel(RightFootVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtFoot"].ValueStruct["Accessory"].ValueByte);
                                ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtFoot"].ValueStruct["Accessory"].ValueByte = (byte)Param1; 
                            }
                            catch { return -1; }
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetRightHipModel:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try 
                            {
                                if (Param1 < 0) Param1 = ItemModels.GetPreviousModel(RightHipVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtHip"].ValueStruct["Accessory"].ValueByte);
                                if (Param1 > 255) Param1 = ItemModels.GetNextModel(RightHipVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtHip"].ValueStruct["Accessory"].ValueByte);
                                ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtHip"].ValueStruct["Accessory"].ValueByte = (byte)Param1; 
                            }
                            catch { return -1; }
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetRightKneeModel:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try 
                            {
                                if (Param1 < 0) Param1 = ItemModels.GetPreviousModel(RightKneeVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtKnee"].ValueStruct["Accessory"].ValueByte);
                                if (Param1 > 255) Param1 = ItemModels.GetNextModel(RightKneeVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtKnee"].ValueStruct["Accessory"].ValueByte);
                                ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtKnee"].ValueStruct["Accessory"].ValueByte = (byte)Param1; 
                            }
                            catch { return -1; }
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetRightLegModel:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try 
                            {
                                if (Param1 < 0) Param1 = ItemModels.GetPreviousModel(RightLegVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtLeg"].ValueStruct["Accessory"].ValueByte);
                                if (Param1 > 255) Param1 = ItemModels.GetNextModel(RightLegVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtLeg"].ValueStruct["Accessory"].ValueByte);
                                ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtLeg"].ValueStruct["Accessory"].ValueByte = (byte)Param1; 
                            }
                            catch { return -1; }
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetRightShinModel:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try 
                            {
                                if (Param1 < 0) Param1 = ItemModels.GetPreviousModel(RightShinVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtShin"].ValueStruct["Accessory"].ValueByte);
                                if (Param1 > 255) Param1 = ItemModels.GetNextModel(RightShinVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtShin"].ValueStruct["Accessory"].ValueByte);
                                ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtShin"].ValueStruct["Accessory"].ValueByte = (byte)Param1; 
                            }
                            catch { return -1; }
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetRightShoulderModel:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try 
                            {
                                if (Param1 < 0) Param1 = ItemModels.GetPreviousModel(RightShoulderVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtShoulder"].ValueStruct["Accessory"].ValueByte);
                                if (Param1 > 255) Param1 = ItemModels.GetNextModel(RightShoulderVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtShoulder"].ValueStruct["Accessory"].ValueByte);
                                ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtShoulder"].ValueStruct["Accessory"].ValueByte = (byte)Param1; 
                            }
                            catch { return -1; }
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetFrontHipModel:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try 
                            {
                                if (Param1 < 0) Param1 = ItemModels.GetPreviousModel(FrontHipVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACFtHip"].ValueStruct["Accessory"].ValueByte);
                                if (Param1 > 255) Param1 = ItemModels.GetNextModel(FrontHipVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACFtHip"].ValueStruct["Accessory"].ValueByte);
                                ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACFtHip"].ValueStruct["Accessory"].ValueByte = (byte)Param1; 
                            }
                            catch { return -1; }
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetBackHipModel:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try 
                            {
                                if (Param1 < 0) Param1 = ItemModels.GetPreviousModel(BackHipVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACBkHip"].ValueStruct["Accessory"].ValueByte);
                                if (Param1 > 255) Param1 = ItemModels.GetNextModel(BackHipVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACBkHip"].ValueStruct["Accessory"].ValueByte);
                                ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACBkHip"].ValueStruct["Accessory"].ValueByte = (byte)Param1; 
                            }
                            catch { return -1; }
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                #endregion
                #region Set Visual-Type-Driven Models
                case ItemCommand.SetArmorVariation:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try
                            {
                                if (Param1 < 0) Param1 = ItemModels.GetPreviousModel(ArmorVariations[ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ArmorVisualType"].ValueByte], ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Variation"].ValueByte);
                                if (Param1 > 255) Param1 = ItemModels.GetNextModel(ArmorVariations[ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ArmorVisualType"].ValueByte], ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Variation"].ValueByte);
                                ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Variation"].ValueByte = (byte)Param1;
                            }
                            catch { return -1; }
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetArmorVisualType:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try
                            {
                                if (Param1 < 0) Param1 = ItemModels.GetPreviousKey(ArmorVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ArmorVisualType"].ValueByte);
                                if (Param1 > 255) Param1 = ItemModels.GetNextKey(ArmorVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ArmorVisualType"].ValueByte);
                                ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ArmorVisualType"].ValueByte = (byte)Param1;
                            }
                            catch { return -1; }
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetBeltVariation:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try
                            {
                                if (Param1 == -2)
                                {
                                    GFFField toRemove = null;
                                    foreach(GFFField field in ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct.Fields.Values)
                                    {
                                        if(field.StringLabel == "Belt")
                                        {
                                            toRemove = field;
                                        }
                                    }
                                    if(toRemove != null) ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct.Fields.Remove(toRemove);
                                    break;
                                }
                                if (Param1 > -2 && !ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct.Contains("Belt"))
                                {
                                    ItemModels.AddArmorPiece(ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName], "Belt", BeltVariations);
                                }
                                if (Param1 < 0) Param1 = ItemModels.GetPreviousModel(BeltVariations[ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Belt"].ValueStruct["ArmorVisualType"].ValueByte], ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Belt"].ValueStruct["Variation"].ValueByte);
                                if (Param1 > 255) Param1 = ItemModels.GetNextModel(BeltVariations[ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Belt"].ValueStruct["ArmorVisualType"].ValueByte], ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Belt"].ValueStruct["Variation"].ValueByte);
                                ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Belt"].ValueStruct["Variation"].ValueByte = (byte)Param1;
                            }
                            catch { return -1; }
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetBeltVisualType:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try
                            {
                                if (Param1 == -2)
                                {
                                    GFFField toRemove = null;
                                    foreach (GFFField field in ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct.Fields.Values)
                                    {
                                        if (field.StringLabel == "Belt")
                                        {
                                            toRemove = field;
                                        }
                                    }
                                    if (toRemove != null) ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct.Fields.Remove(toRemove);
                                    break;
                                }
                                if (Param1 > -2 && !ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct.Contains("Belt"))
                                {
                                    ItemModels.AddArmorPiece(ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName], "Belt", BeltVariations);
                                }
                                if (Param1 < 0) Param1 = ItemModels.GetNextKey(BeltVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Belt"].ValueStruct["ArmorVisualType"].ValueByte);
                                if (Param1 > 255) Param1 = ItemModels.GetPreviousKey(BeltVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Belt"].ValueStruct["ArmorVisualType"].ValueByte);
                                ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Belt"].ValueStruct["ArmorVisualType"].ValueByte = (byte)Param1;
                            }
                            catch { return -1; }
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetBootsVariation:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try
                            {
                                if (Param1 == -2)
                                {
                                    GFFField toRemove = null;
                                    foreach (GFFField field in ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct.Fields.Values)
                                    {
                                        if (field.StringLabel == "Boots")
                                        {
                                            toRemove = field;
                                        }
                                    }
                                    if (toRemove != null) ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct.Fields.Remove(toRemove);
                                    break;
                                }
                                if (Param1 > -2 && !ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct.Contains("Boots"))
                                {
                                    ItemModels.AddArmorPiece(ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName], "Boots", BootVariations);
                                }
                                if (Param1 < 0) Param1 = ItemModels.GetPreviousModel(BootVariations[ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Boots"].ValueStruct["ArmorVisualType"].ValueByte], ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Boots"].ValueStruct["Variation"].ValueByte);
                                if (Param1 > 255) Param1 = ItemModels.GetNextModel(BootVariations[ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Boots"].ValueStruct["ArmorVisualType"].ValueByte], ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Boots"].ValueStruct["Variation"].ValueByte);
                                ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Boots"].ValueStruct["Variation"].ValueByte = (byte)Param1;
                            }
                            catch { return -1; }
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetBootsVisualType:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try
                            {
                                if (Param1 == -2)
                                {
                                    GFFField toRemove = null;
                                    foreach (GFFField field in ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct.Fields.Values)
                                    {
                                        if (field.StringLabel == "Boots")
                                        {
                                            toRemove = field;
                                        }
                                    }
                                    if (toRemove != null) ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct.Fields.Remove(toRemove);
                                    break;
                                }
                                if (Param1 > -2 && !ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct.Contains("Boots"))
                                {
                                    ItemModels.AddArmorPiece(ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName], "Boots", BootVariations);
                                }
                                if (Param1 < 0) Param1 = ItemModels.GetNextKey(BootVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Boots"].ValueStruct["ArmorVisualType"].ValueByte);
                                if (Param1 > 255) Param1 = ItemModels.GetPreviousKey(BootVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Boots"].ValueStruct["ArmorVisualType"].ValueByte);
                                ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Boots"].ValueStruct["ArmorVisualType"].ValueByte = (byte)Param1;
                            }
                            catch { return -1; }
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetCloakVariation:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try
                            {
                                if (Param1 == -2)
                                {
                                    GFFField toRemove = null;
                                    foreach (GFFField field in ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct.Fields.Values)
                                    {
                                        if (field.StringLabel == "Cloak")
                                        {
                                            toRemove = field;
                                        }
                                    }
                                    if (toRemove != null) ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct.Fields.Remove(toRemove);
                                    break;
                                }
                                if (Param1 > -2 && !ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct.Contains("Cloak"))
                                {
                                    ItemModels.AddArmorPiece(ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName], "Cloak", CloakVariations);
                                }
                                if (Param1 < 0) Param1 = ItemModels.GetPreviousModel(CloakVariations[ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Cloak"].ValueStruct["ArmorVisualType"].ValueByte], ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Cloak"].ValueStruct["Variation"].ValueByte);
                                if (Param1 > 255) Param1 = ItemModels.GetNextModel(CloakVariations[ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Cloak"].ValueStruct["ArmorVisualType"].ValueByte], ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Cloak"].ValueStruct["Variation"].ValueByte);
                                ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Cloak"].ValueStruct["Variation"].ValueByte = (byte)Param1;
                            }
                            catch { return -1; }
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetCloakVisualType:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try
                            {
                                if (Param1 == -2)
                                {
                                    GFFField toRemove = null;
                                    foreach (GFFField field in ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct.Fields.Values)
                                    {
                                        if (field.StringLabel == "Cloak")
                                        {
                                            toRemove = field;
                                        }
                                    }
                                    if (toRemove != null) ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct.Fields.Remove(toRemove);
                                    break;
                                }
                                if (Param1 > -2 && !ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct.Contains("Cloak"))
                                {
                                    ItemModels.AddArmorPiece(ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName], "Cloak", CloakVariations);
                                }
                                if (Param1 < 0) Param1 = ItemModels.GetNextKey(CloakVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Cloak"].ValueStruct["ArmorVisualType"].ValueByte);
                                if (Param1 > 255) Param1 = ItemModels.GetPreviousKey(CloakVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Cloak"].ValueStruct["ArmorVisualType"].ValueByte);
                                ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Cloak"].ValueStruct["ArmorVisualType"].ValueByte = (byte)Param1;
                            }
                            catch { return -1; }
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetGlovesVariation:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try
                            {
                                if (Param1 == -2)
                                {
                                    GFFField toRemove = null;
                                    foreach (GFFField field in ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct.Fields.Values)
                                    {
                                        if (field.StringLabel == "Gloves")
                                        {
                                            toRemove = field;
                                        }
                                    }
                                    if (toRemove != null) ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct.Fields.Remove(toRemove);
                                    break;
                                }
                                if (Param1 > -2 && !ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct.Contains("Gloves"))
                                {
                                    ItemModels.AddArmorPiece(ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName], "Gloves", GloveVariations);
                                }
                                if (Param1 < 0) Param1 = ItemModels.GetPreviousModel(GloveVariations[ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Gloves"].ValueStruct["ArmorVisualType"].ValueByte], ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Gloves"].ValueStruct["Variation"].ValueByte);
                                if (Param1 > 255) Param1 = ItemModels.GetNextModel(GloveVariations[ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Gloves"].ValueStruct["ArmorVisualType"].ValueByte], ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Gloves"].ValueStruct["Variation"].ValueByte);
                                ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Gloves"].ValueStruct["Variation"].ValueByte = (byte)Param1;
                            }
                            catch { return -1; }
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetGlovesVisualType:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try
                            {
                                if (Param1 == -2)
                                {
                                    GFFField toRemove = null;
                                    foreach (GFFField field in ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct.Fields.Values)
                                    {
                                        if (field.StringLabel == "Gloves")
                                        {
                                            toRemove = field;
                                        }
                                    }
                                    if (toRemove != null) ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct.Fields.Remove(toRemove);
                                    break;
                                }
                                if (Param1 > -2 && !ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct.Contains("Gloves"))
                                {
                                    ItemModels.AddArmorPiece(ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName], "Gloves", GloveVariations);
                                }
                                if (Param1 < 0) Param1 = ItemModels.GetNextKey(GloveVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Gloves"].ValueStruct["ArmorVisualType"].ValueByte);
                                if (Param1 > 255) Param1 = ItemModels.GetPreviousKey(GloveVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Gloves"].ValueStruct["ArmorVisualType"].ValueByte);
                                ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Gloves"].ValueStruct["ArmorVisualType"].ValueByte = (byte)Param1;
                            }
                            catch { return -1; }
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetHelmetVariation:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try
                            {
                                if (Param1 == -2)
                                {
                                    GFFField toRemove = null;
                                    foreach (GFFField field in ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct.Fields.Values)
                                    {
                                        if (field.StringLabel == "Helm")
                                        {
                                            toRemove = field;
                                        }
                                    }
                                    if (toRemove != null) ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct.Fields.Remove(toRemove);
                                    break;
                                }
                                if (Param1 > -2 && !ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct.Contains("Helm"))
                                {
                                    ItemModels.AddArmorPiece(ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName], "Helm", HelmetVariations);
                                }
                                if (Param1 < 0) Param1 = ItemModels.GetPreviousModel(HelmetVariations[ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Helm"].ValueStruct["ArmorVisualType"].ValueByte], ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Helm"].ValueStruct["Variation"].ValueByte);
                                if (Param1 > 255) Param1 = ItemModels.GetNextModel(HelmetVariations[ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Helm"].ValueStruct["ArmorVisualType"].ValueByte], ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Helm"].ValueStruct["Variation"].ValueByte);
                                ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Helm"].ValueStruct["Variation"].ValueByte = (byte)Param1;
                            }
                            catch { return -1; }
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetHelmetVisualType:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try
                            {
                                if (Param1 == -2)
                                {
                                    GFFField toRemove = null;
                                    foreach (GFFField field in ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct.Fields.Values)
                                    {
                                        if (field.StringLabel == "Helm")
                                        {
                                            toRemove = field;
                                        }
                                    }
                                    if (toRemove != null) ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct.Fields.Remove(toRemove);
                                    break;
                                }
                                if (Param1 > -2 && !ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct.Contains("Helm"))
                                {
                                    ItemModels.AddArmorPiece(ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName], "Helm", HelmetVariations);
                                }
                                if (Param1 < 0) Param1 = ItemModels.GetNextKey(HelmetVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Helm"].ValueStruct["ArmorVisualType"].ValueByte);
                                if (Param1 > 255) Param1 = ItemModels.GetPreviousKey(HelmetVariations, ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Helm"].ValueStruct["ArmorVisualType"].ValueByte);
                                ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["Helm"].ValueStruct["ArmorVisualType"].ValueByte = (byte)Param1;
                            }
                            catch { return -1; }
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                #endregion
                #region Set Accessory Colors
                case ItemCommand.SetLeftAnkleColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            ItemColors.SetAccessoryColor("ACLtAnkle", Param1, Param2);
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetLeftArmColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            ItemColors.SetAccessoryColor("ACLtArm", Param1, Param2);
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetLeftBracerColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            ItemColors.SetAccessoryColor("ACLtBracer", Param1, Param2);
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetLeftElbowColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            ItemColors.SetAccessoryColor("ACLtElbow", Param1, Param2);
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetLeftFootColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            ItemColors.SetAccessoryColor("ACLtFoot", Param1, Param2);
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetLeftHipColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            ItemColors.SetAccessoryColor("ACLtHip", Param1, Param2);
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetLeftKneeColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            ItemColors.SetAccessoryColor("ACLtKnee", Param1, Param2);
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetLeftLegColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            ItemColors.SetAccessoryColor("ACLtLeg", Param1, Param2);
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetLeftShinColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            ItemColors.SetAccessoryColor("ACLtShin", Param1, Param2);
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetLeftShoulderColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            ItemColors.SetAccessoryColor("ACLtShoulder", Param1, Param2);
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetRightAnkleColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            ItemColors.SetAccessoryColor("ACRtAnkle", Param1, Param2);
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetRightArmColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            ItemColors.SetAccessoryColor("ACRtArm", Param1, Param2);
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetRightBracerColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            ItemColors.SetAccessoryColor("ACRtBracer", Param1, Param2);
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetRightElbowColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            ItemColors.SetAccessoryColor("ACRtAnkle", Param1, Param2);
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetRightFootColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            ItemColors.SetAccessoryColor("ACRtFoot", Param1, Param2);
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetRightHipColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            ItemColors.SetAccessoryColor("ACRtHip", Param1, Param2);
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetRightKneeColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            ItemColors.SetAccessoryColor("ACRtKnee", Param1, Param2);
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetRightLegColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            ItemColors.SetAccessoryColor("ACRtLeg", Param1, Param2);
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetRightShinColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            ItemColors.SetAccessoryColor("ACRtShin", Param1, Param2);
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetRightShoulderColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            ItemColors.SetAccessoryColor("ACRtShoulder", Param1, Param2);
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetFrontHipColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            ItemColors.SetAccessoryColor("ACFtHip", Param1, Param2);
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetBackHipColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            ItemColors.SetAccessoryColor("ACBkHip", Param1, Param2);
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                #endregion
                #region Set Visual-Type-Driven Colors
                case ItemCommand.SetArmorColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            ItemColors.SetArmorColor(Param1, Param2);
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetBeltColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            ItemColors.SetArmorPieceColor("Belt", Param1, Param2);
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetBootsColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            ItemColors.SetArmorPieceColor("Boots", Param1, Param2);
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetCloakColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            ItemColors.SetArmorPieceColor("Cloak", Param1, Param2);
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetGlovesColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            ItemColors.SetArmorPieceColor("Gloves", Param1, Param2);
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                case ItemCommand.SetHelmetColor:
                    {
                        if (Param1 > 3 || Param1 < 1) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            ItemColors.SetArmorPieceColor("Helm", Param1, Param2);
                            break;
                        }
                        else
                        {
                            return -1;
                        }
                    }
                #endregion
                #region Whole Armor Set Changes
                case ItemCommand.SetArmorSetModels:
                    {
                        List<ArmorSet> aSet = null;
                        try
                        {
                            aSet = ArmorSetLibrary[(ArmorSetTypes)Param1];
                        }
                        catch
                        {
                            SendMessageToAllDMs("ArmorSetLibrary doesn't contain key "+Param1.ToString());
                        }
                        ArmorSet cSet = null;
                        try
                        {
                            cSet = aSet[Param2];
                        }
                        catch
                        {
                            SendMessageToAllDMs("Armor Set list doesn't contain key " + Param2.ToString());
                        }
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        ItemModels.TakeArmorStyle(ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName], cSet);
                        break;
                    }
                case ItemCommand.SetAllArmorColors:
                    {
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        ItemColors.SetColorThemes(ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName], Param1, Param2);
                        break;
                    }
                #endregion
                #region Providing Information to NWScript
                case ItemCommand.GetSpellCastPropertyCasterLevel:
                    {
                        if (ALFA.Shared.Modules.InfoStore.IPCastSpells.Count > Param1 &&
                            ALFA.Shared.Modules.InfoStore.IPCastSpells[Param1] != null)
                            return ALFA.Shared.Modules.InfoStore.IPCastSpells[Param1].CasterLevel;
                        else return -1;
                    }
                case ItemCommand.GetSpellCastPropertySpellLevel:
                    {
                        if (ALFA.Shared.Modules.InfoStore.IPCastSpells.Count > Param1 &&
                            ALFA.Shared.Modules.InfoStore.IPCastSpells[Param1] != null)
                            return ALFA.Shared.Modules.InfoStore.IPCastSpells[Param1].InnateLevel;
                        else return -1;
                    }
                case ItemCommand.GetSpellLevel:
                    {
                        if (ALFA.Shared.Modules.InfoStore.CoreSpells.Count > Param1 &&
                            ALFA.Shared.Modules.InfoStore.CoreSpells[Param1] != null)
                            return ALFA.Shared.Modules.InfoStore.CoreSpells[Param1].InnateLevel;
                        else return -1;
                    }
                #endregion
            }
            if (Command >= 200)
            {
                DestroyObject(Target, 0.0f, FALSE);

                uint newObj = RetrieveCampaignObject(ItemChangeDBName, ModelChangeVarName, GetLocation(OBJECT_SELF), OBJECT_SELF, OBJECT_SELF);
                ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName] = null;
                if (GetObjectType(Target) != OBJECT_TYPE_PLACEABLE)
                {
                    int item = ObjectToInt(CopyItem(newObj, OBJECT_SELF, TRUE));
                    DestroyObject(newObj, 0.0f, FALSE);
                    return item;
                }
            }
            return 0;
        }

        public enum ItemCommand
        {
            AdjustPrice = 0,
            CalculatePrice = 1,
            GenerateLoot = 2,
            GenerateAmuletFirst = 3,
            GenerateArmorFirst = 4,
            GenerateBeltFirst = 5,
            GenerateBootsFirst = 6,
            GenerateCloakFirst = 7,
            GenerateGlovesFirst = 8,
            GenerateHelmetFirst = 9,
            GenerateRingFirst = 10,
            GenerateRodFirst = 11,
            GenerateStaffFirst = 12,
            GenerateWandFirst = 13,
            GenerateScrolls = 14,
            GeneratePotions = 15,
            GenerateWeaponFirst = 16,

            GetLeftAnkleModel = 101,
            GetLeftArmModel = 102,
            GetLeftBracerModel = 103,
            GetLeftElbowModel = 104,
            GetLeftFootModel = 105,
            GetLeftHipModel = 106,
            GetLeftKneeModel = 107,
            GetLeftLegModel = 108,
            GetLeftShinModel = 109,
            GetLeftShoulderModel = 110,
            GetRightAnkleModel = 111,
            GetRightArmModel = 112,
            GetRightBracerModel = 113,
            GetRightElbowModel = 114,
            GetRightFootModel = 115,
            GetRightHipModel = 116,
            GetRightKneeModel = 117,
            GetRightLegModel = 118,
            GetRightShinModel = 119,
            GetRightShoulderModel = 120,
            GetFrontHipModel = 121,
            GetBackHipModel = 122,
            GetArmorVisualType = 123,
            GetArmorVariation = 124,
            GetBeltVisualType = 125,
            GetBeltVariation = 126,
            GetBootsVisualType = 127,
            GetBootsVariation = 128,
            GetCloakVisualType = 129,
            GetCloakVariation = 130,
            GetGlovesVisualType = 131,
            GetGlovesVariation = 132,
            GetHelmetVisualType = 133,
            GetHelmetVariation = 134,

            GetLeftAnkleColor = 141,
            GetLeftArmColor = 142,
            GetLeftBracerColor = 143,
            GetLeftElbowColor = 144,
            GetLeftFootColor = 145,
            GetLeftHipColor = 146,
            GetLeftKneeColor = 147,
            GetLeftLegColor = 148,
            GetLeftShinColor = 149,
            GetLeftShoulderColor = 150,
            GetRightAnkleColor = 151,
            GetRightArmColor = 152,
            GetRightBracerColor = 153,
            GetRightElbowColor = 154,
            GetRightFootColor = 155,
            GetRightHipColor = 156,
            GetRightKneeColor = 157,
            GetRightLegColor = 158,
            GetRightShinColor = 159,
            GetRightShoulderColor = 160,
            GetFrontHipColor = 161,
            GetBackHipColor = 162,
            GetArmorColor = 163,
            GetBeltColor = 164,
            GetBootsColor = 165,
            GetCloakColor = 166,
            GetGlovesColor = 167,
            GetHelmetColor = 168,

            SetLeftAnkleModel = 201,
            SetLeftArmModel = 202,
            SetLeftBracerModel = 203,
            SetLeftElbowModel = 204,
            SetLeftFootModel = 205,
            SetLeftHipModel = 206,
            SetLeftKneeModel = 207,
            SetLeftLegModel = 208,
            SetLeftShinModel = 209,
            SetLeftShoulderModel = 210,
            SetRightAnkleModel = 211,
            SetRightArmModel = 212,
            SetRightBracerModel = 213,
            SetRightElbowModel = 214,
            SetRightFootModel = 215,
            SetRightHipModel = 216,
            SetRightKneeModel = 217,
            SetRightLegModel = 218,
            SetRightShinModel = 219,
            SetRightShoulderModel = 220,
            SetFrontHipModel = 221,
            SetBackHipModel = 222,
            SetArmorVisualType = 223,
            SetArmorVariation = 224,
            SetBeltVisualType = 225,
            SetBeltVariation = 226,
            SetBootsVisualType = 227,
            SetBootsVariation = 228,
            SetCloakVisualType = 229,
            SetCloakVariation = 230,
            SetGlovesVisualType = 231,
            SetGlovesVariation = 232,
            SetHelmetVisualType = 233,
            SetHelmetVariation = 234,

            SetLeftAnkleColor = 241,
            SetLeftArmColor = 242,
            SetLeftBracerColor = 243,
            SetLeftElbowColor = 244,
            SetLeftFootColor = 245,
            SetLeftHipColor = 246,
            SetLeftKneeColor = 247,
            SetLeftLegColor = 248,
            SetLeftShinColor = 249,
            SetLeftShoulderColor = 250,
            SetRightAnkleColor = 251,
            SetRightArmColor = 252,
            SetRightBracerColor = 253,
            SetRightElbowColor = 254,
            SetRightFootColor = 255,
            SetRightHipColor = 256,
            SetRightKneeColor = 257,
            SetRightLegColor = 258,
            SetRightShinColor = 259,
            SetRightShoulderColor = 260,
            SetFrontHipColor = 261,
            SetBackHipColor = 262,
            SetArmorColor = 263,
            SetBeltColor = 264,
            SetBootsColor = 265,
            SetCloakColor = 266,
            SetGlovesColor = 267,
            SetHelmetColor = 268,

            SetArmorSetModels = 290,
            SetAllArmorColors = 291,


            GetSpellLevel = 400,
            GetSpellCastPropertySpellLevel = 401,
            GetSpellCastPropertyCasterLevel = 402,
        }

        public enum ColorType
        {
            All = 0,
            Red = 1,
            Green = 2,
            Blue = 3,
        }

        #region Available Models
        public static Dictionary<int, List<int>> ArmorVariations = new Dictionary<int, List<int>>
        {
            {0, new List<int> { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 84, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 110, 111, 112, 113, 114, 115, 118, 120, 121, 123, 124, 125, 126, 128, 129, 130, 132, 133, 134, 136, 135, 136, 137, 138, 139, 140, 141, 142, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 158, 184, 185, 199, 209, 210, 222, 223, 224, 226, 230, 231, 232, 233, 234, 249, } },
            {1, new List<int> { 0, 1, 9, 11, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 46, 57, 68, 75, 78, 85, 86, 87, 88, 90, 93, 94, 95, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 229,} },
            {2, new List<int> { 0, 1, 2, 4, 5, 6, 9, 10, 19, 20, 25, 26, 27, 28, 29, 30, 31, 32, 35, 47, 59, 100, 101, 102, 103, 104, 105, 106, 107, 120, 219, 220, } },
            {3, new List<int> { 48, 56, 64, 77,	} },
            {4, new List<int> { 0, 1, 2, 3, 4, 5, 10, 18, 23, 25, 26, 30, 31, 32, 33, 41, 50, 60, 61, 63, 65, 66, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 100, 101, 102, 103, 104, 105, 106, 107, 180, 181, 219,  } },
            {5, new List<int> { 0, 1, 2, 3, 10, 11, 12, 15, 16, 22, 24, 45, 64, 76, 82,  } },
            {6, new List<int> { 23, 24, 28, } },
            {7, new List<int> { 1, 2, 3, 4, 5, 6, 7, 10, 13, 16, 17, 18, 23, 25, 27, 28, 33, 36, 46, 49, 52, 53, 56, 58, 74, 81, 82, 84, } },
            {8, new List<int> { 0, 1, 2, 9, 10, 11, 12, 13, 14, 15, 20, 24, 25, 26, 27, 28, 29, 30, 32, 33, 46, 49, 50, 52, 53, 54, 55, 56, 60, 72, 73, 80, 81, 82, 84, 86, 88, 89, 93, 94, 95, 96, 97, 98, 99, 150, 162, 165, 170, 180, 181, 200, } },
            {9, new List<int> { 0, 1, 2, 3, 9, 11, 13, 15, 17, 18, 21, 34, 35, 70, 73, 74, 87, 100, } },
            {10, new List<int> { 0, 19, 99, 100, 101, 102, 103, 104, 105, } },
            {19, new List<int> { 0, 1, 2, 3, 4, } },
        };

        public static Dictionary<int, List<int>> HelmetVariations = new Dictionary<int, List<int>>
        {
            {0, new List<int> { 0, 1, 2, 3, 4, 5, 6, 7, 8, 10, 12, 13, 14, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 31, 32, 33, 34, 35, 38, 39, 50, 51, 52, 53, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 79, 83, 97, 98, 99, 100, 101, 102, 103, 105, 127, 132, 184, } },
            {1, new List<int> { 29, 59, 69, } },
            {2, new List<int> { 0, 1, 2, 3, 4, 5, 6, 7, 9, 10, 12, 35, 49, 81, } },
            {4, new List<int> { 0, 1, 3, 30, 37, 39, 40, 41, 43, } },
            {5, new List<int> { 0, 1, 45, 46, 47, 56, 57, 58, } },
            {6, new List<int> { 0, 1, 2, 3, 4, 5, 9, } },
            {7, new List<int> { 0, 1, 2, 4, 5, 6, 7, 8, 9, 10, 29, 50, 51, 52, 53, 57, 58, 200, } },
            {8, new List<int> { 0, 1, 2, 3, 4, 5, 6, 7, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 29, 35, 36, 42, 46, 47, 50, 51, 52, 59, } },
            {9, new List<int> { 0, 1, 2, 3, 4, 6, 9, 15, 17, 22, 23, 24, 25, 26, 27, 28, 29, 34, 35, 44, 45, } },
            {10, new List<int> { 0, 1, 2, 5, 11, 12, 13, 15, 16, 23, 29, 31, 32, 36, 37, 39, 40, 42, 48, 249, 250, } },
            {17, new List<int> { 46, 47, 48, 49, 50, 51, 52, 53, 54, 90, 91, 92, 94, 95, 114, 115, 116, 117, 121, 123, 124, 125, 126, }},
            {24, new List<int> { 99, 100, 101, 102, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 123, 124, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 141, 142, 143, 144, 145, 146, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 166, 167, 168, 169, 170, 171, 174, 175, 176, 177, 178, 179, 180, 184, 187, 189, 194, 195, 196, 197, 198, 199, 200, 201, 203, }},
            {25, new List<int> { 4, 5, 6, 10, } },
        };    

        public static Dictionary<int, List<int>> BootVariations = new Dictionary<int, List<int>>
        {
            {0, new List<int> { 0, 1, 2, 3, 4, 15, 16, 23, 33, 49, 50, 69, 91, 92, 98, 100, 102, 200, 224, } },
            {1, new List<int> { 11, 23, 46, } },
            {2, new List<int> { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 16, 18, 19, 22, 27, 35, 39, 44, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 99, 150, 156, 229, } },
            {3, new List<int> { 0, } },
            {4, new List<int> { 0, 1, 2, 18, 24, 33, } },
            {5, new List<int> { 0, 1, } },
            {6, new List<int> { 0, } },
            {7, new List<int> { 0, 27, 28, } },
            {8, new List<int> { 0, 1, 5, 7, 32, 33, 40, 49, 162, 165, 167, } },
            {9, new List<int> { 1, 24, 34, 35, } },
            {10, new List<int> {18, 49, 99, } },
        };

        public static Dictionary<int, List<int>> GloveVariations = new Dictionary<int, List<int>>
        {
            {0, new List<int> { 0, 1, 49, 50, 51, 52, 78, 98, 100, 120, } },
            {1, new List<int> { 11, }},
            {2, new List<int> { 0, 1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 30, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 60, 61, 62, 63, } },
            {3, new List<int> { 0, 1, } },
            {4, new List<int> { 0, 1, 24, } },
            {5, new List<int> { 0, 1, 22, } },
            {7, new List<int> { 0, 1, 27, 35, } },
            {8, new List<int> { 0, 1, 2, 3, 9, 32, 48, } },
            {9, new List<int> { 0, 1, 2, 3,  } },
            {10, new List<int> { 0, 1, 2, 3, 8, 43, 81, 99, } },
        };

        public static Dictionary<int, List<int>> BeltVariations = new Dictionary<int, List<int>>
        {
            {0, new List<int> { 1, 2, 3, 16, 18, 30, 31, 33, 36, 50, 51, 52, 53, 54, 55, 56, 57, 58, 180, 181, 184, 185, } },
            {1, new List<int> { 0, 1, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 19, 20, 21, 22, 23, 24, 26, 27, 28, 29, 30, 31, 79, 85, 87, 88, 91, 92, 93, 94, 95, } },
            {2, new List<int> { 0, 1, 2, 3, 17, 18, 19, 50, 51, 52, 53, 54, 55, 56, 67, 68, 222, } },
            {5, new List<int> { 0, 1, 2, 3, } },
            {8, new List<int> { 0, 1, 2, 3, 180, } },
            {9, new List<int> { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 20,  } },
            {10, new List<int> { 99, } },
        };

        public static Dictionary<int, List<int>> CloakVariations = new Dictionary<int, List<int>>
        {
            {0, new List<int> { 0, 1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 13, 14, 15, 16, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 102, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, } },
            {9, new List<int> { 0, 1, 3, 4, 5, 6, 12, 13, 14, 15, 16, 17, 18, 19, }},
            {25, new List<int> { 1, 3, 4, 5, 13, 14, } },
        };

        public static List<int> LeftShoulderVariations = new List<int>
        {
            0, 1, 2, 3, 4, 5, 6, 7, 9, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 166, 201, 210, 254, 255, 
        };

        public static List<int> RightShoulderVariations = new List<int>
        {
            0, 1, 2, 3, 4, 5, 6, 7, 9, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 166, 201, 210, 254, 255, 
        };

        public static List<int> LeftBracerVariations = new List<int>
        {
            0, 1, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 99,
        };

        public static List<int> RightBracerVariations = new List<int>
        {
            0, 1, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35,
        };

        public static List<int> LeftElbowVariations = new List<int>
        {
            0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 210, 254, 255, 
        };

        public static List<int> RightElbowVariations = new List<int>
        {
            0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 210, 254, 255, 
        };

        public static List<int> LeftArmVariations = new List<int>
        {
            0, 1, 2, 4, 5, 8, 10, 12, 14, 16, 18, 21, 22, 23, 24, 25, 27, 28, 29, 30, 31, 99, 210,
        };

        public static List<int> RightArmVariations = new List<int>
        {
            0, 1, 2, 4, 5, 8, 10, 12, 14, 16, 18, 21, 22, 23, 24, 25, 27, 28, 29, 30, 31, 210,
        };

        public static List<int> LeftHipVariations = new List<int>
        {
            0, 1, 2, 3, 13, 14, 43, 44, 45, 150, 151, 210, 254, 255,
        };

        public static List<int> RightHipVariations = new List<int>
        {
            0, 1, 2, 3, 13, 14, 43, 44, 45, 99, 150, 151, 210, 255,  
        };

        public static List<int> FrontHipVariations = new List<int>
        {
            0, 43, 
        };

        public static List<int> BackHipVariations = new List<int>
        {
            0,
        };

        public static List<int> LeftLegVariations = new List<int>
        {
            0, 1, 2, 4, 6, 7, 9, 10, 12, 13, 14, 17, 22, 23, 24, 26, 27, 28, 29, 98, 210,
        };

        public static List<int> RightLegVariations = new List<int>
        {
            0, 1, 2, 4, 6, 7, 9, 10, 12, 13, 14, 17, 22, 23, 24, 26, 27, 28, 29, 97, 98, 99, 210,
        };

        public static List<int> LeftShinVariations = new List<int>
        {
            0, 1, 3, 4, 5, 6, 9, 11, 14, 15, 17, 19, 20, 21, 22, 23, 24, 25,
        };

        public static List<int> RightShinVariations = new List<int>
        {
            0, 1, 3, 4, 5, 6, 9, 11, 14, 15, 17, 19, 20, 21, 22, 23, 24, 25,
        };

        public static List<int> LeftKneeVariations = new List<int>
        {
            0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 210,
        };

        public static List<int> RightKneeVariations = new List<int>
        {
            0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 210,
        };

        public static List<int> LeftFootVariations = new List<int>
        {
            0,
        };

        public static List<int> RightFootVariations = new List<int>
        {
            0,
        };

        public static List<int> LeftAnkleVariations = new List<int>
        {
            0,
        };

        public static List<int> RightAnkleVariations = new List<int>
        {
            0,
        };
        #endregion

        #region Outfits
        public static List<ArmorSet> ClothArmorAppearances = new List<ArmorSet>
        {
            new ArmorSet() { ArmorVariation = 1, ArmorVisualType = 0, BackHip = 0, BeltVariation = -1, BeltVisualType = -1, BootsVariation = 0, BootsVisualType = 4, CloakVariation = -1, CloakVisualType = -1, FrontHip = 0, GlovesVariation = -1, GlovesVisualType = -1, HelmetVariation = -1, HelmetVisualType = -1, LeftAnkle = 0, LeftArm = 0, LeftBracer = 0, LeftElbow = 0, LeftFoot = 0, LeftHip = 0, LeftKnee = 0, LeftLeg = 0, LeftShin = 0, LeftShoulder = 0, RightAnkle = 0, RightArm = 0, RightBracer = 0, RightElbow = 0, RightFoot = 0, RightHip = 0, RightKnee = 0, RightLeg = 0, RightShin = 0, RightShoulder = 0 },
        };

        public static List<ArmorSet> PaddedArmorAppearance = new List<ArmorSet>
        {
            new ArmorSet() { ArmorVariation = 0, ArmorVisualType = 1, BackHip = 0, BeltVariation = -1, BeltVisualType = -1, BootsVariation = 3, BootsVisualType = 2, CloakVariation = -1, CloakVisualType = -1, FrontHip = 0, GlovesVariation = 6, GlovesVisualType = 2, HelmetVariation = -1, HelmetVisualType = -1, LeftAnkle = 0, LeftArm = 0, LeftBracer = 0, LeftElbow = 0, LeftFoot = 0, LeftHip = 0, LeftKnee = 0, LeftLeg = 0, LeftShin = 0, LeftShoulder = 0, RightAnkle = 0, RightArm = 0, RightBracer = 0, RightElbow = 0, RightFoot = 0, RightHip = 0, RightKnee = 0, RightLeg = 0, RightShin = 0, RightShoulder = 0 },
        };

        public static List<ArmorSet> LeatherArmorAppearance = new List<ArmorSet>
        {
            new ArmorSet() { ArmorVariation = 9, ArmorVisualType = 2, BackHip = 0, BeltVariation = -1, BeltVisualType = -1, BootsVariation = 50, BootsVisualType = 0, CloakVariation = -1, CloakVisualType = -1, FrontHip = 0, GlovesVariation = 50, GlovesVisualType = 0, HelmetVariation = -1, HelmetVisualType = -1, LeftAnkle = 0, LeftArm = 0, LeftBracer = 0, LeftElbow = 0, LeftFoot = 0, LeftHip = 0, LeftKnee = 7, LeftLeg = 0, LeftShin = 0, LeftShoulder = 4, RightAnkle = 0, RightArm = 0, RightBracer = 0, RightElbow = 0, RightFoot = 0, RightHip = 0, RightKnee = 7, RightLeg = 0, RightShin = 0, RightShoulder = 4 },
        };

        public static List<ArmorSet> StuddedLeatherAppearance = new List<ArmorSet>
        {
            new ArmorSet() { ArmorVariation = 1, ArmorVisualType = 2, BackHip = 0, BeltVariation = -1, BeltVisualType = -1, BootsVariation = 0, BootsVisualType = 3, CloakVariation = -1, CloakVisualType = -1, FrontHip = 0, GlovesVariation = 1, GlovesVisualType = 3, HelmetVariation = -1, HelmetVisualType = -1, LeftAnkle = 0, LeftArm = 0, LeftBracer = 5, LeftElbow = 3, LeftFoot = 0, LeftHip = 0, LeftKnee = 0, LeftLeg = 0, LeftShin = 0, LeftShoulder = 3, RightAnkle = 0, RightArm = 0, RightBracer = 5, RightElbow = 3, RightFoot = 0, RightHip = 0, RightKnee = 0, RightLeg = 0, RightShin = 0, RightShoulder = 3 },
        };

        public static List<ArmorSet> ChainShirtAppearance = new List<ArmorSet>
        {
            new ArmorSet() { ArmorVariation = 30, ArmorVisualType = 4, BackHip = 0, BeltVariation = -1, BeltVisualType = -1, BootsVariation = 50, BootsVisualType = 0, CloakVariation = -1, CloakVisualType = -1, FrontHip = 0, GlovesVariation = 50, GlovesVisualType = 0, HelmetVariation = 2, HelmetVisualType = 2, LeftAnkle = 0, LeftArm = 0, LeftBracer = 0, LeftElbow = 0, LeftFoot = 0, LeftHip = 0, LeftKnee = 0, LeftLeg = 0, LeftShin = 0, LeftShoulder = 0, RightAnkle = 0, RightArm = 0, RightBracer = 0, RightElbow = 0, RightFoot = 0, RightHip = 0, RightKnee = 0, RightLeg = 0, RightShin = 0, RightShoulder = 0},
        };

        public static List<ArmorSet> BreastplateAppearance = new List<ArmorSet>
        {
            new ArmorSet() { ArmorVariation = 11, ArmorVisualType = 8, BackHip = 0, BeltVariation = -1, BeltVisualType = -1, BootsVariation = 162, BootsVisualType = 8, CloakVariation = -1, CloakVisualType = -1, FrontHip = 0, GlovesVariation = 6, GlovesVisualType = 2, HelmetVariation = 50, HelmetVisualType = 7, LeftAnkle = 0, LeftArm = 0, LeftBracer = 0, LeftElbow = 0, LeftFoot = 0, LeftHip = 0, LeftKnee = 0, LeftLeg = 0, LeftShin = 0, LeftShoulder = 0, RightAnkle = 0, RightArm = 0, RightBracer = 0, RightElbow = 0, RightFoot = 0, RightHip = 0, RightKnee = 0, RightLeg = 0, RightShin = 0, RightShoulder = 0},
        };

        public static List<ArmorSet> BandedArmorAppearance = new List<ArmorSet>
        {
            new ArmorSet() { ArmorVariation = 1, ArmorVisualType = 8, BackHip = 0, BeltVariation = -1, BeltVisualType = -1, BootsVariation = 0, BootsVisualType = 6, CloakVariation = -1, CloakVisualType = -1, FrontHip = 0, GlovesVariation = 0, GlovesVisualType = 4, HelmetVariation = 52, HelmetVisualType = 7, LeftAnkle = 0, LeftArm = 0, LeftBracer = 0, LeftElbow = 0, LeftFoot = 0, LeftHip = 0, LeftKnee = 0, LeftLeg = 0, LeftShin = 0, LeftShoulder = 0, RightAnkle = 0, RightArm = 0, RightBracer = 0, RightElbow = 0, RightFoot = 0, RightHip = 0, RightKnee = 0, RightLeg = 0, RightShin = 0, RightShoulder = 0},
        };

        public static List<ArmorSet> HalfPlateAppearance = new List<ArmorSet>
        {
            new ArmorSet() { ArmorVariation = 9, ArmorVisualType = 8, BackHip = 0, BeltVariation = -1, BeltVisualType = -1, BootsVariation = 0, BootsVisualType = 6, CloakVariation = -1, CloakVisualType = -1, FrontHip = 0, GlovesVariation = 0, GlovesVisualType = 4, HelmetVariation = 52, HelmetVisualType = 7, LeftAnkle = 0, LeftArm = 0, LeftBracer = 0, LeftElbow = 0, LeftFoot = 0, LeftHip = 0, LeftKnee = 210, LeftLeg = 0, LeftShin = 0, LeftShoulder = 210, RightAnkle = 0, RightArm = 0, RightBracer = 0, RightElbow = 0, RightFoot = 0, RightHip = 0, RightKnee = 210, RightLeg = 0, RightShin = 0, RightShoulder = 210},
        };

        public static List<ArmorSet> FullPlateAppearance = new List<ArmorSet>
        {
            new ArmorSet() { ArmorVariation = 10, ArmorVisualType = 8, BackHip = 0, BeltVariation = -1, BeltVisualType = -1, BootsVariation = 49, BootsVisualType = 8, CloakVariation = -1, CloakVisualType = -1, FrontHip = 0, GlovesVariation = 9, GlovesVisualType = 8, HelmetVariation = 11, HelmetVisualType = 8, LeftAnkle = 0, LeftArm = 210, LeftBracer = 0, LeftElbow = 210, LeftFoot = 0, LeftHip = 210, LeftKnee = 210, LeftLeg = 210, LeftShin = 0, LeftShoulder = 210, RightAnkle = 0, RightArm = 210, RightBracer = 0, RightElbow = 210, RightFoot = 0, RightHip = 210, RightKnee = 210, RightLeg = 210, RightShin = 0, RightShoulder = 210},
        };

        public static List<ArmorSet> HideArmorAppearance = new List<ArmorSet>
        {
            new ArmorSet() { ArmorVariation = 1, ArmorVisualType = 9, BackHip = 0, BeltVariation = 3, BeltVisualType = 2, BootsVariation = 1, BootsVisualType = 9, CloakVariation = -1, CloakVisualType = -1, FrontHip = 0, GlovesVariation = 0, GlovesVisualType = 2, HelmetVariation = -1, HelmetVisualType = -1, LeftAnkle = 0, LeftArm = 0, LeftBracer = 0, LeftElbow = 0, LeftFoot = 0, LeftHip = 0, LeftKnee = 0, LeftLeg = 0, LeftShin = 0, LeftShoulder = 0, RightAnkle = 0, RightArm = 0, RightBracer = 0, RightElbow = 0, RightFoot = 0, RightHip = 0, RightKnee = 0, RightLeg = 0, RightShin = 0, RightShoulder = 0},
        };

        public static List<ArmorSet> ScaleArmorAppearance = new List<ArmorSet>
        {
            new ArmorSet() { ArmorVariation = 0, ArmorVisualType = 5, BackHip = 0, BeltVariation = -1, BeltVisualType = -1, BootsVariation = 0, BootsVisualType = 5, CloakVariation = -1, CloakVisualType = -1, FrontHip = 0, GlovesVariation = 0, GlovesVisualType = 5, HelmetVariation = 0, HelmetVisualType = 5, LeftAnkle = 0, LeftArm = 2, LeftBracer = 3, LeftElbow = 0, LeftFoot = 0, LeftHip = 0, LeftKnee = 0, LeftLeg = 0, LeftShin = 0, LeftShoulder = 2, RightAnkle = 0, RightArm = 2, RightBracer = 3, RightElbow = 0, RightFoot = 0, RightHip = 0, RightKnee = 0, RightLeg = 0, RightShin = 0, RightShoulder = 2},
        };

        public static List<ArmorSet> ChainmailAppearance = new List<ArmorSet>
        {
            new ArmorSet() { ArmorVariation = 1, ArmorVisualType = 4, BackHip = 0, BeltVariation = -1, BeltVisualType = -1, BootsVariation = 2, BootsVisualType = 4, CloakVariation = -1, CloakVisualType = -1, FrontHip = 0, GlovesVariation = 0, GlovesVisualType = 4, HelmetVariation = 0, HelmetVisualType = 4, LeftAnkle = 0, LeftArm = 0, LeftBracer = 0, LeftElbow = 0, LeftFoot = 0, LeftHip = 0, LeftKnee = 15, LeftLeg = 0, LeftShin = 0, LeftShoulder = 0, RightAnkle = 0, RightArm = 0, RightBracer = 0, RightElbow = 0, RightFoot = 0, RightHip = 0, RightKnee = 15, RightLeg = 0, RightShin = 0, RightShoulder = 0},
        };

        public static List<ArmorSet> SplintArmorAppearance = new List<ArmorSet>
        {
            new ArmorSet() { ArmorVariation = 1, ArmorVisualType = 8, BackHip = 0, BeltVariation = -1, BeltVisualType = -1, BootsVariation = 0, BootsVisualType = 6, CloakVariation = -1, CloakVisualType = -1, FrontHip = 0, GlovesVariation = 0, GlovesVisualType = 4, HelmetVariation = 52, HelmetVisualType = 7, LeftAnkle = 0, LeftArm = 0, LeftBracer = 0, LeftElbow = 0, LeftFoot = 0, LeftHip = 0, LeftKnee = 0, LeftLeg = 0, LeftShin = 0, LeftShoulder = 0, RightAnkle = 0, RightArm = 0, RightBracer = 0, RightElbow = 0, RightFoot = 0, RightHip = 0, RightKnee = 0, RightLeg = 0, RightShin = 0, RightShoulder = 0},
        };
        #endregion

        public enum ArmorSetTypes
        {
            Cloth = 0,
            Padded = 1,
            Leather = 2,
            StuddedLeather = 3,
            ChainShirt = 4,
            Breastplate = 5,
            Banded = 6,
            HalfPlate = 7,
            FullPlate = 8,
            Hide = 9,
            Scale = 10,
            Chainmail = 11,
            Splint = 12,
        }

        public static Dictionary<ArmorSetTypes, List<ArmorSet>> ArmorSetLibrary = new Dictionary<ArmorSetTypes, List<ArmorSet>>
        {
            { ArmorSetTypes.Banded, BandedArmorAppearance },
            { ArmorSetTypes.Breastplate, BreastplateAppearance },
            { ArmorSetTypes.Chainmail, ChainmailAppearance },
            { ArmorSetTypes.ChainShirt, ChainShirtAppearance },
            { ArmorSetTypes.Cloth, ClothArmorAppearances },
            { ArmorSetTypes.FullPlate, FullPlateAppearance },
            { ArmorSetTypes.HalfPlate, HalfPlateAppearance },
            { ArmorSetTypes.Hide, HideArmorAppearance },
            { ArmorSetTypes.Leather, LeatherArmorAppearance },
            { ArmorSetTypes.Padded, PaddedArmorAppearance },
            { ArmorSetTypes.Scale, ScaleArmorAppearance },
            { ArmorSetTypes.Splint, SplintArmorAppearance },
            { ArmorSetTypes.StuddedLeather, StuddedLeatherAppearance },
        };

        public const string ItemChangeDBName = "VDB_ItMod";
        public const string ModelChangeVarName = "ModelChange";
    }
}
