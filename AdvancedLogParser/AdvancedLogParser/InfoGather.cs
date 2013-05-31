using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Windows.Forms;
using Meebey.SmartIrc4net;
using MySql.Data;
using MySql.Data.MySqlClient;
using MySql.Data.Types;
using MySql.Data.Common;

namespace AdvancedLogParser
{
    class InfoGather
    {
        static string ConnectionString;
        public static string DatabaseServer;
        public static string DatabaseUser;
        public static string DatabasePassword;
        public static string DatabaseSchema;

        public static LoadingForm currentLoader;

        public static bool GetPlayers()
        {
            currentLoader = new LoadingForm();
            currentLoader.Show();
            currentLoader.status.Text = "Querying players...";
            Application.DoEvents();
            try
            {
                using (MySqlDataReader reader = MySqlHelper.ExecuteReader(ConnectionString, "SELECT * FROM players"))
                {
                    currentLoader.status.Text = "Loading players...";
                    Application.DoEvents();
                    while (reader.Read())
                    {
                        uint databaseRow = 0;
                        string cdKey;
                        string GSID;
                        DateTime firstLogin;
                        DateTime lastLogin;
                        uint logins;
                        bool isDM;
                        bool isBanned;
                        bool is18Plus;
                        bool isMember;
                        try
                        {
                            // First, we gather information about this row.
                            databaseRow = (uint)reader.GetValue(0);
                            cdKey = (string)reader.GetValue(1);
                            GSID = (string)reader.GetValue(2);
                            firstLogin = (DateTime)reader.GetValue(3);
                            lastLogin = (DateTime)reader.GetValue(4);
                            logins = (uint)reader.GetValue(6);
                            isDM = (bool)reader.GetValue(8);
                            isBanned = (bool)reader.GetValue(9);
                            is18Plus = (bool)reader.GetValue(10);
                            isMember = (bool)reader.GetValue(11);
                        }
                        catch
                        {
                            continue;
                        }

                        // Next, we look for if this is a player's duplicate GSID.
                        if (Players.ListByKey.Keys.Contains(cdKey))
                        {
                            // Yes, yes it is.
                            Player modifiedPlayer = Players.ListByKey[cdKey];

                            // We'll want to add to the list of Ids.
                            modifiedPlayer.playerIds.Add(databaseRow);
                            modifiedPlayer.CommunityIds.Add(GSID);

                            // We'll want to note an earlier first login, if this one is earlier
                            // and a later last login, if this one is later.
                            if (modifiedPlayer.FirstLogin > firstLogin)
                            {
                                modifiedPlayer.FirstLogin = firstLogin;
                            }
                            if (modifiedPlayer.LastLogin < lastLogin)
                            {
                                modifiedPlayer.LastLogin = lastLogin;
                            }

                            // Total number of logins is additive.
                            modifiedPlayer.Logins += logins;

                            // And if any of these bools are true, update the list to
                            // reflect as much.
                            if (isDM)
                            {
                                modifiedPlayer.IsDM = true;
                            }
                            if (isBanned)
                            {
                                modifiedPlayer.IsBanned = true;
                            }
                            if (is18Plus)
                            {
                                modifiedPlayer.Is18Plus = true;
                            }
                            if (isMember)
                            {
                                modifiedPlayer.IsMember = true;
                            }

                            // And lastly we need to make sure that the new Id is indexed.
                            Players.ListByPlayerId.Add(databaseRow, modifiedPlayer);
                        }
                        else
                        {
                            // It's a new person! Yaaaaay!
                            Player addedPlayer = new Player()
                            {
                                CDKey = cdKey,
                                DMTime = 0.0f,
                                FirstLogin = firstLogin,
                                LastLogin = lastLogin,
                                Is18Plus = is18Plus,
                                IsBanned = isBanned,
                                IsDM = isDM,
                                IsMember = isMember,
                                Logins = logins
                            };

                            addedPlayer.CommunityIds = new List<string>();
                            addedPlayer.playerIds = new List<uint>();
                            addedPlayer.Characters = new List<Character>();

                            addedPlayer.CommunityIds.Add(GSID);
                            addedPlayer.playerIds.Add(databaseRow);

                            Players.ListByPlayerId.Add(databaseRow, addedPlayer);
                            Players.ListByKey.Add(cdKey, addedPlayer);
                        }
                    }
                }
            }
            catch (Exception e)
            {
                MessageBox.Show(e.Message);
                return false;
            }
            return true;
        }

