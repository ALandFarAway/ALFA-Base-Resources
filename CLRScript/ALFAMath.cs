//
// This module contains various mathematical algorithms for use by script code.
//

using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using System.IO;
using CLRScriptFramework;
using NWScript;
using NWScript.ManagedInterfaceLayer.NWScriptManagedInterface;

using NWEffect = NWScript.NWScriptEngineStructure0;
using NWEvent = NWScript.NWScriptEngineStructure1;
using NWLocation = NWScript.NWScriptEngineStructure2;
using NWTalent = NWScript.NWScriptEngineStructure3;
using NWItemProperty = NWScript.NWScriptEngineStructure4;

namespace ALFA
{

    /// <summary>
	 /// This class contains various mathematical algorithms for use by script
	 /// code.
    /// </summary>
    public static class MathOps
    {

        /// <summary>
        /// Return the squared distance between two points.
        /// </summary>
        /// <param name="v1">The first point.</param>
        /// <param name="v2">The second point.</param>
        /// <returns>The squared distance between the points is returned.
        /// </returns>
        public static float DistanceSq(Vector3 v1, Vector3 v2)
        {
            double d;

            d = (v2.x - v1.x) * (v2.x - v1.x) +
                (v2.y - v1.y) * (v2.y - v1.y) +
                (v2.z - v1.z) * (v2.z - v1.z);

            return (float)d;
        }

    }
}

