using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Threading;
using System.Windows.Forms;

using OEIShared.IO.GFF;
using NWN2Toolset.NWN2.Data;
using NWN2Toolset.NWN2.Data.Blueprints;
using NWN2Toolset.NWN2.Data.Factions;
using NWN2Toolset.NWN2.Data.Instances;
using NWN2Toolset.NWN2.Data.Templates;
using NWN2Toolset.NWN2.Data.TypedCollections;

namespace ACR_BuilderPlugin
{
    class ModuleValidator
    {
        System.IO.StreamWriter log = null;

        public void Run()
        {
            // Open our log file.
            log = new System.IO.StreamWriter("acr_validation.log");
            log.WriteLine("ACR Validation Tool - Log");
            bool autoSavePreviousState = NWN2Toolset.NWN2ToolsetMainForm.App.AutosaveTemporarilyDisabled;
            NWN2Toolset.NWN2ToolsetMainForm.App.AutosaveTemporarilyDisabled = true;
            try
            {

                #region Validate module information
                NWN2GameModule module = NWN2Toolset.NWN2ToolsetMainForm.App.Module;
                #endregion

                #region Validate blueprints
                log.WriteLine("\nValidating blueprints: Items");
                foreach (NWN2ItemBlueprint item in module.Items) Validate(item);

                log.WriteLine("\nValidating blueprints: Creatures");
                foreach (NWN2CreatureBlueprint creature in module.Creatures) Validate(creature);

                log.WriteLine("\nValidating blueprints: Waypoints");
                foreach (NWN2WaypointBlueprint waypoint in module.Waypoints) Validate(waypoint);
                #endregion

                #region Validate areas
                foreach (NWN2GameArea area in module.Areas.Values)
                {
                    log.WriteLine("\nValidating area: " + area.Name);
                    area.Demand();

                    // A bloom value of 0 can cause issues on some graphic cards.
                    foreach (OEIShared.NetDisplay.DayNightStage dayNightStage in area.DayNightStages)
                    {
                        if (dayNightStage.BloomGlowIntensity == 0.0f)
                        {
                            log.WriteLine("FIXED: Area \"{0}\" a day/night cycle {1} has a bloom intensity of 0.0f. This causes issues on some graphics cards.", area.Name, dayNightStage.Stage.ToString());
                            dayNightStage.BloomGlowIntensity = 0.001f;
                        }
                    }

                    // Area object instances.
                    foreach (NWN2CreatureInstance creature in area.Creatures) Validate(creature);
                    foreach (NWN2ItemInstance item in area.Items) Validate(item);
                    foreach (NWN2WaypointInstance waypoint in area.Waypoints) Validate(waypoint);

                    // Save data.
                    area.LoadAllHookPoints();
                    area.OEISerialize();
                    area.Release();
                }
                #endregion

                // Open the log file.
                log.WriteLine("\nValidation complete.");
                log.Close();
                System.Diagnostics.Process.Start("acr_validation.log");
                module.Modified = true;
            }
            finally
            {
                NWN2Toolset.NWN2ToolsetMainForm.App.AutosaveTemporarilyDisabled = autoSavePreviousState;
            }
        }

        private void Validate(NWN2ItemBlueprint item)
        {
            // Custom validation of only blueprints here.


            // Validation of all NWN2ItemTemplates (in areas, inventories, blueprints).
            Validate((NWN2ItemTemplate)item, item.ResourceName.ToString());
        }

        private void Validate(NWN2ItemInstance item)
        {
            // Custom validation of only instances here.
            log.WriteLine("ERROR: Item \"{0}\" instanced. Use ACR_Spawn instead.", item.Tag);

            // Validation of all NWN2ItemTemplates (in areas, blueprints).
            Validate((NWN2ItemTemplate)item, item.Tag);
        }

        private void Validate(NWN2ItemTemplate item, string reference)
        {
            try
            {
                // Check to see if the price needs to be recalculated.
                GFFStruct gff = new GFFStruct();
                item.SaveEverythingIntoGFFStruct( gff, false );
                if (gff.GetDwordSafe("Cost", 0) != item.Cost) log.WriteLine("FIXED: Item \"{0}\" base cost is out of date.", reference);

                // Make sure prices are positive.
                if (item.Cost + item.AdditionalCost < 0) log.WriteLine("ERROR: Item \"{0}\" has a negative item value.", reference);
            }
            catch (Exception exception)
            {
                log.WriteLine("EXCEPTION: Error while handling \"{0}\":\n{1}", reference, exception.Message);
            }
        }

