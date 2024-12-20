﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.IO.Compression;
using System.Security.Cryptography;
using System.Xml;
using ALFA.Shared;

namespace ACR_ServerCommunicator
{
    static class ModuleContentPatcher
    {
        /// <summary>
        /// A download configuration row from the content_download_config table
        /// </summary>
        private class DownloadConfiguration
        {
            /// <summary>
            /// The hash in the XML
            /// </summary>
            public string Hash;

            /// <summary>
            /// The download hash in the XML
            /// </summary>
            public string DownloadHash;

            /// <summary>
            /// The name attribute in the XML
            /// </summary>
            public string Name;

            /// <summary>
            /// The dlsize attribute in the XML
            /// </summary>
            public string DLSize;

            /// <summary>
            /// The size attribute in the XML
            /// </summary>
            public string Size;
        }

        /// <summary>
        /// File update strategies.
        /// </summary>
        private enum FileUpdateMethod
        {
            //
            // Rename away the existing file, then copy in the new file.
            //

            FileUpdateMethodRename,

            //
            // Directly overwrite the new file.
            //

            FileUpdateMethodDirectReplace
        }

        /// <summary>
        /// A set of paths used to expand content path file locations.
        /// </summary>
        private class ContentPatchPaths
        {
            /// <summary>
            /// The local override directory.
            /// </summary>
            public string OverridePath;

            /// <summary>
            /// The local hak directory.
            /// </summary>
            public string HakPath;
        }

        /// <summary>
        /// A content patch row from the content_patch_files table.
        /// </summary>
        private class ContentPatchFile
        {
            /// <summary>
            /// The file name.
            /// </summary>
            public string FileName;

            /// <summary>
            /// The file location (override, hak, etc.).
            /// </summary>
            public string Location;

            /// <summary>
            /// The MD5 checksum.
            /// </summary>
            public string Checksum;

            /// <summary>
            /// Whether the module must be recompiled if this file is updated.
            /// </summary>
            public bool RecompileModule;

            /// <summary>
            /// The method used to update the file.
            /// </summary>
            public FileUpdateMethod UpdateMethod
            {
                get
                {
                    //
                    // Override files are always directly overwritten.  These
                    // are not expected to be locked by the server while
                    // running.  Other files may be locked by the server, so
                    // they have to be renamed away.
                    //
                    // Note that direct replaced files are expected to be
                    // safely deleteable if a rollback occurs during patching,
                    // i.e. the server must be able to start up with said files
                    // missing.  Typically, these such files would be replaced
                    // by the patch system on a successful patch cycle anyway,
                    // e.g. the "override" subdirectory managed by the content
                    // patch system contains ONLY the files present in the
                    // current patch version override set (all other files are
                    // deleted).
                    //

                    if (Location == "override")
                        return FileUpdateMethod.FileUpdateMethodDirectReplace;
                    else
                        return FileUpdateMethod.FileUpdateMethodRename;
                }
            }

            /// <summary>
            /// Get the local path for a file.
            /// </summary>
            /// <param name="Paths">Supplies the content patch paths that are
            /// used to expand path references.</param>
            /// <returns>The local, fully qualified path to the file.</returns>
            public string GetLocalPath(ContentPatchPaths Paths)
            {
                if (Location == "override")
                    return Paths.OverridePath + "\\" + FileName;
                else if (Location == "hak")
                    return Paths.HakPath + FileName;
                else
                    return null;
            }
        }

