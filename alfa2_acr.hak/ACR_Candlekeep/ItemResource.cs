using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ACR_Candlekeep
{
    public class ItemResource
    {
        public string LocalizedName;
        public string Classification;
        public string TemplateResRef;
        public string Tag;
        public int Cost;
        public int BaseItem;
        public bool Cursed;
        public bool Plot;
        public bool Stolen;

        public ItemResource() { }
    }
}