        private void Validate(NWN2CreatureBlueprint creature)
        {
            // Custom validation of only blueprints here.


            // Validation of all NWN2CreatureTemplates (in areas, blueprints).
            Validate((NWN2CreatureTemplate)creature, creature.ResourceName.ToString());
        }

        private void Validate(NWN2CreatureInstance creature)
        {
            // Custom validation of only instances here.
            log.WriteLine("ERROR: Creature \"{0}\" instanced. Use ACR_Spawn instead.", creature.Tag);

            // Validation of all NWN2CreatureTemplates (in areas, blueprints).
            Validate((NWN2CreatureTemplate)creature, creature.Tag);
        }

        private void Validate(NWN2CreatureTemplate creature, string reference)
        {
            try
            {
                // Check for invalid factions.
                if (creature.FactionID == NWN2Faction.INVALID_FACTION_ID)
                {
                    log.WriteLine("ERROR: Creature \"{0}\" has an invalid faction.", reference);
                }

                // Check for common perception range problems.
                if (creature.PerceptionRange.Row != 17 && creature.PerceptionRange.Row != 18)
                {
                    log.WriteLine("WARNING: Creature \"{0}\" has a non-standard perception range. Use a suggested value of Player-5 or Player-10.", reference);
                }

                // Check for a walk rate equal to players.
                if (creature.WalkRate.Row == 0 || creature.WalkRate.Row == 19)
                {
                    log.WriteLine("WARNING: Creature \"{0}\" has a walk rate equal to players. This creature will have infinite attacks of opportunity against retreating PCs.", reference);
                }
            }
            catch (Exception exception)
            {
                log.WriteLine("EXCEPTION: Error while handling \"{0}\":\n{1}", reference, exception.Message);
            }
        }

        private void Validate(NWN2WaypointBlueprint waypoint)
        {
            // Custom validation of only blueprints here.


            // Validation of all NWN2WaypointTemplates (in areas, blueprints).
            Validate((NWN2WaypointTemplate)waypoint, waypoint.ResourceName.ToString());
        }

        private void Validate(NWN2WaypointInstance waypoint)
        {
            // Custom validation of only instances here.


            // Validation of all NWN2WaypointTemplates (in areas, blueprints).
            Validate((NWN2WaypointTemplate)waypoint, waypoint.Tag);
        }

