/*++

Copyright (c) Skywing. All rights reserved.

Module Name:

	nwnx_objectattributes_include

Abstract:

	This module houses definitions related to the NWNX4 Object Attributes API,
	such as the public API exposed.

--*/

#include "acr_tools_i"

string GetRawHairTintSet(object oCharacter);

string GetRawBodyTintSet(object oCharacter);

string GetRawHeadTintSet(object oCharacter);

string RawToTintSet0(string sRawHair);

string RawToTintSet1(string sRawHair);

string RawToTintSet2(string sRawHair);

string RawHeadToSkin(string sRawBody);

string RawHeadToEyes(string sRawBody);

string RawHeadToBodyHair(string sRawBody);

string RawTintToTint1(string sRawTint);

string RawTintToTint2(string sRawTint);

string RawTintToTint3(string sRawTint);


//
// Public definitions.
//

//
// Define tint set formats for use with the tint set APIs.
//
void XPObjectAttributesSetRace
(
	object Creature,
    int Race
);

void XPObjectAttributesSetSubRace
(
	object Creature,
	int SubRace
);

struct XPObjectAttributes_Color
{
	float r;
	float g;
	float b;
	float a;
};

struct XPObjectAttributes_TintSet
{
	float Tint0_r;
	float Tint0_g;
	float Tint0_b;
	float Tint0_a;
	float Tint1_r;
	float Tint1_g;
	float Tint1_b;
	float Tint1_a;
	float Tint2_r;
	float Tint2_g;
	float Tint2_b;
	float Tint2_a;

	//
	// Nested structures in structures cause a code generation issues with the
	// OEI/Bioware script compiler.  Hence, we spill the fields out to the
	// TintSet structure itself.
	//

//	struct XPObjectAttributes_Color Tint0;
//	struct XPObjectAttributes_Color Tint1;
//	struct XPObjectAttributes_Color Tint2;
};

void
XPObjectAttributesSetHeadVariation(
	object Creature,
	int Variation
	);

void
XPObjectAttributesSetHairVariation(
	object Creature,
	int Variation
	);

void
XPObjectAttributesSetTailVariation(
	object Creature,
	int Variation
	);

void
XPObjectAttributesSetWingVariation(
	object Creature,
	int Variation
	);

void
XPObjectAttributesSetFacialHairVariation(
	object Creature,
	int Variation
	);

void
XPObjectAttributesSetBodyTint(
	object Creature,
	struct XPObjectAttributes_TintSet TintSet
	);

void
XPObjectAttributesSetHeadTint(
	object Creature,
	struct XPObjectAttributes_TintSet TintSet
	);

void
XPObjectAttributesSetHairTint(
	object Creature,
	struct XPObjectAttributes_TintSet TintSet
	);

struct XPObjectAttributes_Color
CreateXPObjectAttributes_Color(
	float r,
	float g,
	float b,
	float a
	);

struct XPObjectAttributes_TintSet
CreateXPObjectAttributes_TintSet(
	struct XPObjectAttributes_Color Tint0,
	struct XPObjectAttributes_Color TInt1,
	struct XPObjectAttributes_Color Tint2
	);

//
// Private definitions.
//

string
XPObjectAttributespFormatTintSetAsString(
	struct XPObjectAttributes_TintSet TintSet
	);

string
XPObjectAttributespFormatColorAsString(
	struct XPObjectAttributes_Color Color
	);

//
// Implementation.
//

void
XPObjectAttributesSetRace(
       object Creature,
       int Race
       )
/*++

Routine Description:
       This routine changes the racial type of a creature object.

Arguments:
       Creature - Supplies the object id of a creature object to modify.
       Race - Supplies the new racial type value.

Return Value:
       None.

Environment:
       Any script callout.
--*/
{
       NWNXSetString(
               "OBJECTATTRIBUTES",
               "SetRace",
               "",
               ObjectToInt( Creature ),
               IntToString( Race ));
}

void XPObjectAttributesSetSubRace(
		object Creature,
		int SubRace
		)
/*++
Routine Description:
	This routine changes the subrace of a creature object
	
Arguments:
	Creature - the creature to be changed
	SubRace - the new subrace to be assigned
	
Return Value:
	None
	
Environment:
	Any script callout
--*/
{
       NWNXSetString(
               "OBJECTATTRIBUTES",
               "SetSubRace",
               "",
               ObjectToInt( Creature ),
               IntToString( SubRace ));
}

void
XPObjectAttributesSetHeadVariation(
	object Creature,
	int Variation
	)
