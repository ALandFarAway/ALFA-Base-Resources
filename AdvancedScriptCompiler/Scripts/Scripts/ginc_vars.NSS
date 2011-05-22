// ginc_vars
/*
    Global/local variable related functions
*/
// ChazM 9/22/05
// ChazM 10/01/05 added IsMarkedAsDone(), MarkAsDone(), IsMarkedAsDoneForInt(), MarkAsDoneForInt()
// ChazM 1/31/06 added GetGlobalArrayString(), SetGlobalArrayString(), GetGlobalArrayInt(), SetGlobalArrayInt()
// ChazM 9/11/06 added GetDoneFlag(); added params to IsMarkedAsDone(), MarkAsDone(); removed IsMarkedAsDoneForInt(), MarkAsDoneForInt()
// ChazM 9/11/06 added error messages for IsMarkedAsDone(), MarkAsDone()
// ChazM 9/12/06 added DoneFlagSanityCheck(); removed commented code
// ChazM 5/25/07 added MarkAsUndone()
	
//void main() {}

#include "ginc_debug"

const string DONE_ONCE 	= "DoneOnce";
//-------------------------------------------------
// Function Prototypes
//-------------------------------------------------
	
float GetGlobalIntAsFloat(string sVarName);
int ModifyGlobalInt(string sVarName, int iDelta);
int ModifyLocalInt(object oObject, string sVarName, int iDelta);
void ModifyLocalIntOnFaction(object oPC, string sVarName, int iDelta, int bPCOnly=TRUE);

object GetGlobalObject(string sVarName);
void SetGlobalObject(string sVarName, object oObj);
void DeleteGlobalObject(string sVarName);

string GetDoneFlag(int iFlag=0);
void DoneFlagSanityCheck(object oObject);
int IsMarkedAsDone(object oObject=OBJECT_SELF, int iFlag=0);
void MarkAsDone(object oObject=OBJECT_SELF, int iFlag=0);
void MarkAsUndone(object oObject=OBJECT_SELF, int iFlag=0);

string GetGlobalArrayString(string sVarName, int nVarNum);
void SetGlobalArrayString(string sVarName, int nVarNum, string nValue);
int GetGlobalArrayInt(string sVarName, int nVarNum);
void SetGlobalArrayInt(string sVarName, int nVarNum, int nValue);

/*This function gets the beginning of the string up to the first instance of sDelimiter.
For instance, if you pass "f00_wp_to_f03" as the sStringToTest and "_" as the delimiter,
This will return "f00".*/
string GetStringPrefix(string sStringToTest, string sDelimiter = "_");

/*This function gets the end of the string after the final instance of sDelimiter.
For instance, if you pass "f00_wp_to_f03" as the sStringToTest and "_" as the delimiter,
This will return "f03".*/
string GetStringSuffix(string sStringToTest, string sDelimiter = "_");

//-------------------------------------------------
// Function Definitions
//-------------------------------------------------

// return int as float
float GetGlobalIntAsFloat(string sVarName)
{
	return (IntToFloat(GetGlobalInt(sVarName)));
}


// Change value of Global Int by iDelta amount
int ModifyGlobalInt(string sVarName, int iDelta)
{
	int iNewVal = GetGlobalInt(sVarName) + iDelta;
	SetGlobalInt(sVarName, iNewVal);
	return (iNewVal);
}

// Change value of Local Int by iDelta amount
int ModifyLocalInt(object oObject, string sVarName, int iDelta)
{
	int iNewVal = GetLocalInt(oObject, sVarName) + iDelta;
	SetLocalInt(oObject, sVarName, iNewVal);
	return (iNewVal);
}


void ModifyLocalIntOnFaction(object oPC, string sVarName, int iDelta, int bPCOnly=TRUE)
{
    object oPartyMem = GetFirstFactionMember(oPC, bPCOnly);
    while (GetIsObjectValid(oPartyMem)) 
	{
		ModifyLocalInt(oPartyMem, sVarName, iDelta);
        oPartyMem = GetNextFactionMember(oPC, bPCOnly);
    }
}		
	

