//
//  System Name : Mage's Private Sanctum
//     Filename :acr_s0_mpsanctum_onexit
//      Version : 0.1
//         Date : 7/8/22
//       Author : Wynna
//
//  Description
//  This script handles on exit actions for the area of effect Mage's Private Sanctum.
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
    ACR_TriggerOnExit();
	object oExiter = GetExitingObject();
	
	effect eEffect = GetFirstEffect(oExiter);
	
	while (GetIsEffectValid(eEffect)) { 
		if(GetEffectType(eEffect) == EFFECT_TYPE_EFFECT_ICON) {
			RemoveEffect(oExiter, eEffect);
			}
		eEffect = GetNextEffect(oExiter);
		}
			
	SendMessageToPC(oExiter, "You exit an area that cloaks sensory communication and extra-sensory prying.");
 	SetLocalInt(oExiter, "abr_sp_sanctum", 0);
	
	
}