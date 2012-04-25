using System;
using System.Collections.Generic;
using System.Text;

namespace ABM_creator
{
    class ALFAItemProperty
    {
        ALFAGFFStruct agffs;

        public ALFAItemProperty(ushort propertyName, byte param1, byte param1value, byte param2, byte param2value, ushort subtype, byte costTable, ushort costValue, byte chanceAppear)
        {
            agffs = new ALFAGFFStruct();
            agffs.SetWord("PropertyName", propertyName);
            agffs.SetByte("Param1", param1);
            agffs.SetByte("Param1Value", param1value);
            agffs.SetByte("Param2", param2);
            agffs.SetByte("Param2Value", param2value);
            agffs.SetWord("Subtype", subtype);
            agffs.SetByte("CostTable", costTable);
            agffs.SetWord("CostValue", costValue);
            agffs.SetByte("ChanceAppear", chanceAppear);
        }

        public ALFAGFFStruct Struct
        {
            get
            {
                return agffs;
            }
        }

        public static NWN2Toolset.NWN2.Data.Templates.NWN2ItemPropertyInfo ClassRestrictionItemProperty(int classId)
        {
            NWN2Toolset.NWN2.Data.Templates.NWN2ItemPropertyInfo ip = new NWN2Toolset.NWN2.Data.Templates.NWN2ItemPropertyInfo();
            ip.PropertyName = new OEIShared.IO.TwoDA.TwoDAReference("itempropdef", "Name", true, 63);
            ip.Subtype = new OEIShared.IO.TwoDA.TwoDAReference("classes", "Name", true, classId);
            return ip;
        }

        public static NWN2Toolset.NWN2.Data.Templates.NWN2ItemPropertyInfo WizardOnlyItemProperty() { return ClassRestrictionItemProperty(10); }

        public static NWN2Toolset.NWN2.Data.Templates.NWN2ItemPropertyInfo SorcererOnlyItemProperty() { return ClassRestrictionItemProperty(9); }

        public static NWN2Toolset.NWN2.Data.Templates.NWN2ItemPropertyInfo DruidOnlyItemProperty() { return ClassRestrictionItemProperty(3); }

        public static NWN2Toolset.NWN2.Data.Templates.NWN2ItemPropertyInfo ClericOnlyItemProperty() { return ClassRestrictionItemProperty(2); }

        public static NWN2Toolset.NWN2.Data.Templates.NWN2ItemPropertyInfo PaladinOnlyItemProperty() { return ClassRestrictionItemProperty(6); }

        public static NWN2Toolset.NWN2.Data.Templates.NWN2ItemPropertyInfo RangerOnlyItemProperty() { return ClassRestrictionItemProperty(7); }

        public static NWN2Toolset.NWN2.Data.Templates.NWN2ItemPropertyInfo BardOnlyItemProperty() { return ClassRestrictionItemProperty(1); }

        public static NWN2Toolset.NWN2.Data.Templates.NWN2ItemPropertyInfo FavoredSoulOnlyItemProperty() { return ClassRestrictionItemProperty(58); }

        public static NWN2Toolset.NWN2.Data.Templates.NWN2ItemPropertyInfo SpiritShamanOnlyItemProperty() { return ClassRestrictionItemProperty(55); }

        public static NWN2Toolset.NWN2.Data.Templates.NWN2ItemPropertyInfo CastSpellOnceItemProperty(ushort iprp_spellsIndex)
        {
            NWN2Toolset.NWN2.Data.Templates.NWN2ItemPropertyInfo ip = new NWN2Toolset.NWN2.Data.Templates.NWN2ItemPropertyInfo();
            ip.CostTable = new OEIShared.IO.TwoDA.TwoDAReference("iprp_costtable", "Name", false, 3);
            ip.CostValue = new OEIShared.IO.TwoDA.TwoDAReference("iprp_chargecost", "Name", false, 1);
            ip.Subtype = new OEIShared.IO.TwoDA.TwoDAReference("iprp_spells", "SpellIndex", false, iprp_spellsIndex);
            ip.PropertyName = new OEIShared.IO.TwoDA.TwoDAReference("itempropdef", "Name", true, 15);
            return ip;
        }

        public static NWN2Toolset.NWN2.Data.Templates.NWN2ItemPropertyInfo CastSpell1ChargeItemProperty(ushort iprp_spellsIndex)
        {
            NWN2Toolset.NWN2.Data.Templates.NWN2ItemPropertyInfo ip = new NWN2Toolset.NWN2.Data.Templates.NWN2ItemPropertyInfo();
            ip.CostTable = new OEIShared.IO.TwoDA.TwoDAReference("iprp_costtable", "Name", false, 3);
            ip.CostValue = new OEIShared.IO.TwoDA.TwoDAReference("iprp_chargecost", "Name", false, 6);
            ip.Subtype = new OEIShared.IO.TwoDA.TwoDAReference("iprp_spells", "SpellIndex", false, iprp_spellsIndex);
            ip.PropertyName = new OEIShared.IO.TwoDA.TwoDAReference("itempropdef", "Name", true, 15);
            return ip;
        }
    }
}
