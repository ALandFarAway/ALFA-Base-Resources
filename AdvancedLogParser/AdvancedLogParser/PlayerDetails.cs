using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Resources;
using System.Text;
using System.Drawing;
using System.Windows.Forms;

namespace AdvancedLogParser
{
    class PlayerDetails: Form
    {
        ListView characterBox = new ListView();

        Label cdKeyLabel = new Label();
        Label cdKeyValue = new Label();
        Label firstLoginLabel = new Label();
        Label firstLoginValue = new Label();
        Label lastLoginLabel = new Label();
        Label lastLoginValue = new Label();
        Label Is18Plus = new Label();
        Label IsDM = new Label();
        Label IsBanned = new Label();

        bool reverseSort = false;
        DateTime lastSorted = DateTime.Now;
        int currentSort = 0;

        public PlayerDetails(Player player)
        {
            characterBox.Columns.Add("Name");
            characterBox.Columns.Add("Class/Level");
            characterBox.Columns.Add("DM?");
            characterBox.Columns.Add("Dead?");

            characterBox.Columns[0].Width = 200;
            characterBox.Columns[1].Width = 200;
            characterBox.Columns[2].Width = 50;
            characterBox.Columns[3].Width = 50;

            characterBox.Width = 520;
            characterBox.Height = 490;

            characterBox.ColumnClick += ColumnSort;
            characterBox.DoubleClick += CharacterDoubleClick;
            characterBox.View = View.Details;

            characterBox.Location = new Point(200, 0);

            characterBox.FullRowSelect = true;

            this.Width = 730;
            this.Height = 520;

            this.Name = player.CommunityIds[0];
            this.Text = this.Name;

            cdKeyLabel.Text = "CD Key:";
            cdKeyLabel.Size = cdKeyLabel.PreferredSize;
            cdKeyLabel.Location = new Point(5, 5);
            cdKeyValue.Text = player.CDKey;
            cdKeyValue.Size = cdKeyValue.PreferredSize;
            cdKeyValue.Location = new Point(100, cdKeyLabel.Location.Y);

            firstLoginLabel.Text = "First Login:";
            firstLoginLabel.Size = firstLoginLabel.PreferredSize;
            firstLoginLabel.Location = new Point(5, cdKeyLabel.Location.Y + cdKeyLabel.Height);
            firstLoginValue.Text = String.Format("{0:yyyy/MM/dd}", player.FirstLogin);
            firstLoginValue.Size = firstLoginValue.PreferredSize;
            firstLoginValue.Location = new Point(100, firstLoginLabel.Location.Y);

            lastLoginLabel.Text = "Last Login:";
            lastLoginLabel.Size = lastLoginLabel.PreferredSize;
            lastLoginLabel.Location = new Point(5, firstLoginLabel.Location.Y + firstLoginLabel.Height);
            lastLoginValue.Text = String.Format("{0:yyyy/MM/dd}", player.LastLogin);
            lastLoginValue.Size = lastLoginValue.PreferredSize;
            lastLoginValue.Location = new Point(100, lastLoginLabel.Location.Y);

            if (player.Is18Plus)
            {
                Is18Plus.Text = "Is the age of majority";
            }
            else
            {
                Is18Plus.Text = "Is NOT the age of majority";
                Is18Plus.ForeColor = Color.Red;
                Is18Plus.BackColor = Color.Yellow;
            }
            Is18Plus.Size = Is18Plus.PreferredSize;
            Is18Plus.Location = new Point(5, lastLoginLabel.Location.Y + lastLoginLabel.Height);
            if (player.IsBanned)
            {
                IsBanned.Text = "Has been BANNED";
                IsBanned.ForeColor = Color.Red;
                IsBanned.BackColor = Color.Yellow;
            }
            else
            {
                IsBanned.Text = "Has not been banned.";
            }
            IsBanned.Size = IsBanned.PreferredSize;
            IsBanned.Location = new Point(5, Is18Plus.Location.Y + Is18Plus.Height);
            if (player.IsDM)
            {
                IsDM.Text = "Is a DM";
            }
            else
            {
                IsDM.Text = "Is not a DM";
            }
            IsDM.Size = IsDM.PreferredSize;
            IsDM.Location = new Point(5, IsBanned.Location.Y + IsBanned.Height);

            foreach (Character ownedChar in player.Characters)
            {
                string classLevel = ClassToAbbreviation(ownedChar.Class1) + ownedChar.Level1;
                if (ownedChar.Class2 < 255)
                {
                    classLevel += "/" + ClassToAbbreviation(ownedChar.Class2) + ownedChar.Level2;
                }
                if (ownedChar.Class3 < 255)
                {
                    classLevel += "/" + ClassToAbbreviation(ownedChar.Class3) + ownedChar.Level3;
                }
                string dm = "";
                string dead = ((ownedChar.Status & 0x001) == 0x001) ? "Y" : "";
                characterBox.Items.Add(new ListViewItem(new string[] { ownedChar.Name, classLevel, dm, dead, ownedChar.Id.ToString() }));
            }

            this.Controls.Add(characterBox);
            this.Controls.Add(cdKeyLabel);
            this.Controls.Add(cdKeyValue);
            this.Controls.Add(firstLoginLabel);
            this.Controls.Add(firstLoginValue);
            this.Controls.Add(lastLoginLabel);
            this.Controls.Add(lastLoginValue);
            this.Controls.Add(IsBanned);
            this.Controls.Add(Is18Plus);
            this.Controls.Add(IsDM);
        }

