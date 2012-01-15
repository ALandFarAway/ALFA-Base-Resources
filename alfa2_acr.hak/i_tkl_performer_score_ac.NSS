/*
Author: brockfanning
Date: Early 2008...
Purpose: This is the script that is called when someone activates the "score"
item that is produced by bards using TKL Performer with the "Transcribe"
function.

starting comments...
5/31/08: Added functionality for non-bards to use it to read lyrics. -bf
1/26/09: Added functionality for "blueprint scores" -bf
*/

#include "tkl_performer_include"

void main()
{
    object oPC      = GetItemActivator();
    object oScore    = GetItemActivated();
	object oInstrument = GetLocalObject(oPC, "TKL_PERFORMER_INSTRUMENT");
	// If the user is not holding an instrument, then they will simply read the lyrics (if any)
	if (GetIsObjectValid(oInstrument) == FALSE)
	{
		SendMessageToPC(oPC, "You look over the score to read the Lyrics.");
		DisplayGuiScreen(oPC, "TKL_PERFORMER_LYRICS", FALSE, "tkl_performer_lyrics.xml");
		RefreshLyrics(oPC, oScore, FALSE);
		SetGUIObjectDisabled(oPC, "TKL_PERFORMER_LYRICS", "LyricRecordButton1", TRUE);
		SetGUIObjectDisabled(oPC, "TKL_PERFORMER_LYRICS", "LyricRecordButton2", TRUE);
		SetGUIObjectDisabled(oPC, "TKL_PERFORMER_LYRICS", "LyricMuteButton", TRUE);
		SetGUIObjectHidden(oPC, "TKL_PERFORMER_LYRICS", "LyricText3", TRUE);
		SetGUIObjectHidden(oPC, "TKL_PERFORMER_LYRICS", "LyricText4", TRUE);
		SetLocalObject(oPC, "TKL_PERFORMER_SCORE", oScore);
		return;
	}
	
	// If the score is a "blueprint score" then read local strings on the score to create music
	// using the "write" function
	else if (GetLocalInt(oScore, "BLUEPRINT_SCORE") == TRUE)
	{
		// We'll be modifying this variable, so let's get the current value so we can set it back
		string sGUIFile = GetLocalString(oInstrument, "GUI_FILE");
		
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
				AssignCommand(oPC, DelayCommand(fDelay, WriteTrack(oPC, oInstrument, iTrack, sInput, sGUIFile)));
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
			AssignCommand(oPC, DelayCommand(fDelay + 0.5f, WriteLyrics(oPC, oInstrument, sLyricWrite))); 
		}
		
		// Transfer a few variables
		SetLocalString(oInstrument, "SONG_NAME", GetName(oScore));
		SetLocalString(oInstrument, "ORIGINAL_COMPOSER", GetLocalString(oScore, "ORIGINAL_COMPOSER"));
		RefreshNames(oPC, oInstrument);
		
		// Finish up by reseting the GUI_FILE string, setting the song length, and giving feedback
		SetLocalString(oInstrument, "GUI_FILE", sGUIFile);
		SendMessageToPC(oPC, "Learning song...");
	}
	
	// Otherwise transfer the song onto the instrument
	else
	{
		SendMessageToPC(oPC, "Learning song...");	
		TransferSong(oScore, oInstrument, TRUE);
	}
}