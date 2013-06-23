using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using ALFA;
using ALFA.Shared;
using OEIShared.IO;
using OEIShared.IO.ERF;
using OEIShared.IO.GFF;
using OEIShared.Utils;

namespace ACR_ServerMisc
{
    public class ItemModification
    {
        /// <summary>
        /// This function is called when RetrieveCampaignObject("VDB_", ..)
        /// is invoked.
        /// </summary>
        /// <param name="sender">Unused.</param>
        /// <param name="e">Supplies event data.</param>
        public static void CampaignDatabase_RetrieveItemModifyEvent(object sender, CampaignDatabase.RetrieveCampaignDatabaseEventArgs e)
        {
            if (!e.CampaignName.StartsWith("ItMod"))
                return;

            e.GFF = new byte[0];
            if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(e.VarName))
            {
                using (MemoryStream s = new MemoryStream())
                {
                    ALFA.Shared.Modules.InfoStore.ModifiedGff[e.VarName].Save(s);
                    e.GFF = s.ToArray();
                }
            }
        }

        /// <summary>
        /// This function is called when StoreCampaignObject("VDB_", ..)
        /// is invoked.
        /// </summary>
        /// <param name="sender">Unused.</param>
        /// <param name="e">Supplies event data.</param>
        public static void CampaignDatabase_StoreItemModifyEvent(object sender, CampaignDatabase.StoreCampaignDatabaseEventArgs e)
        {
            if (!e.CampaignName.StartsWith("ItMod"))
                return;

            if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(e.VarName))
            {
                ALFA.Shared.Modules.InfoStore.ModifiedGff[e.VarName] = new GFFFile(e.GFF);
            }
            else
            {
                ALFA.Shared.Modules.InfoStore.ModifiedGff.Add(e.VarName, new GFFFile(e.GFF));
            }

            e.Handled = true;
        }
    }
}
