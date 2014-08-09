using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ALFA.Shared
{
    /// <summary>
    /// Define the interface that represents a file store directory.  A
    /// directory represents a collection of files.
    /// </summary>
    public interface FileStoreDirectory
    {
        /// <summary>
        /// Obtain a reference to a subdirectory by name.
        /// </summary>
        /// <param name="ItemName">The name of the virtual
        /// subdirectory.</param>
        /// <returns>A FileStoreDirectory object.</returns>
        FileStoreDirectory GetDirectoryReference(string ItemName);

        /// <summary>
        /// List all files directly parented to this directory.
        /// </summary>
        /// <returns>A list of file references.</returns>
        IEnumerable<FileStoreFile> GetFiles();

        /// <summary>
        /// List all directories directly parented to this directory.
        /// </summary>
        /// <returns>A list of directory references.</returns>
        IEnumerable<FileStoreDirectory> GetDirectories();

        /// <summary>
        /// Obtain a reference to a file by name.
        /// </summary>
        /// <param name="FileName">A string containing the name of the
        /// file.</param>
        /// <returns>A FileStoreFile object.</returns>
        FileStoreFile GetFileReference(string FileName);

        /// <summary>
        /// The storage URI of the directory.
        /// </summary>
        Uri Uri { get; }
    }
}
