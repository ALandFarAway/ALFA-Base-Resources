////////////////////////////////////////////////////////////////////////////////
// shinn_sava_start
// Original Scripter:  Shinn      Design: Shinn
// Last modified : 20/06/2012 by Shinn
//------------------------------------------------------------------------------
// Player controller script for sava chess minigame
////////////////////////////////////////////////////////////////////////////////

#include "shinn_sava_i"

void main()
{

object oPC = GetLastUsedBy();

object oHub = GetNearestObjectByTag("sava_game_hub",OBJECT_SELF);

	if(oHub == OBJECT_INVALID)
	{
	SendMessageToPC(oPC,OBJ_ERROR);
	return;	
	}

int PlayerSeat = GetLocalInt(OBJECT_SELF,"Player");

	if(PlayerSeat == 0)
	{
	SendMessageToPC(oPC,VAR_ERROR);
	return;
	}

	
SetLocalObject(oHub,"PLR_"+IntToString(PlayerSeat),oPC);
SetLocalObject(oPC,"GAME_HUB", oHub);
SetLocalInt(oPC,"GAME_SEAT", PlayerSeat);

SetUseableFlag(OBJECT_SELF,FALSE);

DisplayGuiScreen(oPC,"SAVA_MAIN",FALSE,"sava_main_screen.XML",FALSE);


}