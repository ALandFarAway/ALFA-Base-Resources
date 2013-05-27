using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace AdvancedLogParser
{
    class ListViewItemComparer : IComparer
    {
        bool rev = false;
        private int col;
        public ListViewItemComparer()
        {
            col = 0;
        }
        public ListViewItemComparer(int column, bool reverse)
        {
            rev = reverse;
            col = column;
        }
        public int Compare(object x, object y)
        {
            int xInt;
            int yInt;
            float xFloat;
            float yFloat;
            if (Int32.TryParse(((ListViewItem)x).SubItems[col].Text, out xInt))
            {
                int.TryParse(((ListViewItem)y).SubItems[col].Text, out yInt);
                return (rev) ? xInt.CompareTo(yInt) : xInt.CompareTo(yInt) * -1;
            }
            else if (float.TryParse(((ListViewItem)x).SubItems[col].Text, out xFloat))
            {
                float.TryParse(((ListViewItem)y).SubItems[col].Text, out yFloat);
                return (rev) ? xFloat.CompareTo(yFloat) : xFloat.CompareTo(yFloat) * -1;
            }
            else
            {
                if (!rev)
                    return String.Compare(((ListViewItem)x).SubItems[col].Text, ((ListViewItem)y).SubItems[col].Text);
                else
                    return String.Compare(((ListViewItem)y).SubItems[col].Text, ((ListViewItem)x).SubItems[col].Text);
            }
        }
    }
}
