//
//  System Name : Glyph of Warding
//     Filename :acr_s0_glyph_onexit
//      Version : 0.1
//         Date : 3/17/23
//       Author : Wynna
//
//  Description
//  This script handles on exit actions for the AREA OF EFFECT created by 
//	ALFA custom placeable Glyphs of Warding. Note: THIS IS NOT FOR THE SPELL
//	CAST IN GAME. This is called only by a placeable placed either in toolset
//	or by the DM ingame. This should not be on the placeable.
//	The placeable casts an Area of Effect that does have this script on it.
//	It is not updated in ACR updates. 
//
//	Sample Glyph of Warding placeable may be found in the pallet in the
//	_ALFA_Trap_Symbol group. The glyph must be a placeable and it must be
//	tagged with "glyph_ward" as PART of the tag, but it can have any model
//	or vfx on it. The glyph must have the string ACR_CASTER_RESREF filled in
//	with the ResRef of the NPC caster that "cast" it, or it will not fire.
//	Evil, Good, and Neutral casters will cause different damage types.

//  Revision History
////////////////////////////////////////////////////////////////////////////////

//	Wynna - 3/17/2023

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
#include "acr_trigger_i"

// Dummy onexit for glyph of warding object

void main () {

	ACR_TriggerOnHeartbeat();
}