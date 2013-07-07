using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using OEIShared.IO;
using OEIShared.IO.ERF;
using OEIShared.IO.GFF;
using OEIShared.Utils;

namespace ALFA.Shared
{
    /// <summary>
    /// This interface defines the contract between the information store
    /// module and other client modules.
    /// </summary>
    public interface IInformationStore : IBackgroundLoadedResource
    {
        Dictionary<string, ItemResource> ModuleItems { get; set; }
        Dictionary<string, CreatureResource> ModuleCreatures { get; set; }
        Dictionary<string, LightResource> ModuleLights { get; set; }
        Dictionary<string, PlaceableResource> ModulePlaceables { get; set; }
        Dictionary<string, WaypointResource> ModuleWaypoints { get; set; }
        Dictionary<string, VisualEffectResource> ModuleVisualEffects { get; set; }
        Dictionary<string, TrapResource> ModuleTraps { get; set; }
        Dictionary<int, Faction> ModuleFactions { get; set; }

        Dictionary<uint, ActiveArea> ActiveAreas { get; set; }

        Dictionary<string, ActiveTrap> SpawnedTrapTriggers { get; set; }
        Dictionary<string, ActiveTrap> SpawnedTrapDetect { get; set; }

        Dictionary<string, GFFFile> ModifiedGff { get; set; }

        Dictionary<int, Spell> CoreSpells { get; set; }

        Dictionary<int, SpellCastItemProperties> IPCastSpells { get; set; }
    }
}
