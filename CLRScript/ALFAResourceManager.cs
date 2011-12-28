//
// This module contains logic for dealing with the game resource system.  The
// script has to link to OEIShared for this module to be usable.
// 

using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;
using System.Reflection;
using System.Reflection.Emit;
using System.IO;
using CLRScriptFramework;
using NWScript;
using NWScript.ManagedInterfaceLayer.NWScriptManagedInterface;
using OEIShared.IO;
using OEIShared.IO.ERF;
using OEIShared.IO.GFF;
using OEIShared.Utils;

using NWEffect = NWScript.NWScriptEngineStructure0;
using NWEvent = NWScript.NWScriptEngineStructure1;
using NWLocation = NWScript.NWScriptEngineStructure2;
using NWTalent = NWScript.NWScriptEngineStructure3;
using NWItemProperty = NWScript.NWScriptEngineStructure4;

namespace ALFA
{

    public class ResourceManager
    {

        /// <summary>
        /// Create a new ResourceManager instance.
        /// </summary>
        /// <param name="ModuleResName">Optionally supplies the resource name
        /// of the module.  If null, it will be attempted to be gotten from the
        /// command line of the server, but this can fail if the server was
        /// not started with -module on the command line.</param>
        public ResourceManager(string ModuleResName)
        {
            ModuleResourceName = ModuleResName;
        }

        /// <summary>
        /// This method opens module.ifo for read as a GFF reader.
        /// </summary>
        /// <returns>The GFF reader for module.ifo is returned.</returns>
        public GFFFile OpenModuleIfo()
        {
            IResourceEntry ResEntry = GetResource("module", ResIFO);

            if (ResEntry == null)
                return null;

            return new GFFFile(ResEntry.GetStream(false));
        }

        /// <summary>
        /// Get a resource by name.
        /// </summary>
        /// <param name="ResRef">Supplies the resref to open.</param>
        /// <param name="ResType">Supplies the restype code of the resource.</param>
        /// <returns>The resource entry is returned on success, else null if
        /// the resource didn't exist.</returns>
        public IResourceEntry GetResource(string ResRef, ushort ResType)
        {
            return GetResource(new OEIResRef(ResRef), ResType);
        }

        /// <summary>
        /// Get a resource by name.
        /// </summary>
        /// <param name="ResRef">Supplies the resref to open.</param>
        /// <param name="ResType">Supplies the restype code of the resource.</param>
        /// <returns>The resource entry is returned on success, else null if
        /// the resource didn't exist.</returns>
        public IResourceEntry GetResource(OEIResRef ResRef, ushort ResType)
        {
            IResourceEntry ResEntry;

            if (Repositories == null)
                LoadResourceRepositories();

            foreach (IResourceRepository Repository in Repositories)
            {
                ResEntry = Repository.FindResource(ResRef, ResType);

                if (ResEntry == null || ResEntry is MissingResourceEntry)
                    continue;

                return ResEntry;
            }

            return null;
        }

        /// <summary>
        /// Get a list of all resources of a given type.  Duplicates may exist
        /// in the returned list, but the list is ordered in priority order,
        /// with the first entry being the most precedent for a given name.
        /// </summary>
        /// <param name="ResType">Supplies the resource type to search for.</param>
        /// <returns>A list of all resources found with the given resource
        /// type code.</returns>
        public IEnumerable<IResourceEntry> GetResourcesByType(ushort ResType)
        {
            List<IResourceEntry> FoundResources = new List<IResourceEntry>();

            if (Repositories == null)
                LoadResourceRepositories();

            foreach (IResourceRepository Repository in Repositories)
            {
                foreach (IResourceEntry ResEntry in Repository.FindResourcesByType(ResType))
                {
                    FoundResources.Add(ResEntry);
                }
            }

            return FoundResources;
        }

