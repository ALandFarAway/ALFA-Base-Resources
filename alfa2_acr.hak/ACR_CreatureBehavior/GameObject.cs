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
        /// Construct a game object and insert it into an object table.
        /// </summary>
        /// <param name="ObjectId">The engine object id.</param>
        /// <param name="ObjectType">The object type code.</param>
        /// <param name="ObjectManager">The object manager to attach the object
        /// to.</param>
        public GameObject(uint ObjectId, GameObjectType ObjectType, GameObjectManager ObjectManager)
        {
            this.GameObjectId = ObjectId;
            this.GameObjectTypeCode = ObjectType;
            this.ObjectManager = ObjectManager;

            ObjectManager.AddGameObject(this);
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

                return ObjectManager.GetAreaObject(Script.GetArea((ObjectId)));
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

                ObjectManager.RemoveGameObject(this);

                return false;
            }
        }

        /// <summary>
        /// Get or set the rundown flag on the object, indicating that the
        /// object is awaiting deletion.
        /// </summary>
        public bool IsRundown { get { return Rundown; } set { Rundown = value; } }

        /// <summary>
        /// The currently executing ACR_CreatureBehavior script instance.
        /// </summary>
        public ACR_CreatureBehavior Script
        {
            get { return ObjectManager.Script; }
        }

        /// <summary>
        /// Get the overarching module object.
        /// </summary>
        public ModuleObject Module
        {
            get { return ObjectManager.Module; }
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
        /// Return a string representation of the object.
        /// </summary>
        /// <returns>Returns the string representation of the object.</returns>
        public override string ToString()
        {
            return String.Format(
                "{0} 0x{1} ({2})", ObjectType, ObjectId.ToString("X"), Name);
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
        /// The invalid object id.
        /// </summary>
        public static uint OBJECT_INVALID = CLRScriptBase.OBJECT_INVALID;



        /// <summary>
        /// The game object id for the object.
        /// </summary>
        private uint GameObjectId;

        /// <summary>
        /// The game object type for the object.
        /// </summary>
        private GameObjectType GameObjectTypeCode;

        /// <summary>
        /// The associated object manager that the object is attached to.
        /// </summary>
        public GameObjectManager ObjectManager;

        /// <summary>
        /// True if we have entered rundown, i.e. we're on the object to delete
        /// list.
        /// </summary>
        private bool Rundown = false;


    }
}
