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
    /// This class represents the module.
    /// </summary>
    public class ModuleObject : GameObject
    {
        /// <summary>
        /// Construct a module object and insert it into the object table.
        /// </summary>
        public ModuleObject(uint ObjectId) : base(ObjectId, GameObjectType.Module)
        {
            //
            // Discover pre-created areas in the module.  Instanced areas will
            // be discovered when they are created.
            //

            foreach (uint AreaObjectId in Script.GetAreas())
            {
                AreaObject Area = new AreaObject(AreaObjectId);
            }
        }

        /// <summary>
        /// Add an instanced area object to the area object list.
        /// </summary>
        /// <param name="AreaObjectId">Supplies the area object id.</param>
        /// <returns>The C# area object.</returns>
        public AreaObject AddInstancedArea(uint AreaObjectId)
        {
            AreaObject Area = new AreaObject(AreaObjectId);

            return Area;
        }

        /// <summary>
        /// The list of areas present in the module.
        /// </summary>
        public List<AreaObject> Areas = new List<AreaObject>();
    }
}
