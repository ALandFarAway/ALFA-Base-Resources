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
    public class ServerView : Form
    {
        ListView characterList = new ListView();
        ListView dmList = new ListView();
        ListView enforcementList = new ListView();
        ListView advancementList = new ListView();
        ListView deathList = new ListView();

        Label characterListLabel = new Label();
        Label dmListLabel = new Label();
        Label enforcementListLabel = new Label();
        Label advancementListLabel = new Label();
        Label deathListLabel = new Label();
        
        DateTime lastSorted = DateTime.UtcNow;
        bool reverseSort = false;
        int currentSort = 0;


        public ServerView(Server server)
        {
            List<Log> serverEnforcementLogs = new List<Log>();
            List<Log> serverAdvancementLogs = new List<Log>();
            List<Log> serverDeathLogs = new List<Log>();
            if (server == null)
            {
                server = MakeMegaServer();
                serverEnforcementLogs = Logs.EnforcementAlerts;
                serverAdvancementLogs = Logs.AdvancementAlerts;
                serverDeathLogs = Logs.DeathAlerts;
                this.Name = String.Format("All ALFA ({0} Characters, {1} DMs, {2} Alerts)", server.RecentCharacters.Count, server.RecentDMs.Count, serverEnforcementLogs.Count + serverAdvancementLogs.Count + serverDeathLogs.Count);
                this.Text = this.Name;
            }
            else
            {
                foreach (Log log in Logs.EnforcementAlerts)
                {
                    if (log.ServerId == server.ServerId)
                    {
                        serverEnforcementLogs.Add(log);
                    }
                }
                foreach (Log log in Logs.AdvancementAlerts)
                {
                    if (log.ServerId == server.ServerId)
                    {
                        serverAdvancementLogs.Add(log);
                    }
                }
                foreach (Log log in Logs.DeathAlerts)
                {
                    if (log.ServerId == server.ServerId)
                    {
                        serverDeathLogs.Add(log);
                    }
                }
                this.Name = String.Format("ALFA{0:000} ({1} Characters, {2} DMs, {3} Alerts)", server.ServerId, server.RecentCharacters.Count, server.RecentDMs.Count, serverEnforcementLogs.Count + serverAdvancementLogs.Count + serverDeathLogs.Count);
                this.Text = this.Name;
            }

            characterListLabel.Text = "Characters Played in the Last 30 Days";
            characterListLabel.Size = characterListLabel.PreferredSize;
            characterListLabel.Location = new Point(0, 0);

            characterList.View = View.Details;
            dmList.View = View.Details;
            enforcementList.View = View.Details;
            advancementList.View = View.Details;
            deathList.View = View.Details;

            characterList.FullRowSelect = true;
            dmList.FullRowSelect = true;
            enforcementList.FullRowSelect = true;
            advancementList.FullRowSelect = true;
            deathList.FullRowSelect = true;

            characterList.DoubleClick += DoubleClickCharacterList;
            dmList.DoubleClick += DoubleClickDMList;

            characterList.ColumnClick += ColumnSort;
            dmList.ColumnClick += ColumnSort;
            enforcementList.ColumnClick += ColumnSort;
            advancementList.ColumnClick += ColumnSort;
            deathList.ColumnClick += ColumnSort;

            characterList.Width = 550;
            characterList.Height = 440;
            characterList.Columns.Add("Character");
            characterList.Columns.Add("Player");
            characterList.Columns.Add("Class");
            characterList.Columns.Add("DMtime");
            characterList.Columns.Add("Alerts");
            characterList.Location = new Point(0, characterListLabel.Location.Y + characterListLabel.Height);
            foreach (Character currentChar in server.RecentCharacters)
            {
                if (currentChar.IsPlayable == false)
                {
                    continue;
                }
                if ((currentChar.Status & 0x001) == 0x001) // dead
                {
                    continue;
                }
                string charClass = PlayerDetails.ClassToAbbreviation(currentChar.Class1) + currentChar.Level1;
                if (currentChar.Class2 < 255)
                {
                    charClass += "/" + PlayerDetails.ClassToAbbreviation(currentChar.Class2) + currentChar.Level2;
                }
                if (currentChar.Class3 < 255)
                {
                    charClass += "/" + PlayerDetails.ClassToAbbreviation(currentChar.Class3) + currentChar.Level3;
                }
                string alerts = "";
                WealthLevel currentWeath = InfoGather.GetWealthLevel(currentChar);
                if (currentWeath == WealthLevel.VeryPoor)
                {
                    alerts += "Poor!";
                }
                else if (currentWeath == WealthLevel.VeryRich)
                {
                    alerts += "Rich!";
                }
                else if (currentWeath == WealthLevel.Cutoff)
                {
                    alerts += "CUTOFF WEALTH!";
                }
                string aliases = "";
                try
                {
                    foreach (string alias in Players.ListByPlayerId[currentChar.PlayerId].CommunityIds)
                    {
                        if (aliases == "")
                        {
                            aliases = alias;
                        }
                        else
                        {
                            aliases += "/ " + alias;
                        }
                    }
                }
                catch
                {
                    aliases = "Unknown player";
                }
                characterList.Items.Add(new ListViewItem(new string[] { currentChar.Name, aliases, charClass, String.Format("{0:N1}", currentChar.DMTime), alerts, currentChar.Id.ToString() }));
            }
            characterList.Columns[0].AutoResize(ColumnHeaderAutoResizeStyle.ColumnContent);
            characterList.Columns[1].Width = 150;
            characterList.Columns[2].AutoResize(ColumnHeaderAutoResizeStyle.ColumnContent);
            characterList.Columns[3].AutoResize(ColumnHeaderAutoResizeStyle.ColumnContent);
            characterList.Columns[4].AutoResize(ColumnHeaderAutoResizeStyle.ColumnContent);

            dmListLabel.Text = "DMs Logging in During the Last 30 Days";
            dmListLabel.Size = dmListLabel.PreferredSize;
            dmListLabel.Location = new Point(0, characterList.Location.Y + characterList.Height + 10);

            dmList.Width = characterList.Width;
            dmList.Height = 250;
            dmList.Location = new Point(0, dmListLabel.Location.Y + dmListLabel.Height);
            dmList.Columns.Add("DM Community Ids");
            dmList.Columns[0].Width = 400;
            foreach (Player dm in server.RecentDMs)
            {
                string name = "";
                foreach (string gsid in dm.CommunityIds)
                {
                    if (name == "")
                    {
                        name = gsid;
                    }
                    else
                    {
                        name += "/ " + gsid;
                    }
                }
                dmList.Items.Add(new ListViewItem(new string[] { name, dm.playerIds[0].ToString() }));
            }
            dmList.Columns[0].AutoResize(ColumnHeaderAutoResizeStyle.ColumnContent);

            enforcementListLabel.Text = "Enforcement Alerts";
            enforcementListLabel.Size = enforcementListLabel.PreferredSize;
            enforcementListLabel.Location = new Point(characterList.Width + 10, 0);

            enforcementList.Width = 340;
            enforcementList.Height = 200;
            enforcementList.Location = new Point(characterList.Width + 10, enforcementListLabel.Location.Y + enforcementListLabel.Height);
            enforcementList.Columns.Add("Character");
            enforcementList.Columns.Add("Time");
            enforcementList.Columns.Add("Event");
            foreach (Log log in serverEnforcementLogs)
            {
                string character = "Unknown Character";
                if (log.CharacterId > 0) character = Characters.List[log.CharacterId].Name;
                enforcementList.Items.Add(new ListViewItem(new string[] { character, String.Format("{0}/{1}/{2}", log.Time.Year, log.Time.Month, log.Time.Day), log.Event }));
            }
            enforcementList.Columns[0].AutoResize(ColumnHeaderAutoResizeStyle.ColumnContent);
            enforcementList.Columns[1].AutoResize(ColumnHeaderAutoResizeStyle.ColumnContent);
            enforcementList.Columns[2].AutoResize(ColumnHeaderAutoResizeStyle.ColumnContent);

            advancementListLabel.Text = "Advancement Alerts";
            advancementListLabel.Size = advancementListLabel.PreferredSize;
            advancementListLabel.Location = new Point(characterList.Width + 10, enforcementList.Location.Y + enforcementList.Height + 10);

            advancementList.Width = 340;
            advancementList.Height = 230;
            advancementList.Location = new Point(characterList.Width + 10, advancementListLabel.Location.Y + advancementListLabel.Height);
            advancementList.Columns.Add("Character");
            advancementList.Columns.Add("Time");
            advancementList.Columns.Add("Event");
            foreach (Log log in serverAdvancementLogs)
            {
                string character = "Unknown Character";
                if(log.CharacterId > 0) character = Characters.List[log.CharacterId].Name;
                advancementList.Items.Add(new ListViewItem(new string[] { character, String.Format("{0}/{1}/{2}", log.Time.Year, log.Time.Month, log.Time.Day), log.Event }));
            }
            advancementList.Columns[0].AutoResize(ColumnHeaderAutoResizeStyle.ColumnContent);
            advancementList.Columns[1].AutoResize(ColumnHeaderAutoResizeStyle.ColumnContent);
            advancementList.Columns[2].AutoResize(ColumnHeaderAutoResizeStyle.ColumnContent);

            deathListLabel.Text = "Death Alerts";
            deathListLabel.Size = deathListLabel.PreferredSize;
            deathListLabel.Location = new Point(characterList.Width + 10, advancementList.Location.Y + advancementList.Height + 10);

            deathList.Width = 340;
            deathList.Height = 230;
            deathList.Location = new Point(characterList.Width + 10, deathListLabel.Location.Y + deathListLabel.Height);
            deathList.Columns.Add("Character");
            deathList.Columns.Add("Time");
            deathList.Columns.Add("Event");
            foreach (Log log in serverDeathLogs)
            {
                string character = "Unknown Character";
                if (log.CharacterId > 0) character = Characters.List[log.CharacterId].Name;
                deathList.Items.Add(new ListViewItem(new string[] { character, String.Format("{0}/{1}/{2}", log.Time.Year, log.Time.Month, log.Time.Day), log.Event }));
            }
            deathList.Columns[0].AutoResize(ColumnHeaderAutoResizeStyle.ColumnContent);
            deathList.Columns[1].AutoResize(ColumnHeaderAutoResizeStyle.ColumnContent);
            deathList.Columns[2].AutoResize(ColumnHeaderAutoResizeStyle.ColumnContent);

            this.Width = deathList.Width + deathList.Location.X + 10;
            this.Height = deathList.Height + deathList.Location.Y + 30;

            this.Controls.Add(characterListLabel);
            this.Controls.Add(characterList);
            this.Controls.Add(dmListLabel);
            this.Controls.Add(dmList);
            this.Controls.Add(enforcementListLabel);
            this.Controls.Add(enforcementList);
            this.Controls.Add(advancementListLabel);
            this.Controls.Add(advancementList);
            this.Controls.Add(deathListLabel);
            this.Controls.Add(deathList);
        }

        public static Server MakeMegaServer()
        {
            Server retVal = new Server();
            foreach (Server srv in Servers.List.Values)
            {
                foreach (Character ch in srv.RecentCharacters)
                {
                    if (!retVal.RecentCharacters.Contains(ch))
                    {
                        retVal.RecentCharacters.Add(ch);
                    }
                }
                foreach (Player pl in srv.RecentPlayers)
                {
                    if (!retVal.RecentPlayers.Contains(pl))
                    {
                        retVal.RecentPlayers.Add(pl);
                    }
                }
                foreach (Player dm in srv.RecentDMs)
                {
                    if (!retVal.RecentDMs.Contains(dm))
                    {
                        retVal.RecentDMs.Add(dm);
                    }
                }
            }
            return retVal;
        }

        private void ColumnSort(object Sender, ColumnClickEventArgs e)
        {
            if (DateTime.UtcNow - lastSorted < new TimeSpan(0, 0, 0, 0, 10))
                return;

            // Actual sorting.
            if (e.Column == currentSort)
            {
                reverseSort = !reverseSort;
            }
            currentSort = e.Column;
            lastSorted = DateTime.UtcNow;
            ListView list = Sender as ListView;
            if (list != null && list.Columns.Count > e.Column)
            {
                list.ListViewItemSorter = new ListViewItemComparer(e.Column, reverseSort);
            }
        }

        private void DoubleClickCharacterList(object Sender, EventArgs e)
        {
            string ClickedRow = characterList.SelectedItems[0].SubItems[5].Text;
            uint characterId = 0;
            if(uint.TryParse(ClickedRow, out characterId))
            {
                if (Characters.List.ContainsKey(characterId))
                {
                    new CharacterDetails(Characters.List[characterId]).Show();
                }
            }
        }

        private void DoubleClickDMList(object Sender, EventArgs e)
        {
            string ClickedRow = dmList.SelectedItems[0].SubItems[1].Text;
            uint playerId = 0;
            if (uint.TryParse(ClickedRow, out playerId))
            {
                if (Players.ListByPlayerId.ContainsKey(playerId))
                {
                    new PlayerDetails(Players.ListByPlayerId[playerId]).Show();
                }
            }
        }
    }


}