        public static void GetCharacters()
        {
            currentLoader.status.Text = "Querying characters...";
            Application.DoEvents();
            try
            {
                using (MySqlDataReader reader = MySqlHelper.ExecuteReader(ConnectionString, "SELECT * FROM characters"))
                {
                    currentLoader.status.Text = "Loading characters...";
                    Application.DoEvents();
                    while (reader.Read())
                    {
                        uint id;
                        ushort serverId;
                        uint playerId;
                        string name;
                        uint level;
                        uint race;
                        uint subRace;
                        string deity;
                        uint gender;
                        uint hitPoints;
                        uint xp;
                        uint gp;
                        uint wealth;
                        uint ethics;
                        uint morals;
                        uint class1;
                        uint level1;
                        uint class2;
                        uint level2;
                        uint class3;
                        uint level3;
                        uint strength;
                        uint dexterity;
                        uint constitution;
                        uint intelligence;
                        uint wisdom;
                        uint charisma;
                        uint damage;
                        uint deaths;
                        uint status;
                        bool isOnline;
                        bool isDeleted;
                        bool isPlayable;
                        sbyte retiredStatus;

                        try
                        {
                            id = (uint)reader.GetValue(0);
                            serverId = (ushort)reader.GetValue(1);
                            playerId = (uint)reader.GetValue(2);
                            name = (string)reader.GetValue(3);
                            level = (byte)reader.GetValue(4);
                            race = (byte)reader.GetValue(5);
                            subRace = (byte)reader.GetValue(6);
                            deity = (string)reader.GetValue(7);
                            gender = (byte)reader.GetValue(8);
                            hitPoints = (ushort)reader.GetValue(9);
                            xp = (uint)reader.GetValue(10);
                            gp = (uint)reader.GetValue(11);
                            wealth = (uint)reader.GetValue(12);
                            ethics = (byte)reader.GetValue(13);
                            morals = (byte)reader.GetValue(14);
                            class1 = (ushort)reader.GetValue(15);
                            level1 = (byte)reader.GetValue(16);
                            class2 = (ushort)reader.GetValue(17);
                            level2 = (byte)reader.GetValue(18);
                            class3 = (ushort)reader.GetValue(19);
                            level3 = (byte)reader.GetValue(20);

                            strength = (byte)reader.GetValue(23);
                            dexterity = (byte)reader.GetValue(24);
                            constitution = (byte)reader.GetValue(25);
                            intelligence = (byte)reader.GetValue(26);
                            wisdom = (byte)reader.GetValue(27);
                            charisma = (byte)reader.GetValue(28);

                            damage = (ushort)reader.GetValue(30);
                            deaths = (ushort)reader.GetValue(31);
                            status = (uint)reader.GetValue(32);
                            isOnline = (bool)reader.GetValue(33);
                            isDeleted = (bool)reader.GetValue(34);
                            isPlayable = (bool)reader.GetValue(35);
                            retiredStatus = (sbyte)reader.GetValue(38);
                        }
                        catch
                        {
                            continue;
                        }
                        Character newChar = new AdvancedLogParser.Character()
                        {
                            Charisma = charisma,
                            Class1 = class1,
                            Class2 = class2,
                            Class3 = class3,
                            Constitution = constitution,
                            Damage = damage,
                            Deaths = deaths,
                            Deity = deity,
                            Dexterity = dexterity,
                            DMTime = 0.0f,
                            Ethics = ethics,
                            Gender = gender,
                            GP = gp,
                            HitPoints = hitPoints,
                            Id = id,
                            Intelligence = intelligence,
                            IsDeleted = isDeleted,
                            IsOnline = isOnline,
                            IsPlayable = isPlayable,
                            Level = level,
                            Level1 = level1,
                            Level2 = level2,
                            Level3 = level3,
                            Morals = morals,
                            Name = name,
                            PlayerId = playerId,
                            Race = race,
                            RetiredStatus = retiredStatus,
                            ServerId = serverId,
                            Status = status,
                            Strength = strength,
                            SubRace = subRace,
                            Wealth = wealth,
                            Wisdom = wisdom,
                            XP = xp
                        };

                        if (morals >= 70)
                        {
                            if (ethics >= 70) newChar.Alignment = Alignment.LawfulGood;
                            else if (ethics >= 31) newChar.Alignment = Alignment.NeutralGood;
                            else newChar.Alignment = Alignment.ChaoticGood;
                        }
                        else if (morals >= 31)
                        {
                            if (ethics >= 70) newChar.Alignment = Alignment.LawfulNeutral;
                            else if (ethics >= 31) newChar.Alignment = Alignment.TrueNeutral;
                            else newChar.Alignment = Alignment.ChaoticNeutral;
                        }
                        else
                        {
                            if (ethics >= 70) newChar.Alignment = Alignment.LawfulEvil;
                            else if (ethics >= 31) newChar.Alignment = Alignment.NeutralEvil;
                            else newChar.Alignment = Alignment.ChaoticEvil;
                        }

                        Characters.List.Add(id, newChar);
                        try
                        {
                            Players.ListByPlayerId[playerId].Characters.Add(newChar);
                        }
                        catch { }
                    }
                }
            }
            catch (Exception e)
            {
                MessageBox.Show(e.Message);
                Application.Exit();
            }
        }

