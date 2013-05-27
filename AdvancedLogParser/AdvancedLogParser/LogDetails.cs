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
    public class LogDetails : Form
    {
        Label IdLabel = new Label();
        Label IdValue = new Label();
        Label ServerLabel = new Label();
        Label ServerValue = new Label();
        Label TimeLabel = new Label();
        Label TimeValue = new Label();
        Label CharacterLabel = new Label();
        Label CharacterValue = new Label();
        Label DMLabel = new Label();
        Label DMValue = new Label();
        Label EvNameLabel = new Label();
        Label EvNameValue = new Label();
        Label EvDescLabel = new Label();
        Label EvDescValue = new Label();

        const int RightColumn = 100;

        public LogDetails(Log log)
        {
            this.Name = String.Format("{0} - {1}", log.Id, log.Event);
            this.Text = this.Name;

            IdLabel.Text = "Id:";
            IdLabel.Size = IdLabel.PreferredSize;
            IdLabel.Location = new Point(5, 0);

            IdValue.Text = log.Id.ToString();
            IdValue.Size = IdValue.PreferredSize;
            IdValue.Location = new Point(RightColumn, IdLabel.Location.Y);

            ServerLabel.Text = "Server:";
            ServerLabel.Size = ServerLabel.PreferredSize;
            ServerLabel.Location = new Point(5, IdLabel.Location.Y + IdLabel.Height);

            ServerValue.Text = log.ServerId.ToString();
            ServerValue.Size = ServerValue.PreferredSize;
            ServerValue.Location = new Point(RightColumn, ServerLabel.Location.Y);

            TimeLabel.Text = "Time:";
            TimeLabel.Size = TimeLabel.PreferredSize;
            TimeLabel.Location = new Point(5, ServerLabel.Location.Y + ServerLabel.Height);

            TimeValue.Text = String.Format("{0} {1} UTC", log.Time.ToShortDateString(), log.Time.ToShortTimeString());
            TimeValue.Size = TimeValue.PreferredSize;
            TimeValue.Location = new Point(RightColumn, TimeLabel.Location.Y);

            CharacterLabel.Text = "Character:";
            CharacterLabel.Size = CharacterLabel.PreferredSize;
            CharacterLabel.Location = new Point(5, TimeLabel.Location.Y + TimeLabel.Height);

            if (Characters.List.ContainsKey(log.CharacterId))
            {
                CharacterValue.Text = Characters.List[log.CharacterId].Name;
            }
            else
            {
                CharacterValue.Text = "Unknown Character";
            }
            CharacterValue.Size = CharacterValue.PreferredSize;
            CharacterValue.Location = new Point(RightColumn, CharacterLabel.Location.Y);

            DMLabel.Text = "DM:";
            DMLabel.Size = DMLabel.PreferredSize;
            DMLabel.Location = new Point(5, CharacterLabel.Location.Y + CharacterLabel.Height);

            if (log.DMId == 0)
            {
                DMValue.Text = "No DM";
            }
            else if (Characters.List.ContainsKey(log.DMId))
            {
                if (Players.ListByPlayerId.ContainsKey(Characters.List[log.DMId].PlayerId))
                {
                    Player dm = Players.ListByPlayerId[Characters.List[log.DMId].PlayerId];
                    string aliases = "";
                    foreach (string alias in dm.CommunityIds)
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
                    DMValue.Text = aliases;
                }
                else
                {
                    DMValue.Text = "Unknown DM";
                }
            }
            else
            {
                DMValue.Text = "Unknown DM";
            }
            DMValue.Size = DMValue.PreferredSize;
            DMValue.Location = new Point(RightColumn, DMLabel.Location.Y);

            EvNameLabel.Text = "Type:";
            EvNameLabel.Size = EvNameLabel.PreferredSize;
            EvNameLabel.Location = new Point(5, DMLabel.Location.Y + DMLabel.Height);

            EvNameValue.Text = log.Event;
            EvNameValue.Size = EvNameValue.PreferredSize;
            EvNameValue.Location = new Point(RightColumn, EvNameLabel.Location.Y);

            EvDescLabel.Text = "Description:";
            EvDescLabel.Size = EvDescLabel.PreferredSize;
            EvDescLabel.Location = new Point(5, EvNameLabel.Location.Y + EvNameLabel.Height);

            EvDescValue.Text = log.EventDescription;
            EvDescValue.Size = EvDescValue.PreferredSize;
            EvDescValue.Location = new Point(10, EvDescLabel.Location.Y + EvDescLabel.Height);

            this.Height = EvDescValue.Size.Height + EvDescValue.Location.Y + 30;
            this.Width = EvDescValue.Size.Width + EvDescValue.Location.X + 10;
            if (this.Width < 300) this.Width = 300;

            this.Controls.Add(IdLabel);
            this.Controls.Add(IdValue);
            this.Controls.Add(ServerLabel);
            this.Controls.Add(ServerValue);
            this.Controls.Add(TimeLabel);
            this.Controls.Add(TimeValue);
            this.Controls.Add(CharacterLabel);
            this.Controls.Add(CharacterValue);
            this.Controls.Add(DMLabel);
            this.Controls.Add(DMValue);
            this.Controls.Add(EvNameLabel);
            this.Controls.Add(EvNameValue);
            this.Controls.Add(EvDescLabel);
            this.Controls.Add(EvDescValue);
        }
    }
}
