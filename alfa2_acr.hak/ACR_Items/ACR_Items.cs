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
                #region Set Accessory Models
                case ItemCommand.SetLeftAnkleModel:
                    {
                        if (Param1 < 0 || Param1 > 255) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtAnkle"].ValueStruct["Accessory"].ValueByte = (byte)Param1; }
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
                        if (Param1 < 0 || Param1 > 255) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtArm"].ValueStruct["Accessory"].ValueByte = (byte)Param1; }
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
                        if (Param1 < 0 || Param1 > 255) return -1; 
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtBracer"].ValueStruct["Accessory"].ValueByte = (byte)Param1; }
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
                        if (Param1 < 0 || Param1 > 255) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtElbow"].ValueStruct["Accessory"].ValueByte = (byte)Param1; }
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
                        if (Param1 < 0 || Param1 > 255) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtFoot"].ValueStruct["Accessory"].ValueByte = (byte)Param1; }
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
                        if (Param1 < 0 || Param1 > 255) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtHip"].ValueStruct["Accessory"].ValueByte = (byte)Param1; }
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
                        if (Param1 < 0 || Param1 > 255) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtKnee"].ValueStruct["Accessory"].ValueByte = (byte)Param1; }
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
                        if (Param1 < 0 || Param1 > 255) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtLeg"].ValueStruct["Accessory"].ValueByte = (byte)Param1; }
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
                        if (Param1 < 0 || Param1 > 255) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtShin"].ValueStruct["Accessory"].ValueByte = (byte)Param1; }
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
                        if (Param1 < 0 || Param1 > 255) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACLtShoulder"].ValueStruct["Accessory"].ValueByte = (byte)Param1; }
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
                        if (Param1 < 0 || Param1 > 255) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtAnkle"].ValueStruct["Accessory"].ValueByte = (byte)Param1; }
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
                        if (Param1 < 0 || Param1 > 255) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtArm"].ValueStruct["Accessory"].ValueByte = (byte)Param1; }
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
                        if (Param1 < 0 || Param1 > 255) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtBracer"].ValueStruct["Accessory"].ValueByte = (byte)Param1; }
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
                        if (Param1 < 0 || Param1 > 255) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtElbow"].ValueStruct["Accessory"].ValueByte = (byte)Param1; }
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
                        if (Param1 < 0 || Param1 > 255) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtFoot"].ValueStruct["Accessory"].ValueByte = (byte)Param1; }
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
                        if (Param1 < 0 || Param1 > 255) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtHip"].ValueStruct["Accessory"].ValueByte = (byte)Param1; }
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
                        if (Param1 < 0 || Param1 > 255) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtKnee"].ValueStruct["Accessory"].ValueByte = (byte)Param1; }
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
                        if (Param1 < 0 || Param1 > 255) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtLeg"].ValueStruct["Accessory"].ValueByte = (byte)Param1; }
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
                        if (Param1 < 0 || Param1 > 255) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtShin"].ValueStruct["Accessory"].ValueByte = (byte)Param1; }
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
                        if (Param1 < 0 || Param1 > 255) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACRtShoulder"].ValueStruct["Accessory"].ValueByte = (byte)Param1; }
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
                        if (Param1 < 0 || Param1 > 255) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACFtHip"].ValueStruct["Accessory"].ValueByte = (byte)Param1; }
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
                        if (Param1 < 0 || Param1 > 255) return -1;
                        StoreCampaignObject(ItemChangeDBName, ModelChangeVarName, Target, OBJECT_SELF);
                        if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(ModelChangeVarName))
                        {
                            try { ALFA.Shared.Modules.InfoStore.ModifiedGff[ModelChangeVarName].TopLevelStruct["ACBkHip"].ValueStruct["Accessory"].ValueByte = (byte)Param1; }
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
            }
            if (Command >= 200)
            {
                DestroyObject(Target, 0.0f, FALSE);
                uint newObj = RetrieveCampaignObject(ItemChangeDBName, ModelChangeVarName, GetLocation(OBJECT_SELF), OBJECT_SELF, OBJECT_SELF);
                if (GetObjectType(Target) != OBJECT_TYPE_PLACEABLE)
                {
                    CopyItem(newObj, OBJECT_SELF, TRUE);
                    DestroyObject(newObj, 0.0f, FALSE);
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
        }

        public enum ColorType
        {
            All = 0,
            Red = 1,
            Green = 2,
            Blue = 3,
        }

        public const string ItemChangeDBName = "VDB_ItMod";
        public const string ModelChangeVarName = "ModelChange";
    }
}