        public static void GetAlerts()
        {
            currentLoader.status.Text = "Querying alerts...";
            Application.DoEvents();
            DateTime checkFrom = DateTime.UtcNow.Subtract(TimeSpan.FromDays(30));
            try
            {
                using (MySqlDataReader reader = MySqlHelper.ExecuteReader(ConnectionString, String.Format("SELECT * FROM alandsyu_live.logs WHERE Date > '{0}/{1}/{2}' AND (Event = \"Death\" OR Event = \"Kill\" OR Event = \"Resurrection\" OR Event = \"Tech Resurrection\" OR Event = \"LOGOUT DURING COMBAT\" OR Event = \"SELF-LOOTING ATTEMPT\" OR Event = \"LOGOUT WHILE BLEEDING\" OR Event = \"Level Up\" OR Event = \"Drop, Illegal\" OR Event = \"Acquire, Illegal\" OR Event = \"XP Change\" OR (Event = \"Over-CR combat kill\" AND CharacterID != 0) OR Event = \"Death Floor\")", checkFrom.Year, checkFrom.Month, checkFrom.Day)))
                {
                    currentLoader.status.Text = "Loading alerts...";
                    Application.DoEvents();
                    uint id;
                    ushort serverId;
                    uint characterId;
                    string eventName;
                    string eventDescription;
                    DateTime time;
                    uint dmId;

                    while (reader.Read())
                    {
                        try
                        {
                            id = (uint)reader.GetValue(0);
                            serverId = (ushort)reader.GetValue(1);
                            characterId = (uint)reader.GetValue(2);
                            eventName = (string)reader.GetValue(3);
                            eventDescription = (string)reader.GetValue(4);
                            time = (DateTime)reader.GetValue(5);
                            if (!reader.IsDBNull(6))
                            {
                                dmId = (uint)reader.GetValue(6);
                            }
                            else
                            {
                                dmId = 0;
                            }
                        }
                        catch
                        {
                            continue;
                        }

                        Log newLog = new Log()
                        {
                            Id = id,
                            ServerId = serverId,
                            CharacterId = characterId,
                            DMId = dmId,
                            Event = eventName,
                            EventDescription = eventDescription,
                            Time = time
                        };
                        switch (eventName)
                        {
                            case "Death":
                                Logs.DeathAlerts.Add(newLog.Id, newLog);
                                break;
                            case "Kill":
                                Logs.DeathAlerts.Add(newLog.Id, newLog);
                                break;
                            case "Resurrection":
                                Logs.DeathAlerts.Add(newLog.Id, newLog);
                                break;
                            case "Tech Resurrection":
                                Logs.DeathAlerts.Add(newLog.Id, newLog);
                                break;
                            case "Death Floor":
                                Logs.DeathAlerts.Add(newLog.Id, newLog);
                                break;
                            case "LOGOUT DURING COMBAT":
                                Logs.EnforcementAlerts.Add(newLog.Id, newLog);
                                break;
                            case "SELF-LOOTING ATTEMPT":
                                Logs.EnforcementAlerts.Add(newLog.Id, newLog);
                                break;
                            case "LOGOUT WHILE BLEEDING":
                                Logs.EnforcementAlerts.Add(newLog.Id, newLog);
                                break;
                            case "Drop, Illegal":
                                Logs.EnforcementAlerts.Add(newLog.Id, newLog);
                                break;
                            case "Acquire, Illegal":
                                Logs.EnforcementAlerts.Add(newLog.Id, newLog);
                                break;
                            case "Level Up":
                                Logs.AdvancementAlerts.Add(newLog.Id, newLog);
                                break;
                            case "XP Change":
                                Logs.AdvancementAlerts.Add(newLog.Id, newLog);
                                break;
                            case "Over-CR combat kill":
                                Logs.AdvancementAlerts.Add(newLog.Id, newLog);
                                break;
                            default:
                                Logs.EnforcementAlerts.Add(newLog.Id, newLog);
                                break;
                        }
                    }
                }
            }
            catch (Exception e)
            {
                MessageBox.Show(e.Message);
                Application.Exit();
            }
        }

