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
            int commandNumber = (int)ScriptParameters[0];
            ACR_CreatorCommand command = (ACR_CreatorCommand)commandNumber;
            if (command == ACR_CreatorCommand.ACR_CHOOSERCREATOR_INITIALIZE_LISTS)
            {
                if (OBJECT_SELF == GetModule())
                {
                    // We're caching the navigators on behalf of the module.
                    // TODO: Actually cache the lists.
                    return 0;
                }
                else
                {
                    if (Users.GetUser(OBJECT_SELF).openCommand == ACR_CreatorCommand.ACR_CHOOSERCREATOR_INITIALIZE_LISTS)
                        Users.GetUser(OBJECT_SELF).openCommand = ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_CREATURE_TAB;

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
                    Waiter.WaitForResources((CLRScriptBase)this, (ALFA.Shared.IBackgroundLoadedResource)currentUser.CurrentCreatureCategory);
                    break;
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_ITEM_TAB:
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "CreatureActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "ItemActive", FALSE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "PlaceableActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "TrapActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "VfxActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "WaypointActive", TRUE);
                    Waiter.WaitForResources((CLRScriptBase)this, (ALFA.Shared.IBackgroundLoadedResource)currentUser.CurrentItemCategory);
                    break;
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_PLACEABLE_TAB:
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "CreatureActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "ItemActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "PlaceableActive", FALSE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "TrapActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "VfxActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "WaypointActive", TRUE);
                    Waiter.WaitForResources((CLRScriptBase)this, (ALFA.Shared.IBackgroundLoadedResource)currentUser.CurrentPlaceableCategory);
                    break;
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_TRAP_TAB:
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "CreatureActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "ItemActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "PlaceableActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "TrapActive", FALSE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "VfxActive", TRUE);
                    SetGUIObjectHidden(currentUser.Id, "SCREEN_ACR_CREATOR", "WaypointActive", TRUE);
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
                    // TODO: Display current waypoint classification, or the base
                    // classification if none are selected.
                    break;
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_INCOMING_CLICK:
                    // TODO: make note of the selected row and provide
                    // additional information, if appropriate.
                    break;
                case ACR_CreatorCommand.ACR_CHOOSERCREATOR_INCOMING_DOUBLECLICK:
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

            ACR_CHOOSERCREATOR_INCOMING_CLICK = 20,
            ACR_CHOOSERCREATOR_INCOMING_DOUBLECLICK = 21,

            ACR_CHOOSERCREATOR_SEARCH_CREATURES = 31,
            ACR_CHOOSERCREATOR_SEARCH_ITEMS = 32,
            ACR_CHOOSERCREATOR_SEARCH_PLACEABLES = 33,
            ACR_CHOOSERCREATOR_SEARCH_TRAPS = 34,
            ACR_CHOOSERCREATOR_SEARCH_VFX = 35,
            ACR_CHOOSERCREATOR_SEARCH_WAYPOINT = 36
        }

    }
}
