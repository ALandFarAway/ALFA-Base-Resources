using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Text;
using ALFA;
using ALFA.Shared;

namespace ACR_ServerMisc
{
    /// <summary>
    /// This class implements a storage provider for the campaign database that
    /// is backed by the raw file system.
    /// </summary>
    internal static class CampaignObjectFileStore
    {
        /// <summary>
        /// This class holds state associated with the campaign store backend.
        /// </summary>
        private class CampaignStore
        {
            public CampaignStore()
            {
                //
                // Register events.
                //

                CampaignDatabase.StoreCampaignDatabaseEvent += new EventHandler<CampaignDatabase.StoreCampaignDatabaseEventArgs>(CampaignDatabase_StoreCampaignDatabaseEvent);
                CampaignDatabase.StoreCampaignDatabaseEvent += new EventHandler<CampaignDatabase.StoreCampaignDatabaseEventArgs>(ItemModification.CampaignDatabase_StoreItemModifyEvent);
                CampaignDatabase.RetrieveCampaignDatabaseEvent += new EventHandler<CampaignDatabase.RetrieveCampaignDatabaseEventArgs>(CampaignDatabase_RetrieveCampaignDatabaseEvent);
                CampaignDatabase.RetrieveCampaignDatabaseEvent += new EventHandler<CampaignDatabase.RetrieveCampaignDatabaseEventArgs>(ItemModification.CampaignDatabase_RetrieveItemModifyEvent);

                //
                // Ensure that the database store exists.
                //

                Directory.CreateDirectory(DatabaseStoreDirectory);
            }

            ~CampaignStore()
            {
                //
                // Unregister events.
                //

                CampaignDatabase.StoreCampaignDatabaseEvent -= new EventHandler<CampaignDatabase.StoreCampaignDatabaseEventArgs>(CampaignDatabase_StoreCampaignDatabaseEvent);
                CampaignDatabase.StoreCampaignDatabaseEvent -= new EventHandler<CampaignDatabase.StoreCampaignDatabaseEventArgs>(ItemModification.CampaignDatabase_StoreItemModifyEvent);
                CampaignDatabase.RetrieveCampaignDatabaseEvent -= new EventHandler<CampaignDatabase.RetrieveCampaignDatabaseEventArgs>(CampaignDatabase_RetrieveCampaignDatabaseEvent);                
                CampaignDatabase.RetrieveCampaignDatabaseEvent -= new EventHandler<CampaignDatabase.RetrieveCampaignDatabaseEventArgs>(ItemModification.CampaignDatabase_RetrieveItemModifyEvent);
            }

            /// <summary>
            /// Check whether there is a campaign database store for the given
            /// campaign name (raw GFF on filesystem format).
            /// </summary>
            /// <param name="Campaign">Supplies the campaign name.</param>
            /// <returns>True if the database store for the campaign exists.
            /// </returns>
            internal bool GetHasDatabaseStore(string Campaign)
            {
                if (!SystemInfo.IsSafeFileName(Campaign))
                    return false;

                return Directory.Exists(DatabaseStoreDirectory + Campaign);
            }

            /// <summary>
            /// Delete a campaign database store for the given campaign name (raw
            /// GFF on filesystem format).
            /// </summary>
            /// <param name="Campaign">Supplies the campaign name.</param>
            /// <returns>True if the operation succeeded.</returns>
            internal bool DeleteDatabaseStore(string Campaign)
            {
                if (!SystemInfo.IsSafeFileName(Campaign))
                    return false;

                try
                {
                    string DirectoryName = DatabaseStoreDirectory + Campaign;

                    if (!Directory.Exists(DirectoryName))
                        return true;

                    ALFA.Shared.Logger.Log("CampaignObjectFileStore.DeleteDatabaseStore: Deleted campaign database store {0}", Campaign);
                    Directory.Delete(DirectoryName, true);
                    return true;
                }
                catch (Exception e)
                {
                    ALFA.Shared.Logger.Log("CampaignObjectFileStore.DeleteDatabaseStore({0}): Exception: {1}", Campaign, e);
                    return false;
                }
                catch
                {
                    return false;
                }
            }

            /// <summary>
            /// Delete all GFF files in a campaign database at and above a given index.
            /// </summary>
            /// <param name="Campaign">Supplies the campaign name.</param>
            /// <param name="Index">Supplies the lowest-numbered file to be deleted.</param>
            /// <returns>True if the operation succeeded.</returns>
            internal bool DeleteDatabaseStoreAtIndex(string Campaign, int Index)
            {
                if (!SystemInfo.IsSafeFileName(Campaign))
                    return false;

                try
                {
                    string DirectoryName = DatabaseStoreDirectory + Campaign;

                    if (!Directory.Exists(DirectoryName))
                        return true;

                    ALFA.Shared.Logger.Log("CampaignObjectFileStore.DeleteDatabaseStore: Deleted campaign database store {0} above index {1}", Campaign, Index);
                    string FileName = String.Format("{0}{1}{2}.GFF", DirectoryName, Path.DirectorySeparatorChar, Index);
                    while (File.Exists(FileName))
                    {
                        File.Delete(FileName);
                        Index++;
                        FileName = String.Format("{0}{1}{2}.GFF", DirectoryName, Path.DirectorySeparatorChar, Index);
                    }
                    return true;
                }
                catch (Exception e)
                {
                    ALFA.Shared.Logger.Log("CampaignObjectFileStore.DeleteDatabaseStore({0}): Exception: {1}", Campaign, e);
                    return false;
                }
                catch
                {
                    return false;
                }
            }

