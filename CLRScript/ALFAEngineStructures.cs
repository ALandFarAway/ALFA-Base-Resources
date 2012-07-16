//
// This module contains support for operating with game-defined data
// structures.  The contents of this module are highly version pecific.
// 

using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Runtime.InteropServices;
using System.Reflection;
using System.Reflection.Emit;
using NWScript;
using NWScript.ManagedInterfaceLayer.NWScriptManagedInterface;
using CLRScriptFramework;

using NWEffect = NWScript.NWScriptEngineStructure0;
using NWEvent = NWScript.NWScriptEngineStructure1;
using NWLocation = NWScript.NWScriptEngineStructure2;
using NWTalent = NWScript.NWScriptEngineStructure3;
using NWItemProperty = NWScript.NWScriptEngineStructure4;


namespace ALFA
{

    /// <summary>
    /// This class encapsulates a wrapper for the native game effect object.
    /// </summary>
    public class GameEffect
    {
        /// <summary>
        /// Obtain a CGameEffect wrapper for an NWEffect instance.
        /// </summary>
        /// <param name="EffectInstance">Supplies the instance to wrap.</param>
        public GameEffect(NWEffect EffectInstance)
        {
            this.EffectInstance = EffectInstance;
            this.CGameEffectInstance = GetGameEffectInstance(EffectInstance);

            ReadGameEffectFields();
        }

        /// <summary>
        /// The internal type of the effect.  Note that the type encoding of
        /// the internal type is not the same as the set of NWScript effect
        /// type constants.
        /// </summary>
        public GameEffectType EffectType
        {
            get { return EffectTypeRead; }
        }


        /// <summary>
        /// Obtain data from the internal CGameEffect object.
        /// </summary>
        private void ReadGameEffectFields()
        {
            CGameEffectInternal EffectStructure = (CGameEffectInternal)Marshal.PtrToStructure(CGameEffectInstance, typeof(CGameEffectInternal));

            EffectTypeRead = (GameEffectType) EffectStructure.m_nType;
        }

        /// <summary>
        /// Obtain the internal CGameEffect object for this NWEffect instance.
        /// </summary>
        /// <param name="Effect">Supplies the effect instance to obtain the
        /// internal instance pointer for.</param>
        /// <returns></returns>
        private static IntPtr GetGameEffectInstance(NWEffect Effect)
        {
            //
            // Obtain the SharedPtr<EngineStructure> pointer from the NWEffect
            // wrapper (and underlying NWScriptEngineStructure).
            //

            IntPtr EngineStructurePtr = (IntPtr)ObtainGetEngineStructurePtr(Effect)(Effect.m_EngineStructure);

            //
            // Read SharedPtr<EngineStructure>.T, obtaining the
            // NWScript Accelerator's EngineStructureBridge pointer.
            //

            IntPtr EngineStructureBridgePtr = (IntPtr)Marshal.ReadIntPtr(EngineStructurePtr, Marshal.SizeOf(typeof(IntPtr)));

            //
            // Read EngineStructureBridge.m_Representation, obtaining the
            // CGameEffect instance.
            //
            // void * __VFN_table;
            // int m_EngineStructureType;
            // CNWVirtualMachineCmdImplementer * m_CmdImplementer;
            // void * m_Representation;
            //

            IntPtr GameEffectInstance = (IntPtr)Marshal.ReadIntPtr(EngineStructureBridgePtr, Marshal.SizeOf(typeof(IntPtr)) + sizeof(int) + Marshal.SizeOf(typeof(IntPtr)));

            return GameEffectInstance;
        }

