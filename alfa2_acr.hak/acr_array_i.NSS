////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_array_i.nss
//      Version : 0.1
//         Date : 4/2/06
//       Author : Ronan
//
//  Local Variable Prefix = ACR_ARY
//  To prevent local variable name conflicts, we define the prefix used for
//  all local variables of this system here.
//
//  Description
//  These functions deal with the storage and retrieval of arrays stored on
//  in-game objects.
//
//  Revision History
////////////////////////////////////////////////////////////////////////////////

#ifndef ACR_ARRAY_I
#define ACR_ARRAY_I

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// Gets the string value at index nIndex, on the local array of name sVarName
// stored on object oObject.
// Returns "" on error.
string GetLocalArrayString(object oObject, string sVarName, int nIndex);

// Gets the int value at index nIndex, on the local array of name sVarName
// stored on object oObject.
// Returns 0 on error.
int GetLocalArrayInt(object oObject, string sVarName, int nIndex);

// Gets the float value at index nIndex, on the local array of name sVarName
// stored on object oObject.
// Returns 0.0 on error.
float GetLocalArrayFloat(object oObject, string sVarName, int nIndex);

// Gets the location value at index nIndex, on the local array of name sVarName
// stored on object oObject.
// The location returned on an error is not reliable!
location GetLocalArrayLocation(object oObject, string sVarName, int nIndex);

// Gets the object value at index nIndex, on the local array of name sVarName
// stored on object oObject.
// Returns OBJECT_INVALID on error.
object GetLocalArrayObject(object oObject, string sVarName, int nIndex);

// Sets the int value at index nIndex from array sVarName on object oObject to
// nValue.
void SetLocalArrayInt(object oObject, string sVarName, int nIndex, int nValue);

// Sets the float value at index nIndex from array sVarName on object oObject to
// nValue.
void SetLocalArrayFloat(object oObject, string sVarName, int nIndex, float nValue);

// Sets the object value at index nIndex from array sVarName on object oObject
// to oValue.
void SetLocalArrayObject(object oObject, string sVarName, int nIndex, object oValue);

// Sets the location value at index nIndex from array sVarName on object oObject
// to lValue.
void SetLocalArrayLocation(object oObject, string sVarName, int nIndex, location lValue);

// Sets the srting value at index nIndex from array sVarName on object oObject
// to sValue.
void SetLocalArrayString(object oObject, string sVarName, int nIndex, string sValue);

// Deletes the local int stored in array sVarName, on object oObject with
// index nIndex.
void DeleteLocalArrayInt(object oObject, string sVarName, int nIndex);

// Deletes the local float stored in array sVarName, on object oObject with
// index nIndex.
void DeleteLocalArrayFloat(object oObject, string sVarName, int nIndex);

// Deletes the local string stored in array sVarName, on object oObject with
// index nIndex.
void DeleteLocalArrayString(object oObject, string sVarName, int nIndex);

// Deletes the local location stored in array sVarName, on object oObject with
// index nIndex.
void DeleteLocalArrayLocation(object oObject, string sVarName, int nIndex);

// Deletes the local object stored in array sVarName, on object oObject with
// index nIndex.
void DeleteLocalArrayObject(object oObject, string sVarName, int nIndex);

// Deletes nNumToDelete local ints stored in array sVarName, on object oObject
// starting at  index nIndex.
void DeleteLocalArrayInts(object oObject, string sVarName, int nNumToDelete, int nIndex = 0);

// Deletes nNumToDelete local floats stored in array sVarName, on object oObject
// starting at index nIndex.
void DeleteLocalArrayFloats(object oObject, string sVarName, int nNumToDelete, int nIndex = 0);

// Deletes nNumToDelete local strings stored in array sVarName, on object oObject
// starting at index nIndex.
void DeleteLocalArrayStrings(object oObject, string sVarName, int nNumToDelete, int nIndex = 0);

// Deletes nNumToDelete local locations stored in array sVarName, on object
// starting at with index nIndex.
void DeleteLocalArrayLocations(object oObject, string sVarName, int nNumToDelete, int nIndex = 0);

// Deletes nNumToDelete local objects stored in array sVarName, on object oObject
// starting at index nIndex.
void DeleteLocalArrayObjects(object oObject, string sVarName, int nNumToDelete, int nIndex = 0);

// Loads nLength elements of array sVarName on oObject as custom conversation
// tokens, starting with nStartToken.
// The loading can start at an index other than 0 if nStartIndex is defined.
void LoadStringArrayIntoCustomTokens(object oObject, string sVarName, int nLength, int nStartToken, int nStartIndex = 0);

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

