using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using CLRScriptFramework;
using ALFA;
using NWScript;
using NWScript.ManagedInterfaceLayer.NWScriptManagedInterface;

namespace ACR_ServerCommunicator
{
    /// <summary>
    /// This event encapsulates data relating to an account association request
    /// for a player.  Such an event is created when a player is asynchronously
    /// discovered to not have a forum account to community account association
    /// set up yet.
    /// </summary>
    class PlayerAccountAssociationEvent : IGameEventQueueEvent
    {

        /// <summary>
        /// Create a new PlayerAccountAssociationEvent.
        /// </summary>
        /// <param name="PlayerObject">Supplies the local object id of the
        /// player to send to.</param>
        /// <param name="AccountAssociationSecret">Supplies the account
        /// association secret.</param>
        /// <param name="AccountAssociationURL">Supplies the base URL of the
        /// account association service.</param>
        public PlayerAccountAssociationEvent(uint PlayerObject, string AccountAssociationSecret, string AccountAssociationURL)
        {
            this.PlayerObject = PlayerObject;
            this.AccountAssociationSecret = AccountAssociationSecret;
            this.AccountAssociationURL = AccountAssociationURL;
        }

        /// <summary>
        /// Dispatch the event (in a script context).
        /// </summary>
        /// <param name="Script">Supplies the script object.</param>
        /// <param name="Database">Supplies the database connection.</param>
        public void DispatchEvent(ACR_ServerCommunicator Script, ALFA.Database Database)
        {
            PlayerState State = Script.TryGetPlayerState(PlayerObject);
            string RequestURL;

            //
            // If the player is logged off, then there's nothing to do.
            //

            if (State == null || State.IsDM)
                return;

            if (String.IsNullOrEmpty(AccountAssociationSecret))
                return;

            RequestURL = AccountAssociator.GenerateAssociationURL(Script.GetPCPlayerName(PlayerObject), AccountAssociationSecret, AccountAssociationURL);

            Script.DisplayGuiScreen(PlayerObject, "acr_account_association", CLRScriptBase.FALSE, "acr_account_association.XML", CLRScriptBase.FALSE);
            Script.SetLocalGUIVariable(PlayerObject, "acr_account_association", 0, RequestURL);
        }

        /// <summary>
        /// The object id of the player to send the message to.
        /// </summary>
        private uint PlayerObject;

        /// <summary>
        /// The account association secret.
        /// </summary>
        private string AccountAssociationSecret;

        /// <summary>
        /// The account association service URL.
        /// </summary>
        private string AccountAssociationURL;
    }
}
