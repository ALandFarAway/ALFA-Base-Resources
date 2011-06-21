// Name     : NWNX Timer include
// Purpose  : Various functions for accessing the Timer plugin
// Authors  : Ingmar Stieger (Papillon)
// Modified : January 11, 2005

// This file is licensed under the terms of the
// GNU GENERAL PUBLIC LICENSE (GPL) Version 2

/************************************/
/* Function prototypes              */
/************************************/

// Start a timer named sName on object oObject
void StartTimer(object oObject, string sName);

// Stop a timer named sName on object oObject
string StopTimer(object oObject, string sName);

// Query a timer named sName on object oObject
string QueryTimer(object oObject, string sName);

const string timeSpacer = "                                               ";

/************************************/
/* Implementation                   */
/************************************/

void StartTimer(object oObject, string sName)
{
    //SetLocalString(oObject, "NWNX!TIME!START!" + sName + ObjectToString(oObject), timeSpacer);
    NWNXSetString("TIME", "START", sName + ObjectToString(oObject), 0, "");
}

string StopTimer(object oObject, string sName)
{
    //SetLocalString(oObject, "NWNX!TIME!STOP!" + sName + ObjectToString(oObject), timeSpacer);
    //return GetLocalString(oObject, "NWNX!TIME!STOP!"  + sName + ObjectToString(oObject));
    return NWNXGetString("TIME", "STOP", sName + ObjectToString(oObject), 0);
}

string QueryTimer(object oObject, string sName)
{
    //SetLocalString(oObject, "NWNX!TIME!QUERY!" + sName + ObjectToString(oObject), timeSpacer);
    //return GetLocalString(oObject, "NWNX!TIME!QUERY!" + sName + ObjectToString(oObject));
    return NWNXGetString("TIME", "QUERY", sName + ObjectToString(oObject), 0);
}