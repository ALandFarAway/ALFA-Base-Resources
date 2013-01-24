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
const int ACR_COLLECTION_METHOD_CREATE= 0;
const int ACR_COLLECTION_METHOD_CREATE_IF_NOT_EXISTS = 1;
const int ACR_COLLECTION_METHOD_DELETE = 2;
const int ACR_COLLECTION_METHOD_DELETE_IF_EXISTS = 3;
const int ACR_COLLECTION_METHOD_EXISTS = 4;
const int ACR_COLLECTION_METHOD_ADD = 5;
const int ACR_COLLECTION_METHOD_CLEAR = 7;
const int ACR_COLLECTION_METHOD_CONTAINS = 8;
const int ACR_COLLECTION_METHOD_CONTAINS_KEY = 9;
const int ACR_COLLECTION_METHOD_CONTAINS_VALUE = 10;
const int ACR_COLLECTION_METHOD_COUNT = 6;
const int ACR_COLLECTION_METHOD_ELEMENT_AT = 11;
const int ACR_COLLECTION_METHOD_FIND = 12;
const int ACR_COLLECTION_METHOD_FIND_LAST = 13;
const int ACR_COLLECTION_METHOD_FIRST = 14;
const int ACR_COLLECTION_METHOD_INDEX_OF = 15;
const int ACR_COLLECTION_METHOD_INSERT = 16;
const int ACR_COLLECTION_METHOD_LAST = 17;
const int ACR_COLLECTION_METHOD_LAST_INDEX_OF = 18;
const int ACR_COLLECTION_METHOD_MAX = 19;
const int ACR_COLLECTION_METHOD_MIN = 20;
const int ACR_COLLECTION_METHOD_PEEK = 21;
const int ACR_COLLECTION_METHOD_POP = 22;
const int ACR_COLLECTION_METHOD_PUSH = 23;
const int ACR_COLLECTION_METHOD_REMOVE = 24;
const int ACR_COLLECTION_METHOD_REMOVE_AT = 25;
const int ACR_COLLECTION_METHOD_REMOVE_RANGE = 26;
const int ACR_COLLECTION_METHOD_REVERSE = 27;
const int ACR_COLLECTION_METHOD_SET_AT_INDEX = 28;
const int ACR_COLLECTION_METHOD_SORT = 29;
const int ACR_COLLECTION_METHOD_SUM = 30;

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
// INTEGER LIST
//

void ACR_IntList_Create( string sName );
void ACR_IntList_Delete( string sName );
int ACR_IntList_Exists( string sName );
void ACR_IntList_Add( string sName, int nValue );
void ACR_IntList_Clear( string sName );
int ACR_IntList_Contains( string sName, int nValue );
int ACR_IntList_Count( string sName );
int ACR_IntList_ElementAt( string sName, int nIndex );
int ACR_IntList_First( string sName );
int ACR_IntList_IndexOf( string sName, int nValue );
void ACR_IntList_Insert( string sName, int nIndex, int nValue );
int ACR_IntList_Max( string sName );
int ACR_IntList_Min( string sName );
void ACR_IntList_Remove( string sName, int nValue );
void ACR_IntList_RemoveAt( string sName, int nIndex );
void ACR_IntList_RemoveRange( string sName, int nIndex, int nCount );
void ACR_IntList_Reverse( string sName );
void ACR_IntList_Sort( string sName );
int ACR_IntList_Sum( string sName );


//
// FLOAT LIST
//

void ACR_FloatList_Create( string sName );
void ACR_FloatList_Delete( string sName );
int ACR_FloatList_Exists( string sName );
void ACR_FloatList_Add( string sName, float fValue );
void ACR_FloatList_Clear( string sName );
int ACR_FloatList_Contains( string sName, float fValue );
int ACR_FloatList_Count( string sName );
float ACR_FloatList_ElementAt( string sName, int nIndex );
float ACR_FloatList_First( string sName );
int ACR_FloatList_IndexOf( string sName, float fValue );
void ACR_FloatList_Insert( string sName, int nIndex, float fValue );
float ACR_FloatList_Max( string sName );
float ACR_FloatList_Min( string sName );
void ACR_FloatList_Remove( string sName, float fValue );
void ACR_FloatList_RemoveAt( string sName, int nIndex );
void ACR_FloatList_RemoveRange( string sName, int nIndex, int nCount );
void ACR_FloatList_Reverse( string sName );
void ACR_FloatList_Sort( string sName );
float ACR_FloatList_Sum( string sName );


