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
                    }

                    command = Users.GetUser(OBJECT_SELF).openCommand;
                }
            }

            string commandParam = (string)ScriptParameters[1];
            User currentUser = Users.GetUser(OBJECT_SELF);
            switch (command)
            {
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_CREATURE_TAB:
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "CreatureActive", FALSE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "ItemActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "PlaceableActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "TrapActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "VfxActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "WaypointActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "LightActive", TRUE);
                    currentUser.openCommand = ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_CREATURE_TAB;
                    SetGUIObjectText(currentUser.Id, "SCREEN_DMC_CREATOR", "Column2", -1, "Fac");
                    SetGUIObjectText(currentUser.Id, "SCREEN_DMC_CREATOR", "Column3", -1, "CR");
                    if (currentUser.CurrentCreatureCategory == Navigators.CreatureNavigator.bottomCategory)
                    {
                        Waiter.WaitForNavigator((CLRScriptBase)this, Navigators.CreatureNavigator);
                    }
                    else
                    {
                        if (currentUser.CurrentCreatureCategory == null)
                        {
                            currentUser.CurrentCreatureCategory = Navigators.CreatureNavigator.bottomCategory;
                        }
                        Waiter.DrawNavigatorCategory((CLRScriptBase)this, currentUser.CurrentCreatureCategory);
                    }
                    break;
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_ITEM_TAB:
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "CreatureActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "ItemActive", FALSE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "PlaceableActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "TrapActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "VfxActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "WaypointActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "LightActive", TRUE);
                    currentUser.openCommand = ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_ITEM_TAB;
                    SetGUIObjectText(currentUser.Id, "SCREEN_DMC_CREATOR", "Column2", -1, "Value");
                    SetGUIObjectText(currentUser.Id, "SCREEN_DMC_CREATOR", "Column3", -1, "Lvl");
                    if (currentUser.CurrentItemCategory == Navigators.ItemNavigator.bottomCategory)
                    {
                        Waiter.WaitForNavigator((CLRScriptBase)this, Navigators.ItemNavigator);
                    }
                    else
                    {
                        if (currentUser.CurrentItemCategory == null)
                        {
                            currentUser.CurrentItemCategory = Navigators.ItemNavigator.bottomCategory;
                        }
                        Waiter.DrawNavigatorCategory((CLRScriptBase)this, currentUser.CurrentItemCategory);
                    }
                    break;
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_PLACEABLE_TAB:
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "CreatureActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "ItemActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "PlaceableActive", FALSE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "TrapActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "VfxActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "WaypointActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "LightActive", TRUE);
                    currentUser.openCommand = ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_PLACEABLE_TAB;
                    SetGUIObjectText(currentUser.Id, "SCREEN_DMC_CREATOR", "Column2", -1, "Lck/Trp");
                    SetGUIObjectText(currentUser.Id, "SCREEN_DMC_CREATOR", "Column3", -1, "Inv?");
                    if (currentUser.CurrentPlaceableCategory == Navigators.PlaceableNavigator.bottomCategory)
                    {
                        Waiter.WaitForNavigator((CLRScriptBase)this, Navigators.PlaceableNavigator);
                    }
                    else
                    {
                        if (currentUser.CurrentPlaceableCategory == null)
                        {
                            currentUser.CurrentPlaceableCategory = Navigators.PlaceableNavigator.bottomCategory;
                        }
                        Waiter.DrawNavigatorCategory((CLRScriptBase)this, currentUser.CurrentPlaceableCategory);
                    }
                    break;
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_TRAP_TAB:
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "CreatureActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "ItemActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "PlaceableActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "TrapActive", FALSE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "VfxActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "WaypointActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "LightActive", TRUE);
                    currentUser.openCommand = ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_TRAP_TAB;
                    SetGUIObjectText(currentUser.Id, "SCREEN_DMC_CREATOR", "Column2", -1, "DC");
                    SetGUIObjectText(currentUser.Id, "SCREEN_DMC_CREATOR", "Column3", -1, "CR");
                    if (currentUser.CurrentTrapCategory == Navigators.TrapNavigator.bottomCategory)
                    {
                        Waiter.WaitForNavigator((CLRScriptBase)this, Navigators.TrapNavigator);
                    }
                    else
                    {
                        if (currentUser.CurrentTrapCategory == null)
                        {
                            currentUser.CurrentTrapCategory = Navigators.TrapNavigator.bottomCategory;
                        }
                        Waiter.DrawNavigatorCategory((CLRScriptBase)this, currentUser.CurrentTrapCategory);
                    }
                    break;
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_VFX_TAB:
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "CreatureActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "ItemActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "PlaceableActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "TrapActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "VfxActive", FALSE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "WaypointActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "LightActive", TRUE);
                    currentUser.openCommand = ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_VFX_TAB;
                    SetGUIObjectText(currentUser.Id, "SCREEN_DMC_CREATOR", "Column2", -1, " ");
                    SetGUIObjectText(currentUser.Id, "SCREEN_DMC_CREATOR", "Column3", -1, " ");
                    if (currentUser.CurrentVisualEffectCategory == Navigators.VisualEffectNavigator.bottomCategory)
                    {
                        Waiter.WaitForNavigator((CLRScriptBase)this, Navigators.VisualEffectNavigator);
                    }
                    else
                    {
                        if (currentUser.CurrentVisualEffectCategory == null)
                        {
                            currentUser.CurrentVisualEffectCategory = Navigators.VisualEffectNavigator.bottomCategory;
                        }
                        Waiter.DrawNavigatorCategory((CLRScriptBase)this, currentUser.CurrentVisualEffectCategory);
                    }
                    break;
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_WAYPOINT_TAB:
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "CreatureActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "ItemActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "PlaceableActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "TrapActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "VfxActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "WaypointActive", FALSE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "LightActive", TRUE);
                    currentUser.openCommand = ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_WAYPOINT_TAB;
                    SetGUIObjectText(currentUser.Id, "SCREEN_DMC_CREATOR", "Column2", -1, " ");
                    SetGUIObjectText(currentUser.Id, "SCREEN_DMC_CREATOR", "Column3", -1, " ");
                    if (currentUser.CurrentWaypointCategory == Navigators.WaypointNavigator.bottomCategory)
                    {
                        Waiter.WaitForNavigator((CLRScriptBase)this, Navigators.WaypointNavigator);
                    }
                    else
                    {
                        if (currentUser.CurrentWaypointCategory == null)
                        {
                            currentUser.CurrentWaypointCategory = Navigators.WaypointNavigator.bottomCategory;
                        }
                        Waiter.DrawNavigatorCategory((CLRScriptBase)this, currentUser.CurrentWaypointCategory);
                    }
                    break;
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_LIGHTS_TAB:
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "CreatureActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "ItemActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "PlaceableActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "TrapActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "VfxActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "WaypointActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_DMC_CREATOR", "LightActive", FALSE);
                    currentUser.openCommand = ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_LIGHTS_TAB;
                    SetGUIObjectText(currentUser.Id, "SCREEN_DMC_CREATOR", "Column2", -1, "Brt/Rd");
                    SetGUIObjectText(currentUser.Id, "SCREEN_DMC_CREATOR", "Column3", -1, "Shd");
                    if (currentUser.CurrentWaypointCategory == Navigators.LightNavigator.bottomCategory)
                    {
                        Waiter.WaitForNavigator((CLRScriptBase)this, Navigators.LightNavigator);
                    }
                    else
                    {
                        if (currentUser.CurrentLightCategory == null)
                        {
                            currentUser.CurrentLightCategory = Navigators.LightNavigator.bottomCategory;
                        }
                        Waiter.DrawNavigatorCategory((CLRScriptBase)this, currentUser.CurrentLightCategory);
                    }
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
                        if (searchTerm == "..") targetCat = currentCat.ParentCategory;
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
