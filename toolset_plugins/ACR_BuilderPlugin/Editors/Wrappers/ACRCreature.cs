using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.Design;
using System.Drawing.Design;
using System.Globalization;
using System.Text;

using System.Windows.Forms;
using System.Windows.Forms.Design;

using NWN2Toolset.NWN2.Data;
using NWN2Toolset.NWN2.Data.Templates;

using ACR_BuilderPlugin.Helpers;
using ACR_BuilderPlugin.Editors.Converters;

namespace ACR_BuilderPlugin.Editors.Wrappers
{
    class ACRCreature
    {
        private NWN2CreatureTemplate creature;

        public void SetSelection(NWN2CreatureTemplate cre)
        {
            creature = cre;
        }

        public NWN2CreatureTemplate GetTemplate()
        {
            return (NWN2CreatureTemplate)creature;
        }

        #region Core
        [CategoryAttribute("Core"), DisplayNameAttribute("Immune to Dispel"), DescriptionAttribute("Set to 1 to make the creature immune to dispel magic.")]
        [DefaultValue(false)]
        public bool X1_L_IMMUNE_TO_DISPEL
        {
            get { return VariableHelper.GetBoolean(creature.Variables, "X1_L_IMMUNE_TO_DISPEL"); }
            set { VariableHelper.SetBoolean(creature.Variables, "X1_L_IMMUNE_TO_DISPEL", value); }
        }

        [CategoryAttribute("Core"), DisplayNameAttribute("Is Incorporeal"), DescriptionAttribute("Set this variable to 1 on a creature to make it walk through other creatures.")]
        [DefaultValue(false)]
        public bool X2_L_IS_INCORPOREAL
        {
            get { return VariableHelper.GetBoolean(creature.Variables, "X2_L_IS_INCORPOREAL"); }
            set { VariableHelper.SetBoolean(creature.Variables, "X2_L_IS_INCORPOREAL", value); }
        }

        [CategoryAttribute("Core"), DisplayNameAttribute("Is Undead"), DescriptionAttribute("If set to a nonzero value, this creature will be considered undead for all scripting purposes. It will still need undead creature properties assigned.")]
        [DefaultValue(false)]
        public bool ACR_CRE_ISUNDEAD
        {
            get { return VariableHelper.GetBoolean(creature.Variables, "ACR_CRE_ISUNDEAD"); }
            set { VariableHelper.SetBoolean(creature.Variables, "ACR_CRE_ISUNDEAD", value); }
        }

        [CategoryAttribute("Core"), DisplayNameAttribute("Number of Attacks"), DescriptionAttribute("Set this variable to 1 - 6 to override the number of attacks a creature has based on its BAB.")]
        [DefaultValue(0)]
        public int X2_L_NUMBER_OF_ATTACKS
        {
            get { return VariableHelper.GetInteger(creature.Variables, "X2_L_NUMBER_OF_ATTACKS"); }
            set { VariableHelper.SetInteger(creature.Variables, "X2_L_NUMBER_OF_ATTACKS", value); }
        }

        [CategoryAttribute("Core"), DisplayNameAttribute("Randomize Abilities"), DescriptionAttribute("If set to a nonzero value, the creature is spawned with randomized ability scores. The blueprint is treated as the \"average\" for the resulting scores.")]
        [DefaultValue(false)]
        public bool ACR_CRE_RANDOM_ABILITIES
        {
            get { return VariableHelper.GetBoolean(creature.Variables, "ACR_CRE_RANDOM_ABILITIES"); }
            set { VariableHelper.SetBoolean(creature.Variables, "ACR_CRE_RANDOM_ABILITIES", value); }
        }

