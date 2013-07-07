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
    public class GenerateWand: CLRScriptBase
    {
        static int wandNumber = 0;
        static string wandResRef = "x2_it_pcwand";

        public static int NewWand(CLRScriptBase script, int maxValue)
        {
            if (maxValue < 375)
            {
                return 0;
            }
            int wandValue = 0;
            uint scrollSource = OBJECT_INVALID;
            if (maxValue >= 21000)
            {
                switch (Generation.rand.Next(5))
                {
                    case 0:
                        wandNumber++;
                        scrollSource = script.CreateItemOnObject(GenerateScroll.Level4Scrolls[Generation.rand.Next(GenerateScroll.Level4Scrolls.Count)], script.OBJECT_SELF, 1, "soonwand" + wandNumber.ToString(), FALSE);
                        wandValue = 21000;
                        break;
                    case 1:
                        wandNumber++;
                        scrollSource = script.CreateItemOnObject(GenerateScroll.Level3Scrolls[Generation.rand.Next(GenerateScroll.Level3Scrolls.Count)], script.OBJECT_SELF, 1, "soonwand" + wandNumber.ToString(), FALSE);
                        wandValue = 11250;
                        break;
                    case 2:
                        wandNumber++;
                        scrollSource = script.CreateItemOnObject(GenerateScroll.Level2Scrolls[Generation.rand.Next(GenerateScroll.Level2Scrolls.Count)], script.OBJECT_SELF, 1, "soonwand" + wandNumber.ToString(), FALSE);
                        wandValue = 4500;
                        break;
                    case 3:
                        wandNumber++;
                        scrollSource = script.CreateItemOnObject(GenerateScroll.Level1Scrolls[Generation.rand.Next(GenerateScroll.Level1Scrolls.Count)], script.OBJECT_SELF, 1, "soonwand" + wandNumber.ToString(), FALSE);
                        wandValue = 750;
                        break;
                    case 4:
                        wandNumber++;
                        scrollSource = script.CreateItemOnObject(GenerateScroll.Level0Scrolls[Generation.rand.Next(GenerateScroll.Level0Scrolls.Count)], script.OBJECT_SELF, 1, "soonwand" + wandNumber.ToString(), FALSE);
                        wandValue = 375;
                        break;
                }
            }
            else if (maxValue >= 11250)
            {
                switch (Generation.rand.Next(4))
                {
                    case 0:
                        wandNumber++;
                        scrollSource = script.CreateItemOnObject(GenerateScroll.Level3Scrolls[Generation.rand.Next(GenerateScroll.Level3Scrolls.Count)], script.OBJECT_SELF, 1, "soonwand" + wandNumber.ToString(), FALSE);
                        wandValue = 11250;
                        break;
                    case 1:
                        wandNumber++;
                        scrollSource = script.CreateItemOnObject(GenerateScroll.Level2Scrolls[Generation.rand.Next(GenerateScroll.Level2Scrolls.Count)], script.OBJECT_SELF, 1, "soonwand" + wandNumber.ToString(), FALSE);
                        wandValue = 4500;
                        break;
                    case 2:
                        wandNumber++;
                        scrollSource = script.CreateItemOnObject(GenerateScroll.Level1Scrolls[Generation.rand.Next(GenerateScroll.Level1Scrolls.Count)], script.OBJECT_SELF, 1, "soonwand" + wandNumber.ToString(), FALSE);
                        wandValue = 750;
                        break;
                    case 3:
                        wandNumber++;
                        scrollSource = script.CreateItemOnObject(GenerateScroll.Level0Scrolls[Generation.rand.Next(GenerateScroll.Level0Scrolls.Count)], script.OBJECT_SELF, 1, "soonwand" + wandNumber.ToString(), FALSE);
                        wandValue = 375;
                        break;
                }
            }
            else if (maxValue >= 4500)
            {
                switch (Generation.rand.Next(3))
                {
                    case 0:
                        wandNumber++;
                        scrollSource = script.CreateItemOnObject(GenerateScroll.Level2Scrolls[Generation.rand.Next(GenerateScroll.Level2Scrolls.Count)], script.OBJECT_SELF, 1, "soonwand" + wandNumber.ToString(), FALSE);
                        wandValue = 4500;
                        break;
                    case 1:
                        wandNumber++;
                        scrollSource = script.CreateItemOnObject(GenerateScroll.Level1Scrolls[Generation.rand.Next(GenerateScroll.Level1Scrolls.Count)], script.OBJECT_SELF, 1, "soonwand" + wandNumber.ToString(), FALSE);
                        wandValue = 750;
                        break;
                    case 2:
                        wandNumber++;
                        scrollSource = script.CreateItemOnObject(GenerateScroll.Level0Scrolls[Generation.rand.Next(GenerateScroll.Level0Scrolls.Count)], script.OBJECT_SELF, 1, "soonwand" + wandNumber.ToString(), FALSE);
                        wandValue = 375;
                        break;
                }
            }
            else if (maxValue >= 750)
            {
                switch (Generation.rand.Next(2))
                {
                    case 0:
                        wandNumber++;
                        scrollSource = script.CreateItemOnObject(GenerateScroll.Level1Scrolls[Generation.rand.Next(GenerateScroll.Level1Scrolls.Count)], script.OBJECT_SELF, 1, "soonwand" + wandNumber.ToString(), FALSE);
                        wandValue = 750;
                        break;
                    case 1:
                        wandNumber++;
                        scrollSource = script.CreateItemOnObject(GenerateScroll.Level0Scrolls[Generation.rand.Next(GenerateScroll.Level0Scrolls.Count)], script.OBJECT_SELF, 1, "soonwand" + wandNumber.ToString(), FALSE);
                        wandValue = 375;
                        break;
                }
            }
            else if (maxValue >= 375)
            {
                wandNumber++;
                scrollSource = script.CreateItemOnObject(GenerateScroll.Level0Scrolls[Generation.rand.Next(GenerateScroll.Level0Scrolls.Count)], script.OBJECT_SELF, 1, "soonwand" + wandNumber.ToString(), FALSE);
                wandValue = 375;
            }

            uint wandItem = script.CreateItemOnObject(wandResRef, script.OBJECT_SELF, 1, script.GetTag(scrollSource) + wandNumber.ToString(), FALSE);
            script.SetItemCharges(wandItem, 50);
            string wandName = script.GetFirstName(scrollSource);
            wandName.Replace("Scroll", "Wand");
            script.SetFirstName(wandItem, wandName);
            foreach (NWItemProperty prop in script.GetItemPropertiesOnItem(scrollSource))
            {
                if (script.GetItemPropertyType(prop) == ITEM_PROPERTY_CAST_SPELL)
                {
                    script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyCastSpell(script.GetItemPropertySubType(prop), IP_CONST_CASTSPELL_NUMUSES_1_CHARGE_PER_USE), wandItem, 0.0f);
                }
                else if (script.GetItemPropertyType(prop) == ITEM_PROPERTY_USE_LIMITATION_CLASS)
                {
                    script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyLimitUseByClass(script.GetItemPropertySubType(prop)), wandItem, 0.0f);
                }
            }
            script.DestroyObject(scrollSource, 0.0f, FALSE);
            return wandValue;
        }
    }
}
