using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;
using System.Reflection;
using System.Reflection.Emit;
using System.Threading;
using CLRScriptFramework;
using ALFA;
using NWScript;
using NWScript.ManagedInterfaceLayer.NWScriptManagedInterface;

using NWEffect = NWScript.NWScriptEngineStructure0;
using NWEvent = NWScript.NWScriptEngineStructure1;
using NWLocation = NWScript.NWScriptEngineStructure2;
using NWTalent = NWScript.NWScriptEngineStructure3;
using NWItemProperty = NWScript.NWScriptEngineStructure4;

namespace ACR_ChooserCreator
{
    public partial class ACR_ChooserCreator : CLRScriptBase, IGeneratedScriptProgram
    {
        public ACR_ChooserCreator([In] NWScriptJITIntrinsics Intrinsics, [In] INWScriptProgram Host)
        {
            InitScript(Intrinsics, Host);
        }

        private ACR_ChooserCreator([In] ACR_ChooserCreator Other)
        {
            InitScript(Other);

            LoadScriptGlobals(Other.SaveScriptGlobals());
        }

        public static Type[] ScriptParameterTypes = { typeof(int), typeof(string) };

        public Int32 ScriptMain([In] object[] ScriptParameters, [In] Int32 DefaultReturnCode)
        {
            SendMessageToPC(OBJECT_SELF, ScriptParameters[0].ToString());
            SendMessageToPC(OBJECT_SELF, ScriptParameters[1].ToString());

            return 0;

        }

        private enum ACR_CreatorCommand
        {
            ACR_CHOOSERCREATOR_INITIALIZE_LISTS = 0,

            ACR_CHOOSERCREATOR_TOP_CREATURE_NAVIGATOR = 10,
            ACR_CHOOSERCREATOR_TOP_ITEM_NAVIGATOR = 11,
            ACR_CHOOSERCREATOR_TOP_PLACEABLE_NAVIGATOR = 12,

            ACR_CHOOSERCREATOR_INCOMING_CLICK = 20,
            ACR_CHOOSERCREATOR_INCOMING_DOUBLECLICK = 21,

            ACR_CHOOSERCREATOR_SEARCH_CREATURES = 30,
            ACR_CHOOSERCREATOR_SEARCH_ITEMS = 31,
            ACR_CHOOSERCREATOR_SEARCH_PLACEABLES = 32
        }

    }
}