/*++

Routine Description:

	This routine changes the head variation of a creature object.

Arguments:

	Creature - Supplies the object id of a creature object to modify.

	Variation - Supplies the new variation value.

Return Value:

	None.

Environment:

	Any script callout.

--*/
{
	NWNXSetString(
		"OBJECTATTRIBUTES",
		"SetHeadVariation",
		"",
		ObjectToInt( Creature ),
		IntToString( Variation ));
}

void
XPObjectAttributesSetHairVariation(
	object Creature,
	int Variation
	)
/*++

Routine Description:

	This routine changes the hair variation of a creature object.

Arguments:

	Creature - Supplies the object id of a creature object to modify.

	Variation - Supplies the new variation value.

Return Value:

	None.

Environment:

	Any script callout.

--*/
{
	NWNXSetString(
		"OBJECTATTRIBUTES",
		"SetHairVariation",
		"",
		ObjectToInt( Creature ),
		IntToString( Variation ));
}

void
XPObjectAttributesSetTailVariation(
	object Creature,
	int Variation
	)
/*++

Routine Description:

	This routine changes the tail variation of a creature object.

Arguments:

	Creature - Supplies the object id of a creature object to modify.

	Variation - Supplies the new variation value.

Return Value:

	None.

Environment:

	Any script callout.

--*/
{
	NWNXSetString(
		"OBJECTATTRIBUTES",
		"SetTailVariation",
		"",
		ObjectToInt( Creature ),
		IntToString( Variation ));
}

void
XPObjectAttributesSetWingVariation(
	object Creature,
	int Variation
	)
/*++

Routine Description:

	This routine changes the wing variation of a creature object.

Arguments:

	Creature - Supplies the object id of a creature object to modify.

	Variation - Supplies the new variation value.

Return Value:

	None.

Environment:

	Any script callout.

--*/
{
	NWNXSetString(
		"OBJECTATTRIBUTES",
		"SetWingVariation",
		"",
		ObjectToInt( Creature ),
		IntToString( Variation ));
}

void
XPObjectAttributesSetFacialHairVariation(
	object Creature,
	int Variation
	)
/*++

Routine Description:

	This routine changes the facial hair variation of a creature object.

Arguments:

	Creature - Supplies the object id of a creature object to modify.

	Variation - Supplies the new variation value.

Return Value:

	None.

Environment:

	Any script callout.

--*/
{
	NWNXSetString(
		"OBJECTATTRIBUTES",
		"SetFacialHairVariation",
		"",
		ObjectToInt( Creature ),
		IntToString( Variation ));
}

void
XPObjectAttributesSetBodyTint(
	object Creature,
	struct XPObjectAttributes_TintSet TintSet
	)
/*++

Routine Description:

	This routine changes the body tint of a creature object.

Arguments:

	Creature - Supplies the object id of a creature object to modify.

	TintSet - Supplies the new tint set value.

Return Value:

	None.

Environment:

	Any script callout.

--*/
{
	NWNXSetString(
		"OBJECTATTRIBUTES",
		"SetSetBodyTint",
		"",
		ObjectToInt( Creature ),
		XPObjectAttributespFormatTintSetAsString( TintSet ));
}

void
XPObjectAttributesSetHeadTint(
	object Creature,
	struct XPObjectAttributes_TintSet TintSet
	)
/*++

Routine Description:

	This routine changes the head tint of a creature object.

Arguments:

	Creature - Supplies the object id of a creature object to modify.

	TintSet - Supplies the new tint set value.

Return Value:

	None.

Environment:

	Any script callout.

--*/
{
	NWNXSetString(
		"OBJECTATTRIBUTES",
		"SetHeadTint",
		"",
		ObjectToInt( Creature ),
		XPObjectAttributespFormatTintSetAsString( TintSet ));
}

void
XPObjectAttributesSetHairTint(
	object Creature,
	struct XPObjectAttributes_TintSet TintSet
	)
/*++

Routine Description:

	This routine changes the hair tint of a creature object.

Arguments:

	Creature - Supplies the object id of a creature object to modify.

	TintSet - Supplies the new tint set value.

Return Value:

	None.

Environment:

	Any script callout.

--*/
{
	NWNXSetString(
		"OBJECTATTRIBUTES",
		"SetHairTint",
		"",
		ObjectToInt( Creature ),
		XPObjectAttributespFormatTintSetAsString( TintSet ));
}



string
XPObjectAttributespFormatTintSetAsString(
	struct XPObjectAttributes_TintSet TintSet
	)
