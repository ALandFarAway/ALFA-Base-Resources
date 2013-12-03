using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;

namespace NWN
{
    /// <summary>
    /// This class wraps AuroraServerNetLayer.dll's reliable datagram protocol
    /// for use by managed code.
    /// </summary>
    public class NetLayerWindow
    {

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

            IntPtr Context;

            //
            // Define the high level receive procedure.  It is invoked each
            // time a completed high level frame has been received.
            //

            IntPtr OnReceive;

            //
            // Define the low level send procedure.  It is invoked each time
            // a subframe datagram is ready to be written out on the wire.
            //

            IntPtr OnSend;

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

            IntPtr OnStreamError;
        }

        /// <summary>
        /// Called when a data packet is available on the NetLayerWindow
        /// connection.
        /// </summary>
        /// <param name="Data">Supplies the data packet.</param>
        /// <returns>True on success, else false on failure.</returns>
        private bool OnReceive(byte[] Data)
        {
            Data = Data;
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
            Data = Data;
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
            Fatal = Fatal;
            ErrorCode = ErrorCode;
            return true;
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
        private static bool OnStreamError(bool Fatal, UInt32 ErrorCode, IntPtr Context)
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
            UInt32 SendQueueDepth; // [out]
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
