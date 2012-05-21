//
// This module contains logic for dealing with direct socket I/O.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;
using System.Net;

namespace ACR_ServerCommunicator
{
    /// <summary>
    /// This class supports direct socket I/O.
    /// </summary>
    static class SocketIo
    {

        /// <summary>
        /// Initialize the socket subsystem.
        /// </summary>
        /// <returns>True if socket I/O is connected.</returns>
        public static bool Initialize()
        {
            if (Initialized)
                return true;

            try
            {
                RecvfromDelegate = new RecvfromCallout(OnLowLevelReceive);
                RecvfromDelegateHandle = GCHandle.Alloc(RecvfromDelegate);

                try
                {
                    SetRecvfromCallout(Marshal.GetFunctionPointerForDelegate(RecvfromDelegate));
                }
                catch
                {
                    RecvfromDelegate = null;
                    RecvfromDelegateHandle.Free();
                    throw;
                }
            }
            catch
            {
                return false;
            }

            Initialized = true;
            return true;
        }

        /// <summary>
        /// Send a message to an arbitrary destination using the server's data
        /// socket.
        /// </summary>
        /// <param name="Message">Supplies the bytes to send.</param>
        /// <param name="Destination">Supplies the destination network address.
        /// </param>
        /// <param name="DestinationPort">Supplies the destination port.
        /// </param>
        public static void SendMessage(byte[] Message, IPAddress Destination, int DestinationPort)
        {
            sockaddr_in sin = new sockaddr_in()
            {
                sin_family = AF_INET,
                sin_port = (ushort)IPAddress.HostToNetworkOrder((short)DestinationPort),
#pragma warning disable 618
                sin_addr = (uint)Destination.Address,
#pragma warning restore 618
                sin_zero = new byte[8] { 0, 0, 0, 0, 0, 0, 0, 0 }
            };

            SendMessage(Message, sin);
        }

        /// <summary>
        /// Send a message to an arbitrary destination using the server's data
        /// socket.
        /// </summary>
        /// <param name="Message">Supplies the bytes to send.</param>
        /// <param name="Destination">Supplies the destination address.</param>
        public static void SendMessage(byte[] Message, sockaddr_in Destination)
        {
            int Length;

            if (RecvfromSocket == IntPtr.Zero || Message == null || ((Length = Message.Length) == 0))
                return;

            IntPtr BounceBuffer = Marshal.AllocHGlobal(Length);

            try
            {
                Marshal.Copy(Message, 0, BounceBuffer, Length);
                sendto(RecvfromSocket, BounceBuffer, Length, 0, ref Destination, Marshal.SizeOf(typeof(sockaddr_in)));
            }
            finally
            {
                Marshal.FreeHGlobal(BounceBuffer);
            }
        }

        /// <summary>
        /// sockaddr_in layout in C#.
        /// </summary>
        [StructLayout(LayoutKind.Sequential)]
        public struct sockaddr_in
        {
            public short sin_family;
            public ushort sin_port;
            public uint sin_addr;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public byte[] sin_zero;
        };

        [DllImport("ws2_32.dll")]
        private static extern int sendto(IntPtr s, IntPtr buf, int len, int flags, ref sockaddr_in to, int tolen);

        //
        // The following are used with the new xp_bugfix recvfrom hook.  Note
        // that until all servers have rolled out the new plugin version, we
        // must gracefully handle SetRecvfromCallout not existing.
        //

        [UnmanagedFunctionPointer(CallingConvention.StdCall)]
        private delegate int RecvfromCallout(IntPtr s, IntPtr buf, int len, int flags, IntPtr from, IntPtr fromlen);

        /// <summary>
        /// Set the low level recvfrom callout.
        /// </summary>
        /// <param name="NewCallout">Supplies the new callout.</param>
        /// <returns>The previous callout is returned.</returns>
        [DllImport("xp_bugfix.dll", CallingConvention = CallingConvention.StdCall)]
        private static extern IntPtr SetRecvfromCallout(IntPtr NewCallout);


