//
// This module handles internetwork communication between servers.
//

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using ALFA;

namespace ACR_ServerCommunicator
{
    /// <summary>
    /// This class handles cross-server direct network communication.
    /// </summary>
    class ServerNetworkManager
    {
        /// <summary>
        /// Initialize the ServerNetworkManager instance.
        /// </summary>
        /// <param name="WorldManager">Supplies the game world manager to which
        /// the network manager instance is bound.</param>
        /// <param name="LocalServerId">Supplies the server id of the local
        /// server.</param>
        /// <param name="Script">Supplies the main script object.</param>
        public ServerNetworkManager(GameWorldManager WorldManager, int LocalServerId, ACR_ServerCommunicator Script)
        {
            SocketIo.Initialize(Script);

            this.WorldManager = WorldManager;
            this.LocalServerId = LocalServerId;
        }

        /// <summary>
        /// Send an IPC wakeup message to a destination server.
        /// </summary>
        /// <param name="Server">Supplies the destination server.</param>
        public void SendMessageIPCWakeup(GameServer Server)
        {
            NetworkMessage Message = CreateDatagramMessage(DATAGRAM_MESSAGE_CMD.CMD_IPC_WAKE);
            BufferBuilder Builder = Message.GetBuilder();

            Builder.WriteInt32(LocalServerId);
            Builder.WriteInt32(Server.ServerId);

            SendMessageToServer(Message, Server);
        }

        /// <summary>
        /// Send a shutdown notification message to a destination server.
        /// </summary>
        /// <param name="Server">Supplies the destination server.</param>
        public void SendMessageShutdownNotify(GameServer Server)
        {
            NetworkMessage Message = CreateDatagramMessage(DATAGRAM_MESSAGE_CMD.CMD_SHUTDOWN_NOTIFY);
            BufferBuilder Builder = Message.GetBuilder();

            Builder.WriteInt32(LocalServerId);

            SendMessageToServer(Message, Server);
        }

        /// <summary>
        /// Send a database online/offline notification to a server.
        /// </summary>
        /// <param name="Server">Supplies the destination server.</param>
        /// <param name="Online">Supplies 1 if the database is viewed as
        /// online, else 0 if the database is viewed as offline.</param>
        public void SendNotifyMessageDatabaseStatus(GameServer Server, bool Online)
        {
            NetworkMessage Message = CreateDatagramMessage(DATAGRAM_MESSAGE_CMD.CMD_NOTIFY_DATABASE_STATUS);
            BufferBuilder Builder = Message.GetBuilder();

            Builder.WriteInt32(LocalServerId);
            Builder.WriteByte(Online ? (byte)1 : (byte)0);

            SendMessageToServer(Message, Server);
        }

        /// <summary>
        /// Send a direct message to a server.  Failures are ignored.
        /// </summary>
        /// <param name="Data">Supplies the message payload.</param>
        /// <param name="Server">Supplies the destination server.</param>
        private void SendMessageToServer(byte[] Data, GameServer Server)
        {
            try
            {
                IPAddress Address;

                if (Server.ServerId == LocalServerId)
                    Address = IPAddress.Loopback;
                else
                    Address = Server.GetIPAddress();

                SocketIo.SendMessage(Data, Address, Server.ServerPort);
            }
            catch
            {
            }
        }

        /// <summary>
        /// Send a direct message to a server.  Failures are ignored.
        /// </summary>
        /// <param name="Message">Supplies the message payload.</param>
        /// <param name="Server">Supplies the destination server.</param>
        private void SendMessageToServer(NetworkMessage Message, GameServer Server)
        {
            if (!Server.Online)
                return;

            try
            {
                SendMessageToServer(Message.FinalizeMessage(), Server);
            }
            catch
            {
            }
        }

        /// <summary>
        /// Create a new outbound datagram message.
        /// </summary>
        /// <param name="Cmd">Supplies the message command code.</param>
        /// <returns>The new outbound message is returned.</returns>
        private NetworkMessage CreateDatagramMessage(DATAGRAM_MESSAGE_CMD Cmd)
        {
            return new NetworkMessage(SocketIo.ALFAProtocolMagic,
                (byte)SocketIo.PROTOCOL_ID.PROTOCOL_DATAGRAM,
                (UInt16)Cmd);
        }

