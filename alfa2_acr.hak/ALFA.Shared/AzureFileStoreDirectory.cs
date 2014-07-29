using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Auth;
using Microsoft.WindowsAzure.Storage.Blob;

namespace ALFA.Shared
{
    /// <summary>
    /// This class encapsulates an Azure backend implementation of the
    /// FileStoreDirectory abstraction.
    /// </summary>
    internal class AzureFileStoreDirectory : FileStoreDirectory
    {
        /// <summary>
        /// Instantiate a new AzureFileStoreDirectory from an Azure directory.
        /// </summary>
        /// <param name="Directory">Supplies the directory.</param>
        internal AzureFileStoreDirectory(CloudBlobDirectory Directory)
        {
            this.Directory = Directory;
        }

        /// <summary>
        /// Obtain a reference to a subdirectory by name.
        /// </summary>
        /// <param name="ItemName">The name of the virtual
        /// subdirectory.</param>
        /// <returns>A FileStoreDirectory object.</returns>
        public FileStoreDirectory GetDirectoryReference(string ItemName)
        {
            return new AzureFileStoreDirectory(Directory.GetDirectoryReference(ItemName));
        }

        /// <summary>
        /// List all files directly parented to this directory.
        /// </summary>
        /// <returns>A list of file references.</returns>
        public IEnumerable<FileStoreFile> GetFiles()
        {
            List<FileStoreFile> Entries = new List<FileStoreFile>();

            foreach (var Entry in Directory.ListBlobs())
            {
                if (Entry.GetType() == typeof(CloudBlockBlob))
                    Entries.Add(new AzureFileStoreFile((CloudBlockBlob)Entry));
            }

            return Entries;
        }

        /// <summary>
        /// List all directories directly parented to this directory.
        /// </summary>
        /// <returns>A list of directory references.</returns>
        public IEnumerable<FileStoreDirectory> GetDirectories()
        {
            List<FileStoreDirectory> Entries = new List<FileStoreDirectory>();

            foreach (var Entry in Directory.ListBlobs())
            {
                if (Entry.GetType() == typeof(CloudBlobDirectory))
                    Entries.Add(new AzureFileStoreDirectory((CloudBlobDirectory)Entry));
            }

            return Entries;
        }

        /// <summary>
        /// Obtain a reference to a file by name.
        /// </summary>
        /// <param name="FileName">A string containing the name of the
        /// file.</param>
        /// <returns>A FileStoreFile object.</returns>
        public FileStoreFile GetFileReference(string FileName)
        {
            return new AzureFileStoreFile(Directory.GetBlockBlobReference(FileName));
        }


        /// <summary>
        /// The internal Azure directory.
        /// </summary>
        private CloudBlobDirectory Directory;
    }
}