        [CategoryAttribute("Core"), DisplayNameAttribute("Randomize Alignment"), DescriptionAttribute("If set to a nonzero value, the creature is spawned with randomized alignment. The blueprint is treated as the \"average\" for this, and alignment will never differ from the blueprint by more than one step.")]
        [DefaultValue(false)]
        public bool ACR_CRE_RANDOM_ALIGNMENT
        {
            get { return VariableHelper.GetBoolean(creature.Variables, "ACR_CRE_RANDOM_ALIGNMENT"); }
            set { VariableHelper.SetBoolean(creature.Variables, "ACR_CRE_RANDOM_ALIGNMENT", value); }
        }

        [CategoryAttribute("Core"), DisplayNameAttribute("Randomized Spells"), DescriptionAttribute("Setting this variable on a spellcaster creature will make its spelluse a bit more random, but their spell selection may not always be appropriate to the situation anymore.")]
        [DefaultValue(false)]
        public bool X2_SPELL_RANDOM
        {
            get { return VariableHelper.GetBoolean(creature.Variables, "X2_SPELL_RANDOM"); }
            set { VariableHelper.SetBoolean(creature.Variables, "X2_SPELL_RANDOM", value); }
        }

        [CategoryAttribute("Core"), DisplayNameAttribute("Spawn Damaged"), DescriptionAttribute("If set to a nonzero value, the creature will not heal to full health upon spawn-in. This variable allows you to equip your monsters with creature items/equipment that provides health bonuses without them spawning harmed.")]
        [DefaultValue(false)]
        public bool ACR_CRE_SPAWN_DAMAGED
        {
            get { return VariableHelper.GetBoolean(creature.Variables, "ACR_CRE_SPAWN_DAMAGED"); }
            set { VariableHelper.SetBoolean(creature.Variables, "ACR_CRE_SPAWN_DAMAGED", value); }
        }
        #endregion

        #region AI
        [Browsable(true)]
        [CategoryAttribute("AI and Behavior"), DisplayNameAttribute("Behavior Type"), DescriptionAttribute("Which ACR behavior type to use. See http://www.alandfaraway.info/wiki/Building_Creatures for descriptions.")]
        [TypeConverter(typeof(CreatureBehaviorTypeConverter))]
        public string ACR_CREATURE_BEHAVIOR
        {
            get { return VariableHelper.GetString(creature.Variables, "ACR_CREATURE_BEHAVIOR"); }
            set { VariableHelper.SetString(creature.Variables, "ACR_CREATURE_BEHAVIOR", value); }
        }

        [CategoryAttribute("AI and Behavior"), DisplayNameAttribute("Compassion"), DescriptionAttribute("The higher value of this variable, the higher the chance that the creature will aid friendly creatures in combat.")]
        public int X2_L_BEH_COMPASSION
        {
            get { return VariableHelper.GetInteger(creature.Variables, "X2_L_BEH_COMPASSION"); }
            set { VariableHelper.SetInteger(creature.Variables, "X2_L_BEH_COMPASSION", value); }
        }

        [CategoryAttribute("AI and Behavior"), DisplayNameAttribute("Magic Preference"), DescriptionAttribute("The value of this variable is added to the chance that a creature will use magic in combat. Set to 100 for always, 0 for never.")]
        public int X2_L_BEH_MAGIC
        {
            get { return VariableHelper.GetInteger(creature.Variables, "X2_L_BEH_MAGIC"); }
            set { VariableHelper.SetInteger(creature.Variables, "X2_L_BEH_MAGIC", value); }
        }

        [CategoryAttribute("AI and Behavior"), DisplayNameAttribute("Offensive Preference"), DescriptionAttribute("The higher value of this variable, the higher the chance that the creature will use offensive abilities in combat. Set to 0 to make them flee.")]
        public int X2_L_BEH_OFFENSE
        {
            get { return VariableHelper.GetInteger(creature.Variables, "X2_L_BEH_OFFENSE"); }
            set { VariableHelper.SetInteger(creature.Variables, "X2_L_BEH_OFFENSE", value); }
        }

