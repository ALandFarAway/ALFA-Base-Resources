using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Text;

using NWN2Toolset.NWN2.Data.Templates;

using ACR_BuilderPlugin.Helpers;
using ACR_BuilderPlugin.Editors.Converters;

namespace ACR_BuilderPlugin
{
    public class ACRSpawnWaypoint
    {
        private NWN2WaypointTemplate waypoint;

        public void SetSelection(NWN2WaypointTemplate wp)
        {
            waypoint = wp;
        }

        #region Core
        [CategoryAttribute("Core"), DisplayNameAttribute("Disabled"), DescriptionAttribute("This spawn is disabled and will not spawn unless enabled by some other script or DM tool.")]
        [DefaultValue(false)]
        public bool ACR_SPAWN_IS_DISABLED
        {
            get { return VariableHelper.GetBoolean(waypoint.Variables, "ACR_SPAWN_IS_DISABLED"); }
            set { VariableHelper.SetBoolean(waypoint.Variables, "ACR_SPAWN_IS_DISABLED", value); }
        }

        [Browsable(true)]
        [CategoryAttribute("Core"), DisplayNameAttribute("Type"), DescriptionAttribute("This indicates the type of object which is being spawned.")]
        [TypeConverter(typeof(SpawnTypeConverter))]
        public string ACR_SPAWN_TYPE
        {
            get { return SpawnTypeConverter.SpawnTypes[VariableHelper.GetInteger(waypoint.Variables, "ACR_SPAWN_TYPE")]; }
            set { VariableHelper.SetInteger(waypoint.Variables, "ACR_SPAWN_TYPE", Array.IndexOf(SpawnTypeConverter.SpawnTypes, value )); }
        }

        [CategoryAttribute("Core"), DisplayNameAttribute("Spawns"), DescriptionAttribute("This array lists Resource Names of objects which are always spawned by the spawn point. If the spawn point is activated, all the Resource Names in this array will be spawned. Resource Names listed more than once are spawned more than once.")]
        public string[] ACR_SPAWN_RESNAME
        {
            get { return VariableHelper.GetStringArray(waypoint.Variables, "ACR_SPAWN_RESNAME_*"); }
            set { VariableHelper.SetStringArray(waypoint.Variables, "ACR_SPAWN_RESNAME_*", value); }
        }

        [CategoryAttribute("Core"), DisplayNameAttribute("Count"), DescriptionAttribute("This local integer defines the number of times a spawn point will spawn, if all its children have been killed. The default is 1, which indicates a \"single-life\" spawn. A setting of \"-1\" will lead to an infinitely respawning waypoint, which will always repopulate after being \"cleared out\". Similarly, setting this value to \"5\", would mean the spawn point would have to be killed off 5 separate times to deactivate \"for good\". Note that currently a mod reset still sets this counter back to it's original state.")]
        [DefaultValue(1)]
        public int ACR_SPAWN_RESPAWN_COUNT
        {
            get { return VariableHelper.GetInteger(waypoint.Variables, "ACR_SPAWN_RESPAWN_COUNT"); }
            set { VariableHelper.SetInteger(waypoint.Variables, "ACR_SPAWN_RESPAWN_COUNT", value); }
        }

        [CategoryAttribute("Core"), DisplayNameAttribute("Chance"), DescriptionAttribute("This value, from 0 to 100, represents the chance a spawn has of spawning. This chance is computed once every game day. The % chance applies per day for the waypoint collectively, so it is an all-or-nothing situation.")]
        [DefaultValue(100.0f)]
        public float ACR_SPAWN_CHANCE
        {
            get { return VariableHelper.GetFloat(waypoint.Variables, "ACR_SPAWN_CHANCE"); }
            set { VariableHelper.SetFloat(waypoint.Variables, "ACR_SPAWN_CHANCE", value); }
        }

