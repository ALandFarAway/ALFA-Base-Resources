using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ALFA.Shared
{
    /// <summary>
    /// Define the interface that represents a file store container.  A
    /// container represents a top level collection of files and directories.
    /// </summary>
    public interface FileStoreContainer
    {
        /// <summary>
        /// Obtain a reference to a directory by name.
        /// </summary>
        /// <param name="RelativeAddress">A string containing the name of the
        /// virtual blob directory.</param>
        /// <returns>A FileStoreDirectory object.</returns>
        FileStoreDirectory GetDirectoryReference(string RelativeAddress);

        /// <summary>
        /// Obtain a reference to a file by name.
        /// </summary>
        /// <param name="FileName">A string containing the name of the
        /// file.</param>
        /// <returns>A FileStoreFile object.</returns>
        FileStoreFile GetFileReference(string FileName);

        /// <summary>
        /// List all files directly parented to this container.
        /// </summary>
        /// <returns>A list of file references.</returns>
        IEnumerable<FileStoreFile> GetFiles();

        /// <summary>
        /// List all directories directly parented to this container.
        /// </summary>
        /// <returns>A list of directory references.</returns>
        IEnumerable<FileStoreDirectory> GetDirectories();

        /// <summary>
        /// Create the container if it doesn't exist.  The container is assumed
        /// to be private access only.
        /// </summary>
        /// <returns>true if the container did not already exist and was
        /// created; otherwise false.</returns>
        bool CreateIfNotExists();
    }
}
