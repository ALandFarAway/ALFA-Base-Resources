using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;



namespace ACR_Candlekeep
{
    public class Archives : ALFA.Shared.InformationStore
    {
        public Dictionary<string, ALFA.Shared.ItemResource> ModuleItems { get; set; }
    }
}
