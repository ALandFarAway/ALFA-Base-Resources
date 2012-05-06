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
    /// This class represents a trigger within the game.
    /// </summary>
    public class TriggerObject : GameObject, TransitionSource
    {

        /// <summary>
        /// Construct a trigger object and insert it into the object table.
        /// </summary>
        /// <param name="ObjectId">Supplies the creature object id.</param>
        /// <param name="ObjectManager">Supplies the object manager.</param>
        public TriggerObject(uint ObjectId, GameObjectManager ObjectManager)
            : base(ObjectId, GameObjectType.Trigger, ObjectManager)
        {
        }

        /// <summary>
        /// Get the transition target of the trigger, if one existed.
        /// </summary>
        public virtual uint TransitionTarget { get { return Script.GetTransitionTarget(ObjectId); } }

    }
}
