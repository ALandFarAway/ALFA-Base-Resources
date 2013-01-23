////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_collections_i.nss
//
//  Description
//  This file contains wrappers around functions in ACR_CollectionLib, for
//  holding data
//
/////////////////////////////////////////////////////////////////////////////////

#ifndef ACR_COLLECTIONS_I
#define ACR_COLLECTIONS_I

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// Our script.
string ACR_COLLECTION_LIB_SCRIPT = "acr_collectionlib";

// Result variables.
string ACR_COLLECTION_RESULT_VAR_INT = "ACR_COLLECTION_RES_INT";
string ACR_COLLECTION_RESULT_VAR_FLOAT = "ACR_COLLECTION_RES_FLT";
string ACR_COLLECTION_RESULT_VAR_STRING = "ACR_COLLECTION_RES_STR";
string ACR_COLLECTION_RESULT_VAR_OBJECT = "ACR_COLLECTION_RES_OBJ";

// Data type codes for ACR_CollectionLib.
const int ACR_COLLECTION_DATA_TYPE_INT = 0;
const int ACR_COLLECTION_DATA_TYPE_FLOAT = 1;
const int ACR_COLLECTION_DATA_TYPE_STRING = 2;
const int ACR_COLLECTION_DATA_TYPE_OBJECT = 3;

// Container codes for ACR_Collectionlib.
const int ACR_COLLECTION_ARRAY_LIST = 0;
const int ACR_COLLECTION_INT_LIST = 1;
const int ACR_COLLECTION_FLOAT_LIST = 2;
const int ACR_COLLECTION_STRING_LIST = 3;
const int ACR_COLLECTION_OBJECT_LIST = 4;
const int ACR_COLLECTION_INT_DICTIONARY = 5;
const int ACR_COLLECTION_FLOAT_DICTIONARY = 6;
const int ACR_COLLECTION_STRING_DICTIONARY = 7;
const int ACR_COLLECTION_OBJECT_DICTIONARY = 8;
const int ACR_COLLECTION_INT_QUEUE = 9;
const int ACR_COLLECTION_FLOAT_QUEUE = 10;
const int ACR_COLLECTION_STRING_QUEUE = 11;
const int ACR_COLLECTION_OBJECT_QUEUE = 12;
const int ACR_COLLECTION_INT_STACK = 13;
const int ACR_COLLECTION_FLOAT_STACK = 14;
const int ACR_COLLECTION_STRING_STACK = 15;
const int ACR_COLLECTION_OBJECT_STACK = 16;
const int ACR_COLLECTION_RESULT = 17;

// Method codes for interacting with ACR_CollectionLib collections.
const int ACR_COLLECTION_METHOD_CREATE = 0;
const int ACR_COLLECTION_METHOD_DELETE = 1;
const int ACR_COLLECTION_METHOD_ADD = 2;
const int ACR_COLLECTION_METHOD_CLEAR = 3;
const int ACR_COLLECTION_METHOD_CONTAINS = 4;
const int ACR_COLLECTION_METHOD_COUNT = 5;
const int ACR_COLLECTION_METHOD_ELEMENTAT = 6;
const int ACR_COLLECTION_METHOD_MAX = 7;
const int ACR_COLLECTION_METHOD_REVERSE = 8;
const int ACR_COLLECTION_METHOD_SUM = 9;

// Error codes.
const int ACR_COLLECTION_ERROR_NAME = -3400;
const int ACR_COLLECTION_ERROR_COLLECTION_ALREADY_EXISTS = -3401;
const int ACR_COLLECTION_ERROR_COLLECTION_DOES_NOT_EXIST = -3402;
const int ACR_COLLECTION_ERROR_COLLECTION_NO_METHOD = -3403;


////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//
// GENERIC FUNCTIONS
//

int ACR_CallCollectionLib( int nCollection, int nMethodCode, string sCollectionName, int nParamInt1 = 0, int nParamInt2 = 0, float fParamFlt1 = 0.0, float fParamFlt2 = 0.0, string sParamStr1 = "", string sParamStr2 = "", object oParamObj1 = OBJECT_INVALID, object oParamObj2 = OBJECT_INVALID );

int ACR_GetCollectionResultInt();

float ACR_GetCollectionResultFloat();

string ACR_GetCollectionResultString();

object ACR_GetCollectionResultObject();


//
// ARRAY LIST
//

void ACR_IntList_Create( string sName );
void ACR_IntList_Delete( string sName );
void ACR_IntList_Add( string sName, int nValue );
void ACR_IntList_Clear( string sName );
int ACR_IntList_Contains( string sName, int nValue );
int ACR_IntList_Count( string sName );
int ACR_IntList_ElementAt( string sName, int nIndex );
int ACR_IntList_Max( string sName );
void ACR_IntList_Reverse( string sName );
int ACR_IntList_Sum( string sName );


////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

