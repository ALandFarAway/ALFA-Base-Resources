//
//  System Name : Mage's Private Sanctum
//     Filename : acr_s0_mpsanctum_onenter
//      Version : 0.1
//         Date : 7/8/22
//       Author : Wynna
//
//  Description
//  This script handles on enter actions for the area of effect Mage's Private Sanctum.
//  It is not updated in ACR updates.
//
//  Revision History
////////////////////////////////////////////////////////////////////////////////

//	Wynna - 7/8/2022

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
#include "acr_trigger_i"


void main()
{
    ACR_TriggerOnEnter();

	object oEnterer = GetEnteringObject();
	effect eIcon = EffectEffectIcon(52);
	float fDuration = 24 * 60.0 * 60.0;
	
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eIcon, oEnterer, fDuration);
	SendMessageToPC(oEnterer, "You enter an area that cloaks sensory communication and extra-sensory prying.");
 	SetLocalInt(oEnterer, "abr_sp_sanctum", 1);
	
}