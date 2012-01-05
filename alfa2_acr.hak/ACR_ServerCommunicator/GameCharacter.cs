using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ALFA;

namespace ACR_ServerCommunicator
{
    /// <summary>
    /// This object maintains state about a character, gathered from the
    /// database.
    /// </summary>
    class GameCharacter : IGameEntity
    {

        public GameCharacter(GameWorldManager WorldManager)
        {
            this.WorldManager = WorldManager;
            Player = null;
            Server = null;
            Visited = false;
        }

        /// <summary>
        /// Retrieve the properties of the character from the database.
        /// </summary>
        public void PopulateFromDatabase()
        {
            IALFADatabase Database = WorldManager.Database;

            Database.ACR_SQLQuery(String.Format(
                "SELECT `Name`, `PlayerID`, `IsOnline` FROM `characters` WHERE `ID` = {0}",
                CharacterId));

            if (!Database.ACR_SQLFetch())
            {
                throw new ApplicationException("Failed to populate data for character " + CharacterId);
            }

            CharacterName = Database.ACR_SQLGetData(0);
            PlayerId = Convert.ToInt32(Database.ACR_SQLGetData(1));
            IsOnline = Convert.ToInt32(Database.ACR_SQLGetData(2)) != 0;
        }

        /// <summary>
        /// Get the database id of the character.
        /// </summary>
        public int DatabaseId
        {
            get { return CharacterId; }
        }

        /// <summary>
        /// Get the logical name of the character.
        /// </summary>
        public string Name
        {
            get { return CharacterName; }
        }

        /// <summary>
        /// The character id (from the database).
        /// </summary>
        public int CharacterId { get; set; }

        /// <summary>
        /// The owning player id.  Generally, the Player property should be
        /// used except when bootstrapping the GameCharacter object.
        /// </summary>
        public int PlayerId { get; set; }

        /// <summary>
        /// The character name.
        /// </summary>
        public string CharacterName { get; set; }

        /// <summary>
        /// The player that owns the character.
        /// </summary>
        public GamePlayer Player { get; set; }

        /// <summary>
        /// The server that the character is logged in to.
        /// </summary>
        public GameServer Server { get; set; }

        /// <summary>
        /// The Visited flag can be toggled to keep track of whether the object
        /// had been touched over a sequence of operations.  It may be used by
        /// external requestors.
        /// </summary>
        public bool Visited { get; set; }

        /// <summary>
        /// Whether the character is currently online or not.
        /// </summary>
        public bool Online
        {
            get { return IsOnline; }
            set
            {
                bool OldIsOnline = IsOnline;
                IsOnline = value;

                if (IsOnline == false)
                    Server = null;

                //
                // Notify the player object to recalculate the primary online
                // character if need be.
                //

                if (Player != null && IsOnline != OldIsOnline)
                    Player.UpdateOnlineCharacter();
            }
        }

        /// <summary>
        /// The associated game world manager.
        /// </summary>
        private GameWorldManager WorldManager;

        /// <summary>
        /// Whether the character is online or not.
        /// </summary>
        private bool IsOnline;
    }
}
