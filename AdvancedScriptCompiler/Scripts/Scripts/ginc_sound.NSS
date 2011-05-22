// ginc_sound
/*
	Sound and Music functions.
*/
// EPF 8/23/06

// some variables used in the ga_music functions to save and load tracks
const string MUSIC_TRACK_DAY = "00_sDayMusic";
const string MUSIC_TRACK_NIGHT = "00_sNightMusic";
const string MUSIC_TRACK_BATTLE = "00_sBattleMusic";


void SaveMusicTrack(object oArea);
void SaveBattleMusicTrack(object oArea);
void RestoreMusicTrack(object oArea);
void ChangeMusicTrack(object oArea, int nTrack);
void RestoreBattleMusicTrack(object oArea);

//--------------------------------------
// Music Related
//--------------------------------------
void SaveMusicTrack(object oArea)
{
	SetLocalInt(oArea,MUSIC_TRACK_DAY, MusicBackgroundGetDayTrack(oArea));
	SetLocalInt(oArea,MUSIC_TRACK_NIGHT, MusicBackgroundGetNightTrack(oArea));
}

void SaveBattleMusicTrack(object oArea)
{
	SetLocalInt(oArea,MUSIC_TRACK_BATTLE, MusicBackgroundGetBattleTrack(oArea));
}

void RestoreMusicTrack(object oArea)
{
	MusicBackgroundChangeDay(oArea, GetLocalInt(oArea,MUSIC_TRACK_DAY));
	MusicBackgroundChangeNight(oArea, GetLocalInt(oArea,MUSIC_TRACK_NIGHT));
}

void ChangeMusicTrack(object oArea, int nTrack)
{
	MusicBackgroundChangeDay(oArea, nTrack);
	MusicBackgroundChangeNight(oArea, nTrack);
}

void RestoreBattleMusicTrack(object oArea)
{
	MusicBattleChange(oArea, GetLocalInt(oArea,MUSIC_TRACK_BATTLE));
}