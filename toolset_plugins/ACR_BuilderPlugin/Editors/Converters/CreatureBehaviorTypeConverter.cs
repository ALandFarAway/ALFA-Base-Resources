using System.ComponentModel;

namespace ACR_BuilderPlugin.Editors.Converters
{
    class CreatureBehaviorTypeConverter : StringConverter
    {
        public string[] BehaviorTypes = { "BEHAVIOR_TYPE_ANIMAL", "BEHAVIOR_TYPE_ARCHER", "BEHAVIOR_TYPE_BUFFS", "BEHAVIOR_TYPE_CONTROL", "BEHAVIOR_TYPE_COWARD", "BEHAVIOR_TYPE_FLANK", "BEHAVIOR_TYPE_MEDIC", "BEHAVIOR_TYPE_MINDLESS", "BEHAVIOR_TYPE_NUKE", "BEHAVIOR_TYPE_SHOCK", "BEHAVIOR_TYPE_SKIRMISH", "BEHAVIOR_TYPE_TANK" };

        public override bool GetStandardValuesSupported(ITypeDescriptorContext context)
        {
            return true;
        }

        public override bool GetStandardValuesExclusive(ITypeDescriptorContext context)
        {
            return false;
        }

        public override StandardValuesCollection GetStandardValues(ITypeDescriptorContext context)
        {
            return new StandardValuesCollection(BehaviorTypes);
        }
    }
}
