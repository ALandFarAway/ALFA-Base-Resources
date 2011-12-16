/***************************************************************************
    NWNX Database plugin - Generic base class for database plugins
    Copyright (C) 2007 Ingmar Stieger (Papillon, papillon@nwnx.org)

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

#include "dbplugin.h"

/***************************************************************************
    Implementation of DBPlugin
***************************************************************************/

DBPlugin::DBPlugin()
{
	header = _T("NWNX Base DB Plugin V.1.1");
	subClass = _T("DBPlugin");
	version = _T("1.1");
	description = _T("Overwrite this constructor in your derived plugin class.");
	logLevel = 0;
}

DBPlugin::~DBPlugin()
{
	delete config;
	wxLogMessage(wxT("* Plugin unloaded."));
}

bool DBPlugin::SetupLogAndIniFile(TCHAR* nwnxhome)
{
	assert(GetPluginFileName());

	/* Log file */
	wxString logfile(nwnxhome); 
	logfile.append(wxT("\\"));
	logfile.append(GetPluginFileName());
	logfile.append(wxT(".txt"));
	logger = new wxLogNWNX(logfile, wxString(header.c_str()));

	/* Ini file */
	wxString inifile(nwnxhome); 
	inifile.append(wxT("\\"));
	inifile.append(GetPluginFileName());
	inifile.append(wxT(".ini"));
	wxLogTrace(TRACE_VERBOSE, wxT("* reading inifile %s"), inifile);

	config = new wxFileConfig(wxEmptyString, wxEmptyString, 
		inifile, wxEmptyString, wxCONFIG_USE_LOCAL_FILE|wxCONFIG_USE_NO_ESCAPE_CHARACTERS);
	
	config->Read(wxT("loglevel"), &logLevel);
	switch(logLevel)
	{
		case 0: wxLogMessage(wxT("* Log level set to 0 (nothing)")); break;
		case 1: wxLogMessage(wxT("* Log level set to 1 (only errors)")); break;
		case 2: wxLogMessage(wxT("* Log level set to 2 (everything)")); break;
	}
	return true;
}

void DBPlugin::GetFunctionClass(TCHAR* fClass)
{
	wxString myClass;
	if (config->Read(wxT("class"), &myClass) )
	{
		wxLogMessage(wxT("* Registering under function class %s"), myClass);
		_tcsncpy_s(fClass, 128, myClass, myClass.length());
	}
	else
	{
		wxString default(wxT("SQL"));
		_tcsncpy_s(fClass, 128, default, default.length()); 
	}
}

int DBPlugin::GetInt(char* sFunction, char* sParam1, int nParam2)
{
	wxLogTrace(TRACE_VERBOSE, wxT("* Plugin GetInt(0x%x, %s, %d)"), 0x0, sParam1, nParam2);

#ifdef UNICODE
	wxString function(sFunction, wxConvUTF8);
#else
	wxString function(sFunction);
#endif

	if (function == wxT(""))
	{
		wxLogMessage(wxT("* Function not specified."));
		return -1;
	}

	if (function == wxT("FETCH"))
		return Fetch(sParam1);
	else if (function == wxT("GET AFFECTED ROWS"))
		return GetAffectedRows();

	return 0;

}

void DBPlugin::SetString(char* sFunction, char* sParam1, int nParam2, char* sValue)
{
	wxLogTrace(TRACE_VERBOSE, wxT("* Plugin SetString(0x%x, %s, %d, %s)"), 0x0, sParam1, nParam2, sValue);

#ifdef UNICODE
	wxString function(sFunction, wxConvUTF8);
#else
	wxString function(sFunction);
#endif

	if (function == wxT(""))
	{
		wxLogMessage(wxT("* Function not specified."));
		return;
	}

	if (function == wxT("EXEC"))
		Execute(sParam1);
	else if (function == wxT("SETSCORCOSQL"))
		SetScorcoSQL(sParam1);
}

char* DBPlugin::GetString(char* sFunction, char* sParam1, int nParam2)
{
	wxLogTrace(TRACE_VERBOSE, wxT("* Plugin GetString(0x%x, %s, %d)"), 0x0, sParam1, nParam2);

#ifdef UNICODE
	wxString function(sFunction, wxConvUTF8);
	wxString param1(sParam1, wxConvUTF8);
#else
	wxString function(sFunction);
	wxString param1(sParam1);
#endif

	if (function == wxT(""))
	{
		wxLogMessage(wxT("* Function not specified."));
		return NULL;
	}

	if (function == wxT("GETDATA"))
	{
		GetData(nParam2, returnBuffer);
	}
	else if (function == wxT("GET ESCAPE STRING"))
		GetEscapeString(sParam1, returnBuffer);
	else
	{
		// Process generic functions
		wxString query = ProcessQueryFunction(function.c_str());
		if (query != wxT(""))
		{
			sprintf_s(returnBuffer, MAX_BUFFER, "%s", query);
		}
		else
		{
			wxLogMessage(wxT("* Unknown function '%s' called."), function);
			return NULL;
		}
	}

	return returnBuffer;
}

bool DBPlugin::Execute(char* query)
{
	return FALSE;
}

int DBPlugin::GetAffectedRows()
{
	return -1;
}

int DBPlugin::Fetch(char* buffer)
{
	return -1;
}

int DBPlugin::GetData(int iCol, char* buffer)
{
	return -1;
}

void DBPlugin::GetEscapeString(char* str, char* buffer)
{
}

BOOL DBPlugin::WriteScorcoData(BYTE* pData, int Length)
{
	return 0;
}

BYTE* DBPlugin::ReadScorcoData(char *param, int *size)
{
	return NULL;
}

void DBPlugin::SetScorcoSQL(char *request)
{
	if(strlen(request) < MAXSQL)
		memcpy(scorcoSQL, request, strlen(request) + 1);
	else
		memcpy(scorcoSQL, request, MAXSQL);
}
