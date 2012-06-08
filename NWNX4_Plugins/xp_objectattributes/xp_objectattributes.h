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
#if !defined(XP_OBJECTATTRIBUTES_H_INCLUDED)
#define XP_OBJECTATTRIBUTES_H_INCLUDED

#define DLLEXPORT extern "C" __declspec(dllexport)

#include <windows.h>
#include <windowsx.h>
#include <specstrings.h>
#include "../plugin.h"
#include "../../misc/log.h"
#include "../../NWN2Lib/NWN2.h"

class ObjectAttributesPlugin : public Plugin
{
public:
	ObjectAttributesPlugin();
	~ObjectAttributesPlugin();

	bool Init(TCHAR* nwnxhome);  

	int GetInt(char* sFunction, char* sParam1, int nParam2) { return 0; }
	void SetInt(char* sFunction, char* sParam1, int nParam2, int nValue) {};
	float GetFloat(char* sFunction, char* sParam1, int nParam2) { return 0.0; }
	void SetFloat(char* sFunction, char* sParam1, int nParam2, float fValue) {};
	void SetString(char* sFunction, char* sParam1, int nParam2, char* sValue);
	char* GetString(char* sFunction, char* sParam1, int nParam2);
	void GetFunctionClass(TCHAR* fClass);



private:

	//
	// Define XPObjectAttributes implementation logic for the NWNX4 version
	// the of XPObjectAttributes NWNX API.
	//
	// N.B.  This code is shared with the NWNXHost.cpp.
	//

	void
	OnXPObjectAttributesSetString(
		__in const char * Plugin,
		__in const char * Function,
		__in const char * Param1,
		__in int Param2,
		__in const char * Value
		);

	//
	// Set the head variation for a creature.
	//

	void
	XPObjectAttributesSetHeadVariation(
		__in CreatureObject * Creature,
		__in unsigned long Variation
		);

	//
	// Set the hair variation for a creature.
	//

	void
	XPObjectAttributesSetHairVariation(
		__in CreatureObject * Creature,
		__in unsigned long Variation
		);

	//
	// Set the tail variation for a creature.
	//

	void
	XPObjectAttributesSetTailVariation(
		__in CreatureObject * Creature,
		__in unsigned long Variation
		);

	//
	// Set the wing variation for a creature.
	//

	void
	XPObjectAttributesSetWingVariation(
		__in CreatureObject * Creature,
		__in unsigned long Variation
		);

	//
	// Set the facial hair variation for a creature.
	//

	void
	XPObjectAttributesSetFacialHairVariation(
		__in CreatureObject * Creature,
		__in unsigned long Variation
		);

	//
	// Set the body tint for a creature.
	//

	void
	XPObjectAttributesSetBodyTint(
		__in CreatureObject * Creature,
		__in const NWN::NWN2_TintSet * TintSet
		);

	//
	// Set the head tint for a creature.
	//

	void
	XPObjectAttributesSetHeadTint(
		__in CreatureObject * Creature,
		__in const NWN::NWN2_TintSet * TintSet
		);

	//
	// Set the hair tint for a creature.
	//

	void
	XPObjectAttributesSetHairTint(
		__in CreatureObject * Creature,
		__in const NWN::NWN2_TintSet * TintSet
		);

	//
	// Set the racial type for a creature.
	//

	void
	XPObjectAttributesSetRace(
		__in CreatureObject * Creature,
		__in unsigned short Race
		);

	//
	// Set the sub race type for a creature.
	//

	void
	XPObjectAttributesSetSubRace(
		__in CreatureObject * Creature,
		__in unsigned short SubRace
		);

	//
	// Set the movement speed for a creature
	//

	void
	XPObjectAttributesSetMovementSpeed(
		__in CreatureObject * Creature,
		__in unsigned short Speed
		);

	//
	// Parse a string tint set into the raw tintset data structure.
	//

	bool
	XPObjectAttributesParseTintSetString(
		__in const char * StringTintSet,
		__out NWN::NWN2_TintSet * TintSet
		);

	std::string
	XPObjectAttributesGetHairTint(
		__in CreatureObject * Creature
		);

	std::string
	XPOnObjectAttributesGetString(
		__in const char * Plugin,
		__in const char * Function,
		__in const char * Param1,
		__in int Param2
		);

	GameObjectManager m_ObjectManager;

	std::string m_ReturnString; // String that will be returned for GetString requests from the script.

	wxLogNWNX* logger;


};

#endif
