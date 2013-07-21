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

namespace ACR_ChooserCreator
{
    public class CreatorTabs: CLRScriptBase
    {
        public static void FocusTabs(CLRScriptBase script, User currentUser, ACR_ChooserCreator.ACR_CreatorCommand command)
        {
            switch (command)
            {
                case ACR_ChooserCreator.ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_CREATURE_TAB:
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "CreatureActive", FALSE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "ItemActive", TRUE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "PlaceableActive", TRUE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "TrapActive", TRUE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "VfxActive", TRUE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "WaypointActive", TRUE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "LightActive", TRUE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "ItemButtons", TRUE);
                    currentUser.openCommand = ACR_ChooserCreator.ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_CREATURE_TAB;
                    script.SetGUIObjectText(currentUser.Id, "SCREEN_DMC_CREATOR", "Column2", -1, "Fac");
                    script.SetGUIObjectText(currentUser.Id, "SCREEN_DMC_CREATOR", "Column3", -1, "CR");
                    if (currentUser.CurrentCreatureCategory == Navigators.CreatureNavigator.bottomCategory)
                    {
                        Waiter.WaitForNavigator(script, Navigators.CreatureNavigator);
                    }
                    else
                    {
                        if (currentUser.CurrentCreatureCategory == null)
                        {
                            currentUser.CurrentCreatureCategory = Navigators.CreatureNavigator.bottomCategory;
                        }
                        Waiter.DrawNavigatorCategory(script, currentUser.CurrentCreatureCategory);
                    }
                    break;
                case ACR_ChooserCreator.ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_ITEM_TAB:
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "CreatureActive", TRUE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "ItemActive", FALSE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "PlaceableActive", TRUE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "TrapActive", TRUE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "VfxActive", TRUE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "WaypointActive", TRUE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "LightActive", TRUE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "ItemButtons", FALSE);
                    currentUser.openCommand = ACR_ChooserCreator.ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_ITEM_TAB;
                    script.SetGUIObjectText(currentUser.Id, "SCREEN_DMC_CREATOR", "Column2", -1, "Value");
                    script.SetGUIObjectText(currentUser.Id, "SCREEN_DMC_CREATOR", "Column3", -1, "Lvl");
                    if (currentUser.CurrentItemCategory == Navigators.ItemNavigator.bottomCategory)
                    {
                        Waiter.WaitForNavigator(script, Navigators.ItemNavigator);
                    }
                    else
                    {
                        if (currentUser.CurrentItemCategory == null)
                        {
                            currentUser.CurrentItemCategory = Navigators.ItemNavigator.bottomCategory;
                        }
                        Waiter.DrawNavigatorCategory(script, currentUser.CurrentItemCategory);
                    }
                    break;
                case ACR_ChooserCreator.ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_PLACEABLE_TAB:
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "CreatureActive", TRUE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "ItemActive", TRUE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "PlaceableActive", FALSE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "TrapActive", TRUE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "VfxActive", TRUE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "WaypointActive", TRUE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "LightActive", TRUE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "ItemButtons", TRUE);
                    currentUser.openCommand = ACR_ChooserCreator.ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_PLACEABLE_TAB;
                    script.SetGUIObjectText(currentUser.Id, "SCREEN_DMC_CREATOR", "Column2", -1, "Lck/Trp");
                    script.SetGUIObjectText(currentUser.Id, "SCREEN_DMC_CREATOR", "Column3", -1, "Inv?");
                    if (currentUser.CurrentPlaceableCategory == Navigators.PlaceableNavigator.bottomCategory)
                    {
                        Waiter.WaitForNavigator(script, Navigators.PlaceableNavigator);
                    }
                    else
                    {
                        if (currentUser.CurrentPlaceableCategory == null)
                        {
                            currentUser.CurrentPlaceableCategory = Navigators.PlaceableNavigator.bottomCategory;
                        }
                        Waiter.DrawNavigatorCategory(script, currentUser.CurrentPlaceableCategory);
                    }
                    break;
                case ACR_ChooserCreator.ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_TRAP_TAB:
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "CreatureActive", TRUE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "ItemActive", TRUE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "PlaceableActive", TRUE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "TrapActive", FALSE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "VfxActive", TRUE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "WaypointActive", TRUE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "LightActive", TRUE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "ItemButtons", TRUE);
                    currentUser.openCommand = ACR_ChooserCreator.ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_TRAP_TAB;
                    script.SetGUIObjectText(currentUser.Id, "SCREEN_DMC_CREATOR", "Column2", -1, "DC");
                    script.SetGUIObjectText(currentUser.Id, "SCREEN_DMC_CREATOR", "Column3", -1, "CR");
                    if (currentUser.CurrentTrapCategory == Navigators.TrapNavigator.bottomCategory)
                    {
                        Waiter.WaitForNavigator(script, Navigators.TrapNavigator);
                    }
                    else
                    {
                        if (currentUser.CurrentTrapCategory == null)
                        {
                            currentUser.CurrentTrapCategory = Navigators.TrapNavigator.bottomCategory;
                        }
                        Waiter.DrawNavigatorCategory(script, currentUser.CurrentTrapCategory);
                    }
                    break;
                case ACR_ChooserCreator.ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_VFX_TAB:
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "CreatureActive", TRUE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "ItemActive", TRUE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "PlaceableActive", TRUE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "TrapActive", TRUE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "VfxActive", FALSE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "WaypointActive", TRUE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "LightActive", TRUE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "ItemButtons", TRUE);
                    currentUser.openCommand = ACR_ChooserCreator.ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_VFX_TAB;
                    script.SetGUIObjectText(currentUser.Id, "SCREEN_DMC_CREATOR", "Column2", -1, " ");
                    script.SetGUIObjectText(currentUser.Id, "SCREEN_DMC_CREATOR", "Column3", -1, " ");
                    if (currentUser.CurrentVisualEffectCategory == Navigators.VisualEffectNavigator.bottomCategory)
                    {
                        Waiter.WaitForNavigator(script, Navigators.VisualEffectNavigator);
                    }
                    else
                    {
                        if (currentUser.CurrentVisualEffectCategory == null)
                        {
                            currentUser.CurrentVisualEffectCategory = Navigators.VisualEffectNavigator.bottomCategory;
                        }
                        Waiter.DrawNavigatorCategory(script, currentUser.CurrentVisualEffectCategory);
                    }
                    break;
                case ACR_ChooserCreator.ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_WAYPOINT_TAB:
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "CreatureActive", TRUE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "ItemActive", TRUE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "PlaceableActive", TRUE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "TrapActive", TRUE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "VfxActive", TRUE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "WaypointActive", FALSE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "LightActive", TRUE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "ItemButtons", TRUE);
                    currentUser.openCommand = ACR_ChooserCreator.ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_WAYPOINT_TAB;
                    script.SetGUIObjectText(currentUser.Id, "SCREEN_DMC_CREATOR", "Column2", -1, " ");
                    script.SetGUIObjectText(currentUser.Id, "SCREEN_DMC_CREATOR", "Column3", -1, " ");
                    if (currentUser.CurrentWaypointCategory == Navigators.WaypointNavigator.bottomCategory)
                    {
                        Waiter.WaitForNavigator(script, Navigators.WaypointNavigator);
                    }
                    else
                    {
                        if (currentUser.CurrentWaypointCategory == null)
                        {
                            currentUser.CurrentWaypointCategory = Navigators.WaypointNavigator.bottomCategory;
                        }
                        Waiter.DrawNavigatorCategory(script, currentUser.CurrentWaypointCategory);
                    }
                    break;
                case ACR_ChooserCreator.ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_LIGHTS_TAB:
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "CreatureActive", TRUE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "ItemActive", TRUE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "PlaceableActive", TRUE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "TrapActive", TRUE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "VfxActive", TRUE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "WaypointActive", TRUE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "LightActive", FALSE);
                    script.SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "ItemButtons", TRUE);
                    currentUser.openCommand = ACR_ChooserCreator.ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_LIGHTS_TAB;
                    script.SetGUIObjectText(currentUser.Id, "SCREEN_DMC_CREATOR", "Column2", -1, "Brt/Rd");
                    script.SetGUIObjectText(currentUser.Id, "SCREEN_DMC_CREATOR", "Column3", -1, "Shd");
                    if (currentUser.CurrentWaypointCategory == Navigators.LightNavigator.bottomCategory)
                    {
                        Waiter.WaitForNavigator(script, Navigators.LightNavigator);
                    }
                    else
                    {
                        if (currentUser.CurrentLightCategory == null)
                        {
                            currentUser.CurrentLightCategory = Navigators.LightNavigator.bottomCategory;
                        }
                        Waiter.DrawNavigatorCategory(script, currentUser.CurrentLightCategory);
                    }
                    break;
            }
        }
    }
}
