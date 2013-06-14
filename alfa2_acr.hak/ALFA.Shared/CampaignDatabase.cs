using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;

namespace ALFA.Shared
{
    /// <summary>
    /// The CampaignDatabase class encapsulates support for interacting with
    /// the StoreCampaignObject and RetrieveCampaignObject script functions.
    /// It allows CLR code to be registered to handle specific calls to both of
    /// these script functions, via the StoreCampaignDatabaseEvent and
    /// RetrieveCampaignDatabaseEvent events, respectively.  These two events
    /// allow code to either receive a serialized, GFF-format version of a game
    /// object, or to instantiate a game object from a GFF-format serialized
    /// buffer.
    /// </summary>
    public class CampaignDatabase
    {
        /// <summary>
        /// Wrapper class to manage the campaign database hook with cleanup.
        /// Only a single instance should exist.
        /// </summary>
        private class CampaignDatabaseHook : IDisposable
        {

            /// <summary>
            /// Constructor.
            /// </summary>
            internal CampaignDatabaseHook()
            {
                //
                // Create delegates.
                //

                CCodeBase_GetBinaryData_HookDelegate = new CCodeBase_GetBinaryData(GetBinaryDataHook);
                CCodeBase_AddBinaryData_HookDelegate = new CCodeBase_AddBinaryData(AddBinaryDataHook);

                CCodeBase_GetBinaryData_OriginalDelegate = (CCodeBase_GetBinaryData)Marshal.GetDelegateForFunctionPointer(CCodeBase_GetBinaryData_Offset, typeof(CCodeBase_GetBinaryData));
                CCodeBase_AddBinaryData_OriginalDelegate = (CCodeBase_AddBinaryData)Marshal.GetDelegateForFunctionPointer(CCodeBase_AddBinaryData_Offset, typeof(CCodeBase_AddBinaryData));

                //
                // Install hooks.
                //

                GetBinaryDataPatch = new CodePatch(
                    ServerInterop.CCodeBase_GetBinaryData_Call,
                    Marshal.GetFunctionPointerForDelegate(CCodeBase_GetBinaryData_HookDelegate),
                    true);
                AddBinaryDataPatch = new CodePatch(
                    ServerInterop.CCodeBase_AddBinaryData_Call,
                    Marshal.GetFunctionPointerForDelegate(CCodeBase_AddBinaryData_HookDelegate),
                    true);
            }

