using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Runtime.InteropServices;
using System.Reflection;
using System.Reflection.Emit;
using NWScript;
using NWScript.ManagedInterfaceLayer.NWScriptManagedInterface;

using NWEffect = NWScript.NWScriptEngineStructure0;
using NWEvent = NWScript.NWScriptEngineStructure1;
using NWLocation = NWScript.NWScriptEngineStructure2;
using NWTalent = NWScript.NWScriptEngineStructure3;
using NWItemProperty = NWScript.NWScriptEngineStructure4;

namespace NWScript
{
    /// <summary>
    /// This attribute class tags a field as a "NWScript global", which is
    /// automatically saved and restored across script situation continuations.
    /// 
    /// Only fields that are of type Int32 ("int"), UInt32 ("object"),
    /// Single ("float"), or engine structure types, may be declared as
    /// NWScript globals.
    /// </summary>
    [System.AttributeUsage(System.AttributeTargets.Field)]
    public class NWScriptGlobal : System.Attribute
    {
        public NWScriptGlobal()
        {
        }
    }
}

namespace CLRScriptFramework
{

    public interface ICLRScriptImplementation
    {
        /// <summary>
        /// This helper function saves the value of all 'globals' to an object
        /// array for use with storing a saved state (e.g. a script situation).
        /// </summary>
        /// <returns>A list of global variables, to be restored by a future
        /// call to LoadScriptGlobals.</returns>
        object[] SaveScriptGlobals();

        /// <summary>
        /// This function represents the user's main script entrypoint symbol.
        /// </summary>
        /// <param name="ScriptParameters">Supplies the argument vector for the
        /// script.</param>
        /// <param name="DefaultReturnCode">Supplies the requested default
        /// return code if the script does not wish to specify a specific
        /// return code.</param>
        /// <returns></returns>
        Int32 ScriptMain([In] object[] ScriptParameters, [In] Int32 DefaultReturnCode);

        /// <summary>
        /// This routine is invoked when the script context is being cloned for
        /// the creation of a script situation.  Its purpose is to create a new
        /// SampleManagedNWScript object and transfer any state desired to the
        /// new script object.
        /// </summary>
        /// <returns>The cloned script object is returned.</returns>
        IGeneratedScriptProgram CloneScriptProgram();
    }

    /// <summary>
    /// This partial implementation of the sample script includes wrappers for
    /// the high level NWScript functions.  You should include the wrappers in
    /// your script object type.
    /// </summary>
    public partial class CLRScriptBase
    {

        /// <summary>
        /// The following field is the "self" constant for use within the
        /// script.
        /// </summary>
        public UInt32 OBJECT_SELF;

        /// <summary>
        /// The following constant is the "invalid" object id constant for use
        /// within the script.
        /// </summary>
        public const UInt32 OBJECT_INVALID = ManagedNWScript.OBJECT_INVALID;



        /// <summary>
        /// This datatype wraps the concept of an "action" datatype in NWScript, that
        /// is, a continued execution context.
        /// </summary>
        /// 
        public delegate void NWAction();

        /// <summary>
        /// This table is used to track pending action delegates for resume.
        /// It should not be used by user code.
        /// </summary>
        protected static Dictionary<UInt32, NWAction> ActionDelegateTable = new Dictionary<UInt32, NWAction>();

        /// <summary>
        /// This variable tracks the next available resume method id for an
        /// action delegate.  It should not be used by user code.
        /// </summary>
        protected static UInt32 NextActionDelegateId = 0;


        /// <summary>
        /// The ManagedNWScript object represents the high level script API
        /// that is used to interface with the host program.
        /// </summary>
        public ManagedNWScript ScriptHost;

        /// <summary>
        /// The following list describes the set of 'global variables' that are
        /// automatically saved and restored across script situations.
        /// </summary>
        protected static List<FieldInfo> GlobalFields;

        /// <summary>
        /// The following script program object can optionally be set to
        /// delegate unrecognized script situation ids.  This capability can be
        /// useful if, for example, we want to call a NWScript script that sets
        /// up its own script situations.  In that case, we would need to be
        /// able to dispatch those script situation resumes on the right script
        /// object.
        /// </summary>
        public IGeneratedScriptProgram DelegateScriptObject = null;

        /// <summary>
        /// This routine sets up a saved script situation for a store state
        /// request.
        /// </summary>
        /// <param name="Action">Supplies the action delegate to save for later
        /// execution.</param>
        protected void InternalSaveStateForAction(NWAction Action)
        {
            //
            // Insert the delegate into the resume method table.  The resume
            // method ID is used to look up the delegate when we are entered to
            // resume a script situation.
            //
            // Script situation IDs created by CLR script code always have the
            // top bit set.  Conversely, script situation IDs that are used by
            // JIT'd NWScript scripts don't have this bit set.  This allows the
            // resume dispatcher to distinguish between the two.
            //

            UInt32 ResumeMethodId = NextActionDelegateId++ | 0x80000000;

            ActionDelegateTable[ResumeMethodId] = Action;

            //
            // Now clone the script program, save off global variables, and
            // package the script program object's state into the VM stack for
            // later execution.
            //
            // No local variables are stored presently, as we use the CLR state
            // retained within the delegate object itself.  Note that this
            // precludes restoring a script situation from a saved game.
            //
            // N.B.  A non-zero resume PC must be set.  Otherwise, the NWScript
            //       runtime environment may not recognize that this is a
            //       resume from a script situation, versus an invocation at
            //       the entry point.
            //

            ICLRScriptImplementation ScriptImplementation = (ICLRScriptImplementation)this;

            ScriptHost.Host.Intrinsic_StoreState(ScriptImplementation.SaveScriptGlobals(), null, 1, ResumeMethodId, ScriptImplementation.CloneScriptProgram());
        }

