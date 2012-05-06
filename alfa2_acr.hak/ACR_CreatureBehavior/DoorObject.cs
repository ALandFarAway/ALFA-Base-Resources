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
    /// This class represents a door within the game.
    /// </summary>
    public class DoorObject : GameObject, TransitionSource
    {

        /// <summary>
        /// Construct a creature object and insert it into the object table.
        /// </summary>
        /// <param name="ObjectId">Supplies the creature object id.</param>
        /// <param name="ObjectManager">Supplies the object manager.</param>
        public DoorObject(uint ObjectId, GameObjectManager ObjectManager)
            : base(ObjectId, GameObjectType.Door, ObjectManager)
        {
        }

        /// <summary>
        /// Get the transition target of the door, if one existed.
        /// </summary>
        public virtual uint TransitionTarget { get { return Script.GetTransitionTarget(ObjectId); } }

    }
}
