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
    /// This class represents an area within the game.
    /// </summary>
    public class AreaObject : GameObject
    {

        /// <summary>
        /// Construct an area object and insert it into the object table.
        /// </summary>
        /// <param name="ObjectId"></param>
        public AreaObject(uint ObjectId) : base(ObjectId, GameObjectType.Area)
        {
            //
            // Cache state that doesn't change over the lifetime of the object
            // so as to avoid a need to call down into the engine for these
            // fields.
            //

            AreaInterior = Script.GetIsAreaInterior(ObjectId) != CLRScriptBase.FALSE ? true : false;
            AreaNatural = Script.GetIsAreaNatural(ObjectId) != CLRScriptBase.FALSE ? true : false;
            AreaUnderground = Script.GetIsAreaAboveGround(ObjectId) != CLRScriptBase.FALSE ? false : true;
        }

        /// <summary>
        /// Return an enumeration context for this area.  Since we don't create
        /// a C# representation for all objects in the area up front, we don't
        /// refer to those objects by their C# object state unless we really
        /// need to.  Instead, we use the raw object id.
        /// </summary>
        /// <returns>The enumerator for this area.</returns>
        public CLRScriptBase.AreaObjectEnumeratorHelper GetObjectIdsInArea()
        {
            return Script.GetObjectsInArea(ObjectId);
        }

        /// <summary>
        /// Get the interior flag of the area.
        /// </summary>
        public bool IsInterior { get { return AreaInterior; } }
        /// <summary>
        /// Get the natural flag of the area.
        /// </summary>
        public bool IsNatural { get {return AreaNatural; } }
        /// <summary>
        /// Get the underground flag of the area.
        /// </summary>
        public bool IsUnderground { get { return AreaUnderground; } }


        /// <summary>
        /// The area interior flag.
        /// </summary>
        private bool AreaInterior;
        /// <summary>
        /// The area natural flag.
        /// </summary>
        private bool AreaNatural;
        /// <summary>
        /// The area underground flag.
        /// </summary>
        private bool AreaUnderground;
    }
}