        [CategoryAttribute("AI and Behavior"), DisplayNameAttribute("Use Ambiant Animations"), DescriptionAttribute("Set to 1 to make the creature play mobile ambient animations after spawn. Use this if you want your creature to roam around the area attempting to use other objects. This simulates random movement.")]
        [DefaultValue(false)]
        public bool X2_L_SPAWN_USE_AMBIENT
        {
            get { return VariableHelper.GetBoolean(creature.Variables, "X2_L_SPAWN_USE_AMBIENT"); }
            set { VariableHelper.SetBoolean(creature.Variables, "X2_L_SPAWN_USE_AMBIENT", value); }
        }

        [CategoryAttribute("AI and Behavior"), DisplayNameAttribute("Use Ambiant Animations (Immobile)"), DescriptionAttribute("Set to 1 to make the creature play immobile ambient animations after spawn.")]
        [DefaultValue(false)]
        public bool X2_L_SPAWN_USE_AMBIENT_IMMOBILE
        {
            get { return VariableHelper.GetBoolean(creature.Variables, "X2_L_SPAWN_USE_AMBIENT_IMMOBILE"); }
            set { VariableHelper.SetBoolean(creature.Variables, "X2_L_SPAWN_USE_AMBIENT_IMMOBILE", value); }
        }

        [CategoryAttribute("AI and Behavior"), DisplayNameAttribute("Spawn Alert"), DescriptionAttribute("Set to 1 to make the creature activate detect mode after spawn.")]
        [DefaultValue(false)]
        public bool X2_L_SPAWN_USE_SEARCH
        {
            get { return VariableHelper.GetBoolean(creature.Variables, "X2_L_SPAWN_USE_SEARCH"); }
            set { VariableHelper.SetBoolean(creature.Variables, "X2_L_SPAWN_USE_SEARCH", value); }
        }

        [CategoryAttribute("AI and Behavior"), DisplayNameAttribute("Spawn Stealthed"), DescriptionAttribute("Set to 1 to make the creature activate stealth mode after spawn.")]
        [DefaultValue(false)]
        public bool X2_L_SPAWN_USE_STEALTH
        {
            get { return VariableHelper.GetBoolean(creature.Variables, "X2_L_SPAWN_USE_STEALTH"); }
            set { VariableHelper.SetBoolean(creature.Variables, "X2_L_SPAWN_USE_STEALTH", value); }
        }

        [CategoryAttribute("AI and Behavior"), DisplayNameAttribute("Custom Combat AI"), DescriptionAttribute("See the \"x2_ai_demo\" module for details.")]
        public string X2_SPECIAL_COMBAT_AI_SCRIPT
        {
            get { return VariableHelper.GetString(creature.Variables, "X2_SPECIAL_COMBAT_AI_SCRIPT"); }
            set { VariableHelper.SetString(creature.Variables, "X2_SPECIAL_COMBAT_AI_SCRIPT", value); }
        }
        #endregion

        #region Drops and Loot
        [CategoryAttribute("Drops and Loot"), DisplayNameAttribute("Loot Disabled"), DescriptionAttribute("If set to a nonzero value, the creature is not given any loot drops by the loot system at all. If unset, it is.")]
        [DefaultValue(false)]
        public bool ACR_LOOT_DISABLE
        {
            get { return VariableHelper.GetBoolean(creature.Variables, "ACR_LOOT_DISABLE"); }
            set { VariableHelper.SetBoolean(creature.Variables, "ACR_LOOT_DISABLE", value); }
        }

        [CategoryAttribute("Drops and Loot"), DisplayNameAttribute("CR Modifier"), DescriptionAttribute("This value modifies the creatures CR for the purposes of calculating the amount of loot dropped. If positive, it adds to the CR and increases the value of the loot dropped. If negative, it subtracts from the CR.")]
        [DefaultValue(0.0f)]
        public float ACR_LOOT_CR_MOD
        {
            get { return VariableHelper.GetFloat(creature.Variables, "ACR_LOOT_CR_MOD"); }
            set { VariableHelper.SetFloat(creature.Variables, "ACR_LOOT_CR_MOD", value); }
        }
        #endregion
    }
}
