using System;
using System.Collections.Generic;
using System.Text;

namespace ABM_creator
{
    static class DebugWindow
    {
        static System.Windows.Forms.Form form;
        static System.Windows.Forms.ListBox listBox;
        static bool initialized = false;

        static public void PrintDebugMessage(string msg)
        {
            if (!initialized)
            {
                Initialize();
            }
            listBox.Items.Add(msg);
            listBox.Show();
        }

        private static void Initialize()
        {
            form = new System.Windows.Forms.Form();
            listBox = new System.Windows.Forms.ListBox();
            listBox.Sorted = false;
            listBox.Size = new System.Drawing.Size(400, 300);
            listBox.HorizontalScrollbar = true;

            form.Controls.Add(listBox);
            form.Size = new System.Drawing.Size(430, 330);
            form.Text = "Debug Window";
            form.Show();

            initialized = true;
        }
    }
}
