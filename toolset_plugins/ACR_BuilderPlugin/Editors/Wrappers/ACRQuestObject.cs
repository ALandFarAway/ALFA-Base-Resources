using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Text;

using NWN2Toolset.NWN2.Data.Templates;

using ACR_BuilderPlugin.Helpers;
using ACR_BuilderPlugin.Editors.Converters;

namespace ACR_BuilderPlugin.Editors.Wrappers
{
    class ACRQuestObject
    {
        protected INWN2Object questObject;

        public void SetSelection(INWN2Object obj)
        {
            questObject = obj;
        }

        #region Core
        [CategoryAttribute("Core"), DisplayNameAttribute("Quest Name"), DescriptionAttribute("Variable for defining the quest name (per the module journal).")]
        public string ACR_QST_NAME
        {
            get { return VariableHelper.GetString(questObject.Variables, "ACR_QST_NAME"); }
            set { VariableHelper.SetString(questObject.Variables, "ACR_QST_NAME", value); }
        }

        [CategoryAttribute("Core"), DisplayNameAttribute("State, Lower"), DescriptionAttribute("Variable for defining the activation state of a quest trigger. If this is 0 or undefined, a quest trigger can be activated repeatedly or in any sequence.")]
        [DefaultValue(0)]
        public int ACR_QST_LOWER_STATE
        {
            get { return VariableHelper.GetInteger(questObject.Variables, "ACR_QST_LOWER_STATE"); }
            set { VariableHelper.SetInteger(questObject.Variables, "ACR_QST_LOWER_STATE", value); }
        }

        [CategoryAttribute("Core"), DisplayNameAttribute("State, Upper"), DescriptionAttribute("Variable for defining the state at which a quest trigger will grant the associated quest XP reward. If this is 0 or undefined, the quest trigger will not grant any quest XP.")]
        [DefaultValue(0)]
        public int ACR_QST_UPPER_STATE
        {
            get { return VariableHelper.GetInteger(questObject.Variables, "ACR_QST_UPPER_STATE"); }
            set { VariableHelper.SetInteger(questObject.Variables, "ACR_QST_UPPER_STATE", value); }
        }

        [CategoryAttribute("Core"), DisplayNameAttribute("Message"), DescriptionAttribute("Variable for defining a message to send to the player when a quest trigger is activated.")]
        public string ACR_QST_MESSAGE
        {
            get { return VariableHelper.GetString(questObject.Variables, "ACR_QST_MESSAGE"); }
            set { VariableHelper.SetString(questObject.Variables, "ACR_QST_MESSAGE", value); }
        }
        #endregion

        #region Requirements
        [CategoryAttribute("Requirements"), DisplayNameAttribute("Skill"), DescriptionAttribute("Variable for defining a skill that needs a skill check in order to activate this quest trigger.")]
        [DefaultValue(0)]
        public int ACR_QST_REQUIRED_SKILL
        {
            get { return VariableHelper.GetInteger(questObject.Variables, "ACR_QST_REQUIRED_SKILL"); }
            set { VariableHelper.SetInteger(questObject.Variables, "ACR_QST_REQUIRED_SKILL", value); }
        }

        [CategoryAttribute("Requirements"), DisplayNameAttribute("DC"), DescriptionAttribute("Variable for the difficulty class of the skill check that needs to be passed in order to activate this quest trigger.")]
        [DefaultValue(0)]
        public int ACR_QST_SKILL_DC
        {
            get { return VariableHelper.GetInteger(questObject.Variables, "ACR_QST_SKILL_DC"); }
            set { VariableHelper.SetInteger(questObject.Variables, "ACR_QST_SKILL_DC", value); }
        }
        #endregion

        #region Spawns
        [CategoryAttribute("Spawns"), DisplayNameAttribute("Spawn Creature"), DescriptionAttribute("Variable for defining the resref of the creature object to spawn (used OnTriggerEnter).")]
        public string ACR_QST_SPAWN_CRESREF
        {
            get { return VariableHelper.GetString(questObject.Variables, "ACR_QST_SPAWN_CRESREF"); }
            set { VariableHelper.SetString(questObject.Variables, "ACR_QST_SPAWN_CRESREF", value); }
        }

        [CategoryAttribute("Spawns"), DisplayNameAttribute("Spawn Item"), DescriptionAttribute("Variable for defining the resref of the item object to spawn (used OnTriggerEnter).")]
        public string ACR_QST_SPAWN_IRESREF
        {
            get { return VariableHelper.GetString(questObject.Variables, "ACR_QST_SPAWN_IRESREF"); }
            set { VariableHelper.SetString(questObject.Variables, "ACR_QST_SPAWN_IRESREF", value); }
        }

        [CategoryAttribute("Spawns"), DisplayNameAttribute("Fade In"), DescriptionAttribute("Variable for defining a skill that needs a skill check in order to activate this quest trigger.")]
        [DefaultValue(false)]
        public bool ACR_QST_APPEAR_ANIMATION
        {
            get { return VariableHelper.GetBoolean(questObject.Variables, "ACR_QST_APPEAR_ANIMATION"); }
            set { VariableHelper.SetBoolean(questObject.Variables, "ACR_QST_APPEAR_ANIMATION", value); }
        }

        [CategoryAttribute("Spawns"), DisplayNameAttribute("Delay"), DescriptionAttribute("Variable for defining a spawn time delay. This is used to introduce a delay between activating a quest trigger and spawning the desired object.")]
        [DefaultValue(0.0f)]
        public float ACR_QST_SPAWN_DELAY
        {
            get { return VariableHelper.GetFloat(questObject.Variables, "ACR_QST_SPAWN_DELAY"); }
            set { VariableHelper.SetFloat(questObject.Variables, "ACR_QST_SPAWN_DELAY", value); }
        }

        [CategoryAttribute("Spawns"), DisplayNameAttribute("Waypoint"), DescriptionAttribute("Variable for defining the tag of the waypoint (location) at which to spawn an item or creature.")]
        public string ACR_QST_SPAWN_WAYPOINT
        {
            get { return VariableHelper.GetString(questObject.Variables, "ACR_QST_SPAWN_WAYPOINT"); }
            set { VariableHelper.SetString(questObject.Variables, "ACR_QST_SPAWN_WAYPOINT", value); }
        }
        #endregion
    }
}
