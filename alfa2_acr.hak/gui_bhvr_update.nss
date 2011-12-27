//::///////////////////////////////////////////////
//:: Behavior Screen - Update 
//:: gui_bhvr_update.nss
//:: Created By: Brock Heinz - OEI
//:: Created On: 03/29/06
//:://////////////////////////////////////////////
// ChazM 4/26/06 - changed to use inc file
// ChazM 11/9/06 - Examined Creature update
// 	Serverside copied for ALFA by AcadiusLost, to compile in gui_bhvr_inc debug fix

#include "gui_bhvr_inc"

#include "hench_i0_assoc"

void main(int iExamined)
{
	//PrettyError( "gui_bhvr_hench_update." );

	string sScreen;
	object oPlayerObject = GetControlledCharacter(OBJECT_SELF);
	object oTargetObject;
	
	if (iExamined == 0) // looking at our own character sheet
	{
		oTargetObject = oPlayerObject;
		sScreen = SCREEN_CHARACTER;
	}
	else 	// looking at an examined character sheet
	{
		oTargetObject = GetPlayerCreatureExamineTarget(oPlayerObject);
		sScreen = SCREEN_CREATUREEXAMINE;
	}
	GuiBehaviorInit(oPlayerObject, oTargetObject, sScreen);
	HenchGuiBehaviorInit(oPlayerObject, oTargetObject, sScreen);
}