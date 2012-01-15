/*
Author: brockfanning
Date: 1/24/09
Purpose: This is called from an NPC conversation to do several things
	-Improvise songs
		Note that the iParam1,2,3,4 variables can be set according to this:
			0 = nothing
			1 = drums
			2 = chords
			3 = lute notes
			4 = flute
			
		And iParam5 determines the style. (if left at 0, it will randomly choose one)
	
	-Play a "server" song
	-Play a song from the NPC's inventory
	-Randomly do one of the above
	-Transcribe a song for the PC
		This simply creates a score of the last song played, and gives it to the PC.
*/

#include "tkl_performer_include"

void ErasePreviousSong(object oNPC, object oInstrument)
{
	EraseTrack(oInstrument, 4);
	EraseTrack(oInstrument, 3);
	EraseTrack(oInstrument, 2);
	EraseTrack(oInstrument, 1);
	DeleteLocalString(oInstrument, "SONG_NAME");
	EraseLyrics(oInstrument);
	EraseLyricTrack(oInstrument);
	DeleteLocalInt(oInstrument, "KEY");
	DeleteLocalInt(oInstrument, "TEMPO");
	DeleteLocalString(oInstrument, "ORIGINAL_COMPOSER");
}

// Set a local int until the song ends, so that the conversation can be disabled.
// Remove the int after a delay equal to the song length.
// Also disable environmental audio and background music for the duration.
void DisableNPC(object oNPC, object oInstrument)
{
	SetLocalInt(oNPC, "NPC_IS_PLAYING", TRUE);
	float fLength = GetLocalFloat(oInstrument, "SONG_LENGTH");
	DelayCommand(fLength, DeleteLocalInt(oNPC, "NPC_IS_PLAYING"));
	
	object oArea = GetArea(oNPC);
	MusicBackgroundStop(oArea);
	AmbientSoundStop(oArea);
	DelayCommand(fLength + 3.0f, MusicBackgroundPlay(oArea));
	DelayCommand(fLength + 3.0f, AmbientSoundPlay(oArea));
}

// Counts the number of blueprint scores in an NPC's inventory, and saves the info for later.
// If none are found, it saves -1 as the total.
int CatalogBlueprintScores(object oNPC)
{
	// Check for a variable, so that we don't have to search every time.
	int iBlueprintScores = GetLocalInt(oNPC, "TOTAL_BLUEPRINT_SCORES");
	
	// If not found, cycle through the NPC's inventory
	if (iBlueprintScores == 0)
	{
		object oItem = GetFirstItemInInventory(oNPC);
		while (GetIsObjectValid(oItem))
		{
			if (GetLocalInt(oItem, "BLUEPRINT_SCORE"))
			{
				// Increment the total and save the score's name for later.
				iBlueprintScores++;
				SetLocalObject(oNPC, "BLUEPRINT_SCORE" + IntToString(iBlueprintScores), oItem);			
			}
			oItem = GetNextItemInInventory(oNPC);
		}
		
		// Set a local int so we won't have to cycle through inventory next time
		// If none were found, set the variable to -1 so it won't be searched for next time.
		if (iBlueprintScores > 0)
			SetLocalInt(oNPC, "TOTAL_BLUEPRINT_SCORES", iBlueprintScores);
		else 
			SetLocalInt(oNPC, "TOTAL_BLUEPRINT_SCORES", -1);
	}
	
	return iBlueprintScores;
}