        /// <summary>
        /// This routine is invoked to dispatch a script situation to its
        /// associated delegate.  It should be called from the main
        /// ExecuteScriptSituation handler.
        /// 
        /// Script situations dispatched via this method do NOT support loading
        /// of saved games!
        /// </summary>
        /// <param name="ScriptSituationId">Supplies the ScriptSituationId that
        /// was provided to the initial StoreState request, which is intended
        /// to uniquely identify the site within which the script situation was
        /// created.</param>
        /// <param name="Locals">Supplies an array of local variables that were
        /// provided to the initial StoreState request.  The locals may only
        /// include standard NWScript types (Int32, UInt32, Single, and engine
        /// structures).</param>
        /// <param name="ObjectSelf">Supplies the "OBJECT_SELF" object id of
        /// the object that the script is being executed over.  This may be the
        /// invalid object id (Script.OBJECT_INVALID) if no object is
        /// associated with the execute script request.</param>
        public void DispatchExecuteScriptSituation([In] UInt32 ScriptSituationId, [In] object[] Locals, [In] UInt32 ObjectSelf)
        {
            UInt32 OldOBJECT_SELF = OBJECT_SELF;

            //
            // If this was a script situation set up by CLR script code, run
            // the delegate.
            //

            if ((ScriptSituationId & 0x80000000) != 0)
            {
                //
                // Assign a new OBJECT_SELF temporarily, for the invocation, and
                // dispatch to the delegate.
                //

                try
                {
                    OBJECT_SELF = ObjectSelf;
                    ActionDelegateTable[ScriptSituationId].Invoke();
                }
                finally
                {
                    OBJECT_SELF = OldOBJECT_SELF;
                    ActionDelegateTable.Remove(ScriptSituationId);
                }
            }
            else if (DelegateScriptObject != null)
            {
                //
                // This is a script situation setup by NWScript code and we
                // have established a delegate script object (which is expected
                // to be a NWScript script object).  Dispatch the request on
                // the delegate script object.
                //

                DelegateScriptObject.ExecuteScriptSituation(ScriptSituationId, Locals, ObjectSelf);
            }
            else
            {
                throw new ApplicationException("Unable to dispatch script situation " + ScriptSituationId);
            }
        }

        /// <summary>
        /// This routine creates a default engine structure of type NWEffect.
        /// </summary>
        /// <returns>The default value engine structure is returned.</returns>
        public NWEffect GetDefaultNWEffect()
        {
            return ScriptHost.Intrinsics.Intrinsic_CreateEngineStructure0();
        }

        /// <summary>
        /// This routine compares two engine structures of type NWEffect for
        /// equality.
        /// </summary>
        /// <param name="Effect1">Supplies the first engine structure.</param>
        /// <param name="Effect2">Supplies the second engine structure.</param>
        /// <returns>The routine returns true of the engine structures are
        /// logically equal.</returns>
        public bool EqualNWEffects(NWEffect Effect1, NWEffect Effect2)
        {
            return ScriptHost.Intrinsics.Intrinsic_CompareEngineStructure0(Effect1, Effect2);
        }

        /// <summary>
        /// This routine creates a default engine structure of type NWEvent.
        /// </summary>
        /// <returns>The default value engine structure is returned.</returns>
        public NWEvent GetDefaultNWEvent()
        {
            return ScriptHost.Intrinsics.Intrinsic_CreateEngineStructure1();
        }

        /// <summary>
        /// This routine compares two engine structures of type NWEvent for
        /// equality.
        /// </summary>
        /// <param name="Effect1">Supplies the first engine structure.</param>
        /// <param name="Effect2">Supplies the second engine structure.</param>
        /// <returns>The routine returns true of the engine structures are
        /// logically equal.</returns>
        public bool EqualNWEvents(NWEvent Event1, NWEvent Event2)
        {
            return ScriptHost.Intrinsics.Intrinsic_CompareEngineStructure1(Event1, Event2);
        }

        /// <summary>
        /// This routine creates a default engine structure of type NWLocation.
        /// </summary>
        /// <returns>The default value engine structure is returned.</returns>
        public NWLocation GetDefaultNWLocation()
        {
            return ScriptHost.Intrinsics.Intrinsic_CreateEngineStructure2();
        }

        /// <summary>
        /// This routine compares two engine structures of type NWLocation for
        /// equality.
        /// </summary>
        /// <param name="Effect1">Supplies the first engine structure.</param>
        /// <param name="Effect2">Supplies the second engine structure.</param>
        /// <returns>The routine returns true of the engine structures are
        /// logically equal.</returns>
        public bool EqualNWLocations(NWLocation Location1, NWLocation Location2)
        {
            return ScriptHost.Intrinsics.Intrinsic_CompareEngineStructure2(Location1, Location2);
        }

        /// <summary>
        /// This routine creates a default engine structure of type NWTalent.
        /// </summary>
        /// <returns>The default value engine structure is returned.</returns>
        public NWTalent GetDefaultNWTalent()
        {
            return ScriptHost.Intrinsics.Intrinsic_CreateEngineStructure3();
        }

        /// <summary>
        /// This routine compares two engine structures of type NWTalent for
        /// equality.
        /// </summary>
        /// <param name="Effect1">Supplies the first engine structure.</param>
        /// <param name="Effect2">Supplies the second engine structure.</param>
        /// <returns>The routine returns true of the engine structures are
        /// logically equal.</returns>
        public bool EqualNWTalents(NWTalent Talent1, NWTalent Talent2)
        {
            return ScriptHost.Intrinsics.Intrinsic_CompareEngineStructure3(Talent1, Talent2);
        }

        /// <summary>
        /// This routine creates a default engine structure of type NWItemProperty.
        /// </summary>
        /// <returns>The default value engine structure is returned.</returns>
        public NWItemProperty GetDefaultNWItemProperty()
        {
            return ScriptHost.Intrinsics.Intrinsic_CreateEngineStructure4();
        }

