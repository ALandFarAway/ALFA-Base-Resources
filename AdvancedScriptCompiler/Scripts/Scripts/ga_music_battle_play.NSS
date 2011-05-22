// ga_music_play
/*
   Play battle music in current area
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
	
	MusicBattlePlay(oArea);
}