        [CategoryAttribute("Core"), DisplayNameAttribute("Delay (Min)"), DescriptionAttribute("This is the random period of time a spawn spends \"recharging\" after its children have all been killed. This value is in game hours, and is chosen randomly between the mininum and maximum. To keep this value from being random, set both the min and max equal.")]
        [DefaultValue(0.0f)]
        public float ACR_RESPAWN_DELAY_MIN
        {
            get { return VariableHelper.GetFloat(waypoint.Variables, "ACR_RESPAWN_DELAY_MIN"); }
            set { VariableHelper.SetFloat(waypoint.Variables, "ACR_RESPAWN_DELAY_MIN", value); }
        }

        [CategoryAttribute("Core"), DisplayNameAttribute("Delay (Max)"), DescriptionAttribute("This is the random period of time a spawn spends \"recharging\" after its children have all been killed. This value is in game hours, and is chosen randomly between the mininum and maximum. To keep this value from being random, set both the min and max equal.")]
        [DefaultValue(0.0f)]
        public float ACR_RESPAWN_DELAY_MAX
        {
            get { return VariableHelper.GetFloat(waypoint.Variables, "ACR_RESPAWN_DELAY_MAX"); }
            set { VariableHelper.SetFloat(waypoint.Variables, "ACR_RESPAWN_DELAY_MAX", value); }
        }

        [CategoryAttribute("Core"), DisplayNameAttribute("Radius"), DescriptionAttribute("This, if nonzero, specifies a maximum distance from the chosen spawn point location at which the spawn child may appear, in a random direction. This is calculated separately (distance and direction) for each spawned child, so for a multiple spawn, you can imagine it to describe the tightness of the \"scatter\" of the spawned children around the spawn point target. A small value will give a closely-spaced group, while a large one will give the illusion of entirely separate spawns, even though they are all children of the same waypoint.")]
        [DefaultValue(0.0f)]
        public float ACR_SPAWN_RANDOM_RADIUS
        {
            get { return VariableHelper.GetFloat(waypoint.Variables, "ACR_SPAWN_RANDOM_RADIUS"); }
            set { VariableHelper.SetFloat(waypoint.Variables, "ACR_SPAWN_RANDOM_RADIUS", value); }
        }

        [CategoryAttribute("Core"), DisplayNameAttribute("Range"), DescriptionAttribute("This, if nonzero, specifies a range (in a random direction) from the actual location of the waypoint to the target/centerpoint of the spawning- 0.0 will always center the spawn right on top of the waypoint, while an arbitrarily large value could place the spawn anywhere in the area. Note that when spawning a single child, this parameter is functionally equivalent to Radius, but when used with multiple children, it can place a mob of creatures, placeables, or items in a less predictable position, either in a closely knit group, or a broad spread.")]
        [DefaultValue(0.0f)]
        public float ACR_SPAWN_RANDOM_RANGE
        {
            get { return VariableHelper.GetFloat(waypoint.Variables, "ACR_SPAWN_RANDOM_RANGE"); }
            set { VariableHelper.SetFloat(waypoint.Variables, "ACR_SPAWN_RANDOM_RANGE", value); }
        }

        [CategoryAttribute("Core"), DisplayNameAttribute("Random Facing"), DescriptionAttribute("The spawn's facing is random, instead of facing the direction of the spawn waypoint.")]
        [DefaultValue(0.0f)]
        public float ACR_SPAWN_RANDOM_FACING
        {
            get { return VariableHelper.GetFloat(waypoint.Variables, "ACR_SPAWN_RANDOM_FACING"); }
            set { VariableHelper.SetFloat(waypoint.Variables, "ACR_SPAWN_RANDOM_FACING", value); }
        }

        [CategoryAttribute("Core"), DisplayNameAttribute("Spawn in Sight"), DescriptionAttribute("The spawn will spawn with a PC in sight of it. This is disabled to keep spawns from suddenly appearing in front of a PC in an OOC fashion.")]
        [DefaultValue(false)]
        public bool ACR_SPAWN_IN_PC_SIGHT
        {
            get { return VariableHelper.GetBoolean(waypoint.Variables, "ACR_SPAWN_IN_PC_SIGHT"); }
            set { VariableHelper.SetBoolean(waypoint.Variables, "ACR_SPAWN_IN_PC_SIGHT", value); }
        }