        /// <summary>
        /// This routine compares two engine structures of type NWItemProperty
        /// for equality.
        /// </summary>
        /// <param name="Effect1">Supplies the first engine structure.</param>
        /// <param name="Effect2">Supplies the second engine structure.</param>
        /// <returns>The routine returns true of the engine structures are
        /// logically equal.</returns>
        public bool EqualNWItemProperties(NWItemProperty ItemProperty1, NWItemProperty ItemProperty2)
        {
            return ScriptHost.Intrinsics.Intrinsic_CompareEngineStructure4(ItemProperty1, ItemProperty2);
        }

        /// <summary>
        /// This function is called from the user's constructor.  Its purpose
        /// is to initialize internal library support data.
        /// </summary>
        /// <param name="Intrinsics">Supplies the JIT intrinsics interface that
        /// is used to interface with various engine structure constructs.</param>
        /// <param name="Host">Supplies the JIT host program interface that is
        /// used to interface with the host program.</param>
        protected void InitScript(NWScriptJITIntrinsics Intrinsics, INWScriptProgram Host)
        {
            //
            // Create a managed script interface object and hand over control
            // of the host and intrinsics interfaces.
            //
            // Most operations should use the managed interface wrapper and not
            // the raw intrinsics or host object methods.
            //

            ScriptHost = new ManagedNWScript(Intrinsics, Host);

            //
            // Discover the list of global variables associated with the
            // script, and set default values for globals that cannot be null.
            //

            InitGlobals();

            //
            // Set the default OBJECT_SELF value up.
            //

            OBJECT_SELF = OBJECT_INVALID;
        }

        /// <summary>
        /// This function is called from the user's copy constructor.  Its
        /// purpose is to initialize internal library support data.
        /// </summary>
        /// <param name="Other>Supplies the instance to copy data from.</param>
        protected void InitScript(CLRScriptBase Other)
        {
            ScriptHost = Other.ScriptHost;
            OBJECT_SELF = Other.OBJECT_SELF;
            DelegateScriptObject = Other.DelegateScriptObject;
        }

        /// <summary>
        /// This provides an IEnumerator for areas present in a module.
        /// </summary>
        public class AreaEnumerator : IEnumerator<uint>
        {
            public AreaEnumerator(CLRScriptBase TheScript)
            {
                Script = TheScript;
                Reset();
            }

            public void Dispose() { }

            public bool MoveNext()
            {
                if (IsReset)
                    CurrentItem = Script.GetFirstArea();
                else
                    CurrentItem = Script.GetNextArea();

                IsReset = false;

                return CurrentItem != OBJECT_INVALID;
            }

            public void Reset()
            {
                IsReset = true;
            }

            public uint Current { get { return CurrentItem; } }

            object IEnumerator.Current { get { return CurrentItem; } }

            protected CLRScriptBase Script;
            protected bool IsReset = true;
            protected UInt32 CurrentItem;
        }

        public class AreaEnumeratorHelper : IEnumerable<uint>
        {
            public AreaEnumeratorHelper(CLRScriptBase TheScript)
            {
                Script = TheScript;
            }

            public IEnumerator<uint> GetEnumerator() { return new AreaEnumerator(Script); }
            IEnumerator IEnumerable.GetEnumerator() { return new AreaEnumerator(Script); }

            protected CLRScriptBase Script;
        }

        /// <summary>
        /// This routine returns an enumerator for areas in the module.
        /// </summary>
        /// <returns>The enumerator is returned.</returns>
        public AreaEnumeratorHelper GetAreas()
        {
            return new AreaEnumeratorHelper(this);
        }

        /// <summary>
        /// This provides an IEnumerator for players present.
        /// </summary>
        public class PlayerEnumerator : IEnumerator<uint>
        {
            public PlayerEnumerator(CLRScriptBase TheScript, bool IsOwnedCharacter)
            {
                Script = TheScript;
                OwnedCharacter = IsOwnedCharacter;
                Reset();
            }

            public void Dispose() { }

            public bool MoveNext()
            {
                if (IsReset)
                    CurrentItem = Script.GetFirstPC(OwnedCharacter ? TRUE : FALSE);
                else
                    CurrentItem = Script.GetNextPC(OwnedCharacter ? TRUE : FALSE);

                IsReset = false;

                return CurrentItem != OBJECT_INVALID;
            }

            public void Reset()
            {
                IsReset = true;
            }

            public uint Current { get { return CurrentItem; } }

            object IEnumerator.Current { get { return CurrentItem; } }

            protected CLRScriptBase Script;
            protected bool IsReset = true;
            protected bool OwnedCharacter;
            protected UInt32 CurrentItem;
        }

        public class PlayerEnumeratorHelper : IEnumerable<uint>
        {
            public PlayerEnumeratorHelper(CLRScriptBase TheScript, bool IsOwnedCharacter)
            {
                Script = TheScript;
                OwnedCharacter = IsOwnedCharacter;
            }

            public IEnumerator<uint> GetEnumerator() { return new PlayerEnumerator(Script, OwnedCharacter); }
            IEnumerator IEnumerable.GetEnumerator() { return new PlayerEnumerator(Script, OwnedCharacter); }

            protected CLRScriptBase Script;
            protected bool OwnedCharacter;
        }

        /// <summary>
        /// This routine returns an enumerator for players in the module.
        /// </summary>
        /// <param name="IsOwnedCharacter">Supplies true if owned characters
        /// should be returned instead of active characters.</param>
        /// <returns>The enumerator is returned.</returns>
        public PlayerEnumeratorHelper GetPlayers(bool IsOwnedCharacter)
        {
            return new PlayerEnumeratorHelper(this, IsOwnedCharacter);
        }