        public static void GetLogins()
        {
            currentLoader.status.Text = "Querying logins...";
            Application.DoEvents();
            DateTime checkFrom = DateTime.UtcNow.Subtract(TimeSpan.FromDays(30));
            try
            {
                using (MySqlDataReader reader = MySqlHelper.ExecuteReader(ConnectionString, String.Format("SELECT * FROM alandsyu_live.logs WHERE Date > '{0}/{1}/{2}' AND Event = \"Login\"", checkFrom.Year, checkFrom.Month, checkFrom.Day)))
                {
                    currentLoader.status.Text = "Loading logins...";
                    Application.DoEvents();
                    uint id;
                    ushort serverId;
                    uint characterId;
                    string eventName;
                    string eventDescription;
                    DateTime time;
                    uint dmId;

                    while (reader.Read())
                    {
                        try
                        {
                            id = (uint)reader.GetValue(0);
                            serverId = (ushort)reader.GetValue(1);
                            characterId = (uint)reader.GetValue(2);
                            eventName = (string)reader.GetValue(3);
                            eventDescription = (string)reader.GetValue(4);
                            time = (DateTime)reader.GetValue(5);
                            if (!reader.IsDBNull(6))
                            {
                                dmId = (uint)reader.GetValue(6);
                            }
                            else
                            {
                                dmId = 0;
                            }
                        }
                        catch
                        {
                            continue;
                        }

                        Log newLog = new Log()
                        {
                            Id = id,
                            ServerId = serverId,
                            CharacterId = characterId,
                            DMId = dmId,
                            Event = eventName,
                            EventDescription = eventDescription,
                            Time = time
                        };
                        Logs.RecentLogins.Add(newLog.Id, newLog);
                    }
                }
            }
            catch (Exception e)
            {
                MessageBox.Show(e.Message);
                Application.Exit();
            }
        }

        public static void IdentifyLogins()
        {
            currentLoader.status.Text = "Identifying players...";
            Application.DoEvents();
            foreach (Log thisLog in Logs.RecentLogins.Values)
            {
                try
                {
                    if (!Servers.List.Keys.Contains(thisLog.ServerId))
                    {
                        Server srv = new Server() { ServerId = thisLog.ServerId };
                        Servers.List.Add(thisLog.ServerId, srv);
                    }
                    Server currentServer = Servers.List[thisLog.ServerId];

                    if (thisLog.EventDescription.Contains("Dungeon Master:"))
                    {
                        Player dm = Players.ListByPlayerId[Characters.List[thisLog.CharacterId].PlayerId];
                        if (!currentServer.RecentDMs.Contains(dm))
                        {
                            currentServer.RecentDMs.Add(dm);
                        }
                    }
                    else
                    {
                        Character character = Characters.List[thisLog.CharacterId];
                        if (!currentServer.RecentCharacters.Contains(character))
                        {
                            currentServer.RecentCharacters.Add(character);
                        }

                        Player player = Players.ListByPlayerId[Characters.List[thisLog.CharacterId].PlayerId];
                        if (!currentServer.RecentPlayers.Contains(player))
                        {
                            currentServer.RecentPlayers.Add(player);
                        }
                    }
                }
                catch { }
            }
        }

        public static void BuildConnectionString()
        {
            ConnectionString = String.Format("Server={0};Uid={1};Password={2};Database={3};Max Pool Size=2;Pooling=true;Allow Batch=true",
                        DatabaseServer,
                        DatabaseUser,
                        DatabasePassword,
                        DatabaseSchema);
        }

