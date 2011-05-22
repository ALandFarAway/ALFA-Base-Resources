// ga_clock_off(int bAllPlayers)
/*
	Description: Turns clock off for speaker or for all players
	
*/
// ChazM 6/1/07

#include "ginc_time"

void main(int bAllPlayers)
{
    object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());

	if (bAllPlayers)
		SetClockOnForAllPlayers(FALSE);
	else
		SetClockOnForPlayer(oPC, FALSE);
}