//
// STRING LIST
//

void ACR_StringList_Create( string sName );
void ACR_StringList_Delete( string sName );
int ACR_StringList_Exists( string sName );
void ACR_StringList_Add( string sName, string sValue );
void ACR_StringList_Clear( string sName );
int ACR_StringList_Contains( string sName, string sValue );
int ACR_StringList_Count( string sName );
string ACR_StringList_ElementAt( string sName, int nIndex );
string ACR_StringList_First( string sName );
int ACR_StringList_IndexOf( string sName, string sValue );
void ACR_StringList_Insert( string sName, int nIndex, string sValue );
void ACR_StringList_Remove( string sName, string sValue );
void ACR_StringList_RemoveAt( string sName, int nIndex );
void ACR_StringList_RemoveRange( string sName, int nIndex, int nCount );
void ACR_StringList_Reverse( string sName );
void ACR_StringList_Sort( string sName );


////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! Main interface with the ACR_CollectionLib managed script. The variables are
//! different depending on what you are trying to accomplish. It is not
//! recommended that you change anything with this function unless you know
//! what you are doing.
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


// Begin IntList


void ACR_IntList_Create( string sName ) {
	ACR_CallCollectionLib( ACR_COLLECTION_INT_LIST, ACR_COLLECTION_METHOD_CREATE, sName );
}


void ACR_IntList_Delete( string sName ) {
	ACR_CallCollectionLib( ACR_COLLECTION_INT_LIST, ACR_COLLECTION_METHOD_DELETE, sName );
}


int ACR_IntList_Exists( string sName ) {
	ACR_CallCollectionLib( ACR_COLLECTION_INT_LIST, ACR_COLLECTION_METHOD_EXISTS, sName );
	return ACR_GetCollectionResultInt();
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
	ACR_CallCollectionLib( ACR_COLLECTION_INT_LIST, ACR_COLLECTION_METHOD_ELEMENT_AT, sName, nIndex );
	return ACR_GetCollectionResultInt();
}


int ACR_IntList_First( string sName ) {
	ACR_CallCollectionLib( ACR_COLLECTION_INT_LIST, ACR_COLLECTION_METHOD_FIRST, sName );
	return ACR_GetCollectionResultInt();
}


int ACR_IntList_IndexOf( string sName, int nValue ) {
	ACR_CallCollectionLib( ACR_COLLECTION_INT_LIST, ACR_COLLECTION_METHOD_ELEMENT_AT, sName, nValue );
	return ACR_GetCollectionResultInt();
}


void ACR_IntList_Insert( string sName, int nIndex, int nValue ) {
	ACR_CallCollectionLib( ACR_COLLECTION_INT_LIST, ACR_COLLECTION_METHOD_INSERT, sName, nIndex, nValue );
}


int ACR_IntList_Max( string sName ) {
	ACR_CallCollectionLib( ACR_COLLECTION_INT_LIST, ACR_COLLECTION_METHOD_MAX, sName );
	return ACR_GetCollectionResultInt();
}


int ACR_IntList_Min( string sName ) {
	ACR_CallCollectionLib( ACR_COLLECTION_INT_LIST, ACR_COLLECTION_METHOD_MIN, sName );
	return ACR_GetCollectionResultInt();
}


void ACR_IntList_Remove( string sName, int nValue ) {
	ACR_CallCollectionLib( ACR_COLLECTION_INT_LIST, ACR_COLLECTION_METHOD_REMOVE, sName, nValue );
}


void ACR_IntList_RemoveAt( string sName, int nIndex ) {
	ACR_CallCollectionLib( ACR_COLLECTION_INT_LIST, ACR_COLLECTION_METHOD_REMOVE_AT, sName, nIndex );
}


void ACR_IntList_RemoveRange( string sName, int nIndex, int nCount ) {
	ACR_CallCollectionLib( ACR_COLLECTION_INT_LIST, ACR_COLLECTION_METHOD_REMOVE_AT, sName, nIndex, nCount );
}


void ACR_IntList_Reverse( string sName ) {
	ACR_CallCollectionLib( ACR_COLLECTION_INT_LIST, ACR_COLLECTION_METHOD_REVERSE, sName );
}


void ACR_IntList_Sort( string sName ) {
	ACR_CallCollectionLib( ACR_COLLECTION_INT_LIST, ACR_COLLECTION_METHOD_SORT, sName );
}


