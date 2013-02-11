using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ALFA.Shared
{
    /// <summary>
    /// This interface defines the contract between the information store
    /// module and other client modules.
    /// </summary>
    public interface InformationStore
    {
        Dictionary<string, ItemResource> ModuleItems { get; set; }
    }
}
