using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel;
using System.IO;

using OEIShared.IO;
using OEIShared.IO.GFF;

using ALFA;

namespace ACR_Candlekeep
{
    public class Archivist : BackgroundWorker
    {
        public static ALFA.ResourceManager manager;
        public void InitializeArchives(object Sender, EventArgs e)
        {
            // TODO: Allow this to be configured.
            manager = new ALFA.ResourceManager(null);

            manager.LoadCoreResources();

            foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResUTI))
            {
                try
                {
                    GFFFile currentGFF = manager.OpenGffResource(resource.ResRef.Value, resource.ResourceType);

                    string currentResRef = currentGFF.TopLevelStruct["TemplateResRef"].Value.ToString();
                    if (ALFA.Shared.Modules.InfoStore.ModuleItems.Keys.Contains(currentResRef))
                    {
                        // If we have competing resources, we expect that GetResourcesByType will give us the
                        // resource of greatest priority first. Therefore, redundant entries of a given resref
                        // are trash.
                        continue;
                    }

                    ALFA.Shared.ItemResource addingItem = new ALFA.Shared.ItemResource();
                    try
                    {
                        addingItem.LocalizedName = currentGFF.TopLevelStruct["LocalizedName"].Value.ToString().Split('"')[1];
                    }
                    catch
                    {
                        addingItem.LocalizedName = currentGFF.TopLevelStruct["LocalizedName"].Value.ToString();
                    }

                    addingItem.Classification = currentGFF.TopLevelStruct["Classification"].Value.ToString();
                    addingItem.TemplateResRef = currentResRef;
                    addingItem.Tag = currentGFF.TopLevelStruct["Tag"].Value.ToString();

                    int Cost, BaseItem;
                    bool Cursed = false, Plot = false, Stolen = false;
                    Int32.TryParse(currentGFF.TopLevelStruct["Cost"].Value.ToString(), out Cost);
                    Int32.TryParse(currentGFF.TopLevelStruct["BaseItem"].Value.ToString(), out BaseItem);
                    if (currentGFF.TopLevelStruct["Cursed"].Value.ToString() == "1") Cursed = true;
                    if (currentGFF.TopLevelStruct["Plot"].Value.ToString() == "1") Plot = true;
                    if (currentGFF.TopLevelStruct["Stolen"].Value.ToString() == "1") Stolen = true;

                    addingItem.Cost = Cost;
                    addingItem.BaseItem = BaseItem;
                    addingItem.Cursed = Cursed;
                    addingItem.Plot = Plot;
                    addingItem.Stolen = Stolen;

                    ALFA.Shared.Modules.InfoStore.ModuleItems.Add(currentResRef, addingItem);
                }
                catch { }
            }

            #region Commented-Out Resource Types
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.Res2DA))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResARE))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResBBX))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResBIC))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResBMP))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResBMU))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResCAM))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResDDS))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResDFT))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResDLG))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResDWK))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResFAC))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResFXA))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResGFF))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResGIC))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResGIT))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResGR2))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResGUI))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResIFO))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResINI))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResINVALID))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResITP))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResJPG))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResJRL))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResLTR))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResMDB))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResMDL))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResNCS))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResNDB))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResNSS))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResPFB))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResPFX))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResPLT))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResPTM))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResPTT))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResPWC))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResPWK))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResSEF))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResSET))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResSPT))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResSSF))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResTGA))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResTRn))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResTRN))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResTRx))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResTRX))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResTXI))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResTXT))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResUEN))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResULT))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResUPE))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResUSC))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResUTC))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResUTD))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResUTE))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResUTM))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResUTP))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResUTR))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResUTS))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResUTT))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResUTW))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResWAV))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResWLK))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResWOK))
            //{ }
            //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResXML))
            //{ }
            #endregion
        }
    }
}