void PlayBlueprintScore(object oPC, object oNPC, object oInstrument, int iParam1)
{
	int iBlueprintScores = CatalogBlueprintScores(oNPC);
		
	object oScore = GetLocalObject(oNPC, "BLUEPRINT_SCORE" + IntToString(iParam1));
	if (!GetIsObjectValid(oScore))
	{
		SpeakString("I'm sorry, it seems I am missing that score.");
		return;
	}
	
	SpeakString("Let me look over the music for one moment... *gets out some sheet music and studies it*");
	
	// First delete old song
	ErasePreviousSong(oNPC, oInstrument);
	
	// Check for any speed variance, or set the default 100 (low = faster, high = slower)
	int iTempo = 100;
	int iVariance = GetLocalInt(oScore, "SPEED_VARIANCE");
	if (iVariance > 0)
		iTempo -= (Random(iVariance) + 1);
	else if (iVariance < 0)
		iTempo += (Random(iVariance) + 1);
	SetLocalInt(oInstrument, "TEMPO", iTempo);
	
	float fSecondsPerBeat = GetLocalFloat(oScore, "SECONDS_PER_BEAT");
	if (fSecondsPerBeat <= 0.0f) fSecondsPerBeat = 1.0f;
	int iMetronome = FloatToInt(60.0f / fSecondsPerBeat);
	//int iMetronome = GetLocalInt(oScore, "METRONOME");
	//if (iMetronome == 0) iMetronome = 60;
	SetLocalInt(oInstrument, "METRONOME", iMetronome);
		
	int iTrack;
	float fDelay;
	// Cycle through each track, and write it.
	for (iTrack = 1; iTrack <= 4; iTrack++)
	{
		string sInstrument = GetLocalString(oScore, "INSTRUMENT" + IntToString(iTrack));
		string sGUIFile = "tkl_performer_lute.xml";
		if (GetStringLowerCase(sInstrument) == "flute")
			sGUIFile = "tkl_performer_flute.xml";
		else if (GetStringLowerCase(sInstrument) == "drum" || GetStringLowerCase(sInstrument) == "drums")
			sGUIFile = "tkl_performer_drum.xml";	
	
		string sInput = GetLocalString(oScore, "NOTES" + IntToString(iTrack));
		if (sInput != "")
		{
			SetLocalInt(oInstrument, "METRONOME_RECORDED_TRACK" + IntToString(iTrack), iMetronome);
			SetLocalString(oInstrument, "TRACK_" + IntToString(iTrack) + "_NAME", sInstrument);
			AssignCommand(oNPC, DelayCommand(fDelay, WriteTrack(oNPC, oInstrument, iTrack, sInput, sGUIFile)));
			fDelay += 1.0f;
		}
	}
	
	// Transfer all lyrics
	int iLyric;
	string sLyric, sText;
	for (iLyric = 1; iLyric <= 64; iLyric++)
	{
		sLyric = IntToString(iLyric);
		sText = GetLocalString(oScore, "LYRIC" + sLyric);
		if (sText != "")
			SetLocalString(oInstrument, "LYRIC" + sLyric, sText);
	}
	// Check for a Lyric "Write" track
	string sLyricWrite = GetLocalString(oScore, "WRITE_LYRICS");
	if (sLyricWrite != "")
	{
		float fSecondsPerLyric = GetLocalFloat(oScore, "SECONDS_PER_LYRIC");
		if (fSecondsPerLyric <= 0.0f) fSecondsPerLyric = 1.0f;
		SetLocalFloat(oInstrument, "SECONDS_PER_LYRIC", fSecondsPerLyric);
		SetLocalString(oInstrument, "WRITE_LYRICS", sLyricWrite);
		AssignCommand(oNPC, DelayCommand(fDelay + 0.5f, WriteLyrics(oNPC, oInstrument, sLyricWrite))); 
	}
	
	// Transfer a few variables
	SetLocalString(oInstrument, "SONG_NAME", GetName(oScore));
	SetLocalString(oInstrument, "ORIGINAL_COMPOSER", GetLocalString(oScore, "ORIGINAL_COMPOSER"));
	
	// Set a random key
	SetLocalInt(oInstrument, "KEY", Random(12));
	
	// After a nice long delay, start playing the song
	DelayCommand(fDelay + 3.0f, PlaySong(oNPC, oInstrument, 0, TRUE));
	DelayCommand(fDelay + 3.1f, DisableNPC(oNPC, oInstrument));
}



void PlayServerSong(object oNPC, object oInstrument, int iParam1)
{
	object oSong = RetrieveTKLPersistInstrumentObject(OBJECT_INVALID, "TKL_SERVER_INST_" +
			IntToString(iParam1), GetLocation(oNPC), oNPC);
	if (GetIsObjectValid(oSong))
	{
		SpeakString("Let me see if I can remember that song... *prepares to play*");
	
		TransferSong(oSong, oInstrument);
		// Set a random key
		SetLocalInt(oInstrument, "KEY", Random(12));
		DelayCommand(3.0f, PlaySong(oNPC, oInstrument));
		DelayCommand(3.1f, DisableNPC(oNPC, oInstrument));
		DestroyObject(oSong);
	}
	else
		SpeakString("Sorry, it seems that I don't remember that song.");
}

