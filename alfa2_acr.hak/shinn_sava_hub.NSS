////////////////////////////////////////////////////////////////////////////////
// shinn_sava_hub
// Original Scripter:  Shinn      Design: Shinn
// Last modified : 20/06/2012 by Shinn
//------------------------------------------------------------------------------
// Sava chess minigame game hub object script
////////////////////////////////////////////////////////////////////////////////

#include "shinn_sava_i"

void main()
{

object oHub = OBJECT_SELF;

object oPlayer1 = GetLocalObject(oHub,"PLR_1");
// testing commented out  object oPlayer2 = GetLocalObject(oHub,"PLR_2");

int iReseted = GetLocalInt(oHub,"Reseted");

int i;


// original need to use for actual game
//if(GetIsObjectValid(oPlayer1) != TRUE && GetIsObjectValid(oPlayer2) != TRUE && iReseted == FALSE)


//for testing in single player
if(GetIsObjectValid(oPlayer1) != TRUE  && iReseted == FALSE)
{

		for(i=11 ; i <= 88 ; i++)
		{
		DeleteLocalInt(oHub,"FIELD_"+IntToString(i)+"_VT");
		DeleteLocalInt(oHub, "FIELD_"+IntToString(i)+"_Piece");
		DeleteLocalInt(oHub, "FIELD_"+IntToString(i)+"_Owner");
		}
		
	DeleteLocalObject(oHub,"PLR_1");
	DeleteLocalObject(oHub,"PLR_2");
	
	SetUseableFlag(GetNearestObjectByTag("sava_ctrl_1"),TRUE);
	SetUseableFlag(GetNearestObjectByTag("sava_ctrl_2"),TRUE);	
	SetLocalInt(oHub,"GAME_IN_PROGERSS", FALSE);
	
	SetLocalInt(oHub,"Kill_Count_1",0);
	SetLocalInt(oHub,"Kill_Count_2",0);

	SetLocalInt(oHub,"Reseted", TRUE);
	
//	ClearSpecFields(oHub);
	
}


}