        public static void GetDMTime()
        {
            currentLoader.status.Text = "Querying DM Time...";
            Application.DoEvents();
            DateTime checkFrom = DateTime.UtcNow.Subtract(TimeSpan.FromDays(30));
            try
            {
                using (MySqlDataReader reader = MySqlHelper.ExecuteReader(ConnectionString, String.Format("SELECT * FROM alandsyu_live.logs WHERE Date > '{0}/{1}/{2}' AND (Event = \"XP Gain, DM RP\" OR \"XP Gain, DM Quest\")", checkFrom.Year, checkFrom.Month, checkFrom.Day)))
                {
                    currentLoader.status.Text = "Parsing DM Time...";
                    Application.DoEvents();
                    while (reader.Read())
                    {
                        try
                        {
                            uint id = (uint)reader.GetValue(0);
                            ushort serverId = (ushort)reader.GetValue(1);
                            uint characterId = (uint)reader.GetValue(2);
                            string eventName = (string)reader.GetValue(3);
                            string eventDescription = (string)reader.GetValue(4);
                            string timeDMed;
                            if (eventName == "XP Gain, DM RP")
                            {
                                timeDMed = eventDescription.Split(' ')[7];
                            }
                            else
                            {
                                timeDMed = eventDescription.Split(' ')[11];
                            }
                            float addingTime = 0.0f;
                            float.TryParse(timeDMed, out addingTime);
                            Character charDMed = Characters.List[characterId];
                            charDMed.DMTime += addingTime;
                            Player playerDMed = Players.ListByPlayerId[charDMed.PlayerId];
                            playerDMed.DMTime += addingTime;
                        }
                        catch(Exception e)
                        {
                            MessageBox.Show(e.Message);
                            continue;
                        }
                    }
                }
            }
            catch (Exception e)
            {
                MessageBox.Show(e.Message);
                Application.Exit();
            }
        }

        public static WealthLevel GetWealthLevel(Character character)
        {
            uint nLowWealth = GetLowWealth(character.XP);
            uint nMedWealth = GetMedWealth(character.XP);
            uint nHighWealth = GetHighWealth(character.XP);
            uint nCutOff = GetCutoffWealth(character.XP);

            if (character.Wealth < nLowWealth) return WealthLevel.VeryPoor;
            else if (character.Wealth < nMedWealth * 0.9) return WealthLevel.Poor;
            else if (character.Wealth < nMedWealth * 1.1) return WealthLevel.Target;
            else if (character.Wealth < nHighWealth) return WealthLevel.Rich;
            else if (character.Wealth < nCutOff) return WealthLevel.VeryRich;
            else return WealthLevel.Cutoff;
        }

        static uint GetLowWealth(uint nXP)
        {
            uint nPercent, nBelowNumber, nAboveNumber;
            if (nXP < 1000)
            {
                nPercent = (100 * nXP) / 1000;
                nBelowNumber = 300;
                nAboveNumber = 650;
            }
            else if (nXP < 3000)
            {
                nPercent = (100 * (nXP - 1000)) / 2000;
                nBelowNumber = 650;
                nAboveNumber = 1925;
            }
            else if (nXP < 6000)
            {
                nPercent = (100 * (nXP - 3000)) / 3000;
                nBelowNumber = 1925;
                nAboveNumber = 3850;
            }
            else if (nXP < 10000)
            {
                nPercent = (100 * (nXP - 6000)) / 4000;
                nBelowNumber = 3850;
                nAboveNumber = 6425;
            }
            else if (nXP < 15000)
            {
                nPercent = (100 * (nXP - 10000)) / 5000;
                nBelowNumber = 6425;
                nAboveNumber = 9300;
            }
            else if (nXP < 21000)
            {
                nPercent = (100 * (nXP - 15000)) / 6000;
                nBelowNumber = 9300;
                nAboveNumber = 13575;
            }
            else if (nXP < 28000)
            {
                nPercent = (100 * (nXP - 21000)) / 7000;
                nBelowNumber = 13575;
                nAboveNumber = 19300;
            }
            else if (nXP < 36000)
            {
                nPercent = (100 * (nXP - 28000)) / 8000;
                nBelowNumber = 19300;
                nAboveNumber = 25750;
            }
            else if (nXP < 45000)
            {
                nPercent = (100 * (nXP - 36000)) / 9000;
                nBelowNumber = 25750;
                nAboveNumber = 35025;
            }
            else if (nXP < 55000)
            {
                nPercent = (100 * (nXP - 45000)) / 10000;
                nBelowNumber = 35025;
                nAboveNumber = 47200;
            }
            else if (nXP < 66000)
            {
                nPercent = (100 * (nXP - 55000)) / 11000;
                nBelowNumber = 47200;
                nAboveNumber = 62925;
            }
            else if (nXP < 78000)
            {
                nPercent = (100 * (nXP - 66000)) / 12000;
                nBelowNumber = 62925;
                nAboveNumber = 78650;
            }
            else if (nXP < 91000)
            {
                nPercent = (100 * (nXP - 78000)) / 13000;
                nBelowNumber = 78650;
                nAboveNumber = 107250;
            }
            else if (nXP < 105000)
            {
                nPercent = (100 * (nXP - 91000)) / 14000;
                nBelowNumber = 107250;
                nAboveNumber = 143000;
            }
            else if (nXP < 120000)
            {
                nPercent = (100 * (nXP - 105000)) / 15000;
                nBelowNumber = 143000;
                nAboveNumber = 185900;
            }
            else if (nXP < 136000)
            {
                nPercent = (100 * (nXP - 120000)) / 16000;
                nBelowNumber = 185900;
                nAboveNumber = 243100;
            }
            else if (nXP < 153000)
            {
                nPercent = (100 * (nXP - 136000)) / 17000;
                nBelowNumber = 243100;
                nAboveNumber = 314600;
            }
            else if (nXP < 171000)
            {
                nPercent = (100 * (nXP - 153000)) / 18000;
                nBelowNumber = 314600;
                nAboveNumber = 414700;
            }
            else if (nXP < 190000)
            {
                nPercent = (100 * (nXP - 171000)) / 19000;
                nBelowNumber = 414700;
                nAboveNumber = 500000;
            }
            else
            {
                nPercent = 100;
                nBelowNumber = 500000;
                nAboveNumber = 500000;
            }

            return (((nAboveNumber - nBelowNumber) * nPercent) / 100) + nBelowNumber;
        }

