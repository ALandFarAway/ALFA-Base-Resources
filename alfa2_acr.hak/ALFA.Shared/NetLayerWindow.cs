using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;
using System.Windows.Forms; // For Timer (which must fire in the main thread).

namespace NWN
{
    /// <summary>
    /// This class wraps AuroraServerNetLayer.dll's reliable datagram protocol
    /// for use by managed code.
    /// 
    /// A typical user of the class must use the following events and methods:
    /// 
    /// NetLayerWindow.Connect() is called when the application wishes to open
    /// a connection.  Keep alive traffic and other periodic events are
    /// started at this time.
    /// 
    /// NetLayerWindow.SendPacket() is called when the application wishes to
    /// send an application-specific packet to the remote endpoint.
    /// 
    /// NetLayerWindow.PacketReceiveEvent is fired when application-specific 
    /// data is received (sequenced, in-stream-order) from the remote endpoint.
    /// 
    /// NetLayerWindow.ReceivePacket() is called when NetLayerWindow packet
    /// data (raw network traffic) is received from the remote endpoint.  This
    /// data usually comes directly from a network socket.
    /// 
    /// NetLayerWindow.PacketSendEvent is fired when NetLayerWindow packet data
    /// (raw network traffic) is ready to be sent to the remote endpoint.  This
    /// data is usually sent directly to a network socket.
    /// 
    /// 
    /// To break a connection, the NetLayerWindow object should be disposed and
    /// a new NetLayerWindow object created.
    /// 
    /// 
    /// Actual responsibility for informing the other party that a connection
    /// is ready to be established (and transmitting and receiving raw network
    /// data) is the user's responsibility, and is outside the scope of the
    /// NetLayerWindow object itself.  This decouples the NetLayerWindow object
    /// from the raw details of how network traffic is sent or received.
    /// 
    /// The user must only call the NetLayerWindow object on the main thread,
    /// which must run a message loop (for the timer).  User events are only
    /// raised when a call to the NetLayerWindow object is outstanding, or the
    /// internal timer has been fired by the user's message loop.
    /// </summary>
    public class NetLayerWindow : IDisposable
    {

        /// <summary>
        /// Create a new NetLayerWindow object.
        /// </summary>
        public NetLayerWindow()
        {
            GCHandle Handle = GCHandle.Alloc(this);
            bool KeepHandle = false;

            try
            {
                CONNECTION_CALLBACKS Callbacks = new CONNECTION_CALLBACKS()
                {
                    Context = (IntPtr)Handle,
                    OnReceive = Marshal.GetFunctionPointerForDelegate(OnReceiveDelegate),
                    OnSend = Marshal.GetFunctionPointerForDelegate(OnSendDelegate),
                    OnStreamError = Marshal.GetFunctionPointerForDelegate(OnStreamErrorDelegate)
                };

                Connection = AuroraServerNetLayerCreate(IntPtr.Zero, Callbacks);

                if (Connection == IntPtr.Zero)
                    throw new OutOfMemoryException("Couldn't create NetLayerWindow object.");

                WindowTimer.Tick += WindowTimer_Tick;

                KeepHandle = true;
            }
            finally
            {
                if (!KeepHandle)
                {
                    if (Connection != IntPtr.Zero)
                    {
                        AuroraServerNetLayerDestroy(Connection);
                        Connection = IntPtr.Zero;
                    }

                    Handle.Free();
                }
            }
        }

        /// <summary>
        /// Destructor.
        /// </summary>
        ~NetLayerWindow()
        {
            Dispose(false);
        }

        /// <summary>
        /// Enable the connection for use.
        /// </summary>
        public void Connect()
        {
            if (Connection == IntPtr.Zero)
                throw new ApplicationException("Connection not established.");

            if (WindowTimer.Enabled)
                throw new ApplicationException("Connection timer already running.");

            WindowTimer.Start();
        }

        /// <summary>
        /// Dispose the object.
        /// </summary>
        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        /// <summary>
        /// Send a packet.  This should be invoked on the main thread.
        /// </summary>
        /// <param name="Data">Supplies the data packet to send.</param>
        /// <param name="FlushNagle">Supplies true if the send request should
        /// be expedited at the cost of bandwidth efficiency, by flushing any
        /// pending Nagle queue immediately.</param>
        public void SendPacket(byte[] Data, bool FlushNagle)
        {
            IntPtr Buffer = IntPtr.Zero;

            if (Connection == IntPtr.Zero)
                throw new ApplicationException("Connection not established.");

            if (Data.Length == 0)
                throw new ApplicationException("Invalid packet.");

            try
            {
                Buffer = Marshal.AllocHGlobal(Data.Length);
                Marshal.Copy(Data, 0, Buffer, Data.Length);

                if (!AuroraServerNetLayerSend(Connection, Buffer, (IntPtr)Data.Length, false, FlushNagle))
                    throw new ApplicationException("AuroraServerNetLayerSend failed.");
            }
            finally
            {
                if (Buffer != IntPtr.Zero)
                {
                    Marshal.FreeHGlobal(Buffer);
                    Buffer = IntPtr.Zero;
                }
            }
        }

