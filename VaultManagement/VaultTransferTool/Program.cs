using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Reflection;
using System.Text;
using System.Threading;
using ALFA.Shared;

namespace VaultTransferTool
{
    class Program
    {
        static void Main(string[] args)
        {
            string ConnectionString = null;
            string DownloadTo = null;
            string UploadFrom = null;
            string DeleteFileName = null;
            bool IncludeAllFiles = false;

            Console.CancelKeyPress += Console_CancelKeyPress;

            Console.WriteLine("ALFA Azure Vault Management Tool v{0}", Assembly.GetExecutingAssembly().GetName().Version);
            Console.WriteLine();

            for (int i = 0; i < args.Length; i += 1)
            {
                if (i + 1 < args.Length && args[i].ToLowerInvariant() == "-connectionstring")
                {
                    ConnectionString = args[i+1];
                    i += 1;
                    continue;
                }
                else if (i + 1 < args.Length && args[i].ToLowerInvariant() == "-download")
                {
                    DownloadTo = args[i+1];
                    i += 1;
                    continue;
                }
                else if (i + 1 < args.Length && args[i].ToLowerInvariant() == "-upload")
                {
                    UploadFrom = args[i+1];
                    i += 1;
                    continue;
                }
                else if (i + 1 < args.Length && args[i].ToLowerInvariant() == "-delete")
                {
                    DeleteFileName = args[i + 1];
                    i += 1;
                    continue;
                }
                else if (args[i].ToLowerInvariant() == "-all")
                {
                    IncludeAllFiles = true;
                    continue;
                }

                Console.WriteLine("Unrecognized argument: {0}", args[i]);
                PrintUsage();
                return;
            }

            if ((String.IsNullOrEmpty(ConnectionString)) ||
                ((String.IsNullOrEmpty(DownloadTo) ? 0 : 1) + (String.IsNullOrEmpty(UploadFrom) ? 0 : 1) + (String.IsNullOrEmpty(DeleteFileName) ? 0 : 1) != 1))
            {
                PrintUsage();
                return;
            }

            try
            {
                FileStore Store = FileStoreProvider.CreateAzureFileStore(ConnectionString);
                FileStoreContainer Container = Store.GetContainerReference(FileStoreNamespace.ServerVault);

                if (!String.IsNullOrEmpty(DownloadTo))
                {
                    Console.WriteLine("Downloading from vault to {0} in (CTRL+C in 5 seconds to cancel)...", DownloadTo);
                    Thread.Sleep(5000);

                    foreach (FileStoreDirectory Directory in Container.GetDirectories())
                    {
                        foreach (FileStoreFile File in Directory.GetFiles())
                        {
                            string RemoteName;

                            if (AbortProgram)
                            {
                                Console.WriteLine("Cancelled.");
                                return;
                            }

                            //
                            // Attempt to create the local file using the
                            // original filename case.
                            //

                            File.FetchAttributes();
                            if (File.Metadata.TryGetValue("OriginalFileName", out RemoteName))
                            {
                                if (RemoteName.ToLowerInvariant() != File.Name)
                                {
                                    Console.WriteLine("* File {0} OriginalFileName {1} is malformed, ignoring.", File.Name, RemoteName);
                                    RemoteName = File.Name;
                                }
                            }
                            else
                            {
                                RemoteName = File.Name;
                            }

                            string RemoteDirName = Path.GetDirectoryName(RemoteName);
                            string RemoteFileName = Path.GetFileName(RemoteName);

                            if (!IncludeAllFiles && !RemoteFileName.ToLowerInvariant().EndsWith(".bic"))
                            {
                                Console.WriteLine("* File {0} is not a character file, skipping...", RemoteName);
                                continue;
                            }

                            if (!ALFA.SystemInfo.IsSafeFileName(RemoteFileName) || RemoteDirName.IndexOfAny(Path.GetInvalidPathChars()) != -1)
                            {
                                Console.WriteLine("* File {0} has an unsafe filename, skipping...", RemoteName);
                                continue;
                            }

                            string FileName = String.Format("{0}{1}{2}", DownloadTo, Path.DirectorySeparatorChar, RemoteDirName);
                            FileStream FsFile = null;
                            DateTimeOffset? Offset = null;

                            if (!System.IO.Directory.Exists(FileName))
                                System.IO.Directory.CreateDirectory(FileName);

                            FileName = String.Format("{0}{1}{2}", FileName, Path.DirectorySeparatorChar, RemoteFileName);

                            //
                            // Download the file if it didn't exist locally, or
                            // if the local file was older than the vault based
                            // file.
                            //

                            try
                            {
                                try
                                {
                                    FsFile = System.IO.File.Open(FileName, FileMode.Open, FileAccess.ReadWrite);
                                    Offset = System.IO.File.GetLastWriteTimeUtc(FileName);
                                }
                                catch (DirectoryNotFoundException)
                                {
                                }
                                catch (FileNotFoundException)
                                {
                                }

                                if (FsFile == null)
                                {
                                    FsFile = System.IO.File.Open(FileName, FileMode.OpenOrCreate, FileAccess.ReadWrite);
                                    Offset = null;
                                }

                                if (Offset != null)
                                {
                                    Console.Write("Downloading file {0}...", FileName);

                                    try
                                    {
                                        try
                                        {
                                            File.ReadIfModifiedSince(FsFile, Offset.Value);
                                        }
                                        catch
                                        {
                                            FsFile.Dispose();
                                            System.IO.File.SetLastWriteTimeUtc(FileName, Offset.Value.UtcDateTime);
                                            throw;
                                        }

                                        FsFile.Dispose();
                                        System.IO.File.SetLastWriteTimeUtc(FileName, File.LastModified.Value.UtcDateTime);
                                        Console.WriteLine(" done.");
                                    }
                                    catch (FileStoreConditionNotMetException)
                                    {
                                        Console.WriteLine(" already up to date.");
                                    }
                                }
                                else
                                {
                                    Console.Write("Downloading file {0}...", FileName);

                                    try
                                    {
                                        File.Read(FsFile);
                                    }
                                    catch
                                    {
                                        FsFile.Dispose();
                                        System.IO.File.Delete(FileName);
                                    }

                                    FsFile.Dispose();
                                    System.IO.File.SetLastWriteTimeUtc(FileName, File.LastModified.Value.UtcDateTime);
                                    Console.WriteLine("done.");
                                }
                            }
                            finally
                            {
                                FsFile.Dispose();
                            }
                        }
                    }
                }
                else if (!String.IsNullOrEmpty(UploadFrom))
                {
                    Console.WriteLine("Uploading from {0} to vault (CTRL+C in 5 seconds to cancel)...", UploadFrom);
                    Thread.Sleep(5000);

                    //
                    // Canonicalize the upload from base path so that relative
                    // filenames can be ascertained for naming files that are
                    // transferred to the vault.
                    //

                    UploadFrom = Path.GetFullPath(UploadFrom);

                    if (UploadFrom.EndsWith(Path.DirectorySeparatorChar.ToString()))
                        UploadFrom = UploadFrom.Substring(0, UploadFrom.Length - 1);

                    foreach (string FsFileName in Directory.EnumerateFiles(UploadFrom, "*.bic", SearchOption.AllDirectories))
                    {
                        string RemoteName;

                        if (AbortProgram)
                        {
                            Console.WriteLine("Cancelled.");
                            return;
                        }

                        if (!IncludeAllFiles && !FsFileName.ToLowerInvariant().EndsWith(".bic"))
                        {
                            Console.WriteLine("* File {0} is not a character file, skipping...", FsFileName);
                            continue;
                        }

                        //
                        // Upload files that did not exist or which were newer
                        // on the local side.
                        //

                        RemoteName = FsFileName.Substring(UploadFrom.Length + 1);

                        DateTimeOffset FsLastModified = System.IO.File.GetLastWriteTimeUtc(FsFileName);

                        using (FileStream FsFile = System.IO.File.OpenRead(FsFileName))
                        {
                            Console.Write("Uploading file {0}...", RemoteName);

                            try
                            {
                                FileStoreFile RemoteFile = Container.GetFileReference(RemoteName.Replace('\\', '/').ToLowerInvariant());

                                try
                                {
                                    RemoteFile.FetchAttributes();

                                    if (RemoteFile.LastModified >= FsLastModified)
                                    {
                                        Console.WriteLine(" already up to date.");
                                        continue;
                                    }
                                }
                                catch
                                {
                                }

                                RemoteFile.Metadata["OriginalFileName"] = RemoteName.Replace('\\', '/');
                                RemoteFile.WriteIfNotModifiedSince(FsFile, FsLastModified);
                                Console.WriteLine(" done.");
                            }
                            catch (FileStoreConditionNotMetException)
                            {
                                Console.WriteLine(" already up to date.");
                            }
                        }
                    }
                }
                else if (!String.IsNullOrEmpty(DeleteFileName))
                {
                    Console.Write("Deleting file {0} from vault (CTRL+C in 5 seconds to cancel)...", DeleteFileName);
                    Thread.Sleep(5000);

                    if (AbortProgram)
                    {
                        Console.WriteLine("Cancelled.");
                        return;
                    }

                    //
                    // Delete vault file if it existed.
                    //

                    FileStoreFile RemoteFile = Container.GetFileReference(DeleteFileName.Replace('\\', '/').ToLowerInvariant());

                    if (!RemoteFile.Exists())
                    {
                        Console.Write(" file not found on the vault.");
                    }
                    else
                    {
                        RemoteFile.Delete();
                        Console.Write(" done");
                    }
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("Exception: {0}", e);
                return;
            }
        }

        static void Console_CancelKeyPress(object sender, ConsoleCancelEventArgs e)
        {
            Console.WriteLine("Cancelling...");
            AbortProgram = true;

            e.Cancel = true;
        }

        static void PrintUsage()
        {
            Console.WriteLine("Usage: VaultTransferTool [-connectionstring <connection string>] [-download <path> | -upload <path> | -delete <path>] [-includeall]");
            Console.WriteLine();
            Console.WriteLine("The -connectionstring argument designates the Azure connection string to use to communicate with the vault.");
            Console.WriteLine();
            Console.WriteLine("One of -download <path>, -upload <path>, or -delete <path> must be specified.  The -download and -upload options enable downloading files from the vault, or uploading files to the vault.  The given path should be laid out like a normal server vault directory, with a subdirectory for each account name and character (*.bic) files in each subdirectory.  Files are never deleted from the remote vault, only updated with -download or -upload.  A file is only transferred if the source of the transfer is newer than the destination file (unmodified files aren't copied again).");
            Console.WriteLine();
            Console.WriteLine("To delete a file, use -delete <path> where <path> is in the form of account\\character.bic.  The file is permanently deleted from the Azure vault, but the cache should still be purged from each server using the purge cache tool to ensure that it is not regenerated the next time a player logs on to a server that had previously cached the character file to delete.  The file to be deleted doesn't need to exist on the local machine, and is not deleted from the local machine if it did exist.");
            Console.WriteLine();
            Console.WriteLine("Normally, only character files (*.bic) are transferred.  Use the -includeall argument to transfer all files, regardless of file extension.");
        }

        private static volatile bool AbortProgram = false;
    }
}
