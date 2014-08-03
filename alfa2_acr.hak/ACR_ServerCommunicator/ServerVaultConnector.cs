using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Runtime.InteropServices;
using ALFA.Shared;

namespace ACR_ServerCommunicator
{
    /// <summary>
    /// This class encapsulates the connector between the server vault plugin's
    /// storage plugin interface, and the server vault backend store (i.e., the
    /// Azure storage provider).
    /// </summary>
    static class ServerVaultConnector
    {

        /// <summary>
        /// Initialize the server vault connector subsystem.
        /// </summary>
        /// <param name="Script">Supplies the main script object.</param>
        /// <param name="ConnectionString">Supplies the connection string for
        /// the server vault.</param>
        /// <returns>True if the server vault connector is
        /// initialized.</returns>
        public static bool Initialize(ACR_ServerCommunicator Script, string ConnectionString)
        {
            if (Initialized)
                return true;

            try
            {
                StoreConnectionString = ConnectionString;

                FileStoreProvider.DefaultVaultConnectionString = ConnectionString;

                SynchronizeAccountFromVaultDelegate = new SynchronizeAccountFromVault(OnSynchronizeAccountFromVault);
                SynchronizeAccountFromVaultHandle = GCHandle.Alloc(SynchronizeAccountFromVaultDelegate);

                SynchronizeAccountFileToVaultDelegate = new SynchronizeAccountFileToVault(OnSynchronizeAccountFileToVault);
                SynchronizeAccountFileToVaultHandle = GCHandle.Alloc(SynchronizeAccountFileToVaultDelegate);

                try
                {
                    if (SetStoragePluginCallbacks(Marshal.GetFunctionPointerForDelegate(SynchronizeAccountFromVaultDelegate),
                        Marshal.GetFunctionPointerForDelegate(SynchronizeAccountFileToVaultDelegate),
                        IntPtr.Zero) == 0)
                    {
                        throw new ApplicationException("Failed to install storage plugin callbacks.");
                    }
                }
                catch (Exception e)
                {
                    Script.WriteTimestampedLogEntry(String.Format("ServerVaultConnector.Initialize: Exception: {0}", e));
                    SynchronizeAccountFileToVaultDelegate = null;
                    SynchronizeAccountFileToVaultHandle.Free();
                    SynchronizeAccountFromVaultDelegate = null;
                    SynchronizeAccountFromVaultHandle.Free();
                    throw;
                }
            }
            catch
            {
                return false;
            }

            Initialized = true;
            return true;
        }

        /// <summary>
        /// Refresh configuration in the event that it had changed.
        /// </summary>
        /// <param name="ConnectionString">Supplies the connection string for
        /// the server vault.</param>
        public static void RefreshConfiguration(string ConnectionString)
        {
            if (ConnectionString == StoreConnectionString)
                return;

            StoreConnectionString = ConnectionString;
            StoreInternal = null;
            ContainerInternal = null;

            FileStoreProvider.DefaultVaultConnectionString = ConnectionString;
        }

        //
        // The following are used with the xp_AuroraServerVault storage plugin
        // interface.  Note that until all servers have rolled out the new
        // plugin version, we must gracefully handle SetStoragePluginCallbacks
        // not existing.
        //

        /// <summary>
        /// Synchronize new files from the vault storage provider.  The
        /// SyncPath specifies the path to download changed files from the
        /// vault storage provider to.  It may be populated with existing
        /// files, and only newer files should be transferred from the vault
        /// storage provider.
        /// 
        /// This function is called from the transfer synchronization thread.
        /// </summary>
        /// <param name="AccountName">Supplies the account name.</param>
        /// <param name="SyncPath">Supplies the path to synchronize files to
        /// from the vault.  Existing files should be datestamp compared with
        /// the vault before being replaced.  File are downloaded from the
        /// vault, not uploaded, with this routine.</param>
        /// <param name="Context">Supplies a context handle.</param>
        /// <returns>TRUE on success.</returns>
        [UnmanagedFunctionPointer(CallingConvention.StdCall, CharSet = CharSet.Ansi)]
        private delegate int SynchronizeAccountFromVault(string AccountName, string SyncPath, IntPtr Context);

