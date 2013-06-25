using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;

namespace ALFA.Shared
{
    /// <summary>
    /// This class supports low level interoperability with NWN2Server.exe.
    /// It is not portable.
    /// </summary>
    internal static class ServerInterop
    {
        /// <summary>
        /// Allocate unmanaged memory on the server heap.  The caller is
        /// responsible for freeing the memory.
        /// </summary>
        /// <param name="Size">Supplies the allocation size.</param>
        /// <returns>The new allocation.</returns>
        internal static IntPtr AllocateServerHeap(UInt32 Size)
        {
            IntPtr HeapMgr = NWN2_HeapMgr_Instance();
            IntPtr Heap = NWN2_HeapMgr_GetDefaultHeap(HeapMgr);
            IntPtr P;

            P = NWN2_Heap_Allocate(Heap, Size);

            if (P == IntPtr.Zero)
                throw new OutOfMemoryException();
            else
                return P;
        }

        /// <summary>
        /// Free unmanaged memory to the server heap (allocated by the server
        /// internally or by AllocateServerHeap()).
        /// </summary>
        /// <param name="P">Supplies the memory block to free.</param>
        internal static void FreeServerHeap(IntPtr P)
        {
            IntPtr HeapMgr = NWN2_HeapMgr_Instance();
            IntPtr Heap = NWN2_HeapMgr_GetDefaultHeap(HeapMgr);

            NWN2_Heap_Deallocate(Heap, P);
        }

        //
        // Heap manager imports.
        //

        [DllImport("NWN2_MemoryMgr.dll", EntryPoint = "?Instance@NWN2_HeapMgr@@SAPAV1@XZ", SetLastError = false, CallingConvention = CallingConvention.StdCall)]
        internal static extern IntPtr NWN2_HeapMgr_Instance();

        [DllImport("NWN2_MemoryMgr.dll", EntryPoint = "?GetDefaultHeap@NWN2_HeapMgr@@QAEPAVNWN2_Heap@@XZ", SetLastError = false, CallingConvention = CallingConvention.ThisCall)]
        internal static extern IntPtr NWN2_HeapMgr_GetDefaultHeap(IntPtr HeapMgr);

        [DllImport("NWN2_MemoryMgr.dll", EntryPoint = "?Allocate@NWN2_Heap@@QAEPAXI@Z", SetLastError = false, CallingConvention = CallingConvention.ThisCall)]
        internal static extern IntPtr NWN2_Heap_Allocate(IntPtr Heap, UInt32 Size);

        [DllImport("NWN2_MemoryMgr.dll", EntryPoint = "?Deallocate@NWN2_Heap@@SAXPAX@Z", SetLastError = false, CallingConvention = CallingConvention.ThisCall)]
        internal static extern IntPtr NWN2_Heap_Deallocate(IntPtr Heap, IntPtr P);

        //
        // String class.
        //

        [StructLayout(LayoutKind.Sequential)]
        internal struct CExoString
        {
            private IntPtr CharPtr;
            private UInt32 Length;

            /// <summary>
            /// Get a standard string representation of the CExoString.
            /// </summary>
            /// <returns>The standard representation of the string.</returns>
            public override string ToString()
            {
                if (Length == 0)
                    return String.Empty;

                byte[] Bytes = new byte[Length - 1];
                Marshal.Copy(CharPtr, Bytes, 0, (int)(Length - 1));

                return Encoding.UTF8.GetString(Bytes);
            }
        };


        /// <summary>
        /// Read a CExoString from an arbitrary virtual address and return
        /// a CLR string representation of it.
        /// </summary>
        /// <param name="Offset">Supplies the offset of the CExoString
        /// object.</param>
        /// <returns>The CLR string representation.</returns>
        internal static string ReadCExoString(IntPtr Offset)
        {
            if (Offset == IntPtr.Zero)
                return String.Empty;

            CExoString ExoStr = (CExoString)Marshal.PtrToStructure(Offset, typeof(CExoString));
            return ExoStr.ToString();
        }

        //
        // Code base (campaign database) support.
        //

        internal static IntPtr CCodeBase_GetBinaryData_Call = new IntPtr(0x6A4E74);
        internal static IntPtr CCodeBase_AddBinaryData_Call = new IntPtr(0x6B2A49);
   }
}
