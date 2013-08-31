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
    public class ChooserLists: CLRScriptBase
    {
        public static List<ALFA.Shared.ActiveArea> AreaList;

        public static void SortLists(CLRScriptBase script)
        {
            if(!ALFA.Shared.Modules.InfoStore.WaitForResourcesLoaded(false))
            {
                script.DelayCommand(6.0f, delegate { SortLists(script); });
                return;
            }
            if (ALFA.Shared.Modules.InfoStore.ActiveAreas == null)
            {
                script.DelayCommand(2.0f, delegate { SortLists(script); });
                return;
            }
            AreaList = ALFA.Shared.Modules.InfoStore.ActiveAreas.Values.ToList<ALFA.Shared.ActiveArea>();
            AreaList.Sort();
        }

        public static void InitializeButtons(CLRScriptBase script, User currentUser)
        {
            script.SetGUITexture(currentUser.Id, "SCREEN_DMC_CHOOSER", "SHOW_AOE", currentUser.ChooserShowAOE ? "trap.tga" : "notrap.tga");
            script.SetGUITexture(currentUser.Id, "SCREEN_DMC_CHOOSER", "SHOW_CREATURE", currentUser.ChooserShowCreature ? "creature.tga" : "nocreature.tga");
            script.SetGUITexture(currentUser.Id, "SCREEN_DMC_CHOOSER", "SHOW_DOOR", currentUser.ChooserShowDoor ? "door.tga" : "nodoor.tga");
            script.SetGUITexture(currentUser.Id, "SCREEN_DMC_CHOOSER", "SHOW_ITEM", currentUser.ChooserShowItem ? "item.tga" : "noitem.tga");
            script.SetGUITexture(currentUser.Id, "SCREEN_DMC_CHOOSER", "SHOW_LIGHT", currentUser.ChooserShowLight ? "light.tga" : "nolight.tga");
            script.SetGUITexture(currentUser.Id, "SCREEN_DMC_CHOOSER", "SHOW_PLACEABLE", currentUser.ChooserShowPlaceable ? "placeable.tga" : "noplaceable.tga");
            script.SetGUITexture(currentUser.Id, "SCREEN_DMC_CHOOSER", "SHOW_STORE", currentUser.ChooserShowStore ? "store.tga" : "nostore.tga");
            script.SetGUITexture(currentUser.Id, "SCREEN_DMC_CHOOSER", "SHOW_TRIGGER", currentUser.ChooserShowTrigger ? "trigger.tga" : "notrigger.tga");
            script.SetGUITexture(currentUser.Id, "SCREEN_DMC_CHOOSER", "SHOW_VFX", currentUser.ChooserShowPlacedEffect ? "vfx.tga" : "novfx.tga");
            script.SetGUITexture(currentUser.Id, "SCREEN_DMC_CHOOSER", "SHOW_WAYPOINT", currentUser.ChooserShowWaypoint ? "waypoint.tga" : "nowaypoint.tga");
        }

        public static void SearchAreas(CLRScriptBase script, User currentUser, string searchString)
        {
            script.ClearListBox(currentUser.Id, "SCREEN_DMC_CHOOSER", "LISTBOX_ACR_CHOOSER_AREAS");
            foreach (ALFA.Shared.ActiveArea area in AreaList)
            {
                if (area.LocalizedName.ToLower().Contains(searchString.ToLower()))
                {
                    script.AddListBoxRow(currentUser.Id, "SCREEN_DMC_CHOOSER", "LISTBOX_ACR_CHOOSER_AREAS", area.Id.ToString(), "LISTBOX_ITEM_TEXT=  " + area.DisplayName, "", "5=" + area.Id.ToString(), "");
                }
            }
        }

        public static void DrawAreas(CLRScriptBase script, User currentUser)
        {
            script.ClearListBox(currentUser.Id, "SCREEN_DMC_CHOOSER", "LISTBOX_ACR_CHOOSER_AREAS");
            if (ALFA.Shared.Modules.InfoStore.ActiveAreas.Keys.Contains(script.GetArea(currentUser.Id)))
            {
                ALFA.Shared.ActiveArea currentArea = ALFA.Shared.Modules.InfoStore.ActiveAreas[script.GetArea(currentUser.Id)];
                script.AddListBoxRow(currentUser.Id, "SCREEN_DMC_CHOOSER", "LISTBOX_ACR_CHOOSER_AREAS", currentArea.Id.ToString(), "LISTBOX_ITEM_TEXT=  <Color=DarkOrange>" + currentArea.DisplayName + "</color>", "", "5="+currentArea.Id.ToString(), "");
                List<ALFA.Shared.ActiveArea> adjAreas = new List<ALFA.Shared.ActiveArea>();
                foreach (ALFA.Shared.ActiveArea adjacentArea in currentArea.ExitTransitions.Values)
                {
                    if (!adjAreas.Contains(adjacentArea))
                    {
                        script.AddListBoxRow(currentUser.Id, "SCREEN_DMC_CHOOSER", "LISTBOX_ACR_CHOOSER_AREAS", adjacentArea.Id.ToString(), "LISTBOX_ITEM_TEXT=  <Color=DarkGoldenRod>" + adjacentArea.DisplayName + "</color>", "", "5=" + adjacentArea.Id.ToString(), "");
                        adjAreas.Add(adjacentArea);
                    }
                }
            }
            foreach (ALFA.Shared.ActiveArea area in AreaList)
            {
                script.AddListBoxRow(currentUser.Id, "SCREEN_DMC_CHOOSER", "LISTBOX_ACR_CHOOSER_AREAS", area.Id.ToString(), "LISTBOX_ITEM_TEXT=  " + area.DisplayName, "", "5=" + area.Id.ToString(), "");
            }
            currentUser.LastSeenArea = script.GetArea(currentUser.Id);
        }

        public static void DrawObjects(CLRScriptBase script, User currentUser, uint currentArea)
        {
            float fDelay = 0.1f;
            List<uint> ChooserAoEs = new List<uint>();
            List<uint> ChooserCreatures = new List<uint>();
            List<uint> ChooserDoors = new List<uint>();
            List<uint> ChooserItems = new List<uint>();
            List<uint> ChooserLights = new List<uint>();
            List<uint> ChooserPlaceables = new List<uint>();
            List<uint> ChooserPlacedEffects = new List<uint>();
            List<uint> ChooserStores = new List<uint>();
            List<uint> ChooserTriggers = new List<uint>();
            List<uint> ChooserWaypoints = new List<uint>();
            script.DelayCommand(fDelay, delegate
            {
                foreach (uint thing in script.GetObjectsInArea(currentArea))
                {
                    int objectType = script.GetObjectType(thing);
                    switch (objectType)
                    {
                        case OBJECT_TYPE_AREA_OF_EFFECT:
                            ChooserAoEs.Add(thing);
                            break;
                        case OBJECT_TYPE_CREATURE:
                            ChooserCreatures.Add(thing);
                            break;
                        case OBJECT_TYPE_DOOR:
                            ChooserDoors.Add(thing);
                            break;
                        case OBJECT_TYPE_ITEM:
                            ChooserItems.Add(thing);
                            break;
                        case OBJECT_TYPE_LIGHT:
                            ChooserLights.Add(thing);
                            break;
                        case OBJECT_TYPE_PLACEABLE:
                            ChooserPlaceables.Add(thing);
                            break;
                        case OBJECT_TYPE_PLACED_EFFECT:
                            ChooserPlacedEffects.Add(thing);
                            break;
                        case OBJECT_TYPE_STORE:
                            ChooserStores.Add(thing);
                            break;
                        case OBJECT_TYPE_TRIGGER:
                            ChooserTriggers.Add(thing);
                            break;
                        case OBJECT_TYPE_WAYPOINT:
                            ChooserWaypoints.Add(thing);
                            break;
                    }
                }
                script.ClearListBox(currentUser.Id, "SCREEN_DMC_CHOOSER", "LISTBOX_ACR_CHOOSER_OBJECTS");
                if (ChooserAoEs.Count > 0 && currentUser.ChooserShowAOE)
                {
                    fDelay += 0.1f;
                    script.DelayCommand(fDelay, delegate
                    {
                        foreach (uint thing in ChooserAoEs)
                        {
                            script.AddListBoxRow(currentUser.Id, "SCREEN_DMC_CHOOSER", "LISTBOX_ACR_CHOOSER_OBJECTS", thing.ToString(), "LISTBOX_ITEM_TEXT=  " + script.GetTag(thing), "LISTBOX_ITEM_ICON=trap.tga", "5="+thing.ToString(), "");
                        }
                    });
                }
                if (ChooserCreatures.Count > 0 && currentUser.ChooserShowCreature)
                {
                    fDelay += 0.1f;
                    script.DelayCommand(fDelay, delegate
                    {
                        foreach (uint thing in ChooserCreatures)
                        {
                            script.AddListBoxRow(currentUser.Id, "SCREEN_DMC_CHOOSER", "LISTBOX_ACR_CHOOSER_OBJECTS", thing.ToString(), "LISTBOX_ITEM_TEXT=  " + script.GetName(thing), "LISTBOX_ITEM_ICON=creature.tga", "5=" + thing.ToString(), "");
                        }
                    });
                }
                if (ChooserDoors.Count > 0 && currentUser.ChooserShowDoor)
                {
                    fDelay += 0.1f;
                    script.DelayCommand(fDelay, delegate
                    {
                        foreach (uint thing in ChooserDoors)
                        {
                            script.AddListBoxRow(currentUser.Id, "SCREEN_DMC_CHOOSER", "LISTBOX_ACR_CHOOSER_OBJECTS", thing.ToString(), "LISTBOX_ITEM_TEXT=  " + script.GetName(thing), "LISTBOX_ITEM_ICON=door.tga", "5=" + thing.ToString(), "");
                        }
                    });
                }
                if (ChooserItems.Count > 0 && currentUser.ChooserShowItem)
                {
                    fDelay += 0.1f;
                    script.DelayCommand(fDelay, delegate
                    {
                        foreach (uint thing in ChooserItems)
                        {
                            script.AddListBoxRow(currentUser.Id, "SCREEN_DMC_CHOOSER", "LISTBOX_ACR_CHOOSER_OBJECTS", thing.ToString(), "LISTBOX_ITEM_TEXT=  " + script.GetName(thing), "LISTBOX_ITEM_ICON=item.tga", "5=" + thing.ToString(), "");
                        }
                    });
                }
                if (ChooserLights.Count > 0 && currentUser.ChooserShowLight)
                {
                    fDelay += 0.1f;
                    script.DelayCommand(fDelay, delegate
                    {
                        foreach (uint thing in ChooserLights)
                        {
                            script.AddListBoxRow(currentUser.Id, "SCREEN_DMC_CHOOSER", "LISTBOX_ACR_CHOOSER_OBJECTS", thing.ToString(), "LISTBOX_ITEM_TEXT=  " + script.GetName(thing) + ";LISTBOX_ITEM_TEXT2= Light", "LISTBOX_ITEM_ICON=light.tga", "5=" + thing.ToString(), "");
                        }
                    });
                }
                if (ChooserPlaceables.Count > 0 && currentUser.ChooserShowPlaceable)
                {
                    fDelay += 0.1f;
                    script.DelayCommand(fDelay, delegate
                    {
                        foreach (uint thing in ChooserPlaceables)
                        {

                            script.AddListBoxRow(currentUser.Id, "SCREEN_DMC_CHOOSER", "LISTBOX_ACR_CHOOSER_OBJECTS", thing.ToString(), "LISTBOX_ITEM_TEXT=  " + script.GetName(thing) + ";LISTBOX_ITEM_TEXT2= Placeable", "LISTBOX_ITEM_ICON=placeable.tga", "5=" + thing.ToString(), "");
                        }
                    });
                }
                if (ChooserPlacedEffects.Count > 0 && currentUser.ChooserShowPlacedEffect)
                {
                    fDelay += 0.1f;
                    script.DelayCommand(fDelay, delegate
                    {
                        foreach (uint thing in ChooserPlacedEffects)
                        {
                            script.AddListBoxRow(currentUser.Id, "SCREEN_DMC_CHOOSER", "LISTBOX_ACR_CHOOSER_OBJECTS", thing.ToString(), "LISTBOX_ITEM_TEXT=  " + script.GetName(thing) + ";LISTBOX_ITEM_TEXT2= Placed Effect", "LISTBOX_ITEM_ICON=vfx.tga", "5=" + thing.ToString(), "");
                        }
                    });
                }
                if (ChooserStores.Count > 0 && currentUser.ChooserShowStore)
                {
                    fDelay += 0.1f;
                    script.DelayCommand(fDelay, delegate
                    {
                        foreach (uint thing in ChooserStores)
                        {
                            script.AddListBoxRow(currentUser.Id, "SCREEN_DMC_CHOOSER", "LISTBOX_ACR_CHOOSER_OBJECTS", thing.ToString(), "LISTBOX_ITEM_TEXT=  " + script.GetName(thing) + ";LISTBOX_ITEM_TEXT2= Store", "LISTBOX_ITEM_ICON=store.tga", "5=" + thing.ToString(), "");
                        }
                    });
                }
                if (ChooserTriggers.Count > 0 && currentUser.ChooserShowTrigger)
                {
                    fDelay += 0.1f;
                    script.DelayCommand(fDelay, delegate
                    {
                        foreach (uint thing in ChooserTriggers)
                        {
                            script.AddListBoxRow(currentUser.Id, "SCREEN_DMC_CHOOSER", "LISTBOX_ACR_CHOOSER_OBJECTS", thing.ToString(), "LISTBOX_ITEM_TEXT=  " + script.GetName(thing) + ";LISTBOX_ITEM_TEXT2= Trigger", "LISTBOX_ITEM_ICON=trigger.tga", "5=" + thing.ToString(), "");
                        }
                    });
                }
                if (ChooserWaypoints.Count > 0 && currentUser.ChooserShowWaypoint)
                {
                    fDelay += 0.1f;
                    script.DelayCommand(fDelay, delegate
                    {
                        foreach (uint thing in ChooserWaypoints)
                        {
                            script.AddListBoxRow(currentUser.Id, "SCREEN_DMC_CHOOSER", "LISTBOX_ACR_CHOOSER_OBJECTS", thing.ToString(), "LISTBOX_ITEM_TEXT=  " + script.GetName(thing) + ";LISTBOX_ITEM_TEXT2=  Waypoint", "LISTBOX_ITEM_ICON=waypoint.tga", "5=" + thing.ToString(), "");
                        }
                    });
                }
            });
        }

        public static void DrawLimbo(CLRScriptBase script, User currentUser)
        {
            script.ClearListBox(currentUser.Id, "SCREEN_DMC_CHOOSER", "LISTBOX_ACR_LIMBO_OBJECTS");
            int max = script.GetLimboCreatureCount();
            int count = 0;
            while (count < max)
            {
                uint thing = script.GetCreatureInLimbo(count);
                if (script.GetIsObjectValid(thing) == TRUE)
                {
                    script.AddListBoxRow(currentUser.Id, "SCREEN_DMC_CHOOSER", "LISTBOX_ACR_LIMBO_OBJECTS", thing.ToString(), "LISTBOX_ITEM_TEXT=  " + script.GetName(thing), "LISTBOX_ITEM_ICON=creature.tga", "5=" + thing.ToString(), "");
                }
                count++;
            }
        }
    }
}