        /// <summary>
        /// Receive a packet from the network.  This should be invoked on the
        /// main thread.
        /// </summary>
        /// <param name="Data">Supplies the packet data.</param>
        /// <param name="Offset">Supplies the offset into the packet data to
        /// hand off to the NetLayerWindow package (zero if the entire data
        /// buffer is in NetLayerWindow format with no application specific
        /// header prepended).</param>
        public void ReceivePacket(byte[] Data, int Offset)
        {
            IntPtr Buffer = IntPtr.Zero;

            if (Connection == IntPtr.Zero)
                throw new ApplicationException("Connection not established.");

            if ((Data.Length - Offset) == 0)
                throw new ApplicationException("Invalid packet.");

            try
            {
                Buffer = Marshal.AllocHGlobal(Data.Length - Offset);
                Marshal.Copy(Data, Offset, Buffer, Data.Length);

                if (!AuroraServerNetLayerReceive(Connection, Buffer, (IntPtr)Data.Length))
                    throw new ApplicationException("AuroraServerNetLayerReceive failed.");
            }
            finally
            {
                if (Buffer != IntPtr.Zero)
                {
                    Marshal.FreeHGlobal(Buffer);
                    Buffer = IntPtr.Zero;
                }
            }
        }

        /// <summary>
        /// Event arguments for on packet receive.
        /// </summary>
        public class PacketReceiveEventArgs : EventArgs
        {
            /// <summary>
            /// Create a packet receive event arguments object.
            /// </summary>
            /// <param name="Data">Supplies the packet data.</param>
            public PacketReceiveEventArgs(byte[] Data)
            {
                this.DataInt = Data;
            }

            private byte[] DataInt;

            /// <summary>
            /// The packet data.
            /// </summary>
            public byte[] Data { get { return DataInt; } }
        }

        /// <summary>
        /// Event registration for inbound high level packet receive.  When a
        /// correctly sequenced packet is ready to be processed by the
        /// application, the event is fired so that the application can handle
        /// the packet data as appropriate.
        /// </summary>
        public event EventHandler<PacketReceiveEventArgs> PacketReceiveEvent;

        /// <summary>
        /// Event arguments for on packet send.
        /// </summary>
        public class PacketSendEventArgs : EventArgs
        {
            /// <summary>
            /// Create a packet send event arguments object.
            /// </summary>
            /// <param name="Data">Supplies the packet data.</param>
            public PacketSendEventArgs(byte[] Data)
            {
                this.DataInt = Data;
            }

            private byte[] DataInt;

            /// <summary>
            /// The packet data.
            /// </summary>
            public byte[] Data { get { return DataInt; } }
        }

        /// <summary>
        /// Event registration for a request to transmit outbound, encapsulated
        /// internal protocol data on behalf of the NetLayerWindow package.  The
        /// event handler should transmit the data over the network.
        /// </summary>
        public event EventHandler<PacketSendEventArgs> PacketSendEvent;

        /// <summary>
        /// Event arguments for on stream error.
        /// </summary>
        public class StreamErrorEventArgs : EventArgs
        {
            /// <summary>
            /// Create a stream error event arguments object.
            /// </summary>
            /// <param name="Fatal">Supplies true if the error is fatal, else
            /// false if the error may be retried.</param>
            /// <param name="ErrorCode">Supplies the error code.</param>
            public StreamErrorEventArgs(bool Fatal, UInt32 ErrorCode)
            {
                this.FatalInt = Fatal;
                this.ErrorCodeInt = ErrorCode;
            }

            private bool FatalInt;
            private UInt32 ErrorCodeInt;

            /// <summary>
            /// True if the error is fatal, else false if the error may be
            /// transient.
            /// </summary>
            private bool Fatal { get { return FatalInt; } }

            /// <summary>
            /// The error code.
            /// </summary>
            private UInt32 ErrorCode { get { return ErrorCodeInt; } }
        }

        /// <summary>
        /// Event registration for a stream error notification.  The event
        /// handler should take appropriate streams to log the error, and if
        /// Fatal is true, close down the connection as appropriate.
        /// </summary>
        public EventHandler<StreamErrorEventArgs> StreamErrorEvent;
        