        /// <summary>
        /// Process and apply content patches.  A server restart is scheduled
        /// if required for the content patch.
        /// </summary>
        /// <param name="ContentPatchPath">Supplies the configured content
        /// patch base path, from the database config table.</param>
        /// <param name="Database">Supplies the database object.</param>
        /// <param name="Script">Supplies the script object.</param>
        /// <param name="ConnectionString">Supplies the updater file store
        /// connection string.</param>
        /// <returns>True if a patch was applied and a reboot is required for
        /// it to take effect.</returns>
        public static bool ProcessContentPatches(string ContentPatchPath, ALFA.Database Database, ACR_ServerCommunicator Script, string ConnectionString)
        {
            bool ContentChanged = false;
            string Version = Database.ACR_GetHAKVersion();
            List<ContentPatchFile> PatchFiles = new List<ContentPatchFile>();
            ContentPatchPaths LocalPaths = new ContentPatchPaths()
            {
                HakPath = ALFA.SystemInfo.GetHakDirectory(),
                OverridePath = ALFA.SystemInfo.GetOverrideDirectory() + "ACR_ContentPatches"
            };
            string RemoteContentPatchPath = String.Format("{0}{1}\\{2}", ALFA.SystemInfo.GetCentralVaultPath(), ContentPatchPath, Version);
            string FileStoreContentPatchPath = String.Format("{0}/{1}", ContentPatchPath, Version).Replace('\\', '/');
            bool RecompileModule = false;
            bool SentNotification = false;

            Database.ACR_SQLQuery(String.Format(
                "SELECT `FileName`, `Location`, `Checksum`, `RecompileModule` FROM `content_patch_files` WHERE `HakVersion` = '{0}'",
                Database.ACR_SQLEncodeSpecialChars(Version)));

            while (Database.ACR_SQLFetch())
            {
                ContentPatchFile PatchFile = new ContentPatchFile();

                PatchFile.FileName = Database.ACR_SQLGetData(0);
                PatchFile.Location = Database.ACR_SQLGetData(1);
                PatchFile.Checksum = Database.ACR_SQLGetData(2);
                PatchFile.RecompileModule = ALFA.Database.ACR_ConvertDatabaseStringToBoolean(Database.ACR_SQLGetData(3));

                if (PatchFile.Location != "override" &&
                    PatchFile.Location != "hak")
                {
                    continue;
                }

                if (!ALFA.SystemInfo.IsSafeFileName(PatchFile.FileName))
                    continue;

                PatchFiles.Add(PatchFile);
            }

            if (!Directory.Exists(LocalPaths.OverridePath))
                Directory.CreateDirectory(LocalPaths.OverridePath);

            //
            // Remove entries in the ACR patch override directory that are not
            // listed in the patch table.  These may be patches for a previous
            // version, and are not applicable.
            //

            foreach (string DirFile in Directory.GetFiles(LocalPaths.OverridePath))
            {
                ContentPatchFile FoundPatch = (from PF in PatchFiles
                                               where (PF.FileName.Equals(Path.GetFileName(DirFile), StringComparison.InvariantCultureIgnoreCase) && PF.Location == "override")
                                               select PF).FirstOrDefault();
                if (FoundPatch == null)
                {
                    Database.ACR_IncrementStatistic("CONTENT_PATCH_REMOVE_FILE");

                    Script.WriteTimestampedLogEntry(String.Format(
                        "ModuleContentPatcher.ProcessContentPatches: Removing extraneous file {0} from {1}", Path.GetFileName(DirFile), LocalPaths.OverridePath));

                    File.Delete(DirFile);
                    ContentChanged = true;
                }
            }

            //
            // Verify that the MD5 checksum of each of the content files in the
            // ACR patch override directory matches the database's expected
            // checksum.  If not (or if the file in question didn't exist),
            // then copy the new version over from the central vault.
            //

            using (MD5CryptoServiceProvider MD5Csp = new MD5CryptoServiceProvider())
            {
                foreach (ContentPatchFile PatchFile in PatchFiles)
                {
                    bool Matched = false;
                    bool Rename = false;
                    FileUpdateMethod UpdateMethod;
                    string LocalPath = PatchFile.GetLocalPath(LocalPaths);
                    string RemotePath = String.Format("{0}\\{1}", RemoteContentPatchPath, PatchFile.FileName);
                    string FileStorePath = String.Format("{0}/{1}", FileStoreContentPatchPath, PatchFile.FileName).Replace('\\', '/');
                    string LocalHashString = "<no such file>";
                    string TransferTempFilePath = LocalPath + ".patchxfer";

                    if (File.Exists(LocalPath))
                    {
                        LocalHashString = GetFileChecksum(LocalPath, MD5Csp);

                        Matched = (LocalHashString.ToString() == PatchFile.Checksum.ToLower());
                    }

                    if (Matched)
                    {
                        Script.WriteTimestampedLogEntry(String.Format(
                            "ModuleContentPatcher.ProcessContentPatches: Content patch file {0} is up to date (checksum {1}).",
                            PatchFile.FileName,
                            LocalHashString));
                    }
                    else
                    {
                        if (File.Exists(TransferTempFilePath))
                        {
                            try
                            {
                                File.Delete(TransferTempFilePath);
                            }
                            catch (Exception e)
                            {
                                Script.WriteTimestampedLogEntry(String.Format(
                                    "ModuleContentPatcher.ProcessContentPatches: Warning: Exception {0} removing transfer temp file {1} for transfer file {2}.",
                                    e,
                                    TransferTempFilePath,
                                    PatchFile.FileName));
                            }
                        }

                        Script.WriteTimestampedLogEntry(String.Format(
                            "ModuleContentPatcher.ProcessContentPatches: Content patch file {0} needs to be updated (local checksum {1}, remote checksum {2}).  Copying file...",
                            PatchFile.FileName,
                            LocalHashString,
                            PatchFile.Checksum));

                        if (PatchFile.RecompileModule)
                        {
                            Script.WriteTimestampedLogEntry(String.Format(
                                "ModuleContentPatcher.ProcessContentPatches: Content patch file {0} requires a module recompile, flagging module for recompilation.",
                                PatchFile.FileName));
                            RecompileModule = true;
                        }

                        if (!SentNotification)
                        {
                            Script.SendInfrastructureIrcMessage(String.Format(
                                "Server '{0}' is applying a content patch, and will restart shortly.",
                                Script.GetName(Script.GetModule())));
                            SentNotification = true;
                        }

                        Script.SendInfrastructureDiagnosticIrcMessage(String.Format(
                            "Server '{0}' is updating content file '{1}'.",
                            Script.GetName(Script.GetModule()),
                            PatchFile.FileName));

                        //
                        // The file needs to be updated.  Copy it over and
                        // re-validate the checksum.  If the checksum did not
                        // match, log an error and delete the file.
                        //

                        try
                        {
                            try
                            {
                                //
                                // Try first to download via the file store
                                // provider.  If that fails (e.g. the file
                                // store is not supported), then fall back to
                                // the traditional remote vault share transfer
                                // mechanism.
                                //

                                try
                                {
                                    DownloadContentPatchFromFileStore(FileStorePath, TransferTempFilePath, ConnectionString, Script);
                                }
                                catch (Exception e)
                                {
                                    Script.WriteTimestampedLogEntry(String.Format("ModuleContentPatcher.ProcessContentPatches: Couldn't retrieve uncompressed file {0} from Azure, falling back to file share, due to exception: {1}", FileStorePath, e));
                                    File.Copy(RemotePath, TransferTempFilePath, true);
                                }
                            }
                            catch
                            {
                                throw;
                            }

                            UpdateMethod = PatchFile.UpdateMethod;

                            //
                            // If we are patching a hak, rename it away so that
                            // the file can be written to.
                            //

                            switch (UpdateMethod)
                            {

                                case FileUpdateMethod.FileUpdateMethodRename:
                                    if (File.Exists(LocalPath))
                                    {
                                        string OldFileName = LocalPath + ".old";

                                        if (File.Exists(OldFileName))
                                            File.Delete(OldFileName);

                                        File.Move(LocalPath, OldFileName);
                                        Rename = true;
                                    }
                                    break;

                                case FileUpdateMethod.FileUpdateMethodDirectReplace:
                                    break;

                            }

                            Database.ACR_IncrementStatistic("CONTENT_PATCH_" + PatchFile.Location.ToUpper());

                            try
                            {
                                if (Rename)
                                    File.Move(TransferTempFilePath, LocalPath);
                                else
                                    File.Copy(TransferTempFilePath, LocalPath, true);
                            }
                            catch
                            {
                                if (UpdateMethod == FileUpdateMethod.FileUpdateMethodRename)
                                {
                                    string OldFileName = LocalPath + ".old";

                                    try
                                    {
                                        if (File.Exists(LocalPath))
                                            File.Delete(LocalPath);
                                    }
                                    catch
                                    {
                                    }

                                    File.Move(OldFileName, LocalPath);
                                }
                                else
                                {
                                    File.Delete(LocalPath);
                                }

                                throw;
                            }

                            if (GetFileChecksum(LocalPath, MD5Csp) != PatchFile.Checksum.ToLower())
                            {
                                Script.WriteTimestampedLogEntry(String.Format(
                                    "ModuleContentPatcher.ProcessContentPatches: Content patch file {0} was copied, but checksum did not match {1}!  This may indicate a configuration error in the database, or file corruption in transit.",
                                    PatchFile.FileName,
                                    PatchFile.Checksum));
                                Script.SendInfrastructureDiagnosticIrcMessage(String.Format(
                                    "Server '{0}' had checksum mismatch for content patch file {1} after hotfix file deployment, rolling back file.",
                                    Script.GetName(Script.GetModule()),
                                    PatchFile.FileName));

                                if (UpdateMethod == FileUpdateMethod.FileUpdateMethodRename)
                                {
                                    string OldFileName = LocalPath + ".old";

                                    try
                                    {
                                        if (File.Exists(LocalPath))
                                            File.Delete(LocalPath);
                                    }
                                    catch
                                    {
                                    }

                                    File.Move(OldFileName, LocalPath);
                                }
                                else
                                {
                                    File.Delete(LocalPath);
                                }

                                Database.ACR_IncrementStatistic("CONTENT_PATCH_INCORRECT_CHECKSUM");
                            }
                            else
                            {
                                ContentChanged = true;

                                Database.ACR_IncrementStatistic("CONTENT_PATCH_UPDATED_FILE");

                                Script.WriteTimestampedLogEntry(String.Format(
                                    "ModuleContentPatcher.ProcessContentPatches: Successfully updated content patch file {0}.",
                                    PatchFile.FileName));
                            }
                        }
                        catch (Exception e)
                        {
                            Script.WriteTimestampedLogEntry(String.Format(
                                "ModuleContentPatcher.ProcessContentPatches: Exception {0} updating content patch file {1}.",
                                e,
                                PatchFile.FileName));

                            Script.SendInfrastructureDiagnosticIrcMessage(String.Format(
                                "Server '{0}' encountered exception deploying content patch file {1}, rolling back file.",
                                Script.GetName(Script.GetModule()),
                                PatchFile.FileName));
                        }
                    }

                    if (File.Exists(TransferTempFilePath))
                    {
                        try
                        {
                            File.Delete(TransferTempFilePath);
                        }
                        catch (Exception e)
                        {
                            Script.WriteTimestampedLogEntry(String.Format(
                                "ModuleContentPatcher.ProcessContentPatches: Warning: Exception {0} removing transfer temp file {1} for transfer file {2} after patching completed.",
                                e,
                                TransferTempFilePath,
                                PatchFile.FileName));
                        }
                    }
                }
            }

            //
            // Update autodownloader configuration, as necessary.
            //

            try
            {
                if (ProcessModuleDownloaderResourcesUpdates(Database, Script))
                {
                    Script.WriteTimestampedLogEntry("ModuleContentPatcher.ProcessContentPatches: Autodownloader configuration updated.");
                    ContentChanged = true;
                }
            }
            catch (Exception e)
            {
                Script.WriteTimestampedLogEntry(String.Format(
                    "ModuleContentPatcher.ProcessContentPatches: Warning: Exception {0} updating autodownloader configuration.",
                    e));

                Script.SendInfrastructureDiagnosticIrcMessage(String.Format(
                    "Server '{0}' encountered exception updating autodownloader configuration.",
                    Script.GetName(Script.GetModule())));
            }

            if (ContentChanged)
            {
                if (RecompileModule)
                {
                    Script.WriteTimestampedLogEntry("ModuleContentPatcher.ProcessContentPatches: A module recompile is required; recompiling module...");
                    CompileModuleScripts(Script, Database);
                }

                Database.ACR_IncrementStatistic("CONTENT_PATCH_REBOOT");

                Script.SendInfrastructureDiagnosticIrcMessage(String.Format(
                    "Server '{0}' restarting after content patch deployment (old HAK ACR version {1} build date {2}, old module ACR version {3}).",
                    Script.GetName(Script.GetModule()),
                    Database.ACR_GetHAKVersion(),
                    Database.ACR_GetHAKBuildDate(),
                    Database.ACR_GetVersion()));
            }

            return ContentChanged;
        }

