using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ALFA.Shared;

namespace ACR_ChooserCreator
{
    public interface IDrawableList
    {
        List<IListBoxItem> ListBox {get; set;}
    }
}
