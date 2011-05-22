// gb_comp_heart
/*
	companion heartbeat
*/
// ChazM 12/5/05
// BMA-OEI 2/6/06 cleaned up comments, preserve action queue
// BMA-OEI 2/8/06 removed debug
// BMA-OEI 2/23/06 added 0.5f minimal follow distance
// ChazM 2/23/06 added commented PrettyDebugs.
// BMA-OEI 2/28/06 increase min follow distance = 2.0f	
// DBR - 08/03/06 added support for NW_ASC_MODE_PUPPET
// ChazM 8/18/06 added debug calls.
			
//:://////////////////////////////////////////////////
//:: X0_CH_HEN_HEART
/*

  OnHeartbeat event handler for henchmen/associates.

*/
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 01/05/2003
//:://////////////////////////////////////////////////


#include "X0_INC_HENAI"
#include "hench_i0_generic"


void main()
{
	//option for a custom hb script (ease of AI hookup)
	string sHBScript=GetLocalString(OBJECT_SELF, "hb_script");
	if (sHBScript != "")
	{
		ExecuteScript(sHBScript, OBJECT_SELF);
	}

	if (GetIsPC(OBJECT_SELF))
	{
//		Jug_Debug("*****" + GetName(OBJECT_SELF) + " heartbeat exit due to isPC action " + IntToString(GetCurrentAction()) + " PC " + IntToString(GetIsPC(OBJECT_SELF)));
		return;		// heartbeat gets called on load for PC sometimes
	}
	
//	float time = IntToFloat(GetTimeSecond()) + IntToFloat(GetTimeMillisecond()) /1000.0;
//	Jug_Debug("*****" + GetName(OBJECT_SELF) + " heartbeat action " + IntToString(GetCurrentAction()) + " time " + FloatToString(time));

	int bDying = (GetIsDead(OBJECT_SELF) || GetIsHenchmanDying(OBJECT_SELF));
	
    // If we're dying or busy, we return
    // (without sending the user-defined event)
	// file: nw_i0_generic, x0_i0_henchmen, assoc, x0_i0_states, henai
    int bBusy = GetAssociateState(NW_ASC_IS_BUSY);

	if (bDying || bBusy)
	{
		return;
	}
	
	ExecuteScript("gb_assoc_heart", OBJECT_SELF);
}