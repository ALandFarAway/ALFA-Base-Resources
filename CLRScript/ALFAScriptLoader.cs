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
using System.IO;
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
        /// <param name="CallerScript">Supplies the script object owned by the
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
        /// This routine loads a CLR script assembly from disk and creates an
        /// initial script object from it.
        /// </summary>
        /// <param name="ScriptFileName">Supplies the file name of the script
        /// assembly to load.</param>
        /// <param name="CallerScript">Supplies the script object owned by the
        /// caller.</param>
        /// <returns>The script object for the newly loaded script.  On failure
        /// an exception is raised.</returns>
        public static IGeneratedScriptProgram LoadScriptFromDisk(string ScriptFileName, CLRScriptBase CallerScript)
        {
            AppDomain CurrentDomain = AppDomain.CurrentDomain;
            Assembly ScriptAsm;
            Type ScriptObjectType;
            IGeneratedScriptProgram ScriptObject;

            //
            // Load the target assembly up from disk in preparation for
            // instantiation.
            //

            byte[] FileContents = File.ReadAllBytes(ScriptFileName);

            //
            // Establish a temporary assembly resolve handler to handle the
            // reference to the interface assembly.
            //

            CurrentDomain.AssemblyResolve += new ResolveEventHandler(LoadScriptFromDisk_AssemblyResolve);

            try
            {
                ScriptAsm = CurrentDomain.Load(FileContents);

                //
                // Locate the script object type and create an instance of the
                // script object.
                //

                ScriptObjectType = (from AsmType in ScriptAsm.GetTypes()
                                    where AsmType.IsVisible &&
                                    AsmType.GetInterface("IGeneratedScriptProgram") != null
                                    select AsmType).FirstOrDefault();

                if (ScriptObjectType == null)
                    throw new ApplicationException("Unable to resolve script object type for assembly " + ScriptFileName);

                ScriptObject = (IGeneratedScriptProgram)ScriptAsm.CreateInstance(
                    ScriptObjectType.FullName,
                    false,
                    BindingFlags.CreateInstance,
                    null,
                    new object[] { CallerScript.ScriptHost.Intrinsics, CallerScript.ScriptHost.Host },
                    null,
                    null);
            }
            finally
            {
                CurrentDomain.AssemblyResolve -= new ResolveEventHandler(LoadScriptFromDisk_AssemblyResolve);
            }

            return ScriptObject;
        }

        /// <summary>
        /// This method handles assembly resolution for
        /// NWScriptManagedInterfaceAssembly when loading a CLR script from
        /// LoadScript
        /// </summary>
        /// <param name="sender">Supplies the sender object.</param>
        /// <param name="args">Supplies the event arguments.</param>
        /// <returns></returns>
        static Assembly LoadScriptFromDisk_AssemblyResolve(object sender, ResolveEventArgs args)
        {
            if (args.Name != "NWScriptManagedInterface, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null")
                return null;

            return Assembly.GetAssembly(typeof(ManagedNWScript));
        }

        /// <summary>
        /// This methods generates a default argument array for a script object
        /// and returns it.  All arguments have empty values.
        /// </summary>
        /// <param name="ScriptObject">Supplies the script object of the script
        /// to generate default arguments for.</param>
        /// <param name="CallerScript">Supplies the script object owned by the
        /// caller.</param>
        /// <returns>The argument array is returned.</returns>
        public static object[] GetDefaultParametersForScript(IGeneratedScriptProgram ScriptObject, CLRScriptBase CallerScript)
        {
            Type ScriptObjectType = ScriptObject.GetType();
            FieldInfo ParametersField = ScriptObjectType.GetField("ScriptParameterTypes");
            Type[] ParameterTypes;
            object[] DefaultParameters;

            if (ParametersField == null)
                return new object[] { };

            ParameterTypes = (Type[])ParametersField.GetValue(ScriptObject);

            DefaultParameters = new object[ParameterTypes.Length];

            //
            // Construct a default argument for each parameter to the script's
            // main function.
            //

            for (int i = 0; i < ParameterTypes.Length; i += 1)
            {
                if (ParameterTypes[i] == typeof(string))
                    DefaultParameters[i] = "";
                else if (ParameterTypes[i] == typeof(Int32))
                    DefaultParameters[i] = (Int32)0;
                else if (ParameterTypes[i] == typeof(UInt32))
                    DefaultParameters[i] = CLRScriptBase.OBJECT_INVALID;
                else if (ParameterTypes[i] == typeof(Single))
                    DefaultParameters[i] = (Single)0.0f;
                else if (ParameterTypes[i] == typeof(NWScriptEngineStructure0))
                    DefaultParameters[i] = CallerScript.ScriptHost.Intrinsics.Intrinsic_CreateEngineStructure0();
                else if (ParameterTypes[i] == typeof(NWScriptEngineStructure1))
                    DefaultParameters[i] = CallerScript.ScriptHost.Intrinsics.Intrinsic_CreateEngineStructure1();
                else if (ParameterTypes[i] == typeof(NWScriptEngineStructure2))
                    DefaultParameters[i] = CallerScript.ScriptHost.Intrinsics.Intrinsic_CreateEngineStructure2();
                else if (ParameterTypes[i] == typeof(NWScriptEngineStructure3))
                    DefaultParameters[i] = CallerScript.ScriptHost.Intrinsics.Intrinsic_CreateEngineStructure3();
                else if (ParameterTypes[i] == typeof(NWScriptEngineStructure4))
                    DefaultParameters[i] = CallerScript.ScriptHost.Intrinsics.Intrinsic_CreateEngineStructure4();
                else if (ParameterTypes[i] == typeof(NWScriptEngineStructure5))
                    DefaultParameters[i] = CallerScript.ScriptHost.Intrinsics.Intrinsic_CreateEngineStructure5();
                else if (ParameterTypes[i] == typeof(NWScriptEngineStructure6))
                    DefaultParameters[i] = CallerScript.ScriptHost.Intrinsics.Intrinsic_CreateEngineStructure6();
                else if (ParameterTypes[i] == typeof(NWScriptEngineStructure7))
                    DefaultParameters[i] = CallerScript.ScriptHost.Intrinsics.Intrinsic_CreateEngineStructure7();
                else if (ParameterTypes[i] == typeof(NWScriptEngineStructure8))
                    DefaultParameters[i] = CallerScript.ScriptHost.Intrinsics.Intrinsic_CreateEngineStructure8();
                else if (ParameterTypes[i] == typeof(NWScriptEngineStructure9))
                    DefaultParameters[i] = CallerScript.ScriptHost.Intrinsics.Intrinsic_CreateEngineStructure9();
                else
                    throw new ApplicationException("Script takes invalid arguments to ExecuteScript entrypoint.");
            }

            return DefaultParameters;
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
