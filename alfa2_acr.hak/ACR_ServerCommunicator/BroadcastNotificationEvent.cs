﻿using System;
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
    /// This event encapsulates data relating to a broadcast notification for
    /// all players on the server.
    /// </summary>
    class BroadcastNotificationEvent : IGameEventQueueEvent
    {

        /// <summary>
        /// Create a new BroadcastNotificationEvent.
        /// </summary>
        /// <param name="Message">Supplies the message text.</param>
        public BroadcastNotificationEvent(string Message)
        {
            this.Message = Message;
        }

        /// <summary>
        /// Dispatch the event (in a script context).
        /// </summary>
        /// <param name="Script">Supplies the script object.</param>
        /// <param name="Database">Supplies the database connection.</param>
        public void DispatchEvent(ACR_ServerCommunicator Script, ALFA.Database Database)
        {
            foreach (uint PlayerObject in Script.GetPlayers(true))
            {
                string FormattedMessage = String.Format(
                    "</c><c=#FFFF00>{0}</c>",
                    Message);

                NWScript.Vector3 v;
                v.x = v.y = v.z = 0.0f;

                Script.SendChatMessage(
                    CLRScriptBase.OBJECT_INVALID,
                    PlayerObject,
                    CLRScriptBase.CHAT_MODE_SERVER,
                    FormattedMessage,
                    CLRScriptBase.FALSE);

                Script.FloatingTextStringOnCreature(FormattedMessage,
                    PlayerObject,
                    CLRScriptBase.FALSE,
                    5.0f,
                    CLRScriptBase.COLOR_WHITE,
                    CLRScriptBase.COLOR_WHITE,
                    0.0f,
                    v);
            }

            Database.ACR_IncrementStatistic("BROADCAST_MESSAGE");
            Script.WriteTimestampedLogEntry("Received broadcast notification: " + Message);
        }

        /// <summary>
        /// The message text.
        /// </summary>
        private string Message;
    }
}
