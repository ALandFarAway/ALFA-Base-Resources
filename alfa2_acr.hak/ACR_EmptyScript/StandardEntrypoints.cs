using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Runtime.InteropServices;
using System.Reflection;
using System.Reflection.Emit;
using CLRScriptFramework;
using NWScript;
using NWScript.ManagedInterfaceLayer.NWScriptManagedInterface;

using NWEffect = NWScript.NWScriptEngineStructure0;
using NWEvent = NWScript.NWScriptEngineStructure1;
using NWLocation = NWScript.NWScriptEngineStructure2;
using NWTalent = NWScript.NWScriptEngineStructure3;
using NWItemProperty = NWScript.NWScriptEngineStructure4;

namespace ACR_EmptyScript
{
    public partial class ACR_EmptyScript : CLRScriptBase, ICLRScriptImplementation
    {

        /// <summary>
        /// This helper function saves the value of all 'globals' to an object
        /// array for use with storing a saved state (e.g. a script situation).
        /// </summary>
        /// <returns>A list of global variables, to be restored by a future
        /// call to LoadScriptGlobals.</returns>
        public object[] SaveScriptGlobals()
        {
            object[] Globals = new object[GlobalFields.Count];

            int i = 0;

            foreach (FieldInfo Field in GlobalFields)
            {
                Globals[i] = Field.GetValue(this);
                i += 1;
            }

            return Globals;
        }

        /// <summary>
        /// This routine is the main entry point symbol for the script.  It is
        /// invoked when the packaged script is executed.
        /// </summary>
        /// <param name="ObjectSelf">Supplies the "OBJECT_SELF" object id of
        /// the object that the script is being executed over.  This may be the
        /// invalid object id (Script.OBJECT_INVALID) if no object is
        /// associated with the execute script request.</param>
        /// <param name="ScriptParameters">Supplies the parameter values for
        /// the script.  If the type deriving from IGeneratedScriptProgram
        /// declares a ScriptParameterTypes public field, then parameters may
        /// be passed in via this array (in which case the parameter types
        /// have already been converted and validated).  Otherwise, no
        /// arguments are provided.</param>
        /// <param name="DefaultReturnCode">Supplies the requested default
        /// return code to use if the script is a "main"-style script that
        /// would not conventionally return a value.</param>
        /// <returns></returns>
        public Int32 ExecuteScript([In] UInt32 ObjectSelf, [In] object[] ScriptParameters, [In] Int32 DefaultReturnCode)
        {
            UInt32 OldOBJECT_SELF = ObjectSelf;
            int ReturnCode;

            try
            {
                OBJECT_SELF = ObjectSelf;
                ReturnCode = ScriptMain(ScriptParameters, DefaultReturnCode);
            }
            finally
            {
                OBJECT_SELF = OldOBJECT_SELF;
            }

            return ReturnCode;
        }

        /// <summary>
        /// This routine is invoked when a script situation created by the
        /// script is resumed for execution (for example, a DelayCommand
        /// continuation).  Its purpose is to perform the appropriate resume
        /// action for this continuation.
        /// 
        /// Note that a script situation may be resumed after the original
        /// script object has been deleted, or even after the host process has
        /// been exited and restarted (in the save of a saved game that has
        /// been loaded).
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
        public void ExecuteScriptSituation([In] UInt32 ScriptSituationId, [In] object[] Locals, [In] UInt32 ObjectSelf)
        {
            //
            // Call the helper function.
            //

            DispatchExecuteScriptSituation(ScriptSituationId, Locals, ObjectSelf);
        }

        /// <summary>
        /// This routine is invoked when the script context is being cloned for
        /// the creation of a script situation.  Its purpose is to create a new
        /// SampleManagedNWScript object and transfer any state desired to the
        /// new script object.
        /// </summary>
        /// <returns>The cloned script object is returned.</returns>
        public IGeneratedScriptProgram CloneScriptProgram()
        {
            return new ACR_EmptyScript(this);
        }

        /// <summary>
        /// This routine is invoked when the script context was restored from
        /// the interopability script stack for a script situation.  Its
        /// purpose is to restore any 'global' (i.e. member variable) state
        /// that was passed to the initial StoreState request.  The globals may
        /// only include standard NWScript types (Int32, UInt32, Single, and
        /// engine structures).
        /// </summary>
        /// <param name="Globals">Supplies an array of global variables that
        /// were provided to the initial StoreState request.</param>
        public void LoadScriptGlobals([In] object[] Globals)
        {
            //
            // Restore all [NWScriptGlobal] attributed globals from the global
            // list.
            //

            int i = 0;

            foreach (FieldInfo Field in GlobalFields)
            {
                Field.SetValue(this, Globals[i]);
                i += 1;
            }
        }
    }
}
