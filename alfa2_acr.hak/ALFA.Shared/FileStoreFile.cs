using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace ALFA.Shared
{
    /// <summary>
    /// Define the interface that represents a file store file.
    /// </summary>
    public interface FileStoreFile
    {

        /// <summary>
        /// Obtain a reference to the container.
        /// </summary>
        FileStoreContainer Container { get; }

        /// <summary>
        /// Obtain a reference to the parent directory.
        /// </summary>
        FileStoreDirectory Parent { get; }

        /// <summary>
        /// Replace the contents of the file with the given Stream.
        /// </summary>
        /// <param name="Stream">Supplies the Stream to write into the file.
        /// The original contents of the file are replaced.</param>
        void Write(Stream Stream);

        /// <summary>
        /// Replace the contents of the file with the given Stream if the
        /// stored file has not been modified since a given time.
        /// </summary>
        /// <param name="Stream">Supplies the Stream to write into the file.
        /// The original contents of the file are replaced.</param>
        /// <param name="Time">Supplies the modified time cutoff.</param>
        void WriteIfNotModifiedSince(Stream Stream, DateTimeOffset Time);

        /// <summary>
        /// Read the entire contents of the file into the given Stream.
        /// </summary>
        /// <param name="Stream">Supplies the Stream to read the entire
        /// contents of the file into.</param>
        void Read(Stream Stream);

        /// <summary>
        /// Read the entire contents of the file into the given Stream if it is
        /// not modified since a given time.
        /// </summary>
        /// <param name="Stream">Supplies the Stream to read the entire
        /// contents of the file into.</param>
        /// <param name="Time">Supplies the modified since limit.</param>
        void ReadIfModifiedSince(Stream Stream, DateTimeOffset Time);

        /// <summary>
        /// Delete the file.
        /// </summary>
        void Delete();

        /// <summary>
        /// Load properties and metadata.
        /// </summary>
        void FetchAttributes();

        /// <summary>
        /// Set new metadata for the file.
        /// </summary>
        void SetMetadata();

        /// <summary>
        /// Returns true if the file exists.
        /// </summary>
        bool Exists();

        /// <summary>
        /// The last modified timestamp of the file.
        /// </summary>
        DateTimeOffset? LastModified { get; }

        /// <summary>
        /// The metadata for the file.
        /// </summary>
        IDictionary<string, string> Metadata { get; }

        /// <summary>
        /// The storage URI of the file.
        /// </summary>
        Uri Uri { get; }

        /// <summary>
        /// The name of the file.
        /// </summary>
        string Name { get; }
    }
}