        static uint GetMedWealth(uint nXP)
        {
            uint nPercent, nBelowNumber, nAboveNumber;
            if (nXP < 1000)
            {
                nPercent = (100 * nXP) / 1000;
                nBelowNumber = 600;
                nAboveNumber = 1175;
            }
            else if (nXP < 3000)
            {
                nPercent = (100 * (nXP - 1000)) / 2000;
                nBelowNumber = 1175;
                nAboveNumber = 3500;
            }
            else if (nXP < 6000)
            {
                nPercent = (100 * (nXP - 3000)) / 3000;
                nBelowNumber = 3500;
                nAboveNumber = 7025;
            }
            else if (nXP < 10000)
            {
                nPercent = (100 * (nXP - 6000)) / 4000;
                nBelowNumber = 7025;
                nAboveNumber = 11700;
            }
            else if (nXP < 15000)
            {
                nPercent = (100 * (nXP - 10000)) / 5000;
                nBelowNumber = 11700;
                nAboveNumber = 16900;
            }
            else if (nXP < 21000)
            {
                nPercent = (100 * (nXP - 15000)) / 6000;
                nBelowNumber = 16900;
                nAboveNumber = 24700;
            }
            else if (nXP < 28000)
            {
                nPercent = (100 * (nXP - 21000)) / 7000;
                nBelowNumber = 24700;
                nAboveNumber = 35100;
            }
            else if (nXP < 36000)
            {
                nPercent = (100 * (nXP - 28000)) / 8000;
                nBelowNumber = 35100;
                nAboveNumber = 46800;
            }
            else if (nXP < 45000)
            {
                nPercent = (100 * (nXP - 36000)) / 9000;
                nBelowNumber = 46800;
                nAboveNumber = 63700;
            }
            else if (nXP < 55000)
            {
                nPercent = (100 * (nXP - 45000)) / 10000;
                nBelowNumber = 63700;
                nAboveNumber = 85800;
            }
            else if (nXP < 66000)
            {
                nPercent = (100 * (nXP - 55000)) / 11000;
                nBelowNumber = 85800;
                nAboveNumber = 114400;
            }
            else if (nXP < 78000)
            {
                nPercent = (100 * (nXP - 66000)) / 12000;
                nBelowNumber = 114400;
                nAboveNumber = 143000;
            }
            else if (nXP < 91000)
            {
                nPercent = (100 * (nXP - 78000)) / 13000;
                nBelowNumber = 143000;
                nAboveNumber = 195000;
            }
            else if (nXP < 105000)
            {
                nPercent = (100 * (nXP - 91000)) / 14000;
                nBelowNumber = 195000;
                nAboveNumber = 260000;
            }
            else if (nXP < 120000)
            {
                nPercent = (100 * (nXP - 105000)) / 15000;
                nBelowNumber = 260000;
                nAboveNumber = 338000;
            }
            else if (nXP < 136000)
            {
                nPercent = (100 * (nXP - 120000)) / 16000;
                nBelowNumber = 338000;
                nAboveNumber = 442000;
            }
            else if (nXP < 153000)
            {
                nPercent = (100 * (nXP - 136000)) / 17000;
                nBelowNumber = 442000;
                nAboveNumber = 572000;
            }
            else if (nXP < 171000)
            {
                nPercent = (100 * (nXP - 153000)) / 18000;
                nBelowNumber = 572000;
                nAboveNumber = 754000;
            }
            else if (nXP < 190000)
            {
                nPercent = (100 * (nXP - 171000)) / 19000;
                nBelowNumber = 754000;
                nAboveNumber = 1000000;
            }
            else
            {
                nPercent = 100;
                nBelowNumber = 1000000;
                nAboveNumber = 1000000;
            }

            return (((nAboveNumber - nBelowNumber) * nPercent) / 100) + nBelowNumber;
        }

