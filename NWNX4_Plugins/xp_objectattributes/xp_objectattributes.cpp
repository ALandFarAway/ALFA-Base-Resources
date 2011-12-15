/***************************************************************************
    NWNX ObjectAttributes - NWN2Server Game Object Attributes Editor
    Copyright (C) 2008-2011 Skywing (skywing@valhallalegends.com).  This
    instance of the core XPObjectAttributes functionality is licensed under the
    GPLv2 for the usage of the NWNX4 project, nonwithstanding other licenses
    granted by the copyright holder. 

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

 ***************************************************************************/

#include "xp_objectattributes.h"

#define PLUGIN_VERSION "0.0.1"

ObjectAttributesPlugin *plugin;
			

/***************************************************************************
    NWNX and DLL specific functions
***************************************************************************/

DLLEXPORT Plugin* GetPluginPointerV2()
{
	return plugin;
}

BOOL APIENTRY DllMain(HMODULE hModule, DWORD ul_reason_for_call, LPVOID lpReserved)
{
	if (ul_reason_for_call == DLL_PROCESS_ATTACH)
	{
		plugin = new ObjectAttributesPlugin();

		TCHAR szPath[MAX_PATH];
		GetModuleFileName(hModule, szPath, MAX_PATH);
		plugin->SetPluginFullPath(szPath);
	}
	else if (ul_reason_for_call == DLL_PROCESS_DETACH)
	{
		delete plugin;
	}
    return TRUE;
}


/***************************************************************************
    Implementation of ObjectAttributes Plugin
***************************************************************************/

ObjectAttributesPlugin::ObjectAttributesPlugin()
{
	header = _T(
		"NWNX ObjectAttributes Plugin " _T( PLUGIN_VERSION) _T( "\n" ) \
		"(c) 2008-2011 by Skywing \n" \
		"Visit NWNX at: http://www.nwnx.org\n");

	description = _T("This plugin provides scripting support functionality to edit game object attributes.");

	subClass = _T("NWNX4-ObjectAttributes");
	version  = _T(PLUGIN_VERSION);
}

ObjectAttributesPlugin::~ObjectAttributesPlugin()
{
	wxLogMessage(wxT("* Plugin unloaded."));
}

bool ObjectAttributesPlugin::Init(TCHAR* nwnxhome)
{
	assert(GetPluginFileName());

	/* Log file */
	wxString logfile(nwnxhome); 
	logfile.append(wxT("\\"));
	logfile.append(GetPluginFileName());
	logfile.append(wxT(".txt"));
	logger = new wxLogNWNX(logfile, wxString(header.c_str()), false, true);

	wxLogMessage(wxT("* Plugin initialized."));
	return true;
}

void ObjectAttributesPlugin::GetFunctionClass(TCHAR* fClass)
{
	_tcsncpy_s(fClass, 128, wxT("OBJECTATTRIBUTES"), 16); 
}

void ObjectAttributesPlugin::SetString(char* sFunction, char* sParam1, int nParam2, char* sValue)
{
	wxLogTrace(TRACE_VERBOSE, wxT("* Plugin SetString(0x%x, %s, %d, %s)"), 0x0, sParam1, nParam2, sValue);

	//
	// Invoke the main dispatcher.
	//

	OnXPObjectAttributesSetString(
		"OBJECTATTRIBUTES",
		sFunction,
		sParam1,
		nParam2,
		sValue);
}

char* ObjectAttributesPlugin::GetString(char* sFunction, char* sParam1, int nParam2)
{
	std::string ReturnString;

	wxLogTrace(TRACE_VERBOSE, wxT("* Plugin GetString(0x%x, %s, %d)"), 0x0, sParam1, nParam2);

	ReturnString = XPOnObjectAttributesGetString(
		"OBJECTATTRIBUTES",
		sFunction,
		sParam1,
		nParam2);

	m_ReturnString = ReturnString;

	return (char*) m_ReturnString.c_str( );
}
