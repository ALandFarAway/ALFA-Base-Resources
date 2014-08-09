using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Auth;
using Microsoft.WindowsAzure.Storage.Blob;
using Microsoft.WindowsAzure.Storage.Blob.Protocol;
using Microsoft.WindowsAzure.Storage.Shared.Protocol;

namespace ALFA.Shared
{
    /// <summary>
    /// This class encapsulates an Azure backend implementation of the
    /// FileStoreFile abstraction.
    /// </summary>
    internal class AzureFileStoreFile : FileStoreFile
    {
        /// <summary>
        /// Instantiate a new AzureFileStoreFile from an Azure blob.
        /// </summary>
        /// <param name="Blob">Supplies the blob.</param>
        internal AzureFileStoreFile(CloudBlockBlob Blob)
        {
            this.Blob = Blob;
        }

        /// <summary>
        /// Obtain a reference to the container.
        /// </summary>
        public FileStoreContainer Container { get { return new AzureFileStoreContainer(Blob.Container); } }

        /// <summary>
        /// Obtain a reference to the parent directory.
        /// </summary>
        public FileStoreDirectory Parent { get { return new AzureFileStoreDirectory(Blob.Parent); } }

        /// <summary>
        /// Replace the contents of the file with the given Stream.
        /// </summary>
        /// <param name="Stream">Supplies the Stream to write into the file.
        /// The original contents of the file are replaced.</param>
        public void Write(Stream Stream)
        {
            Blob.UploadFromStream(Stream);
        }

        /// <summary>
        /// Replace the contents of the file with the given Stream if the
        /// stored file has not been modified since a given time.
        /// </summary>
        /// <param name="Stream">Supplies the Stream to write into the file.
        /// The original contents of the file are replaced.</param>
        /// <param name="Time">Supplies the modified time cutoff.</param>
        public void WriteIfNotModifiedSince(Stream Stream, DateTimeOffset Time)
        {
            try
            {
                Blob.UploadFromStream(Stream, AccessCondition.GenerateIfNotModifiedSinceCondition(Time));
            }
            catch (StorageException Ex)
            {
                if (Ex.RequestInformation.HttpStatusMessage == AzureFileStoreStatusCodes.ConditionNotMet)
                    throw new FileStoreConditionNotMetException(Ex);

                throw;
            }
        }

        /// <summary>
        /// Read the entire contents of the file into the given Stream.
        /// </summary>
        /// <param name="Stream">Supplies the Stream to read the entire
        /// contents of the file into.</param>
        public void Read(Stream Stream)
        {
            Blob.DownloadToStream(Stream);
        }

        /// <summary>
        /// Read the entire contents of the file into the given Stream if it is
        /// not modified since a given time.
        /// </summary>
        /// <param name="Stream">Supplies the Stream to read the entire
        /// contents of the file into.</param>
        /// <param name="Time">Supplies the modified since limit.</param>
        public void ReadIfModifiedSince(Stream Stream, DateTimeOffset Time)
        {
            try
            {
                Blob.DownloadToStream(Stream, AccessCondition.GenerateIfModifiedSinceCondition(Time));
            }
            catch (StorageException Ex)
            {
                if (Ex.RequestInformation.HttpStatusMessage == AzureFileStoreStatusCodes.ConditionNotMet)
                    throw new FileStoreConditionNotMetException(Ex);

                throw;
            }
        }

        /// <summary>
        /// Delete the file.
        /// </summary>
        public void Delete()
        {
            Blob.Delete();
        }

        /// <summary>
        /// Load properties and metadata.
        /// </summary>
        public void FetchAttributes()
        {
            Blob.FetchAttributes();
        }

        /// <summary>
        /// Set new metadata for the file.
        /// </summary>
        public void SetMetadata()
        {
            Blob.SetMetadata();
        }

        /// <summary>
        /// Returns true if the file exists.
        /// </summary>
        public bool Exists()
        {
            return Blob.Exists();
        }

        /// <summary>
        /// The last modified timestamp of the file.
        /// </summary>
        public DateTimeOffset? LastModified
        {
            get
            {
                return Blob.Properties.LastModified;
            }
        }

        /// <summary>
        /// The metadata for the file.
        /// </summary>
        public IDictionary<string, string> Metadata
        {
            get
            {
                return Blob.Metadata;
            }
        }

        /// <summary>
        /// The storage URI of the file.
        /// </summary>
        public Uri Uri { get { return Blob.Uri; } }

        /// <summary>
        /// The name of the file.
        /// </summary>
        public string Name { get { return Blob.Name; } }

        /// <summary>
        /// The internal Azure blob for this file.
        /// </summary>
        private CloudBlockBlob Blob;
    }
}