        /// <summary>
        /// This provides an IEnumerator for items present in a creature's inventory.
        /// </summary>
        public class InventoryItemEnumerator : IEnumerator<uint>
        {
            public InventoryItemEnumerator(uint ObjectId, CLRScriptBase TheScript)
            {
                Creature = ObjectId;
                Script = TheScript;
                Reset();
            }

            public void Dispose() { }

            public bool MoveNext()
            {
                if (IsReset)
                    CurrentItem = Script.GetFirstItemInInventory(Creature);
                else
                    CurrentItem = Script.GetNextItemInInventory(Creature);

                IsReset = false;

                return CurrentItem != OBJECT_INVALID;
            }

            public void Reset()
            {
                IsReset = true;
            }

            public uint Current { get { return CurrentItem; } }

            object IEnumerator.Current { get { return CurrentItem; } }

            protected CLRScriptBase Script;
            protected bool IsReset = true;
            protected UInt32 Creature;
            protected UInt32 CurrentItem;
        }

        public class InventoryItemEnumeratorHelper : IEnumerable<uint>
        {
            public InventoryItemEnumeratorHelper(uint ObjectId, CLRScriptBase TheScript)
            {
                Creature = ObjectId;
                Script = TheScript;
            }

            public IEnumerator<uint> GetEnumerator() { return new AreaObjectEnumerator(Creature, Script); }
            IEnumerator IEnumerable.GetEnumerator() { return new AreaObjectEnumerator(Creature, Script); }

            protected CLRScriptBase Script;
            protected UInt32 Creature;
        }

        /// <summary>
        /// This routine returns an enumerator for items in a creature's inventory.
        /// </summary>
        /// <param name="Creature">Supplies the creature's object ID.</param>
        /// <returns>The enumerator is returned.</returns>
        public InventoryItemEnumeratorHelper GetItemsInInventory(uint Creature)
        {
            return new InventoryItemEnumeratorHelper(Creature, this);
        }

        /// <summary>
        /// This provides an IEnumerator for objects present in an area.
        /// </summary>
        public class AreaObjectEnumerator : IEnumerator<uint>
        {
            public AreaObjectEnumerator(uint ObjectId, CLRScriptBase TheScript)
            {
                Area = ObjectId;
                Script = TheScript;
                Reset();
            }

            public void Dispose() { }

            public bool MoveNext()
            {
                if (IsReset)
                    CurrentItem = Script.GetFirstObjectInArea(Area);
                else
                    CurrentItem = Script.GetNextObjectInArea(Area);

                IsReset = false;

                return CurrentItem != OBJECT_INVALID;
            }

            public void Reset()
            {
                IsReset = true;
            }

            public uint Current { get { return CurrentItem; } }

            object IEnumerator.Current { get { return CurrentItem; } }

            protected CLRScriptBase Script;
            protected bool IsReset = true;
            protected UInt32 Area;
            protected UInt32 CurrentItem;
        }

        public class AreaObjectEnumeratorHelper : IEnumerable<uint>
        {
            public AreaObjectEnumeratorHelper(uint ObjectId, CLRScriptBase TheScript)
            {
                Area = ObjectId;
                Script = TheScript;
            }

            public IEnumerator<uint> GetEnumerator() { return new AreaObjectEnumerator(Area, Script); }
            IEnumerator IEnumerable.GetEnumerator() { return new AreaObjectEnumerator(Area, Script); }

            protected CLRScriptBase Script;
            protected UInt32 Area;
        }

        /// <summary>
        /// This routine returns an enumerator for objects in an area.
        /// </summary>
        /// <param name="AreaObject">Supplies the area object.</param>
        /// <returns>The enumerator is returned.</returns>
        public AreaObjectEnumeratorHelper GetObjectsInArea(uint AreaObject)
        {
            return new AreaObjectEnumeratorHelper(AreaObject, this);
        }

        /// <summary>
        /// This provides an IEnumerator for objects present in a container.
        /// </summary>
        public class ContainerObjectEnumerator : IEnumerator<uint>
        {
            public ContainerObjectEnumerator(uint ObjectId, CLRScriptBase TheScript)
            {
                Container = ObjectId;
                Script = TheScript;
                Reset();
            }

            public void Dispose() { }

            public bool MoveNext()
            {
                if (IsReset)
                    CurrentItem = Script.GetFirstItemInInventory(Container);
                else
                    CurrentItem = Script.GetNextItemInInventory(Container);

                IsReset = false;

                return CurrentItem != OBJECT_INVALID;
            }

            public void Reset()
            {
                IsReset = true;
            }

            public uint Current { get { return CurrentItem; } }

            object IEnumerator.Current { get { return CurrentItem; } }

            protected CLRScriptBase Script;
            protected bool IsReset = true;
            protected UInt32 Container;
            protected UInt32 CurrentItem;
        }

        public class ContainerObjectEnumeratorHelper : IEnumerable<uint>
        {
            public ContainerObjectEnumeratorHelper(uint ObjectId, CLRScriptBase TheScript)
            {
                Container = ObjectId;
                Script = TheScript;
            }

            public IEnumerator<uint> GetEnumerator() { return new ContainerObjectEnumerator(Container, Script); }
            IEnumerator IEnumerable.GetEnumerator() { return new ContainerObjectEnumerator(Container, Script); }

            protected CLRScriptBase Script;
            protected UInt32 Container;
        }

        /// <summary>
        /// This routine returns an enumerator for objects in a container.
        /// </summary>
        /// <returns>The enumerator is returned.</returns>
        public ContainerObjectEnumeratorHelper GetObjectsInContainer(uint ContainerObject)
        {
            return new ContainerObjectEnumeratorHelper(ContainerObject, this);
        }

        /// <summary>
        /// This provides an IEnumerator for objects present in a faction.
        /// </summary>
        public class FactionObjectEnumerator : IEnumerator<uint>
        {
            public FactionObjectEnumerator(uint ObjectId, bool IsPCOnly, CLRScriptBase TheScript)
            {
                FactionMember = ObjectId;
                PCOnly = IsPCOnly;
                Script = TheScript;
                Reset();
            }

