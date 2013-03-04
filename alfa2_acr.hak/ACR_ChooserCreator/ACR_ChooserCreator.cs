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
    public partial class ACR_ChooserCreator : CLRScriptBase, IGeneratedScriptProgram
    {
        public ACR_ChooserCreator([In] NWScriptJITIntrinsics Intrinsics, [In] INWScriptProgram Host)
        {
            InitScript(Intrinsics, Host);
        }

        private ACR_ChooserCreator([In] ACR_ChooserCreator Other)
        {
            InitScript(Other);

            LoadScriptGlobals(Other.SaveScriptGlobals());
        }

        public static Type[] ScriptParameterTypes = { typeof(int), typeof(string) };

        public Int32 ScriptMain([In] object[] ScriptParameters, [In] Int32 DefaultReturnCode)
        {
            bool debug = true;
            int commandNumber = (int)ScriptParameters[0];
            ACR_CreatorCommand command = (ACR_CreatorCommand)commandNumber;
            if (command == ACR_CreatorCommand.ACR_CHOOSERCREATOR_INITIALIZE_LISTS)
            {
                if (OBJECT_SELF == GetModule())
                {
                    BackgroundLoader loader = new BackgroundLoader();
                    loader.DoWork += BackgroundLoader.LoadNavigators;
                    loader.RunWorkerAsync();
                    return 0;
                }
                else
                {
                    if (Users.GetUser(OBJECT_SELF).openCommand == ACR_CreatorCommand.ACR_CHOOSERCREATOR_INITIALIZE_LISTS)
                        Users.GetUser(OBJECT_SELF).openCommand = ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_CREATURE_TAB;

                    if (debug)
                    {
                        SendMessageToPC(OBJECT_SELF, BackgroundLoader.loaderError);
                        foreach (int fac in ALFA.Shared.Modules.InfoStore.ModuleFactions.Keys)
                        {
                            SendMessageToPC(OBJECT_SELF, "Faction :" + fac.ToString() + " = " + ALFA.Shared.Modules.InfoStore.ModuleFactions[fac].Name);
                        }
                    }

                    command = Users.GetUser(OBJECT_SELF).openCommand;
                }
            }

            string commandParam = (string)ScriptParameters[1];
            User currentUser = Users.GetUser(OBJECT_SELF);
            switch (command)
            {
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_CREATURE_TAB:
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "CreatureActive", FALSE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "ItemActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "PlaceableActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "TrapActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "VfxActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "WaypointActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "LightActive", TRUE);
                    currentUser.openCommand = ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_CREATURE_TAB;
                    if (currentUser.CurrentCreatureCategory == Navigators.CreatureNavigator.bottomCategory)
                    {
                        Waiter.WaitForNavigator((CLRScriptBase)this, Navigators.CreatureNavigator);
                    }
                    else
                    {
                        Waiter.DrawNavigatorCategory((CLRScriptBase)this, currentUser.CurrentCreatureCategory);
                    }
                    break;
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_ITEM_TAB:
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "CreatureActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "ItemActive", FALSE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "PlaceableActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "TrapActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "VfxActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "WaypointActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "LightActive", TRUE);
                    currentUser.openCommand = ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_ITEM_TAB;
                    if (currentUser.CurrentItemCategory == Navigators.ItemNavigator.bottomCategory)
                    {
                        Waiter.WaitForNavigator((CLRScriptBase)this, Navigators.ItemNavigator);
                    }
                    else
                    {
                        Waiter.DrawNavigatorCategory((CLRScriptBase)this, currentUser.CurrentItemCategory);
                    }
                    break;
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_PLACEABLE_TAB:
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "CreatureActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "ItemActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "PlaceableActive", FALSE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "TrapActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "VfxActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "WaypointActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "LightActive", TRUE);
                    currentUser.openCommand = ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_PLACEABLE_TAB;
                    if (currentUser.CurrentPlaceableCategory == Navigators.PlaceableNavigator.bottomCategory)
                    {
                        Waiter.WaitForNavigator((CLRScriptBase)this, Navigators.PlaceableNavigator);
                    }
                    else
                    {
                        Waiter.DrawNavigatorCategory((CLRScriptBase)this, currentUser.CurrentPlaceableCategory);
                    }
                    break;
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_TRAP_TAB:
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "CreatureActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "ItemActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "PlaceableActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "TrapActive", FALSE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "VfxActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "WaypointActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "LightActive", TRUE);
                    // TODO: Display current trap classification, or the base
                    // classification if none are selected.
                    break;
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_VFX_TAB:
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "CreatureActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "ItemActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "PlaceableActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "TrapActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "VfxActive", FALSE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "WaypointActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "LightActive", TRUE);
                    // TODO: Display current VFX classification, or the base
                    // classification if none are selected.
                    break;
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_WAYPOINT_TAB:
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "CreatureActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "ItemActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "PlaceableActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "TrapActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "VfxActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "WaypointActive", FALSE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "LightActive", TRUE);
                    // TODO: Display current waypoint classification, or the base
                    // classification if none are selected.
                    break;
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_LIGHTS_TAB:
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "CreatureActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "ItemActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "PlaceableActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "TrapActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "VfxActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "WaypointActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "LightActive", FALSE);
                    // TODO: Display current lights classification, or the base
                    // classification if none are selected.
                    break;
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_INCOMING_CLICK:
                    // TODO: make note of the selected row and provide
                    // additional information, if appropriate.
                    break;
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_INCOMING_DOUBLECLICK:
                    if (commandParam.Contains(":"))
                    {
                        // first, default this stuff in. On error, we flip out and just use
                        // the bottom category in the creature navigator.
                        NavigatorCategory currentCat = Navigators.CreatureNavigator.bottomCategory;
                        NavigatorCategory targetCat = Navigators.CreatureNavigator.bottomCategory;

                        // then, we need to know where we are right now.
                        if (currentUser.openCommand == ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_CREATURE_TAB) currentCat = currentUser.CurrentCreatureCategory;
                        else if (currentUser.openCommand == ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_ITEM_TAB) currentCat = currentUser.CurrentItemCategory;
                        else if (currentUser.openCommand == ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_PLACEABLE_TAB) currentCat = currentUser.CurrentPlaceableCategory;

                        // and we figure out where we're going relative to where we are.
                        string searchTerm = commandParam.Split(':')[1];
                        if (searchTerm == "..") targetCat = currentCat.ParentCategory;
                        else
                        {
                            if (currentUser.openCommand == ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_CREATURE_TAB) targetCat = BackgroundLoader.GetCategoryByName(currentUser.CurrentCreatureCategory, searchTerm);
                            else if (currentUser.openCommand == ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_ITEM_TAB) targetCat = BackgroundLoader.GetCategoryByName(currentUser.CurrentItemCategory, searchTerm);
                            else if (currentUser.openCommand == ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_PLACEABLE_TAB) targetCat = BackgroundLoader.GetCategoryByName(currentUser.CurrentPlaceableCategory, searchTerm);
                        }

                        // and then we have a new current category.
                        if (currentUser.openCommand == ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_CREATURE_TAB) currentUser.CurrentCreatureCategory = targetCat;
                        else if (currentUser.openCommand == ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_ITEM_TAB) currentUser.CurrentItemCategory = targetCat;
                        else if (currentUser.openCommand == ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_PLACEABLE_TAB) currentUser.CurrentPlaceableCategory = targetCat;

                        // and finally we can draw the new navigator category.
                        Waiter.DrawNavigatorCategory(this, targetCat);
                    }
                    else
                    {
                        SendMessageToPC(OBJECT_SELF, "Preparing to spawn " + commandParam);

                        // The name of the script to execute on targeting.
                        SetGlobalGUIVariable(OBJECT_SELF, ALFA.Shared.GuiGlobals.ACR_GUI_GLOBAL_CREATOR_TARGET_SCRIPT_NAME, "gui_creatorspawn");

                        // The first string parameter being used.
                        SetGlobalGUIVariable(OBJECT_SELF, ALFA.Shared.GuiGlobals.ACR_GUI_GLOBAL_CREATOR_TARGET_SCRIPT_NAME_PARAM, commandParam);

                        if (currentUser.openCommand == ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_CREATURE_TAB)
                        {
                            SetGlobalGUIVariable(OBJECT_SELF, ALFA.Shared.GuiGlobals.ACR_GUI_GLOBAL_CREATOR_VALID_TARGET_LIST, "ground");
                            SetGlobalGUIVariable(OBJECT_SELF, ALFA.Shared.GuiGlobals.ACR_GUI_GLOBAL_CREATOR_CREATE_OBJECT_TYPE, CLRScriptBase.OBJECT_TYPE_CREATURE.ToString());
                        }
                        else if (currentUser.openCommand == ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_ITEM_TAB)
                        {
                            SetGlobalGUIVariable(OBJECT_SELF, ALFA.Shared.GuiGlobals.ACR_GUI_GLOBAL_CREATOR_VALID_TARGET_LIST, "self,creature,ground,placeable");
                            SetGlobalGUIVariable(OBJECT_SELF, ALFA.Shared.GuiGlobals.ACR_GUI_GLOBAL_CREATOR_CREATE_OBJECT_TYPE, CLRScriptBase.OBJECT_TYPE_ITEM.ToString());
                        }
                        else if (currentUser.openCommand == ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_PLACEABLE_TAB)
                        {
                            SetGlobalGUIVariable(OBJECT_SELF, ALFA.Shared.GuiGlobals.ACR_GUI_GLOBAL_CREATOR_VALID_TARGET_LIST, "ground");
                            SetGlobalGUIVariable(OBJECT_SELF, ALFA.Shared.GuiGlobals.ACR_GUI_GLOBAL_CREATOR_CREATE_OBJECT_TYPE, CLRScriptBase.OBJECT_TYPE_PLACEABLE.ToString());
                        }
                        
                        DisplayGuiScreen(OBJECT_SELF, "TARGET_SINGLE", 0, "target_single.xml", 0);
                    }
                    // TODO: make note of the selected row and provide a suitable
                    // interface to direct the action.
                    break;
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_SEARCH_CREATURES:
                    // TODO: Kick off background process and waiter process to
                    // search for the user's request.
                    break;
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_SEARCH_ITEMS:
                    // TODO: Kick off background process and waiter process to
                    // search for the user's request.
                    break;
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_SEARCH_PLACEABLES:
                    // TODO: Kick off background process and waiter process to
                    // search for the user's request.
                    break;
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_SEARCH_TRAPS:
                    // TODO: Kick off background process and waiter process to
                    // search for the user's request.
                    break;
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_SEARCH_VFX:
                    // TODO: Kick off background process and waiter process to
                    // search for the user's request.
                    break;
            }
            return 0;

        }

        public enum ACR_CreatorCommand
        {
            ACR_CHOOSERCREATOR_INITIALIZE_LISTS = 0,

            ACR_CHOOSERCREATOR_FOCUS_CREATURE_TAB = 1,
            ACR_CHOOSERCREATOR_FOCUS_ITEM_TAB = 2,
            ACR_CHOOSERCREATOR_FOCUS_PLACEABLE_TAB = 3,
            ACR_CHOOSERCREATOR_FOCUS_TRAP_TAB = 4,
            ACR_CHOOSERCREATOR_FOCUS_VFX_TAB = 5,
            ACR_CHOOSERCREATOR_FOCUS_WAYPOINT_TAB = 6,
            ACR_CHOOSERCREATOR_FOCUS_LIGHTS_TAB = 7,

            ACR_CHOOSERCREATOR_INCOMING_CLICK = 20,
            ACR_CHOOSERCREATOR_INCOMING_DOUBLECLICK = 21,

            ACR_CHOOSERCREATOR_SEARCH_CREATURES = 31,
            ACR_CHOOSERCREATOR_SEARCH_ITEMS = 32,
            ACR_CHOOSERCREATOR_SEARCH_PLACEABLES = 33,
            ACR_CHOOSERCREATOR_SEARCH_TRAPS = 34,
            ACR_CHOOSERCREATOR_SEARCH_VFX = 35,
            ACR_CHOOSERCREATOR_SEARCH_WAYPOINT = 36,
            ACR_CHOOSERCREATOR_SEARCH_LIGHTS = 37
        }

    }
}
