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
    class ChooserJump: CLRScriptBase
    {
        public static void JumpToArea(CLRScriptBase script, User currentUser)
        {
            uint currentArea = script.GetArea(currentUser.Id);
            if (!ALFA.Shared.Modules.InfoStore.ActiveAreas.Keys.Contains(currentUser.Id))
            {

            }

            // If this is an adjacent area, jump the DM to one of the ATs connecting the areas.
            foreach (ALFA.Shared.ActiveTransition exitTranstion in ALFA.Shared.Modules.InfoStore.ActiveAreas[currentArea].ExitTransitions.Keys)
            {
                if (exitTranstion.AreaTarget.Id == currentUser.FocusedArea)
                {
                    script.JumpToLocation(script.GetLocation(exitTranstion.Target));
                    return;
                }
            }

            // If these aren't adjacent areas, grab an AT if we can find one.
            if (ALFA.Shared.Modules.InfoStore.ActiveAreas[currentUser.FocusedArea].ExitTransitions.Count > 0)
            {
                foreach(ALFA.Shared.ActiveTransition enterTransition in ALFA.Shared.Modules.InfoStore.ActiveAreas[currentUser.FocusedArea].ExitTransitions.Keys)
                {
                    script.JumpToLocation(script.GetLocation(enterTransition.Id));
                    return;
                }
            }

            // If we can't find one, just try the middle of the area.
            float x = script.GetAreaSize(AREA_WIDTH, currentUser.FocusedArea) / 2;
            float y = script.GetAreaSize(AREA_HEIGHT, currentUser.FocusedArea) / 2;
            float z = 0.0f;
            NWLocation loc = script.Location(currentUser.FocusedArea, script.Vector(x, y, z), 0.0f);
            script.JumpToLocation(loc);
        }
    }
}
