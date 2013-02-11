using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;

namespace ACR_AssemblyLoader
{
    /// <summary>
    /// This class handles assembly resolution of common assemblies that may
    /// be referenced by ALFA CLRScript instances.
    /// </summary>
    class AssemblyLoader
    {

        public AssemblyLoader()
        {
            AppDomain CurrentDomain = AppDomain.CurrentDomain;

            PopulateKnownAssemblies();

            CurrentDomain.AssemblyResolve += new ResolveEventHandler(CurrentDomain_AssemblyResolve);
        }

        /// <summary>
        /// This method loads known assemblies and prepopulates them in the
        /// known assembly cache.
        /// </summary>
        void PopulateKnownAssemblies()
        {
            //
            // Load ALFA.Shared.dll from the byte array attached to the
            // assembly resources, and add it to the known assembly cache.
            //

            KnownAssemblies.Add(Assembly.Load(Properties.Resources.ALFA_Shared));
        }

        /// <summary>
        /// This method attempts to resolve known assemblies on behalf of CLR
        /// scripts.
        /// </summary>
        /// <param name="sender">Supplies the sending object.</param>
        /// <param name="args">Supplies arguments.</param>
        /// <returns>If the assembly is manually resolved, the assembly object
        /// is returned.  Otherwise, null is returned.</returns>
        Assembly CurrentDomain_AssemblyResolve(object sender, ResolveEventArgs args)
        {
            //
            // Search the known assembly cache for a match for the full name of
            // the assembly.  If no assembly is found, then null is returned.
            // If a matching assembly is found, then it is used to satisfy the
            // assembly resolution request.
            //

            Assembly Asm = KnownAssemblies.Where(x => x.FullName == args.Name).FirstOrDefault();

            if (Asm == null)
                return null;

            return Asm;
        }

        /// <summary>
        /// The list of known assemblies that can be used to satisfy assembly
        /// resolution.
        /// </summary>
        List<Assembly> KnownAssemblies = new List<Assembly>();
    }
}