        /// <summary>
        /// Synchronize a single character file from the spool directory to the
        /// remote storage provider.  The contents of the file to transfer are
        /// already in memory.
        /// 
        /// This function is called from the transfer synchronization thread.
        /// </summary>
        /// <param name="AccountName">Supplies the account name.</param>
        /// <param name="CharacterFileName">Supplies the character file name,
        /// without path (e.g. character.bic).</param>
        /// <param name="Data">Supplies a pointer to the BIC memory
        /// image.</param>
        /// <param name="Length">Supplies the length, in bytes, of the BIC to
        /// transfer.</param>
        /// <param name="Context">Supplies a context handle.</param>
        /// <returns>TRUE on success.</returns>
        [UnmanagedFunctionPointer(CallingConvention.StdCall, CharSet = CharSet.Ansi)]
        private delegate int SynchronizeAccountFileToVault(string AccountName, string CharacterFileName, IntPtr Data, IntPtr Length, IntPtr Context);

        /// <summary>
        /// Initialize the storage plugin interface for the server vault
        /// plugin.  Only one call to this function should be made per process.
        /// </summary>
        /// <param name="SynchronizeAccountFromVault">Supplies the synchronize
        /// callback that is invoked when an account needs to be updated from
        /// the vault.</param>
        /// <param name="SynchronizeAccountFileToVault">Supplies the
        /// synchronize callback that is invoked when an account file is ready
        /// to be pushed to the vault.</param>
        /// <param name="Context"></param>
        /// <returns></returns>
        [DllImport("xp_ServerVault.dll", CallingConvention = CallingConvention.StdCall)]
        private static extern int SetStoragePluginCallbacks(IntPtr SynchronizeAccountFromVault, IntPtr SynchronizeAccountFileToVault, IntPtr Context);


