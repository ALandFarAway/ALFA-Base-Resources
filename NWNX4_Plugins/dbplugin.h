/***************************************************************************
    NWNX Database plugin - Generic base class for database plugins
    Copyright (C) 2007 Ingmar Stieger (Papillon, papillon@blackdagger.com) 

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
#if !defined(DBPLUGIN_H_INCLUDED)
#define DBPLUGIN_H_INCLUDED

#define DLLEXPORT extern "C" __declspec(dllexport)

#include "windows.h"
#include "plugin.h"
#include "../misc/log.h"
#include "wx/tokenzr.h"
#include "wx/fileconf.h"
#include "scorcohook.h"

#define BUFFER_SIZE 1024*64
#define MAXSQL 1024

class DBPlugin : public Plugin
{
public:
	DBPlugin();
	~DBPlugin();

	bool SetupLogAndIniFile(TCHAR* nwnxhome);  

	int GetInt(char* sFunction, char* sParam1, int nParam2);
	void SetInt(char* sFunction, char* sParam1, int nParam2, int nValue) {};
	float GetFloat(char* sFunction, char* sParam1, int nParam2) { return 0.0; }
	void SetFloat(char* sFunction, char* sParam1, int nParam2, float fValue) {};
	void SetString(char* sFunction, char* sParam1, int nParam2, char* sValue);
	char* GetString(char* sFunction, char* sParam1, int nParam2);
	virtual BOOL WriteScorcoData(BYTE* pData, int Length);
	virtual BYTE* ReadScorcoData(char *param, int *size);

	void GetFunctionClass(TCHAR* fClass);

protected:
	wxLogNWNX* logger;
	wxFileConfig *config;
	int logLevel;
	char scorcoSQL[MAXSQL];

	virtual bool Execute(char* query);
	virtual int Fetch(char* buffer);
	virtual int GetData(int iCol, char* buffer);
	virtual int GetAffectedRows();
	virtual void GetEscapeString(char* str, char* buffer);
	void SetScorcoSQL(char *request);
};

#endif