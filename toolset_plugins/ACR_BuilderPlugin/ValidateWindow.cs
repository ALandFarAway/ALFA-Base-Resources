using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Threading;
using System.Windows.Forms;

using NWN2Toolset.NWN2.Data;
using NWN2Toolset.NWN2.Data.Blueprints;
using NWN2Toolset.NWN2.Data.Templates;
using NWN2Toolset.NWN2.Data.TypedCollections;

namespace ACR_BuilderPlugin
{
    public partial class ValidateWindow : Form
    {
        System.IO.StreamWriter log = null;

        public ValidateWindow()
        {
            InitializeComponent();
        }

        public void Run()
        {
            bwMain.RunWorkerAsync();
        }

        //
        // Main work thread.
        //

        /// <summary>
        /// Main work thread for the validation of module content.
        /// </summary>
        private void bwMain_DoWork(object sender, DoWorkEventArgs e)
        {
            // Counters and commonly used variables.
            int i = 0;
            int count = 0;
            NWN2BlueprintCollection bpCollection;

            // Open our log file.
            log = new System.IO.StreamWriter("acr_validation.log");
            log.WriteLine("ACR Validation Tool - Log");

            #region Validate waypoint blueprints.
            log.WriteLine("\nValidating blueprints: Waypoints");
            pbOverall.Value = 66;
            lbCurrentTask.Text = "Validating waypoint blueprints...";
            bpCollection = NWN2GlobalBlueprintManager.GetBlueprintsOfType(NWN2ObjectType.Waypoint);
            i = 0;
            count = bpCollection.Count;
            foreach (NWN2WaypointBlueprint waypoint in bpCollection)
            {
                // Check for common errors in the ACR_Spawn system.
                if (waypoint.Variables.GetVariable("ACR_SPAWN_TYPE") != null)
                {
                    // Check variable types.
                    ValidateVariableType(waypoint, "ACR_SPAWN_TYPE", NWN2ScriptVariableType.Int);
                    ValidateVariableType(waypoint, "ACR_SPAWN_RESNAMES_MIN", NWN2ScriptVariableType.Int);
                    ValidateVariableType(waypoint, "ACR_SPAWN_RESNAMES_MAX", NWN2ScriptVariableType.Int);
                    ValidateVariableType(waypoint, "ACR_SPAWN_RESPAWN_COUNT", NWN2ScriptVariableType.Int);
                    ValidateVariableType(waypoint, "ACR_RESPAWN_DELAY_MIN", NWN2ScriptVariableType.Float);
                    ValidateVariableType(waypoint, "ACR_RESPAWN_DELAY_MAX", NWN2ScriptVariableType.Float);
                    ValidateVariableType(waypoint, "ACR_SPAWN_CHANCE", NWN2ScriptVariableType.Float);
                    ValidateVariableType(waypoint, "ACR_SPAWN_RANDOM_RADIUS", NWN2ScriptVariableType.Float);
                    ValidateVariableType(waypoint, "ACR_SPAWN_RANDOM_RANGE", NWN2ScriptVariableType.Float);
                    ValidateVariableType(waypoint, "ACR_SPAWN_IN_VFX", NWN2ScriptVariableType.Int);
                    ValidateVariableType(waypoint, "ACR_SPAWN_VFX", NWN2ScriptVariableType.Int);
                    ValidateVariableType(waypoint, "ACR_SPAWN_IN_SFX", NWN2ScriptVariableType.String);
                    ValidateVariableType(waypoint, "ACR_SPAWN_SFX", NWN2ScriptVariableType.String);
                    ValidateVariableType(waypoint, "ACR_SPAWN_ANIMATION", NWN2ScriptVariableType.String);
                    ValidateVariableType(waypoint, "ACR_SPAWN_IN_HOUR", NWN2ScriptVariableType.Int);
                    ValidateVariableType(waypoint, "ACR_SPAWN_OUT_HOUR", NWN2ScriptVariableType.Int);
                    ValidateVariableType(waypoint, "ACR_SPAWN_IN_DAY", NWN2ScriptVariableType.Int);
                    ValidateVariableType(waypoint, "ACR_SPAWN_OUT_DAY", NWN2ScriptVariableType.Int);
                    ValidateVariableType(waypoint, "ACR_SPAWN_IN_MONTH", NWN2ScriptVariableType.Int);
                    ValidateVariableType(waypoint, "ACR_SPAWN_OUT_MONTH", NWN2ScriptVariableType.Int);
                    ValidateVariableType(waypoint, "ACR_SPAWN_IN_PC_SIGHT", NWN2ScriptVariableType.Int);
                    ValidateVariableType(waypoint, "ACR_SPAWN_ONLY_WHEN_NO_PC_IN_AREA", NWN2ScriptVariableType.Int);
                    ValidateVariableType(waypoint, "ACR_SPAWN_WITH_ANIMATION", NWN2ScriptVariableType.Int);
                    ValidateVariableType(waypoint, "ACR_SPAWN_IS_DISABLED", NWN2ScriptVariableType.Int);
                    ValidateVariableType(waypoint, "ACR_SPAWN_RANDOM_FACING", NWN2ScriptVariableType.Int);
                    ValidateVariableType(waypoint, "ACR_SPAWN_IN_STEALTH", NWN2ScriptVariableType.Int);
                    ValidateVariableType(waypoint, "ACR_SPAWN_IN_DETECT", NWN2ScriptVariableType.Int);
                    ValidateVariableType(waypoint, "ACR_SPAWN_BUFFED", NWN2ScriptVariableType.Int);
                    ValidateVariableType(waypoint, "ACR_COLOR_NAME", NWN2ScriptVariableType.String);

                    // Check variable bounds.
                    ValidateVariableBounds(waypoint, "ACR_SPAWN_TYPE", 0, 8);
                    ValidateVariableBounds(waypoint, "ACR_SPAWN_RESNAMES_MIN", 0, 31);
                    ValidateVariableBounds(waypoint, "ACR_SPAWN_RESNAMES_MAX", 0, 31);
                    ValidateVariableBounds(waypoint, "ACR_SPAWN_CHANCE", 0.0f, 100.0f);
                    if (!GetAreVariablesEqual(waypoint, "ACR_SPAWN_IN_HOUR", "ACR_SPAWN_OUT_HOUR"))
                    {
                        ValidateVariableBounds(waypoint, "ACR_SPAWN_IN_HOUR", 0, 23);
                        ValidateVariableBounds(waypoint, "ACR_SPAWN_OUT_HOUR", 0, 23);
                    }
                    if (!GetAreVariablesEqual(waypoint, "ACR_SPAWN_IN_DAY", "ACR_SPAWN_OUT_DAY"))
                    {
                        ValidateVariableBounds(waypoint, "ACR_SPAWN_IN_DAY", 1, 31);
                        ValidateVariableBounds(waypoint, "ACR_SPAWN_OUT_DAY", 1, 31);
                    }
                    if (!GetAreVariablesEqual(waypoint, "ACR_SPAWN_IN_MONTH", "ACR_SPAWN_OUT_MONTH"))
                    {
                        ValidateVariableBounds(waypoint, "ACR_SPAWN_IN_MONTH", 1, 12);
                        ValidateVariableBounds(waypoint, "ACR_SPAWN_OUT_MONTH", 1, 12);
                    }
                }

                // Report progress.
                i++;
                bwMain.ReportProgress(100 * i / count, "Validating \"" + waypoint.ResourceName.ToString() + "\"");
            }
            #endregion

            // Open the log file.
            log.WriteLine("\nValidation complete.");
            log.Close();
            System.Diagnostics.Process.Start("acr_validation.log");
        }

