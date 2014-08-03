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
        /// Verifies that a given variable on a waypoint is of the correct type.
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
                    log.WriteLine("FIXED: Waypoint blueprint \"" + waypoint.ResourceName + "\" had variable \"" + variable + "\" not of type " + type.ToString());
                }
                else
                {
                    log.WriteLine("ERROR: Waypoint blueprint \"" + waypoint.ResourceName + "\" has variable \"" + variable + "\" not of type " + type.ToString());
                }
            }
        }
    }
}
