using System;
using System.Collections.Generic;
using System.Text;

using NWN2Toolset.NWN2.Data;
using NWN2Toolset.NWN2.Data.Templates;
using NWN2Toolset.NWN2.Data.TypedCollections;

namespace ACR_BuilderPlugin.Helpers
{
    static class ModuleHelper
    {
        public static NWN2GameModule GetCurrentModule()
        {
            return NWN2Toolset.NWN2ToolsetMainForm.App.Module;
        }
    }
}
