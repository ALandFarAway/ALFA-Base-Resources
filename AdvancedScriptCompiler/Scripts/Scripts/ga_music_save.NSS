// ga_music_save
/*
   Save background music in current area. Restore with ga_music_restore.
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
	
	SaveMusicTrack(oArea);
}