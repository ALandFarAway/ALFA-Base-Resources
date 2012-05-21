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
    /// This class maintains state that links C# object state to undelrying
    /// engine game object representations.
    /// </summary>
    public class GameObjectManager
    {

        /// <summary>
        /// Construct a new GameObjectManager, and the underlying module object
        /// and the area list.
        /// </summary>
        public GameObjectManager()
        {
            Initialize();
        }

        /// <summary>
        /// Look up the internal GameObject for an object by object id and
        /// return the C# object state for it.
        /// 
        /// The routine does not create the object state for an object id
        /// that is valid but unrecognized to us (i.e. that we have not yet
        /// seen even though it exists engine-side).
        /// </summary>
        /// <param name="ObjectId">Supplies the object id to look up.</param>
        /// <returns>The corresponding C# object state, else null.</returns>
        public GameObject GetGameObject(uint ObjectId)
        {
            GameObject GameObj;

            if (ObjectId == CLRScriptBase.OBJECT_INVALID)
                return null;

            if (!GameObjectTable.TryGetValue(ObjectId, out GameObj))
                return null;

            //
            // Even though we have a record of the object in our lookup table,
            // the engine may have already removed its representation of the
            // object.  In that case, pretend that the object state doesn't
            // exist for purposes of by-object-id lookups.
            //

            if (!GameObj.Exists)
                return null;

            return GameObj;
        }

        /// <summary>
        /// Look up the internal GameObject for an object by object id and
        /// return the C# object state for it, if the object type matched the
        /// expected type.
        /// 
        /// The routine does not create the object state for an object id
        /// that is valid but unrecognized to us (i.e. that we have not yet
        /// seen even though it exists engine-side).
        /// </summary>
        /// <param name="ObjectId">Supplies the object id to look up.</param>
        /// <param name="ObjectType">Supplies the required object type.</param>
        /// <returns>The corresponding C# object state, else null.</returns>
        public GameObject GetGameObject(uint ObjectId, GameObjectType ObjectType)
        {
            GameObject GameObj = GetGameObject(ObjectId);

            if (GameObj == null || GameObj.ObjectType != ObjectType)
                return null;
            else
                return GameObj;
        }

        /// <summary>
        /// Get the C# area object for the given object id.
        /// </summary>
        /// <param name="ObjectId">Supplies the object id to look up.</param>
        /// <returns>The corresponding C# Area object, else null.</returns>
        public AreaObject GetAreaObject(uint ObjectId)
        {
            return (AreaObject)GetGameObject(ObjectId, GameObjectType.Area);
        }

        /// <summary>
        /// Get the C# creature object for the given object id.
        /// </summary>
        /// <param name="ObjectId">Supplies the object id to look up.</param>
        /// <param name="CreateIfNeeded">If true, the C# Creature object for
        /// the creature is created if the object didn't already exist.</param>
        /// <returns>The corresponding C# Creature object, else null.</returns>
        public CreatureObject GetCreatureObject(uint ObjectId, bool CreateIfNeeded = false)
        {
            CreatureObject Creature = (CreatureObject)GetGameObject(ObjectId, GameObjectType.Creature);

            if (Creature != null)
                return Creature;
            else if (CreateIfNeeded && Script.GetObjectType(ObjectId) == CLRScriptBase.OBJECT_TYPE_CREATURE)
                return new CreatureObject(ObjectId, this);
            else
                return null;
        }



        /// <summary>
        /// The currently executing ACR_CreatureBehavior script instance.
        /// </summary>
        public ACR_CreatureBehavior Script
        {
            get { return ACR_CreatureBehavior.CurrentScript; }
        }

        /// <summary>
        /// Get the overarching module object.
        /// </summary>
        public ModuleObject Module
        {
            get { return ModuleObj; }
        }

        /// <summary>
        /// Get the list of all known areas.
        /// </summary>
        /// <returns>The known area list.</returns>
        public List<AreaObject> GetAreas()
        {
            return Module.Areas;
        }



        /// <summary>
        /// Insert an object into the game object table.
        /// </summary>
        /// <param name="Obj">Supplies the object to insert.</param>
        public void AddGameObject(GameObject Obj)
        {
            GameObjectTable.Add(Obj.ObjectId, Obj);
        }

        /// <summary>
        /// Remove an object from the game object table.
        /// </summary>
        /// <param name="Obj">Supplies the object to remove.</param>
        public void RemoveGameObject(GameObject Obj)
        {
            GameObjectTable.Remove(Obj.ObjectId);
            ObjectsToDelete.Add(Obj);
        }



        /// <summary>
        /// Called during initial script object initialization to set up the
        /// periodic garbage collection of objects to delete from the
        /// object dictionary.
        /// </summary>
        private void Initialize()
        {
            //
            // Create the module (and discover associated areas).
            //

            ModuleObj = new ModuleObject(Script.GetModule(), this);

            //
            // Schedule garbage collection for C# objects whose engine
            // representation no longer exists.
            //

            GarbageCollectObjects();
        }

        /// <summary>
        /// Called before we return to the engine, after all work has been
        /// finished.  This function runs down objects marked for pending
        /// deletion (ensuring timely handling in cases where the deleted half
        /// of the object was explicitly detected).
        /// </summary>
        public void ProcessPendingDeletions()
        {
            if (ObjectsToDelete.Count == 0)
                return;

            foreach (GameObject ObjectToRundown in ObjectsToDelete)
            {
                try
                {
                    ObjectToRundown.OnRundown();
                }
                catch (Exception e)
                {
                    Script.WriteTimestampedLogEntry(String.Format(
                        "GameObject.ProcessPendingDeletions(): Exception {0} running rundown for object {1} of type {2}.", e, ObjectToRundown.ObjectId, ObjectToRundown.ObjectType));
                }
            }

            //
            // Now that we have ran through the object to delete list, clear it
            // out (the last reference that the underlying object system has to
            // these object ids).
            //

            ObjectsToDelete.Clear();
        }

        /// <summary>
        /// Periodically run as a DelayCommand continuation in order to scan
        /// the object table for objects whose engine parts have been deleted.
        /// 
        /// Any such objects found are removed.
        /// 
        /// It is necessary to periodically poll for deleted objects because
        /// not all object types provide script events that signify deletion.
        /// </summary>
        private void GarbageCollectObjects()
        {
            //
            // Scan the object table looking for objects that have had their
            // engine side counterpart deleted.  Add these to the object to
            // delete list, but don't mark them as in rundown.  This allows us
            // to differentiate between which objects were still in the
            // dictionary during the subsequent rundown loop (so that we can
            // remove them then, as we can't modify the dictionary during the
            // enumeration).
            //

            foreach (var Entry in GameObjectTable)
            {
                if (Script.GetIsObjectValid(Entry.Key) != CLRScriptBase.FALSE)
                    continue;

                ObjectsToDelete.Add(Entry.Value);
            }

            //
            // For every object that is scheduled for rundown, call the
            // OnRundown notification and remove the object from the deletion
            // list.  If the object was one we moved above, remove it from the
            // lookup table too (otherwise it was already removed from the
            // lookup table ahead of time).
            //

            foreach (GameObject ObjectToRundown in ObjectsToDelete)
            {
                if (ObjectToRundown.IsRundown == false)
                    GameObjectTable.Remove(ObjectToRundown.ObjectId);

                try
                {
                    ObjectToRundown.OnRundown();
                }
                catch (Exception e)
                {
                    Script.WriteTimestampedLogEntry(String.Format(
                        "GameObject.GarbageCollectObjects(): Exception {0} running rundown for object {1} of type {2}.", e, ObjectToRundown.ObjectId, ObjectToRundown.ObjectType));
                }
            }

            //
            // Now that we have ran through the object to delete list, clear it
            // out (the last reference that the underlying object system has to
            // these object ids).
            //

            ObjectsToDelete.Clear();

            //
            // Schedule the next garbage collection.
            //

            Script.DelayCommand(60.0f, delegate() { GarbageCollectObjects(); });
        }

        /// <summary>
        /// The module object.
        /// </summary>
        private ModuleObject ModuleObj = null;

        /// <summary>
        /// The table of game objects in the game, mapped to C# object classes.
        /// </summary>
        private Dictionary<uint, GameObject> GameObjectTable = new Dictionary<uint, GameObject>();

        /// <summary>
        /// The list of objects awaiting rundown.
        /// </summary>
        private List<GameObject> ObjectsToDelete = new List<GameObject>();
    }
}