        /// <summary>
        /// This routine handles ALFA datagram protocol messages that have been
        /// received over the network.
        /// </summary>
        /// <param name="Data">Supplies the received data payload.</param>
        /// <param name="Sender">Supplies the sender's address.</param>
        /// <param name="SenderPort">Supplies the sender's port.</param>
        public void OnDatagramReceive(byte[] Data, IPAddress Sender, int SenderPort)
        {
            NetworkMessage Message = new NetworkMessage(Data,
                SocketIo.ALFAProtocolMagic,
                (byte)SocketIo.PROTOCOL_ID.PROTOCOL_DATAGRAM);

            GameServer SourceServer = LookupServer(Sender, SenderPort);

            if (SourceServer == null)
            {
                lock (WorldManager)
                {
                    WorldManager.WriteDiagnosticLog(String.Format("ServerNetworkManager.OnDatagramReceive: Received datagram from unknown source {0}:{1}", Sender, SenderPort));
                    return;
                }
            }

            //
            // Dispatch the message.
            //

            switch ((DATAGRAM_MESSAGE_CMD)Message.GetCommand())
            {

                case DATAGRAM_MESSAGE_CMD.CMD_IPC_WAKE:
                    OnRecvMessageIPCWake(Message, SourceServer);
                    return;

                case DATAGRAM_MESSAGE_CMD.CMD_SHUTDOWN_NOTIFY:
                    OnRecvMessageShutdownNotify(Message, SourceServer);
                    return;

                case DATAGRAM_MESSAGE_CMD.CMD_NOTIFY_DATABASE_STATUS:
                    OnRecvMessageNotifyDatabaseStatus(Message, SourceServer);
                    return;

            }
        }

        /// <summary>
        /// Handle an IPC wakeup message received.
        /// </summary>
        /// <param name="Message">Supplies the message.</param>
        /// <param name="Source">Supplies the message sender.</param>
        private void OnRecvMessageIPCWake(NetworkMessage Message, GameServer Source)
        {
            BufferParser Parser = Message.GetParser();
            int SourceServerId = Parser.ReadInt32();
            int DestinationServerId = Parser.ReadInt32();

            Parser.FinishParsing();

            if (SourceServerId != Source.ServerId || LocalServerId != DestinationServerId)
                return;

            //
            // Signal the world manager that it should break out of the polling
            // wait and immediately check for new IPC messages that are
            // available to process.
            //

            WorldManager.SignalIPCEventWakeup();
        }

        /// <summary>
        /// Handle a shutdown notification message.
        /// </summary>
        /// <param name="Message">Supplies the message.</param>
        /// <param name="Source">Supplies the message sender.</param>
        private void OnRecvMessageShutdownNotify(NetworkMessage Message, GameServer Source)
        {
            BufferParser Parser = Message.GetParser();
            int SourceServerId = Parser.ReadInt32();

            Parser.FinishParsing();

            if (SourceServerId != Source.ServerId)
                return;

            //
            // Tear down any state between the two servers.
            //
        }

        /// <summary>
        /// Handle a database status notification.
        /// </summary>
        /// <param name="Message">Supplies the message.</param>
        /// <param name="Source">Supplies the message sender.</param>
        private void OnRecvMessageNotifyDatabaseStatus(NetworkMessage Message, GameServer Source)
        {
            BufferParser Parser = Message.GetParser();
            int SourceServerId = Parser.ReadInt32();
            bool DatabaseOnline = (Parser.ReadByte() == 0 ? false : true);

            Parser.FinishParsing();

            if (SourceServerId != Source.ServerId)
                return;

            lock (WorldManager)
            {
                if (Source.Online)
                    Source.DatabaseOnline = DatabaseOnline;
            }
        }

        /// <summary>
        /// Look up a server by network address.
        /// </summary>
        /// <param name="Address">Supplies the address to look up.</param>
        /// <param name="Port">Supplies the port to look up.</param>
        /// <returns>The associated server object, else null if there was no
        /// match.</returns>
        private GameServer LookupServer(IPAddress Address, int Port)
        {
            try
            {
                lock (WorldManager)
                {
                    GameServer Server;

                    if (IPAddress.IsLoopback(Address))
                    {
                        Server = (from S in WorldManager.Servers
                                  where S.ServerId == LocalServerId
                                  select S).FirstOrDefault();
                    }
                    else
                    {
                        Server = (from S in WorldManager.Servers
                                  where S.Online && S.ServerPort == Port && S.GetIPAddress() == Address
                                  select S).FirstOrDefault();
                    }

                    return Server;
                }
            }
            catch
            {
                return null;
            }
        }

        /// <summary>
        /// Message commands numbers for the datagram protocol.
        /// </summary>
        private enum DATAGRAM_MESSAGE_CMD : uint
        {
            /// <summary>
            /// An IPC event has been placed in to the server queue, so the
            /// server should wake up to perform processing.
            /// </summary>
            CMD_IPC_WAKE = 0x0000,
            /// <summary>
            /// Notify that the server intends to shut down cleanly.
            /// </summary>
            CMD_SHUTDOWN_NOTIFY = 0x0001,
            /// <summary>
            /// Notify the server of our local view of the database's status.
            /// </summary>
            CMD_NOTIFY_DATABASE_STATUS = 0x0002,
        }

        /// <summary>
        /// The game world manager.
        /// </summary>
        private GameWorldManager WorldManager;

        /// <summary>
        /// Supplies the local server id.
        /// </summary>
        private int LocalServerId;
    }
}
