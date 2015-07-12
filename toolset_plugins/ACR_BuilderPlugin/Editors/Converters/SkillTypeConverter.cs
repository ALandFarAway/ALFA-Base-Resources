using System;
using System.ComponentModel;
using System.Globalization;

using NWN2Toolset;
using NWN2Toolset.NWN2.Data;
using NWN2Toolset.NWN2.Rules;
using System.Windows.Forms;

namespace ACR_BuilderPlugin.Editors.Converters
{
    class SkillTypeConverter : StringConverter
    {
        public static string[] SkillList = null;

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
            if (SkillList == null)
            {
                ReloadSkillList();
            }
            return new StandardValuesCollection(SkillList);
        }

        public static void ReloadSkillList()
        {
            SkillList = new string[] { "Hi!" };
        }
    }
}
