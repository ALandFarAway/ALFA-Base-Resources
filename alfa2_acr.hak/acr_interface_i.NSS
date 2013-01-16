////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_interface_i.nss
//      Version : 1.0
//         Date : 2012-01-08
//       Author : FoamBats4All
//
//  Local Variable Prefix:
//	ACR_CMD
//
//  Description:
//  This module defines interaction with a user. Multiple inputs (GUI, text,
//  etc.) share the same functionality. This provides a single library to use
//  them all. 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_nonlethal_i"
#include "acr_tradescroll_i"


////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// Prefix for text commands.
const string ACR_FI_CMD_TEXT_PREFIX = "#";
const int ACR_FI_CMD_TEXT_PREFIX_LENGTH = 1;

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! Mines the parameter at given position from the command.
//!  - sCommand : The command input to get the parameter from.
//!  - nParamNumber : Parameter number to fetch.
//! Returns: Parameter if found, empty string on error.
string ACR_FI_GetParameter( string sCommand, int nParamNumber );

object ACR_FI_ParameterToObject( object oPC, string sParam );

void ACR_FI_RunCommand( object oPC, string sCommand, string sParam0 = "", string sParam1 = "", string sParam2 = "" );

void ACR_FI_ParseAndRunCommand( object oPC, string sInput );

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void ACR_FI_SetSubdualMode( object oPC, string sState ) {
	if ( sState == "on" ) {
		_SetNLDMode( oPC, TRUE );
	} else if ( sState == "off" ) {
		_SetNLDMode( oPC, FALSE );
	} else {
		_SetNLDMode( oPC, !_GetNLDMode( oPC ) );
	}
}


void ACR_FI_Pray( object oPC ) {
	
}


void ACR_FI_MemorizeSpells( object oPC ) {
	
}


void ACR_FI_ListKnownSpells( object oPC, string sClass ) {
	
}


void ACR_FI_ListPreparedSpells( object oPC, string sClass ) {
	
}


void ACR_FI_Craft( object oPC, object oTarget ) {
	
}


void ACR_FI_ScribeScroll( object oPC ) {
	
}


void ACR_FI_MakeTradescroll( object oPC, string sSpell ) {
	ACR_CreateTradeScroll( oPC, StringToInt( sSpell ) );
}


void ACR_FI_BrewPotion( object oPC ) {
	
}


void ACR_FI_CraftWand( object oPC ) {
	
}


string ACR_FI_GetParameter( string sCommand, int nParamNumber ) {
	// Reusable variables.
	int i;
	
	// Parameter data.
	int iStartPosition = -1;
	int iParamLength = -1;
	
	// Find the parameter and its length.
	for ( i = 0; i < nParamNumber; i++ ) {
		iStartPosition = FindSubString( sCommand, " ", iStartPosition + 1 );
		if ( iStartPosition == -1 ) return "";
	}
	iStartPosition++;
	iParamLength = FindSubString( sCommand, " ", iStartPosition ) - iStartPosition;
	if ( iParamLength == -1 ) iParamLength = GetStringLength( sCommand ) - iStartPosition;
	
	// Verify output and return.
	if ( iStartPosition < 1 || iParamLength < 1 ) {
		return "";
	}
	return GetSubString( sCommand, iStartPosition, iParamLength );
}


object ACR_FI_ParameterToObject( object oPC, string sParam ) {
	// Allow self-referencing.
	if ( sParam == "$self" ) return oPC;
	
	// Allow selecting our current target.
	if ( sParam == "$target" ) return GetPlayerCurrentTarget( oPC );
	
	// Allow targetting our animal companion/familiar.
	if ( sParam == "$companion" ) return GetHenchman( oPC );
	
	// All other posibilities are invalid.
	return OBJECT_INVALID;
}


void ACR_FI_RunCommand( object oPC, string sCommand, string sParam0 = "", string sParam1 = "", string sParam2 = "" ) {
	// First, we lowercase everything.
	string sCmd = GetStringLowerCase( sCommand );
	string sP1 = GetStringLowerCase( sParam0 );
	string sP2 = GetStringLowerCase( sParam1 );
	string sP3 = GetStringLowerCase( sParam2 );

	// Debug message
	SendMessageToPC( oPC, sCmd + "( " + sP1 + ", " + sP2 + ", " + sP3 + " )" );
	
	// Actual commands.
	if ( sCmd == "subdual" ) ACR_FI_SetSubdualMode( oPC, sP1 );
	else if ( sCmd == "tradescroll" ) ACR_FI_MakeTradescroll( oPC, sP1 );
}


void ACR_FI_ParseAndRunCommand( object oPC, string sInput ) {
	// Find our parameters.
	string sParam0 = ACR_FI_GetParameter( sInput, 1 );
	string sParam1 = ACR_FI_GetParameter( sInput, 2 );
	string sParam2 = ACR_FI_GetParameter( sInput, 3 );
	
	// Isolate our command.
	string sCommand = ACR_FI_GetParameter( sInput, 0 );
	
	// Call our parent method.
	ACR_FI_RunCommand( oPC, sCommand, sParam0, sParam1, sParam2 );
}