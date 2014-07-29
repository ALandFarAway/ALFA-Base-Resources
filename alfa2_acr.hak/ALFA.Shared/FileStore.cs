using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ALFA.Shared
{
    /// <summary>
    /// Define the interface used to communicate with file store services.
    /// 
    /// The file store represents a named blob based storage, i.e. key/value
    /// pairs where a key names a (potentially large, i.e. data file based)
    /// blob.
    /// </summary>
    public interface FileStore
    {
        /// <summary>
        /// Obtain a reference to a container by name.
        /// </summary>
        /// <param name="ContainerName">A string containing the name of the
        /// container.</param>
        /// <returns>A FileStoreContainer object.</returns>
        FileStoreContainer GetContainerReference(string ContainerName);
    }
}
