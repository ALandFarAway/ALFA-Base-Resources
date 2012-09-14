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
    /// This class is used to expose methods and functionality to PowerShell
    /// scriptlets.  Note that methods on this object are called without there
    /// necessarily being a valid current script object on the
    /// ACR_CreatureBehavior object, so only local properties are generally
    /// accessible.
    /// </summary>
    public class PowerShellInterop
    {

        /// <summary>
        /// Create a new PowerShellInterop object.
        /// </summary>
        public PowerShellInterop()
        {
        }

        /// <summary>
        /// Get the party manager.
        /// </summary>
        public AIPartyManager PartyManager
        {
            get { return Server.PartyManager; }
        }

        /// <summary>
        /// Get the object manager.
        /// </summary>
        public GameObjectManager ObjectManager
        {
            get { return Server.ObjectManager; }
        }

        /// <summary>
        /// Get the module object for debugging purposes.
        /// </summary>
        public ModuleObject Module
        {
            get { return Server.ObjectManager.Module; }
        }

        /// <summary>
        /// Get the list of areas for debugging purposes.
        /// </summary>
        /// <summary>
        /// Get the list of all known areas.
        /// </summary>
        /// <returns>The known area list.</returns>
        public List<AreaObject> GetAreas()
        {
            return Module.Areas;
        }

        /// <summary>
        /// Get the list of creatures for debugging purposes.
        /// </summary>
        /// <returns>The creature list.</returns>
        public IEnumerable<CreatureObject> GetCreatures()
        {
            var Creatures = (from Obj in Server.ObjectManager.GetGameObjectsUnsafe()
                             where Obj.ObjectType == GameObjectType.Creature
                             select (CreatureObject)Obj);

            return Creatures;
        }

        /// <summary>
        /// Get an object for debugging purposes.
        /// </summary>
        /// <param name="ObjectId">Supplies the object id to translate.</param>
        /// <returns>The object is returned, else null if the object id was not
        /// known to have an already existing object state.</returns>
        public GameObject GetGameObject(uint ObjectId)
        {
            ObjectId &= 0x7FFFFFFF;

            return Server.ObjectManager.GetGameObjectUnsafe(ObjectId);
        }

    }
}
