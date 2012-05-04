using System;
using System.Collections.Generic;
using System.Text;

namespace ABM_creator
{
    class ALFAIExoLocString : OEIShared.Utils.OEIExoLocString
    {
        public ALFAIExoLocString(string str)
            : base()
        {
            this[OEIShared.Utils.BWLanguages.BWLanguage.English] = str;
        }
    }
}
