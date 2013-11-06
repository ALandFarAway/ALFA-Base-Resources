using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Security.Cryptography;
using System.Xml;

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

            public string GetLocalPath(string OverridePath, string HakPath)
            {
                if (Location == "override")
                    return OverridePath + "\\" + FileName;
                else if (Location == "hak")
                    return HakPath + FileName;
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
        /// <returns>True if a patch was applied and a reboot is required for
        /// it to take effect.</returns>
        public static bool ProcessContentPatches(string ContentPatchPath, ALFA.Database Database, ACR_ServerCommunicator Script)
        {
            bool ContentChanged = false;
            string Version = Database.ACR_GetHAKVersion();
            List<ContentPatchFile> PatchFiles = new List<ContentPatchFile>();
            string LocalContentPatchPath = ALFA.SystemInfo.GetOverrideDirectory() + "ACR_ContentPatches";
            string LocalContentPatchHakPath = ALFA.SystemInfo.GetHakDirectory();
            string RemoteContentPatchPath = String.Format("{0}{1}\\{2}", ALFA.SystemInfo.GetCentralVaultPath(), ContentPatchPath, Version);
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

            if (!Directory.Exists(LocalContentPatchPath))
                Directory.CreateDirectory(LocalContentPatchPath);

            //
            // Remove entries in the ACR patch override directory that are not
            // listed in the patch table.  These may be patches for a previous
            // version, and are not applicable.
            //

            foreach (string DirFile in Directory.GetFiles(LocalContentPatchPath))
            {
                ContentPatchFile FoundPatch = (from PF in PatchFiles
                                               where (PF.FileName.Equals(Path.GetFileName(DirFile), StringComparison.InvariantCultureIgnoreCase) && PF.Location == "override")
                                               select PF).FirstOrDefault();
                if (FoundPatch == null)
                {
                    Database.ACR_IncrementStatistic("CONTENT_PATCH_REMOVE_FILE");

                    Script.WriteTimestampedLogEntry(String.Format(
                        "ModuleContentPatcher.ProcessContentPatches: Removing extraneous file {0} from {1}", Path.GetFileName(DirFile), LocalContentPatchPath));

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
                    string LocalPath = PatchFile.GetLocalPath(LocalContentPatchPath, LocalContentPatchHakPath);
                    string RemotePath = String.Format("{0}\\{1}", RemoteContentPatchPath, PatchFile.FileName);
                    string LocalHashString = "<no such file>";
                    string TransferTempFilePath = LocalPath + ".patchxfer";

                    if (File.Exists(LocalPath) && File.Exists(RemotePath))
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

                        //
                        // The file needs to be updated.  Copy it over and
                        // re-validate the checksum.  If the checksum did not
                        // match, log an error and delete the file.
                        //

                        try
                        {
                            try
                            {
                                File.Copy(RemotePath, TransferTempFilePath, true);
                            }
                            catch
                            {
                                throw;
                            }

                            //
                            // If we are patching a hak, rename it away so that
                            // the file can be written to.
                            //

                            if (PatchFile.Location == "hak" && File.Exists(LocalPath))
                            {
                                string OldFileName = LocalPath + ".old";

                                if (File.Exists(OldFileName))
                                    File.Delete(OldFileName);

                                File.Move(LocalPath, OldFileName);

                                Database.ACR_IncrementStatistic("CONTENT_PATCH_HAK");
                                Rename = true;
                            }
                            else if (PatchFile.Location == "override")
                            {
                                Database.ACR_IncrementStatistic("CONTENT_PATCH_OVERRIDE");
                            }

                            try
                            {
                                if (Rename)
                                    File.Move(TransferTempFilePath, LocalPath);
                                else
                                    File.Copy(TransferTempFilePath, LocalPath, true);
                            }
                            catch
                            {
                                if (PatchFile.Location == "hak")
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

                                if (PatchFile.Location == "hak")
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

            Script.WriteTimestampedLogEntry(String.Format(
                "ModuleContentPatcher.CompileModuleScripts: Compiling module scripts with compiler options '{0}'...", CompilerOptions));

            Result = ALFA.ScriptCompiler.CompileScript("*.nss", CompilerOptions, delegate(string Line)
            {
                if (!String.IsNullOrWhiteSpace(Line))
                    Script.WriteTimestampedLogEntry(Line);
                return false;
            });

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
                }

                Database.ACR_IncrementStatistic("CONTENT_PATCH_RECOMPILE_FAILED");
            }

        }

    }
}
