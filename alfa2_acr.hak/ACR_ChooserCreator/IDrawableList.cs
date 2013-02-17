using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ALFA.Shared;

namespace ACR_ChooserCreator
{
    interface IDrawableList : IBackgroundLoadedResource
    {
        bool ResourcesLoaded { get; set; }
        List<Object> drawableList { get; set; }
    }
}
