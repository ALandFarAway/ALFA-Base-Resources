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
                    ChooserLists.AreaList = ALFA.Shared.Modules.InfoStore.ActiveAreas.Values.ToList<ALFA.Shared.ActiveArea>();
                    ChooserLists.AreaList.Sort();
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
                    }

                    command = Users.GetUser(OBJECT_SELF).openCommand;
                }
            }

            string commandParam = (string)ScriptParameters[1];
            User currentUser = Users.GetUser(OBJECT_SELF);
            switch (command)
            {
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_CREATURE_TAB:
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_ITEM_TAB:
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_PLACEABLE_TAB:
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_TRAP_TAB:
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_VFX_TAB:
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_WAYPOINT_TAB:
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_LIGHTS_TAB:
                    CreatorTabs.FocusTabs(this, currentUser, command);
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
                        else if (currentUser.openCommand == ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_WAYPOINT_TAB) currentCat = currentUser.CurrentWaypointCategory;
                        else if (currentUser.openCommand == ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_VFX_TAB) currentCat = currentUser.CurrentVisualEffectCategory;
                        else if (currentUser.openCommand == ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_LIGHTS_TAB) currentCat = currentUser.CurrentLightCategory;
                        else if (currentUser.openCommand == ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_TRAP_TAB) currentCat = currentUser.CurrentTrapCategory;

                        // and we figure out where we're going relative to where we are.
                        string searchTerm = commandParam.Split(':')[1];
                        if (searchTerm == "..")
                        {
                            if (currentCat.ParentCategory != null)
                            {
                                targetCat = currentCat.ParentCategory;
                            }
                        }
                        else
                        {
                            if (currentUser.openCommand == ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_CREATURE_TAB) targetCat = BackgroundLoader.GetCategoryByName(currentUser.CurrentCreatureCategory, searchTerm);
                            else if (currentUser.openCommand == ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_ITEM_TAB) targetCat = BackgroundLoader.GetCategoryByName(currentUser.CurrentItemCategory, searchTerm);
                            else if (currentUser.openCommand == ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_PLACEABLE_TAB) targetCat = BackgroundLoader.GetCategoryByName(currentUser.CurrentPlaceableCategory, searchTerm);
                            else if (currentUser.openCommand == ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_WAYPOINT_TAB) targetCat = BackgroundLoader.GetCategoryByName(currentUser.CurrentWaypointCategory, searchTerm);
                            else if (currentUser.openCommand == ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_VFX_TAB) targetCat = BackgroundLoader.GetCategoryByName(currentUser.CurrentVisualEffectCategory, searchTerm);
                            else if (currentUser.openCommand == ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_LIGHTS_TAB) targetCat = BackgroundLoader.GetCategoryByName(currentUser.CurrentLightCategory, searchTerm);
                            else if (currentUser.openCommand == ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_TRAP_TAB) targetCat = BackgroundLoader.GetCategoryByName(currentUser.CurrentTrapCategory, searchTerm);
                        }

                        // and then we have a new current category.
                        if (currentUser.openCommand == ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_CREATURE_TAB) currentUser.CurrentCreatureCategory = targetCat;
                        else if (currentUser.openCommand == ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_ITEM_TAB) currentUser.CurrentItemCategory = targetCat;
                        else if (currentUser.openCommand == ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_PLACEABLE_TAB) currentUser.CurrentPlaceableCategory = targetCat;
                        else if (currentUser.openCommand == ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_WAYPOINT_TAB) currentUser.CurrentWaypointCategory = targetCat;
                        else if (currentUser.openCommand == ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_VFX_TAB) currentUser.CurrentVisualEffectCategory = targetCat;
                        else if (currentUser.openCommand == ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_LIGHTS_TAB) currentUser.CurrentLightCategory = targetCat;
                        else if (currentUser.openCommand == ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_TRAP_TAB) currentUser.CurrentTrapCategory = targetCat;

                        // and finally we can draw the new navigator category.
                        Waiter.DrawNavigatorCategory(this, targetCat);
                    }
                    else
                    {
                        SendMessageToPC(OBJECT_SELF, "Preparing to spawn " + commandParam);

                        string spawnUI = ALFA.Shared.GuiGlobals.ACR_GUI_GLOBAL_TARGETUI_SINGLE;
                        string spawnUIScreenName = ALFA.Shared.GuiGlobals.ACR_GUI_GLOBAL_UINAME_SINGLE;

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
                        else if (currentUser.openCommand == ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_WAYPOINT_TAB)
                        {
                            SetGlobalGUIVariable(OBJECT_SELF, ALFA.Shared.GuiGlobals.ACR_GUI_GLOBAL_CREATOR_VALID_TARGET_LIST, "ground");
                            SetGlobalGUIVariable(OBJECT_SELF, ALFA.Shared.GuiGlobals.ACR_GUI_GLOBAL_CREATOR_CREATE_OBJECT_TYPE, CLRScriptBase.OBJECT_TYPE_WAYPOINT.ToString());
                        }
                        else if (currentUser.openCommand == ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_VFX_TAB)
                        {
                            SetGlobalGUIVariable(OBJECT_SELF, ALFA.Shared.GuiGlobals.ACR_GUI_GLOBAL_CREATOR_VALID_TARGET_LIST, "ground");
                            SetGlobalGUIVariable(OBJECT_SELF, ALFA.Shared.GuiGlobals.ACR_GUI_GLOBAL_CREATOR_CREATE_OBJECT_TYPE, CLRScriptBase.OBJECT_TYPE_PLACED_EFFECT.ToString());
                        }
                        else if (currentUser.openCommand == ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_LIGHTS_TAB)
                        {
                            SetGlobalGUIVariable(OBJECT_SELF, ALFA.Shared.GuiGlobals.ACR_GUI_GLOBAL_CREATOR_VALID_TARGET_LIST, "ground");
                            SetGlobalGUIVariable(OBJECT_SELF, ALFA.Shared.GuiGlobals.ACR_GUI_GLOBAL_CREATOR_CREATE_OBJECT_TYPE, CLRScriptBase.OBJECT_TYPE_LIGHT.ToString());
                        }
                        else if (currentUser.openCommand == ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_TRAP_TAB)
                        {
                            SetGlobalGUIVariable(OBJECT_SELF, ALFA.Shared.GuiGlobals.ACR_GUI_GLOBAL_CREATOR_VALID_TARGET_LIST, "ground");
                            SetGlobalGUIVariable(OBJECT_SELF, ALFA.Shared.GuiGlobals.ACR_GUI_GLOBAL_CREATOR_CREATE_OBJECT_TYPE, "99");
                            ALFA.Shared.TrapResource trapToSpawn = ALFA.Shared.Modules.InfoStore.ModuleTraps[commandParam];
                            if (trapToSpawn != null)
                            {
                                switch(trapToSpawn.TriggerArea)
                                    {
                                        case 2:
                                            spawnUI = ALFA.Shared.GuiGlobals.ACR_GUI_GLOBAL_TARGETUI_10FT;
                                            spawnUIScreenName = ALFA.Shared.GuiGlobals.ACR_GUI_GLOBAL_UINAME_10FT;
                                            break;
                                        case 3:
                                            spawnUI = ALFA.Shared.GuiGlobals.ACR_GUI_GLOBAL_TARGETUI_20FT;
                                            spawnUIScreenName = ALFA.Shared.GuiGlobals.ACR_GUI_GLOBAL_UINAME_20FT;
                                            break;
                                        case 4:
                                            spawnUI = ALFA.Shared.GuiGlobals.ACR_GUI_GLOBAL_TARGETUI_20FT;
                                            spawnUIScreenName = ALFA.Shared.GuiGlobals.ACR_GUI_GLOBAL_UINAME_20FT;
                                            break;
                                        case 5:
                                            spawnUI = ALFA.Shared.GuiGlobals.ACR_GUI_GLOBAL_TARGETUI_30FT;
                                            spawnUIScreenName = ALFA.Shared.GuiGlobals.ACR_GUI_GLOBAL_UINAME_30FT;
                                            break;
                                        case 6:
                                            spawnUI = ALFA.Shared.GuiGlobals.ACR_GUI_GLOBAL_TARGETUI_30FT;
                                            spawnUIScreenName = ALFA.Shared.GuiGlobals.ACR_GUI_GLOBAL_UINAME_30FT;
                                            break;
                                        default:
                                            spawnUI = ALFA.Shared.GuiGlobals.ACR_GUI_GLOBAL_TARGETUI_SINGLE;
                                            spawnUIScreenName = ALFA.Shared.GuiGlobals.ACR_GUI_GLOBAL_UINAME_SINGLE;
                                            break;
                                    }
                            }
                        }
                        
                        DisplayGuiScreen(OBJECT_SELF, spawnUIScreenName, 0, spawnUI, 0);
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
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_SEARCH_WAYPOINT:
                    // TODO: Kick off background process and waiter process to
                    // search for the user's request.
                    break;
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_SEARCH_VFX:
                    // TODO: Kick off background process and waiter process to
                    // search for the user's request.
                    break;
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_INITIALIZE_CHOOSER:
                    ChooserLists.InitializeButtons(this, currentUser);
                    if (currentUser.LastSeenArea != GetArea(currentUser.Id))
                    {
                        ChooserLists.DrawAreas(this, currentUser);
                    }
                    currentUser.FocusedArea = GetArea(currentUser.Id);
                    ChooserLists.DrawObjects(this, currentUser, currentUser.FocusedArea);
                    break;
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_CHOOSER:
                    ChooserLists.DrawObjects(this, currentUser, currentUser.FocusedArea);
                    break;
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_LIMBO:
                    // TODO: list all creatures in limbo.
                    break;
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_SEARCH_CHOOSER:
                    // TODO: Run a search of areas for the provided string.
                    break;
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_LIST_AREA:
                    uint targetArea = 0;
                    if (uint.TryParse(commandParam, out targetArea))
                    {
                        currentUser.FocusedArea = targetArea;
                        ChooserLists.DrawObjects(this, currentUser, currentUser.FocusedArea);
                    }
                    break;
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_CHOOSER_AOE_VISIBLE:
                    currentUser.ChooserShowAOE = !currentUser.ChooserShowAOE;
                    SetGUITexture(currentUser.Id, "SCREEN_DMC_CHOOSER", "SHOW_AOE", currentUser.ChooserShowAOE ? "trap.tga" : "notrap.tga");
                    ChooserLists.DrawObjects(this, currentUser, currentUser.FocusedArea);
                    break;
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_CHOOSER_CREATURE_VISIBLE:
                    currentUser.ChooserShowCreature = !currentUser.ChooserShowCreature;
                    SetGUITexture(currentUser.Id, "SCREEN_DMC_CHOOSER", "SHOW_CREATURE", currentUser.ChooserShowCreature ? "creature.tga" : "nocreature.tga");
                    ChooserLists.DrawObjects(this, currentUser, currentUser.FocusedArea);
                    break;
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_CHOOSER_DOOR_VISIBLE:
                    currentUser.ChooserShowDoor = !currentUser.ChooserShowDoor;
                    SetGUITexture(currentUser.Id, "SCREEN_DMC_CHOOSER", "SHOW_DOOR", currentUser.ChooserShowDoor ? "door.tga" : "nodoor.tga");
                    ChooserLists.DrawObjects(this, currentUser, currentUser.FocusedArea);
                    break;
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_CHOOSER_ITEM_VISIBLE:
                    currentUser.ChooserShowItem = !currentUser.ChooserShowItem;
                    SetGUITexture(currentUser.Id, "SCREEN_DMC_CHOOSER", "SHOW_ITEM", currentUser.ChooserShowItem ? "item.tga" : "noitem.tga");
                    ChooserLists.DrawObjects(this, currentUser, currentUser.FocusedArea);
                    break;
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_CHOOSER_LIGHT_VISIBLE:
                    currentUser.ChooserShowLight = !currentUser.ChooserShowLight;
                    SetGUITexture(currentUser.Id, "SCREEN_DMC_CHOOSER", "SHOW_LIGHT", currentUser.ChooserShowLight ? "light.tga" : "nolight.tga");
                    ChooserLists.DrawObjects(this, currentUser, currentUser.FocusedArea);
                    break;
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_CHOOSER_PLACEABLE_VISIBLE:
                    currentUser.ChooserShowPlaceable = !currentUser.ChooserShowPlaceable;
                    SetGUITexture(currentUser.Id, "SCREEN_DMC_CHOOSER", "SHOW_PLACEABLE", currentUser.ChooserShowPlaceable ? "placeable.tga" : "noplaceable.tga");
                    ChooserLists.DrawObjects(this, currentUser, currentUser.FocusedArea);
                    break;
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_CHOOSER_PLACEDEFFECT_VISIBLE:
                    currentUser.ChooserShowPlacedEffect = !currentUser.ChooserShowPlacedEffect;
                    SetGUITexture(currentUser.Id, "SCREEN_DMC_CHOOSER", "SHOW_VFX", currentUser.ChooserShowPlacedEffect ? "vfx.tga" : "novfx.tga");
                    ChooserLists.DrawObjects(this, currentUser, currentUser.FocusedArea);
                    break;
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_CHOOSER_STORE_VISIBLE:
                    currentUser.ChooserShowStore = !currentUser.ChooserShowStore;
                    SetGUITexture(currentUser.Id, "SCREEN_DMC_CHOOSER", "SHOW_STORE", currentUser.ChooserShowStore ? "store.tga" : "nostore.tga");
                    ChooserLists.DrawObjects(this, currentUser, currentUser.FocusedArea);
                    break;
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_CHOOSER_TRIGGER_VISIBLE:
                    currentUser.ChooserShowTrigger = !currentUser.ChooserShowTrigger;
                    SetGUITexture(currentUser.Id, "SCREEN_DMC_CHOOSER", "SHOW_TRIGGER", currentUser.ChooserShowTrigger ? "trigger.tga" : "notrigger.tga");
                    ChooserLists.DrawObjects(this, currentUser, currentUser.FocusedArea);
                    break;
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_CHOOSER_WAYPOINT_VISIBLE:
                    currentUser.ChooserShowWaypoint = !currentUser.ChooserShowWaypoint;
                    SetGUITexture(currentUser.Id, "SCREEN_DMC_CHOOSER", "SHOW_WAYPOINT", currentUser.ChooserShowWaypoint ? "waypoint.tga" : "nowaypoint.tga");
                    ChooserLists.DrawObjects(this, currentUser, currentUser.FocusedArea);
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
            ACR_CHOOSERCREATOR_SEARCH_LIGHTS = 37,

            ACR_CHOOSERCREATOR_INITIALIZE_CHOOSER = 100,
            ACR_CHOOSERCREATOR_FOCUS_CHOOSER = 101,
            ACR_CHOOSERCREATOR_FOCUS_LIMBO = 102,

            ACR_CHOOSERCREATOR_SEARCH_CHOOSER = 111,
            ACR_CHOOSERCREATOR_LIST_AREA = 112,

            ACR_CHOOSERCREATOR_CHOOSER_AOE_VISIBLE = 121,
            ACR_CHOOSERCREATOR_CHOOSER_CREATURE_VISIBLE = 122,
            ACR_CHOOSERCREATOR_CHOOSER_DOOR_VISIBLE = 123, 
            ACR_CHOOSERCREATOR_CHOOSER_ITEM_VISIBLE = 124,
            ACR_CHOOSERCREATOR_CHOOSER_LIGHT_VISIBLE = 125,
            ACR_CHOOSERCREATOR_CHOOSER_PLACEABLE_VISIBLE = 126,
            ACR_CHOOSERCREATOR_CHOOSER_PLACEDEFFECT_VISIBLE = 127,
            ACR_CHOOSERCREATOR_CHOOSER_STORE_VISIBLE = 128,
            ACR_CHOOSERCREATOR_CHOOSER_TRIGGER_VISIBLE = 129,
            ACR_CHOOSERCREATOR_CHOOSER_WAYPOINT_VISIBLE = 130,
        }

    }
}