/*++

Routine Description:

	This routine packages a TintSet structure into a string for transfer to the
	NWNX API.

Arguments:

	TintSet - Supplies the tint set to repackage.

Return Value:

	A string representation of the tint set is returned.

Environment:

	Private routine, any caller within file.

--*/
{
	string                          StringTintSet;
	struct XPObjectAttributes_Color Color;

	//
	// Format the tint set into the form:
	//
	// NWN2_TintSet[0xRRGGBBAA, 0xRRGGBBAA, 0xRRGGBBAA]
	//
	// Note:  When using old versions of Torlack's nwnnsscomp, the references to
	//        TintSet.Tint0 (through Tint2) may generate parse errors due to a
	//        compiler bug.  The OEI/BioWare compiler will compile the code
	//        fragment correctly, and a fixed version of nwnnsscomp is also
	//        available.
	//
	// Note:  The Bioware/OEI compiler has a (different) bug with parse tree
	//        generation when nested struct members are referenced.  The member
	//        referenced is pushed onto the stack and then immediately cleaned
	//        from the stack, but the parse tree emits code that still attempts
	//        to reference the temporary that was just cleaned off of the stack.
	//
	//        This results in a compile time error for a compound expression,
	//        and illegal code generation (flagged by the NWScriptAnalyzer when
	//        JIT'd by the NWScript JIT system) when used in a simple
	//        expression.  The error would typically be detected as a
	//        'CPDOWNSP source/destination overlap' violation.
	//
	//        An example of bad code generation can be found here:
	//
	//        00000877 03 01 FFFFFFBC 0030      CPTOPSP FFFFFFBC, 0030
	//        0000087F 21 01 0030 0000 0000     DESTRUCT 0030, 0000, 0000
	//        00000887 01 01 FFFFFFF0 0010      CPDOWNSP FFFFFFF0, 0010
	//
	//        Note that the temporary (size of 30) created on the stack is then
	//        immediately deleted followed by a CPDOWNSP that attempts to access
	//        the memory previously assigned to the temporary (and which now
	//        points into the local variable frame).
	//
	//        As a result, any script that must be compiled with the Bioware/OEI
	//        compiler may not contain a nested struct member within a struct.
	//

	StringTintSet  = "NWN2_TintSet[";
	Color.r        = TintSet.Tint0_r; // Workaround Bioware compiler bugs.
	Color.g        = TintSet.Tint0_g;
	Color.b        = TintSet.Tint0_b;
	Color.a        = TintSet.Tint0_a;
	StringTintSet += XPObjectAttributespFormatColorAsString( Color );
	StringTintSet += ", ";
	Color.r        = TintSet.Tint1_r;
	Color.g        = TintSet.Tint1_g;
	Color.b        = TintSet.Tint1_b;
	Color.a        = TintSet.Tint1_a;
	StringTintSet += XPObjectAttributespFormatColorAsString( Color );
	StringTintSet += ", ";
	Color.r        = TintSet.Tint2_r;
	Color.g        = TintSet.Tint2_g;
	Color.b        = TintSet.Tint2_b;
	Color.a        = TintSet.Tint2_a;
	StringTintSet += XPObjectAttributespFormatColorAsString( Color );
	StringTintSet += "]";

	return StringTintSet;
}

string
XPObjectAttributespFormatColorAsString(
	struct XPObjectAttributes_Color Color
	)
/*++

Routine Description:

	This routine packages a Color structure into a string for transfer to the
	NWNX API.

Arguments:

	Color - Supplies the color to repackage.

Return Value:

	A string representation of the color is returned.

Environment:

	Private routine, any caller within file.

--*/
{
	int ColorValue;

	ColorValue  = (FloatToInt( Color.r * 255.0f ) & 0xFF) << 24;
	ColorValue |= (FloatToInt( Color.g * 255.0f ) & 0xFF) << 16;
	ColorValue |= (FloatToInt( Color.b * 255.0f ) & 0xFF) <<  8;
	ColorValue |= (FloatToInt( Color.a * 255.0f ) & 0xFF) <<  0;

	return IntToHexString( ColorValue );
}

struct XPObjectAttributes_Color
CreateXPObjectAttributes_Color(
	float r,
	float g,
	float b,
	float a
	)
/*++

Routine Description:

	This routine constructs a struct XPObjectAttributes_Color.

Arguments:

	r - Supplies the red value [0...1]

	g - Supplies the green value [0...1].

	b - Supplies the blue value [0...1].

	a - Supplies the alpha value [0...1].

Return Value:

	The routine returns a constructed struct XPObjectAttributes_Color.

Environment:

	Any script callout.

--*/
{
	struct XPObjectAttributes_Color Color;

	Color.r = r;
	Color.g = g;
	Color.b = b;
	Color.a = a;

	return Color;
}

struct XPObjectAttributes_TintSet
CreateXPObjectAttributes_TintSet(
	struct XPObjectAttributes_Color Tint0,
	struct XPObjectAttributes_Color Tint1,
	struct XPObjectAttributes_Color Tint2
	)
