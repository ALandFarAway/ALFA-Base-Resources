using System;
using System.Collections.Generic;
using System.Text;
using NWN2Toolset.Plugins;
using TD.SandBar;

namespace ABM_creator
{
    class ALFAItemBlueprint
    {
        ALFAGFFStruct itemGFFStruct;

        public ALFAItemBlueprint()
        {
            itemGFFStruct = new ALFAGFFStruct();
        }

        public ALFAItemBlueprint(NWN2Toolset.NWN2.Data.Blueprints.NWN2ItemBlueprint itemBlueprint)
        {
            itemGFFStruct = new ALFAGFFStruct();
            itemBlueprint.SaveEverythingIntoGFFStruct(itemGFFStruct, true);
        }

        public ALFAGFFStruct Struct
        {
            get
            {
                return itemGFFStruct;
            }

            set
            {
                itemGFFStruct = value;
            }
        }

        public byte Charges
        {
            get
            {
                return itemGFFStruct.GetByte("Charges");
            }

            set
            {
                itemGFFStruct.SetByte("Charges", value);
            }
        }

        public uint Cost
        {
            get
            {
                return itemGFFStruct.GetDword("Cost");
            }

            set
            {
                itemGFFStruct.SetDword("Cost", value);
            }
        }

        public string Classification
        {
            get
            {
                return itemGFFStruct.GetOEIExoString("Classification");
            }

            set
            {
                itemGFFStruct.SetOEIExoString("Classification", value);
            }
        }

        public string Name
        {
            get
            {
                return itemGFFStruct.GetOEIExoLocString("LocalizedName");
            }

            set
            {
                itemGFFStruct.SetOEIExoLocString("LocalizedName", value);
            }
        }

        public string UnidentifiedDescription
        {
            get
            {
                return itemGFFStruct.GetOEIExoLocString("Description");
            }

            set
            {
                itemGFFStruct.SetOEIExoLocString("Description", value);
            }
        }

        public string IdentifiedDescription
        {
            get
            {
                return itemGFFStruct.GetOEIExoLocString("DescIdentified");
            }

            set
            {
                itemGFFStruct.SetOEIExoLocString("DescIdentified", value);
            }
        }

        public string Tag
        {
            get
            {
                return itemGFFStruct.GetOEIExoString("Tag");
            }

            set
            {
                itemGFFStruct.SetOEIExoString("Tag", value);
            }
        }

        public string TemplateResRef
        {
            get
            {
                return itemGFFStruct.GetCResRef("TemplateResRef");
            }

            set
            {
                itemGFFStruct.SetCResRef("TemplateResRef", value);
            }
        }

        public byte ModelPart1
        {
            get
            {
                return itemGFFStruct.GetByte("ModelPart1");
            }

            set
            {
                itemGFFStruct.SetByte("ModelPart1", value);
            }
        }

        public byte ModelPart2
        {
            get
            {
                return itemGFFStruct.GetByte("ModelPart2");
            }

            set
            {
                itemGFFStruct.SetByte("ModelPart2", value);
            }
        }

        public byte ModelPart3
        {
            get
            {
                return itemGFFStruct.GetByte("ModelPart3");
            }

            set
            {
                itemGFFStruct.SetByte("ModelPart3", value);
            }
        }

        public System.Collections.IEnumerator FieldKeys
        {
            get
            {
                return itemGFFStruct.Fields.Keys.GetEnumerator();
            }
        }

        public System.Collections.IEnumerator FieldValues
        {
            get
            {
                return itemGFFStruct.Fields.Values.GetEnumerator();
            }
        }

        public int FieldCount
        {
            get
            {
                return itemGFFStruct.Fields.Count;
            }
        }

        override public string ToString()
        {
            string str = "Read only: " + itemGFFStruct.Fields.IsReadOnly;
            int num = itemGFFStruct.FieldCount;
            System.Collections.IEnumerator keysEnum = itemGFFStruct.Fields.Keys.GetEnumerator();
            System.Collections.IEnumerator valsEnum = itemGFFStruct.Fields.Values.GetEnumerator();     
            for (int i = 0; i < num; i++)
            {
                keysEnum.MoveNext();
                valsEnum.MoveNext();
                string label = (string)keysEnum.Current;
                OEIShared.IO.GFF.GFFField field = (OEIShared.IO.GFF.GFFField)valsEnum.Current;
                str += label.ToString() + " (" + field.Type.ToString() + "): " + field.Value.ToString() + Environment.NewLine;
            }
            return str;
        }

        public NWN2Toolset.NWN2.Data.Blueprints.NWN2ItemBlueprint ItemBlueprint
        {
            get
            {
                return new NWN2Toolset.NWN2.Data.Blueprints.NWN2ItemBlueprint(itemGFFStruct);
            }
        }

        public OEIShared.IO.GFF.GFFList PropertiesList
        {
            get
            {
                return itemGFFStruct.GetListSafe("PropertiesList");
            }

        }
        
        public void AddItemProperty(ALFAItemProperty aIp)
        {
            AddItemProperty(aIp.Struct);
        }

        public void AddItemProperty(OEIShared.IO.GFF.GFFStruct ipGFF)
        {
            itemGFFStruct.GetListSafe("PropertiesList").StructList.Add(ipGFF);
        }
    }
}
