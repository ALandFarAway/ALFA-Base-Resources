using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ACR_ChooserCreator
{
    interface PlaceableList : IDrawableList
    {
        new List<ALFA.Shared.PlaceableResource> drawableList { get; set; }
    }
}
