using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Resources;
using System.Text;
using System.Drawing;
using System.Drawing.Drawing2D;
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

        Label alignmentPieLabel = new Label();
        Rectangle alignmentPie = new Rectangle();
        Label dmTimePieLabel = new Label();
        Rectangle dmTimePie = new Rectangle();
        Label legendLabel = new Label();
        Label legendLabelTwo = new Label();

        Server savedServer;
        
        DateTime lastSorted = DateTime.UtcNow;
        bool reverseSort = false;
        int currentSort = 0;


        public ServerView(Server server)
        {
            this.Paint += new PaintEventHandler(ServerView_Paint);

            Dictionary<uint, Log> serverEnforcementLogs = new Dictionary<uint, Log>();
            Dictionary<uint, Log> serverAdvancementLogs = new Dictionary<uint, Log>();
            Dictionary<uint, Log> serverDeathLogs = new Dictionary<uint, Log>();
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
                foreach (Log log in Logs.EnforcementAlerts.Values)
                {
                    if (log.ServerId == server.ServerId)
                    {
                        serverEnforcementLogs.Add(log.Id, log);
                    }
                }
                foreach (Log log in Logs.AdvancementAlerts.Values)
                {
                    if (log.ServerId == server.ServerId)
                    {
                        serverAdvancementLogs.Add(log.Id, log);
                    }
                }
                foreach (Log log in Logs.DeathAlerts.Values)
                {
                    if (log.ServerId == server.ServerId)
                    {
                        serverDeathLogs.Add(log.Id, log);
                    }
                }
                this.Name = String.Format("ALFA{0:000} ({1} Characters, {2} DMs, {3} Alerts)", server.ServerId, server.RecentCharacters.Count, server.RecentDMs.Count, serverEnforcementLogs.Count + serverAdvancementLogs.Count + serverDeathLogs.Count);
                this.Text = this.Name;
            }
            savedServer = server;

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
            enforcementList.DoubleClick += DoubleClickEnforcementList;
            advancementList.DoubleClick += DoubleClickAdvancementList;
            deathList.DoubleClick += DoubleClickDeathList;

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
            foreach (Log log in serverEnforcementLogs.Values)
            {
                string character = "Unknown Character";
                if (log.CharacterId > 0) character = Characters.List[log.CharacterId].Name;
                enforcementList.Items.Add(new ListViewItem(new string[] { character, String.Format("{0}/{1}/{2}", log.Time.Year, log.Time.Month, log.Time.Day), log.Event, log.Id.ToString() }));
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
            foreach (Log log in serverAdvancementLogs.Values)
            {
                string character = "Unknown Character";
                if(log.CharacterId > 0) character = Characters.List[log.CharacterId].Name;
                advancementList.Items.Add(new ListViewItem(new string[] { character, String.Format("{0}/{1}/{2}", log.Time.Year, log.Time.Month, log.Time.Day), log.Event, log.Id.ToString() }));
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
            foreach (Log log in serverDeathLogs.Values)
            {
                string character = "Unknown Character";
                if (log.CharacterId > 0) character = Characters.List[log.CharacterId].Name;
                deathList.Items.Add(new ListViewItem(new string[] { character, String.Format("{0}/{1}/{2}", log.Time.Year, log.Time.Month, log.Time.Day), log.Event, log.Id.ToString() }));
            }
            deathList.Columns[0].AutoResize(ColumnHeaderAutoResizeStyle.ColumnContent);
            deathList.Columns[1].AutoResize(ColumnHeaderAutoResizeStyle.ColumnContent);
            deathList.Columns[2].AutoResize(ColumnHeaderAutoResizeStyle.ColumnContent);

            alignmentPieLabel.Text = "Wealth Distribution";
            alignmentPieLabel.Size = alignmentPieLabel.PreferredSize;
            alignmentPieLabel.Location = new Point(enforcementList.Location.X + enforcementList.Width + 10, 0);
            alignmentPieLabel.Click += PieLabel_Click;
            
            alignmentPie.Size = new Size(350, 350);
            alignmentPie.Location = new Point(alignmentPieLabel.Location.X, alignmentPieLabel.Location.Y + alignmentPieLabel.Height);

            dmTimePieLabel.Text = "DM Coverage";
            dmTimePieLabel.Size = dmTimePieLabel.PreferredSize;
            dmTimePieLabel.Location = new Point(alignmentPie.Location.X, alignmentPie.Location.Y + alignmentPie.Height + 10);
            dmTimePieLabel.Click += PieLabel_Click;

            dmTimePie.Size = new Size(350, 350);
            dmTimePie.Location = new Point(alignmentPieLabel.Location.X, dmTimePieLabel.Location.Y + dmTimePieLabel.Height);

            legendLabel.Text = "Very Poor\n\nPoor\n\nTarget\n\nRich\n\nVery Rich\n\nCutoff Wealth";
            legendLabel.Size = legendLabel.PreferredSize;
            legendLabel.Location = new Point(alignmentPie.Location.X + alignmentPie.Width + 50, alignmentPieLabel.Location.Y + alignmentPieLabel.Height);

            legendLabelTwo.Text = "DMed\n\nUn-DMed";
            legendLabelTwo.Size = legendLabelTwo.PreferredSize;
            legendLabelTwo.Location = new Point(dmTimePie.Location.X + dmTimePie.Width + 50, dmTimePieLabel.Location.Y + dmTimePieLabel.Height);

            this.Width = dmTimePie.Width + dmTimePie.Location.X + 210;
            this.Height = dmTimePie.Height + dmTimePie.Location.Y + 30;

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
            this.Controls.Add(alignmentPieLabel);
            this.Controls.Add(dmTimePieLabel);
            this.Controls.Add(legendLabel);
            this.Controls.Add(legendLabelTwo);
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
            try
            {
                string ClickedRow = characterList.SelectedItems[0].SubItems[5].Text;
                uint characterId = 0;
                if (uint.TryParse(ClickedRow, out characterId))
                {
                    if (Characters.List.ContainsKey(characterId))
                    {
                        new CharacterDetails(Characters.List[characterId]).Show();
                    }
                }
            }
            catch { }
        }

        private void DoubleClickDMList(object Sender, EventArgs e)
        {
            try
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
            catch { }
        }

        private void DoubleClickEnforcementList(object Sender, EventArgs e)
        {
            try
            {
                string ClickedRow = enforcementList.SelectedItems[0].SubItems[3].Text;
                uint logId = 0;
                if (uint.TryParse(ClickedRow, out logId))
                {
                    if (Logs.EnforcementAlerts.ContainsKey(logId))
                    {
                        new LogDetails(Logs.EnforcementAlerts[logId]).Show();
                    }
                }
            }
            catch { }
        }

        private void DoubleClickAdvancementList(object Sender, EventArgs e)
        {
            try
            {
                string ClickedRow = advancementList.SelectedItems[0].SubItems[3].Text;
                uint logId = 0;
                if (uint.TryParse(ClickedRow, out logId))
                {
                    if (Logs.AdvancementAlerts.ContainsKey(logId))
                    {
                        new LogDetails(Logs.AdvancementAlerts[logId]).Show();
                    }
                }
            }
            catch { }
        }

        private void DoubleClickDeathList(object Sender, EventArgs e)
        {
            try
            {
                string ClickedRow = deathList.SelectedItems[0].SubItems[3].Text;
                uint logId = 0;
                if (uint.TryParse(ClickedRow, out logId))
                {
                    if (Logs.DeathAlerts.ContainsKey(logId))
                    {
                        new LogDetails(Logs.DeathAlerts[logId]).Show();
                    }
                }
            }
            catch { }
        }

        int pieType = 3;

        private void ServerView_Paint(object Sender, PaintEventArgs e)
        {
            int lawfulGood = 0;
            float lawfulGoodTime = 0.0f;
            int neutralGood = 0;
            float neutralGoodTime = 0.0f;
            int chaoticGood = 0;
            float chaoticGoodTime = 0.0f;
            int lawfulNeutral = 0;
            float lawfulNeutralTime = 0.0f;
            int trueNeutral = 0;
            float trueNeutralTime = 0.0f;
            int chaoticNeutral = 0;
            float chaoticNeutralTime = 0.0f;
            int lawfulEvil = 0;
            float lawfulEvilTime = 0.0f;
            int neutralEvil = 0;
            float neutralEvilTime = 0.0f;
            int chaoticEvil = 0;
            float chaoticEvilTime = 0.0f;

            float totalTime = 0.0f;

            int veryPoor = 0;
            int poor = 0;
            int target = 0;
            int rich = 0;
            int veryRich = 0;
            int cutoffRich = 0;

            int dmed = 0;
            int unDMed = 0;

            if (pieType <= 2)
            {
                foreach (Character ch in savedServer.RecentCharacters)
                {
                    switch (ch.Alignment)
                    {
                        case Alignment.LawfulGood:
                            lawfulGood++;
                            lawfulGoodTime += ch.DMTime;
                            break;
                        case Alignment.NeutralGood:
                            neutralGood++;
                            neutralGoodTime += ch.DMTime;
                            break;
                        case Alignment.ChaoticGood:
                            chaoticGood++;
                            chaoticGoodTime += ch.DMTime;
                            break;
                        case Alignment.LawfulNeutral:
                            lawfulNeutral++;
                            lawfulNeutralTime += ch.DMTime;
                            break;
                        case Alignment.TrueNeutral:
                            trueNeutral++;
                            trueNeutralTime += ch.DMTime;
                            break;
                        case Alignment.ChaoticNeutral:
                            chaoticNeutral++;
                            chaoticNeutralTime += ch.DMTime;
                            break;
                        case Alignment.LawfulEvil:
                            lawfulEvil++;
                            lawfulEvilTime += ch.DMTime;
                            break;
                        case Alignment.NeutralEvil:
                            neutralEvil++;
                            neutralEvilTime += ch.DMTime;
                            break;
                        case Alignment.ChaoticEvil:
                            chaoticEvil++;
                            chaoticEvilTime += ch.DMTime;
                            break;
                    }
                    totalTime += ch.DMTime;
                }
            }
            else if (pieType == 3)
            {
                foreach (Character character in savedServer.RecentCharacters)
                {
                    WealthLevel lvl = InfoGather.GetWealthLevel(character);
                    switch (lvl)
                    {
                        case WealthLevel.VeryPoor:
                            veryPoor++;
                            break;
                        case WealthLevel.Poor:
                            poor++;
                            break;
                        case WealthLevel.Target:
                            target++;
                            break;
                        case WealthLevel.Rich:
                            rich++;
                            break;
                        case WealthLevel.VeryRich:
                            veryRich++;
                            break;
                        case WealthLevel.Cutoff:
                            cutoffRich++;
                            break;
                    }
                    if (character.DMTime <= 0.25)
                    {
                        unDMed++;
                    }
                    else
                    {
                        dmed++;
                    }
                }
            }

            Pen blackPen = new Pen(Color.Black, 2.0f);
            Brush blackBrush = new SolidBrush(Color.Black);
            Brush greyBrush = new SolidBrush(Color.Gray);
            Brush whiteBrush = new SolidBrush(Color.White);
            Brush lightBlueBrush = new SolidBrush(Color.LightBlue);
            Brush blueBrush = new SolidBrush(Color.Blue);
            Brush darkBlueBrush = new SolidBrush(Color.DarkBlue);
            Brush lightOrangeBrush = new SolidBrush(Color.Orange);
            Brush orangeBrush = new SolidBrush(Color.DarkOrange);
            Brush darkOrangeBrush = new SolidBrush(Color.OrangeRed);

            Graphics g = e.Graphics;
            g.Clear(this.BackColor);

            if (pieType == 0)
            {
                int locY = alignmentPieLabel.Location.Y + alignmentPieLabel.Height;
                Rectangle rect = new Rectangle(alignmentPie.Location.X + alignmentPie.Width + 30, locY, alignmentPieLabel.Height, alignmentPieLabel.Height);
                g.DrawRectangle(blackPen, rect);
                g.FillRectangle(lightBlueBrush, rect);

                locY += alignmentPieLabel.Height * 2;
                rect = new Rectangle(alignmentPie.Location.X + alignmentPie.Width + 30, locY, alignmentPieLabel.Height, alignmentPieLabel.Height);
                g.DrawRectangle(blackPen, rect);
                g.FillRectangle(whiteBrush, rect);

                locY += alignmentPieLabel.Height * 2;
                rect = new Rectangle(alignmentPie.Location.X + alignmentPie.Width + 30, locY, alignmentPieLabel.Height, alignmentPieLabel.Height);
                g.DrawRectangle(blackPen, rect);
                g.FillRectangle(lightOrangeBrush, rect);

                locY += alignmentPieLabel.Height * 2;
                rect = new Rectangle(alignmentPie.Location.X + alignmentPie.Width + 30, locY, alignmentPieLabel.Height, alignmentPieLabel.Height);
                g.DrawRectangle(blackPen, rect);
                g.FillRectangle(blueBrush, rect);

                locY += alignmentPieLabel.Height * 2;
                rect = new Rectangle(alignmentPie.Location.X + alignmentPie.Width + 30, locY, alignmentPieLabel.Height, alignmentPieLabel.Height);
                g.DrawRectangle(blackPen, rect);
                g.FillRectangle(greyBrush, rect);

                locY += alignmentPieLabel.Height * 2;
                rect = new Rectangle(alignmentPie.Location.X + alignmentPie.Width + 30, locY, alignmentPieLabel.Height, alignmentPieLabel.Height);
                g.DrawRectangle(blackPen, rect);
                g.FillRectangle(orangeBrush, rect);

                locY += alignmentPieLabel.Height * 2;
                rect = new Rectangle(alignmentPie.Location.X + alignmentPie.Width + 30, locY, alignmentPieLabel.Height, alignmentPieLabel.Height);
                g.DrawRectangle(blackPen, rect);
                g.FillRectangle(darkBlueBrush, rect);

                locY += alignmentPieLabel.Height * 2;
                rect = new Rectangle(alignmentPie.Location.X + alignmentPie.Width + 30, locY, alignmentPieLabel.Height, alignmentPieLabel.Height);
                g.DrawRectangle(blackPen, rect);
                g.FillRectangle(blackBrush, rect);

                locY += alignmentPieLabel.Height * 2;
                rect = new Rectangle(alignmentPie.Location.X + alignmentPie.Width + 30, locY, alignmentPieLabel.Height, alignmentPieLabel.Height);
                g.DrawRectangle(blackPen, rect);
                g.FillRectangle(darkOrangeBrush, rect);

                float oldSweep = 0.0f;
                float currentSweep = (((float)neutralGood) * 360) / savedServer.RecentCharacters.Count;
                g.DrawPie(blackPen, alignmentPie, oldSweep, currentSweep);
                g.FillPie(whiteBrush, alignmentPie, oldSweep, currentSweep);
                oldSweep += currentSweep;
                currentSweep = (((float)chaoticGood) * 360) / savedServer.RecentCharacters.Count;
                g.DrawPie(blackPen, alignmentPie, oldSweep, currentSweep);
                g.FillPie(lightOrangeBrush, alignmentPie, oldSweep, currentSweep);
                oldSweep += currentSweep;
                currentSweep = (((float)chaoticNeutral) * 360) / savedServer.RecentCharacters.Count;
                g.DrawPie(blackPen, alignmentPie, oldSweep, currentSweep);
                g.FillPie(orangeBrush, alignmentPie, oldSweep, currentSweep);
                oldSweep += currentSweep;
                currentSweep = (((float)trueNeutral) * 360) / savedServer.RecentCharacters.Count;
                g.DrawPie(blackPen, alignmentPie, oldSweep, currentSweep);
                g.FillPie(greyBrush, alignmentPie, oldSweep, currentSweep);
                oldSweep += currentSweep;
                currentSweep = (((float)lawfulNeutral) * 360) / savedServer.RecentCharacters.Count;
                g.DrawPie(blackPen, alignmentPie, oldSweep, currentSweep);
                g.FillPie(blueBrush, alignmentPie, oldSweep, currentSweep);
                oldSweep += currentSweep;
                currentSweep = (((float)chaoticEvil) * 360) / savedServer.RecentCharacters.Count;
                g.DrawPie(blackPen, alignmentPie, oldSweep, currentSweep);
                g.FillPie(darkOrangeBrush, alignmentPie, oldSweep, currentSweep);
                oldSweep += currentSweep;
                currentSweep = (((float)neutralEvil) * 360) / savedServer.RecentCharacters.Count;
                g.DrawPie(blackPen, alignmentPie, oldSweep, currentSweep);
                g.FillPie(blackBrush, alignmentPie, oldSweep, currentSweep);
                oldSweep += currentSweep;
                currentSweep = (((float)lawfulEvil) * 360) / savedServer.RecentCharacters.Count;
                g.DrawPie(blackPen, alignmentPie, oldSweep, currentSweep);
                g.FillPie(darkBlueBrush, alignmentPie, oldSweep, currentSweep);
                oldSweep += currentSweep;
                currentSweep = (((float)lawfulGood) * 360) / savedServer.RecentCharacters.Count;
                g.DrawPie(blackPen, alignmentPie, oldSweep, currentSweep);
                g.FillPie(lightBlueBrush, alignmentPie, oldSweep, currentSweep);

                locY = dmTimePieLabel.Location.Y + dmTimePieLabel.Height;
                rect = new Rectangle(alignmentPie.Location.X + alignmentPie.Width + 30, locY, alignmentPieLabel.Height, alignmentPieLabel.Height);
                g.DrawRectangle(blackPen, rect);
                g.FillRectangle(lightBlueBrush, rect);

                locY += alignmentPieLabel.Height * 2;
                rect = new Rectangle(alignmentPie.Location.X + alignmentPie.Width + 30, locY, alignmentPieLabel.Height, alignmentPieLabel.Height);
                g.DrawRectangle(blackPen, rect);
                g.FillRectangle(whiteBrush, rect);

                locY += alignmentPieLabel.Height * 2;
                rect = new Rectangle(alignmentPie.Location.X + alignmentPie.Width + 30, locY, alignmentPieLabel.Height, alignmentPieLabel.Height);
                g.DrawRectangle(blackPen, rect);
                g.FillRectangle(lightOrangeBrush, rect);

                locY += alignmentPieLabel.Height * 2;
                rect = new Rectangle(alignmentPie.Location.X + alignmentPie.Width + 30, locY, alignmentPieLabel.Height, alignmentPieLabel.Height);
                g.DrawRectangle(blackPen, rect);
                g.FillRectangle(blueBrush, rect);

                locY += alignmentPieLabel.Height * 2;
                rect = new Rectangle(alignmentPie.Location.X + alignmentPie.Width + 30, locY, alignmentPieLabel.Height, alignmentPieLabel.Height);
                g.DrawRectangle(blackPen, rect);
                g.FillRectangle(greyBrush, rect);

                locY += alignmentPieLabel.Height * 2;
                rect = new Rectangle(alignmentPie.Location.X + alignmentPie.Width + 30, locY, alignmentPieLabel.Height, alignmentPieLabel.Height);
                g.DrawRectangle(blackPen, rect);
                g.FillRectangle(orangeBrush, rect);

                locY += alignmentPieLabel.Height * 2;
                rect = new Rectangle(alignmentPie.Location.X + alignmentPie.Width + 30, locY, alignmentPieLabel.Height, alignmentPieLabel.Height);
                g.DrawRectangle(blackPen, rect);
                g.FillRectangle(darkBlueBrush, rect);

                locY += alignmentPieLabel.Height * 2;
                rect = new Rectangle(alignmentPie.Location.X + alignmentPie.Width + 30, locY, alignmentPieLabel.Height, alignmentPieLabel.Height);
                g.DrawRectangle(blackPen, rect);
                g.FillRectangle(blackBrush, rect);

                locY += alignmentPieLabel.Height * 2;
                rect = new Rectangle(alignmentPie.Location.X + alignmentPie.Width + 30, locY, alignmentPieLabel.Height, alignmentPieLabel.Height);
                g.DrawRectangle(blackPen, rect);
                g.FillRectangle(darkOrangeBrush, rect);

                oldSweep = 0.0f;
                currentSweep = (neutralGoodTime * 360) / totalTime;
                g.DrawPie(blackPen, dmTimePie, oldSweep, currentSweep);
                g.FillPie(whiteBrush, dmTimePie, oldSweep, currentSweep);
                oldSweep += currentSweep;
                currentSweep = (chaoticGoodTime * 360) / totalTime;
                g.DrawPie(blackPen, dmTimePie, oldSweep, currentSweep);
                g.FillPie(lightOrangeBrush, dmTimePie, oldSweep, currentSweep);
                oldSweep += currentSweep;
                currentSweep = (chaoticNeutralTime * 360) / totalTime;
                g.DrawPie(blackPen, dmTimePie, oldSweep, currentSweep);
                g.FillPie(orangeBrush, dmTimePie, oldSweep, currentSweep);
                oldSweep += currentSweep;
                currentSweep = (trueNeutralTime * 360) / totalTime;
                g.DrawPie(blackPen, dmTimePie, oldSweep, currentSweep);
                g.FillPie(greyBrush, dmTimePie, oldSweep, currentSweep);
                oldSweep += currentSweep;
                currentSweep = (lawfulNeutralTime * 360) / totalTime;
                g.DrawPie(blackPen, dmTimePie, oldSweep, currentSweep);
                g.FillPie(blueBrush, dmTimePie, oldSweep, currentSweep);
                oldSweep += currentSweep;
                currentSweep = (chaoticEvilTime * 360) / totalTime;
                g.DrawPie(blackPen, dmTimePie, oldSweep, currentSweep);
                g.FillPie(darkOrangeBrush, dmTimePie, oldSweep, currentSweep);
                oldSweep += currentSweep;
                currentSweep = (neutralEvilTime * 360) / totalTime;
                g.DrawPie(blackPen, dmTimePie, oldSweep, currentSweep);
                g.FillPie(blackBrush, dmTimePie, oldSweep, currentSweep);
                oldSweep += currentSweep;
                currentSweep = (lawfulEvilTime * 360) / totalTime;
                g.DrawPie(blackPen, dmTimePie, oldSweep, currentSweep);
                g.FillPie(darkBlueBrush, dmTimePie, oldSweep, currentSweep);
                oldSweep += currentSweep;
                currentSweep = (lawfulGoodTime * 360) / totalTime;
                g.DrawPie(blackPen, dmTimePie, oldSweep, currentSweep);
                g.FillPie(lightBlueBrush, dmTimePie, oldSweep, currentSweep);
            }
            else if (pieType == 1)
            {
                int locY = alignmentPieLabel.Location.Y + alignmentPieLabel.Height;
                Rectangle rect = new Rectangle(alignmentPie.Location.X + alignmentPie.Width + 30, locY, alignmentPieLabel.Height, alignmentPieLabel.Height);
                g.DrawRectangle(blackPen, rect);
                g.FillRectangle(whiteBrush, rect);

                locY += alignmentPieLabel.Height * 2;
                rect = new Rectangle(alignmentPie.Location.X + alignmentPie.Width + 30, locY, alignmentPieLabel.Height, alignmentPieLabel.Height);
                g.DrawRectangle(blackPen, rect);
                g.FillRectangle(greyBrush, rect);

                locY += alignmentPieLabel.Height * 2;
                rect = new Rectangle(alignmentPie.Location.X + alignmentPie.Width + 30, locY, alignmentPieLabel.Height, alignmentPieLabel.Height);
                g.DrawRectangle(blackPen, rect);
                g.FillRectangle(blackBrush, rect);

                float oldSweep = 0.0f;
                float currentSweep = (((float)neutralGood + (float)chaoticGood + (float)lawfulGood) * 360) / savedServer.RecentCharacters.Count;
                g.DrawPie(blackPen, alignmentPie, oldSweep, currentSweep);
                g.FillPie(whiteBrush, alignmentPie, oldSweep, currentSweep);
                oldSweep += currentSweep;
                currentSweep = (((float)trueNeutral + (float)chaoticNeutral + (float)lawfulNeutral) * 360) / savedServer.RecentCharacters.Count;
                g.DrawPie(blackPen, alignmentPie, oldSweep, currentSweep);
                g.FillPie(greyBrush, alignmentPie, oldSweep, currentSweep);
                oldSweep += currentSweep;
                currentSweep = (((float)neutralEvil + (float)chaoticEvil + (float)lawfulEvil) * 360) / savedServer.RecentCharacters.Count;
                g.DrawPie(blackPen, alignmentPie, oldSweep, currentSweep);
                g.FillPie(blackBrush, alignmentPie, oldSweep, currentSweep);

                locY = dmTimePieLabel.Location.Y + dmTimePieLabel.Height;
                rect = new Rectangle(alignmentPie.Location.X + alignmentPie.Width + 30, locY, alignmentPieLabel.Height, alignmentPieLabel.Height);
                g.DrawRectangle(blackPen, rect);
                g.FillRectangle(whiteBrush, rect);

                locY += alignmentPieLabel.Height * 2;
                rect = new Rectangle(alignmentPie.Location.X + alignmentPie.Width + 30, locY, alignmentPieLabel.Height, alignmentPieLabel.Height);
                g.DrawRectangle(blackPen, rect);
                g.FillRectangle(greyBrush, rect);

                locY += alignmentPieLabel.Height * 2;
                rect = new Rectangle(alignmentPie.Location.X + alignmentPie.Width + 30, locY, alignmentPieLabel.Height, alignmentPieLabel.Height);
                g.DrawRectangle(blackPen, rect);
                g.FillRectangle(blackBrush, rect);

                oldSweep = 0.0f;
                currentSweep = ((neutralGoodTime + chaoticGoodTime + lawfulGoodTime) * 360) / totalTime;
                g.DrawPie(blackPen, dmTimePie, oldSweep, currentSweep);
                g.FillPie(whiteBrush, dmTimePie, oldSweep, currentSweep);
                oldSweep += currentSweep;
                currentSweep = ((trueNeutralTime + chaoticNeutralTime + lawfulNeutralTime) * 360) / totalTime;
                g.DrawPie(blackPen, dmTimePie, oldSweep, currentSweep);
                g.FillPie(greyBrush, dmTimePie, oldSweep, currentSweep);
                oldSweep += currentSweep;
                currentSweep = ((neutralEvilTime + chaoticEvilTime + lawfulEvilTime) * 360) / totalTime;
                g.DrawPie(blackPen, dmTimePie, oldSweep, currentSweep);
                g.FillPie(blackBrush, dmTimePie, oldSweep, currentSweep);
            }
            else if (pieType == 2)
            {
                int locY = alignmentPieLabel.Location.Y + alignmentPieLabel.Height;
                Rectangle rect = new Rectangle(alignmentPie.Location.X + alignmentPie.Width + 30, locY, alignmentPieLabel.Height, alignmentPieLabel.Height);
                g.DrawRectangle(blackPen, rect);
                g.FillRectangle(blueBrush, rect);

                locY += alignmentPieLabel.Height * 2;
                rect = new Rectangle(alignmentPie.Location.X + alignmentPie.Width + 30, locY, alignmentPieLabel.Height, alignmentPieLabel.Height);
                g.DrawRectangle(blackPen, rect);
                g.FillRectangle(greyBrush, rect);

                locY += alignmentPieLabel.Height * 2;
                rect = new Rectangle(alignmentPie.Location.X + alignmentPie.Width + 30, locY, alignmentPieLabel.Height, alignmentPieLabel.Height);
                g.DrawRectangle(blackPen, rect);
                g.FillRectangle(orangeBrush, rect);

                float oldSweep = 0.0f;
                float currentSweep = (((float)lawfulEvil + (float)lawfulNeutral + (float)lawfulGood) * 360) / savedServer.RecentCharacters.Count;
                g.DrawPie(blackPen, alignmentPie, oldSweep, currentSweep);
                g.FillPie(blueBrush, alignmentPie, oldSweep, currentSweep);
                oldSweep += currentSweep;
                currentSweep = (((float)trueNeutral + (float)neutralGood + (float)neutralEvil) * 360) / savedServer.RecentCharacters.Count;
                g.DrawPie(blackPen, alignmentPie, oldSweep, currentSweep);
                g.FillPie(greyBrush, alignmentPie, oldSweep, currentSweep);
                oldSweep += currentSweep;
                currentSweep = (((float)chaoticGood + (float)chaoticNeutral + (float)chaoticEvil) * 360) / savedServer.RecentCharacters.Count;
                g.DrawPie(blackPen, alignmentPie, oldSweep, currentSweep);
                g.FillPie(orangeBrush, alignmentPie, oldSweep, currentSweep);

                locY = dmTimePieLabel.Location.Y + dmTimePieLabel.Height;
                rect = new Rectangle(alignmentPie.Location.X + alignmentPie.Width + 30, locY, alignmentPieLabel.Height, alignmentPieLabel.Height);
                g.DrawRectangle(blackPen, rect);
                g.FillRectangle(blueBrush, rect);

                locY += alignmentPieLabel.Height * 2;
                rect = new Rectangle(alignmentPie.Location.X + alignmentPie.Width + 30, locY, alignmentPieLabel.Height, alignmentPieLabel.Height);
                g.DrawRectangle(blackPen, rect);
                g.FillRectangle(greyBrush, rect);

                locY += alignmentPieLabel.Height * 2;
                rect = new Rectangle(alignmentPie.Location.X + alignmentPie.Width + 30, locY, alignmentPieLabel.Height, alignmentPieLabel.Height);
                g.DrawRectangle(blackPen, rect);
                g.FillRectangle(orangeBrush, rect);

                oldSweep = 0.0f;
                currentSweep = ((lawfulEvilTime + lawfulNeutralTime + lawfulGoodTime) * 360) / totalTime;
                g.DrawPie(blackPen, dmTimePie, oldSweep, currentSweep);
                g.FillPie(blueBrush, dmTimePie, oldSweep, currentSweep);
                oldSweep += currentSweep;
                currentSweep = ((trueNeutralTime + neutralEvilTime + neutralGoodTime) * 360) / totalTime;
                g.DrawPie(blackPen, dmTimePie, oldSweep, currentSweep);
                g.FillPie(greyBrush, dmTimePie, oldSweep, currentSweep);
                oldSweep += currentSweep;
                currentSweep = ((chaoticGoodTime + chaoticEvilTime + chaoticNeutralTime) * 360) / totalTime;
                g.DrawPie(blackPen, dmTimePie, oldSweep, currentSweep);
                g.FillPie(orangeBrush, dmTimePie, oldSweep, currentSweep);
            }
            else if (pieType == 3)
            {
                int locY = alignmentPieLabel.Location.Y + alignmentPieLabel.Height;
                Rectangle rect = new Rectangle(alignmentPie.Location.X + alignmentPie.Width + 30, locY, alignmentPieLabel.Height, alignmentPieLabel.Height);
                g.DrawRectangle(blackPen, rect);
                g.FillRectangle(new SolidBrush(Color.Purple), rect);

                locY += alignmentPieLabel.Height * 2;
                rect = new Rectangle(alignmentPie.Location.X + alignmentPie.Width + 30, locY, alignmentPieLabel.Height, alignmentPieLabel.Height);
                g.DrawRectangle(blackPen, rect);
                g.FillRectangle(new SolidBrush(Color.Blue), rect);

                locY += alignmentPieLabel.Height * 2;
                rect = new Rectangle(alignmentPie.Location.X + alignmentPie.Width + 30, locY, alignmentPieLabel.Height, alignmentPieLabel.Height);
                g.DrawRectangle(blackPen, rect);
                g.FillRectangle(new SolidBrush(Color.Green), rect);

                locY += alignmentPieLabel.Height * 2;
                rect = new Rectangle(alignmentPie.Location.X + alignmentPie.Width + 30, locY, alignmentPieLabel.Height, alignmentPieLabel.Height);
                g.DrawRectangle(blackPen, rect);
                g.FillRectangle(new SolidBrush(Color.Yellow), rect);

                locY += alignmentPieLabel.Height * 2;
                rect = new Rectangle(alignmentPie.Location.X + alignmentPie.Width + 30, locY, alignmentPieLabel.Height, alignmentPieLabel.Height);
                g.DrawRectangle(blackPen, rect);
                g.FillRectangle(new SolidBrush(Color.Orange), rect);

                locY += alignmentPieLabel.Height * 2;
                rect = new Rectangle(alignmentPie.Location.X + alignmentPie.Width + 30, locY, alignmentPieLabel.Height, alignmentPieLabel.Height);
                g.DrawRectangle(blackPen, rect);
                g.FillRectangle(new SolidBrush(Color.Red), rect);

                float oldSweep = 0.0f;
                float currentSweep = (((float)veryPoor) * 360) / savedServer.RecentCharacters.Count;
                g.DrawPie(blackPen, alignmentPie, oldSweep, currentSweep);
                g.FillPie(new SolidBrush(Color.Purple), alignmentPie, oldSweep, currentSweep);
                oldSweep += currentSweep;
                currentSweep = (((float)poor) * 360) / savedServer.RecentCharacters.Count;
                g.DrawPie(blackPen, alignmentPie, oldSweep, currentSweep);
                g.FillPie(new SolidBrush(Color.Blue), alignmentPie, oldSweep, currentSweep);
                oldSweep += currentSweep;
                currentSweep = (((float)target) * 360) / savedServer.RecentCharacters.Count;
                g.DrawPie(blackPen, alignmentPie, oldSweep, currentSweep);
                g.FillPie(new SolidBrush(Color.Green), alignmentPie, oldSweep, currentSweep);
                oldSweep += currentSweep;
                currentSweep = (((float)rich) * 360) / savedServer.RecentCharacters.Count;
                g.DrawPie(blackPen, alignmentPie, oldSweep, currentSweep);
                g.FillPie(new SolidBrush(Color.Yellow), alignmentPie, oldSweep, currentSweep);
                oldSweep += currentSweep;
                currentSweep = (((float)veryRich) * 360) / savedServer.RecentCharacters.Count;
                g.DrawPie(blackPen, alignmentPie, oldSweep, currentSweep);
                g.FillPie(new SolidBrush(Color.Orange), alignmentPie, oldSweep, currentSweep);
                oldSweep += currentSweep;
                currentSweep = (((float)cutoffRich) * 360) / savedServer.RecentCharacters.Count;
                g.DrawPie(blackPen, alignmentPie, oldSweep, currentSweep);
                g.FillPie(new SolidBrush(Color.Red), alignmentPie, oldSweep, currentSweep);


                locY = dmTimePieLabel.Location.Y + dmTimePieLabel.Height;
                rect = new Rectangle(alignmentPie.Location.X + alignmentPie.Width + 30, locY, alignmentPieLabel.Height, alignmentPieLabel.Height);
                g.DrawRectangle(blackPen, rect);
                g.FillRectangle(new SolidBrush(Color.Green), rect);

                locY += alignmentPieLabel.Height * 2;
                rect = new Rectangle(alignmentPie.Location.X + alignmentPie.Width + 30, locY, alignmentPieLabel.Height, alignmentPieLabel.Height);
                g.DrawRectangle(blackPen, rect);
                g.FillRectangle(new SolidBrush(Color.Red), rect);

                oldSweep = 0.0f;
                currentSweep = (((float)dmed) * 360) / savedServer.RecentCharacters.Count;
                g.DrawPie(blackPen, dmTimePie, oldSweep, currentSweep);
                g.FillPie(new SolidBrush(Color.Green), dmTimePie, oldSweep, currentSweep);
                oldSweep += currentSweep;
                currentSweep = (((float)unDMed) * 360) / savedServer.RecentCharacters.Count;
                g.DrawPie(blackPen, dmTimePie, oldSweep, currentSweep);
                g.FillPie(new SolidBrush(Color.Red), dmTimePie, oldSweep, currentSweep);
            }
        }

        private void PieLabel_Click(object Sender, EventArgs e)
        {
            pieType++;
            if (pieType > 3) pieType = 0;
            if (pieType == 0)
            {
                alignmentPieLabel.Text = "Alignment Distribution (All)";
                alignmentPieLabel.Size = alignmentPieLabel.PreferredSize;
                dmTimePieLabel.Text = "DM Time Distribution (All)";
                dmTimePieLabel.Size = dmTimePieLabel.PreferredSize;
                legendLabel.Text = "Lawful Good\n\nNeutral Good\n\nChaotic Good\n\nLawful Neutral\n\nTrue Neutral\n\nChaotic Neutral\n\nLawful Evil\n\nNeutral Evil\n\nChaotic Evil";
                legendLabel.Size = legendLabel.PreferredSize;
                legendLabelTwo.Text = "Lawful Good\n\nNeutral Good\n\nChaotic Good\n\nLawful Neutral\n\nTrue Neutral\n\nChaotic Neutral\n\nLawful Evil\n\nNeutral Evil\n\nChaotic Evil";
                legendLabelTwo.Size = legendLabelTwo.PreferredSize;
            }
            if (pieType == 1)
            {
                alignmentPieLabel.Text = "Alignment Distribution (Good v. Evil)";
                alignmentPieLabel.Size = alignmentPieLabel.PreferredSize;
                dmTimePieLabel.Text = "DM Time Distribution (Good v. Evil)";
                dmTimePieLabel.Size = dmTimePieLabel.PreferredSize;
                legendLabel.Text = "Good\n\nNeutral\n\nEvil";
                legendLabel.Size = legendLabel.PreferredSize;
                legendLabelTwo.Text = "Good\n\nNeutral\n\nEvil";
                legendLabelTwo.Size = legendLabelTwo.PreferredSize;
            }
            if (pieType == 2)
            {
                alignmentPieLabel.Text = "Alignment Distribution (Law v. Chaos)";
                alignmentPieLabel.Size = alignmentPieLabel.PreferredSize;
                dmTimePieLabel.Text = "DM Time Distribution (Law v. Chaos)";
                dmTimePieLabel.Size = dmTimePieLabel.PreferredSize;
                legendLabel.Text = "Lawful\n\nNeutral\n\nChaotic";
                legendLabel.Size = legendLabel.PreferredSize;
                legendLabelTwo.Text = "Lawful\n\nNeutral\n\nChaotic";
                legendLabelTwo.Size = legendLabelTwo.PreferredSize;
            }
            if (pieType == 3)
            {
                alignmentPieLabel.Text = "Wealth Distribution";
                alignmentPieLabel.Size = alignmentPieLabel.PreferredSize;
                dmTimePieLabel.Text = "DM Coverage";
                dmTimePieLabel.Size = dmTimePieLabel.PreferredSize;
                legendLabel.Text = "Very Poor\n\nPoor\n\nTarget\n\nRich\n\nVery Rich\n\nCutoff Wealth";
                legendLabel.Size = legendLabel.PreferredSize;
                legendLabelTwo.Text = "DMed\n\nUn-DMed";
                legendLabelTwo.Size = legendLabelTwo.PreferredSize;
            }
            this.OnPaint(new PaintEventArgs(this.CreateGraphics(), this.ClientRectangle));
        }
    }


}
