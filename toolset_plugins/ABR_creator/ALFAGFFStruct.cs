using System;
using System.Collections.Generic;
using System.Text;
using NWN2Toolset.Plugins;
using TD.SandBar;

namespace ABM_creator
{
    class ALFAGFFStruct : OEIShared.IO.GFF.GFFStruct
    {
        public string GetOEIExoLocString(string key)
        {
            return this[key].ValueCExoLocString[OEIShared.Utils.BWLanguages.BWLanguage.English];
        }

        public string GetCResRef(string key)
        {
            return this[key].ValueCResRef.ToString();
        }

        public void SetCResRef(string key, string resref)
        {
            Set(key, new OEIShared.Utils.OEIResRef(resref));
        }

        public void Set(string key, object value)
        {
            Set(OEIShared.IO.GFF.GFFField.CreateGFFField(key, value));
        }

        public void Set(OEIShared.IO.GFF.GFFField field)
        {
            if (this.Contains(field.StringLabel))
            {
                this.Fields.Remove(field);
            }
            this.Fields.Add(field);
        }

        public ushort GetWord(string key)
        {
            return this[key].ValueWord;
        }

        public void SetWord(string key, ushort value)
        {
            this.Set(key, value);
        }

        public uint GetDword(string key)
        {
            return this[key].ValueDword;
        }

        public void SetDword(string key, uint value)
        {
            this[key].ValueDword = value;
        }

        public void SetOEIExoLocString(string key, string value)
        {
            OEIShared.Utils.OEIExoLocString str = new OEIShared.Utils.OEIExoLocString();
            str[OEIShared.Utils.BWLanguages.BWLanguage.English] = value;
            Set(OEIShared.IO.GFF.GFFField.CreateGFFField(key, str));            
        }

        public string GetOEIExoString(string key)
        {
            return this[key].ValueCExoString.Value;
        }

        public void SetOEIExoString(string key, string value)
        {
            Set(key, new OEIShared.Utils.OEIExoString(value));
        }

        public byte GetByte(string key)
        {
            return this[key].ValueByte;
        }

        public void SetByte(string key, byte b)
        {
            Set(key, b);
        }

        public uint GetUint(string key)
        {
            return (uint)this[key].ValueInt;
        }

        public void SetUint(string key, uint value)
        {
            Set(key, value);
        }

        public void PrintToDebugWindow()
        {
            PrintToDebugWindow(this);
        }

        void PrintToDebugWindow(OEIShared.IO.GFF.GFFStruct gffStruct)           
        {
            System.Collections.IEnumerator keys = gffStruct.Fields.Keys.GetEnumerator();
            System.Collections.IEnumerator values = gffStruct.Fields.Values.GetEnumerator();
            for (int i = 0; i < gffStruct.FieldCount; i++)
            {
                keys.MoveNext();
                values.MoveNext();
                string key = (string)keys.Current;
                OEIShared.IO.GFF.GFFField value = (OEIShared.IO.GFF.GFFField)values.Current;
                DebugWindow.PrintDebugMessage(key + " (" + value.Type.ToString() + "): " + value.Value.ToString());
            }
        }
        
        public void PrintListToDebugWindow(string listName)
        {
            OEIShared.IO.GFF.GFFList list = this.GetListSafe(listName);
            for (int i = 0; i < list.StructList.Count; i++)
            {
                DebugWindow.PrintDebugMessage("**************");
                PrintToDebugWindow(list[i]);
            }
            DebugWindow.PrintDebugMessage("**************");
        }
    }
}