        /// <summary>
        /// Process any updates to moduledownloaderresources.xml.
        /// </summary>
        /// <param name="Database">Supplies the database object.</param>
        /// <param name="Script">Supplies the script object.</param>
        /// <returns>True if a patch was applied and a reboot is required for
        /// it to take effect.</returns>
        public static bool ProcessModuleDownloaderResourcesUpdates(ALFA.Database Database, ACR_ServerCommunicator Script)
        {
            bool ContentChanged = false;

            //
            // Check the database for the expected download server configurations.
            //

            Database.ACR_SQLQuery("SELECT `Hash`, `DownloadHash`, `Name`, `DLSize`, `Size` FROM `content_download_config`");

            List<DownloadConfiguration> hakConfigs = new List<DownloadConfiguration>();

            //
            // Build a list of expected download configurations.
            //

            while (Database.ACR_SQLFetch())
            {
                DownloadConfiguration downloadConfig = new DownloadConfiguration();

                downloadConfig.Hash = Database.ACR_SQLGetData(0);
                downloadConfig.DownloadHash = Database.ACR_SQLGetData(1);
                downloadConfig.Name = Database.ACR_SQLGetData(2);
                downloadConfig.DLSize = Database.ACR_SQLGetData(3);
                downloadConfig.Size = Database.ACR_SQLGetData(4);

                if (String.IsNullOrEmpty(downloadConfig.Hash) ||
                    String.IsNullOrEmpty(downloadConfig.DownloadHash) ||
                    String.IsNullOrEmpty(downloadConfig.Name) ||
                    String.IsNullOrEmpty(downloadConfig.DLSize) ||
                    String.IsNullOrEmpty(downloadConfig.Size))
                {
                    continue;
                }

                hakConfigs.Add(downloadConfig);
            }

            //
            // If we have any configuration to do, we loop through and compare the 
            // configuration on the database with the configuration on the server,
            // updating the downloadresources xml if it is new.
            //

            if (hakConfigs.Count > 0)
            {
                XmlDocument moduleDownloadResources = new XmlDocument();
                moduleDownloadResources.Load(ALFA.SystemInfo.GetModuleDirectory() + "\\moduledownloaderresources.xml");
                XmlElement downloadResources = moduleDownloadResources.DocumentElement;

                foreach (DownloadConfiguration config in hakConfigs)
                {
                    foreach (XmlNode node in downloadResources.ChildNodes)
                    {
                        if (node.Attributes["name"].Value == config.Name)
                        {
                            if (node.Attributes["hash"].Value != config.Hash)
                            {
                                node.Attributes["hash"].Value = config.Hash;
                                ContentChanged = true;
                            }
                            if (node.Attributes["downloadHash"].Value != config.DownloadHash)
                            {
                                node.Attributes["downloadHash"].Value = config.DownloadHash;
                                ContentChanged = true;
                            }
                            if (node.Attributes["dlsize"].Value != config.DLSize)
                            {
                                node.Attributes["dlsize"].Value = config.DLSize;
                                ContentChanged = true;
                            }
                            if (node.Attributes["size"].Value != config.Size)
                            {
                                node.Attributes["size"].Value = config.Size;
                                ContentChanged = true;
                            }

                            if (ContentChanged)
                            {
                                Script.WriteTimestampedLogEntry(String.Format(
                                    "ModuleContentPatcher.ProcessModuleDownloaderResourcesUpdates: Updated downloader resource {0} (hash {1}).",
                                    config.Name,
                                    config.Hash));
                            }
                        }
                    }
                }

                if (ContentChanged)
                    moduleDownloadResources.Save(ALFA.SystemInfo.GetModuleDirectory() + "\\moduledownloaderresources.xml");
            }

            return ContentChanged;
        }

