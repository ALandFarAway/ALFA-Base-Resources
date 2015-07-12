using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Text;

using NWN2Toolset.NWN2.Data.Templates;

using ACR_BuilderPlugin.Helpers;
using ACR_BuilderPlugin.Editors.Converters;

namespace ACR_BuilderPlugin.Editors.Wrappers
{
    class ACRQuestWaypoint : ACRQuestObject
    {
        #region Core
        [CategoryAttribute("Core"), DisplayNameAttribute("Trigger Shape"), DescriptionAttribute("Variable corresponding to a line number in vfx_persistent.2da which determines the size/shape/facing/visual effects (if any) of the quest location once spawned.")]
        [DefaultValue(0)]
        public int ACR_QUEST_TRIG_SHAPE
        {
            get { return VariableHelper.GetInteger(questObject.Variables, "ACR_QUEST_TRIG_SHAPE"); }
            set { VariableHelper.SetInteger(questObject.Variables, "ACR_QUEST_TRIG_SHAPE", value); }
        }
        #endregion
    }
}
