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
#include "../../NWN2Lib/NWN2.h"
#define STRSAFE_NO_DEPRECIATE
#include <strsafe.h>

//
// XPObjectAttributes API.
//

void
ObjectAttributesPlugin::OnXPObjectAttributesSetString(
	__in const char * Plugin,
	__in const char * Function,
	__in const char * Param1,
	__in int Param2,
	__in const char * Value
	)
/*++

Routine Description:

	This routine dispatches XPObjectAttributes NWNXSetString requests.

Arguments:

	Plugin - Supplies the plugin name.

	Function - Supplies the function name.  This designates the operation to
	           perform, such as "set hair model variation number".

	Param1 - Supplies the first function parameter.

	Param2 - Supplies the second function parameter.  This is the object id of
	         the object to modify.

	Value - Supplies the value to set.  This is the data to change in the
	        object.

Return Value:

	None.

Environment:

	User mode.

--*/
{
	NWN::OBJECTID       ObjectId;
	GameObject        * Object;
	CreatureObject    * Creature;
	NWN::NWN2_TintSet   TintSet;

	UNREFERENCED_PARAMETER( Param1 );

	ObjectId = (NWN::OBJECTID) Param2;

	if ((ObjectId & NWN::INVALIDOBJID) != 0)
		ObjectId &= ~(NWN::LISTTYPE_MASK);

	if ((Object = m_ObjectManager.GetGameObject( ObjectId )) == NULL)
		return;

	Creature = Object->AsCreature( );

	if ((!strcmp( Function, "SetHeadVariation" )) && (Creature != NULL))
	{
		XPObjectAttributesSetHeadVariation(
			Creature,
			strtoul( Value, 0, NULL ));

		return;
	}
	else if ((!strcmp( Function, "SetHairVariation" )) && (Creature != NULL))
	{
		XPObjectAttributesSetHairVariation(
			Creature,
			strtoul( Value, 0, NULL ));

		return;
	}
	else if ((!strcmp( Function, "SetTailVariation" )) && (Creature != NULL))
	{
		XPObjectAttributesSetTailVariation(
			Creature,
			strtoul( Value, 0, NULL ));

		return;
	}
	else if ((!strcmp( Function, "SetWingVariation" )) && (Creature != NULL))
	{
		XPObjectAttributesSetWingVariation(
			Creature,
			strtoul( Value, 0, NULL ));

		return;
	}
	else if ((!strcmp( Function, "SetFacialHairVariation" )) && (Creature != NULL))
	{
		XPObjectAttributesSetFacialHairVariation(
			Creature,
			strtoul( Value, 0, NULL ));

		return;
	}
	else if ((!strcmp( Function, "SetBodyTint" )) &&
	         (Creature != NULL)                   && 
	         (XPObjectAttributesParseTintSetString( Value, &TintSet )))
	{
		XPObjectAttributesSetBodyTint( Creature, &TintSet );

		return;
	}
	else if ((!strcmp( Function, "SetHeadTint" )) &&
	         (Creature != NULL)                   && 
	         (XPObjectAttributesParseTintSetString( Value, &TintSet )))
	{
		XPObjectAttributesSetHeadTint( Creature, &TintSet );

		return;
	}
	else if ((!strcmp( Function, "SetHairTint" )) &&
	         (Creature != NULL)                   && 
	         (XPObjectAttributesParseTintSetString( Value, &TintSet )))
	{
		XPObjectAttributesSetHairTint( Creature, &TintSet );

		return;
	}
	else if ((!strcmp( Function, "SetRace" )) &&
	         (Creature != NULL))
	{
		XPObjectAttributesSetRace(
			Creature,
			(unsigned short) strtoul( Value, 0, NULL ));

		return;
	}
	else if ((!strcmp( Function, "SetSubRace" )) &&
			 (Creature != NULL))
	{
		XPObjectAttributesSetSubRace(
			Creature,
			(unsigned short) strtoul( Value, 0, NULL));
		return;
	}
	else if ((!strcmp( Function, "SetMovementSpeed" )) &&
		     (Creature != NULL))
	{
		XPObjectAttributesSetMovementSpeed(
			Creature,
			(unsigned short) stroul( Value, 0, NULL));
		return;
	}
	else
	{
	}
}

