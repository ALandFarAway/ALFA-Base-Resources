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
    public class ItemColors
    {
        public static int GetAccessoryColor(string partName, int colorNumber, ACR_Items.ColorType color)
        {
            try
            {
                GFFStruct colorStruct = ALFA.Shared.Modules.InfoStore.ModifiedGff[ACR_Items.ModelChangeVarName].TopLevelStruct[partName].ValueStruct["Tintable"].ValueStruct["Tint"].ValueStruct;
                return GetColorFromTintStruct(colorStruct, colorNumber, color);
            }
            catch { }
            return -1;
        }

        public static int GetArmorColor(int colorNumber, ACR_Items.ColorType color)
        {
            try
            {
                GFFStruct colorStruct = ALFA.Shared.Modules.InfoStore.ModifiedGff[ACR_Items.ModelChangeVarName].TopLevelStruct["Tintable"].ValueStruct["Tint"].ValueStruct;
                return GetColorFromTintStruct(colorStruct, colorNumber, color);
            }
            catch { }
            return -1;
        }

        public static int GetArmorPieceColor(string partName, int colorNumber, ACR_Items.ColorType color)
        {
            try
            {
                GFFStruct colorStruct = ALFA.Shared.Modules.InfoStore.ModifiedGff[ACR_Items.ModelChangeVarName].TopLevelStruct[partName].ValueStruct["ArmorTint"].ValueStruct;
                return GetColorFromTintStruct(colorStruct, colorNumber, color);
            }
            catch { }
            return -1;
        }

        public static int SetAccessoryColor(string partName, int colorNumber, int color)
        {
            try
            {
                GFFStruct colorStruct = ALFA.Shared.Modules.InfoStore.ModifiedGff[ACR_Items.ModelChangeVarName].TopLevelStruct[partName].ValueStruct["Tintable"].ValueStruct["Tint"].ValueStruct;
                return SetColorInTintStruct(colorStruct, colorNumber, color);
            }
            catch { }
            return -1;
        }

        public static int SetArmorColor(int colorNumber, int color)
        {
            try
            {
                GFFStruct colorStruct = ALFA.Shared.Modules.InfoStore.ModifiedGff[ACR_Items.ModelChangeVarName].TopLevelStruct["Tintable"].ValueStruct["Tint"].ValueStruct;
                return SetColorInTintStruct(colorStruct, colorNumber, color);
            }
            catch { }
            return -1;
        }

        public static int SetArmorPieceColor(string partName, int colorNumber, int color)
        {
            try
            {
                GFFStruct colorStruct = ALFA.Shared.Modules.InfoStore.ModifiedGff[ACR_Items.ModelChangeVarName].TopLevelStruct[partName].ValueStruct["ArmorTint"].ValueStruct;
                return SetColorInTintStruct(colorStruct, colorNumber, color);
            }
            catch { }
            return -1;
        }

        public static void SetColorThemes(GFFFile armor, int primaryColor, int secondaryColor)
        {
            try 
            {
                ModelColors colors = GetModelColor(LeftAnkleVariationColors, 0, ALFA.Shared.Modules.InfoStore.ModifiedGff[ACR_Items.ModelChangeVarName].TopLevelStruct["ACLtAnkle"].ValueStruct["Accessory"].ValueByte);
                ItemColors.SetAccessoryColor("ACLtAnkle", 1, colors.OneIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetAccessoryColor("ACLtAnkle", 2, colors.TwoIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetAccessoryColor("ACLtAnkle", 3, colors.ThreeIsAccent ? secondaryColor : primaryColor);
            }
            catch { }
            try 
            {
                ModelColors colors = GetModelColor(LeftArmVariationColors, 0, ALFA.Shared.Modules.InfoStore.ModifiedGff[ACR_Items.ModelChangeVarName].TopLevelStruct["ACLtArm"].ValueStruct["Accessory"].ValueByte);
                ItemColors.SetAccessoryColor("ACLtArm", 1, colors.OneIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetAccessoryColor("ACLtArm", 2, colors.TwoIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetAccessoryColor("ACLtArm", 3, colors.ThreeIsAccent ? secondaryColor : primaryColor);
            }
            catch { }
            try 
            { 
                ModelColors colors = GetModelColor(LeftBracerVariationColors, 0, ALFA.Shared.Modules.InfoStore.ModifiedGff[ACR_Items.ModelChangeVarName].TopLevelStruct["ACLtBracer"].ValueStruct["Accessory"].ValueByte);
                ItemColors.SetAccessoryColor("ACLtBracer", 1, colors.OneIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetAccessoryColor("ACLtBracer", 2, colors.TwoIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetAccessoryColor("ACLtBracer", 3, colors.ThreeIsAccent ? secondaryColor : primaryColor);
            }
            catch { }
            try 
            { 
                ModelColors colors = GetModelColor(LeftElbowVariationColors, 0, ALFA.Shared.Modules.InfoStore.ModifiedGff[ACR_Items.ModelChangeVarName].TopLevelStruct["ACLtElbow"].ValueStruct["Accessory"].ValueByte);
                ItemColors.SetAccessoryColor("ACLtElbow", 1, colors.OneIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetAccessoryColor("ACLtElbow", 2, colors.TwoIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetAccessoryColor("ACLtElbow", 3, colors.ThreeIsAccent ? secondaryColor : primaryColor);
            }
            catch { }
            try 
            { 
                ModelColors colors = GetModelColor(LeftFootVariationColors, 0, ALFA.Shared.Modules.InfoStore.ModifiedGff[ACR_Items.ModelChangeVarName].TopLevelStruct["ACLtFoot"].ValueStruct["Accessory"].ValueByte);
                ItemColors.SetAccessoryColor("ACLtFoot", 1, colors.OneIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetAccessoryColor("ACLtFoot", 2, colors.TwoIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetAccessoryColor("ACLtFoot", 3, colors.ThreeIsAccent ? secondaryColor : primaryColor);
            }
            catch { }
            try 
            { 
                ModelColors colors = GetModelColor(LeftHipVariationColors, 0, ALFA.Shared.Modules.InfoStore.ModifiedGff[ACR_Items.ModelChangeVarName].TopLevelStruct["ACLtHip"].ValueStruct["Accessory"].ValueByte);
                ItemColors.SetAccessoryColor("ACLtHip", 1, colors.OneIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetAccessoryColor("ACLtHip", 2, colors.TwoIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetAccessoryColor("ACLtHip", 3, colors.ThreeIsAccent ? secondaryColor : primaryColor);
            }
            catch { }
            try 
            { 
                ModelColors colors = GetModelColor(LeftKneeVariationColors, 0, ALFA.Shared.Modules.InfoStore.ModifiedGff[ACR_Items.ModelChangeVarName].TopLevelStruct["ACLtKnee"].ValueStruct["Accessory"].ValueByte);
                ItemColors.SetAccessoryColor("ACLtKnee", 1, colors.OneIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetAccessoryColor("ACLtKnee", 2, colors.TwoIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetAccessoryColor("ACLtKnee", 3, colors.ThreeIsAccent ? secondaryColor : primaryColor);
            }
            catch { }
            try 
            { 
                ModelColors colors = GetModelColor(LeftLegVariationColors, 0, ALFA.Shared.Modules.InfoStore.ModifiedGff[ACR_Items.ModelChangeVarName].TopLevelStruct["ACLtLeg"].ValueStruct["Accessory"].ValueByte);
                ItemColors.SetAccessoryColor("ACLtLeg", 1, colors.OneIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetAccessoryColor("ACLtLeg", 2, colors.TwoIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetAccessoryColor("ACLtLeg", 3, colors.ThreeIsAccent ? secondaryColor : primaryColor);
            }
            catch { }
            try 
            { 
                ModelColors colors = GetModelColor(LeftShinVariationColors, 0, ALFA.Shared.Modules.InfoStore.ModifiedGff[ACR_Items.ModelChangeVarName].TopLevelStruct["ACLtShin"].ValueStruct["Accessory"].ValueByte);
                ItemColors.SetAccessoryColor("ACLtShin", 1, colors.OneIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetAccessoryColor("ACLtShin", 2, colors.TwoIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetAccessoryColor("ACLtShin", 3, colors.ThreeIsAccent ? secondaryColor : primaryColor);
            }
            catch { }
            try 
            { 
                ModelColors colors = GetModelColor(LeftShoulderVariationColors, 0, ALFA.Shared.Modules.InfoStore.ModifiedGff[ACR_Items.ModelChangeVarName].TopLevelStruct["ACLtShoulder"].ValueStruct["Accessory"].ValueByte);
                ItemColors.SetAccessoryColor("ACLtShoulder", 1, colors.OneIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetAccessoryColor("ACLtShoulder", 2, colors.TwoIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetAccessoryColor("ACLtShoulder", 3, colors.ThreeIsAccent ? secondaryColor : primaryColor);
            }
            catch { }
            try 
            { 
                ModelColors colors = GetModelColor(RightAnkleVariationColors, 0, ALFA.Shared.Modules.InfoStore.ModifiedGff[ACR_Items.ModelChangeVarName].TopLevelStruct["ACRtAnkle"].ValueStruct["Accessory"].ValueByte);
                ItemColors.SetAccessoryColor("ACRtAnkle", 1, colors.OneIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetAccessoryColor("ACRtAnkle", 2, colors.TwoIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetAccessoryColor("ACRtAnkle", 3, colors.ThreeIsAccent ? secondaryColor : primaryColor);
            }
            catch { }
            try 
            { 
                ModelColors colors = GetModelColor(RightArmVariationColors, 0, ALFA.Shared.Modules.InfoStore.ModifiedGff[ACR_Items.ModelChangeVarName].TopLevelStruct["ACRtArm"].ValueStruct["Accessory"].ValueByte);
                ItemColors.SetAccessoryColor("ACRtArm", 1, colors.OneIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetAccessoryColor("ACRtArm", 2, colors.TwoIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetAccessoryColor("ACRtArm", 3, colors.ThreeIsAccent ? secondaryColor : primaryColor);
            }
            catch { }
            try 
            { 
                ModelColors colors = GetModelColor(RightBracerVariationColors, 0, ALFA.Shared.Modules.InfoStore.ModifiedGff[ACR_Items.ModelChangeVarName].TopLevelStruct["ACRtBracer"].ValueStruct["Accessory"].ValueByte);
                ItemColors.SetAccessoryColor("ACRtBracer", 1, colors.OneIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetAccessoryColor("ACRtBracer", 2, colors.TwoIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetAccessoryColor("ACRtBracer", 3, colors.ThreeIsAccent ? secondaryColor : primaryColor);
            }
            catch { }
            try 
            { 
                ModelColors colors = GetModelColor(RightElbowVariationColors, 0, ALFA.Shared.Modules.InfoStore.ModifiedGff[ACR_Items.ModelChangeVarName].TopLevelStruct["ACRtElbow"].ValueStruct["Accessory"].ValueByte);
                ItemColors.SetAccessoryColor("ACRtElbow", 1, colors.OneIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetAccessoryColor("ACRtElbow", 2, colors.TwoIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetAccessoryColor("ACRtElbow", 3, colors.ThreeIsAccent ? secondaryColor : primaryColor);
            }
            catch { }
            try 
            { 
                ModelColors colors = GetModelColor(RightFootVariationColors, 0, ALFA.Shared.Modules.InfoStore.ModifiedGff[ACR_Items.ModelChangeVarName].TopLevelStruct["ACRtFoot"].ValueStruct["Accessory"].ValueByte);
                ItemColors.SetAccessoryColor("ACRtFoot", 1, colors.OneIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetAccessoryColor("ACRtFoot", 2, colors.TwoIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetAccessoryColor("ACRtFoot", 3, colors.ThreeIsAccent ? secondaryColor : primaryColor);
            }
            catch { }
            try
            {
                ModelColors colors = GetModelColor(RightHipVariationColors, 0, ALFA.Shared.Modules.InfoStore.ModifiedGff[ACR_Items.ModelChangeVarName].TopLevelStruct["ACRtHip"].ValueStruct["Accessory"].ValueByte);
                ItemColors.SetAccessoryColor("ACRtHip", 1, colors.OneIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetAccessoryColor("ACRtHip", 2, colors.TwoIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetAccessoryColor("ACRtHip", 3, colors.ThreeIsAccent ? secondaryColor : primaryColor);
            }
            catch { }
            try 
            { 
                ModelColors colors = GetModelColor(RightKneeVariationColors, 0, ALFA.Shared.Modules.InfoStore.ModifiedGff[ACR_Items.ModelChangeVarName].TopLevelStruct["ACRtKnee"].ValueStruct["Accessory"].ValueByte);
                ItemColors.SetAccessoryColor("ACRtKnee", 1, colors.OneIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetAccessoryColor("ACRtKnee", 2, colors.TwoIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetAccessoryColor("ACRtKnee", 3, colors.ThreeIsAccent ? secondaryColor : primaryColor);
            }
            catch { }
            try 
            { 
                ModelColors colors = GetModelColor(RightLegVariationColors, 0, ALFA.Shared.Modules.InfoStore.ModifiedGff[ACR_Items.ModelChangeVarName].TopLevelStruct["ACRtLeg"].ValueStruct["Accessory"].ValueByte);
                ItemColors.SetAccessoryColor("ACRtLeg", 1, colors.OneIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetAccessoryColor("ACRtLeg", 2, colors.TwoIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetAccessoryColor("ACRtLeg", 3, colors.ThreeIsAccent ? secondaryColor : primaryColor);
            }
            catch { }
            try 
            { 
                ModelColors colors = GetModelColor(RightShinVariationColors, 0, ALFA.Shared.Modules.InfoStore.ModifiedGff[ACR_Items.ModelChangeVarName].TopLevelStruct["ACRtShin"].ValueStruct["Accessory"].ValueByte);
                ItemColors.SetAccessoryColor("ACRtShin", 1, colors.OneIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetAccessoryColor("ACRtShin", 2, colors.TwoIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetAccessoryColor("ACRtShin", 3, colors.ThreeIsAccent ? secondaryColor : primaryColor);
            }
            catch { }
            try
            {
                ModelColors colors = GetModelColor(RightShoulderVariationColors, 0, ALFA.Shared.Modules.InfoStore.ModifiedGff[ACR_Items.ModelChangeVarName].TopLevelStruct["ACRtShoulder"].ValueStruct["Accessory"].ValueByte);
                ItemColors.SetAccessoryColor("ACRtShoulder", 1, colors.OneIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetAccessoryColor("ACRtShoulder", 2, colors.TwoIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetAccessoryColor("ACRtShoulder", 3, colors.ThreeIsAccent ? secondaryColor : primaryColor);
            }
            catch { }
            try 
            { 
                ModelColors colors = GetModelColor(FrontHipVariationColors, 0, ALFA.Shared.Modules.InfoStore.ModifiedGff[ACR_Items.ModelChangeVarName].TopLevelStruct["ACFtHip"].ValueStruct["Accessory"].ValueByte);
                ItemColors.SetAccessoryColor("ACFtHip", 1, colors.OneIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetAccessoryColor("ACFtHip", 2, colors.TwoIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetAccessoryColor("ACFtHip", 3, colors.ThreeIsAccent ? secondaryColor : primaryColor);
            }
            catch { }
            try 
            { 
                ModelColors colors = GetModelColor(BackHipVariationColors, 0, ALFA.Shared.Modules.InfoStore.ModifiedGff[ACR_Items.ModelChangeVarName].TopLevelStruct["ACBkHip"].ValueStruct["Accessory"].ValueByte);
                ItemColors.SetAccessoryColor("ACBkHip", 1, colors.OneIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetAccessoryColor("ACBkHip", 2, colors.TwoIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetAccessoryColor("ACBkHip", 3, colors.ThreeIsAccent ? secondaryColor : primaryColor);
            }
            catch { }
            try 
            {
                ModelColors colors = GetModelColor(ArmorVariationColors, ALFA.Shared.Modules.InfoStore.ModifiedGff[ACR_Items.ModelChangeVarName].TopLevelStruct["ArmorVisualType"].ValueByte, ALFA.Shared.Modules.InfoStore.ModifiedGff[ACR_Items.ModelChangeVarName].TopLevelStruct["Variation"].ValueByte);
                ItemColors.SetArmorColor(1, colors.OneIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetArmorColor(2, colors.TwoIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetArmorColor(3, colors.ThreeIsAccent ? secondaryColor : primaryColor);
            }
            catch { }
            try 
            { 
                ModelColors colors = GetModelColor(BeltVariationColors, ALFA.Shared.Modules.InfoStore.ModifiedGff[ACR_Items.ModelChangeVarName].TopLevelStruct["Belt"].ValueStruct["ArmorVisualType"].ValueByte, ALFA.Shared.Modules.InfoStore.ModifiedGff[ACR_Items.ModelChangeVarName].TopLevelStruct["Belt"].ValueStruct["Variation"].ValueByte);
                ItemColors.SetArmorPieceColor("Belt", 1, colors.OneIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetArmorPieceColor("Belt", 2, colors.TwoIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetArmorPieceColor("Belt", 3, colors.ThreeIsAccent ? secondaryColor : primaryColor);
            }
            catch { }
            try 
            { 
                ModelColors colors = GetModelColor(BootVariationColors, ALFA.Shared.Modules.InfoStore.ModifiedGff[ACR_Items.ModelChangeVarName].TopLevelStruct["Boots"].ValueStruct["ArmorVisualType"].ValueByte, ALFA.Shared.Modules.InfoStore.ModifiedGff[ACR_Items.ModelChangeVarName].TopLevelStruct["Boots"].ValueStruct["Variation"].ValueByte);
                ItemColors.SetArmorPieceColor("Boots", 1, colors.OneIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetArmorPieceColor("Boots", 2, colors.TwoIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetArmorPieceColor("Boots", 3, colors.ThreeIsAccent ? secondaryColor : primaryColor);
            }
            catch { }
            try 
            { 
                ModelColors colors = GetModelColor(CloakVariationColors, ALFA.Shared.Modules.InfoStore.ModifiedGff[ACR_Items.ModelChangeVarName].TopLevelStruct["Cloak"].ValueStruct["ArmorVisualType"].ValueByte, ALFA.Shared.Modules.InfoStore.ModifiedGff[ACR_Items.ModelChangeVarName].TopLevelStruct["Cloak"].ValueStruct["Variation"].ValueByte);
                ItemColors.SetArmorPieceColor("Cloak", 1, colors.OneIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetArmorPieceColor("Cloak", 2, colors.TwoIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetArmorPieceColor("Cloak", 3, colors.ThreeIsAccent ? secondaryColor : primaryColor);
            }
            catch { }
            try 
            { 
                ModelColors colors = GetModelColor(GloveVariationColors, ALFA.Shared.Modules.InfoStore.ModifiedGff[ACR_Items.ModelChangeVarName].TopLevelStruct["Gloves"].ValueStruct["ArmorVisualType"].ValueByte, ALFA.Shared.Modules.InfoStore.ModifiedGff[ACR_Items.ModelChangeVarName].TopLevelStruct["Gloves"].ValueStruct["Variation"].ValueByte); 
                ItemColors.SetArmorPieceColor("Gloves", 1, colors.OneIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetArmorPieceColor("Gloves", 2, colors.TwoIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetArmorPieceColor("Gloves", 3, colors.ThreeIsAccent ? secondaryColor : primaryColor);
            }
            catch { }
            try 
            { 
                ModelColors colors = GetModelColor(HelmetVariationColors, ALFA.Shared.Modules.InfoStore.ModifiedGff[ACR_Items.ModelChangeVarName].TopLevelStruct["Helm"].ValueStruct["Variation"].ValueByte, ALFA.Shared.Modules.InfoStore.ModifiedGff[ACR_Items.ModelChangeVarName].TopLevelStruct["Helm"].ValueStruct["Variation"].ValueByte);
                ItemColors.SetArmorPieceColor("Helm", 1, colors.OneIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetArmorPieceColor("Helm", 2, colors.TwoIsAccent ? secondaryColor : primaryColor);
                ItemColors.SetArmorPieceColor("Helm", 3, colors.ThreeIsAccent ? secondaryColor : primaryColor);
            }
            catch { }
        }

        public static ModelColors GetModelColor(List<ModelColors> fromList, int visualType, int variation)
        {
            foreach (ModelColors col in fromList)
            {
                if (col.VisualType == visualType && col.Variation == variation)
                {
                    return col;
                }
            }
            return new ModelColors() { OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false };
        }

        private static int GetColorFromTintStruct(GFFStruct colorStruct, int colorNumber, ACR_Items.ColorType color)
        {
            switch (color)
            {
                case ACR_Items.ColorType.All:
                    int retVal = colorStruct[colorNumber.ToString()].ValueStruct["r"].ValueByte * 256 * 256;
                    retVal += colorStruct[colorNumber.ToString()].ValueStruct["g"].ValueByte * 256;
                    retVal += colorStruct[colorNumber.ToString()].ValueStruct["b"].ValueByte;
                    return retVal;
                case ACR_Items.ColorType.Blue:
                    return colorStruct[colorNumber.ToString()].ValueStruct["b"].ValueByte;
                case ACR_Items.ColorType.Green:
                    return colorStruct[colorNumber.ToString()].ValueStruct["g"].ValueByte;
                case ACR_Items.ColorType.Red:
                    return colorStruct[colorNumber.ToString()].ValueStruct["r"].ValueByte;
            }
            return -1;
        }

        private static int SetColorInTintStruct(GFFStruct colorStruct, int colorNumber, int color)
        {
            colorStruct[colorNumber.ToString()].ValueStruct["r"].ValueByte = (byte)((color & (255 * 256 * 256)) / (256 * 256));
            colorStruct[colorNumber.ToString()].ValueStruct["g"].ValueByte = (byte)((color & (255 * 256)) / 256);
            colorStruct[colorNumber.ToString()].ValueStruct["b"].ValueByte = (byte)(color & 255);
            return color;
        }



        #region Model Color Sets
        public static List<ModelColors> ArmorVariationColors = new List<ModelColors>
        {
            new ModelColors { VisualType = 0, Variation = 0, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 1, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 2, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 3, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 4, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 5, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 6, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 7, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 8, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 9, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 10, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 11, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 12, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 13, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 14, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 15, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 16, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 17, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 18, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 19, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 20, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 21, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 22, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 23, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 24, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 29, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 30, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 31, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 32, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 50, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 51, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 52, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 64, OneIsAccent = true, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 65, OneIsAccent = true, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 70, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 72, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 74, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 86, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 87, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 88, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 89, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 90, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 91, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 92, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 93, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 94, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 95, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 96, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 97, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 98, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 101, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 102, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 103, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 104, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 105, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 106, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 107, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 108, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 110, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 111, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 112, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 113, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 114, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 115, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 118, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 120, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 126, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 184, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 185, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 1, Variation = 0, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 1, Variation = 90, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 1, Variation = 93, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 1, Variation = 94, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 1, Variation = 95, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 2, Variation = 0, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 2, Variation = 1, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 2, Variation = 2, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 2, Variation = 4, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 2, Variation = 5, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 2, Variation = 9, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 4, Variation = 0, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 4, Variation = 1, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 4, Variation = 2, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 4, Variation = 3, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 4, Variation = 4, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 4, Variation = 5, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 4, Variation = 30, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 4, Variation = 31, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 4, Variation = 32, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 4, Variation = 180, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 4, Variation = 181, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 5, Variation = 0, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 5, Variation = 1, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 8, Variation = 0, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 8, Variation = 1, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 8, Variation = 2, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 8, Variation = 9, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 8, Variation = 10, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 8, Variation = 11, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 8, Variation = 12, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 8, Variation = 162, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 8, Variation = 165, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 8, Variation = 170, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 9, Variation = 0, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 9, Variation = 1, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 9, Variation = 2, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 9, Variation = 3, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 9, Variation = 70, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 10, Variation = 0, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
        };

        public static List<ModelColors> HelmetVariationColors = new List<ModelColors>
        {
            new ModelColors { VisualType = 0, Variation = 0, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 1, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 2, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 3, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 4, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 5, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 6, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 7, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 8, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 10, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 12, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 13, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 14, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 16, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 17, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 18, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 19, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 20, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 21, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 22, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 23, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 24, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 25, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 26, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 27, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 28, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 39, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 50, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 51, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 52, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 53, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 59, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 60, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 61, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 62, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 63, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 64, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 65, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 67, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 68, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 69, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 70, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 97, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 98, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 102, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 127, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 184, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 2, Variation = 0, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 2, Variation = 1, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 2, Variation = 2, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 2, Variation = 3, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 2, Variation = 4, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 4, Variation = 0, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 4, Variation = 3, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 5, Variation = 0, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 5, Variation = 1, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 6, Variation = 0, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 6, Variation = 1, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 6, Variation = 2, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 6, Variation = 3, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 6, Variation = 4, OneIsAccent = true, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 6, Variation = 9, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 7, Variation = 0, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 7, Variation = 1, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 7, Variation = 2, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 7, Variation = 4, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 7, Variation = 5, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 7, Variation = 6, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 7, Variation = 7, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 7, Variation = 9, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 7, Variation = 10, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 7, Variation = 50, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 7, Variation = 51, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 7, Variation = 52, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 7, Variation = 53, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 8, Variation = 0, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 8, Variation = 1, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 8, Variation = 2, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 8, Variation = 3, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 8, Variation = 4, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 8, Variation = 5, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 8, Variation = 6, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 8, Variation = 7, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 8, Variation = 10, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 8, Variation = 11, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 8, Variation = 19, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 9, Variation = 0, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 9, Variation = 1, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 9, Variation = 2, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 9, Variation = 3, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = true },
        };

        public static List<ModelColors> BootVariationColors = new List<ModelColors>
        {
            new ModelColors { VisualType = 0, Variation = 0, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 1, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 2, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 3, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 4, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 49, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 50, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 92, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 98, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 2, Variation = 0, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 2, Variation = 1, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 2, Variation = 2, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 2, Variation = 3, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 2, Variation = 4, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 2, Variation = 5, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 2, Variation = 6, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 3, Variation = 0, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 4, Variation = 0, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 4, Variation = 1, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 4, Variation = 2, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 5, Variation = 0, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 5, Variation = 1, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 6, Variation = 0, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 7, Variation = 0, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 8, Variation = 0, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 8, Variation = 1, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 8, Variation = 49, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 8, Variation = 162, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 8, Variation = 165, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 9, Variation = 1, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
        };

        public static List<ModelColors> GloveVariationColors = new List<ModelColors>
        {
            new ModelColors { VisualType = 0, Variation = 0, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 1, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 49, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 50, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 51, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 52, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 98, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 2, Variation = 0, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 2, Variation = 1, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 2, Variation = 2, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 2, Variation = 3, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 2, Variation = 4, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 2, Variation = 5, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 2, Variation = 6, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 2, Variation = 7, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 3, Variation = 0, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 3, Variation = 1, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 4, Variation = 0, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 4, Variation = 1, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 5, Variation = 0, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 5, Variation = 1, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 7, Variation = 0, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 7, Variation = 1, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 8, Variation = 0, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 8, Variation = 1, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 8, Variation = 2, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 8, Variation = 3, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 8, Variation = 9, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 10, Variation = 0, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
        };

        public static List<ModelColors> BeltVariationColors = new List<ModelColors>
        {
            new ModelColors { VisualType = 0, Variation = 1, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 2, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 3, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 180, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 181, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 184, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 185, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 1, Variation = 79, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 1, Variation = 85, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 1, Variation = 87, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 1, Variation = 88, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 1, Variation = 91, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 1, Variation = 93, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 1, Variation = 94, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 1, Variation = 95, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 2, Variation = 0, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 2, Variation = 1, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 2, Variation = 2, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 2, Variation = 3, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 8, Variation = 180, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
        };

        public static List<ModelColors> CloakVariationColors = new List<ModelColors>
        {
            new ModelColors { VisualType = 0, Variation = 0, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 1, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 2, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 3, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 4, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 5, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 6, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 8, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 9, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 10, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 11, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 12, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 13, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 14, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 15, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 20, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 21, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 22, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 23, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 24, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 25, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 26, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 27, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 28, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 29, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 30, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 31, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 32, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 33, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 34, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 102, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
        };

        public static List<ModelColors> LeftShoulderVariationColors = new List<ModelColors>
        {
            new ModelColors { VisualType = 0, Variation = 0, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 1, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 2, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 3, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 4, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 5, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 6, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 7, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 9, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 13, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 14, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 15, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 16, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 17, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 18, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 19, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 20, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 21, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 22, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 23, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 24, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 25, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 26, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 27, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 28, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 29, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 30, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 31, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 32, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 33, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 34, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 35, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 36, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 37, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 38, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 210, OneIsAccent = true, TwoIsAccent = true, ThreeIsAccent = false },
        };

        public static List<ModelColors> RightShoulderVariationColors = new List<ModelColors>
        {
            new ModelColors { VisualType = 0, Variation = 0, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 1, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 2, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 3, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 4, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 5, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 6, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 7, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 9, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 13, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 14, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 15, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 16, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 17, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 18, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 19, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 20, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 21, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 22, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 23, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 24, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 25, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 26, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 27, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 28, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 29, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 30, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 31, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 32, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 33, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 34, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 35, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 36, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 37, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 38, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 210, OneIsAccent = true, TwoIsAccent = true, ThreeIsAccent = false },
        };

        public static List<ModelColors> LeftBracerVariationColors = new List<ModelColors>
        {
            new ModelColors { VisualType = 0, Variation = 0, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 1, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 3, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 4, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 5, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 6, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 7, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 8, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 9, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 10, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 11, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 12, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 13, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 14, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 16, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 17, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 18, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 19, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 20, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 21, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 22, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 23, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 24, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 25, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 26, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 27, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 28, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 29, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 30, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 31, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 32, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 33, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 34, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 35, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 99, OneIsAccent = true, TwoIsAccent = true, ThreeIsAccent = true },
        };

        public static List<ModelColors> RightBracerVariationColors = new List<ModelColors>
        {
            new ModelColors { VisualType = 0, Variation = 0, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 1, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 3, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 4, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 5, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 6, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 7, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 8, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 9, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 10, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 11, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 12, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 13, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 14, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 16, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 17, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 18, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 19, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 20, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 21, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 22, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 23, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 24, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 25, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 26, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 27, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 28, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 29, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 30, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 31, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 32, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 33, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 34, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 35, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
        };

        public static List<ModelColors> LeftElbowVariationColors = new List<ModelColors>
        {
            new ModelColors { VisualType = 0, Variation = 0, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 1, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 2, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 3, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 4, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 5, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 6, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 7, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 8, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 9, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 10, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 11, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 12, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 210, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
        };

        public static List<ModelColors> RightElbowVariationColors = new List<ModelColors>
        {
            new ModelColors { VisualType = 0, Variation = 0, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 1, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 2, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 3, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 4, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 5, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 6, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 7, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 8, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 9, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 10, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 11, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 12, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 210, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
        };

        public static List<ModelColors> LeftArmVariationColors = new List<ModelColors>
        {
            new ModelColors { VisualType = 0, Variation = 0, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 1, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 2, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 4, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 5, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 8, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 10, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 12, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 14, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 16, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 18, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 21, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 22, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 23, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 24, OneIsAccent = true, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 25, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 27, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 28, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 29, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 30, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 31, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 99, OneIsAccent = true, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 210, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
        };

        public static List<ModelColors> RightArmVariationColors = new List<ModelColors>
        {
            new ModelColors { VisualType = 0, Variation = 0, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 1, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 2, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 4, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 5, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 8, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 10, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 12, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 14, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 16, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 18, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 21, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 22, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 23, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 24, OneIsAccent = true, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 25, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 27, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 28, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 29, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 30, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 31, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 210, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
        };

        public static List<ModelColors> LeftHipVariationColors = new List<ModelColors>
        {
            new ModelColors { VisualType = 0, Variation = 0, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 1, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 2, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 3, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 150, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 151, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 210, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
        };

        public static List<ModelColors> RightHipVariationColors = new List<ModelColors>
        {
            new ModelColors { VisualType = 0, Variation = 0, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 1, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 2, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 3, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 99, OneIsAccent = true, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 150, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 151, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 210, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
        };

        public static List<ModelColors> FrontHipVariationColors = new List<ModelColors>
        {
            new ModelColors { VisualType = 0, Variation = 0, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
        };

        public static List<ModelColors> BackHipVariationColors = new List<ModelColors>
        {
            new ModelColors { VisualType = 0, Variation = 0, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
        };

        public static List<ModelColors> LeftLegVariationColors = new List<ModelColors>
        {
            new ModelColors { VisualType = 0, Variation = 0, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 1, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 2, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 4, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 6, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 7, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 9, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 10, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 12, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 13, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 14, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 17, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 22, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 23, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 24, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 26, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 27, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 28, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 29, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 98, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 210, OneIsAccent = true, TwoIsAccent = true, ThreeIsAccent = false },
        };

        public static List<ModelColors> RightLegVariationColors = new List<ModelColors>
        {
            new ModelColors { VisualType = 0, Variation = 0, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 1, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 2, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 4, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 6, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 7, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 9, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 10, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 12, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 13, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 14, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 17, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 22, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 23, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 24, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 26, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 27, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 28, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 29, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 97, OneIsAccent = true, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 98, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 99, OneIsAccent = true, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 210, OneIsAccent = true, TwoIsAccent = true, ThreeIsAccent = false },
        };

        public static List<ModelColors> LeftShinVariationColors = new List<ModelColors>
        {
            new ModelColors { VisualType = 0, Variation = 0, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 1, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 3, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 4, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 5, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 6, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 9, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 11, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 14, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 15, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 17, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 19, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 20, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 21, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 22, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 23, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 24, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 25, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
        };

        public static List<ModelColors> RightShinVariationColors = new List<ModelColors>
        {
            new ModelColors { VisualType = 0, Variation = 0, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 1, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 3, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 4, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 5, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 6, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 9, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 11, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 14, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 15, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 17, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 19, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 20, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 21, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 22, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 23, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 24, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 25, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
        };

        public static List<ModelColors> LeftKneeVariationColors = new List<ModelColors>
        {
            new ModelColors { VisualType = 0, Variation = 0, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 1, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 2, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 3, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 4, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 5, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 6, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 7, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 8, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 9, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 10, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 11, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 12, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 13, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 14, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 15, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 210, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = true },
        };

        public static List<ModelColors> RightKneeVariationColors = new List<ModelColors>
        {
            new ModelColors { VisualType = 0, Variation = 0, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 1, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 2, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 3, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 4, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 5, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 6, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 7, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 8, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 9, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 10, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = true },
            new ModelColors { VisualType = 0, Variation = 11, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 12, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 13, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 14, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 15, OneIsAccent = false, TwoIsAccent = true, ThreeIsAccent = false },
            new ModelColors { VisualType = 0, Variation = 210, OneIsAccent = true, TwoIsAccent = false, ThreeIsAccent = true },
        };

        public static List<ModelColors> LeftFootVariationColors = new List<ModelColors>
        {
            new ModelColors { VisualType = 0, Variation = 0, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
        };

        public static List<ModelColors> RightFootVariationColors = new List<ModelColors>
        {
            new ModelColors { VisualType = 0, Variation = 0, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
        };

        public static List<ModelColors> LeftAnkleVariationColors = new List<ModelColors>
        {
            new ModelColors { VisualType = 0, Variation = 0, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
        };

        public static List<ModelColors> RightAnkleVariationColors = new List<ModelColors>
        {
            new ModelColors { VisualType = 0, Variation = 0, OneIsAccent = false, TwoIsAccent = false, ThreeIsAccent = false },
        };
        #endregion
    }
}
