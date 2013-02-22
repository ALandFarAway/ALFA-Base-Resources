using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ALFA.Shared
{
    public interface IBackgroundLoadedResource
    {
        /// <summary>
        /// Wait for resources to become available.
        /// </summary>
        /// <param name="Wait">Supplies true to perform a blocking wait, else
        /// false to return immediately with the current availability status.
        /// </param>
        /// <returns>True if the resources are available to be accessed, else
        /// false if they are not yet loaded.</returns>
        bool WaitForResourcesLoaded(bool Wait);
    }
}