        /// <summary>
        /// Dispose the object.
        /// </summary>
        /// <param name="Disposing">Supplies true if called from
        /// Dispose.</param>
        private void Dispose(bool Disposing)
        {
            //
            // Clean up unmanaged resources and stop the timer.
            //

            if (Connection != IntPtr.Zero)
            {
                AuroraServerNetLayerDestroy(Connection);
                Connection = IntPtr.Zero;
            }

            if (WindowTimer.Enabled)
            {
                WindowTimer.Stop();
            }
        }

        /// <summary>
        /// Called by the timer package when the window timer elapses, on the
        /// main thread.
        /// </summary>
        /// <param name="sender">Unused.</param>
        /// <param name="e">Unused.</param>
        private void WindowTimer_Tick(object sender, EventArgs e)
        {
            if (Connection == IntPtr.Zero)
            {
                return;
            }

            //
            // Allow the NetLayerWindow package to perform periodic, time-based
            // tasks, and set the timer for future expiration.
            //

            WindowTimer.Interval = (int)AuroraServerNetLayerTimeout(Connection);
            WindowTimer.Start();
        }

        /// <summary>
        /// Called when a data packet is available on the NetLayerWindow
        /// connection.
        /// </summary>
        /// <param name="Data">Supplies the data packet.</param>
        /// <returns>True on success, else false on failure.</returns>
        private bool OnReceive(byte[] Data)
        {
            PacketReceiveEventArgs EventArgs;

            EventArgs = new PacketReceiveEventArgs(Data);

            PacketReceiveEvent(this, EventArgs);
            return true;
        }

        /// <summary>
        /// Called when a data packet is available to send from the
        /// NetLayerWindow connection.
        /// </summary>
        /// <param name="Data">Supplies the data packet.</param>
        /// <returns>True on success, else false on failure.</returns>
        private bool OnSend(byte[] Data)
        {
            PacketSendEventArgs EventArgs;

            EventArgs = new PacketSendEventArgs(Data);

            PacketSendEvent(this, EventArgs);
            return true;
        }

        /// <summary>
        /// Called when a stream error is raised on the NetLayerWindow
        /// connection.
        /// </summary>
        /// <param name="Fatal">Supplies true if the error is fatal, else false
        /// if the error may be continuable.</param>
        /// <param name="ErrorCode">Supplies the error code.</param>
        /// <returns>True on success, else false on failure.</returns>
        private bool OnStreamError(bool Fatal, UInt32 ErrorCode)
        {
            StreamErrorEventArgs EventArgs;

            EventArgs = new StreamErrorEventArgs(Fatal, ErrorCode);

            StreamErrorEvent(this, EventArgs);
            return true;
        }

        //
        // Define low level callbacks from native code when NetLayerWindow
        // events are received.  These are only invoked when a call to the
        // NetLayerWindow package is made.
        //

        [UnmanagedFunctionPointer(CallingConvention.Cdecl, CharSet = CharSet.Ansi, SetLastError = true)]
        [return:MarshalAs(UnmanagedType.I1)]
        private delegate bool OnReceiveProc(IntPtr Data, IntPtr Length, IntPtr Context);

        [UnmanagedFunctionPointer(CallingConvention.Cdecl, CharSet = CharSet.Ansi, SetLastError = true)]
        [return:MarshalAs(UnmanagedType.I1)]
        private delegate bool OnSendProc(IntPtr Data, IntPtr Length, IntPtr Context);

        [UnmanagedFunctionPointer(CallingConvention.Cdecl, CharSet = CharSet.Ansi, SetLastError = true)]
        [return:MarshalAs(UnmanagedType.I1)]
        private delegate bool OnStreamErrorProc([MarshalAs(UnmanagedType.I1)] bool Fatal, UInt32 ErrorCode, IntPtr Context);

        //
        // Define callback structure exchanged with the NetLayerWindow
        // implementation.
        //

        [StructLayout(LayoutKind.Sequential)]
        private struct CONNECTION_CALLBACKS
        {
            //
            // Define the arbitrary user context value that is passed to each
            // callback invocation.
            //

            public IntPtr Context;

            //
            // Define the high level receive procedure.  It is invoked each
            // time a completed high level frame has been received.
            //

            public IntPtr OnReceive;

            //
            // Define the low level send procedure.  It is invoked each time
            // a subframe datagram is ready to be written out on the wire.
            //

            public IntPtr OnSend;

