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
        /// known assembly cache.  Note that these assembles must be loaded in
        /// the proper order, that is, base assemblies before dependant
        /// assemblies.
        /// </summary>
        void PopulateKnownAssemblies()
        {
            Assembly ALFA_Shared;

            //
            // Load additional support assemblies.  The order to add these can
            // be discovered by going to Tools, NuGet Package Manager,
            // Package Visualizer.  The graph must be added in bottom up order.
            //

            KnownAssemblies.Add(Assembly.Load(Properties.Resources.Microsoft_Data_Edm));
            KnownAssemblies.Add(Assembly.Load(Properties.Resources.System_Spatial));
            KnownAssemblies.Add(Assembly.Load(Properties.Resources.Microsoft_Data_OData));
            KnownAssemblies.Add(Assembly.Load(Properties.Resources.Microsoft_Data_Services_Client));
            KnownAssemblies.Add(Assembly.Load(Properties.Resources.Microsoft_WindowsAzure_ConfigurationManager));
            KnownAssemblies.Add(Assembly.Load(Properties.Resources.Newtonsoft_Json));
            KnownAssemblies.Add(Assembly.Load(Properties.Resources.Microsoft_WindowsAzure_Storage));

            //
            // Load ALFA.Shared.dll from the byte array attached to the
            // assembly resources, and add it to the known assembly cache.
            //

            KnownAssemblies.Add(ALFA_Shared = Assembly.Load(Properties.Resources.ALFA_Shared));

            KnownResources.Add("SGTatham_Plink", Properties.Resources.SGTatham_Plink);

            //
            // Export KnownAssemblies and KnownResources to ALFA.Shared for
            // other components to use.  Note that since ALFA.Shared is loaded
            // by the AssemblyLoader, the AssemblyLoader itself cannot contain
            // a static bound reference to ALFA.Shared; instead, the references
            // must be dynamically satisfied via Reflection.
            //

            Type ModuleLinkage = ALFA_Shared.GetType("ALFA.Shared.ModuleLinkage", true);

            ModuleLinkage.GetProperty("KnownAssemblies").SetValue(null, KnownAssemblies, null);
            ModuleLinkage.GetProperty("KnownResources").SetValue(null, KnownResources, null);
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

            if (Asm != null)
                return Asm;

            //
            // Some assemblies may depend on a compatibility search via an
            // app.config file.  Since these are not visible to the framework
            // for CLRScript assemblies, fall back to a loose search via same
            // assembly name and public key token.
            //

            AssemblyName SearchName = new AssemblyName(args.Name);

            Asm = KnownAssemblies.Where(x => x.GetName().Name == SearchName.Name && 
                x.GetName().CultureInfo.Name == SearchName.CultureInfo.Name &&
                x.GetName().Version >= SearchName.Version &&
                x.GetName().GetPublicKeyToken().SequenceEqual(SearchName.GetPublicKeyToken())).FirstOrDefault();

            if (Asm != null)
                return Asm;

            return null;
        }

        /// <summary>
        /// The list of known assemblies that can be used to satisfy assembly
        /// resolution.
        /// </summary>
        List<Assembly> KnownAssemblies = new List<Assembly>();

        /// <summary>
        /// The list of known resource elements.
        /// </summary>
        Dictionary<string, byte[]> KnownResources = new Dictionary<string, byte[]>();
    }
}