std::string
ObjectAttributesPlugin::XPOnObjectAttributesGetString(
	__in const char * Plugin,
	__in const char * Function,
	__in const char * Param1,
	__in int Param2
	)
{
	NWN::OBJECTID       ObjectId;
	GameObject        * Object;
	CreatureObject    * Creature;
	std::string         ReturnString;

	UNREFERENCED_PARAMETER( Param1 );

	ObjectId = (NWN::OBJECTID) Param2;

	if ((ObjectId & NWN::INVALIDOBJID) != 0)
		ObjectId &= ~(NWN::LISTTYPE_MASK);

	if ((Object = m_ObjectManager.GetGameObject( ObjectId )) == NULL)
		return ReturnString;

	Creature = Object->AsCreature( );

	if ((!strcmp( Function, "GetHairTint" )) &&
		     (Creature != NULL))
	{
		ReturnString = XPObjectAttributesGetHairTint( 
				Creature );
	}
	else
	{
		return ReturnString;
	}

	return ReturnString;
}
void
ObjectAttributesPlugin::XPObjectAttributesSetHeadVariation(
	__in CreatureObject * Creature,
	__in unsigned long Variation
	)
/*++

Routine Description:

	This routine alters the head variation of a creature on behalf of script.

Arguments:

	Creature - Supplies the creature object to modify.

	Variation - Supplies the new variation value.

Return Value:

	None.

Environment:

	User mode.

--*/
{
	Creature->SetHeadVariation( (unsigned char) Variation );
}

void
ObjectAttributesPlugin::XPObjectAttributesSetHairVariation(
	__in CreatureObject * Creature,
	__in unsigned long Variation
	)
/*++

Routine Description:

	This routine alters the hair variation of a creature on behalf of script.

Arguments:

	Creature - Supplies the creature object to modify.

	Variation - Supplies the new variation value.

Return Value:

	None.

Environment:

	User mode.

--*/
{
	Creature->SetHairVariation( (unsigned char) Variation );
}

void
ObjectAttributesPlugin::XPObjectAttributesSetTailVariation(
	__in CreatureObject * Creature,
	__in unsigned long Variation
	)
/*++

Routine Description:

	This routine alters the tail variation of a creature on behalf of script.

Arguments:

	Creature - Supplies the creature object to modify.

	Variation - Supplies the new variation value.

Return Value:

	None.

Environment:

	User mode.

--*/
{
	Creature->SetTailVariation( (unsigned char) Variation );
}

void
ObjectAttributesPlugin::XPObjectAttributesSetWingVariation(
	__in CreatureObject * Creature,
	__in unsigned long Variation
	)
/*++

Routine Description:

	This routine alters the wing variation of a creature on behalf of script.

Arguments:

	Creature - Supplies the creature object to modify.

	Variation - Supplies the new variation value.

Return Value:

	None.

Environment:

	User mode.

--*/
{
	Creature->SetWingVariation( (unsigned char) Variation );
}

void
ObjectAttributesPlugin::XPObjectAttributesSetFacialHairVariation(
	__in CreatureObject * Creature,
	__in unsigned long Variation
	)
/*++

Routine Description:

	This routine alters the facial hair variation of a creature on behalf of
	script.

Arguments:

	Creature - Supplies the creature object to modify.

	Variation - Supplies the new variation value.

Return Value:

	None.

Environment:

	User mode.

--*/
{
	Creature->SetFacialHairVariation( (unsigned char) Variation );
}

void
ObjectAttributesPlugin::XPObjectAttributesSetBodyTint(
	__in CreatureObject * Creature,
	__in const NWN::NWN2_TintSet * TintSet
	)
