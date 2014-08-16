using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;

namespace ALFA.Shared
{
    /// <summary>
    /// This class provides linkage between different modules in the ACR
    /// system.  It can be used to share data elements between different script
    /// modules in a single-instanced way.
    /// </summary>
    public static class ModuleLinkage
    {
        /// <summary>
        /// The list of known assemblies supplied by the ACR_AssemblyLoader.
        /// </summary>
        public static IList<Assembly> KnownAssemblies { get; set; }

        /// <summary>
        /// The list of known resources supplied by the ACR_AssemblyLoader.
        /// </summary>
        public static IDictionary<string, byte[]> KnownResources { get; set; }

        /// <summary>
        /// The default database object.  This is set by ACR_ServerMisc when
        /// acr_mod_events_i's _LoadAssemblies() calls acr_db_persist_i's
        /// ACR_InitializeDatabase().
        /// </summary>
        public static IALFADatabase DefaultDatabase { get; set; }
    }
}