/*++

Routine Description:

	This routine constructs a struct XPObjectAttributes_TintSet.

Arguments:

	Tint0 - Supplies the first tint value.

	Tint1 - Supplies the second tint value.

	Tint2 - Supplies the third tint value.

Return Value:

	The routine returns a constructed struct XPObjectAttributes_TintSet.

Environment:

	Any script callout.

--*/
{
	struct XPObjectAttributes_TintSet TintSet;

//	TintSet.Tint0 = Tint0;
//	TintSet.Tint1 = Tint1;
//	TintSet.Tint2 = Tint2;

	TintSet.Tint0_r = Tint0.r;
	TintSet.Tint0_g = Tint0.g;
	TintSet.Tint0_b = Tint0.b;
	TintSet.Tint0_a = Tint0.a;

	TintSet.Tint1_r = Tint1.r;
	TintSet.Tint1_g = Tint1.g;
	TintSet.Tint1_b = Tint1.b;
	TintSet.Tint1_a = Tint1.a;

	TintSet.Tint2_r = Tint2.r;
	TintSet.Tint2_g = Tint2.g;
	TintSet.Tint2_b = Tint2.b;
	TintSet.Tint2_a = Tint2.a;

	return TintSet;
}


string GetRawHairTintSet(object oCharacter)
{
	string sTintSet = NWNXGetString("OBJECTATTRIBUTES", 
									"GetHairTint",
									"",
									ObjectToInt( oCharacter ));
	return sTintSet;
}

string GetRawBodyTintSet(object oCharacter)
{
	string sTintSet = NWNXGetString("OBJECTATTRIBUTES", 
									"GetBodyTint",
									"",
									ObjectToInt( oCharacter ));
	return sTintSet;
}

string GetRawHeadTintSet(object oCharacter)
{
	string sTintSet = NWNXGetString("OBJECTATTRIBUTES", 
									"GetHeadTint",
									"",
									ObjectToInt( oCharacter ));
	return sTintSet;
}

string RawToTintSet2(string sRawHair)
{
	return GetStringLeft(GetStringRight(sRawHair, GetStringLength(sRawHair) - 15), 8);
}

string RawToTintSet1(string sRawHair)
{
	return GetStringLeft(GetStringRight(sRawHair, GetStringLength(sRawHair) - 27), 8);
}

string RawToTintSet0(string sRawHair)
{
	return GetStringLeft(GetStringRight(sRawHair, GetStringLength(sRawHair) - 39), 8);
}


string RawairToHairAccessory(string sRawHair)
{
	return RawToTintSet2(sRawHair);
}

string RawHairToHairLowlight(string sRawHair)
{
	return RawToTintSet1(sRawHair);
}

string RawHairToHairHighlight(string sRawHair)
{
	return RawToTintSet0(sRawHair);
}

struct XPObjectAttributes_Color RawAttribToTint(string sRaw)
{
	struct XPObjectAttributes_Color col;

	// 8 characters, defined as:
	//
	// rrggbbaa
	//
	// convert from 0-255 -> 0-1
	
	col.r = HexStringToFloat(GetStringLeft(sRaw, 2)) / 255.0f;
	col.g = HexStringToFloat(GetStringRight(GetStringLeft(sRaw, 4), 2)) / 255.0f;
	col.b = HexStringToFloat(GetStringRight(GetStringLeft(sRaw, 6), 2)) / 255.0f;
//	col.a = HexStringToFloat(GetStringRight(GetStringLeft(sRaw, 8), 2)) / 255.0f;
	col.a = 1.0f;

	return col;
}


struct XPObjectAttributes_TintSet RawAttribToTintSet(string sRaw)
{
	struct XPObjectAttributes_Color tint0,tint1,tint2;
	string s0, s1, s2;

	s0 = RawToTintSet0(sRaw);
	s1 = RawToTintSet1(sRaw);
	s2 = RawToTintSet2(sRaw);

	tint0 = RawAttribToTint(s2);
	tint1 = RawAttribToTint(s1);
	tint2 = RawAttribToTint(s0);

	return CreateXPObjectAttributes_TintSet(tint0, tint1, tint2);
}

struct XPObjectAttributes_TintSet GetHairTintSet(object o)
{
	return RawAttribToTintSet(GetRawHairTintSet(o));
}

struct XPObjectAttributes_TintSet GetBodyTintSet(object o)
{
	return RawAttribToTintSet(GetRawBodyTintSet(o));
}

struct XPObjectAttributes_TintSet GetHeadTintSet(object o)
{
	return RawAttribToTintSet(GetRawHeadTintSet(o));
}



