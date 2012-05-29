/*++

Copyright (c) Ken Johnson (Skywing). All rights reserved.

Module Name:

	nwnx_nwscriptvm_include.nss

Abstract:

	This module defines APIs that are provided by the NWScriptVM plugin.

--*/

//
// Debug levels for NWScriptVM_SetDebugLevel.
//

const int EDL_None    = 0;        // No output
const int EDL_Errors  = 1;        // Only errors are shown
const int EDL_Calls   = 2;        // Errors and script calls shown
const int EDL_Verbose = 3;        // Full instruction level tracing shown

void
NWScriptVM_LogStatistics(
	)
/*++

Routine Description:

	This routine logs current NWScript usage statistics to the plugin log file.

Arguments:

	None.

Return Value:

	None.

Environment:

	Any script caller.

--*/
{
	NWNXGetInt( "NWSCRIPTVM", "LOG SCRIPT STATISTICS", "", 0 );
}

void
NWScriptVM_SetReferenceVM(
	int UseReferenceVM
	)
/*++

Routine Description:

	This routine sets whether the script host prefers the reference VM or the
	JIT engine for future script compilation.  Note that already cached scripts
	are not necessarily immediately impacted by the request.

Arguments:

	UseReferenceVM - Supplies a Boolean value that indicates a zero value if the
	                 server should prefer to JIT scripts, else a non-zero value
	                 if the server should prefer to use the reference VM for
	                 scripts.

Return Value:

	None.

Environment:

	Any script caller.

--*/
{
	NWNXGetInt(
		"NWSCRIPTVM",
		"SET REFERENCE VM",
		"",
		UseReferenceVM ? TRUE : FALSE );
}

void
NWScriptVM_ClearScriptCache(
	)
/*++

Routine Description:

	This routine clears the script host's cached script list.  The cache
	maintains state about which scripts have been JIT'd and which have been
	slated for execution in the reference VM.

Arguments:

	None.

Return Value:

	None.

Environment:

	Any script caller.

--*/
{
	NWNXGetInt( "NWSCRIPTVM", "CLEAR SCRIPT CACHE", "", 0 );
}

int
NWScriptVM_GetAvailableVASpace(
	)
/*++

Routine Description:

	This routine returns an estimate of the amount of virtual address space that
	is free on the server process.  The estimate does not represent contiguous
	free VA ranges and it does not represent a guarantee of future ability to
	satisfy any allocations successfully.

	N.B.  The returned value has 32 significant bits, that is, the sign bit is
	      used as an additional data bit.  The return value is unsigned but the
	      scripting environment does not provide native unsigned integer math.

Arguments:

	None.

Return Value:

	An estimate of the available VA space in the server process is returned.
	The estimate may be less than zero because it is an unsigned quantity.

Environment:

	Any script caller.

--*/
{
	return NWNXGetInt( "NWSCRIPTVM", "GET AVAILABLE VA SPACE", "", 0 );
}

void
NWScriptVM_SetDebugLevel(
	int DebugLevel
	)
/*++

Routine Description:

	This routine sets the debug level of the script execution subsystem.  For
	example, it can be used to enable or disable detailed tracing at runtime.

	NOTE:  Detailed tracing should generally be used with the NWScript VM and
	       not the JIT compiler, as scripts that are already JIT'd may not
	       return full information.  Therefore, it is recommended that the
	       following steps be taken to enable tracing at runtime:

	       1) Call NWScriptVM_SetReferenceVM(TRUE) to disable the JIT system.
	       2) Call NWScriptVM_SetDebugLevel(EDL_Verbose) to enable tracing.
	       3) Call NWScriptVM_ClearScriptCache() to force existing JIT'd scripts
	          to be executed via the reference VM.

	       Similarly, follow the same steps to disable tracing, except that you
	       should set the reference VM to disabled (FALSE) and set the debug
	       level to errors only (EDL_Errors).

Arguments:

	DebugLevel - Supplies the new script debug level.  Legal values are drawn
	             from the EDL_* family of constants.

	             EDL_None - No debug output is recorded to the plugin log file.

	             EDL_Errors - Only serious errors are recorded.

	             EDL_Calls - Function calls are recorded (plus errors).

	             EDL_Verbose - Instruction level tracing is recorded (and calls
	                           and errors).  Instruction level tracing is only
	                           fully supported with the reference VM enabled.

Return Value:

	None.

Environment:

	Any script caller.

--*/
{
	NWNXGetInt( "NWSCRIPTVM", "SET DEBUG LEVEL", "", DebugLevel );
}

void
NWScriptVM_ReloadConfiguration(
	)
/*++

Routine Description:

	This routine reloads the configuration file for the accelerator plugin and
	applies settings defined within it.

	Note that the script cache should be cleared afterwards if the debug level
	is changed.

Arguments:

	None.

Return Value:

	None.

Environment:

	Any script caller.

--*/
{
	NWNXGetInt( "NWSCRIPTVM", "RELOAD CONFIGURATION", "", 0 );
}