        /// <summary>
        /// Called when nwn2server receives a message from UDP.  The routine
        /// decides if the message should be internally handled, and, if so,
        /// packages it up for managed handling.  Otherwise, the original
        /// nwn2server handling is continued.
        /// </summary>
        /// <param name="s">Supplies the socket that received data.</param>
        /// <param name="buf">Supplies the buffer pointer (length of len).
        /// </param>
        /// <param name="len">Supplies the count of bytes received.</param>
        /// <param name="flags">Supplies the original recvfrom flags.</param>
        /// <param name="from">Supplies the sender address.  This is known to
        /// be at least the size of a sockaddr_in.</param>
        /// <param name="fromlen">Supplies the length of the sender address.
        /// </param>
        /// <returns>The new count of bytes to be considered as received.  If
        /// the routine internally handles the message then this should be set
        /// to zero.  Otherwise, len should be returned.</returns>
        private static int OnLowLevelReceive(IntPtr s, IntPtr buf, int len, int flags, IntPtr from, IntPtr fromlen)
        {
            if (RecvfromSocket == IntPtr.Zero)
                RecvfromSocket = s;

            if (len < 5 || Marshal.ReadInt32(fromlen) < Marshal.SizeOf(typeof(sockaddr_in)))
                return len;

            if (Marshal.ReadInt32(buf) != ALFAProtocolMagic)
                return len;

            try
            {
                switch ((PROTOCOL_ID)Marshal.ReadByte(buf + 4))
                {

                    case PROTOCOL_ID.PROTOCOL_DATAGRAM:
                        sockaddr_in Sender = (sockaddr_in)Marshal.PtrToStructure(from, typeof(sockaddr_in));

                        if (Sender.sin_family != AF_INET)
                            return len;

                        OnDatagramReceive(buf, len, Sender);
                        return 0;

                    default:
                        return len;

                }
            }
            catch
            {
                return 0;
            }
        }

        /// <summary>
        /// This routine handles ALFA datagram protocol messages that have been
        /// received over the network.
        /// </summary>
        /// <param name="buf">Supplies the received data payload.</param>
        /// <param name="len">Supplies the length of received data.</param>
        /// <param name="Sender">Supplies the sender's address.</param>
        private static void OnDatagramReceive(IntPtr buf, int len, sockaddr_in Sender)
        {
            IPAddress Address = new IPAddress(Sender.sin_addr);
            int Port = (int)IPAddress.NetworkToHostOrder((short)Sender.sin_port);
            ServerNetworkManager NetworkManager = ACR_ServerCommunicator.GetNetworkManager();
            byte[] Data = new byte[len];
            Marshal.Copy(buf, Data, 0, len);

            NetworkManager.OnDatagramReceive(Data, Address, Port);
        }

        /// <summary>
        /// True if the recvfrom callout was initialized.
        /// </summary>
        private static bool Initialized = false;

        /// <summary>
        /// The data socket of the server.
        /// </summary>
        private static IntPtr RecvfromSocket = IntPtr.Zero;

        /// <summary>
        /// The magic header that ALFA-specific messages are multiplexed under
        /// for the server data port.
        /// </summary>
        public const int ALFAProtocolMagic = 0x414c4641; // 'ALFA'

        /// <summary>
        /// Protocol id numbers for ALFA protocols.  The protocol byte follows
        /// the ALFA protocol magic int.
        /// </summary>
        public enum PROTOCOL_ID : byte
        {
            /// <summary>
            /// The datagram protocol.  Connectionless and without any
            /// reliability guarantees.
            /// </summary>
            PROTOCOL_DATAGRAM = 0,
        }

        /// <summary>
        /// IPv4 protocol family.
        /// </summary>
        private const short AF_INET = 2;

        /// <summary>
        /// Delegate for the recvfrom callout.
        /// </summary>
        private static RecvfromCallout RecvfromDelegate;

        /// <summary>
        /// GC handle used to keep the unmanaged callback delegate alive for
        /// the recvfrom callout.
        /// </summary>
        private static GCHandle RecvfromDelegateHandle;

    }
}
