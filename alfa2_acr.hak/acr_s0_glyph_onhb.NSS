//::///////////////////////////////////////////////
//
//  System Name : Glyph of Warding
//  Filename : acr_s0_glyph_hb
//    
//  Description
//  This script handles on heartbeat actions for the area of effect created by 
//	ALFA custom placeable Glyphs of Warding. Note: THIS IS NOT FOR THE SPELL
//	CAST IN GAME. This is called only by a placeable placed either in toolset
//	or by the DM ingame. This should not be on the placeable.
//	The placeable casts an Area of Effect that does have this script on it.
//	It is not updated in ACR updates. 
//
//  Revision History
////////////////////////////////////////////////////////////////////////////////
//:: 
//:: Georg Zoeller - created x2_o0_glyphhb - 2003-09-02
//	 Wynna - Updated for a placeable glyph - 3/17/2023

////////////////////////////////////////////////////////////////////////////////

/*
    Dummy heartbeat. 

*/

#include "acr_spells_i"
#include "acr_trigger_i"

void main () {

	ACR_TriggerOnHeartbeat();
		
}