int ACR_IntList_Sum( string sName ) {
	ACR_CallCollectionLib( ACR_COLLECTION_INT_LIST, ACR_COLLECTION_METHOD_SUM, sName );
	return ACR_GetCollectionResultInt();
}


// Begin FloatList


void ACR_FloatList_Create( string sName ) {
	ACR_CallCollectionLib( ACR_COLLECTION_FLOAT_LIST, ACR_COLLECTION_METHOD_CREATE, sName );
}


void ACR_FloatList_Delete( string sName ) {
	ACR_CallCollectionLib( ACR_COLLECTION_FLOAT_LIST, ACR_COLLECTION_METHOD_DELETE, sName );
}


int ACR_FloatList_Exists( string sName ) {
	ACR_CallCollectionLib( ACR_COLLECTION_FLOAT_LIST, ACR_COLLECTION_METHOD_EXISTS, sName );
	return ACR_GetCollectionResultInt();
}


void ACR_FloatList_Add( string sName, float fValue ) {
	ACR_CallCollectionLib( ACR_COLLECTION_FLOAT_LIST, ACR_COLLECTION_METHOD_DELETE, sName );
}


void ACR_FloatList_Clear( string sName ) {
	ACR_CallCollectionLib( ACR_COLLECTION_FLOAT_LIST, ACR_COLLECTION_METHOD_CLEAR, sName );
}


int ACR_FloatList_Contains( string sName, float fValue ) {
	ACR_CallCollectionLib( ACR_COLLECTION_FLOAT_LIST, ACR_COLLECTION_METHOD_CONTAINS, sName, 0, 0, fValue );
	return ACR_GetCollectionResultInt();
}


int ACR_FloatList_Count( string sName ) {
	ACR_CallCollectionLib( ACR_COLLECTION_FLOAT_LIST, ACR_COLLECTION_METHOD_COUNT, sName );
	return ACR_GetCollectionResultInt();
}


float ACR_FloatList_ElementAt( string sName, int nIndex ) {
	ACR_CallCollectionLib( ACR_COLLECTION_FLOAT_LIST, ACR_COLLECTION_METHOD_ELEMENT_AT, sName, nIndex );
	return ACR_GetCollectionResultFloat();
}


float ACR_FloatList_First( string sName ) {
	ACR_CallCollectionLib( ACR_COLLECTION_FLOAT_LIST, ACR_COLLECTION_METHOD_FIRST, sName );
	return ACR_GetCollectionResultFloat();
}


int ACR_FloatList_IndexOf( string sName, float fValue ) {
	ACR_CallCollectionLib( ACR_COLLECTION_FLOAT_LIST, ACR_COLLECTION_METHOD_INDEX_OF, sName, 0, 0, fValue );
	return ACR_GetCollectionResultInt();
}


void ACR_FloatList_Insert( string sName, int nIndex, float fValue ) {
	ACR_CallCollectionLib( ACR_COLLECTION_FLOAT_LIST, ACR_COLLECTION_METHOD_INSERT, sName, nIndex, 0, fValue );
}


float ACR_FloatList_Max( string sName ) {
	ACR_CallCollectionLib( ACR_COLLECTION_FLOAT_LIST, ACR_COLLECTION_METHOD_MAX, sName );
	return ACR_GetCollectionResultFloat();
}


float ACR_FloatList_Min( string sName ) {
	ACR_CallCollectionLib( ACR_COLLECTION_FLOAT_LIST, ACR_COLLECTION_METHOD_MIN, sName );
	return ACR_GetCollectionResultFloat();
}


void ACR_FloatList_Remove( string sName, float fValue ) {
	ACR_CallCollectionLib( ACR_COLLECTION_FLOAT_LIST, ACR_COLLECTION_METHOD_REMOVE, sName, 0, 0, fValue );
}


void ACR_FloatList_RemoveAt( string sName, int nIndex ) {
	ACR_CallCollectionLib( ACR_COLLECTION_FLOAT_LIST, ACR_COLLECTION_METHOD_REMOVE_AT, sName, nIndex );
}


void ACR_FloatList_RemoveRange( string sName, int nIndex, int nCount ) {
	ACR_CallCollectionLib( ACR_COLLECTION_FLOAT_LIST, ACR_COLLECTION_METHOD_REMOVE_RANGE, sName, nIndex, nCount );
}


void ACR_FloatList_Reverse( string sName ) {
	ACR_CallCollectionLib( ACR_COLLECTION_FLOAT_LIST, ACR_COLLECTION_METHOD_REVERSE, sName );
}


