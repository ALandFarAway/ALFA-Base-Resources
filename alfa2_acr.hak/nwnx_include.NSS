// Name     : NWNX include
// Purpose  : Functions for querying NWNX status and installed plugins
// Author   : Ingmar Stieger
// Modified : 04/29/2007
// Copyright: This file is licensed under the terms of the
//            GNU GENERAL PUBLIC LICENSE (GPL) Version 2
/**/

// return TRUE if NWNX is installed
int NWNXInstalled()
{
    return NWNXGetInt("NWNX", "INSTALLED", "", 0);
}

// return number of registered plugins / function classes
int NWNXGetPluginCount()
{
    return NWNXGetInt("NWNX", "GET PLUGIN COUNT", "", 0);    
}

// return function class specified by parameter nPlugin
string NWNXGetPluginClass(int nPlugin)
{
    return NWNXGetString("NWNX", "GET PLUGIN CLASS", "", nPlugin);
}

string NWNXGetPluginSubClass(string sClass)
{
	//SetLocalString(GetModule(), "NWNX!" + sClass + "!GET_SUBCLASS", sSpacer);
	//return(GetLocalString(GetModule(), "NWNX!" + sClass + "!GET_SUBCLASS"));
    
    return NWNXGetString(sClass, "GET SUBCLASS", "", 0);
}

string NWNXGetPluginVersion(string sClass)
{
	//SetLocalString(GetModule(), "NWNX!" + sClass + "!GET_VERSION", sSpacer);
	//return(GetLocalString(GetModule(), "NWNX!" + sClass + "!GET_VERSION"));
    return NWNXGetString(sClass, "GET VERSION", "", 0);
}

string NWNXGetPluginDescription(string sClass)
{
    /*
	int i;
    string sBigSpacer;
	
    // Create placeholder for (possibly) long descriptions
    for (i = 0; i < 8; i++)     // reserve 8*128 bytes
       	sBigSpacer += sSpacer;
    
	SetLocalString(GetModule(), "NWNX!" + sClass + "!GET_DESCRIPTION", sBigSpacer);
	return(GetLocalString(GetModule(), "NWNX!" + sClass + "!GET_DESCRIPTION"));
    */
    return NWNXGetString(sClass, "GET DESCRIPTION", "", 0);
}