        /// <summary>
        /// Synchronize new files from the vault storage provider.  The
        /// SyncPath specifies the path to download changed files from the
        /// vault storage provider to.  It may be populated with existing
        /// files, and only newer files should be transferred from the vault
        /// storage provider.
        /// 
        /// This function is called from the transfer synchronization thread.
        /// </summary>
        /// <param name="AccountName">Supplies the account name.</param>
        /// <param name="SyncPath">Supplies the path to synchronize files to
        /// from the vault.  Existing files should be datestamp compared with
        /// the vault before being replaced.  File are downloaded from the
        /// vault, not uploaded, with this routine.</param>
        /// <param name="Context">Supplies a context handle.</param>
        /// <returns>TRUE on success.</returns>
        private static int OnSynchronizeAccountFromVault(string AccountName, string SyncPath, IntPtr Context)
        {
            try
            {
                //
                // Pass through to the default implementation if the connection
                // string is not defined in the database.
                //

                if (String.IsNullOrEmpty(StoreConnectionString))
                    return 1;

                string OriginalAccountName = AccountName;

                //
                // Canonicalize names to lowercase as the file store may be
                // case sensitive and maintaining a mapping table in the
                // database is problematic since the first save for a new
                // account may be observed before the players record for
                // that player is created (and a player could log in to two
                // servers simultaneously and create orphaned records that
                // way, or similarly during a database outage, etc.).
                //

                AccountName = AccountName.ToLowerInvariant();

                try
                {
                    bool DirCreated = false;
                    FileStoreDirectory StoreDirectory = Container.GetDirectoryReference(AccountName);

                    IEnumerable<string> FsFiles = null;
                    Dictionary<string, FileStoreFile> StoreFiles = new Dictionary<string, FileStoreFile>();

                    //
                    // Build an index of all files in the file store vault.
                    //

                    foreach (FileStoreFile StoreFile in StoreDirectory.GetFiles())
                    {
                        string[] Segments = StoreFile.Uri.Segments;

                        if (Segments.Length == 0)
                            continue;

                        string CharacterFileName = Segments[Segments.Length - 1].ToLowerInvariant();

                        if (!CharacterFileName.EndsWith(".bic"))
                            continue;

                        StoreFiles.Add(CharacterFileName, StoreFile);
                    }

                    //
                    // Enumerate file currently in the file system directory,
                    // transferring each corresponding file from the store
                    // directory if the modified date of the store file is
                    // after the modified date of the local file.
                    //

                    if (Directory.Exists(SyncPath))
                    {
                        FsFiles = Directory.EnumerateFiles(SyncPath);

                        foreach (string FsFileName in FsFiles)
                        {
                            DateTime FsLastModified = File.GetLastWriteTimeUtc(FsFileName);
                            string CharacterFileName = Path.GetFileName(FsFileName);
                            string Key = CharacterFileName.ToLowerInvariant();
                            FileStoreFile StoreFile;
                            string TempFileName = null;

                            if (!StoreFiles.TryGetValue(Key, out StoreFile))
                            {
                                //
                                // This file exists locally but not in the file
                                // store vault.  Keep it (any excess files may be
                                // removed by explicit local vault cleanup).
                                //

                                continue;
                            }

                            //
                            // Transfer the file if the file store vault has a more
                            // recent version.
                            //

                            try
                            {
                                TempFileName = Path.GetTempFileName();

                                try
                                {
                                    using (FileStream FsFile = File.Open(TempFileName, FileMode.Create))
                                    {
                                        StoreFile.ReadIfModifiedSince(FsFile, new DateTimeOffset(FsLastModified));
                                    }

                                    try
                                    {
                                        File.Copy(TempFileName, FsFileName, true);
                                        File.SetLastWriteTimeUtc(FsFileName, StoreFile.LastModified.Value.DateTime);
                                    }
                                    catch
                                    {
                                        //
                                        // Clean up after a failed attempt to
                                        // instantiate copy file.
                                        //

                                        ALFA.SystemInfo.SafeDeleteFile(FsFileName);
                                        throw;
                                    }

                                    Logger.Log("ServerVaultConnector.OnSynchronizeAccountFromVault: Downloaded vault file '{0}\\{1}' with modified date {2} -> {3}.",
                                        AccountName,
                                        CharacterFileName,
                                        FsLastModified,
                                        File.GetLastWriteTimeUtc(FsFileName));
                                }
                                catch (FileStoreConditionNotMetException)
                                {
                                    //
                                    // This file was not transferred because it is
                                    // already up to date.
                                    //

                                    Logger.Log("ServerVaultConnector.OnSynchronizeAccountFromVault: Vault file '{0}\\{1}' was already up to date with modified date {2}.",
                                        AccountName,
                                        CharacterFileName,
                                        FsLastModified);
                                }
                            }
                            finally
                            {
                                if (!String.IsNullOrEmpty(TempFileName))
                                    ALFA.SystemInfo.SafeDeleteFile(TempFileName);
                            }

                            //
                            // Remove this file from the list as it has already
                            // been accounted for (it is up to date or has just
                            // been transferred).

                            StoreFiles.Remove(Key);
                        }
                    }

                    //
                    // Sweep any files that were still not yet processed but
                    // existed in the file store vault.  These files are
                    // present on the canonical vault but have not yet been
                    // populated on the local vault, so transfer them now.
                    //

                    foreach (var StoreFile in StoreFiles.Values)
                    {
                        string[] Segments = StoreFile.Uri.Segments;
                        string CharacterFileName = Segments[Segments.Length - 1].ToLowerInvariant();
                        string FsFileName = SyncPath + Path.DirectorySeparatorChar + CharacterFileName;
                        string TempFileName = null;

                        if (!ALFA.SystemInfo.IsSafeFileName(CharacterFileName))
                            throw new ApplicationException("Unsafe filename '" + CharacterFileName + "' on vault for account '" + AccountName + "'.");

                        if (!DirCreated)
                        {
                            DirCreated = Directory.Exists(SyncPath);

                            //
                            // Create the sync directory if it does not exist.
                            // Attempt to preserve case from the vault store if
                            // possible, but fall back to using the case that
                            // the client specified at login time otherwise.
                            //

                            if (!DirCreated)
                            {
                                try
                                {
                                    string OriginalName;

                                    StoreFile.FetchAttributes();

                                    OriginalName = StoreFile.Metadata["OriginalFileName"];

                                    if (OriginalName != null && OriginalName.ToLowerInvariant() == AccountName + "/" + CharacterFileName)
                                    {
                                        OriginalName = OriginalName.Split('/').FirstOrDefault();

                                        DirectoryInfo Parent = Directory.GetParent(SyncPath);

                                        Directory.CreateDirectory(Parent.FullName + "\\" + OriginalName);
                                        Logger.Log("ServerVaultConnector.OnSynchronizeAccountFromVault: Created vault directory for account '{0}'.", OriginalName);
                                        DirCreated = true;
                                    }
                                }
                                catch (Exception e)
                                {
                                    Logger.Log("ServerVaultConnector.OnSynchronizeAccountFromVault: Exception {0} recovering canonical case for creating vault directory '{1}', using account name from client instead.",
                                        e,
                                        OriginalAccountName);
                                }

                                if (!DirCreated)
                                {
                                    Directory.CreateDirectory(SyncPath);
                                    DirCreated = true;
                                }
                            }
                        }

                        try
                        {
                            TempFileName = Path.GetTempFileName();

                            using (FileStream FsFile = File.Open(TempFileName, FileMode.OpenOrCreate))
                            {
                                StoreFile.Read(FsFile);
                            }

                            try
                            {
                                File.Copy(TempFileName, FsFileName);
                                File.SetLastWriteTimeUtc(FsFileName, StoreFile.LastModified.Value.DateTime);
                            }
                            catch
                            {
                                //
                                // Clean up after a failed attempt to
                                // instantiate a new file.
                                //

                                ALFA.SystemInfo.SafeDeleteFile(FsFileName);
                                throw;
                            }

                            Logger.Log("ServerVaultConnector.OnSynchronizeAccountFromVault: Downloaded new vault file '{0}\\{1}' with modified date {2}.",
                                AccountName,
                                CharacterFileName,
                                File.GetLastWriteTimeUtc(FsFileName));
                        }
                        finally
                        {
                            ALFA.SystemInfo.SafeDeleteFile(TempFileName);
                        }
                    }

                    return 1;
                }
                catch (Exception e)
                {
                    Logger.Log("ServerVaultConnector.OnSynchronizeAccountFromVault('{0}', '{1}'): Exception: {2}",
                        AccountName,
                        SyncPath,
                        e);

                    throw;
                }
            }
            catch
            {
                return 0;
            }
        }

