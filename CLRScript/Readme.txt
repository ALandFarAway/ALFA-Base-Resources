CLR Script Overview
===================

Scripts authored in CLR languages can function in any scenario where a standard
NWScript language script might be specified.  A CLR script is packaged into a
specially formatted .ncs file that can be consumed by the NWScript Accelerator
plugin as a conventional NWScript script.


Sample Index
============

Several sample scripts are included in the SDK.  Although the sample are
written in C#, any CLR language can be used.

Scripts may be created using either .NET 2.0 (and 3.0/3.5), or .NET 4.0.  The
script runtime environment always operates in .NET 4.0 mode; the only reason to
use older .NET framework versions is for compatibility with older Visual Studio
releases.


The following are the .NET 4.0 samples:

CLRScript: Illustrates a basic "Hello, world" script.  This project is intended
           as a base project to start new scripts from.

CallNativeScript: Illustrates how to, via .NET Reflection, invoke native
                  NWScript methods on a NWScript script that has been JIT'd by
                  the runtime environment.  This capability can be useful to
                  interoperate with existing library code written in standard
                  NWScript.

AreaEnumerator: Illustrates how to use the provided IEnumerator<T> and
                IEnumerable<T> wrappers around several enumerator action
                services, such as GetFirstPC/GetNextPC.  The enumerator
                wrappers allow transparent use of LINQ and foreach against
                the game's various enumerator action services.


The following are the .NET 2.0 samples:

Clr20Script: Illustrates a basic "Hello, world" script.  This project is
             intended as a base project to start new scripts from.  It is a CLR
             2.0 version of the CLRScript base script.


Most samples reference several supporting source files, which are recommended
for use in new scripts.  The supporting source files are:

NWScriptActions.cs - Provides wrappers that expose the game's action service
                     APIs (i.e. the "engine functions" in nwscript.nss).

NWScriptConstants.cs - Provides compile time constants for constant values that
                       are declared in nwscript.nss.

NWScriptSupport.cs - Provides supporting logic that simplifies the creation of
                     scripts, such as enumerator wrappers and helpers for
                     managing global variables and script situation
                     continuations.


The supporting source files assume that the CLR script they are included within
exports a main script class called CLRScript.CLRScript.  This type is not
required, but is assumed by the supporting library code.  If desired, the
supporting library code can be modified, but this is not recommended.


In addition to the supporting source files, all CLR scripts reference several
assemblies that provide the actual runtime bridge to the game server.  The
functionality exported by these assemblies is, generally, wrappered in a more
convenient manner by the common supporting source files outlined above.

NWNScriptJITIntrinsics.dll - Provides definitions of various interface types
                             that are used to interact with the scripting
                             runtime environment.  For example, the
                             IGeneratedScriptProgram interface type is declared
                             in this assembly.

NWScriptManagedInterface.dll - Provides the underlying action service handler
                               interface that is used to call action service
                               handlers (e.g. nwscript.nss functions).  This
                               assembly is a "virtual" assembly; a customized
                               implemention optimized for performance is
                               generated each time NWN2Server boots by the
                               runtime environment, and then linked to any CLR
                               scripts that load.


Type mappings for CLR scripts
=============================

A series of types that directly map from CLR scripts to native NWScript data
types are supported.  These types are required when action service routine are
invoked, and are also required in certain other circumstances.

The data type mappings are as follows:

int (System.Int32):                 Maps to NWScript 'int'
uint (System.UInt32):               Maps to NWScript 'object'
float (System.Single):              Maps to NWScript 'float'
string (System.String):             Maps to NWScript 'string'
NWScript.Vector3:                   Maps to NWScript 'vector'
NWEffect:                           Maps to NWScript 'effect'
NWScript.NWScriptEngineStructure0:  Maps to NWScript 'effect'
NWEvent:                            Maps to NWScript 'event'
NWScript.NWScriptEngineStructure1:  Maps to NWScript 'event'
NWLocation:                         Maps to NWScript 'location'
NWScript.NWScriptEngineStructure2:  Maps to NWScript 'location'
NWTalent:                           Maps to NWScript 'talent'
NWScript.NWScriptEngineStructure3:  Maps to NWScript 'talent'
NWItemProperty:                     Maps to NWScript 'itemproperty'
NWScript.NWScriptEngineStructure4:  Maps to NWScript 'itemproperty'
NWAction (delegate ()):             Maps to NWScript 'action'

Note that 'string' and all engine structure types must never attain a value of
null when passed to any interfaces.  Instead, default values ("") or those
returned by helper functions such as GetDefaultNWEffect() must be used.

In addition, engine structure types must not be compared with the == operator.
They must be compared with helper functions such as EqualNWEffects().


Lifecycle of a CLR Script
==========================

Each CLR script consists of an assembly with a single associated DLL.  This DLL
is packaged into a .ncs file via the NativeScriptUtil.exe post-processing
utility, after compilation.

A CLR script assembly must expose (as a public class) exactly one type that
derives from the IGeneratedScriptProgram interface.  The NWScript Accelerator
runtime environment will create an instance of the type deriving from
IGeneratedScriptProgram (the script object type).  When the game invokes a CLR
script, via any means, the script object's
IGeneratedScriptProgram.ExecuteScript method is invoked.  This method
invokation happens on the game's main thread, which is the only environment
where calls to the game may be made.

The NWScript Acclerator runtime environment typically maintains at least one
active instance of the CLR script's script object type, but multiple instances
may be created in certain circumstances (such as if a script is recursively
called via the ExecuteScript action service function).  Therefore, script
objects must handle multiple concurrent instances existing simultaneously.