            public void Dispose() { }

            public bool MoveNext()
            {
                if (IsReset)
                    CurrentItem = Script.GetFirstFactionMember(FactionMember, PCOnly ? TRUE : FALSE);
                else
                    CurrentItem = Script.GetNextFactionMember(FactionMember, PCOnly ? TRUE : FALSE);

                IsReset = false;

                return CurrentItem != OBJECT_INVALID;
            }

            public void Reset()
            {
                IsReset = true;
            }

            public uint Current { get { return CurrentItem; } }

            object IEnumerator.Current { get { return CurrentItem; } }

            protected CLRScriptBase Script;
            protected bool IsReset = true;
            protected UInt32 FactionMember;
            protected bool PCOnly;
            protected UInt32 CurrentItem;
        }

        public class FactionObjectEnumeratorHelper : IEnumerable<uint>
        {
            public FactionObjectEnumeratorHelper(uint ObjectId, bool IsPCOnly, CLRScriptBase TheScript)
            {
                FactionMember = ObjectId;
                PCOnly = IsPCOnly;
                Script = TheScript;
            }

            public IEnumerator<uint> GetEnumerator() { return new FactionObjectEnumerator(FactionMember, PCOnly, Script); }
            IEnumerator IEnumerable.GetEnumerator() { return new FactionObjectEnumerator(FactionMember, PCOnly, Script); }

            protected CLRScriptBase Script;
            protected UInt32 FactionMember;
            protected bool PCOnly;
        }

        /// <summary>
        /// This routine returns an enumerator for objects in a faction.
        /// </summary>
        /// <param name="FactionMember">Supplies a member of the faction to
        /// enumerate.</param>
        /// <param name="PCOnly">Supplies true if only PCs are to be returned.</param>
        /// <returns>The enumerator is returned.</returns>
        public FactionObjectEnumeratorHelper GetObjectsInFaction(uint FactionMember, bool PCOnly)
        {
            return new FactionObjectEnumeratorHelper(FactionMember, PCOnly, this);
        }

        /// <summary>
        /// This provides an IEnumerator for subareas overlapping a position.
        /// </summary>
        public class AreaSubAreaEnumerator : IEnumerator<uint>
        {
            public AreaSubAreaEnumerator(uint ObjectId, Vector3 ThePosition, CLRScriptBase TheScript)
            {
                Area = ObjectId;
                Position = ThePosition;
                Script = TheScript;
                Reset();
            }

            public void Dispose() { }

            public bool MoveNext()
            {
                if (IsReset)
                    CurrentItem = Script.GetFirstSubArea(Area, Position);
                else
                    CurrentItem = Script.GetNextSubArea(Area);

                IsReset = false;

                return CurrentItem != OBJECT_INVALID;
            }

            public void Reset()
            {
                IsReset = true;
            }

            public uint Current { get { return CurrentItem; } }

            object IEnumerator.Current { get { return CurrentItem; } }

            protected CLRScriptBase Script;
            protected bool IsReset = true;
            protected UInt32 Area;
            protected Vector3 Position;
            protected UInt32 CurrentItem;
        }

        public class AreaSubAreaEnumeratorHelper : IEnumerable<uint>
        {
            public AreaSubAreaEnumeratorHelper(uint ObjectId, Vector3 ThePosition, CLRScriptBase TheScript)
            {
                Area = ObjectId;
                Position = ThePosition;
                Script = TheScript;
            }

            public IEnumerator<uint> GetEnumerator() { return new AreaSubAreaEnumerator(Area, Position, Script); }
            IEnumerator IEnumerable.GetEnumerator() { return new AreaSubAreaEnumerator(Area, Position, Script); }

            protected CLRScriptBase Script;
            protected UInt32 Area;
            protected Vector3 Position;
        }

        /// <summary>
        /// This routine routines an enumerator for subareas overlapping a
        /// position.
        /// </summary>
        /// <param name="AreaObject">Supplies the area object.</param>
        /// <param name="Position">Supplies the position in the area to
        /// enumerate overlapping subareas of.</param>
        /// <returns>The enumerator is returned.</returns>
        public AreaSubAreaEnumeratorHelper GetSubAreas(uint AreaObject, Vector3 Position)
        {
            return new AreaSubAreaEnumeratorHelper(AreaObject, Position, this);
        }

        /// <summary>
        /// This provides an IEnumerator for objects in a persistent object.
        /// </summary>
        public class PersistentObjectEnumerator : IEnumerator<uint>
        {
            public PersistentObjectEnumerator(uint ObjectId, int TheResidentObjectType, int ThePersistentZone, CLRScriptBase TheScript)
            {
                PersistentObject = ObjectId;
                ResidentObjectType = TheResidentObjectType;
                PersistentZone = ThePersistentZone;
                Script = TheScript;
                Reset();
            }

            public void Dispose() { }

            public bool MoveNext()
            {
                if (IsReset)
                    CurrentItem = Script.GetFirstInPersistentObject(PersistentObject, ResidentObjectType, PersistentZone);
                else
                    CurrentItem = Script.GetNextInPersistentObject(PersistentObject, ResidentObjectType, PersistentZone);

                IsReset = false;

                return CurrentItem != OBJECT_INVALID;
            }

            public void Reset()
            {
                IsReset = true;
            }

            public uint Current { get { return CurrentItem; } }

            object IEnumerator.Current { get { return CurrentItem; } }

            protected CLRScriptBase Script;
            protected bool IsReset = true;
            protected UInt32 PersistentObject;
            protected int ResidentObjectType;
            protected int PersistentZone;
            protected UInt32 CurrentItem;
        }