/*++

Routine Description:

	This routine alters the body tint of a creature on behalf of script.

Arguments:

	Creature - Supplies the creature object to modify.

	TintSet - Supplies the new tint set value.

Return Value:

	None.

Environment:

	User mode.

--*/
{
	Creature->SetTintSet( NWN::CreatureTintSetBody, TintSet );
}

void
ObjectAttributesPlugin::XPObjectAttributesSetRace(
	__in CreatureObject * Creature,
	__in unsigned short Race
	)
/*++
Routine Description:
	This routine alters the racial type of a creature on behalf of script.

Arguments:
	Creature - Supplies the creature object to modify.
	Race - Supplies the new racial type value.

Return Value:
	None.

Environment:
	User mode.
--*/
{
	Creature->SetRace( Race );
}


void
ObjectAttributesPlugin::XPObjectAttributesSetSubRace(
	__in CreatureObject * Creature,
	__in unsigned short SubRace
	)
/*++
Routine Description:
	This routine alters the SubRace of a creature on behalf of a script.

Arguments:
	Creature - the creature object to modify
	SubRace - the new subrace value

Return Value:
	None

Environment:
	User mode
--*/
{
	Creature->SetSubRace( SubRace );
}

	void
	XPObjectAttributesSetMovementSpeed(
		__in CreatureObject * Creature,
		__in unsigned short Speed
		)
/*++
Routine Description:
	This routine alters the movement speed of a creature on behalf of a script.

Arguments:
	Creature - the creature object to modify
	SubRace - the new subrace value

Return Value:
	None

Environment:
	User mode
--*/
{
	Creature->SetMovementSpeed( Speed );
}
void
ObjectAttributesPlugin::XPObjectAttributesSetHeadTint(
	__in CreatureObject * Creature,
	__in const NWN::NWN2_TintSet * TintSet
	)
/*++

Routine Description:

	This routine alters the head tint of a creature on behalf of script.

Arguments:

	Creature - Supplies the creature object to modify.

	TintSet - Supplies the new tint set value.

Return Value:

	None.

Environment:

	User mode.

--*/
{
	Creature->SetTintSet( NWN::CreatureTintSetHead, TintSet );
}

void
ObjectAttributesPlugin::XPObjectAttributesSetHairTint(
	__in CreatureObject * Creature,
	__in const NWN::NWN2_TintSet * TintSet
	)
/*++

Routine Description:

	This routine alters the hair tint of a creature on behalf of script.

Arguments:

	Creature - Supplies the creature object to modify.

	TintSet - Supplies the new tint set value.

Return Value:

	None.

Environment:

	User mode.

--*/
{
	Creature->SetTintSet( NWN::CreatureTintSetHair, TintSet );
}

bool
ObjectAttributesPlugin::XPObjectAttributesParseTintSetString(
	__in const char * StringTintSet,
	__out NWN::NWN2_TintSet * TintSet
	)
/*++

Routine Description:

	This routine attempts to parse a string tint set into the raw tintset data
	structure.

Arguments:

	StringTintSet - Supplies the string TintSet description.

	TintSet - On success, receives the parsed TintSet contents.

Return Value:

	The routine returns a Boolean value indicating true if the tint set was
	parsed successfully, else false if parsing failed.

Environment:

	User mode.

--*/
{
	unsigned long   ColorData[ 3 ];
	int             Scanned;
	unsigned __int8 Data;

	C_ASSERT( RTL_NUMBER_OF( TintSet->Colors ) == 3 );

	Scanned = sscanf_s(
		StringTintSet,
		"NWN2_TintSet[0x%08X, 0x%08X, 0x%08X]",
		&ColorData[ 0 ],
		&ColorData[ 1 ],
		&ColorData[ 2 ] );

	if (Scanned != 3)
		return false;

	for (size_t i = 0; i < RTL_NUMBER_OF( TintSet->Colors ); i += 1)
	{
		Data = (ColorData[ i ] >> 24) & 0xFF;

		TintSet->Colors[ i ].r = (float) (((float) Data) * (1.0/255.0));

		Data = (ColorData[ i ] >> 16) & 0xFF;

		TintSet->Colors[ i ].g = (float) (((float) Data) * (1.0/255.0));

		Data = (ColorData[ i ] >>  8) & 0xFF;

		TintSet->Colors[ i ].b = (float) (((float) Data) * (1.0/255.0));

		Data = (ColorData[ i ] >>  0) & 0xFF;

		TintSet->Colors[ i ].a = (float) (((float) Data) * (1.0/255.0));
	}

	return true;
}