        /// <summary>
        /// Obtain a function that can be used to read the m_EngineStructure
        /// field out of a NWScriptEngineStructure.  A dynamically emitted
        /// method is required as the necessary operations cannot be expressed
        /// in C# but must be implemented instead in raw MSIL.
        /// </summary>
        /// <param name="Effect">Supplies a template NWEffect object to obtain
        /// type information from.</param>
        /// <returns>The method delegate to invoke.</returns>
        private static GetEngineStructurePtrDelegate ObtainGetEngineStructurePtr(NWEffect Effect)
        {
            if (GetEngineStructurePtr != null)
                return GetEngineStructurePtr;

            //
            // Traverse the NWNScriptJITIntrinsics wrapper and obtain the
            // internal mixed mode NWScriptEngineStructure type.  This type
            // contains a pointer to the native C++ object chain that may be
            // traversed to obtain the underlying CGameEffect.
            //
            // N.B.  Accessing a native pointer type located on a type in a
            //       non-directly-referenceable assembly cannot be performed
            //       via conventional language-accessible methods or via
            //       reflection.  Instead, MSIL code must be generated to
            //       perform the requisite field access and cast to IntPtr.
            //

            Type NWEngineStructureType = Effect.m_EngineStructure.GetType();
            FieldInfo EngineStructurePtrField = NWEngineStructureType.GetField("m_EngineStructure", BindingFlags.Public | BindingFlags.Instance);
            DynamicMethod Method = new DynamicMethod("GetEngineStructurePtr", typeof(IntPtr), new Type[] { typeof(object) }, NWEngineStructureType, true);
            ILGenerator ILGen = Method.GetILGenerator();

            ILGen.Emit(OpCodes.Ldarg_0);
            ILGen.Emit(OpCodes.Castclass, NWEngineStructureType);
            ILGen.Emit(OpCodes.Ldfld, EngineStructurePtrField);
            ILGen.Emit(OpCodes.Ret);

            GetEngineStructurePtr = (GetEngineStructurePtrDelegate)Method.CreateDelegate(typeof(GetEngineStructurePtrDelegate));

            return GetEngineStructurePtr;
        }

        /// <summary>
        /// The delegate type for the dynamically emitted
        /// GetEngineStructurePtr method.
        /// </summary>
        /// <param name="EngineStructure">The engine structure.</param>
        /// <returns>The native m_EngineStructure field value.</returns>
        private delegate IntPtr GetEngineStructurePtrDelegate(object EngineStructure);

        /// <summary>
        /// The cached GetEngineStructurePtr delegate.
        /// </summary>
        private static GetEngineStructurePtrDelegate GetEngineStructurePtr = null;
        
        /// <summary>
        /// The underlying NWEffect object.
        /// </summary>
        private NWEffect EffectInstance;

        /// <summary>
        /// The game's CGameEffect instance that is wrapped by the NWEffect.
        /// </summary>
        private IntPtr CGameEffectInstance;

        /// <summary>
        /// The EffectType read from the internal effect structure.
        /// </summary>
        private GameEffectType EffectTypeRead;

        [StructLayout(LayoutKind.Sequential)]
        private struct CGameEffectInternal
        {
            public UInt64 m_nID;                 // +0x00
            public Int32 m_nType;                // +0x08
            public UInt16 m_nSubType;            // +0x0C
            public Single m_fDuration;           // +0x10
            public UInt32 m_nExpiryCalendarDay;  // +0x14
            public UInt32 m_nExpiryTimeOfDay;    // +0x18
            public UInt32 m_oidCreator;          // +0x1C
            public UInt32 m_nSpellId;            // +0x20
            public Int32 m_bExpose;              // +0x24
            public Int32 m_bShowIcon;            // +0x28
            public Int32 m_nCasterLevel;         // +0x2C
            public IntPtr m_pLinkLeft;           // +0x30 (CGameEffect *)
            public IntPtr m_pLinkRight;          // +0x34 (CGameEffect *)
            public Int32 m_nNumIntegers;         // +0x38
            public Int32 m_nNumFloats;           // +0x3C
            public IntPtr m_nParamInteger;       // +0x40 (Int32 *)
            public IntPtr m_nParamFloat;         // +0x44 (Single *)

            //
            // Remains:  m_sParamString[6] (CExoString, 0x8 bytes per element)
            //           m_oidParamObjectID[4] (OBJECTID)
            //           m_pScriptSituations[4] (CVirtualMachineScript *)
            //           m_bSkipOnLoad (Int32)
            //
        }

    }

    /// <summary>
    /// Internal type numbers for CGameEffect objects.
    /// </summary>
    public enum GameEffectType : int
    {
        EFFECT_NWN2SEFFILE = 0x62
    }
}