NWScript Global Variable Management
===================================

In a standard NWScript script, global variables are declared at file scope.
Static and global variables in CLR languages, while fully supported by CLR
scripts, do not directly map to the same concept of NWScript global variables.

This is because each time a NWScript script runs, that script gets a new copy
of its global variables (from scratch).  If a script is concurrently executed
in a recursive fashion, the recursive instance, similarly, receives a private
copy of its global variables.  And if a script makes use of functions that take
"action" arguments, global variables are copied for use by the "action"
continuation.

CLR scripts provide a mechanism to implement the same semantics as NWScript
global variables.  This support is not required (as conventional static,
global, or instance variables are allowed), but can be useful when "action"
continuations or recursive script invocations are in use.

The CLR script support for NWScript global variables is built on top of
specially attributed instance variables attached to the script object type.
These instance variables must be attributed with the [NWScriptGlobal] attribute
and must be of a type that is supported by native NWScript (e.g. int, uint,
float, string, or an engine structure type).

All instance variables decorated with the [NWScriptGlobal] attribute on the
script object are saved and restored automatically when script situations are
created and executed.  This provides consistent semantics with native NWScript,
with these variables having copies "forked off" for each script situation.

Conventional instance variables may still be used, but will not be subject to
the automatic save and restore logic.  The programmer must handle the case of
concurrent recursive scripts appropriately in this case.


Script Situation Continuations (e.g. DelayCommand)
==================================================

CLR scripts natively support the use of DelayCommand and other continuation
functions, internally known as "script situations".  A script situation
represents the state necessary to resume execution of a snippet of CLR code
at a later time.  The implementation of script situation continuations is
designed to be conceptually identical to standard NWScript, so the usage of
these continuations should follow naturally.

When an action service handler with an "action" typed argument is invoked
argument is invoked, a script situation is created.  This process involves
saving the state of all NWScript global variables so that these variables can
be restored later.  In a CLR script, NWScript global variables are, as
discussed in the previous section, automatically "forked off" for each script
situation instance.

The process of creating a script situation is abstracted away by each action
service routine that takes an action type argument.  To call such a service
routine, construct an anonymous delegate (taking no arguments and returning
nothing), and pass it to the action service handler.  For example:

int Volume;
Volume = TALKVOLUME_TALK;

DelayCommand(1.0f,
      new delegate() { ActionSpeakString("Hello, world", Volume); } );

Note that consistent with typical anonymous delegates in C#, and with standard
script situation actions in native NWScript, local variables in the caller's
frame may be accessed in the script situation resume label.


Accessing Native NWScript Functions from CLR Scripts
====================================================

Via .NET Reflection, functions implemented in native NWScript, if contained
within a script that has been JIT'd to CLR code via the NWScript Accelerator
plugin, can be invoked from CLR scripts.  Standard reflection techniques are
applicable (and the CallNativeScript sample demonstrates how to perform this
task).

To invoke native NWScript functions, however, it is necessary to understand the
conventions around the managed assemblies that the runtime translate these
scripts into.

Each script is placed into an assembly named
"NWScriptAsm_<ScriptName>, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null"

... where "<ScriptName>" is the ResRef of the script, for example,
gui_hss_pc_tools.

A single type deriving from IGeneratedScriptProgram is placed in this assembly,
with a name of the form "NWScript.JITCode.<ScriptName>.ScriptProgram".  This
represents the main script type for the JIT'd script, similar to how the main
script type for a CLR script is laid out.

The main script type contains all functions present in the native NWScript
compiled script file, and a special function to set up global variables for an
instance of the script object for the script.  This function is a method on the
script object type and is named "NWScriptInitGlobals".  It is the
responsibility of the user to invoke this method on a private instance of a
script object created for a JIT'd script for purposes of CLR script
interoperability (if the method exists, which it may not if the script had no
NWScript globals).

Individual NWScript functions within the JIT'd script are attached to the
script object type and are prefixed with the string "NWScriptSubroutine_".  A
script MUST be compiled with debug symbols (*.ndb) available in order for names
for NWScript script functions to be available (and thus invokable from a CLR
script).

Scripts have assemblies generated and loaded on demand at first reference.  It
is recommended that CLR scripts wishing to invoke a function on a native
NWScript script first check the loaded assembly list before forcing a script
load via the ExecuteScript action service.  (Note that the target script must
be safe to run the main function for forcing a load via ExecuteScript to be a
safe operation.)

It is not recommended that calls be made to NWScript native functions that
return an aggregate type (such as vector or a custom struct).  These functions
will have a function-specific datatype synthesized by the runtime, which would
require extensive manipulation via reflection to access.


Accessing CLR Script Features from Native NWScript Scripts
==========================================================

In this release, native NWScript scripts cannot directly invoke methods on a
CLR script.  However, a CLR script can still present a parameterized
entrypoint that can be called via the ExecuteScriptEnhanced (or ExecuteScript)
action services, from native NWScript.

Returning values other than of type int from a CLR script to a native NWScript
script must be perfomed indirectly, such as via setting a local variable on a
well-known object.


Accessing NWNX4 Functionality from CLR Scripts
==============================================

As with native NWScript scripts, CLR scripts may invoke NWNX4 plugins via the
NWNXGet* and NWNXSet* action services, which serve as the low level foundation
for communication between the scripting environment and NWNX4 plugins.

Alternatively, native NWScript library functions that are components of a JIT'd
script which wrapper NWNX4 functionality can be accessed as described in the
"Accessing Native NWScript Functions from CLR Scripts" section.  Choose the
mechanism that is most convenient for your program.


