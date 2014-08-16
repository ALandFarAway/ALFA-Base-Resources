using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using CLRScriptFramework;
using ALFA;
using NWScript;
using NWScript.ManagedInterfaceLayer.NWScriptManagedInterface;

namespace ACR_ServerCommunicator
{
    /// <summary>
    /// This event encapsulates data relating to a request to delete a cached
    /// character file from the local vault cache.
    /// </summary>
    class PurgeCachedCharacterEvent : IGameEventQueueEvent
    {

        /// <summary>
        /// Create a new PurgeCachedCharacterEvent.
        /// </summary>
        /// <param name="Player">Supplies the player whose vault should have
        /// the specific character file removed.</param>
        /// <param name="CharacterFileName">Supplies the character file name to
        /// delete.  There should be no path separators, for example,
        /// "charfile.bic".</param>
        public PurgeCachedCharacterEvent(GamePlayer Player, string CharacterFileName)
        {
            this.Player = Player;
            this.CharacterFileName = CharacterFileName;
        }

        /// <summary>
        /// Dispatch the event (in a script context).
        /// </summary>
        /// <param name="Script">Supplies the script object.</param>
        /// <param name="Database">Supplies the database connection.</param>
        public void DispatchEvent(ACR_ServerCommunicator Script, ALFA.Database Database)
        {
            string PlayerName = Player.Name;

            if (!SystemInfo.IsSafeFileName(PlayerName))
            {
                Script.WriteTimestampedLogEntry(String.Format(
                    "PurgeCachedCharacterEvent.DispatchEvent: Invalid player name '{0}'.", PlayerName));
                return;
            }

            string VaultPath = SystemInfo.GetServerVaultPathForAccount(PlayerName);

            if (VaultPath == null)
            {
                Script.WriteTimestampedLogEntry(String.Format(
                    "PurgeCachedCharacterEvent.DispatchEvent: Could not resolve vault path for player '{0}'.",
                    Player.PlayerName));
                return;
            }

            VaultPath += CharacterFileName;

            if (!File.Exists(VaultPath))
            {
                Script.WriteTimestampedLogEntry(String.Format(
                    "PurgeCachedCharacterEvent.DispatchEvent: Character file '{0}' for player '{1}' was not locally cached.",
                    CharacterFileName,
                    Player.PlayerName));
                return;
            }

            try
            {
                File.Delete(VaultPath);
            }
            catch (Exception e)
            {
                Script.WriteTimestampedLogEntry(String.Format(
                    "PurgeCachedCharacterEvent.DispatchEvent: Exception '{0}' removing cached character '{1}' for player '{2}'.",
                    e,
                    CharacterFileName,
                    Player.PlayerName));
                return;
            }

            try
            {
                if (SystemInfo.GetVaultStoragePluginInUse())
                {
                    VaultPath = SystemInfo.GetCentralVaultPathForAccount(PlayerName);

                    VaultPath += CharacterFileName;

                    if (File.Exists(VaultPath))
                        File.Delete(VaultPath);
                }
            }
            catch (Exception e)
            {
                Script.WriteTimestampedLogEntry(String.Format(
                    "PurgeCachedCharacterEvent.DispatchEvent: Exception '{0}' removing cached character from Azure vault temporary local storage '{1}' for player '{2}'.",
                    e,
                    CharacterFileName,
                    Player.PlayerName));
                return;
            }

            Script.WriteTimestampedLogEntry(String.Format(
                "PurgeCachedCharacterEvent.DispatchEvent: Removed cached character '{0}' from player '{1}' vault cache.",
                CharacterFileName,
                Player.PlayerName));
        }

        /// <summary>
        /// The associated player.
        /// </summary>
        private GamePlayer Player;

        /// <summary>
        /// The character file name to remove.
        /// </summary>
        private string CharacterFileName;
    }
}