        private void Validate(NWN2WaypointTemplate waypoint, string reference)
        {
            try
            {
                // Check for common errors in the ACR_Spawn system.
                if (waypoint.Variables.GetVariable("ACR_SPAWN_TYPE") != null)
                {
                    // Check variable types.
                    ValidateVariableType(reference, waypoint, "ACR_SPAWN_TYPE", NWN2ScriptVariableType.Int);
                    ValidateVariableType(reference, waypoint, "ACR_SPAWN_RESNAMES_MIN", NWN2ScriptVariableType.Int);
                    ValidateVariableType(reference, waypoint, "ACR_SPAWN_RESNAMES_MAX", NWN2ScriptVariableType.Int);
                    ValidateVariableType(reference, waypoint, "ACR_SPAWN_RESPAWN_COUNT", NWN2ScriptVariableType.Int);
                    ValidateVariableType(reference, waypoint, "ACR_RESPAWN_DELAY_MIN", NWN2ScriptVariableType.Float);
                    ValidateVariableType(reference, waypoint, "ACR_RESPAWN_DELAY_MAX", NWN2ScriptVariableType.Float);
                    ValidateVariableType(reference, waypoint, "ACR_SPAWN_CHANCE", NWN2ScriptVariableType.Float);
                    ValidateVariableType(reference, waypoint, "ACR_SPAWN_RANDOM_RADIUS", NWN2ScriptVariableType.Float);
                    ValidateVariableType(reference, waypoint, "ACR_SPAWN_RANDOM_RANGE", NWN2ScriptVariableType.Float);
                    ValidateVariableType(reference, waypoint, "ACR_SPAWN_IN_VFX", NWN2ScriptVariableType.Int);
                    ValidateVariableType(reference, waypoint, "ACR_SPAWN_VFX", NWN2ScriptVariableType.Int);
                    ValidateVariableType(reference, waypoint, "ACR_SPAWN_IN_SFX", NWN2ScriptVariableType.String);
                    ValidateVariableType(reference, waypoint, "ACR_SPAWN_SFX", NWN2ScriptVariableType.String);
                    ValidateVariableType(reference, waypoint, "ACR_SPAWN_ANIMATION", NWN2ScriptVariableType.String);
                    ValidateVariableType(reference, waypoint, "ACR_SPAWN_IN_HOUR", NWN2ScriptVariableType.Int);
                    ValidateVariableType(reference, waypoint, "ACR_SPAWN_OUT_HOUR", NWN2ScriptVariableType.Int);
                    ValidateVariableType(reference, waypoint, "ACR_SPAWN_IN_DAY", NWN2ScriptVariableType.Int);
                    ValidateVariableType(reference, waypoint, "ACR_SPAWN_OUT_DAY", NWN2ScriptVariableType.Int);
                    ValidateVariableType(reference, waypoint, "ACR_SPAWN_IN_MONTH", NWN2ScriptVariableType.Int);
                    ValidateVariableType(reference, waypoint, "ACR_SPAWN_OUT_MONTH", NWN2ScriptVariableType.Int);
                    ValidateVariableType(reference, waypoint, "ACR_SPAWN_IN_PC_SIGHT", NWN2ScriptVariableType.Int);
                    ValidateVariableType(reference, waypoint, "ACR_SPAWN_ONLY_WHEN_NO_PC_IN_AREA", NWN2ScriptVariableType.Int);
                    ValidateVariableType(reference, waypoint, "ACR_SPAWN_WITH_ANIMATION", NWN2ScriptVariableType.Int);
                    ValidateVariableType(reference, waypoint, "ACR_SPAWN_IS_DISABLED", NWN2ScriptVariableType.Int);
                    ValidateVariableType(reference, waypoint, "ACR_SPAWN_RANDOM_FACING", NWN2ScriptVariableType.Int);
                    ValidateVariableType(reference, waypoint, "ACR_SPAWN_IN_STEALTH", NWN2ScriptVariableType.Int);
                    ValidateVariableType(reference, waypoint, "ACR_SPAWN_IN_DETECT", NWN2ScriptVariableType.Int);
                    ValidateVariableType(reference, waypoint, "ACR_SPAWN_BUFFED", NWN2ScriptVariableType.Int);
                    ValidateVariableType(reference, waypoint, "ACR_COLOR_NAME", NWN2ScriptVariableType.String);

                    // Check variable bounds.
                    ValidateVariableBounds(reference, waypoint, "ACR_SPAWN_TYPE", 0, 8);
                    ValidateVariableBounds(reference, waypoint, "ACR_SPAWN_RESNAMES_MIN", 0, 31);
                    ValidateVariableBounds(reference, waypoint, "ACR_SPAWN_RESNAMES_MAX", 0, 31);
                    ValidateVariableBounds(reference, waypoint, "ACR_SPAWN_CHANCE", 0.0f, 100.0f);
                    if (!GetAreVariablesEqual(waypoint, "ACR_SPAWN_IN_HOUR", "ACR_SPAWN_OUT_HOUR"))
                    {
                        ValidateVariableBounds(reference, waypoint, "ACR_SPAWN_IN_HOUR", 0, 23);
                        ValidateVariableBounds(reference, waypoint, "ACR_SPAWN_OUT_HOUR", 0, 23);
                    }
                    if (!GetAreVariablesEqual(waypoint, "ACR_SPAWN_IN_DAY", "ACR_SPAWN_OUT_DAY"))
                    {
                        ValidateVariableBounds(reference, waypoint, "ACR_SPAWN_IN_DAY", 1, 31);
                        ValidateVariableBounds(reference, waypoint, "ACR_SPAWN_OUT_DAY", 1, 31);
                    }
                    if (!GetAreVariablesEqual(waypoint, "ACR_SPAWN_IN_MONTH", "ACR_SPAWN_OUT_MONTH"))
                    {
                        ValidateVariableBounds(reference, waypoint, "ACR_SPAWN_IN_MONTH", 1, 12);
                        ValidateVariableBounds(reference, waypoint, "ACR_SPAWN_OUT_MONTH", 1, 12);
                    }
                }
            }
            catch (Exception exception)
            {
                log.WriteLine(String.Format("EXCEPTION: Error while handling \"{0}\":\n{1}", reference, exception.Message));
            }
        }

