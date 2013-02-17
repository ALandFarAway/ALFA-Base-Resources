using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ALFA.Shared
{
    public interface IBackgroundLoadedResource
    {
        bool ResourcesLoaded { get; set; }
    }
}
