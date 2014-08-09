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
    /// FileStoreContainer abstraction.
    /// </summary>
    internal class AzureFileStoreContainer : FileStoreContainer
    {
        /// <summary>
        /// Instantiate a new AzureFileStoreContainer from an Azure container.
        /// </summary>
        /// <param name="Container">Supplies the container.</param>
        internal AzureFileStoreContainer(CloudBlobContainer Container)
        {
            this.Container = Container;
        }

        /// <summary>
        /// Obtain a reference to a directory by name.
        /// </summary>
        /// <param name="RelativeAddress">A string containing the name of the
        /// virtual blob directory.</param>
        /// <returns>A FileStoreDirectory object.</returns>
        public FileStoreDirectory GetDirectoryReference(string RelativeAddress)
        {
            return new AzureFileStoreDirectory(Container.GetDirectoryReference(RelativeAddress));
        }

        /// <summary>
        /// Obtain a reference to a file by name.
        /// </summary>
        /// <param name="FileName">A string containing the name of the
        /// file.</param>
        /// <returns>A FileStoreFile object.</returns>
        public FileStoreFile GetFileReference(string FileName)
        {
            return new AzureFileStoreFile(Container.GetBlockBlobReference(FileName));
        }

        /// <summary>
        /// List all files directly parented to this container.
        /// </summary>
        /// <returns>A list of file references.</returns>
        public IEnumerable<FileStoreFile> GetFiles()
        {
            List<FileStoreFile> Entries = new List<FileStoreFile>();

            foreach (var Entry in Container.ListBlobs())
            {
                if (Entry.GetType() == typeof(CloudBlockBlob))
                    Entries.Add(new AzureFileStoreFile((CloudBlockBlob)Entry));
            }

            return Entries;
        }

        /// <summary>
        /// List all directories directly parented to this container.
        /// </summary>
        /// <returns>A list of directory references.</returns>
        public IEnumerable<FileStoreDirectory> GetDirectories()
        {
            List<FileStoreDirectory> Entries = new List<FileStoreDirectory>();

            foreach (var Entry in Container.ListBlobs())
            {
                if (Entry.GetType() == typeof(CloudBlobDirectory))
                    Entries.Add(new AzureFileStoreDirectory((CloudBlobDirectory)Entry));
            }

            return Entries;
        }

        /// <summary>
        /// Create the container if it doesn't exist.  The container is assumed
        /// to be private access only.
        /// </summary>
        /// <returns>true if the container did not already exist and was
        /// created; otherwise false.</returns>
        public bool CreateIfNotExists()
        {
            return Container.CreateIfNotExists(BlobContainerPublicAccessType.Off);
        }

        /// <summary>
        /// The internal Azure container.
        /// </summary>
        private CloudBlobContainer Container;
    }
}