        /// <summary>
        /// Get the MD5 checksum of a file as a lowercased hex string.
        /// </summary>
        /// <param name="FilePath">Supplies the path to the file.</param>
        /// <param name="MD5Csp">Supplies the MD5 crypto context block.</param>
        /// <returns>The checksum string is returned.</returns>
        private static string GetFileChecksum(string FilePath, MD5CryptoServiceProvider MD5Csp)
        {
            byte[] Hash = MD5Csp.ComputeHash(File.ReadAllBytes(FilePath));
            StringBuilder HashString = new StringBuilder();

            for (int i = 0; i < Hash.Length; i += 1)
                HashString.Append(Hash[i].ToString("x2"));

            return HashString.ToString();
        }

        /// <summary>
        /// Recompile all scripts in the module.
        /// </summary>
        /// <param name="Script">Supplies the main script object.</param>
        /// <param name="Database">Supplies the database connection.</param>
        private static void CompileModuleScripts(ACR_ServerCommunicator Script, ALFA.Database Database)
        {
            ALFA.ScriptCompiler.CompilerResult Result;
            string CompilerOptions = Script.GetLocalString(Script.GetModule(), "ACR_MOD_COMPILER_OPTIONS");
            List<string> CompilerOutput = new List<string>();

            Script.WriteTimestampedLogEntry(String.Format(
                "ModuleContentPatcher.CompileModuleScripts: Compiling module scripts with compiler options '{0}'...", CompilerOptions));
            Script.SendInfrastructureDiagnosticIrcMessage(String.Format(
                "Server '{0}' is recompiling module scripts.",
                Script.GetName(Script.GetModule())));

            Result = ALFA.ScriptCompiler.CompileScript("*.nss", CompilerOptions, delegate(string Line)
            {
                if (!String.IsNullOrWhiteSpace(Line))
                {
                    Script.WriteTimestampedLogEntry(Line);
                }
                return false;
            });

            foreach (string Message in Result.Warnings)
            {
                try
                {
                    CompilerOutput.Add(Message);
                }
                catch (Exception)
                {
                }
            }

            if (Result.Compiled)
            {
                Script.WriteTimestampedLogEntry("ModuleContentPatcher.CompileModuleScripts: Module successfully recompiled.");
                Database.ACR_IncrementStatistic("CONTENT_PATCH_RECOMPILE");

                Script.SendInfrastructureDiagnosticIrcMessage(String.Format(
                    "Server '{0}' successfully recompiled module with {1} warning(s) for content patch deployment.",
                    Script.GetName(Script.GetModule()),
                    Result.Warnings.Count));
            }
            else
            {
                Script.WriteTimestampedLogEntry(String.Format(
                    "ModuleContentPatcher.CompileModuleScripts: {0} error(s) compiling module!", Result.Errors.Count));

                Script.SendInfrastructureDiagnosticIrcMessage(String.Format(
                    "Server '{0}' had {1} error(s), {2} warning(s) recompiling module for content patch deployment.",
                    Script.GetName(Script.GetModule()),
                    Result.Errors.Count,
                    Result.Warnings.Count));

                foreach (string Message in Result.Errors)
                {
                    Script.WriteTimestampedLogEntry(String.Format(
                        "ModuleContentPatcher.CompileModuleScripts: Error '{0}'.", Message));

                    try
                    {
                        CompilerOutput.Add(Message);
                    }
                    catch (Exception)
                    {
                    }
                }

                Database.ACR_IncrementStatistic("CONTENT_PATCH_RECOMPILE_FAILED");
            }

            //
            // Save compiler output to a temporary file for later retrieval.
            //

            try
            {
                string FileName = String.Format("{0}{1}ALFAModuleRecompile.log", Path.GetTempPath(), Path.DirectorySeparatorChar);

                File.WriteAllLines(FileName, CompilerOutput);
            }
            catch (Exception)
            {

            }

        }