            //
            // Define the routine that is invoked when an unrecoverable stream
            // error has occurred.  This typically indicates that the
            // connection should be thrown away.  If Fatal is not set then it
            // is possible that the operation could be retried, else there has
            // been a fatal state error (i.e. dropped compressed frame).
            //
            // N.B.  This is necessary to deal wit hthe fact that the BioWare
            //       implementation has serious bugs that will eventually
            //       result in a stream being rendered unusable.
            //

            public IntPtr OnStreamError;
        }

        /// <summary>
        /// Called when a data packet is available on the NetLayerWindow
        /// connection.
        /// </summary>
        /// <param name="Data">Supplies a pointer to the data buffer.</param>
        /// <param name="Length">Supplies the length, in bytes, of the data
        /// buffer.</param>
        /// <param name="Context">Supplies a GC handle to the NetLayerWindow
        /// object.</param>
        /// <returns>True on success, else false on failure.</returns>
        private static bool OnReceiveThunk(IntPtr Data, IntPtr Length, IntPtr Context)
        {
            try
            {
                GCHandle Handle = (GCHandle)Context;
                NetLayerWindow Window = (NetLayerWindow)Handle.Target;
                byte[] DataBuffer = new byte[(int)Length];

                Marshal.Copy(Data, DataBuffer, 0, (int)Length);

                return Window.OnReceive(DataBuffer);
            }
            catch
            {
                return false;
            }
        }

        /// <summary>
        /// Called when an encapsulated data packet is available to send from
        /// the NetLayerWindow connection.
        /// </summary>
        /// <param name="Data">Supplies a pointer to the data buffer.</param>
        /// <param name="Length">Supplies the length, in bytes, of the data
        /// buffer.</param>
        /// <param name="Context">Supplies a GC handle to the NetLayerWindow
        /// object.</param>
        /// <returns>True on success, else false on failure.</returns>
        private static bool OnSendThunk(IntPtr Data, IntPtr Length, IntPtr Context)
        {
            try
            {
                GCHandle Handle = (GCHandle)Context;
                NetLayerWindow Window = (NetLayerWindow)Handle.Target;
                byte[] DataBuffer = new byte[(int)Length];

                Marshal.Copy(Data, DataBuffer, 0, (int)Length);

                return Window.OnReceive(DataBuffer);
            }
            catch
            {
                return false;
            }
        }

        /// <summary>
        /// Called when a stream error occurs.
        /// </summary>
        /// <param name="Fatal">Supplies true if the error is fatal, else false
        /// if the error may be continuable.</param>
        /// <param name="ErrorCode">Supplies the error code.</param>
        /// <param name="Context">Supplies a GC handle to the NetLayerWindow
        /// object.</param>
        /// <returns>True on success, else false on failure.</returns>
        private static bool OnStreamErrorThunk(bool Fatal, UInt32 ErrorCode, IntPtr Context)
        {
            try
            {
                GCHandle Handle = (GCHandle)Context;
                NetLayerWindow Window = (NetLayerWindow)Handle.Target;

                return Window.OnStreamError(Fatal, ErrorCode);
            }
            catch
            {
                return false;
            }
        }

        /// <summary>
        /// Unmanaged function pointer delegate for OnReceive.
        /// </summary>
        private OnReceiveProc OnReceiveDelegate = new OnReceiveProc(OnReceiveThunk);

        /// <summary>
        /// Unmanaged function pointer delegate for OnSend.
        /// </summary>
        private OnSendProc OnSendDelegate = new OnSendProc(OnSendThunk);

        /// <summary>
        /// Unmanaged function pointer delegate for OnStreamError.
        /// </summary>
        private OnStreamErrorProc OnStreamErrorDelegate = new OnStreamErrorProc(OnStreamErrorThunk);

        /// <summary>
        /// Connection handle.
        /// </summary>
        private IntPtr Connection = IntPtr.Zero;

        /// <summary>
        /// A timer, fired on the main thread, which triggers periodic timed
        /// activity in the NetLayerWindow package.
        /// </summary>
        private Timer WindowTimer = new Timer();

        /// <summary>
        /// Valid values for InfoClass argument to
        /// AuroraServerNetLayerQuery:
        /// </summary>
        [Flags]
        private enum NETLAYERWINDOW_INFO_CLASS : uint
        {
            /// <summary>
            /// [out] AURORA_SERVER_QUERY_SEND_QUEUE_DEPTH
            ///
            /// Returns information about the outbound send queue depth, which
            /// may be used to prioritize and schedule traffic.
            /// </summary>
            AuroraServerQuerySendQueueDepth,
        }

        /// <summary>
        /// Define structure for querying AuroraServerQuerySendQueueDepth.
        /// </summary>
        [StructLayout(LayoutKind.Sequential)]
        private struct AURORA_SERVER_QUERY_SEND_QUEUE_DEPTH
        {
            public UInt32 SendQueueDepth; // [out]
        }