void ACR_FloatList_Sort( string sName ) {
	ACR_CallCollectionLib( ACR_COLLECTION_FLOAT_LIST, ACR_COLLECTION_METHOD_SORT, sName );
}


float ACR_FloatList_Sum( string sName ) {
	ACR_CallCollectionLib( ACR_COLLECTION_FLOAT_LIST, ACR_COLLECTION_METHOD_SUM, sName );
	return ACR_GetCollectionResultFloat();
}


// Begin StringList


void ACR_StringList_Create( string sName ) {
	ACR_CallCollectionLib( ACR_COLLECTION_STRING_LIST, ACR_COLLECTION_METHOD_CREATE, sName );
}


void ACR_StringList_Delete( string sName ) {
	ACR_CallCollectionLib( ACR_COLLECTION_STRING_LIST, ACR_COLLECTION_METHOD_DELETE, sName );
}


int ACR_StringList_Exists( string sName ) {
	ACR_CallCollectionLib( ACR_COLLECTION_STRING_LIST, ACR_COLLECTION_METHOD_EXISTS, sName );
	return ACR_GetCollectionResultInt();
}


void ACR_StringList_Add( string sName, string sValue ) {
	ACR_CallCollectionLib( ACR_COLLECTION_STRING_LIST, ACR_COLLECTION_METHOD_DELETE, sName );
}


void ACR_StringList_Clear( string sName ) {
	ACR_CallCollectionLib( ACR_COLLECTION_STRING_LIST, ACR_COLLECTION_METHOD_CLEAR, sName );
}


int ACR_StringList_Contains( string sName, string sValue ) {
	ACR_CallCollectionLib( ACR_COLLECTION_STRING_LIST, ACR_COLLECTION_METHOD_CONTAINS, sName, 0, 0, 0.0f, 0.0f, sValue );
	return ACR_GetCollectionResultInt();
}


int ACR_StringList_Count( string sName ) {
	ACR_CallCollectionLib( ACR_COLLECTION_STRING_LIST, ACR_COLLECTION_METHOD_COUNT, sName );
	return ACR_GetCollectionResultInt();
}


string ACR_StringList_ElementAt( string sName, int nIndex ) {
	ACR_CallCollectionLib( ACR_COLLECTION_STRING_LIST, ACR_COLLECTION_METHOD_ELEMENT_AT, sName, nIndex );
	return ACR_GetCollectionResultString();
}


string ACR_StringList_First( string sName ) {
	ACR_CallCollectionLib( ACR_COLLECTION_STRING_LIST, ACR_COLLECTION_METHOD_FIRST, sName );
	return ACR_GetCollectionResultString();
}


int ACR_StringList_IndexOf( string sName, string sValue ) {
	ACR_CallCollectionLib( ACR_COLLECTION_STRING_LIST, ACR_COLLECTION_METHOD_INDEX_OF, sName, 0, 0, 0.0f, 0.0f, sValue );
	return ACR_GetCollectionResultInt();
}


void ACR_StringList_Insert( string sName, int nIndex, string sValue ) {
	ACR_CallCollectionLib( ACR_COLLECTION_STRING_LIST, ACR_COLLECTION_METHOD_INSERT, sName, nIndex, 0, 0.0f, 0.0f, sValue );
}


void ACR_StringList_Remove( string sName, string sValue ) {
	ACR_CallCollectionLib( ACR_COLLECTION_STRING_LIST, ACR_COLLECTION_METHOD_REMOVE, sName, 0, 0, 0.0f, 0.0f, sValue );
}


void ACR_StringList_RemoveAt( string sName, int nIndex ) {
	ACR_CallCollectionLib( ACR_COLLECTION_STRING_LIST, ACR_COLLECTION_METHOD_REMOVE_AT, sName, nIndex );
}


void ACR_StringList_RemoveRange( string sName, int nIndex, int nCount ) {
	ACR_CallCollectionLib( ACR_COLLECTION_STRING_LIST, ACR_COLLECTION_METHOD_REMOVE_RANGE, sName, nIndex, nCount );
}


void ACR_StringList_Reverse( string sName ) {
	ACR_CallCollectionLib( ACR_COLLECTION_STRING_LIST, ACR_COLLECTION_METHOD_REVERSE, sName );
}


void ACR_StringList_Sort( string sName ) {
	ACR_CallCollectionLib( ACR_COLLECTION_STRING_LIST, ACR_COLLECTION_METHOD_SORT, sName );
}


#endif