void ImproviseRandom(object oNPC, object oInstrument, object oPC)
{
	// First delete old song
	ErasePreviousSong(oNPC, oInstrument);

	int iStyle = Random(TOTAL_STYLES) + 1;
	SetImprovStyle(oNPC, iStyle);
	//if (bStyleSet == FALSE) SpeakString("Sorry, it seems that I don't remember that style.");
	// Assign the instruments
	int iTrack1, iTrack2, iTrack3, iTrack4;
	switch (d12())
	{
		case 1:
			iTrack1 = IMPROV_INSTRUMENT_DRUM;
			iTrack2 = IMPROV_INSTRUMENT_LUTE_CHORDS;
			iTrack3 = IMPROV_INSTRUMENT_LUTE_NOTES;
			iTrack4 = IMPROV_INSTRUMENT_FLUTE;
			break;
		case 2:
			iTrack1 = IMPROV_INSTRUMENT_DRUM;
			iTrack2 = IMPROV_INSTRUMENT_LUTE_CHORDS;
			iTrack3 = IMPROV_INSTRUMENT_LUTE_NOTES;
			iTrack4 = IMPROV_INSTRUMENT_LUTE_NOTES;
			break;
		case 3:
			iTrack1 = IMPROV_INSTRUMENT_DRUM;
			iTrack2 = IMPROV_INSTRUMENT_LUTE_CHORDS;
			iTrack3 = IMPROV_INSTRUMENT_FLUTE;
			iTrack4 = IMPROV_INSTRUMENT_FLUTE;
			break;
		case 4:
			iTrack1 = IMPROV_INSTRUMENT_DRUM;
			iTrack2 = IMPROV_INSTRUMENT_LUTE_CHORDS;
			iTrack3 = IMPROV_INSTRUMENT_LUTE_NOTES;
			iTrack4 = IMPROV_INSTRUMENT_NONE;
			break;
		case 5:
			iTrack1 = IMPROV_INSTRUMENT_DRUM;
			iTrack2 = IMPROV_INSTRUMENT_LUTE_CHORDS;
			iTrack3 = IMPROV_INSTRUMENT_FLUTE;
			iTrack4 = IMPROV_INSTRUMENT_NONE;
			break;
		case 6:
			iTrack1 = IMPROV_INSTRUMENT_LUTE_NOTES;
			iTrack2 = IMPROV_INSTRUMENT_FLUTE;
			iTrack3 = IMPROV_INSTRUMENT_NONE;
			iTrack4 = IMPROV_INSTRUMENT_NONE;
			break;
		case 7:
			iTrack1 = IMPROV_INSTRUMENT_LUTE_NOTES;
			iTrack2 = IMPROV_INSTRUMENT_LUTE_NOTES;
			iTrack3 = IMPROV_INSTRUMENT_NONE;
			iTrack4 = IMPROV_INSTRUMENT_NONE;
			break;
		case 8:
			iTrack1 = IMPROV_INSTRUMENT_FLUTE;
			iTrack2 = IMPROV_INSTRUMENT_FLUTE;
			iTrack3 = IMPROV_INSTRUMENT_NONE;
			iTrack4 = IMPROV_INSTRUMENT_NONE;
			break;
		case 9:
			iTrack1 = IMPROV_INSTRUMENT_LUTE_NOTES;
			iTrack2 = IMPROV_INSTRUMENT_LUTE_NOTES;
			iTrack3 = IMPROV_INSTRUMENT_FLUTE;
			iTrack4 = IMPROV_INSTRUMENT_FLUTE;
			break;
		case 10:
			iTrack1 = IMPROV_INSTRUMENT_LUTE_NOTES;
			iTrack2 = IMPROV_INSTRUMENT_LUTE_NOTES;
			iTrack3 = IMPROV_INSTRUMENT_LUTE_NOTES;
			iTrack4 = IMPROV_INSTRUMENT_LUTE_NOTES;
			break;
		case 11:
			iTrack1 = IMPROV_INSTRUMENT_FLUTE;
			iTrack2 = IMPROV_INSTRUMENT_FLUTE;
			iTrack3 = IMPROV_INSTRUMENT_FLUTE;
			iTrack4 = IMPROV_INSTRUMENT_FLUTE;
			break;
		case 12:
			iTrack1 = IMPROV_INSTRUMENT_DRUM;
			iTrack2 = IMPROV_INSTRUMENT_DRUM;
			iTrack3 = IMPROV_INSTRUMENT_DRUM;
			iTrack4 = IMPROV_INSTRUMENT_DRUM;
			break;		
	}
	SetLocalInt(oInstrument, "IMPROV_INSTRUMENT_TRACK_1", iTrack1);
	SetLocalInt(oInstrument, "IMPROV_INSTRUMENT_TRACK_2", iTrack2);
	SetLocalInt(oInstrument, "IMPROV_INSTRUMENT_TRACK_3", iTrack3);
	SetLocalInt(oInstrument, "IMPROV_INSTRUMENT_TRACK_4", iTrack4);
	
	// Write and play the song
	Improvise(oNPC);
	// Set a random key
	SetLocalInt(oInstrument, "KEY", Random(12));
	// Set a random speed (90 to 110)
	int iVariance = Random(21) - 10;
	SetLocalInt(oInstrument, "TEMPO", 100 + iVariance);
	// Announce the style
	string sStyle;
	switch (iStyle)
	{
		case 1: sStyle = STYLE_1_NAME; break;
		case 2: sStyle = STYLE_2_NAME; break;
		case 3: sStyle = STYLE_3_NAME; break;
		case 4: sStyle = STYLE_4_NAME; break;
		case 5: sStyle = STYLE_5_NAME; break;
		case 6: sStyle = STYLE_6_NAME; break;
		case 7: sStyle = STYLE_7_NAME; break;
		case 8: sStyle = STYLE_8_NAME; break;
		case 9: sStyle = STYLE_9_NAME; break;
		case 10: sStyle = STYLE_10_NAME; break;
	}
	SpeakString("How about an improvisation in the style of " + sStyle + "...");
	DelayCommand(3.0f, PlaySong(oNPC, oInstrument));
	DelayCommand(3.1f, DisableNPC(oNPC, oInstrument));
	DelayCommand(5.0f, ClearImprovStyle(oNPC));

	SetLocalString(oInstrument, "ORIGINAL_COMPOSER", GetName(oNPC));
}

