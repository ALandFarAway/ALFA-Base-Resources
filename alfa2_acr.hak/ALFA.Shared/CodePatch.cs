using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;

namespace ALFA.Shared
{
    /// <summary>
    /// This patch encapsulates a code patch.
    /// </summary>
    internal class CodePatch : IDisposable
    {
        /// <summary>
        /// Create a generalized code patch.
        /// </summary>
        /// <param name="PatchOffset">Supplies the patch offset.</param>
        /// <param name="Code">Supplies the new code.</param>
        public CodePatch(IntPtr PatchOffset, byte[] Code)
        {
            this.PatchOffset = PatchOffset;

            OldCode = PatchCode(PatchOffset, Code);
        }

        /// <summary>
        /// Create a code patch to change a function pointer.
        /// </summary>
        /// <param name="PatchOffset">Supplies the patch offset.</param>
        /// <param name="ReplacementFunction">Supplies the replacement code
        /// pointer.</param>
        /// <param name="Relative">Supplies true if the patch is relative.
        /// </param>
        public CodePatch(IntPtr PatchOffset, IntPtr ReplacementFunction, bool Relative)
        {
            byte[] Code = new byte[4];
            UInt32 Replacement;

            this.PatchOffset = PatchOffset;

            if (Relative)
                Replacement = (UInt32)ReplacementFunction - (UInt32)PatchOffset - 4;
            else
                Replacement = (UInt32)ReplacementFunction;

            Code[0] = (byte)(Replacement >> 0);
            Code[1] = (byte)(Replacement >> 8);
            Code[2] = (byte)(Replacement >> 16);
            Code[3] = (byte)(Replacement >> 24);

            OldCode = PatchCode(PatchOffset, Code);
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
            if (OldCode != null)
            {
                PatchCode(PatchOffset, OldCode);
                OldCode = null;
            }
        }

        /// <summary>
        /// The offset that the patch resides at.
        /// </summary>
        IntPtr PatchOffset;

        /// <summary>
        /// The old code for the patch.
        /// </summary>
        byte[] OldCode;

        //
        // Code patching imports and infrastructure.
        //

        [DllImport("kernel32.dll", SetLastError = false, CallingConvention = CallingConvention.StdCall)]
        private static extern IntPtr GetCurrentProcess();

        [DllImport("kernel32.dll", SetLastError = false, CallingConvention = CallingConvention.StdCall)]
        private static extern Int32 WriteProcessMemory(IntPtr Process, IntPtr BaseAddress, IntPtr Buffer, IntPtr Size, out IntPtr Written);

        /// <summary>
        /// Install a code patch and return the old code.
        /// </summary>
        /// <param name="Offset">Supplies the offset to install the code patch
        /// to.</param>
        /// <param name="Code">Supplies the new code.</param>
        /// <returns>The old code.</returns>
        internal static byte[] PatchCode(IntPtr Offset, byte[] Code)
        {
            byte[] OldCode = new byte[Code.Length];
            IntPtr Written;
            IntPtr CodeBuffer;

            //
            // Save a copy of the original code, allocate an intermediate
            // fixed bounce buffer, copy to the bounce buffer, and write the
            // new code in (WriteProcessMemory will manage reprotection as
            // required).
            //

            Marshal.Copy(Offset, OldCode, 0, OldCode.Length);

            CodeBuffer = Marshal.AllocHGlobal(Code.Length);
            try
            {
                Marshal.Copy(Code, 0, CodeBuffer, Code.Length);

                if (WriteProcessMemory(GetCurrentProcess(), Offset, CodeBuffer, new IntPtr(Code.Length), out Written) == 0 || (int)Written != Code.Length)
                {
                    throw new InvalidOperationException("Couldn't write process memory.");
                }
            }
            finally
            {
                Marshal.FreeHGlobal(CodeBuffer);
            }

            return OldCode;
        }
    }
}