        private void CharacterDoubleClick(object Sender, EventArgs e)
        {
            uint characterId;
            if (uint.TryParse(characterBox.SelectedItems[0].SubItems[4].Text, out characterId))
            {
                new CharacterDetails(Characters.List[characterId]).Show();
            }
            else
            {
                MessageBox.Show(String.Format("Could not find a character with ID {0}", characterId));
            }
        }
        private void ColumnSort(object Sender, ColumnClickEventArgs e)
        {
            if (DateTime.Now - lastSorted < new TimeSpan(0, 0, 0, 0, 10))
                return;

            // Actual sorting.
            if (e.Column == currentSort)
            {
                reverseSort = !reverseSort;
            }
            currentSort = e.Column;
            lastSorted = DateTime.Now;
            characterBox.ListViewItemSorter = new ListViewItemComparer(e.Column, reverseSort);
        }

        public static string ClassToAbbreviation(uint abbrClass)
        {
            switch (abbrClass)
            {
                case 0:
                    return "Brb ";
                case 1:
                    return "Brd ";
                case 2:
                    return "Clr ";
                case 3:
                    return "Drd ";
                case 4:
                    return "Ftr ";
                case 5:
                    return "Mnk ";
                case 6:
                    return "Pal ";
                case 7:
                    return "Rgr ";
                case 8:
                    return "Rog ";
                case 9:
                    return "Sor ";
                case 10:
                    return "Wiz ";
                case 11:
                    return "Abr ";
                case 12:
                    return "Ani ";
                case 13:
                    return "Con ";
                case 14:
                    return "MnH ";
                case 15:
                    return "Ele ";
                case 16:
                    return "Fey ";
                case 17:
                    return "Drg ";
                case 18:
                    return "Und ";
                case 19:
                    return "Com ";
                case 21:
                    return "Bst ";
                case 22:
                    return "Gia ";
                case 23:
                    return "MgB ";
                case 24:
                    return "Out ";
                case 25:
                    return "SCh ";
                case 26:
                    return "Ver ";
                case 27:
                    return "ShD ";
                case 28:
                    return "Hpr ";
                case 29:
                    return "AA ";
                case 30:
                    return "Ass ";
                case 31:
                    return "BlG ";
                case 32:
                    return "DC ";
                case 33:
                    return "WM ";
                case 34:
                    return "PM ";
                case 35:
                    return "Plt ";
                case 36:
                    return "DwD ";
                case 37:
                    return "DD ";
                case 38:
                    return "Ooz ";
                case 39:
                    return "Wlk ";
                case 40:
                    return "AT ";
                case 43:
                    return "FB ";
                case 44:
                    return "MT ";
                case 45:
                    return "SF ";
                case 46:
                    return "ShT ";
                case 47:
                    return "KP ";
                case 50:
                    return "Dst ";
                case 51:
                    return "WPr ";
                case 52:
                    return "EK ";
                case 53:
                    return "RW ";
                case 54:
                    return "ArS ";
                case 55:
                    return "SS ";
                case 56:
                    return "StL ";
                case 57:
                    return "IB ";
                case 58:
                    return "FS ";
                case 59:
                    return "SwS ";
                case 60:
                    return "DmG ";
                case 61:
                    return "HF ";
                case 104:
                    return "BS ";
            }
            return "Err ";
        }
    }
}