void main(string sAction, int iParam1, int iParam2, int iParam3, int iParam4, int iParam5)
{
	object oNPC = OBJECT_SELF;
	object oPC = GetPCSpeaker();
	
	// For the purposes of this script, the bard itself is considered the "instrument"
	object oInstrument = oNPC;
	SetLocalObject(oNPC, "TKL_PERFORMER_INSTRUMENT", oInstrument);
	
	// Set up Custom Tokens for all the styles available for Improvisation
	if (sAction == "LIST_STYLES")
	{
		int i;
		for (i = 1; i <= 10; i++)
		{
			if (i <= TOTAL_STYLES)
			{
				switch (i)
				{
					case 1: SetCustomToken(7890 + i, STYLE_1_NAME); break;
					case 2: SetCustomToken(7890 + i, STYLE_2_NAME); break;
					case 3: SetCustomToken(7890 + i, STYLE_3_NAME); break;
					case 4: SetCustomToken(7890 + i, STYLE_4_NAME); break;
					case 5: SetCustomToken(7890 + i, STYLE_5_NAME); break;
					case 6: SetCustomToken(7890 + i, STYLE_6_NAME); break;
					case 7: SetCustomToken(7890 + i, STYLE_7_NAME); break;
					case 8: SetCustomToken(7890 + i, STYLE_8_NAME); break;
					case 9: SetCustomToken(7890 + i, STYLE_9_NAME); break;
					case 10: SetCustomToken(7890 + i, STYLE_10_NAME); break;
				}
			}
			else
				SetCustomToken(7890 + i, "...");
		}
	}
	
	// Set up an Improv style on the NPC, for later Improvisation
	if (sAction == "SET_STYLE")
	{
		int iStyle = iParam1;
		if (iStyle == 0) iStyle = Random(TOTAL_STYLES) + 1;
		SetImprovStyle(oNPC, iStyle);
		//if (bStyleSet == FALSE) SpeakString("Sorry, it seems that I don't remember that style.");
	}
	
	if (sAction == "CLEAR_STYLE")
	{
		ClearImprovStyle(oNPC);
	}
	
	// Improvise a style
	else if (sAction == "IMPROVISE")
	{
		// First delete old song
		ErasePreviousSong(oNPC, oInstrument);
	
		// Assign the instruments
		SetLocalInt(oInstrument, "IMPROV_INSTRUMENT_TRACK_1", iParam1);
		SetLocalInt(oInstrument, "IMPROV_INSTRUMENT_TRACK_2", iParam2);
		SetLocalInt(oInstrument, "IMPROV_INSTRUMENT_TRACK_3", iParam3);
		SetLocalInt(oInstrument, "IMPROV_INSTRUMENT_TRACK_4", iParam4);
		
		// Write and play the song
		Improvise(oNPC);
		// Set a random key
		SetLocalInt(oInstrument, "KEY", Random(12));
		DelayCommand(3.0f, PlaySong(oNPC, oInstrument));
		DelayCommand(3.1f, DisableNPC(oNPC, oInstrument));
		DelayCommand(5.0f, ClearImprovStyle(oNPC));
		
		SetLocalString(oInstrument, "ORIGINAL_COMPOSER", GetName(oNPC));
	}
	
	// Give the PC a score of the last song played
	else if (sAction == "TRANSCRIBE")
	{
		if (GetLocalInt(oInstrument, "NOTES_RECORDED_TRACK1") == 0 &&
			GetLocalInt(oInstrument, "NOTES_RECORDED_TRACK2") == 0 &&
			GetLocalInt(oInstrument, "NOTES_RECORDED_TRACK3") == 0 &&
			GetLocalInt(oInstrument, "NOTES_RECORDED_TRACK4") == 0)
			ActionSpeakString("I haven't played anything yet!");
		else
		{
			object oScore = CreateItemOnObject("tkl_performer_score", oPC);
			string sComposer = GetLocalString(oInstrument, "ORIGINAL_COMPOSER");
			if (sComposer == "")
				sComposer = GetName(oNPC);
			string sName = GetLocalString(oInstrument, "SONG_NAME");
			if (sName == "")
				sName = "Untitled";
			SetFirstName(oScore, sName + " <i>(by " + sComposer + ")</i>");
			TransferSong(oInstrument, oScore);
			SetItemCharges(oScore, TKL_TRANSCRIPTION_CHARGES);
		}
	}
	
	// Set up Custom Tokens of all the "Server Songs" (ie, songs saved by DMs) available.
	else if (sAction == "LIST_SERVER_SONGS")
	{
		int i;
		string sName;
		for (i = 1; i <= 10; i++)
		{
			sName = GetTKLPersistString(OBJECT_INVALID, "TKL_SERVER_SONG_NAME" + IntToString(i));
			if (sName == "") sName = "...";	
			SetCustomToken(8764 + i, sName);
		}
	}
	
	// Play a "server song" (song saved by a DM)
	else if (sAction == "PLAY_SERVER_SONG")
	{
		PlayServerSong(oNPC, oInstrument, iParam1);
	}
	
	// Set up Custom Tokens for all the "blueprint scores" (song created from blueprint) in the NPC's inventory.
	// Uses Custom Tokens 2345 - 2354 (max of 10)
	else if (sAction == "LIST_BLUEPRINT_SCORES")
	{
		int iBlueprintScores = CatalogBlueprintScores(oNPC);
		
		// Make sure it's not more than 10
		if (iBlueprintScores > 10) iBlueprintScores = 10;
		
		// Now set up the Custom Tokens
		int i;
		for (i = 1; i <= 10; i++)
		{
			if (i <= iBlueprintScores)
				SetCustomToken(2344 + i, GetName(GetLocalObject(oNPC, "BLUEPRINT_SCORE" + IntToString(i))));
			else
				SetCustomToken(2344 + i, "...");
		}
	}
	
	else if (sAction == "PLAY_BLUEPRINT_SCORE")
	{	
		PlayBlueprintScore(oPC, oNPC, oInstrument, iParam1);
	}
	
	// Randomly choose between: server song, blueprint score, improvisation
	else if (sAction == "PLAY_RANDOM")
	{
		int iBlueprintScores = CatalogBlueprintScores(oNPC);
		int iServerSongs = 0;
		int i;
		for (i = 1; i <= 10; i++)
		{
			if (GetTKLPersistString(OBJECT_INVALID, "TKL_SERVER_SONG_NAME" + IntToString(i)) != "")
				iServerSongs++;
		}
		int iChoices = 0;
		if (iBlueprintScores > 0) 
		{
			iChoices++;
			SetLocalString(oNPC, "CHOICE" + IntToString(iChoices), "PLAY_A_BLUEPRINT_SCORE");	
		}
		if (iServerSongs > 0)
		{
			iChoices++;
			SetLocalString(oNPC, "CHOICE" + IntToString(iChoices), "PLAY_A_SERVER_SONG");
		}
		if (TOTAL_STYLES > 0)
		{
			iChoices++;
			SetLocalString(oNPC, "CHOICE" + IntToString(iChoices), "PLAY_AN_IMPROVISATION");
		}
		if (iChoices == 0)
		{
			SpeakString("Sorry, I don't have any songs available.");
			return;	
		}
		string sChoice = GetLocalString(oNPC, "CHOICE" + IntToString(Random(iChoices) + 1));
		if (sChoice == "PLAY_A_BLUEPRINT_SCORE")
			PlayBlueprintScore(oPC, oNPC, oInstrument, Random(iBlueprintScores) + 1);
		else if (sChoice == "PLAY_A_SERVER_SONG")
			PlayServerSong(oNPC, oInstrument, Random(iServerSongs) + 1);
		else
			ImproviseRandom(oNPC, oInstrument, oPC);
	}		
}