        /// <summary>
        /// Verifies that a given variable on an object is of the correct type.
        /// </summary>
        /// <param name="enforce">If true, this function will try to fix the variable's type.</param>
        private void ValidateVariableType(string reference, NWN2WaypointTemplate waypoint, string variable, NWN2ScriptVariableType type, bool enforce = true)
        {
            if (waypoint == null) return;
            if (waypoint.Variables.GetVariable(variable) == null) return;
            if (waypoint.Variables.GetVariable(variable).VariableType != type)
            {
                if (enforce)
                {
                    waypoint.Variables.GetVariable(variable).VariableType = type;
                    log.WriteLine("FIXED: Waypoint blueprint \"{0}\" has variable \"{1}\" not of type {2}.", reference, variable, type.ToString());
                }
                else
                {
                    log.WriteLine("ERROR: Waypoint blueprint \"{0}\" has variable \"{1}\" not of type {2}.", reference, variable, type.ToString());
                }
            }
        }

        /// <summary>
        /// Verifies that a given variable on an object is inclusively between two values.
        /// </summary>
        private void ValidateVariableBounds(string reference, NWN2WaypointTemplate waypoint, string variable, int min, int max)
        {
            if (waypoint == null) return;
            if (waypoint.Variables.GetVariable(variable) == null) return;
            if (waypoint.Variables.GetVariable(variable).VariableType != NWN2ScriptVariableType.Int) return;
            if (waypoint.Variables.GetVariable(variable).ValueInt < min || waypoint.Variables.GetVariable(variable).ValueInt > max)
            {
                log.WriteLine("ERROR: Waypoint blueprint \"{0}\" has variable \"{1}\" of value {2} outside of bounds [{3},{4}].", reference, variable, waypoint.Variables.GetVariable(variable).ValueInt, min, max);
            }
        }
        private void ValidateVariableBounds(string reference, NWN2WaypointTemplate waypoint, string variable, float min, float max)
        {
            if (waypoint == null) return;
            if (waypoint.Variables.GetVariable(variable) == null) return;
            if (waypoint.Variables.GetVariable(variable).VariableType != NWN2ScriptVariableType.Float) return;
            if (waypoint.Variables.GetVariable(variable).ValueFloat < min || waypoint.Variables.GetVariable(variable).ValueFloat > max)
            {
                log.WriteLine("ERROR: Waypoint blueprint \"{0}\" has variable \"{1}\" of value {2} outside of bounds [{3},{4}].", reference, variable, waypoint.Variables.GetVariable(variable).ValueFloat, min, max);
            }
        }

        /// <summary>
        /// Determines if a given variable on an object matches another.
        /// </summary>
        private bool GetAreVariablesEqual(NWN2WaypointTemplate waypoint, string variable1, string variable2)
        {
            if (waypoint == null) return true;
            if (waypoint.Variables.GetVariable(variable1) == null && waypoint.Variables.GetVariable(variable2) == null) return true;
            if (waypoint.Variables.GetVariable(variable1) == null || waypoint.Variables.GetVariable(variable2) == null) return false;
            if (waypoint.Variables.GetVariable(variable1).VariableType != waypoint.Variables.GetVariable(variable2).VariableType) return false;
            switch (waypoint.Variables.GetVariable(variable1).VariableType)
            {
                case NWN2ScriptVariableType.Float:
                    return (waypoint.Variables.GetVariable(variable1).ValueFloat == waypoint.Variables.GetVariable(variable2).ValueFloat);
                case NWN2ScriptVariableType.Int:
                    return (waypoint.Variables.GetVariable(variable1).ValueInt == waypoint.Variables.GetVariable(variable2).ValueInt);
                case NWN2ScriptVariableType.Location:
                    return (waypoint.Variables.GetVariable(variable1).ValueLocation == waypoint.Variables.GetVariable(variable2).ValueLocation);
                case NWN2ScriptVariableType.String:
                    return (waypoint.Variables.GetVariable(variable1).ValueString == waypoint.Variables.GetVariable(variable2).ValueString);
            }
            return false;
        }
    }
}