std::string
ObjectAttributesPlugin::XPObjectAttributesTintToString(
	__in NWN::NWN2_TintSet * TintSet)
/*++

Routine Description:

	This routine parses through the TintSet struct and returns it in
	the form of a string for use in a script.

Arguments:

	TintSet - Supplies the TintSet struct to use

Return Value:

	Tintset, expressed as a string.

Environment:

	User mode.

--*/
{
	unsigned long   ColorData[ 3 ];
	char            StringTintSet[ 256 ];

	C_ASSERT( RTL_NUMBER_OF( TintSet->Colors ) == 3 );

	for (size_t i = 0; i < RTL_NUMBER_OF( TintSet->Colors ); i += 1)
	{
		ColorData[ i ]  = ((unsigned long) (TintSet->Colors[ i ].r * 255.0f) & 0xFF) << 24;
		ColorData[ i ] |= ((unsigned long) (TintSet->Colors[ i ].g * 255.0f) & 0xFF) << 16;
		ColorData[ i ] |= ((unsigned long) (TintSet->Colors[ i ].b * 255.0f) & 0xFF) <<  8;
		ColorData[ i ] |= ((unsigned long) (TintSet->Colors[ i ].a * 255.0f) & 0xFF) <<  0;
	}

	StringCbPrintfA(
		StringTintSet,
		sizeof( StringTintSet ),
		"NWN2_TintSet[0x%08X, 0x%08X, 0x%08X]",
		ColorData[ 0 ],
		ColorData[ 1 ],
		ColorData[ 2 ] );

	return StringTintSet;
}

std::string
ObjectAttributesPlugin::XPObjectAttributesGetHairTint(
	__in CreatureObject * Creature)
/*++

Routine Description:

	This routine gets the hair tintset as a string for use in a script.

Arguments:

	Creature - Supplies the creature object to read.

Return Value:

	Tintset, expressed as a string.

Environment:

	User mode.

--*/
{
	NWN::NWN2_TintSet * TintSet;
	TintSet = Creature->GetTintSet( NWN::CreatureTintSetHair );


	return XPObjectAttributesTintToString(TintSet);
}

std::string
ObjectAttributesPlugin::XPObjectAttributesGetHeadTint(
	__in CreatureObject * Creature)
/*++

Routine Description:

	This routine gets the head tintset as a string for use in a script.

Arguments:

	Creature - Supplies the creature object to read.

Return Value:

	Tintset, expressed as a string.

Environment:

	User mode.

--*/
{
	NWN::NWN2_TintSet * TintSet;
	TintSet = Creature->GetTintSet( NWN::CreatureTintSetHead );
	
	return XPObjectAttributesTintToString(TintSet);
}

std::string
ObjectAttributesPlugin::XPObjectAttributesGetBodyTint(
	__in CreatureObject * Creature)
/*++

Routine Description:

	This routine gets the body tintset as a string for use in a script.

Arguments:

	Creature - Supplies the creature object to read.

Return Value:

	Tintset, expressed as a string.

Environment:

	User mode.

--*/
{
	NWN::NWN2_TintSet * TintSet;
	TintSet = Creature->GetTintSet( NWN::CreatureTintSetBody );
	
	return XPObjectAttributesTintToString(TintSet);
}

//
// Core NWN2 interface routines.
//
