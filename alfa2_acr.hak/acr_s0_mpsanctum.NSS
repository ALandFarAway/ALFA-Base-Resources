/////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_s0_mpsanctum.nss
//    $Revision:: 1        $ current version of the file
//        $Date:: 2023-03-15 date the file was created or modified
//       Author : Wynna 
//
//
//  Description
//  Mage's Private Sanctum. This creates an AOE that sets an int on any PC within 
//	it. The AOE tells the scrying scripts that the PC is within an area which 
//	is cloaked from scrying.
//////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#include "acr_spells_i"


////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void main()
{		
	if (!ACR_PrecastEvent())
    {
        return;
    }

	object oCaster = OBJECT_SELF;
	float fDuration = 24 * 60.0 * 60.0;
	effect eIcon = EffectEffectIcon(52);
	effect eAOE = EffectAreaOfEffect(AOE_PER_GLYPH_OF_WARDING, "acr_s0_mpsanctum_onenter", "acr_s0_mpsanctum_onhb", "acr_s0_mpsanctum_onexit", "aoe_mpsanctum");
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, GetLocation(oCaster), fDuration);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eIcon, oCaster, fDuration);
	SetLocalInt(oCaster, "abr_sp_sanctum", 1);
	
		
	// Post-cast event.
	ACR_PostcastEvent();
	}				