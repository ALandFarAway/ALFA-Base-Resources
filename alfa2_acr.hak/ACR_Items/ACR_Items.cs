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
                case ItemCommand.GenerateLoot:
                    {
                        Generation.GenerateLoot(this, Param1, Param2);
                        break;
                    }
                case ItemCommand.GenerateArmorFirst:
                    {
                        if (Param2 < Param1) Param2 = Param1;
                        Param1 -= GenerateArmor.NewArmor(this, Param2);
                        Generation.GenerateLoot(this, Param1, Param2);
                        break;
                    }
                case ItemCommand.GenerateAmuletFirst:
                    {
                        if (Param2 < Param1) Param2 = Param1;
                        Param1 -= GenerateAmulet.NewAmulet(this, Param2);
                        Generation.GenerateLoot(this, Param1, Param2);
                        break;
                    }
                case ItemCommand.GenerateBeltFirst:
                    {
                        if (Param2 < Param1) Param2 = Param1;
                        Param1 -= GenerateBelt.NewBelt(this, Param2);
                        Generation.GenerateLoot(this, Param1, Param2);
                        break;
                    }
                case ItemCommand.GenerateBootsFirst:
                    {
                        if (Param2 < Param1) Param2 = Param1;
                        Param1 -= GenerateBoots.NewBoots(this, Param2);
                        Generation.GenerateLoot(this, Param1, Param2);
                        break;
                    }
                case ItemCommand.GenerateCloakFirst:
                    {
                        if (Param2 < Param1) Param2 = Param1;
                        Param1 -= GenerateCloak.NewCloak(this, Param2);
                        Generation.GenerateLoot(this, Param1, Param2);
                        break;
                    }
                case ItemCommand.GenerateGlovesFirst:
                    {
                        if (Param2 < Param1) Param2 = Param1;
                        Param1 -= GenerateGloves.NewGloves(this, Param2);
                        Generation.GenerateLoot(this, Param1, Param2);
                        break;
                    }
                case ItemCommand.GenerateHelmetFirst:
                    {
                        if (Param2 < Param1) Param2 = Param1;
                        Param1 -= GenerateHelmet.NewHelmet(this, Param2);
                        Generation.GenerateLoot(this, Param1, Param2);
                        break;
                    }
                case ItemCommand.GenerateRingFirst:
                    {
                        if (Param2 < Param1) Param2 = Param1;
                        Param1 -= GenerateRing.NewRing(this, Param2);
                        Generation.GenerateLoot(this, Param1, Param2);
                        break;
                    }
                case ItemCommand.GenerateRodFirst:
                    {
                        if (Param2 < Param1) Param2 = Param1;
                        Param1 -= GenerateRod.NewRod(this, Param2);
                        Generation.GenerateLoot(this, Param1, Param2);
                        break;
                    }
                case ItemCommand.GenerateStaffFirst:
                    {
                        if (Param2 < Param1) Param2 = Param1;
                        Param1 -= GenerateStaff.NewStaff(this, Param2);
                        Generation.GenerateLoot(this, Param1, Param2);
                        break;
                    }
                case ItemCommand.GenerateWandFirst:
                    {
                        if (Param2 < Param1) Param2 = Param1;
                        Param1 -= GenerateWand.NewWand(this, Param2);
                        Generation.GenerateLoot(this, Param1, Param2);
                        break;
                    }
                case ItemCommand.GenerateScrolls:
                    {
                        while (Param1 >= 25)
                        {
                            if (Param2 < Param1) Param2 = Param1;
                            Param1 -= GenerateScroll.NewScroll(this, Param2);
                        }
                        break;
                    }
                case ItemCommand.GeneratePotions:
                    {
                        while (Param1 >= 50)
                        {
                            if (Param2 < Param1) Param2 = Param1;
                            Param1 -= GeneratePotion.NewPotion(this, Param2);
                        }
                        break;
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
        }
    }
}
