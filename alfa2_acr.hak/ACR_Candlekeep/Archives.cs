using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;
using System.Threading;
using OEIShared.IO;
using OEIShared.IO.GFF;

namespace ACR_Candlekeep
{
    public class Archives : ALFA.Shared.IInformationStore, ALFA.Shared.IBackgroundLoadedResource, IDisposable
    {

        /// <summary>
        /// Instantiate a new Archives object.
        /// </summary>
        /// <param name="ArchiveWorker">Supplies the Archivist worker instance
        /// that is used to satisfy resource requests.</param>
        public Archives(Archivist ArchiveWorker)
        {
            this.ArchiveWorker = ArchiveWorker;
        }

        private volatile bool _resourcesLoaded = false;
        /// <summary>
        /// Wait for resources to become available.
        /// </summary>
        /// <param name="Wait">Supplies true to perform a blocking wait, else
        /// false to return immediately with the current availability status.
        /// </param>
        /// <returns>True if the resources are available to be accessed, else
        /// false if they are not yet loaded.</returns>
        public bool WaitForResourcesLoaded(bool Wait)
        {
            if (_resourcesLoaded) return true;
            return ResourcesLoadedEvent.WaitOne(Wait ? Timeout.Infinite : 0);
        }

        /// <summary>
        /// Dispose the object.
        /// </summary>
        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        /// <summary>
        /// Invoked to perform cleanup of the object.
        /// </summary>
        /// <param name="Disposing">Supplies true if cleanup is occuring for
        /// IDisposable.Dispose(), else false if cleanup is occuring for
        /// finalization (which must have skippsed IDisposable.Dispose() as the
        /// normal Dispose() path suppresses finalization).</param>
        private void Dispose(bool Disposing)
        {
            if (!Disposed)
            {
                if (Disposing)
                {
                    //
                    // Clean up managed resources.
                    //

                    ResourcesLoadedEvent.Dispose();
                }

                //
                // Clean up unmanaged resources.
                //

                Disposed = true;
            }
        }

        /// <summary>
        /// Finalizer; only invoked if IDisposable.Dispose() was not already
        /// invoked.  Joins common code at Dispose(bool) to clean up the
        /// object.
        /// </summary>
        ~Archives()
        {
            Dispose(false);
        }

        public string GetTalkString(uint Index)
        {
            return Archivist.GetTlkEntry(Index);
        }

        //
        // Getters for ALFA.Shared.IInformationStore.
        //
        // Get requests from within the current assembly are allowed before the
        // resources are marked loaded, to facilitate the internal
        // functionality of the Archivist background worker.
        //

        public Dictionary<string, ALFA.Shared.ItemResource> ModuleItems
        {
            get
            {
                if (_resourcesLoaded == false)
                {
                    if (Assembly.GetCallingAssembly() != Assembly.GetExecutingAssembly())
                    {
                        WaitForResourcesLoaded(true);
                    }
                }

                return this._ModuleItems;
            }
            set
            {
                this._ModuleItems = value;
            }
        }

        public Dictionary<string, ALFA.Shared.CreatureResource> ModuleCreatures
        {
            get
            {
                if (_resourcesLoaded == false)
                {
                    if (Assembly.GetCallingAssembly() != Assembly.GetExecutingAssembly())
                    {
                        WaitForResourcesLoaded(true);
                    }
                }

                return this._ModuleCreatures;
            }
            set
            {
                this._ModuleCreatures = value;
            }
        }

        public Dictionary<string, ALFA.Shared.LightResource> ModuleLights
        {
            get
            {
                if (_resourcesLoaded == false)
                {
                    if (Assembly.GetCallingAssembly() != Assembly.GetExecutingAssembly())
                    {
                        WaitForResourcesLoaded(true);
                    }
                }

                return this._ModuleLights;
            }
            set
            {
                this._ModuleLights = value;
            }
        }

        public Dictionary<string, ALFA.Shared.PlaceableResource> ModulePlaceables
        {
            get
            {
                if (_resourcesLoaded == false)
                {
                    if (Assembly.GetCallingAssembly() != Assembly.GetExecutingAssembly())
                    {
                        WaitForResourcesLoaded(true);
                    }
                }

                return this._ModulePlaceables;
            }
            set
            {
                this._ModulePlaceables = value;
            }
        }

        public Dictionary<string, ALFA.Shared.WaypointResource> ModuleWaypoints
        {
            get
            {
                if (_resourcesLoaded == false)
                {
                    if (Assembly.GetCallingAssembly() != Assembly.GetExecutingAssembly())
                    {
                        WaitForResourcesLoaded(true);
                    }
                }

                return this._ModuleWaypoints;
            }
            set
            {
                this._ModuleWaypoints = value;
            }
        }

        public Dictionary<string, ALFA.Shared.VisualEffectResource> ModuleVisualEffects
        {
            get
            {
                if (_resourcesLoaded == false)
                {
                    if (Assembly.GetCallingAssembly() != Assembly.GetExecutingAssembly())
                    {
                        WaitForResourcesLoaded(true);
                    }
                }

                return this._ModuleVisualEffects;
            }
            set
            {
                this._ModuleVisualEffects = value;
            }
        }

        public Dictionary<string, ALFA.Shared.TrapResource> ModuleTraps
        {
            get
            {
                if (_resourcesLoaded == false)
                {
                    if (Assembly.GetCallingAssembly() != Assembly.GetExecutingAssembly())
                    {
                        WaitForResourcesLoaded(true);
                    }
                }

                return this._ModuleTraps;
            }
            set
            {
                this._ModuleTraps = value;
            }
        }