        /// <summary>
        /// Create or reinitialize (for reuse) a NetLayerWindow object.
        /// </summary>
        /// <param name="ExistingInstance">Supplies a handle to the existing
        /// NetLayerWindow object, else IntPtr.Zero to create a new instance.
        /// If an existing instance were to be supplied, it is reset and
        /// prepared for in-place reuse.</param>
        /// <param name="Callbacks">Supplies a pointer to the connection
        /// callbacks block for this instance.</param>
        /// <returns>A handle to the new NetLayerWindow object on success, else
        /// IntPtr.Zero on failure.  Success is always guaranteed if an
        /// ExistingInstance argument was supplied.</returns>
        [DllImport("AuroraServerNetLayer.dll")]
        private static extern IntPtr AuroraServerNetLayerCreate(IntPtr ExistingInstance, CONNECTION_CALLBACKS Callbacks);

        /// <summary>
        /// Send a data packet on the NetLayerWindow connection.
        /// </summary>
        /// <param name="Connection">Supplies a handle to an existing
        /// NetLayerWindow object.</param>
        /// <param name="Data">Supplies a pointer to the data buffer.</param>
        /// <param name="Length">Supplies the length, in bytes, of the data
        /// buffer.</param>
        /// <param name="HighPriority">Supplies true if the message is to be
        /// sent in the high priority queue, else false if the message is to be
        /// sent in the normal priority queue.</param>
        /// <param name="FlushNagle">Supplies true if the message is to be sent
        /// in an expedited fashion, bypassing Nagle algorithm data coaleasing
        /// within the protocol internal framing layer.</param>
        /// <returns>True on success, else false on failure.</returns>
        [DllImport("AuroraServerNetLayer.dll")]
        private static extern bool AuroraServerNetLayerSend(IntPtr Connection, IntPtr Data, IntPtr Length, bool HighPriority, bool FlushNagle);

        /// <summary>
        /// Informs a NetLayerWindow connection that raw data has been received
        /// as a datagram from the underlying low level transport (e.g. UDP
        /// socket).
        /// </summary>
        /// <param name="Connection">Supplies a handle to an existing
        /// NetLayerWindow object.</param>
        /// <param name="Data">Supplies a pointer to the data buffer.</param>
        /// <param name="Length">Supplies the length, in bytes, of the data
        /// buffer.</param>
        /// <returns>True on success, else false on failure.</returns>
        [DllImport("AuroraServerNetLayer.dll")]
        private static extern bool AuroraServerNetLayerReceive(IntPtr Connection, IntPtr Data, IntPtr Length);

        /// <summary>
        /// Performs timeout processing on a NetLayerWindow connection object.
        /// </summary>
        /// <param name="Connection">Supplies a handle to an existing
        /// NetLayerWindow object.</param>
        /// <returns>The length in time until the next requested invocation of
        /// AuroraServerNetLayerTimeout (for this connection object), expressed
        /// as a count in milliseconds, is returned.</returns>
        [DllImport("AuroraServerNetLayer.dll")]
        private static extern UInt32 AuroraServerNetLayerTimeout(IntPtr Connection);

        /// <summary>
        /// Release a NetLayerWindow connection handle that was allocated via a
        /// prior call to AuroraServerNetLayerCreate.
        /// </summary>
        /// <param name="Connection">Supplies a handle to an existing
        /// NetLayerWindow object.</param>
        /// <returns>True on success, else false on failure.</returns>
        [DllImport("AuroraServerNetLayer.dll")]
        private static extern bool AuroraServerNetLayerDestroy(IntPtr Connection);

        /// <summary>
        /// Queries information about a NetLayerWindow connection object.
        /// </summary>
        /// <param name="Connection">Supplies a handle to an existing
        /// NetLayerWindow object.</param>
        /// <param name="InfoClass">Supplies the information class to query.
        /// </param>
        /// <param name="InfoBufferSize">Supplies the length, in bytes, of the
        /// query buffer for this information class.</param>
        /// <param name="ReturnLength">On success, receives the length written,
        /// in bytes, to the query buffer.</param>
        /// <param name="InfoBuffer">Supplies a pointer to the query buffer.
        /// </param>
        /// <returns>True on success, else false on failure.</returns>
        [DllImport("AuroraServerNetLayer.dll")]
        private static extern bool AuroraServerNetLayerQuery(IntPtr Connection, NETLAYERWINDOW_INFO_CLASS InfoClass, UInt32 InfoBufferSize, out UInt32 ReturnLength, IntPtr InfoBuffer);
    }
}
