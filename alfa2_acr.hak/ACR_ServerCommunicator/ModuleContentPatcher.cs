using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Security.Cryptography;

namespace ACR_ServerCommunicator
{
    static class ModuleContentPatcher
    {

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

            Database.ACR_SQLQuery(String.Format(
                "SELECT `FileName`, `Location`, `Checksum` FROM `content_patch_files` WHERE `HakVersion` = '{0}'",
                Database.ACR_SQLEncodeSpecialChars(Version)));

            while (Database.ACR_SQLFetch())
            {
                ContentPatchFile PatchFile = new ContentPatchFile();

                PatchFile.FileName = Database.ACR_SQLGetData(0);
                PatchFile.Location = Database.ACR_SQLGetData(1);
                PatchFile.Checksum = Database.ACR_SQLGetData(2);

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
                    string LocalPath = PatchFile.GetLocalPath(LocalContentPatchPath, LocalContentPatchHakPath);
                    string RemotePath = String.Format("{0}\\{1}", RemoteContentPatchPath, PatchFile.FileName);
                    string LocalHashString = "<no such file>";

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
                        Script.WriteTimestampedLogEntry(String.Format(
                            "ModuleContentPatcher.ProcessContentPatches: Content patch file {0} needs to be updated (local checksum {1}, remote checksum {2}).  Copying file...",
                            PatchFile.FileName,
                            LocalHashString,
                            PatchFile.Checksum));

                        //
                        // The file needs to be updated.  Copy it over and
                        // re-validate the checksum.  If the checksum did not
                        // match, log an error and delete the file.
                        //

                        try
                        {
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
                            }
                            else if (PatchFile.Location == "override")
                            {
                                Database.ACR_IncrementStatistic("CONTENT_PATCH_OVERRIDE");
                            }

                            try
                            {
                                File.Copy(RemotePath, LocalPath, true);
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

                                if (PatchFile.Location == "hak")
                                {
                                    string OldFileName = LocalPath + ".old";

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
                        }
                    }
                }
            }

            if (ContentChanged)
                Database.ACR_IncrementStatistic("CONTENT_PATCH_REBOOT");

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

    }
}