            /// <summary>
            /// Destructor.
            /// </summary>
            ~CampaignDatabaseHook()
            {
                Dispose(false);
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
            /// Dispose the object.
            /// </summary>
            /// <param name="Disposing">Supplies true if called from Dispose.</param>
            private void Dispose(bool Disposing)
            {
                if (GetBinaryDataPatch != null)
                {
                    GetBinaryDataPatch.Dispose();
                    GetBinaryDataPatch = null;
                }

                if (AddBinaryDataPatch != null)
                {
                    AddBinaryDataPatch.Dispose();
                    AddBinaryDataPatch = null;
                }
            }

            /// <summary>
            /// RetrieveCampaignObject hook.  Called when the server script
            /// function RetrieveCampaignObject is called by any script.
            /// </summary>
            /// <param name="CodeBaseObject">Supplies the code base this
            /// pointer.</param>
            /// <param name="CampaignName">Supplies the campaign name.</param>
            /// <param name="VarName">Supplies the variable name.</param>
            /// <param name="PlayerName">Supplies the player name.</param>
            /// <param name="Cls">Always receives 'O'.</param>
            /// <param name="Size">Receives the size of the restored object GFF
            /// data.</param>
            /// <returns>An unmanaged pointer on the server heap that contains
            /// the raw GFF data for the object.  IntPtr.Zero if there is no
            /// data to restore.</returns>
            private IntPtr GetBinaryDataHook(IntPtr CodeBaseObject, IntPtr CampaignName, IntPtr VarName, IntPtr PlayerName, out Byte Cls, out UInt32 Size)
            {
                string CampaignNameStr = ServerInterop.ReadCExoString(CampaignName);

                //
                // If the campaign is the virtual database, call registered
                // event handlers.
                //

                if (CampaignNameStr.StartsWith("VirtualDatabase"))
                {
                    Cls = (byte)'O';

                    try
                    {
                        RetrieveCampaignDatabaseEventArgs EventArgs;
                        string VarNameStr = ServerInterop.ReadCExoString(VarName);
                        string PlayerNameStr = ServerInterop.ReadCExoString(PlayerName);

                        EventArgs = new RetrieveCampaignDatabaseEventArgs(CampaignNameStr.Substring(15), VarNameStr, PlayerNameStr);
                        CampaignDatabase.RetrieveCampaignDatabaseEvent(null, EventArgs);

                        //
                        // If no handler instantiated a GFF, then return no
                        // data found.  Otherwise, allocate a buffer from the
                        // unmanaged server heap, and copy the contents of the
                        // GFF into the heap buffer and return the heap buffer.
                        //

                        if (EventArgs.GFF == null || EventArgs.GFF.Length == 0)
                        {
                            Size = 0;
                            return IntPtr.Zero;
                        }
                        else
                        {
                            IntPtr GFFBuffer = IntPtr.Zero;

                            try
                            {
                                GFFBuffer = ServerInterop.AllocateServerHeap((uint)EventArgs.GFF.Length);
                                Marshal.Copy(EventArgs.GFF, 0, GFFBuffer, EventArgs.GFF.Length);
                                Size = (uint)EventArgs.GFF.Length;

                                return GFFBuffer;
                            }
                            catch
                            {
                                if (GFFBuffer != IntPtr.Zero)
                                {
                                    ServerInterop.FreeServerHeap(GFFBuffer);
                                    GFFBuffer = IntPtr.Zero;
                                }
                            }
                        }
                    }
                    catch
                    {
                        Size = 0;
                        return IntPtr.Zero;
                    }
                }

                //
                // Pass through to the original server implementation that uses
                // the standard campaign database.
                //

                return CCodeBase_GetBinaryData_OriginalDelegate(CodeBaseObject, CampaignName, VarName, PlayerName, out Cls, out Size);
            }

            /// <summary>
            /// StoreCampaignObject hook.  Called when the server script
            /// function StoreCampaignObject is called by any script.
            /// </summary>
            /// <param name="CodeBaseObject">Supplies the code base this
            /// pointer.</param>
            /// <param name="CampaignName">Supplies the campaign name.</param>
            /// <param name="VarName">Supplies the variable name.</param>
            /// <param name="PlayerName">Supplies the player name.</param>
            /// <param name="Cls">Always supplies the value 'O'.</param>
            /// <param name="Data">Supplies the raw GFF buffer.</param>
            /// <param name="Size">Supplies the count of raw GFF bytes in the
            /// data buffer.</param>
            /// <returns>True if the object was stored, else false if the
            /// object was not stored.
            private Int32 AddBinaryDataHook(IntPtr CodeBaseObject, IntPtr CampaignName, IntPtr VarName, IntPtr PlayerName, Byte Cls, IntPtr Data, UInt32 Size)
            {
                string CampaignNameStr = ServerInterop.ReadCExoString(CampaignName);

                //
                // If the campaign is the virtual database, call registered
                // event handlers.
                //

                if (CampaignNameStr.StartsWith("VirtualDatabase"))
                {
                    try
                    {
                        StoreCampaignDatabaseEventArgs EventArgs;
                        string VarNameStr = ServerInterop.ReadCExoString(VarName);
                        string PlayerNameStr = ServerInterop.ReadCExoString(PlayerName);
                        byte[] GFF = new byte[(int)Size];

                        Marshal.Copy(Data, GFF, 0, (int)Size);

                        EventArgs = new StoreCampaignDatabaseEventArgs(CampaignNameStr.Substring(15), VarNameStr, PlayerNameStr, GFF);
                        CampaignDatabase.StoreCampaignDatabaseEvent(null, EventArgs);

                        return EventArgs.Handled ? 1 : 0;
                    }
                    catch
                    {
                        return 0;
                    }
                }

                //
                // Pass through to the original server implementation that uses
                // the standard campaign database.
                //

                return CCodeBase_AddBinaryData_OriginalDelegate(CodeBaseObject, CampaignName, VarName, PlayerName, Cls, Data, Size);
            }

            /// <summary>
            /// GetBinaryData virtual address.
            /// </summary>
            private IntPtr CCodeBase_GetBinaryData_Offset = new IntPtr((UInt32)Marshal.ReadInt32(ServerInterop.CCodeBase_GetBinaryData_Call) + (UInt32)ServerInterop.CCodeBase_GetBinaryData_Call + 4);

            /// <summary>
            /// AddBinaryData virtual address
            /// </summary>
            private IntPtr CCodeBase_AddBinaryData_Offset = new IntPtr((UInt32)Marshal.ReadInt32(ServerInterop.CCodeBase_AddBinaryData_Call) + (UInt32)ServerInterop.CCodeBase_AddBinaryData_Call + 4);

            /// <summary>
            /// GetBinaryData patch.
            /// </summary>
            private CodePatch GetBinaryDataPatch = null;

            /// <summary>
            /// AddBinaryData patch.
            /// </summary>
            private CodePatch AddBinaryDataPatch = null;

            /// <summary>
            /// RetrieveCampaignObject hook.  Called when the server script
            /// function RetrieveCampaignObject is called by any script.
            /// </summary>
            /// <param name="CodeBaseObject">Supplies the code base this
            /// pointer.</param>
            /// <param name="CampaignName">Supplies the campaign name.</param>
            /// <param name="VarName">Supplies the variable name.</param>
            /// <param name="PlayerName">Supplies the player name.</param>
            /// <param name="Cls">Always receives 'O'.</param>
            /// <param name="Size">Receives the size of the restored object GFF
            /// data.</param>
            /// <returns>An unmanaged pointer on the server heap that contains
            /// the raw GFF data for the object.  IntPtr.Zero if there is no
            /// data to restore.</returns>
            [UnmanagedFunctionPointer(CallingConvention.ThisCall, SetLastError = true)]
            private delegate IntPtr CCodeBase_GetBinaryData(IntPtr CodeBaseObject, IntPtr CampaignName, IntPtr VarName, IntPtr PlayerName, out Byte Cls, out UInt32 Size);

            /// <summary>
            /// StoreCampaignObject hook.  Called when the server script
            /// function StoreCampaignObject is called by any script.
            /// </summary>
            /// <param name="CodeBaseObject">Supplies the code base this
            /// pointer.</param>
            /// <param name="CampaignName">Supplies the campaign name.</param>
            /// <param name="VarName">Supplies the variable name.</param>
            /// <param name="PlayerName">Supplies the player name.</param>
            /// <param name="Cls">Always supplies the value 'O'.</param>
            /// <param name="Data">Supplies the raw GFF buffer.</param>
            /// <param name="Size">Supplies the count of raw GFF bytes in the
            /// data buffer.</param>
            /// <returns>True if the object was stored, else false if the
            /// object was not stored.
            [UnmanagedFunctionPointer(CallingConvention.ThisCall, SetLastError = true)]
            private delegate Int32 CCodeBase_AddBinaryData(IntPtr CodeBaseObject, IntPtr CampaignName, IntPtr VarName, IntPtr PlayerName, Byte Cls, IntPtr Data, UInt32 Size);

            /// <summary>
            /// Unmanaged function pointer delegate for the GetBinaryData hook.
            /// </summary>
            private CCodeBase_GetBinaryData CCodeBase_GetBinaryData_HookDelegate;

            /// <summary>
            /// Unmanaged function pointer delegate for the AddBinaryData hook.
            /// </summary>
            private CCodeBase_AddBinaryData CCodeBase_AddBinaryData_HookDelegate;

            /// <summary>
            /// Unmanaged function pointer delegate for the GetBinaryData
            /// original function implementation.
            /// </summary>
            private CCodeBase_GetBinaryData CCodeBase_GetBinaryData_OriginalDelegate;

            /// <summary>
            /// Unmanaged function pointer delegate for the AddBinaryData
            /// original function implementation.
            /// </summary>
            private CCodeBase_AddBinaryData CCodeBase_AddBinaryData_OriginalDelegate;

        }

