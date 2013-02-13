using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;



namespace ACR_Candlekeep
{
    public class Archives : ALFA.Shared.InformationStore
    {
        public Dictionary<string, ALFA.Shared.ItemResource> ModuleItems { get; set; }
        public Dictionary<string, ALFA.Shared.CreatureResource> ModuleCreatures { get; set; }
        public Dictionary<string, ALFA.Shared.PlaceableResource> ModulePlaceables { get; set; }
        public Dictionary<int, ALFA.Shared.Faction> ModuleFactions { get; set; }
    }
}