        public class PersistentObjectEnumeratorHelper : IEnumerable<uint>
        {
            public PersistentObjectEnumeratorHelper(uint ObjectId, int TheResidentObjectType, int ThePersistentZone, CLRScriptBase TheScript)
            {
                PersistentObject = ObjectId;
                ResidentObjectType = TheResidentObjectType;
                PersistentZone = ThePersistentZone;
                Script = TheScript;
            }

            public IEnumerator<uint> GetEnumerator() { return new PersistentObjectEnumerator(PersistentObject, ResidentObjectType, PersistentZone, Script); }
            IEnumerator IEnumerable.GetEnumerator() { return new PersistentObjectEnumerator(PersistentObject, ResidentObjectType, PersistentZone, Script); }

            protected CLRScriptBase Script;
            protected UInt32 PersistentObject;
            protected int ResidentObjectType;
            protected int PersistentZone;
        }

        /// <summary>
        /// This routine routines an enumerator for objects in a persistent
        /// object.
        /// </summary>
        /// <param name="PersistentObject">Supplies the persistent object.</param>
        /// <param name="ResidentObjectType">Supplies the object type(s) to
        /// query.</param>
        /// <param name="PersistentZone">Supplies the persistent zone
        /// (PERSISTENT_ZONE_ACTIVE, PERSISTENT_ZONE_FOLLOW).</param>
        /// <returns>The enumerator is returned.</returns>
        public PersistentObjectEnumeratorHelper GetObjectsInPersistentObject(uint PersistentObject, int ResidentObjectType, int PersistentZone)
        {
            return new PersistentObjectEnumeratorHelper(PersistentObject, ResidentObjectType, PersistentZone, this);
        }

        /// <summary>
        /// This provides an IEnumerator for objects in a shape.
        /// </summary>
        public class ObjectInShapeEnumerator : IEnumerator<uint>
        {
            public ObjectInShapeEnumerator(int TheShape, float TheSize, NWLocation TheLocation, bool IsLineOfSight, int TheObjectFilter, Vector3 TheOrigin, CLRScriptBase TheScript)
            {
                Shape = TheShape;
                Size = TheSize;
                Location = TheLocation;
                LineOfSight = IsLineOfSight;
                ObjectFilter = TheObjectFilter;
                Origin = TheOrigin;
                Script = TheScript;
                Reset();
            }

            public void Dispose() { }

            public bool MoveNext()
            {
                if (IsReset)
                    CurrentItem = Script.GetFirstObjectInShape(Shape, Size, Location, LineOfSight ? TRUE : FALSE, ObjectFilter, Origin);
                else
                    CurrentItem = Script.GetNextObjectInShape(Shape, Size, Location, LineOfSight ? TRUE : FALSE, ObjectFilter, Origin);

                IsReset = false;

                return CurrentItem != OBJECT_INVALID;
            }

            public void Reset()
            {
                IsReset = true;
            }

            public uint Current { get { return CurrentItem; } }

            object IEnumerator.Current { get { return CurrentItem; } }

            protected CLRScriptBase Script;
            protected bool IsReset = true;
            protected int Shape;
            protected float Size;
            protected NWLocation Location;
            protected bool LineOfSight;
            protected int ObjectFilter;
            protected Vector3 Origin;
            protected UInt32 CurrentItem;
        }
        
        public class ObjectInShapeEnumeratorHelper : IEnumerable<uint>
        {
            public ObjectInShapeEnumeratorHelper(int TheShape, float TheSize, NWLocation TheLocation, bool IsLineOfSight, int TheObjectFilter, Vector3 TheOrigin, CLRScriptBase TheScript)
            {
                Shape = TheShape;
                Size = TheSize;
                Location = TheLocation;
                LineOfSight = IsLineOfSight;
                ObjectFilter = TheObjectFilter;
                Origin = TheOrigin;
                Script = TheScript;
            }

            public IEnumerator<uint> GetEnumerator() { return new ObjectInShapeEnumerator(Shape, Size, Location, LineOfSight, ObjectFilter, Origin, Script); }
            IEnumerator IEnumerable.GetEnumerator() { return new ObjectInShapeEnumerator(Shape, Size, Location, LineOfSight, ObjectFilter, Origin, Script); }

            protected CLRScriptBase Script;
            protected int Shape;
            protected float Size;
            protected NWLocation Location;
            protected bool LineOfSight;
            protected int ObjectFilter;
            protected Vector3 Origin;
        }

        /// <summary>
        /// This routine routines an enumerator for objects in a shape.
        /// </summary>
        /// <param name="Shape">Supplies the shape (SHAPE_*).</param>
        /// <param name="Size">Supplies the size of the shape.</param>
        /// <param name="Location">Supplies the location of the shape.</param>
        /// <param name="LineOfSight">Supplies true if only line of sight from
        /// OBJECT_SELF is to be considered.</param>
        /// <param name="ObjectFilter">Supplies the object type filter mask.
        /// </param>
        /// <param name="Origin">Supplies the origin of the shape.</param>
        /// <returns>The enumerator is returned.</returns>
        public ObjectInShapeEnumeratorHelper GetObjectsInShape(int Shape, float Size, NWLocation Location, bool LineOfSight, int ObjectFilter, Vector3 Origin)
        {
            return new ObjectInShapeEnumeratorHelper(Shape, Size, Location, LineOfSight, ObjectFilter, Origin, this);
        }

        /// <summary>
        /// This provides an IEnumerator for effects attached to an object.
        /// </summary>
        public class ObjectEffectEnumerator : IEnumerator<NWEffect>
        {
            public ObjectEffectEnumerator(uint ObjectId, CLRScriptBase TheScript)
            {
                TheObject = ObjectId;
                Script = TheScript;
                Reset();
            }

            public void Dispose() { }