// hopefully these 3 funcs will be implemented as functions in NWScript
object GetGlobalObject(string sVarName)
{
	object oMod = GetModule();
	return GetLocalObject(oMod, sVarName);
}

void SetGlobalObject(string sVarName, object oObj)
{
	object oMod = GetModule();
	SetLocalObject(oMod, sVarName, oObj);
}

void DeleteGlobalObject(string sVarName)
{
	object oMod = GetModule();
	DeleteLocalObject(oMod, sVarName);
}	

string GetDoneFlag(int iFlag=0)
{
	return(DONE_ONCE + (iFlag==0?"":IntToString(iFlag)));
}

void DoneFlagSanityCheck(object oObject)
{
	int iObjType = GetObjectType(oObject);
	if (iObjType == OBJECT_TYPE_ITEM)
		PrettyError("MarkAsDone()/IsMarkedAsDone() should not be used with items - Use MarkItemAsDone()/IsItemMarkedAsDone(). Name of item passed =" + GetName(oObject));
	if (iObjType == OBJECT_TYPE_INVALID)
		PrettyError("MarkAsDone()/IsMarkedAsDone() is being used with an invalid object type (perhaps the module object).  Item scripts are prone to do this.");
}

// done flags
int IsMarkedAsDone(object oObject=OBJECT_SELF, int iFlag=0)
{
	DoneFlagSanityCheck(oObject);
    int iDoneOnce = GetLocalInt(oObject, GetDoneFlag(iFlag));
	return (iDoneOnce);
}

void MarkAsDone(object oObject=OBJECT_SELF, int iFlag=0)
{
	DoneFlagSanityCheck(oObject);
	SetLocalInt(oObject, GetDoneFlag(iFlag), TRUE);
}

// 
void MarkAsUndone(object oObject=OBJECT_SELF, int iFlag=0)
{
	DoneFlagSanityCheck(oObject);
	SetLocalInt(oObject, GetDoneFlag(iFlag), FALSE);
}


// *** Global Array Functions

// Returns a string, from nVarNum in the array
string GetGlobalArrayString(string sVarName, int nVarNum)
{
    string sFullVarName = sVarName + IntToString(nVarNum) ;
    return GetGlobalString(sFullVarName);
}

// Sets the string at nVarNum position
void SetGlobalArrayString(string sVarName, int nVarNum, string nValue)
{
    string sFullVarName = sVarName + IntToString(nVarNum) ;
    SetGlobalString(sFullVarName, nValue);
}

// Returns an integer, from nVarNum in the array
int GetGlobalArrayInt(string sVarName, int nVarNum)
{
    string sFullVarName = sVarName + IntToString(nVarNum) ;
    return GetGlobalInt(sFullVarName);
}


//    Sets the integer at nVarNum position
void SetGlobalArrayInt(string sVarName, int nVarNum, int nValue)
{
    string sFullVarName = sVarName + IntToString(nVarNum) ;
    SetGlobalInt(sFullVarName, nValue);
}

string GetStringPrefix(string sStringToTest, string sDelimiter = "_")
{
	int i;
	string sResult;
	
	i = FindSubString(sStringToTest, sDelimiter);
		
	return GetStringLeft(sStringToTest, i);	
}

string GetStringSuffix(string sStringToTest, string sDelimiter = "_")
{
	int i=1;
	string sResult, sTemp;
	
	while( i <= GetStringLength(sStringToTest) )
	{
		sResult = GetStringRight(sStringToTest, i);
				
		int nTemp = i+1;
		sTemp = GetStringRight(sStringToTest, nTemp);

		if( TestStringAgainstPattern( sDelimiter + "**", sTemp) )
			return sResult;
		
		else
			i++;
	}
	
	return "";
}