        [CategoryAttribute("Core"), DisplayNameAttribute("Spawn in Area"), DescriptionAttribute("This spawn will not respawn or activate at all if a PC is already in the area when it tries to do so. This is used to prevent creatures from re-appearing where they were after a PC just killed them, or something similar.")]
        [DefaultValue(false)]
        public bool ACR_SPAWN_ONLY_WHEN_NO_PC_IN_AREA
        {
            get { return VariableHelper.GetBoolean(waypoint.Variables, "ACR_SPAWN_ONLY_WHEN_NO_PC_IN_AREA"); }
            set { VariableHelper.SetBoolean(waypoint.Variables, "ACR_SPAWN_ONLY_WHEN_NO_PC_IN_AREA", value); }
        }

        [CategoryAttribute("Core"), DisplayNameAttribute("Stealth Mode"), DescriptionAttribute("The spawn spawns in stealth mode.")]
        [DefaultValue(false)]
        public bool ACR_SPAWN_IN_STEALTH
        {
            get { return VariableHelper.GetBoolean(waypoint.Variables, "ACR_SPAWN_IN_STEALTH"); }
            set { VariableHelper.SetBoolean(waypoint.Variables, "ACR_SPAWN_IN_STEALTH", value); }
        }

        [CategoryAttribute("Core"), DisplayNameAttribute("Detect Mode"), DescriptionAttribute("The spawn spawns in detect mode.")]
        [DefaultValue(false)]
        public bool ACR_SPAWN_IN_DETECT
        {
            get { return VariableHelper.GetBoolean(waypoint.Variables, "ACR_SPAWN_IN_DETECT"); }
            set { VariableHelper.SetBoolean(waypoint.Variables, "ACR_SPAWN_IN_DETECT", value); }
        }

        [CategoryAttribute("Core"), DisplayNameAttribute("Spawn Buffed"), DescriptionAttribute("Tpawned creatures spawn with all hour per level (or longer) buffs cast on itself in a semi-intelligent fashion (evil creatures cast protection from good, multiple magic vestimates or magic weapons are distributed over different items, etc).")]
        [DefaultValue(false)]
        public bool ACR_SPAWN_BUFFED
        {
            get { return VariableHelper.GetBoolean(waypoint.Variables, "ACR_SPAWN_BUFFED"); }
            set { VariableHelper.SetBoolean(waypoint.Variables, "ACR_SPAWN_BUFFED", value); }
        }
        #endregion

        #region Random Spawns
        [CategoryAttribute("Random Spawns"), DisplayNameAttribute("Spawns (Random)"), DescriptionAttribute("This array lists Resource Names of objects which are chosen at random to be spawned. The number of chosen Resource Names depends on the min/max settings. Each time the spawns are chosen randomly from this list.")]
        public string[] ACR_SPAWN_RANDOM_RESNAME
        {
            get { return VariableHelper.GetStringArray(waypoint.Variables, "ACR_SPAWN_RANDOM_RESNAME_*"); }
            set { VariableHelper.SetStringArray(waypoint.Variables, "ACR_SPAWN_RANDOM_RESNAME_*", value); }
        }

        [CategoryAttribute("Random Spawns"), DisplayNameAttribute("Minumum"), DescriptionAttribute("The minimum amount of resources to spawn from the above array.")]
        [DefaultValue(0)]
        public int ACR_SPAWN_RESNAMES_MIN
        {
            get { return VariableHelper.GetInteger(waypoint.Variables, "ACR_SPAWN_RESNAMES_MIN"); }
            set { VariableHelper.SetInteger(waypoint.Variables, "ACR_SPAWN_RESNAMES_MIN", value); }
        }

