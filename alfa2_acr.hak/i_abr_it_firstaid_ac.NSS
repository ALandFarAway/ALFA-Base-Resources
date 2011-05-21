////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : i_abr_it_firstaid_ac
//      Version : 0.15
//         Date : 9/22/2010
//       Author : AcadiusLost
//
//  Local Variable Prefix : ACR_HEAL
//
//  Description
//  This script processes player attempts to use the Heal Skill, on themselves
//  or on others.  The inital and main purpose is to allow stabilzation attempts
//  as DC15 Heal checks.  Later we may add cure disease, cure poison, and longterm
//  care handling to this code.
//
//  Revision History
//  7/12/2007 AcadiusLost: Inception
//  7/15/2007 AcadiusLost: Added exception handling for missing target.
//  7/17/2007 AcadiusLost: Added decrement of saved Death HP, to force stabilization.
//  1/14/2009 AcadiusLost: changed to i_TAG_ac convention before packing into alfa_acr.hak
//  9/19/2010 AcadiusLost: Fixed script to check for IsBleeding instead of IsStablilized()
//  9/22/2010 AcadiusLost: amended check to !ACR_GetIsPlayerBleeding()
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#include "acr_death_i"
#include "acr_resting_i"


const string ABR_HEALKIT_BONUS = "ABR_HEALKIT_BONUS";

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void main()
{
    object oUser = GetItemActivator(); 
	object oPatient = GetItemActivatedTarget();
	object oKit = GetItemActivated();
	
	int nFirstAidDC = 15;
	
	if (oPatient == OBJECT_INVALID)
	{
	    SendMessageToPC(oUser, "Nothing there to apply first aid to.");
		SetItemCharges(oKit, (GetItemCharges(oKit) + 1 ));
		return;
	}
	// Modify DC for Healing Kit or other circumstance bonus.
	nFirstAidDC = nFirstAidDC - GetLocalInt(OBJECT_SELF, ABR_HEALKIT_BONUS);
	// Modify DC for Self Sufficient feat, if present.
	if (GetHasFeat(FEAT_SELF_SUFFICIENT, oUser)) 
	{ 
	    nFirstAidDC = nFirstAidDC - 2; 
    }

    // determine if the target is in need of First Aid
    if (GetCurrentHitPoints(oPatient) <= 0)
	{
	    if (!ACR_GetIsPlayerBleeding(oPatient)) // Stabilized bit is used elsewhere for natural recovery
		{
		    SendMessageToPC(oUser, GetName(oPatient)+" is already stable.");
			SetItemCharges(oKit, (GetItemCharges(oKit) + 1 ));
	    } else if (GetIsSkillSuccessful(oUser, SKILL_HEAL, nFirstAidDC))
		{ 
			ACR_StabilizePlayer(oPatient);
			SendMessageToPC(oUser, "You successfully bind "+GetName(oPatient)+"'s wounds.");
			SendMessageToPC(oPatient, "Your bleeding is staunched by "+GetName(oUser)+".");
		} else {
		    SendMessageToPC(oUser, "You were unable to stop "+GetName(oPatient)+"'s bleeding.");
			SendMessageToPC(oPatient, GetName(oUser)+" has tried unsuccessfully to bind your wounds.");
	    } 
	} else {
	//  FIX ME <--------- should add other uses of heal here
	    SendMessageToPC(oUser, GetName(oPatient)+" doesn't seem to be in need of first aid.");
		SetItemCharges(oKit, (GetItemCharges(oKit)+1));
	}
}