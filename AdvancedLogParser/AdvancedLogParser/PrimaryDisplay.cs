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
    class PrimaryDisplay : Form
    {
        ListView mainList = new ListView();
        Button playerList = new Button();
        Button thisMonth = new Button();
        Button lastMonth = new Button();
        Button older = new Button();
        Button allPlayers = new Button();

        DateTime lastSorted;

        int currentSort = 0;
        bool reverseSort = false;

        public PlayerListView currentPlayerView = PlayerListView.ThisMonth;

        public enum PlayerListView
        {
            ThisMonth = 0,
            LastMonth = 1,
            Older = 2,
            All = 3
        }

        public PrimaryDisplay()
        {
            playerList.Text = "Player Lists";
            playerList.Click += ClickPlayerList;
            playerList.Size = playerList.PreferredSize;
            thisMonth.Text = "Active This Month";
            thisMonth.Click += ClickThisMonth;
            thisMonth.Size = thisMonth.PreferredSize;
            thisMonth.Location = new Point(0, playerList.Height);
            lastMonth.Text = "Inactive Since Last Month";
            lastMonth.Click += ClickLastMonth;
            lastMonth.Size = lastMonth.PreferredSize;
            lastMonth.Location = new Point(thisMonth.Width, playerList.Height);
            older.Text = "Inactive For Longer";
            older.Click += ClickOlder;
            older.Size = lastMonth.PreferredSize;
            older.Location = new Point(lastMonth.Location.X + lastMonth.Width, playerList.Height);
            allPlayers.Text = "All Players";
            allPlayers.Click += ClickAll;
            allPlayers.Size = allPlayers.PreferredSize;
            allPlayers.Location = new Point(older.Location.X + older.Width, playerList.Height);

            this.Height = 786;
            this.Width = 820;

            mainList.View = View.Details;
            mainList.Height = this.Height - 30 - thisMonth.Height - playerList.Height;
            mainList.Width = this.Width - 15;

            mainList.DoubleClick += MainListDoubleClicked;

            mainList.Location = new Point(0, thisMonth.Height + playerList.Height);

            mainList.FullRowSelect = true;

            this.Controls.Add(playerList);
            
            this.Controls.Add(mainList);
            this.Controls.Add(thisMonth);
            this.Controls.Add(lastMonth);
            this.Controls.Add(older);
            this.Controls.Add(allPlayers);

            DrawList();
        }

        private void DrawList()
        {
            mainList.Clear();

            mainList.Columns.Add("CD Key");
            mainList.Columns.Add("Community IDs");
            mainList.Columns.Add("DM Time");
            mainList.Columns.Add("First Login");
            mainList.Columns.Add("Last Login");

            mainList.ColumnClick += ColumnSort;

            if (currentPlayerView == PlayerListView.ThisMonth)
            {
                foreach (Player player in Players.ListByKey.Values)
                {
                    if (player.LastLogin.Month == DateTime.UtcNow.Month &&
                         player.LastLogin.Year == DateTime.UtcNow.Year)
                    {
                        string name = "";
                        foreach (string communityId in player.CommunityIds)
                        {
                            if (name == "")
                            {
                                name = communityId;
                            }
                            else
                            {
                                name += ", " + communityId.Trim();
                            }
                        }
                        mainList.Items.Add(new ListViewItem(new string[] { player.CDKey, name, String.Format("{0:N1}", player.DMTime), String.Format("{0:yyyy/MM/dd}", player.FirstLogin), String.Format("{0:yyyy/MM/dd}", player.LastLogin) }));
                    }
                }
                this.Name = String.Format("Players Active This Month ({0})", mainList.Items.Count);
                this.Text = this.Name;
            }
            if (currentPlayerView == PlayerListView.LastMonth)
            {
                foreach (Player player in Players.ListByKey.Values)
                {
                    DateTime lastMonth = DateTime.UtcNow;
                    lastMonth -= TimeSpan.FromDays(lastMonth.Day + 1);
                    if (player.LastLogin.Month == lastMonth.Month &&
                         player.LastLogin.Year == lastMonth.Year)
                    {
                        string name = "";
                        foreach (string communityId in player.CommunityIds)
                        {
                            if (name == "")
                            {
                                name = communityId;
                            }
                            else
                            {
                                name += ", " + communityId.Trim();
                            }
                        }
                        mainList.Items.Add(new ListViewItem(new string[] { player.CDKey, name, String.Format("{0:N1}", player.DMTime), String.Format("{0:yyyy/MM/dd}", player.FirstLogin), String.Format("{0:yyyy/MM/dd}", player.LastLogin) }));
                    }
                }
                this.Name = String.Format("Players Inactive Since Last Month ({0})", mainList.Items.Count);
                this.Text = this.Name;
            }
            if (currentPlayerView == PlayerListView.Older)
            {
                foreach (Player player in Players.ListByKey.Values)
                {
                    DateTime lastMonth = DateTime.UtcNow;
                    lastMonth -= TimeSpan.FromDays(lastMonth.Day + 1);
                    if ((player.LastLogin.Month != DateTime.UtcNow.Month ||
                         player.LastLogin.Year != DateTime.UtcNow.Year) &&
                         (player.LastLogin.Month != lastMonth.Month ||
                         player.LastLogin.Year != lastMonth.Year))
                    {
                        string name = "";
                        foreach (string communityId in player.CommunityIds)
                        {
                            if (name == "")
                            {
                                name = communityId;
                            }
                            else
                            {
                                name += ", " + communityId.Trim();
                            }
                        }
                        mainList.Items.Add(new ListViewItem(new string[] { player.CDKey, name, String.Format("{0:N1}", player.DMTime), String.Format("{0:yyyy/MM/dd}", player.FirstLogin), String.Format("{0:yyyy/MM/dd}", player.LastLogin) }));
                    }
                }
                this.Name = String.Format("Players Inactive For Longer ({0})", mainList.Items.Count);
                this.Text = this.Name;
            }
            if (currentPlayerView == PlayerListView.All)
            {
                foreach (Player player in Players.ListByKey.Values)
                {
                    string name = "";
                    foreach (string communityId in player.CommunityIds)
                    {
                        if (name == "")
                        {
                            name = communityId;
                        }
                        else
                        {
                            name += ", " + communityId.Trim();
                        }
                    }
                    mainList.Items.Add(new ListViewItem(new string[] { player.CDKey, name, String.Format("{0:N1}", player.DMTime), String.Format("{0:yyyy/MM/dd}", player.FirstLogin), player.LastLogin.ToShortDateString() }));
                }
                this.Name = String.Format("All Players ({0})", mainList.Items.Count);
                this.Text = this.Name;
            }
            mainList.KeyDown += new KeyEventHandler(mainList_KeyDown);

            mainList.Columns[0].AutoResize(ColumnHeaderAutoResizeStyle.ColumnContent);
            mainList.Columns[1].AutoResize(ColumnHeaderAutoResizeStyle.ColumnContent);
            mainList.Columns[2].AutoResize(ColumnHeaderAutoResizeStyle.ColumnContent);
            mainList.Columns[3].AutoResize(ColumnHeaderAutoResizeStyle.ColumnContent);
            mainList.Columns[4].AutoResize(ColumnHeaderAutoResizeStyle.ColumnContent);
        }

        void mainList_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Control && e.KeyCode == Keys.C)
            {
                StringBuilder copyBuffer = new StringBuilder();
                copyBuffer.EnsureCapacity(1);
                foreach (ListViewItem item in mainList.SelectedItems)
                {
                    string line = String.Format("{0,40} {1,10}, {2,10}", item.SubItems[1].Text.ToString(), item.SubItems[2].Text.ToString(), item.SubItems[4].Text.ToString());
                    copyBuffer.EnsureCapacity(copyBuffer.Capacity + line.Length + 1);
                    copyBuffer.AppendLine(line);
                }
                if (copyBuffer.Capacity > 1)
                {
                    Clipboard.SetText(copyBuffer.ToString());
                }
            }
        }

        public void ClickThisMonth(object Sender, EventArgs e)
        {
            currentPlayerView = PlayerListView.ThisMonth;
            DrawList();
        }

        public void ClickLastMonth(object Sender, EventArgs e)
        {
            currentPlayerView = PlayerListView.LastMonth;
            DrawList();
        }

        public void ClickOlder(object Sender, EventArgs e)
        {
            currentPlayerView = PlayerListView.Older;
            DrawList();
        }

        public void ClickAll(object Sender, EventArgs e)
        {
            currentPlayerView = PlayerListView.All;
            DrawList();
        }

        public void ClickPlayerList(object Sender, EventArgs e)
        {
            if (this.Controls.Contains(thisMonth))
            {
                // We're already viewing player lists. Drop this.
                return;
            }
            else
            {
                // Remove old buttons.
                RemoveButtons();

                this.Controls.Add(thisMonth);
                this.Controls.Add(lastMonth);
                this.Controls.Add(older);
            }
        }

        private void MainListDoubleClicked(object Sender, EventArgs e)
        {
            string player = mainList.SelectedItems[0].SubItems[0].Text;
            if (Players.ListByKey.Keys.Contains(player))
            {
                new PlayerDetails(Players.ListByKey[player]).Show();
            }
            else
            {
                MessageBox.Show(String.Format("Could not find player with CD Key {0}", player));
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
            mainList.ListViewItemSorter = new ListViewItemComparer(e.Column, reverseSort);
        }

        private void RemoveButtons()
        {
            if (this.Controls.Contains(thisMonth))
            {
                this.Controls.Remove(thisMonth);
            }
            if (this.Controls.Contains(lastMonth))
            {
                this.Controls.Remove(lastMonth);
            }
            if (this.Controls.Contains(older))
            {
                this.Controls.Remove(older);
            }
        }
    }
}