            public bool MoveNext()
            {
                if (IsReset)
                    CurrentItem = Script.GetFirstEffect(TheObject);
                else
                    CurrentItem = Script.GetNextEffect(TheObject);

                IsReset = false;

                return Script.GetIsEffectValid(CurrentItem) != FALSE;
            }

            public void Reset()
            {
                IsReset = true;
            }

            public NWEffect Current { get { return CurrentItem; } }

            object IEnumerator.Current { get { return CurrentItem; } }

            protected CLRScriptBase Script;
            protected bool IsReset = true;
            protected UInt32 TheObject;
            protected NWEffect CurrentItem;
        }

        public class ObjectEffectEnumeratorHelper : IEnumerable<NWEffect>
        {
            public ObjectEffectEnumeratorHelper(uint ObjectId, CLRScriptBase TheScript)
            {
                TheObject = ObjectId;
                Script = TheScript;
            }

            public IEnumerator<NWEffect> GetEnumerator() { return new ObjectEffectEnumerator(TheObject, Script); }
            IEnumerator IEnumerable.GetEnumerator() { return new ObjectEffectEnumerator(TheObject, Script); }

            protected CLRScriptBase Script;
            protected UInt32 TheObject;
        }

        /// <summary>
        /// This routine routines an enumerator for effects on an object.
        /// </summary>
        /// <param name="ObjectId">Supplies the object id to query.</param>
        /// <returns>The enumerator is returned.</returns>
        public ObjectEffectEnumeratorHelper GetObjectEffects(uint ObjectId)
        {
            return new ObjectEffectEnumeratorHelper(ObjectId, this);
        }

        /// <summary>
        /// This provides an IEnumerator for item properties attached to an
        /// object.
        /// </summary>
        public class ObjectItemPropertyEnumerator : IEnumerator<NWItemProperty>
        {
            public ObjectItemPropertyEnumerator(uint ObjectId, CLRScriptBase TheScript)
            {
                TheObject = ObjectId;
                Script = TheScript;
                Reset();
            }

            public void Dispose() { }

            public bool MoveNext()
            {
                if (IsReset)
                    CurrentItem = Script.GetFirstItemProperty(TheObject);
                else
                    CurrentItem = Script.GetNextItemProperty(TheObject);

                IsReset = false;

                return Script.GetIsItemPropertyValid(CurrentItem) != FALSE;
            }

            public void Reset()
            {
                IsReset = true;
            }

            public NWItemProperty Current { get { return CurrentItem; } }

            object IEnumerator.Current { get { return CurrentItem; } }

            protected CLRScriptBase Script;
            protected bool IsReset = true;
            protected UInt32 TheObject;
            protected NWItemProperty CurrentItem;
        }

        public class ObjectItemPropertyEnumeratorHelper : IEnumerable<NWItemProperty>
        {
            public ObjectItemPropertyEnumeratorHelper(uint ObjectId, CLRScriptBase TheScript)
            {
                TheObject = ObjectId;
                Script = TheScript;
            }

            public IEnumerator<NWItemProperty> GetEnumerator() { return new ObjectItemPropertyEnumerator(TheObject, Script); }
            IEnumerator IEnumerable.GetEnumerator() { return new ObjectItemPropertyEnumerator(TheObject, Script); }

            protected CLRScriptBase Script;
            protected UInt32 TheObject;
        }

        /// <summary>
        /// This routine routines an enumerator for item properties on an item.
        /// </summary>
        /// <param name="ItemObject">Supplies the item object to query.</param>
        /// <returns>The enumerator is returned.</returns>
        public ObjectItemPropertyEnumeratorHelper GetItemPropertiesOnItem(uint ItemObject)
        {
            return new ObjectItemPropertyEnumeratorHelper(ItemObject, this);
        }

        /// <summary>
        /// This provides an IEnumerator for entering players.
        /// </summary>
        public class EnteringPlayerEnumerator : IEnumerator<uint>
        {
            public EnteringPlayerEnumerator(CLRScriptBase TheScript)
            {
                Script = TheScript;
                Reset();
            }

            public void Dispose() { }

            public bool MoveNext()
            {
                if (IsReset)
                    CurrentItem = Script.GetFirstEnteringPC();
                else
                    CurrentItem = Script.GetNextEnteringPC();

                IsReset = false;

                return CurrentItem != OBJECT_INVALID;
            }

            public void Reset()
            {
                IsReset = true;
            }

            public uint Current { get { return CurrentItem; } }

            object IEnumerator.Current { get { return CurrentItem; } }

            protected CLRScriptBase Script;
            protected bool IsReset = true;
            protected UInt32 CurrentItem;
        }

        public class EnteringPlayerEnumeratorHelper : IEnumerable<uint>
        {
            public EnteringPlayerEnumeratorHelper(CLRScriptBase TheScript)
            {
                Script = TheScript;
            }

            public IEnumerator<uint> GetEnumerator() { return new EnteringPlayerEnumerator(Script); }
            IEnumerator IEnumerable.GetEnumerator() { return new EnteringPlayerEnumerator(Script); }

            protected CLRScriptBase Script;
        }

        /// <summary>
        /// This routine routines an enumerator for entering players.
        /// </summary>
        /// <returns>The enumerator is returned.</returns>
        public EnteringPlayerEnumeratorHelper GetEnteringPlayers()
        {
            return new EnteringPlayerEnumeratorHelper(this);
        }

        /// <summary>
        /// This provides an IEnumerator for roster members.
        /// </summary>
        public class RosterMemberEnumerator : IEnumerator<string>
        {
            public RosterMemberEnumerator(CLRScriptBase TheScript)
            {
                Script = TheScript;
                Reset();
            }

            public void Dispose() { }

            public bool MoveNext()
            {
                if (IsReset)
                    CurrentItem = Script.GetFirstRosterMember();
                else
                    CurrentItem = Script.GetNextRosterMember();

                IsReset = false;

                return CurrentItem != "";
            }