        /// <summary>
        /// Download a content patch file from a file store.  Currently, Azure
        /// file stores are assumed.  Both compressed and uncompressed versions
        /// of the file are tried in respective order.
        /// </summary>
        /// <param name="FileStorePath">Supplies the remote file name that
        /// designates the file to download.</param>
        /// <param name="LocalFileName">Supplies the local file name to
        /// download to.</param>
        /// <param name="ConnectionString">Supplies the file store connection
        /// string.</param>
        /// <param name="Script">Supplies the script object.</param>
        private static void DownloadContentPatchFromFileStore(string FileStorePath, string LocalFileName, string ConnectionString, ACR_ServerCommunicator Script)
        {
            if (String.IsNullOrEmpty(ConnectionString))
                throw new NotSupportedException();

            //
            // Initialize the file store provider.
            //

            FileStore UpdaterStore = FileStoreProvider.CreateAzureFileStore(ConnectionString);
            FileStoreContainer UpdaterContainer = UpdaterStore.GetContainerReference(FileStoreNamespace.ACRUpdater);
            FileStoreFile UpdaterFile = UpdaterContainer.GetFileReference(FileStorePath + ".gzip");

            //
            // First attempt to retrieve a gzip compressed version of the file
            // to patch.  If that fails then fall back to a plaintext version.
            //

            try
            {
                using (MemoryStream MemStream = new MemoryStream())
                {
                    UpdaterFile.Read(MemStream);

                    MemStream.Position = 0;

                    using (FileStream OutStream = File.Create(LocalFileName))
                    {
                        using (GZipStream CompressedStream = new GZipStream(MemStream, CompressionMode.Decompress))
                        {
                            CompressedStream.CopyTo(OutStream);
                        }
                    }
                }
            }
            catch (Exception e)
            {
                Script.WriteTimestampedLogEntry(String.Format("ModuleContentPatcher.DownloadContentPatchFromFileStore: Couldn't retrieve compressed file {0} from Azure, trying uncompressed file, due to exception: {1}",
                    FileStorePath,
                    e));

                UpdaterFile = UpdaterContainer.GetFileReference(FileStorePath);

                using (FileStream OutStream = File.Create(LocalFileName))
                {
                    UpdaterFile.Read(OutStream);
                }
            }
        }

        /// <summary>
        /// Check if a file store file exists.
        /// </summary>
        /// <param name="FileStorePath">Supplies the remote file name that
        /// designates the file to check for existance.</param>
        /// <param name="ConnectionString">Supplies the file store connection
        /// string.</param>
        /// <returns>True if the file store file exists.</returns>
        private static bool ContentPatchFileStoreFileExists(string FileStorePath, string ConnectionString)
        {
            if (String.IsNullOrEmpty(ConnectionString))
                return false;

            //
            // Initialize the file store provider.
            //

            FileStore UpdaterStore = FileStoreProvider.CreateAzureFileStore(ConnectionString);
            FileStoreContainer UpdaterContainer = UpdaterStore.GetContainerReference(FileStoreNamespace.ACRUpdater);
            FileStoreFile UpdaterFile = UpdaterContainer.GetFileReference(FileStorePath + ".gzip");

            try
            {
                if (UpdaterFile.Exists())
                    return true;
            }
            catch
            {
            }

            UpdaterFile = UpdaterContainer.GetFileReference(FileStorePath);

            try
            {
                if (UpdaterFile.Exists())
                    return true;
            }
            catch
            {
            }

            return false;
        }
    }
}
