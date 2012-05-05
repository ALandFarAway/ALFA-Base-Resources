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

namespace ACR_CreatureBehavior
{
    /// <summary>
    /// This class manages creation and removal (and tracking) of all AI
    /// controlled parties in the system.
    /// </summary>
    public class AIPartyManager
    {
        /// <summary>
        /// Construct an empty party manager.
        /// </summary>
        public AIPartyManager()
        {
        }

        /// <summary>
        /// The list of all AI parties active system-wide.
        /// </summary>
        public List<AIParty> Parties = null;
    }
}
