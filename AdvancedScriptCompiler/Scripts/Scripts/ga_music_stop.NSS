// ga_music_stop
/*
   Stop background music in current area
*/
// EPF 8/23/06

void main()
{
	object oPC = GetPCSpeaker();
	
	if(!GetIsObjectValid(oPC))
	{
		oPC = OBJECT_SELF;
	}
	object oArea = GetArea(oPC);
	
	MusicBackgroundStop(oArea);
}