        /// <summary>
        /// Synchronize a single character file from the spool directory to the
        /// remote storage provider.  The contents of the file to transfer are
        /// already in memory.
        /// 
        /// This function is called from the transfer synchronization thread.
        /// </summary>
        /// <param name="AccountName">Supplies the account name.</param>
        /// <param name="CharacterFileName">Supplies the character file name,
        /// without path (e.g. character.bic).</param>
        /// <param name="Data">Supplies a pointer to the BIC memory
        /// image.</param>
        /// <param name="Length">Supplies the length, in bytes, of the BIC to
        /// transfer.</param>
        /// <param name="Context">Supplies a context handle.</param>
        /// <returns>TRUE on success.</returns>
        private static int OnSynchronizeAccountFileToVault(string AccountName, string CharacterFile, IntPtr Data, IntPtr Length, IntPtr Context)
        {
            try
            {
                //
                // Pass through to the default implementation if the connection
                // string is not defined in the database.
                //

                if (String.IsNullOrEmpty(StoreConnectionString))
                    return 1;

                try
                {
                    if (Length == IntPtr.Zero)
                        return 0;

                    //
                    // Canonicalize names to lowercase as the file store may be
                    // case sensitive and maintaining a mapping table in the
                    // database is problematic since the first save for a new
                    // account may be observed before the players record for
                    // that player is created (and a player could log in to two
                    // servers simultaneously and create orphaned records that
                    // way, or similarly during a database outage, etc.).
                    //
                    // The original filename is stored as metadata to keep local
                    // filesystems case preserving on servers.
                    //

                    string OriginalFileName = AccountName + "/" + CharacterFile;

                    AccountName = AccountName.ToLowerInvariant();
                    CharacterFile = CharacterFile.ToLowerInvariant();

                    //
                    // Get the file store file for the character file and
                    // replace it with the new character file.
                    //

                    FileStoreDirectory StoreDirectory = Container.GetDirectoryReference(AccountName);
                    FileStoreFile StoreFile = StoreDirectory.GetFileReference(CharacterFile);

                    byte[] CharacterData = new byte[(int)Length];
                    Marshal.Copy(Data, CharacterData, 0, CharacterData.Length);

                    StoreFile.Metadata["OriginalFileName"] = OriginalFileName;
                    StoreFile.Write(new MemoryStream(CharacterData));

                    Logger.Log("ServerVaultConnector.OnSynchronizeAccountFileToVault: Uploaded vault file '{0}\\{1}'.",
                        AccountName,
                        CharacterFile);

                    return 1;
                }
                catch (Exception e)
                {
                    Logger.Log("ServerVaultConnector.OnSynchronizeAccountFileToVault('{0}', '{1}'): Exception: {2}",
                        AccountName,
                        CharacterFile,
                        e);

                    throw;
                }
            }
            catch
            {
                return 0;
            }
        }


