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
    /// This interface encapsulates properties relating to an object that is a
    /// transition source, i.e. which has a linked transition target.
    /// </summary>
    interface TransitionSource
    {

        /// <summary>
        /// The object associated with the transition (e.g. waypoint or door
        /// that the transition user should be transferred to).
        /// </summary>
        uint TransitionTarget { get; }
    }
}