        public Dictionary<int, ALFA.Shared.Faction> ModuleFactions
        {
            get
            {
                if (_resourcesLoaded == false)
                {
                    if (Assembly.GetCallingAssembly() != Assembly.GetExecutingAssembly())
                    {
                        WaitForResourcesLoaded(true);
                    }
                }

                return this._ModuleFactions;
            }
            set
            {
                this._ModuleFactions = value;
            }
        }


        public Dictionary<uint, ALFA.Shared.ActiveArea> ActiveAreas { get; set; }


        public Dictionary<string, ALFA.Shared.ActiveTrap> SpawnedTrapTriggers
        {
            get
            {
                if (_resourcesLoaded == false)
                {
                    if (Assembly.GetCallingAssembly() != Assembly.GetExecutingAssembly())
                    {
                        WaitForResourcesLoaded(true);
                    }
                }

                return this._SpawnedTrapTriggers;
            }
            set
            {
                this._SpawnedTrapTriggers = value;
            }
        }

        public Dictionary<string, ALFA.Shared.ActiveTrap> SpawnedTrapDetect
        {
            get
            {
                if (_resourcesLoaded == false)
                {
                    if (Assembly.GetCallingAssembly() != Assembly.GetExecutingAssembly())
                    {
                        WaitForResourcesLoaded(true);
                    }
                }

                return this._SpawnedTrapDetect;
            }
            set
            {
                this._SpawnedTrapDetect = value;
            }
        }


        public Dictionary<string, GFFFile> ModifiedGff { get; set; }


        public List<ALFA.Shared.Spell> CoreSpells
        {
            get
            {
                if (_resourcesLoaded == false)
                {
                    if (Assembly.GetCallingAssembly() != Assembly.GetExecutingAssembly())
                    {
                        WaitForResourcesLoaded(true);
                    }
                }

                return this._CoreSpells;
            }
            set
            {
                this._CoreSpells = value;
            }
        }

        public List<ALFA.Shared.SpellCastItemProperties> IPCastSpells
        {
            get
            {
                if (_resourcesLoaded == false)
                {
                    if (Assembly.GetCallingAssembly() != Assembly.GetExecutingAssembly())
                    {
                        WaitForResourcesLoaded(true);
                    }
                }

                return this._IPCastSpells;
            }
            set
            {
                this._IPCastSpells = value;
            }
        }

        public List<ALFA.Shared.BaseItem> BaseItems
        {
            get
            {
                if (_resourcesLoaded == false)
                {
                    if (Assembly.GetCallingAssembly() != Assembly.GetExecutingAssembly())
                    {
                        WaitForResourcesLoaded(true);
                    }
                }

                return this._BaseItems;
            }
            set
            {
                this._BaseItems = value;
            }
        }

        public ALFA.ResourceManager Resources
        {
            get
            {
                if (_resourcesLoaded == false)
                {
                    if (Assembly.GetCallingAssembly() != Assembly.GetExecutingAssembly())
                    {
                        WaitForResourcesLoaded(true);
                    }
                }

                return this._Resources;
            }
            set
            {
                this._Resources = value;
            }
        }

        public Dictionary<string, string> AreaNames
        {
            get
            {
                if (_resourcesLoaded == false)
                {
                    if (Assembly.GetCallingAssembly() != Assembly.GetExecutingAssembly())
                    {
                        WaitForResourcesLoaded(true);
                    }
                }

                return this._AreaNames;
            }
            set
            {
                this._AreaNames = value;
            }
        }


        /// <summary>
        /// Mark resources as fully loaded after initialization completes.
        /// </summary>
        internal void SetResourcesLoaded()
        {
            ResourcesLoadedEvent.Set();
            _resourcesLoaded = true;
        }

        /// <summary>
        /// The wait event used to signal resource load completion.
        /// </summary>
        private ManualResetEvent ResourcesLoadedEvent = new ManualResetEvent(false);
        /// <summary>
        /// True if the disposer has run.
        /// </summary>
        private bool Disposed = false;

        /// <summary>
        /// The archive worker object.
        /// </summary>
        private Archivist ArchiveWorker;

        //
        // Published data elements backing properties for
        // ALFA.Shared.Modules.InfoStore.
        //

        private Dictionary<string, ALFA.Shared.ItemResource> _ModuleItems;
        private Dictionary<string, ALFA.Shared.CreatureResource> _ModuleCreatures;
        private Dictionary<string, ALFA.Shared.LightResource> _ModuleLights;
        private Dictionary<string, ALFA.Shared.PlaceableResource> _ModulePlaceables;
        private Dictionary<string, ALFA.Shared.WaypointResource> _ModuleWaypoints;
        private Dictionary<string, ALFA.Shared.VisualEffectResource> _ModuleVisualEffects;
        private Dictionary<string, ALFA.Shared.TrapResource> _ModuleTraps;
        private Dictionary<int, ALFA.Shared.Faction> _ModuleFactions;

        private Dictionary<string, ALFA.Shared.ActiveTrap> _SpawnedTrapTriggers;
        private Dictionary<string, ALFA.Shared.ActiveTrap> _SpawnedTrapDetect;

        private List<ALFA.Shared.Spell> _CoreSpells;
        private List<ALFA.Shared.SpellCastItemProperties> _IPCastSpells;
        private List<ALFA.Shared.BaseItem> _BaseItems;

        private Dictionary<string, string> _AreaNames;

        private ALFA.ResourceManager _Resources;
    }
}