        /// <summary>
        /// The underlying hook object.
        /// </summary>
        private static CampaignDatabaseHook Hook = new CampaignDatabaseHook();

        /// <summary>
        /// Event arguments for StoreCampaignDatabase hooks.
        /// </summary>
        public class StoreCampaignDatabaseEventArgs : EventArgs
        {
            /// <summary>
            /// Create a store campaign database event arguments object.
            /// </summary>
            /// <param name="CampaignName">Supplies the campaign name suffix.
            /// </param>
            /// <param name="VarName">Supplies the campaign variable
            /// name.</param>
            /// <param name="PlayerName">Optionally supplies the player name.
            /// </param>
            /// <param name="GFF">Supplies the raw GFF data.</param>
            public StoreCampaignDatabaseEventArgs(string CampaignName, string VarName, string PlayerName, byte[] GFF)
            {
                this.CampaignNameInt = CampaignName;
                this.VarNameInt = VarName;
                this.PlayerNameInt = PlayerName;
                this.GFFInt = GFF;
            }

            private string CampaignNameInt;
            private string VarNameInt;
            private string PlayerNameInt;
            private byte[] GFFInt;

            /// <summary>
            /// The suffix of the campaign name (after VirtualDatabase).
            /// </summary>
            public string CampaignName { get { return CampaignNameInt; } }