        /// <summary>
        /// 
        /// </summary>
        private void bwMain_ProgressChanged(object sender, ProgressChangedEventArgs e)
        {
            pbCurrent.Value = e.ProgressPercentage;
            if (e.UserState != null) lbCurrentDetail.Text = (string)e.UserState;
        }

        /// <summary>
        /// 
        /// </summary>
        private void bwMain_RunWorkerCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
            Close();
        }

        /// <summary>
        /// Verifies that a given variable on an object is of the correct type.
        /// </summary>
        /// <param name="enforce">If true, this function will try to fix the variable's type.</param>
        private void ValidateVariableType(NWN2WaypointBlueprint waypoint, string variable, NWN2ScriptVariableType type, bool enforce = true)
        {
            if (waypoint == null) return;
            if (waypoint.Variables.GetVariable(variable) == null) return;
            if (waypoint.Variables.GetVariable(variable).VariableType != type)
            {
                if (enforce)
                {
                    waypoint.Variables.GetVariable(variable).VariableType = type;
                    log.WriteLine(String.Format("FIXED: Waypoint blueprint \"{0}\" has variable \"{1}\" not of type {2}.", waypoint.ResourceName, variable, type.ToString()));
                }
                else
                {
                    log.WriteLine(String.Format("ERROR: Waypoint blueprint \"{0}\" has variable \"{1}\" not of type {2}.", waypoint.ResourceName, variable, type.ToString()));
                }
            }
        }

        /// <summary>
        /// Verifies that a given variable on an object is inclusively between two values.
        /// </summary>
        private void ValidateVariableBounds(NWN2WaypointBlueprint waypoint, string variable, int min, int max)
        {
            if (waypoint == null) return;
            if (waypoint.Variables.GetVariable(variable) == null) return;
            if (waypoint.Variables.GetVariable(variable).VariableType != NWN2ScriptVariableType.Int) return;
            if (waypoint.Variables.GetVariable(variable).ValueInt < min || waypoint.Variables.GetVariable(variable).ValueInt > max)
            {
                log.WriteLine(String.Format("ERROR: Waypoint blueprint \"{0}\" has variable \"{1}\" of value {2} outside of bounds [{3},{4}].", waypoint.ResourceName, variable, waypoint.Variables.GetVariable(variable).ValueInt, min, max));
            }
        }
        private void ValidateVariableBounds(NWN2WaypointBlueprint waypoint, string variable, float min, float max)
        {
            if (waypoint == null) return;
            if (waypoint.Variables.GetVariable(variable) == null) return;
            if (waypoint.Variables.GetVariable(variable).VariableType != NWN2ScriptVariableType.Float) return;
            if (waypoint.Variables.GetVariable(variable).ValueFloat < min || waypoint.Variables.GetVariable(variable).ValueFloat > max)
            {
                log.WriteLine(String.Format("ERROR: Waypoint blueprint \"{0}\" has variable \"{1}\" of value {2} outside of bounds [{3},{4}].", waypoint.ResourceName, variable, waypoint.Variables.GetVariable(variable).ValueFloat, min, max));
            }
        }

        /// <summary>
        /// Determines if a given variable on an object matches another.
        /// </summary>
        private bool GetAreVariablesEqual(NWN2WaypointBlueprint waypoint, string variable1, string variable2)
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
