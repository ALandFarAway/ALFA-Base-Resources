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
            ALFA.Shared.Modules.InfoStore.ActiveAreas = new Dictionary<uint, ALFA.Shared.ActiveArea>();
            foreach (uint area in s.GetAreas())
            {
                ALFA.Shared.ActiveArea activeArea = new ALFA.Shared.ActiveArea();
                activeArea.Id = area;
                activeArea.Name = s.GetName(area).Trim();
                activeArea.Tag = s.GetTag(area);
                ALFA.Shared.Modules.InfoStore.ActiveAreas.Add(area, activeArea);
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