            /// <summary>
            /// Get the variable name argument from the request.
            /// </summary>
            public string VarName { get { return VarNameInt; } }

            /// <summary>
            /// Get the player name (if a player object was provided) from the
            /// request.
            /// </summary>
            public string PlayerName { get { return PlayerNameInt; } }

            /// <summary>
            /// Get the raw GFF data from the request.
            /// </summary>
            public byte[] GFF { get { return GFFInt; } }

            /// <summary>
            /// True if at least one event handler handled the request.  This
            /// value controls the ultimate return value to script code from
            /// the call to StoreCampaignObject().
            /// </summary>
            public bool Handled { get; set; }
        }

        /// <summary>
        /// Event registration for StoreCampaignObject("VirtualDatabase", ...).
        /// </summary>
        public static event EventHandler<StoreCampaignDatabaseEventArgs> StoreCampaignDatabaseEvent;

        /// <summary>
        /// Event arguments for RetrieveCampaignDatabase hooks.
        /// </summary>
        public class RetrieveCampaignDatabaseEventArgs : EventArgs
        {
            /// <summary>
            /// Create a retrieve campaign database event arguments object.
            /// </summary>
            /// <param name="CampaignName">Supplies the campaign name.
            /// </param>
            /// <param name="VarName">Supplies the campaign variable
            /// name.</param>
            /// <param name="PlayerName">Optionally supplies the player name.
            /// </param>
            public RetrieveCampaignDatabaseEventArgs(string CampaignName, string VarName, string PlayerName)
            {
                this.CampaignNameInt = CampaignName;
                this.VarNameInt = VarName;
                this.PlayerNameInt = PlayerName;
            }

            private string CampaignNameInt;
            private string VarNameInt;
            private string PlayerNameInt;

            /// <summary>
            /// The suffix of the campaign name (after VirtualDatabase).
            /// </summary>
            public string CampaignName { get { return CampaignNameInt; } }

            /// <summary>
            /// Get the variable name argument from the request.
            /// </summary>
            public string VarName { get { return VarNameInt; } }

            /// <summary>
            /// Get the player name (if a player object was provided) from the
            /// request.
            /// </summary>
            public string PlayerName { get { return PlayerNameInt; } }

            /// <summary>
            /// Set the raw GFF data from the request.  The value is initially
            /// null if no handler has supplied a GFF to instantiate.  If a
            /// handler desires to instantiate a GFF, it should supply a raw
            /// GFF byte array in this member.
            /// </summary>
            public byte[] GFF { get; set; }
        }

        /// <summary>
        /// Event registration for
        /// RetrieveCampaignObject("VirtualDatabase", ...);
        /// </summary>
        public static event EventHandler<RetrieveCampaignDatabaseEventArgs> RetrieveCampaignDatabaseEvent;
    }
}