        [CategoryAttribute("Random Spawns"), DisplayNameAttribute("Maximum"), DescriptionAttribute("The maximum amount of resources to spawn from the above array.")]
        [DefaultValue(0)]
        public int ACR_SPAWN_RESNAMES_MAX
        {
            get { return VariableHelper.GetInteger(waypoint.Variables, "ACR_SPAWN_RESNAMES_MAX"); }
            set { VariableHelper.SetInteger(waypoint.Variables, "ACR_SPAWN_RESNAMES_MAX", value); }
        }
        #endregion

        #region Effects
        [CategoryAttribute("Effects"), DisplayNameAttribute("Animation"), DescriptionAttribute("This is the animation performed by all creatures spawned from this spawn point, as they spawn.")]
        public string ACR_SPAWN_ANIMATION
        {
            get { return VariableHelper.GetString(waypoint.Variables, "ACR_SPAWN_ANIMATION"); }
            set { VariableHelper.SetString(waypoint.Variables, "ACR_SPAWN_ANIMATION", value); }
        }

        [CategoryAttribute("Effects"), DisplayNameAttribute("Use Default Animation"), DescriptionAttribute("This setting makes the spawn appear with its default spawn-in animation. This is usually a \"fly-down\" effect for most creatures, and a \"climb down\" effect for spiders.")]
        [DefaultValue(false)]
        public bool ACR_SPAWN_WITH_ANIMATION
        {
            get { return VariableHelper.GetBoolean(waypoint.Variables, "ACR_SPAWN_WITH_ANIMATION"); }
            set { VariableHelper.SetBoolean(waypoint.Variables, "ACR_SPAWN_WITH_ANIMATION", value); }
        }

        [CategoryAttribute("Effects"), DisplayNameAttribute("Name Coloring"), DescriptionAttribute("Sets the color of the creature's name to the string value. Anything that functions inside of <C=[this spot]>Name</C> is valid for use.")]
        public string ACR_COLOR_NAME
        {
            get { return VariableHelper.GetString(waypoint.Variables, "ACR_COLOR_NAME"); }
            set { VariableHelper.SetString(waypoint.Variables, "ACR_COLOR_NAME", value); }
        }

        [CategoryAttribute("Effects"), DisplayNameAttribute("Spawn Visual"), DescriptionAttribute("This integer indicates the visual effect number of a visual effect which is played on the spawn point itself as it activates. It is commonly used to represent groups of teleporting or summoned monsters.")]
        [DefaultValue(0)]
        public int ACR_SPAWN_VFX
        {
            get { return VariableHelper.GetInteger(waypoint.Variables, "ACR_SPAWN_VFX"); }
            set { VariableHelper.SetInteger(waypoint.Variables, "ACR_SPAWN_VFX", value); }
        }

        [CategoryAttribute("Effects"), DisplayNameAttribute("Spawn in Visual"), DescriptionAttribute("This integer indicates the Visual Effect number of a visual effect which is played on every object this spawn point spawns. It is commonly used to represent teleporting or summoned monsters.")]
        [DefaultValue(0)]
        public int ACR_SPAWN_IN_VFX
        {
            get { return VariableHelper.GetInteger(waypoint.Variables, "ACR_SPAWN_IN_VFX"); }
            set { VariableHelper.SetInteger(waypoint.Variables, "ACR_SPAWN_IN_VFX", value); }
        }

        [CategoryAttribute("Effects"), DisplayNameAttribute("Spawn Sound"), DescriptionAttribute("This is the sound effect file which is played on the spawn point itself as it activates.")]
        public string ACR_SPAWN_SFX
        {
            get { return VariableHelper.GetString(waypoint.Variables, "ACR_SPAWN_SFX"); }
            set { VariableHelper.SetString(waypoint.Variables, "ACR_SPAWN_SFX", value); }
        }

        [CategoryAttribute("Effects"), DisplayNameAttribute("Spawn in Sound"), DescriptionAttribute("This is the Sound Effect file which is played on each object spawned at this spawn point.")]
        public string ACR_SPAWN_IN_SFX
        {
            get { return VariableHelper.GetString(waypoint.Variables, "ACR_SPAWN_IN_SFX"); }
            set { VariableHelper.SetString(waypoint.Variables, "ACR_SPAWN_IN_SFX", value); }
        }
        #endregion

