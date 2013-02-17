using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ACR_ChooserCreator
{
    interface ItemList : IDrawableList
    {
        new List<ALFA.Shared.ItemResource> drawableList { get; set; }
    }
}