        /// <summary>
        /// This method performs demand loading of resource repositories.
        /// </summary>
        private void LoadResourceRepositories()
        {
            string HomeDirectory = SystemInfo.GetHomeDirectory();
            string InstallDirectory = SystemInfo.GetGameInstallationDirectory();
            string ModPath;
            string DataPath;

            //
            // Create a dummy resource manager to keep OEIShared happy.  We do
            // not use it explicitly, but some OEIShared code uses
            // ResourceManager.Instance and hopes to get something back.
            //

            if (OEIShared.IO.ResourceManager.Instance == null)
                new DummyOEIResourceManager();

            if (ModuleResourceName == null)
                ModuleResourceName = SystemInfo.GetModuleResourceName();

            if (ModuleResourceName == null)
                throw new ApplicationException("Cannot determine module resource name.");

            Repositories = new List<ResourceRepository>();

            ModPath = String.Format("{0}\\modules\\{1}.mod", HomeDirectory, ModuleResourceName);

            if (File.Exists(ModPath))
            {
                Repositories.Add(new ERFResourceRepository(ModPath));
            }
            else
            {
                ModPath = String.Format("{0}\\modules\\{1}\\", HomeDirectory, ModuleResourceName);

                Repositories.Add(new DirectoryResourceRepository(ModPath));
            }

            AddModuleHaks(OpenModuleIfo(), HomeDirectory, InstallDirectory);

            foreach (string PathName in new string[] { HomeDirectory, InstallDirectory })
            {
                Repositories.Add(new DirectoryResourceRepository(String.Format("{0}\\override", PathName)));
            }

            DataPath = String.Format("{0}\\Data", InstallDirectory);

            foreach (string ZipPath in Directory.EnumerateFiles(DataPath, "*.zip"))
            {
                Repositories.Add(new ZIPResourceRepository(ZipPath));
            }

            //
            // Finally, populate all of the repositories, which may take time.
            //

            foreach (ResourceRepository Repository in Repositories)
            {
                Repository.PopulateRepository();
            }
        }

        /// <summary>
        /// This routine scans module.ifo for haks to add to the hak list.
        /// </summary>
        /// <param name="ModuleIfo">Supplies the module.ifo GFF reader.</param>
        /// <param name="HomeDirectory">Supplies the NWN2 home directory.</param>
        /// <param name="InstallDirectory">Supplies the NWN2 install directory.</param>
        private void AddModuleHaks(GFFFile ModuleIfo, string HomeDirectory, string InstallDirectory)
        {
            string[] SearchDirs = new string[] { HomeDirectory, InstallDirectory };
            GFFList HakList = ModuleIfo.TopLevelStruct.GetListSafe("Mod_HakList");
            List<string> HakFiles = new List<string>();

            if (HakList.StructList.Count == 0)
            {
                string Hak = ModuleIfo.TopLevelStruct.GetExoStringSafe("Mod_Hak").Value;

                if (!String.IsNullOrEmpty(Hak))
                {
                    HakFiles.Add(Hak);
                }
            }
            else
            {
                foreach (GFFStruct HakStruct in HakList.StructList)
                {
                    string Hak = HakStruct.GetExoStringSafe("Mod_Hak").Value;

                    if (String.IsNullOrEmpty(Hak))
                        continue;

                    HakFiles.Add(Hak);
                }
            }

            foreach (string Hak in HakFiles)
            {
                bool Added = false;

                foreach (string DirName in SearchDirs)
                {
                    string HakFileName = String.Format("{0}\\hak\\{1}.hak", DirName, Hak);

                    if (!File.Exists(HakFileName))
                        continue;

                    Repositories.Add(new ERFResourceRepository(HakFileName));
                    Added = true;
                    break;
                }

                if (!Added)
                    throw new ApplicationException("Couldn't locate hak " + Hak);
            }
        }

        //
        // Resource types for various extensions are listed here.
        //