        #region Timing
        [CategoryAttribute("Timing"), DisplayNameAttribute("Hour (Spawn)"), DescriptionAttribute("This is the hour of the day the spawn starts to spawn in at. If the current hour is between these values, the spawn can be active. If the two values are equal, the hour of the day has no effect on whether or not the spawn activates. This also works for \"circular\" cases, such as Night-only spawns.")]
        [DefaultValue(0)]
        public int ACR_SPAWN_IN_HOUR
        {
            get { return VariableHelper.GetInteger(waypoint.Variables, "ACR_SPAWN_IN_HOUR"); }
            set { VariableHelper.SetInteger(waypoint.Variables, "ACR_SPAWN_IN_HOUR", value); }
        }

        [CategoryAttribute("Timing"), DisplayNameAttribute("Hour (Despawn)"), DescriptionAttribute("This is the hour of the day the spawn starts to spawn out at. If the current hour is between these values, the spawn can be active. If the two values are equal, the hour of the day has no effect on whether or not the spawn activates. This also works for \"circular\" cases, such as Night-only spawns.")]
        [DefaultValue(0)]
        public int ACR_SPAWN_OUT_HOUR
        {
            get { return VariableHelper.GetInteger(waypoint.Variables, "ACR_SPAWN_OUT_HOUR"); }
            set { VariableHelper.SetInteger(waypoint.Variables, "ACR_SPAWN_OUT_HOUR", value); }
        }

        [CategoryAttribute("Timing"), DisplayNameAttribute("Day (Spawn)"), DescriptionAttribute("This is the day of the month in which the spawn will enable. These should also work in a circular fashion similar to the hours above.")]
        [DefaultValue(0)]
        public int ACR_SPAWN_IN_DAY
        {
            get { return VariableHelper.GetInteger(waypoint.Variables, "ACR_SPAWN_IN_DAY"); }
            set { VariableHelper.SetInteger(waypoint.Variables, "ACR_SPAWN_IN_DAY", value); }
        }

        [CategoryAttribute("Timing"), DisplayNameAttribute("Day (Despawn)"), DescriptionAttribute("This is the day of the month in which the spawn will disable. These should also work in a circular fashion similar to the hours above.")]
        [DefaultValue(0)]
        public int ACR_SPAWN_OUT_DAY
        {
            get { return VariableHelper.GetInteger(waypoint.Variables, "ACR_SPAWN_OUT_DAY"); }
            set { VariableHelper.SetInteger(waypoint.Variables, "ACR_SPAWN_OUT_DAY", value); }
        }

        [CategoryAttribute("Timing"), DisplayNameAttribute("Month (Spawn)"), DescriptionAttribute("This is the month of the year the spawn starts to spawn in at. If the current month is between these values, the spawn can be active. If the two values are equal, the month of the year has no effect on whether or not the spawn activates.")]
        [DefaultValue(0)]
        public int ACR_SPAWN_IN_MONTH
        {
            get { return VariableHelper.GetInteger(waypoint.Variables, "ACR_SPAWN_IN_MONTH"); }
            set { VariableHelper.SetInteger(waypoint.Variables, "ACR_SPAWN_IN_MONTH", value); }
        }

        [CategoryAttribute("Timing"), DisplayNameAttribute("Month (Despawn)"), DescriptionAttribute("This is the month of the year the spawns end. If the current month is between these values, the spawn can be active. If the two values are equal, the month of the year has no effect on whether or not the spawn activates.")]
        [DefaultValue(0)]
        public int ACR_SPAWN_OUT_MONTH
        {
            get { return VariableHelper.GetInteger(waypoint.Variables, "ACR_SPAWN_OUT_MONTH"); }
            set { VariableHelper.SetInteger(waypoint.Variables, "ACR_SPAWN_OUT_MONTH", value); }
        }
        #endregion
    }
}
