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
    /// This class represents all state attached to the game server instance.
    /// It encapsulates the object manager and other tables that refer back to
    /// the game engine's representation of various objects.
    /// </summary>
    public static class Server
    {

        /// <summary>
        /// Initialize the server subsystem, from a context where it is safe to
        /// make calls to engine APIs.
        /// </summary>
        public static void Initialize()
        {
            ObjectManager = new GameObjectManager();
            PartyManager = new AIPartyManager();
        }

        /// <summary>
        /// The underlying game object manager.
        /// 
        /// N.B.  The object must be constructed in Initialize and not at
        ///       assembly load time, as calls to engine APIs will be made.
        /// </summary>
        public static GameObjectManager ObjectManager = null;

        /// <summary>
        /// The underlying AI party manager.
        /// </summary>
        public static AIPartyManager PartyManager = null;
    }
}