            /// <summary>
            /// This function is called when RetrieveCampaignObject("VDB_", ..)
            /// is invoked.
            /// </summary>
            /// <param name="sender">Unused.</param>
            /// <param name="e">Supplies event data.</param>
            void CampaignDatabase_RetrieveCampaignDatabaseEvent(object sender, CampaignDatabase.RetrieveCampaignDatabaseEventArgs e)
            {
                //
                // Interested only in VDB_File_<Campaign>.
                //

                if (!e.CampaignName.StartsWith("File_"))
                    return;

                string DirectoryName = e.CampaignName.Substring(5);

                if (!SystemInfo.IsSafeFileName(DirectoryName))
                    return;
                if (!SystemInfo.IsSafeFileName(e.VarName))
                    return;

                try
                {
                    DirectoryName = DatabaseStoreDirectory + DirectoryName;

                    string FileName = String.Format("{0}{1}{2}.GFF", DirectoryName, Path.DirectorySeparatorChar, e.VarName);

                    if (!File.Exists(FileName))
                    {
                        ALFA.Shared.Logger.Log("CampaignObjectFileStore.CampaignDatabase_RetrieveCampaignDatabaseEvent: No database {0} exists.", FileName);
                        return;
                    }

                    e.GFF = File.ReadAllBytes(FileName);
                }
                catch (Exception ex)
                {
                    ALFA.Shared.Logger.Log("CampaignObjectFileStore.CampaignDatabase_RetrieveCampaignDatabaseEvent({0}): Exception: {1}", DirectoryName, ex);
                    return;
                }
                catch
                {
                    return;
                }
            }

            /// <summary>
            /// This function is called when StoreCampaignObject("VDB_", ..)
            /// is invoked.
            /// </summary>
            /// <param name="sender">Unused.</param>
            /// <param name="e">Supplies event data.</param>
            void CampaignDatabase_StoreCampaignDatabaseEvent(object sender, CampaignDatabase.StoreCampaignDatabaseEventArgs e)
            {
                //
                // Interested only in VDB_File_<Campaign>.
                //

                if (!e.CampaignName.StartsWith("File_"))
                    return;

                string DirectoryName = e.CampaignName.Substring(5);

                if (!SystemInfo.IsSafeFileName(DirectoryName))
                    return;
                if (!SystemInfo.IsSafeFileName(e.VarName))
                    return;

                try
                {
                    DirectoryName = DatabaseStoreDirectory + DirectoryName;
                    Directory.CreateDirectory(DirectoryName);

                    string FileName = String.Format("{0}{1}{2}.GFF", DirectoryName, Path.DirectorySeparatorChar, e.VarName);

                    File.WriteAllBytes(FileName, e.GFF);
                }
                catch (Exception ex)
                {
                    ALFA.Shared.Logger.Log("CampaignObjectFileStore.CampaignDatabase_RetrieveCampaignDatabaseEvent({0}): Exception: {1}", DirectoryName, ex);
                    return;
                }
                catch
                {
                    return;
                }

                e.Handled = true;
            }

            /// <summary>
            /// Get the default file extension for a GFF.
            /// </summary>
            /// <param name="GFF">Supplies the raw data.</param>
            /// <returns>The extension.</returns>
            string GetExtensionFromGFFData(byte[] GFF)
            {
                if (GFF.Length < 8)
                    return "GFF";

                return String.Format("{0}{1}{2}", (char)GFF[0], (char)GFF[1], (char)GFF[2]);
            }

            /// <summary>
            /// The campaign database store directory.
            /// </summary>
            private static string DatabaseStoreDirectory = String.Format("{0}{1}DatabaseStore{1}", SystemInfo.GetHomeDirectory(), Path.DirectorySeparatorChar);

            /// <summary>
            /// The legacy F4 database directory (built-in campaign database).
            /// </summary>
            private static string LegacyDatabaseDirectory = String.Format("{0}{1}Database{1}", SystemInfo.GetHomeDirectory(), Path.DirectorySeparatorChar);
        }

        /// <summary>
        /// Check whether there is a campaign database store for the given
        /// campaign name (raw GFF on filesystem format).
        /// </summary>
        /// <param name="Campaign">Supplies the campaign name.</param>
        /// <returns>True if the database store for the campaign exists.
        /// </returns>
        internal static bool GetHasDatabaseStore(string Campaign)
        {
            return Store.GetHasDatabaseStore(Campaign);
        }

        /// <summary>
        /// Delete a campaign database store for the given campaign name (raw
        /// GFF on filesystem format).
        /// </summary>
        /// <param name="Campaign">Supplies the campaign name.</param>
        /// <returns>True if the operation succeeded.</returns>
        internal static bool DeleteDatabaseStore(string Campaign)
        {
            return Store.DeleteDatabaseStore(Campaign);
        }

        /// <summary>
        /// Delete all GFF files in a campaign database at and above a given index.
        /// </summary>
        /// <param name="Campaign">Supplies the campaign name.</param>
        /// <param name="Index">Supplies the lowest-numbered file to be deleted.</param>
        /// <returns>True if the operation succeeded.</returns>
        internal static bool DeleteDatabaseStoreAtIndex(string Campaign, int Index)
        {
            return Store.DeleteDatabaseStoreAtIndex(Campaign, Index);
        }

        /// <summary>
        /// The store backend.
        /// </summary>
        private static CampaignStore Store = new CampaignStore();
    }
}
