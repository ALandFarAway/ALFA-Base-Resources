/***************************************************************************
    NWNX Plugin - Plugins are derived from this class
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

#include "stdwx.h"
#include "../plugins/plugin.h"

Plugin::Plugin()
{
	pluginFileName = NULL;
	pluginFullPath = NULL;
}

Plugin::~Plugin()
{
}

bool Plugin::Init(TCHAR* parameter)
{
	return true;
}

string Plugin::ProcessQueryFunction(string function)
{
	if (function == _T("GET SUBCLASS"))
		return subClass; 
	else if (function == _T("GET VERSION"))
		return version; 
	else if (function == _T("GET DESCRIPTION"))
		return description;
	else
		return _T("");
}

void Plugin::GetFunctionClass(TCHAR* fClass)
{
	fClass = NULL;
}

TCHAR* Plugin::GetPluginFileName()
{
	return pluginFileName;
}

TCHAR* Plugin::GetPluginFullPath()
{
	return pluginFullPath;
}

void Plugin::SetPluginFullPath(TCHAR* fileName)
{
	// TODO: replace with _splitpath
	pluginFullPath = _tcsdup(fileName);

	// extract filename from full path
	int len = (int)_tcslen(fileName) - 1;
	if (len > 0)
	{
		int begin = -1, end = -1;
		for (int i = len; i >= 0; i--)
		{
			if ((end == -1) && (fileName[i] == '.'))
				end = i;
			else if ((begin == -1) && (fileName[i] == '\\'))
				begin = i + 1;
		}

		if (end > begin)
		{
			pluginFileName = new TCHAR[MAX_PATH];
			_tcsncpy_s(pluginFileName, MAX_PATH, fileName + begin, end - begin);
		}
	}
}

void Plugin::nwnxcpy(char* buffer, const char* response)
{
	nwnxcpy(buffer, response, strlen(response));
}

void Plugin::nwnxcpy(char* buffer, const char* response, size_t len)
{
	if (len > MAX_BUFFER)
		len = MAX_BUFFER - 1;

	memcpy(buffer, response, len);
	buffer[len] = 0x0;
}