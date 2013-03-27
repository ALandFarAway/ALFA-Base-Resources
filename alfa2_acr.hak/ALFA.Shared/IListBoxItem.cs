using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ALFA.Shared
{
    public static class Sorting
    {
        public static int Column = 1;
    }

    public interface IListBoxItem: IComparable<IListBoxItem>
    {
        string RowName { get; }
        string TextFields { get; }
        string Icon { get; }
        string Variables { get; }
        string Classification { get; }
    }
}