        /// <summary>
        /// True if the subsystem was initialized.
        /// </summary>
        private static bool Initialized = false;

        /// <summary>
        /// Delegate for the SynchronizeAccountFromVault callout.
        /// </summary>
        private static SynchronizeAccountFromVault SynchronizeAccountFromVaultDelegate;

        /// <summary>
        /// GC handle used to keep the unmanaged callback delegate alive for
        /// the SynchronizeAccountFromVault callout.
        /// </summary>
        private static GCHandle SynchronizeAccountFromVaultHandle;

        /// <summary>
        /// Delegate for the SynchronizeAccountFileToVault callout.
        /// </summary>
        private static SynchronizeAccountFileToVault SynchronizeAccountFileToVaultDelegate;

        /// <summary>
        /// GC handle used to keep the unmanaged callback delegate alive for
        /// the SynchronizeAccountFileToVault callout.
        /// </summary>
        private static GCHandle SynchronizeAccountFileToVaultHandle;

        /// <summary>
        /// The connection string for the server vault.
        /// </summary>
        private static string StoreConnectionString;

        /// <summary>
        /// The underlying file store used for the server vault.
        /// </summary>
        private static FileStore StoreInternal;

        /// <summary>
        /// Obtain a reference to the file store for the server vault.
        /// </summary>
        private static FileStore Store
        {
            get
            {
                if (StoreInternal == null)
                    StoreInternal = FileStoreProvider.CreateAzureFileStore(StoreConnectionString);

                return StoreInternal;
            }
        }

        /// <summary>
        /// The underlying container used for the server vault.
        /// </summary>
        private static FileStoreContainer ContainerInternal;

        /// <summary>
        /// Obtain a reference to the file store container for the server
        /// vault.
        /// </summary>
        private static FileStoreContainer Container
        {
            get
            {
                if (ContainerInternal == null)
                {
                    ContainerInternal = Store.GetContainerReference("alfa-nwn2-server-vault");
                    ContainerInternal.CreateIfNotExists();
                }

                return ContainerInternal;
            }
        }
    }
}