        static uint GetHighWealth(uint nXP)
        {
            uint nPercent, nBelowNumber, nAboveNumber;
            if (nXP < 1000)
            {
                nPercent = (100 * nXP) / 1000;
                nBelowNumber = 2000;
                nAboveNumber = 3500;
            }
            else if (nXP < 3000)
            {
                nPercent = (100 * (nXP - 1000)) / 2000;
                nBelowNumber = 3500;
                nAboveNumber = 5100;
            }
            else if (nXP < 6000)
            {
                nPercent = (100 * (nXP - 3000)) / 3000;
                nBelowNumber = 5100;
                nAboveNumber = 10175;
            }
            else if (nXP < 10000)
            {
                nPercent = (100 * (nXP - 6000)) / 4000;
                nBelowNumber = 10175;
                nAboveNumber = 16975;
            }
            else if (nXP < 15000)
            {
                nPercent = (100 * (nXP - 10000)) / 5000;
                nBelowNumber = 16975;
                nAboveNumber = 24500;
            }
            else if (nXP < 21000)
            {
                nPercent = (100 * (nXP - 15000)) / 6000;
                nBelowNumber = 24500;
                nAboveNumber = 35825;
            }
            else if (nXP < 28000)
            {
                nPercent = (100 * (nXP - 21000)) / 7000;
                nBelowNumber = 35825;
                nAboveNumber = 50900;
            }
            else if (nXP < 36000)
            {
                nPercent = (100 * (nXP - 28000)) / 8000;
                nBelowNumber = 50900;
                nAboveNumber = 67850;
            }
            else if (nXP < 45000)
            {
                nPercent = (100 * (nXP - 36000)) / 9000;
                nBelowNumber = 67850;
                nAboveNumber = 92375;
            }
            else if (nXP < 55000)
            {
                nPercent = (100 * (nXP - 45000)) / 10000;
                nBelowNumber = 92375;
                nAboveNumber = 124425;
            }
            else if (nXP < 66000)
            {
                nPercent = (100 * (nXP - 55000)) / 11000;
                nBelowNumber = 124425;
                nAboveNumber = 165875;
            }
            else if (nXP < 78000)
            {
                nPercent = (100 * (nXP - 66000)) / 12000;
                nBelowNumber = 165875;
                nAboveNumber = 207350;
            }
            else if (nXP < 91000)
            {
                nPercent = (100 * (nXP - 78000)) / 13000;
                nBelowNumber = 207350;
                nAboveNumber = 282750;
            }
            else if (nXP < 105000)
            {
                nPercent = (100 * (nXP - 91000)) / 14000;
                nBelowNumber = 282750;
                nAboveNumber = 377000;
            }
            else if (nXP < 120000)
            {
                nPercent = (100 * (nXP - 105000)) / 15000;
                nBelowNumber = 377000;
                nAboveNumber = 490100;
            }
            else if (nXP < 136000)
            {
                nPercent = (100 * (nXP - 120000)) / 16000;
                nBelowNumber = 490100;
                nAboveNumber = 640900;
            }
            else if (nXP < 153000)
            {
                nPercent = (100 * (nXP - 136000)) / 17000;
                nBelowNumber = 640900;
                nAboveNumber = 829400;
            }
            else if (nXP < 171000)
            {
                nPercent = (100 * (nXP - 153000)) / 18000;
                nBelowNumber = 829400;
                nAboveNumber = 1093300;
            }
            else if (nXP < 190000)
            {
                nPercent = (100 * (nXP - 171000)) / 19000;
                nBelowNumber = 1093300;
                nAboveNumber = 1500000;
            }
            else
            {
                nPercent = 100;
                nBelowNumber = 1500000;
                nAboveNumber = 1500000;
            }

            return (((nAboveNumber - nBelowNumber) * nPercent) / 100) + nBelowNumber;
        }