            public void Reset()
            {
                IsReset = true;
            }

            public string Current { get { return CurrentItem; } }

            object IEnumerator.Current { get { return CurrentItem; } }

            protected CLRScriptBase Script;
            protected bool IsReset = true;
            protected string CurrentItem;
        }

        public class RosterMemberEnumeratorHelper : IEnumerable<string>
        {
            public RosterMemberEnumeratorHelper(CLRScriptBase TheScript)
            {
                Script = TheScript;
            }

            public IEnumerator<string> GetEnumerator() { return new RosterMemberEnumerator(Script); }
            IEnumerator IEnumerable.GetEnumerator() { return new RosterMemberEnumerator(Script); }

            protected CLRScriptBase Script;
        }

        /// <summary>
        /// This routine routines an enumerator for roster members.
        /// </summary>
        /// <returns>The enumerator is returned.</returns>
        public RosterMemberEnumeratorHelper GetRosterMembers()
        {
            return new RosterMemberEnumeratorHelper(this);
        }

        /// <summary>
        /// This function sets up global variable support.  It discovers a list
        /// of all fields that have been attributed with the [NWScriptGlobal]
        /// attribution on the current class.  Its purpose is to allow for
        /// automatic save and restore of these values across a script situation.
        /// </summary>
        protected void InitGlobals()
        {
            Type ThisType = GetType();
            bool CreateGlobalFields = true;

            if (GlobalFields == null)
                GlobalFields = new List<FieldInfo>();
            else
                CreateGlobalFields = false;

            foreach (FieldInfo Field in ThisType.GetFields(BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic))
            {
                if (Field.GetCustomAttributes(typeof(NWScriptGlobal), false).Length == 0)
                    continue;

                if (CreateGlobalFields)
                {
                    //
                    // Verify that a valid type was specified for all globals.
                    // If not, complain in the server log.
                    //

                    if (!IsValidNWScriptType(Field.FieldType))
                    {
                        WriteTimestampedLogEntry(String.Format("{0}.InitGlobals: {0}.{1} is has an invalid type ({2}) for a [NWScriptGlobal].", GetType().FullName, Field.Name, Field.FieldType.FullName));
                    }
                    else
                    {
                        GlobalFields.Add(Field);
                    }
                }

                //
                // Default initialize fields that may not be null.
                //

                if (Field.GetValue(this) != null)
                    continue;

                if (Field.FieldType == typeof(string))
                    Field.SetValue(this, "");
                else if (Field.FieldType == typeof(NWScriptEngineStructure0))
                    Field.SetValue(this, ScriptHost.Intrinsics.Intrinsic_CreateEngineStructure0());
                else if (Field.FieldType == typeof(NWScriptEngineStructure1))
                    Field.SetValue(this, ScriptHost.Intrinsics.Intrinsic_CreateEngineStructure1());
                else if (Field.FieldType == typeof(NWScriptEngineStructure2))
                    Field.SetValue(this, ScriptHost.Intrinsics.Intrinsic_CreateEngineStructure2());
                else if (Field.FieldType == typeof(NWScriptEngineStructure3))
                    Field.SetValue(this, ScriptHost.Intrinsics.Intrinsic_CreateEngineStructure3());
                else if (Field.FieldType == typeof(NWScriptEngineStructure4))
                    Field.SetValue(this, ScriptHost.Intrinsics.Intrinsic_CreateEngineStructure4());
                else if (Field.FieldType == typeof(NWScriptEngineStructure5))
                    Field.SetValue(this, ScriptHost.Intrinsics.Intrinsic_CreateEngineStructure5());
                else if (Field.FieldType == typeof(NWScriptEngineStructure6))
                    Field.SetValue(this, ScriptHost.Intrinsics.Intrinsic_CreateEngineStructure6());
                else if (Field.FieldType == typeof(NWScriptEngineStructure7))
                    Field.SetValue(this, ScriptHost.Intrinsics.Intrinsic_CreateEngineStructure7());
                else if (Field.FieldType == typeof(NWScriptEngineStructure8))
                    Field.SetValue(this, ScriptHost.Intrinsics.Intrinsic_CreateEngineStructure8());
                else if (Field.FieldType == typeof(NWScriptEngineStructure9))
                    Field.SetValue(this, ScriptHost.Intrinsics.Intrinsic_CreateEngineStructure9());
            }
        }

        /// <summary>
        /// This routine determines whether a particular type represents a
        /// legal NWScript type.  Only legal NWScript types can be used in
        /// NWScriptGlobal attributed variables.
        /// </summary>
        /// <param name="ObjectType">Supplies the type to inquire
        /// about.</param>
        /// <returns>True if the type is a legal NWScript type.</returns>
        protected bool IsValidNWScriptType(Type ObjectType)
        {
            if (ObjectType == typeof(Int32))
                return true;
            else if (ObjectType == typeof(UInt32))
                return true;
            else if (ObjectType == typeof(Single))
                return true;
            else if (ObjectType == typeof(string))
                return true;
            else if (ObjectType == typeof(NWScriptEngineStructure0))
                return true;
            else if (ObjectType == typeof(NWScriptEngineStructure1))
                return true;
            else if (ObjectType == typeof(NWScriptEngineStructure2))
                return true;
            else if (ObjectType == typeof(NWScriptEngineStructure3))
                return true;
            else if (ObjectType == typeof(NWScriptEngineStructure4))
                return true;
            else if (ObjectType == typeof(NWScriptEngineStructure5))
                return true;
            else if (ObjectType == typeof(NWScriptEngineStructure6))
                return true;
            else if (ObjectType == typeof(NWScriptEngineStructure7))
                return true;
            else if (ObjectType == typeof(NWScriptEngineStructure8))
                return true;
            else if (ObjectType == typeof(NWScriptEngineStructure9))
                return true;
            else
                return false;
        }


    }
}
