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

namespace ACR_Candlekeep
{
    public class Monks : CLRScriptBase
    {
        public static void LoadAreas(CLRScriptBase s)
        {
            if (!ACR_Candlekeep.ArchivesInstance.WaitForResourcesLoaded(false))
            {
                s.DelayCommand(6.0f, delegate { LoadAreas(s); });
                return;
            }
            ALFA.Shared.Modules.InfoStore.ActiveAreas = new Dictionary<uint, ALFA.Shared.ActiveArea>();
            List<uint> areas = new List<uint>();
            foreach (uint area in s.GetAreas())
            {
                ALFA.Shared.ActiveArea activeArea = new ALFA.Shared.ActiveArea();
                activeArea.Id = area;
                activeArea.Name = s.GetName(area).Trim();
                activeArea.Tag = s.GetTag(area);
                ALFA.Shared.Modules.InfoStore.ActiveAreas.Add(area, activeArea);
                areas.Add(area);
            }
            int count = 0;
            foreach(KeyValuePair<string, string> keyValue in ALFA.Shared.Modules.InfoStore.AreaNames)
            {
                ALFA.Shared.Modules.InfoStore.ActiveAreas[areas[count]].LocalizedName = keyValue.Value;
                ALFA.Shared.Modules.InfoStore.ActiveAreas[areas[count]].ConfigureDisplayName();
                s.SetLocalString(areas[count], "ACR_AREA_RESREF", keyValue.Key);
                count++;
            }
            foreach (ALFA.Shared.ActiveArea activeArea in ALFA.Shared.Modules.InfoStore.ActiveAreas.Values)
            {
                foreach (uint thing in s.GetObjectsInArea(activeArea.Id))
                {
                    uint target = s.GetTransitionTarget(thing);
                    if (s.GetIsObjectValid(target) != FALSE)
                    {
                        ALFA.Shared.ActiveTransition activeTransition = new ALFA.Shared.ActiveTransition();
                        activeTransition.AreaTarget = ALFA.Shared.Modules.InfoStore.ActiveAreas[s.GetArea(target)];
                        activeTransition.Id = thing;
                        activeTransition.Target = target;
                        activeArea.ExitTransitions.Add(activeTransition, activeTransition.AreaTarget);
                    }
                }
            }
        }
    }
}