        static uint GetCutoffWealth(uint nXP)
        {
            uint nPercent, nBelowNumber, nAboveNumber;
            if (nXP < 1000)
            {
                nPercent = (100 * nXP) / 1000;
                nBelowNumber = 13350;
                nAboveNumber = 13350;
            }
            else if (nXP < 3000)
            {
                nPercent = (100 * (nXP - 1000)) / 2000;
                nBelowNumber = 13350;
                nAboveNumber = 13350;
            }
            else if (nXP < 6000)
            {
                nPercent = (100 * (nXP - 3000)) / 3000;
                nBelowNumber = 13350;
                nAboveNumber = 13350;
            }
            else if (nXP < 10000)
            {
                nPercent = (100 * (nXP - 6000)) / 4000;
                nBelowNumber = 13350;
                nAboveNumber = 22225;
            }
            else if (nXP < 15000)
            {
                nPercent = (100 * (nXP - 10000)) / 5000;
                nBelowNumber = 22225;
                nAboveNumber = 32100;
            }
            else if (nXP < 21000)
            {
                nPercent = (100 * (nXP - 15000)) / 6000;
                nBelowNumber = 32100;
                nAboveNumber = 46925;
            }
            else if (nXP < 28000)
            {
                nPercent = (100 * (nXP - 21000)) / 7000;
                nBelowNumber = 46925;
                nAboveNumber = 66700;
            }
            else if (nXP < 36000)
            {
                nPercent = (100 * (nXP - 28000)) / 8000;
                nBelowNumber = 66700;
                nAboveNumber = 88925;
            }
            else if (nXP < 45000)
            {
                nPercent = (100 * (nXP - 36000)) / 9000;
                nBelowNumber = 88925;
                nAboveNumber = 121025;
            }
            else if (nXP < 55000)
            {
                nPercent = (100 * (nXP - 45000)) / 10000;
                nBelowNumber = 121025;
                nAboveNumber = 163025;
            }
            else if (nXP < 66000)
            {
                nPercent = (100 * (nXP - 55000)) / 11000;
                nBelowNumber = 163025;
                nAboveNumber = 217350;
            }
            else if (nXP < 78000)
            {
                nPercent = (100 * (nXP - 66000)) / 12000;
                nBelowNumber = 217350;
                nAboveNumber = 271700;
            }
            else if (nXP < 91000)
            {
                nPercent = (100 * (nXP - 78000)) / 13000;
                nBelowNumber = 271700;
                nAboveNumber = 370500;
            }
            else if (nXP < 105000)
            {
                nPercent = (100 * (nXP - 91000)) / 14000;
                nBelowNumber = 370500;
                nAboveNumber = 494000;
            }
            else if (nXP < 120000)
            {
                nPercent = (100 * (nXP - 105000)) / 15000;
                nBelowNumber = 494000;
                nAboveNumber = 642200;
            }
            else if (nXP < 136000)
            {
                nPercent = (100 * (nXP - 120000)) / 16000;
                nBelowNumber = 642200;
                nAboveNumber = 839800;
            }
            else if (nXP < 153000)
            {
                nPercent = (100 * (nXP - 136000)) / 17000;
                nBelowNumber = 839800;
                nAboveNumber = 1086800;
            }
            else if (nXP < 171000)
            {
                nPercent = (100 * (nXP - 153000)) / 18000;
                nBelowNumber = 1086800;
                nAboveNumber = 1432600;
            }
            else if (nXP < 190000)
            {
                nPercent = (100 * (nXP - 171000)) / 19000;
                nBelowNumber = 1432600;
                nAboveNumber = 2000000;
            }
            else
            {
                nPercent = 100;
                nBelowNumber = 2000000;
                nAboveNumber = 2000000;
            }

            return (((nAboveNumber - nBelowNumber) * nPercent) / 100) + nBelowNumber;
        }
    }
}
