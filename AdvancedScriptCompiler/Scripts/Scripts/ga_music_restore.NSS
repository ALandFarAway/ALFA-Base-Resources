// ga_music_restore
/*
   restore background music in current area
*/
// EPF 8/23/06

#include "ginc_sound"

void main()
{
	object oPC = GetPCSpeaker();
	
	if(!GetIsObjectValid(oPC))
	{
		oPC = OBJECT_SELF;
	}
	object oArea = GetArea(oPC);
	
	RestoreMusicTrack(oArea);
}