int ACR_CallCollectionLib( int nCollection, int nMethodCode, string sCollectionName, int nParamInt1 = 0, int nParamInt2 = 0, float fParamFlt1 = 0.0, float fParamFlt2 = 0.0, string sParamStr1 = "", string sParamStr2 = "", object oParamObj1 = OBJECT_INVALID, object oParamObj2 = OBJECT_INVALID ) {
	// Add parameters
	AddScriptParameterInt( nCollection );
	AddScriptParameterInt( nMethodCode );
	AddScriptParameterString( sCollectionName );
	AddScriptParameterInt( nParamInt1 );
	AddScriptParameterInt( nParamInt1 );
	AddScriptParameterFloat( fParamFlt1 );
	AddScriptParameterFloat( fParamFlt2 );
	AddScriptParameterString( sParamStr1 );
	AddScriptParameterString( sParamStr2 );
	
	// Execute our script.
	WriteTimestampedLogEntry( "Executing " + ACR_COLLECTION_LIB_SCRIPT + "." );
	int nReturnCode = ExecuteScriptEnhanced( ACR_COLLECTION_LIB_SCRIPT, OBJECT_SELF, TRUE );
	
	// Write some information in case of an error.
	if ( nReturnCode != 0 ) {
		WriteTimestampedLogEntry( "ACR_CollectionLib returned error code " + IntToString( nReturnCode ) + "." );
	}
	
	// Throw our return value back.
	return nReturnCode;
}

int ACR_GetCollectionResultInt() {
	object oModule = GetModule();
	int nValue = GetLocalInt( oModule, ACR_COLLECTION_RESULT_VAR_INT );
	DeleteLocalString( oModule, ACR_COLLECTION_RESULT_VAR_INT );
	return nValue;
}


float ACR_GetCollectionResultFloat() {
	object oModule = GetModule();
	float fValue = GetLocalFloat( oModule, ACR_COLLECTION_RESULT_VAR_FLOAT );
	DeleteLocalFloat( oModule, ACR_COLLECTION_RESULT_VAR_FLOAT );
	return fValue;
}


string ACR_GetCollectionResultString() {
	object oModule = GetModule();
	string sValue = GetLocalString( oModule, ACR_COLLECTION_RESULT_VAR_STRING );
	DeleteLocalString( oModule, ACR_COLLECTION_RESULT_VAR_STRING );
	return sValue;
}


object ACR_GetCollectionResultObject() {
	object oModule = GetModule();
	object oValue = GetLocalObject( oModule, ACR_COLLECTION_RESULT_VAR_OBJECT );
	DeleteLocalObject( oModule, ACR_COLLECTION_RESULT_VAR_OBJECT );
	return oValue;
}


void ACR_IntList_Create( string sName ) {
	ACR_CallCollectionLib( ACR_COLLECTION_INT_LIST, ACR_COLLECTION_METHOD_CREATE, sName );
}


void ACR_IntList_Delete( string sName ) {
	ACR_CallCollectionLib( ACR_COLLECTION_INT_LIST, ACR_COLLECTION_METHOD_DELETE, sName );
}


void ACR_IntList_Add( string sName, int nValue ) {
	ACR_CallCollectionLib( ACR_COLLECTION_INT_LIST, ACR_COLLECTION_METHOD_ADD, sName, nValue );
}


void ACR_IntList_Clear( string sName ) {
	ACR_CallCollectionLib( ACR_COLLECTION_INT_LIST, ACR_COLLECTION_METHOD_CLEAR, sName );
}


int ACR_IntList_Contains( string sName, int nValue ) {
	ACR_CallCollectionLib( ACR_COLLECTION_INT_LIST, ACR_COLLECTION_METHOD_CONTAINS, sName, nValue );
	return ACR_GetCollectionResultInt();
}


int ACR_IntList_Count( string sName ) {
	ACR_CallCollectionLib( ACR_COLLECTION_INT_LIST, ACR_COLLECTION_METHOD_COUNT, sName );
	return ACR_GetCollectionResultInt();
}


int ACR_IntList_ElementAt( string sName, int nIndex ) {
	ACR_CallCollectionLib( ACR_COLLECTION_INT_LIST, ACR_COLLECTION_METHOD_ELEMENTAT, sName, nIndex );
	return ACR_GetCollectionResultInt();
}


int ACR_IntList_Max( string sName ) {
	ACR_CallCollectionLib( ACR_COLLECTION_INT_LIST, ACR_COLLECTION_METHOD_MAX, sName );
	return ACR_GetCollectionResultInt();
}


void ACR_IntList_Reverse( string sName ) {
	ACR_CallCollectionLib( ACR_COLLECTION_INT_LIST, ACR_COLLECTION_METHOD_REVERSE, sName );
}


int ACR_IntList_Sum( string sName ) {
	ACR_CallCollectionLib( ACR_COLLECTION_INT_LIST, ACR_COLLECTION_METHOD_SUM, sName );
	return ACR_GetCollectionResultInt();
}


#endif