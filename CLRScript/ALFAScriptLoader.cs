//
// This module contains logic for loading scripts.
// 

using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
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

namespace ALFA
{

    public class ScriptLoader
    {

        /// <summary>
        /// This routine loads a script (if it has not already been loaded),
        /// and sets up globals for the script.  The script needs to be safe to
        /// have its entrypoint called from OBJECT_INVALID for this function to
        /// work properly.
        /// </summary>
        /// <param name="ScriptName">Supplies the name of the script to load.</param>
        /// <param name="ForceLoadScript">If true, forcibly attempt to load
        /// the script.</param>
        /// <param name="CallerScript">Suppiles the script object owned by the
        /// caller.</param>
        /// <returns>The script object for the newly loaded script.  On failure
        /// an exception is raised.</returns>
        public static IGeneratedScriptProgram LoadScript(string ScriptName, bool ForceLoadScript, CLRScriptBase CallerScript)
        {
            string AssemblyName = String.Format("NWScriptAsm_{0}, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null", ScriptName);
            string TypeName = String.Format("NWScript.JITCode.{0}.ScriptProgram", ScriptName);
            Assembly ScriptAssembly;
            IGeneratedScriptProgram ScriptObject;
            Type ScriptObjectType;
            MethodInfo NWScriptInitGlobals;

            //
            // Check if the script is already loaded.  If so, use the existing
            // script assembly.
            //

            ScriptAssembly = (from LoadedAsm in AppDomain.CurrentDomain.GetAssemblies()
                              where LoadedAsm.FullName == AssemblyName
                              select LoadedAsm).FirstOrDefault();

            if (ScriptAssembly == null && ForceLoadScript)
            {
                //
                // The assembly is not yet loaded.  Force it to be loaded via
                // a dummy ExecuteScript call.
                //

                CallerScript.ExecuteScript(ScriptName, CLRScriptBase.OBJECT_INVALID);

                ScriptAssembly = (from LoadedAsm in AppDomain.CurrentDomain.GetAssemblies()
                                  where LoadedAsm.FullName == AssemblyName
                                  select LoadedAsm).FirstOrDefault();
            }

            if (ScriptAssembly == null)
            {
                throw new ApplicationException("Could not load script " + ScriptName);
            }

            //
            // Now that the script assembly is loaded, we can create a script
            // object out of the script for our own use.  The script object
            // encapsulates a private set of global variables for the target
            // script.
            //

            ScriptObject = (IGeneratedScriptProgram)ScriptAssembly.CreateInstance(
                TypeName,
                false,
                BindingFlags.CreateInstance,
                null,
                new object[] { CallerScript.ScriptHost.Intrinsics, CallerScript.ScriptHost.Host },
                null,
                null);

            ScriptObjectType = ScriptObject.GetType();

            //
            // If the script had global variables, call the global variable
            // initializer on the script now.  This will set the script object
            // up into a state as though we created all the global variables,
            // but stopped just before main() or StartingConditional().
            //

            NWScriptInitGlobals = ScriptObjectType.GetMethod("NWScriptInitGlobals");

            if (NWScriptInitGlobals != null)
                NWScriptInitGlobals.Invoke(ScriptObject, null);

            //
            // The private script object is ready to use.  Return the instance
            // of the script that we had created.
            //

            return ScriptObject;
        }

        /// <summary>
        /// This function links to a NWScript function within a given script
        /// object.  The script must be compiled with debug symbols, and the
        /// function needs to have been actually instantiated into the target
        /// script.  Calling the function within NWScript code, inside the
        /// target script, will ensure that the function was instantiated.
        /// </summary>
        /// <param name="ScriptObject">Supplies the script object to get the
        /// target function from.</param>
        /// <param name="ScriptFunctionName">Supplies the name of the NWScript
        /// native function to get.</param>
        /// <returns>The function method is returned.  On failure, an exception
        /// is raised.</returns>
        public static MethodInfo GetScriptFunction(IGeneratedScriptProgram ScriptObject, string ScriptFunctionName)
        {
            MethodInfo Method = ScriptObject.GetType().GetMethod("NWScriptSubroutine_" + ScriptFunctionName);

            if (Method == null)
                throw new ApplicationException("Unable to find script function " + ScriptFunctionName + "on script" + ScriptObject.GetType().FullName);

            return Method;
        }

    }
}