	    public const ushort ResBMP  =    1;
	    public const ushort ResTGA  =    3;
	    public const ushort ResWAV  =    4;
	    public const ushort ResPLT  =    6;
	    public const ushort ResINI  =    7;
	    public const ushort ResBMU  =    8;
	    public const ushort ResTXT  =   10;
	    public const ushort ResMDL  = 2002;
	    public const ushort ResNSS  = 2009;
	    public const ushort ResNCS  = 2010;
	    public const ushort ResARE  = 2012;
	    public const ushort ResSET  = 2013;
	    public const ushort ResIFO  = 2014;
	    public const ushort ResBIC  = 2015;
	    public const ushort ResWOK  = 2016;
	    public const ushort Res2DA  = 2017;
	    public const ushort ResTXI  = 2022;
	    public const ushort ResGIT  = 2023;
	    public const ushort ResUTI  = 2025;
	    public const ushort ResUTC  = 2027;
	    public const ushort ResDLG  = 2029;
	    public const ushort ResITP  = 2030;
	    public const ushort ResUTT  = 2032;
	    public const ushort ResDDS  = 2033;
	    public const ushort ResUTS  = 2035;
	    public const ushort ResLTR  = 2036;
	    public const ushort ResGFF  = 2037;
	    public const ushort ResFAC  = 2038;
	    public const ushort ResUTE  = 2040;
	    public const ushort ResUTD  = 2042;
	    public const ushort ResUTP  = 2044;
	    public const ushort ResDFT  = 2045;
	    public const ushort ResGIC  = 2046;
	    public const ushort ResGUI  = 2047;
	    public const ushort ResUTM  = 2051;
	    public const ushort ResDWK  = 2052;
	    public const ushort ResPWK  = 2053;
	    public const ushort ResJRL  = 2056;
	    public const ushort ResUTW  = 2058;
	    public const ushort ResSSF  = 2060;
	    public const ushort ResNDB  = 2064;
	    public const ushort ResPTM  = 2065;
	    public const ushort ResPTT  = 2066;
	    public const ushort ResUSC  = 3001;
	    public const ushort ResTRN  = 3002;
	    public const ushort ResUTR  = 3003;
	    public const ushort ResUEN  = 3004;
	    public const ushort ResULT  = 3005;
	    public const ushort ResSEF  = 3006;
	    public const ushort ResPFX  = 3007;
	    public const ushort ResCAM  = 3008;
	    public const ushort ResUPE  = 3011;
	    public const ushort ResPFB  = 3015;
	    public const ushort ResBBX  = 3018;
	    public const ushort ResWLK  = 3020;
	    public const ushort ResXML  = 3021;
	    public const ushort ResTRX  = 3035;
	    public const ushort ResTRn  = 3036;
	    public const ushort ResTRx  = 3037;

	    public const ushort ResMDB  = 4000;
	    public const ushort ResSPT  = 4002;
	    public const ushort ResGR2  = 4003;
	    public const ushort ResFXA  = 4004;
	    public const ushort ResJPG  = 4007;
	    public const ushort ResPWC  = 4008;

	    public const ushort ResINVALID = 0xFFFF;


        private List<ResourceRepository> Repositories;
        private string ModuleResourceName;

    }

    public class DummyOEIResourceManager : OEIShared.IO.ResourceManager
    {

        public DummyOEIResourceManager()
        {
            //
            // Set up the instance field to keep OEIShared happy.  It has been
            // obfuscated so the name is destroyed.  Pick it out by looking for
            // the field characteristics via Reflection.
            //

            if (Instance == null)
            {
                FieldInfo InstanceField = (from FieldType in typeof(OEIShared.IO.ResourceManager).GetFields()
                                           where FieldType == typeof(OEIShared.IO.ResourceManager) &&
                                           FieldType.IsStatic &&
                                           FieldType.IsPrivate
                                           select FieldType).FirstOrDefault();

                if (InstanceField == null)
                    throw new ApplicationException("Couldn't find ResourceManager instance field.");

                InstanceField.SetValue(this, this);
            }
        }

        public override void LoadStandardResources()
        {
            throw new NotImplementedException();
        }
        public override void UnloadStandardResources()
        {
            throw new NotImplementedException();
        }
    }
}
