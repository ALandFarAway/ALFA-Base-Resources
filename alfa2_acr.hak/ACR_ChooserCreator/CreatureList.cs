using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ACR_ChooserCreator
{
    interface CreatureList : IDrawableList
    {
        new List<ALFA.Shared.CreatureResource> drawableList { get; set; }
    }
}