string GetLocalArrayString(object oObject, string sVarName, int nIndex) {
    return GetLocalString(oObject, sVarName + IntToString(nIndex));
}

int GetLocalArrayInt(object oObject, string sVarName, int nIndex) {
    return GetLocalInt(oObject, sVarName + IntToString(nIndex));
}

float GetLocalArrayFloat(object oObject, string sVarName, int nIndex) {
    return GetLocalFloat(oObject, sVarName + IntToString(nIndex));
}

location GetLocalArrayLocation(object oObject, string sVarName, int nIndex) {
    return GetLocalLocation(oObject, sVarName + IntToString(nIndex));
}

object GetLocalArrayObject(object oObject, string sVarName, int nIndex) {
    return GetLocalObject(oObject, sVarName + IntToString(nIndex));
}

void SetLocalArrayInt(object oObject, string sVarName, int nIndex, int nValue) {
    SetLocalInt(oObject, sVarName + IntToString(nIndex), nValue);
}

void SetLocalArrayFloat(object oObject, string sVarName, int nIndex, float nValue) {
    SetLocalFloat(oObject, sVarName + IntToString(nIndex), nValue);
}

void SetLocalArrayObject(object oObject, string sVarName, int nIndex, object oValue) {
    SetLocalObject(oObject, sVarName + IntToString(nIndex), oValue);
}

void SetLocalArrayLocation(object oObject, string sVarName, int nIndex, location lValue) {
    SetLocalLocation(oObject, sVarName + IntToString(nIndex), lValue);
}

void SetLocalArrayString(object oObject, string sVarName, int nIndex, string sValue) {
    SetLocalString(oObject, sVarName + IntToString(nIndex), sValue);
}

void DeleteLocalArrayInt(object oObject, string sVarName, int nIndex) {
    DeleteLocalInt(oObject, sVarName + IntToString(nIndex));
}

void DeleteLocalArrayFloat(object oObject, string sVarName, int nIndex) {
    DeleteLocalFloat(oObject, sVarName + IntToString(nIndex));
}

void DeleteLocalArrayString(object oObject, string sVarName, int nIndex) {
    DeleteLocalString(oObject, sVarName + IntToString(nIndex));
}

void DeleteLocalArrayLocation(object oObject, string sVarName, int nIndex) {
    DeleteLocalLocation(oObject, sVarName + IntToString(nIndex));
}

void DeleteLocalArrayObject(object oObject, string sVarName, int nIndex) {
    DeleteLocalObject(oObject, sVarName + IntToString(nIndex));
}

void DeleteLocalArrayInts(object oObject, string sVarName, int nNumToDelete, int nIndex = 0) {
    int nStopAt;
    for(nStopAt = nNumToDelete + nIndex; nIndex < nStopAt; nIndex++) {
        DeleteLocalArrayInt(oObject, sVarName, nIndex);
    }
}

void DeleteLocalArrayFloats(object oObject, string sVarName, int nNumToDelete, int nIndex = 0) {
    int nStopAt;
    for(nStopAt = nNumToDelete + nIndex; nIndex < nStopAt; nIndex++) {
        DeleteLocalArrayFloat(oObject, sVarName, nIndex);
    }
}

void DeleteLocalArrayStrings(object oObject, string sVarName, int nNumToDelete, int nIndex = 0) {
    int nStopAt;
    for(nStopAt = nNumToDelete + nIndex; nIndex < nStopAt; nIndex++) {
        DeleteLocalArrayString(oObject, sVarName, nIndex);
    }
}

void DeleteLocalArrayLocations(object oObject, string sVarName, int nNumToDelete, int nIndex = 0) {
    int nStopAt;
    for(nStopAt = nNumToDelete + nIndex; nIndex < nStopAt; nIndex++) {
        DeleteLocalArrayLocation(oObject, sVarName, nIndex);
    }
}
void DeleteLocalArrayObjects(object oObject, string sVarName, int nNumToDelete, int nIndex = 0) {
    int nStopAt;
    for(nStopAt = nNumToDelete + nIndex; nIndex < nStopAt; nIndex++) {
        DeleteLocalArrayObject(oObject, sVarName, nIndex);
    }
}

void LoadStringArrayIntoCustomTokens(object oObject, string sVarName, int nLength, int nStartToken, int nStartIndex = 0) {
    int i;
    for(i=nStartIndex; i<nLength; i++) {
        SetCustomToken(nStartToken, GetLocalArrayString(oObject, sVarName, i));
        nStartToken++;
    }
}

#endif