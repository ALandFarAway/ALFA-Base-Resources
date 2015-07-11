using System;
using System.ComponentModel;
using System.Globalization;

namespace ACR_BuilderPlugin.Editors.Converters
{
    class SpawnTypeConverter : StringConverter
    {
        public static string[] SpawnTypes = { "Creatures", "Placeables", "Items", "Store", "Waypoint", "Triggers", "Encounters", "Lights", "Trap" };

        public override bool GetStandardValuesSupported(ITypeDescriptorContext context)
        {
            return true;
        }

        public override bool GetStandardValuesExclusive(ITypeDescriptorContext context)
        {
            return true;
        }

        public override StandardValuesCollection GetStandardValues(ITypeDescriptorContext context)
        {
            return new StandardValuesCollection(SpawnTypes);
        }
    }
}
