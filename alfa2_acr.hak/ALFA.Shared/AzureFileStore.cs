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
    /// FileStore abstraction.  There can be multiple Azure storage backends if
    /// the application requires the ability to communicate with multiple
    /// endpoints, each with a unique connection string.
    /// </summary>
    internal class AzureFileStore : FileStore
    {
        /// <summary>
        /// Instantiate a new AzureFileStore object.
        /// </summary>
        /// <param name="ConnectionString">Supplies the Azure connection string
        /// to initialize the file store against.</param>
        internal AzureFileStore(string ConnectionString)
        {
            StorageAccount = CloudStorageAccount.Parse(ConnectionString);
            BlobClient = StorageAccount.CreateCloudBlobClient();

            BlobClient.DefaultRequestOptions.StoreBlobContentMD5 = true;
            BlobClient.DefaultRequestOptions.DisableContentMD5Validation = false;
        }

        /// <summary>
        /// Obtain a reference to a container by name.
        /// </summary>
        /// <param name="ContainerName">A string containing the name of the
        /// container.</param>
        /// <returns>A FileStoreContainer object.</returns>
        public FileStoreContainer GetContainerReference(string ContainerName)
        {
            return new AzureFileStoreContainer(BlobClient.GetContainerReference(ContainerName));
        }

        /// <summary>
        /// The Azure storage account.
        /// </summary>
        private CloudStorageAccount StorageAccount;

        /// <summary>
        /// The Azure blob storage client.
        /// </summary>
        private CloudBlobClient BlobClient;
    }
}
