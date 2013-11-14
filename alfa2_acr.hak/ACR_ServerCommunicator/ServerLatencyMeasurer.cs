using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ACR_ServerCommunicator
{
    /// <summary>
    /// This class manages measuring the database IPC channel latency between
    /// the local server and a remote server.
    /// </summary>
    internal static class ServerLatencyMeasurer
    {

        /// <summary>
        /// Ping state communicated across the channel.
        /// </summary>
        private class PingState
        {
            /// <summary>
            /// Construct a new PingState object.
            /// </summary>
            /// <param name="PCObjectId">Supplies the player id.</param>
            /// <param name="TickCount">Supplies the tick count.</param>
            public PingState(uint PCObjectId, int TickCount)
            {
                this.PCObjectId = PCObjectId;
                this.TickCount = TickCount;
            }

            /// <summary>
            /// The PC object ID of the requesting player.
            /// </summary>
            public uint PCObjectId;

            /// <summary>
            /// The tick count snapped at the start of the ping request.
            /// </summary>
            public int TickCount;

            /// <summary>
            /// Convert the state to a string.
            /// </summary>
            /// <returns>The serialized string version of the state.</returns>
            public override string ToString()
            {
                return String.Format("{0}:{1}", PCObjectId, TickCount);
            }

            /// <summary>
            /// Deserialize the state from a string.
            /// </summary>
            /// <param name="Arguments">Supplies the state string that was
            /// constructed by a call to ToString().</param>
            /// <returns>A new PingState object containing the deserialized
            /// contents, else null on failure.  An exception may also be
            /// raised on a failure that is the result of an unexpected
            /// protocol violation.</returns>
            public static PingState FromString(string Arguments)
            {
                string[] Tokens = Arguments.Split(new char[] { ':' });

                if (Tokens == null || Tokens.Length < 2)
                    return null;

                PingState State = new PingState(Convert.ToUInt32(Tokens[0]),
                    Convert.ToInt32(Tokens[1]));

                return State;
            }
        };

        /// <summary>
        /// This when a cross-server ping response is received.  Its purpose is
        /// to compute the channel latency and send a message to that effect to
        /// the requesting player.
        /// </summary>
        /// <param name="SourceServerId">Supplies the server id of the server
        /// that completed the ping request.</param>
        /// <param name="Arguments">Supplies the serialized state arguments
        /// string.</param>
        /// <param name="Script">Supplies the current script object.</param>
        /// <returns>TRUE on success, else FALSE on failure.</returns>
        public static int HandleServerPingResponse(int SourceServerId, string Arguments, ACR_ServerCommunicator Script)
        {
            int Tick = Environment.TickCount;

            try
            {
                PingState RemoteState;

                //
                // Deserialize the remote ping state.  If null, a protocol
                // violation has occurred.
                //

                if ((RemoteState = PingState.FromString(Arguments)) == null)
                {
                    Script.WriteTimestampedLogEntry(String.Format(
                        "ACR_ServerCommunicator.ServerLatencyMeasurer.HandleServerPingResponse({0}, {1}): Invalid request.",
                        SourceServerId,
                        Arguments));
                    return ACR_ServerCommunicator.FALSE;
                }

                string ServerName = Script.GetServerName(SourceServerId);

                if (ServerName == null)
                    return ACR_ServerCommunicator.FALSE;

                Script.SendMessageToPC(RemoteState.PCObjectId, String.Format(
                    "IPC channel latency to {0}: {1}ms", ServerName, Tick - RemoteState.TickCount));
            }
            catch (Exception e)
            {
                Script.WriteTimestampedLogEntry(String.Format(
                    "ACR_ServerCommunicator.ServerLatencyMeasurer.HandleServerPingResponse({0}, {1}): Exception: {0}",
                    SourceServerId,
                    Arguments,
                    e));
                return ACR_ServerCommunicator.FALSE;
            }

            return ACR_ServerCommunicator.TRUE;
        }

        /// <summary>
        /// This method is called to request an IPC channel latency measurement
        /// to a target server.
        /// </summary>
        /// <param name="PCObjectId">Supplies the PC object id of the
        /// requesting player.</param>
        /// <param name="ServerId">Supplies the server id to send the ping
        /// request to.</param>
        /// <param name="Script">Supplies the script object.</param>
        public static void SendPingToServer(uint PCObjectId, int ServerId, ACR_ServerCommunicator Script)
        {
            //
            // Package and serialize the ping state for transmission to the
            // remote server.  The remote server will echo the ping back, and
            // HandleServerPingResponse will then be invoked via a reply
            // run script request for acr_ping_server_response.
            //

            PingState State = new PingState(PCObjectId, Environment.TickCount);

            Script.RunScriptOnServer(ServerId, "acr_server_ping_request", State.ToString());
        }

    }
}
