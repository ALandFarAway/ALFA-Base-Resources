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
    /// This enum type describes the type of a game object.
    /// </summary>
    public enum GameObjectType
    {
        Module,
        Area,
        Creature,
        Item,
        Trigger,
        Door,
        AreaOfEffect,
        Waypoint,
        Placeable,
        Store,
        Encounter,
        Light,
        PlacedEffect
    }

    /// <summary>
    /// This class wraps an in-game object with support for obtaining and
    /// storing extended state about the object.  More specific object types
    /// derive from this type.
    /// </summary>
    public class GameObject
    {

        /// <summary>
        /// Construct a game object and insert it into the object table.
        /// </summary>
        /// <param name="ObjectId">The engine object id.</param>
        /// <param name="ObjectType">The object type code.</param>
        public GameObject(uint ObjectId, GameObjectType ObjectType)
        {
            this.GameObjectId = ObjectId;
            this.GameObjectTypeCode = ObjectType;

            GameObjectTable.Add(ObjectId, this);
        }

        /// <summary>
        /// The game object id for the object.
        /// </summary>
        public uint ObjectId
        {
            get { return GameObjectId; }
        }

        /// <summary>
        /// The game object type for the object.
        /// </summary>
        public GameObjectType ObjectType
        {
            get { return GameObjectTypeCode; }
        }

        /// <summary>
        /// The joined area of the object.
        /// </summary>
        public AreaObject Area
        {
            get
            {
                //
                // Area and module objects aren't associated with an area.
                //

                switch (ObjectType)
                {
                    case GameObjectType.Area:
                    case GameObjectType.Module:
                        return null;

                }

                return GetAreaObject(Script.GetArea((ObjectId)));
            }
        }

        /// <summary>
        /// Get the full name of the object.
        /// </summary>
        public string Name { get { return Script.GetName(ObjectId); } }

        /// <summary>
        /// Get the first name of the object.
        /// </summary>
        public string FirstName { get { return Script.GetFirstName(ObjectId); } }

        /// <summary>
        /// Get the last name of the object.
        /// </summary>
        public string LastName { get { return Script.GetLastName(ObjectId); } }

        /// <summary>
        /// Returns true if the object actually exists as far as the engine is
        /// concerned.  An object might be removed from the engine while we
        /// still have our local state, in which case case Exists will be
        /// false.
        /// 
        /// If the object is discovered to not exist for the first time, then
        /// it is scheduled for deletion.
        /// </summary>
        public bool Exists
        {
            get
            {
                //
                // Objects already scheduled for removal aren't considered as
                // existing.
                //

                if (Rundown)
                    return false;

                //
                // If the game engine side of the object is still live, then
                // the object exists.  Otherwse, schedule the C# object state
                // for deletion.
                //

                if (Script.GetIsObjectValid(ObjectId) != CLRScriptBase.FALSE)
                    return true;

                GameObjectTable.Remove(ObjectId);
                ObjectsToDelete.Add(this);

                return false;
            }
        }

        /// <summary>
        /// The currently executing ACR_CreatureBehavior script instance.
        /// </summary>
        public static ACR_CreatureBehavior Script
        {
            get { return ACR_CreatureBehavior.CurrentScript; }
        }

        /// <summary>
        /// Get the overarching module object.
        /// </summary>
        public static ModuleObject Module
        {
            get { return ModuleObj; }
        }

        /// <summary>
        /// Get the list of all known areas.
        /// </summary>
        /// <returns>The known area list.</returns>
        public static List<AreaObject> GetAreas()
        {
            return Module.Areas;
        }

        /// <summary>
        /// Called when the C# object state is being run down because the game
        /// engine half of the object has been deleted.  This might occur after
        /// the fact.
        /// </summary>
        public virtual void OnRundown()
        {
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
        public static GameObject GetGameObject(uint ObjectId)
        {
            GameObject GameObj;

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
        public static GameObject GetGameObject(uint ObjectId, GameObjectType ObjectType)
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
        /// <returns>The corresonding C# Area object, else null.</returns>
        public static AreaObject GetAreaObject(uint ObjectId)
        {
            return (AreaObject)GetGameObject(ObjectId, GameObjectType.Area);
        }

        /// <summary>
        /// Get the C# creature object for the given object id.
        /// </summary>
        /// <param name="ObjectId">Supplies the object id to look up.</param>
        /// <returns>The corresonding C# Creature object, else null.</returns>
        public static CreatureObject GetCreatureObject(uint ObjectId)
        {
            return (CreatureObject)GetGameObject(ObjectId, GameObjectType.Creature);
        }

        /// <summary>
        /// Called during initial script object initialization to set up the
        /// periodic garbage collection of objects to delete from the
        /// object dictionary.
        /// </summary>
        public static void Initialize()
        {
            //
            // Create the module (and discover associated areas).
            //

            ModuleObj = new ModuleObject(Script.GetModule());

            //
            // Schedule garbage collection for C# objects whose engine
            // representation no longer exists.
            //

            GarbageCollectObjects();
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
        private static void GarbageCollectObjects()
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
                if (ObjectToRundown.Rundown == false)
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
        /// The game object id for the object.
        /// </summary>
        private uint GameObjectId;

        /// <summary>
        /// The game object type for the object.
        /// </summary>
        private GameObjectType GameObjectTypeCode;

        /// <summary>
        /// True if we have entered rundown, i.e. we're on the object to delete
        /// list.
        /// </summary>
        private bool Rundown = false;


        /// <summary>
        /// The module object.
        /// </summary>
        private static ModuleObject ModuleObj = null;

        /// <summary>
        /// The table of game objects in the game, mapped to C# object classes.
        /// </summary>
        private static Dictionary<uint, GameObject> GameObjectTable = new Dictionary<uint, GameObject>();

        /// <summary>
        /// The list of objects awaiting rundown.
        /// </summary>
        private static List<GameObject> ObjectsToDelete = new List<GameObject>();
    }
}
