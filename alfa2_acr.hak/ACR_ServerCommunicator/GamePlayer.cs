using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ALFA;

namespace ACR_ServerCommunicator
{
    /// <summary>
    /// This object maintains state about a player, gathered from the database.
    /// </summary>
    class GamePlayer : IGameEntity
    {

        /// <summary>
        /// Construct a new GamePlayer object.
        /// </summary>
        public GamePlayer(GameWorldManager WorldManager)
        {
            this.WorldManager = WorldManager;
            this.Characters = new List<GameCharacter>();
            this.OnlineCharacter = null;
        }

        /// <summary>
        /// Retrieve the properties of the player from the database.
        /// </summary>
        public void PopulateFromDatabase()
        {
            IALFADatabase Database = WorldManager.Database;

            Database.ACR_SQLQuery(String.Format(
                "SELECT `Name`, `IsDM` FROM `players` WHERE `ID` = {0}",
                PlayerId));

            if (!Database.ACR_SQLFetch())
            {
                throw new ApplicationException("Failed to populate data for player " + PlayerId);
            }

            PlayerName = Database.ACR_SQLGetData(0);
            IsDM = Convert.ToBoolean(Database.ACR_SQLGetData(1));
        }

        /// <summary>
        /// Get the database id of the player.
        /// </summary>
        public int DatabaseId
        {
            get { return PlayerId; }
        }

        /// <summary>
        /// Get the logical name of the player.
        /// </summary>
        public string Name
        {
            get { return PlayerName; }
        }

        /// <summary>
        /// The player id (from the database).
        /// </summary>
        public int PlayerId { get; set; }

        /// <summary>
        /// The player account name.
        /// </summary>
        public string PlayerName { get; set; }

        /// <summary>
        /// Whether the player is logged on as a DM.  Only meaningful if the
        /// player is actually logged on to a server.
        /// </summary>
        public bool IsDM { get; set; }

        /// <summary>
        /// The list of associated characters.
        /// </summary>
        public List<GameCharacter> Characters { get; set; }

        /// <summary>
        /// Get the primary online character for the player.  Returns null if
        /// the player is not online.
        /// </summary>
        /// <returns>The primary online character is returned, else null if the
        /// player is not online.</returns>
        public GameCharacter GetOnlineCharacter()
        {
            return OnlineCharacter;
        }

        /// <summary>
        /// Get the primary server that the player is online at.  Returns null
        /// if the player is not online.
        /// </summary>
        /// <returns>The primary server that the player is online at is
        /// returned, else null if the player is not online.</returns>
        public GameServer GetOnlineServer()
        {
            GameCharacter Character = GetOnlineCharacter();

            if (Character == null)
                return null;

            return Character.Server;
        }

        /// <summary>
        /// Get whether the player is currently online.
        /// </summary>
        /// <returns></returns>
        public bool IsOnline()
        {
            return (GetOnlineCharacter() != null);
        }

        /// <summary>
        /// Calculate the new online character after a status change.
        /// </summary>
        public void UpdateOnlineCharacter()
        {
            OnlineCharacter = (from C in Characters
                               where C.Server != null
                               select C).FirstOrDefault();
        }

        /// <summary>
        /// The associated game world manager.
        /// </summary>
        private GameWorldManager WorldManager;

        /// <summary>
        /// The current online character, if any.
        /// </summary>
        private GameCharacter OnlineCharacter;
    }
}
