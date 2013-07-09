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

namespace ACR_Candlekeep
{
    public partial class ACR_Candlekeep : CLRScriptBase, IGeneratedScriptProgram
    {
        public ACR_Candlekeep([In] NWScriptJITIntrinsics Intrinsics, [In] INWScriptProgram Host)
        {
            InitScript(Intrinsics, Host);
        }

        private ACR_Candlekeep([In] ACR_Candlekeep Other)
        {
            InitScript(Other);

            LoadScriptGlobals(Other.SaveScriptGlobals());
        }

        public static Type[] ScriptParameterTypes =
        { typeof(int) };

        public Int32 ScriptMain([In] object[] ScriptParameters, [In] Int32 DefaultReturnCode)
        {
            int Value = (int)ScriptParameters[0]; // ScriptParameterTypes[0] is typeof(int)

            switch ((Commands)Value)
            {
                case Commands.INITIALIZE_ARCHIVES:
                        Archivist worker = new Archivist();
                        if (ArchivesInstance != null)
                            break;

                        ArchivesInstance = new Archives(worker);
                        ALFA.Shared.Modules.InfoStore = ArchivesInstance;
                        worker.DoWork += worker.InitializeArchives;
                        worker.RunWorkerAsync();

                        Monks.LoadAreas(this);

                        ShowLoadingProgressDebugString();

                        break;
                case Commands.PRINT_DEBUG:
                        SendMessageToAllDMs("Running ACR_Candlekeep");
                        SendMessageToAllDMs(Archivist.debug);
                        break;
                case Commands.LIST_AREAS:
                        foreach (ALFA.Shared.ActiveArea area in ALFA.Shared.Modules.InfoStore.ActiveAreas.Values)
                        {
                            SendMessageToAllDMs(area.Name);
                            foreach (ALFA.Shared.ActiveArea areaTarget in area.ExitTransitions.Values)
                            {
                                SendMessageToAllDMs(String.Format(" - {0}", areaTarget.Name));
                            }
                        }
                        break;
                case Commands.LIST_SPELLS:
                    foreach(ALFA.Shared.SpellCastItemProperties ip in ALFA.Shared.Modules.InfoStore.IPCastSpells)
                    {
                        SendMessageToAllDMs(ip.ToString());
                    }
                    break;
            }

            return 0;
        }

        /// <summary>
        /// Periodically poll the loading status string and output it to the
        /// debug console while loading is still in progress.
        /// </summary>
        private void ShowLoadingProgressDebugString()
        {
            //
            // Obtain the current debug string if present (and reset it to the
            // empty string if it was set).  If a debug string snippet was
            // obtained, display it to the debug console.
            //

#pragma warning disable 420
            string DebugString = Interlocked.Exchange(ref Archivist.debug, "");
#pragma warning restore 420

            if (!String.IsNullOrEmpty(DebugString))
                WriteTimestampedLogEntry("ACR_Candlekeep: " + DebugString);

            if (ArchivesInstance.WaitForResourcesLoaded(false) == false)
                DelayCommand(1.0f, delegate() { ShowLoadingProgressDebugString(); });
            else
                WriteTimestampedLogEntry("ACR_Candlekeep: Resource loading complete.");
        }

        internal static Archives ArchivesInstance;

        enum Commands
        {
            INITIALIZE_ARCHIVES = 0,
            PRINT_DEBUG = 1,
            LIST_AREAS = 2,
            LIST_SPELLS = 3,
        }
    }
}
