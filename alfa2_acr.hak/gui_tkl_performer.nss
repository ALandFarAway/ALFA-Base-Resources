/*
Script:
Author: brockfanning
Date: Early 2008...
Purpose: This is the main script that gets directly called from the TKL Performer
.xml files.  Most of the key functions can be found in tkl_perormer_included.

5/31/08: Many bugs fixed... brockfanning
6/11/08: rearranged actions to optimize performance, added "rolled offsets" to Quantize, added DCs to transcribing
1/24/09: Updated Write function to use new GUI screen, added Improv functions -brockfanning
1/26/09: Added NOTE_MODE functions, for seconds/beats editing, and scale-tones/half-steps editing -brockfanning
1/30/09: Added seconds/beats functionality for Copy pane, allowed negative PasteTo values
1/31/09: Added Duplicate Note, and Apply Metronome, made Record Pane automatically reset metronome to recorded value
3/12/09: Allow DMs to throw their voice to another NPC
*/

#include "tkl_performer_include"
#include "acr_xp_i"

void QuantizeNote(object oPC, object oInstrument, int iTrack, int iNote, float fTick, int iSubDivide=1)
{
	string sTrack = IntToString(iTrack);
	string sNote = IntToString(iNote);
	float fNearestBeat;
	if (iSubDivide == 0)
		iSubDivide = 1;
	fTick = fTick / IntToFloat(iSubDivide);
	if (fTick < 0.01)
		fTick = 0.01;
	float fPlayed = GetLocalFloat(oInstrument, "NOTE" + sNote + "PLAYBACK_TRACK" + sTrack);
	int iPitch = GetLocalInt(oInstrument, "NOTE" + sNote + "PITCH_TRACK" + sTrack);
	float fRolledOffset = 0.0f;
	// Apply "rolled" note offsets if necessary
	if (iPitch > 100 && iPitch < 137)
		fRolledOffset = TKL_CHORD_ROLL_OFFSET;
	else if (iPitch == 316 || iPitch == 317 || iPitch == 366 || iPitch == 367)
		fRolledOffset = TKL_DRUM_ROLL_OFFSET;
	fPlayed += fRolledOffset; // For rolled notes, tell the computer which beat it REALLY should be on.
	while (fPlayed > fNearestBeat)
	{
		fNearestBeat += fTick;
	}
	//check to see if the note should was played too early or too late
	float fEarly = fNearestBeat - fPlayed;
	float fLate = fPlayed - (fNearestBeat - fTick);
	if (fEarly <= fLate)
	{
		SetLocalFloat(oInstrument, "NOTE" + sNote + "PLAYBACK_TRACK" + sTrack, fNearestBeat - fRolledOffset);
	}
	else
	{
		SetLocalFloat(oInstrument, "NOTE" + sNote + "PLAYBACK_TRACK" + sTrack, (fNearestBeat - fTick) - fRolledOffset);
	}
}

int TogglePrimaryVariation(int iNote)
{	int iReturn;
	if (iNote >= 1 && iNote <= 24)
		iReturn = iNote + 50;
	else if (iNote >= 51 && iNote <= 74)
		iReturn = iNote - 50;
	else if (iNote >= 101 && iNote <= 136)
		iReturn = iNote + 50;
	else if (iNote >= 151 && iNote <= 186)
		iReturn = iNote - 50;
	else if (iNote >= 201 && iNote <= 224)
		iReturn = iNote + 50;
	else if (iNote >= 251 && iNote <= 274)
		iReturn = iNote - 50;
	else if (iNote >= 301 && iNote <= 335)
		iReturn = iNote + 50;
	else if (iNote >= 351 && iNote <= 385)
		iReturn = iNote - 50;
	else
		iReturn = iNote;		
	return iReturn;
}

int ToggleSecondaryVariation(int iNote)
{
	int iReturn;
	if (iNote >= 101 && iNote <= 112)
		iReturn = iNote + 12;
	else if (iNote >= 113 && iNote <= 124)
		iReturn = iNote + 12;
	else if (iNote >= 125 && iNote <= 136)
		iReturn = iNote - 24;
	else if (iNote >= 151 && iNote <= 162)
		iReturn = iNote + 12;
	else if (iNote >= 163 && iNote <= 174)
		 iReturn = iNote + 12;
	else if (iNote >= 175 && iNote <= 186)
		iReturn = iNote - 24;
	else if (iNote >= 301 && iNote <= 310)
		iReturn = iNote + 10;
	else if (iNote >= 311 && iNote <= 320)
		iReturn = iNote - 10;
	else if (iNote >= 351 && iNote <= 360)
		iReturn = iNote + 10;
	else if (iNote >= 361 && iNote <= 370)
		iReturn = iNote - 10;
	else
		iReturn = iNote;
	return iReturn;
}

// Takes any chord pitch and returns a long lute note of a certain pitch as an embellishment
// The embellishments are: 6, m7, M7, b9, 9, #9, #11, b13, 13
int GetEmbellishmentPitch(int iChord, int iEmbellishment)
{
	// get the bass note of the chord
	// convert block to rolled
	if (iChord > 150) iChord -= 50;
	// convert diminished to minor
	if (iChord > 124) iChord -= 12;
	// convert minor to major
	if (iChord > 112) iChord -= 12;
	// convert to lute note (1st octave)
	iChord -= 100;
	// abort if not valid
	if (iChord < 1) return 0;
	int iReturn = iChord;
	
	switch (iEmbellishment)
	{
		case 1: iReturn += 9; break; // 6
		case 2: iReturn += 10; break; // m7
		case 3: iReturn += 11; break; // M7
		case 4: iReturn += 13; break; // b9
		case 5: iReturn += 14; break; // 9
		case 6: iReturn += 15; break; // #9
		case 7: iReturn += 18; break; // #11
		case 8: iReturn += 20; break; // b13
		case 9: iReturn += 21; break; // 13
		case 10: iReturn += 12; break; // root
		case 11: iReturn += 15; break; // minor third
		case 12: iReturn += 16; break; // major third
		case 13: iReturn += 19; break; // fifth
	}
	
	// special cases: the 1st octave sounds better with some chords
	switch (iChord)
	{
		case 10: case 11: case 12:
			iReturn -= 12;
	}
	// Make sure we didn't go over the highest note of the 2nd octave
	while (iReturn > 24)
	{
		iReturn -= 12;
	}
	return iReturn;
}

void main(string sAction, int iOption)
{
	object oPC = OBJECT_SELF;
	object oInstrument = GetLocalObject(oPC, "TKL_PERFORMER_INSTRUMENT");
	
	if (sAction == "RECORD_NOTE")
	{
		int iTrack = GetLocalInt(oInstrument, "RECORDING_TRACK");
		if (iTrack > 0)
		{
			string sTrack = IntToString(iTrack);
			float fSecondsIn = StringToFloat(QueryTimer(oInstrument, "PLAYBACK")) / 1000000.0f;
			int iNotesRecorded = GetLocalInt(oInstrument, "NOTES_RECORDED_TRACK" + sTrack);
			iNotesRecorded++;
			SetLocalInt(oInstrument, "NOTES_RECORDED_TRACK" + sTrack, iNotesRecorded);
			string sID = "NOTE" + IntToString(iNotesRecorded);
			SetLocalFloat(oInstrument, sID + "PLAYBACK_TRACK" + sTrack, fSecondsIn);
			SetLocalInt(oInstrument, sID + "PITCH_TRACK" + sTrack, iOption);
			SendMessageToPC(oPC, "Note recorded at time: " + FloatToString(fSecondsIn) + " on Track " + sTrack);
			ACR_RPXPMarkActive(oPC);
		}
	}
	
	else if (sAction == "PLAY_LIVE")
	{
		int iKey = GetLocalInt(oInstrument, "KEY");
		PlayNote(iOption, iKey);
		ACR_RPXPMarkActive(oPC);
	}
	
	else if (sAction == "LYRIC_SING")
	{
		// check to see if someone is just holding a score, instead of any instrument
		if (GetIsObjectValid(oInstrument) == FALSE)
			oInstrument = GetLocalObject(oPC, "TKL_PERFORMER_SCORE");
		string sLyric = GetLocalString(oInstrument, "LYRIC" + IntToString(iOption));
		if (sLyric == "")
		{
			SendMessageToPC(oPC, "There is no lyric in that slot.");
			return;
		}
		// allow DMs to throw their voice to a selected NPC
		if (GetIsDM(oPC))
		{
			object oNPC = GetPlayerCurrentTarget(oPC);
			if (GetObjectType(oNPC) == OBJECT_TYPE_CREATURE && !GetIsPC(oNPC))
				AssignCommand(oNPC, SpeakString(sLyric));
			else
				SpeakString(sLyric);
		}
		else
			SpeakString(sLyric);
		if (GetLocalInt(oInstrument, "RECORDING_LYRICS"))
		{
			float fSecondsIn = StringToFloat(QueryTimer(oInstrument, "PLAYBACK")) / 1000000.0f;
			int iLyricsRecorded = GetLocalInt(oInstrument, "LYRICS_RECORDED");
			iLyricsRecorded++;
			SetLocalInt(oInstrument, "LYRICS_RECORDED", iLyricsRecorded);
			string sID = "LYRIC" + IntToString(iLyricsRecorded);
			SetLocalFloat(oInstrument, sID + "PLAYBACK", fSecondsIn);
			SetLocalInt(oInstrument, sID + "TEXT", iOption);
			SendMessageToPC(oPC, "Lyric recorded at time: " + FloatToString(fSecondsIn) + ".");	
		}	
		ACR_RPXPMarkActive(oPC);
	}
	
	else if (sAction == "LAG_CHECK")
	{
		string sStop;
		if (TKL_NWNX4_NOT_INSTALLED)
		{
			SendMessageToPC(oPC, "This function is disabled on this server.");
			return;
		}
		if (iOption == 0)
		{
			sStop = StopTimer(oInstrument, "PLAYBACK");
			StartTimer(oInstrument, "PLAYBACK");
			PlaySound("tkl_performer_lag_check");
			SetGUIObjectHidden(oPC, TKL_PERFORMER_SCREEN, "LagCheckPane", FALSE);
		}
		else if (iOption == 1)
		{
			sStop = StopTimer(oInstrument, "PLAYBACK");
			SetGUIObjectHidden(oPC, TKL_PERFORMER_SCREEN, "LagCheckPane", TRUE);
			float fSecondsIn = StringToFloat(sStop) / 1000000.0f;
			fSecondsIn -= 9.089f;
			if (fSecondsIn <= 0.0f)
			{
				SendMessageToPC(oPC, "Lag check unsuccessful: You clicked too early.  Please try again.");
			}
			else
			{
				SendMessageToPC(oPC, "Lag check successful: Result = " + FloatToString(fSecondsIn, 4, 2));
				SendMessageToPC(oPC, "This amount will be deducted from all recording times.");
				SendMessageToPC(oPC, "If you feel you didn't click at the right time, please try again.");
				SetLocalFloat(oPC, "LAG_CHECK", fSecondsIn);
				SetTKLPersistFloat(oPC, "LAG_CHECK", fSecondsIn);
				RefreshRecordPane(oPC, oInstrument);
			}			
		}
		else
		{
			DeleteLocalFloat(oPC, "LAG_CHECK");
			SendMessageToPC(oPC, "Lag Check reset successfully.");
		}
	}	
	
	else if (sAction == "EASY_MODE")
	{
		if (GetLocalInt(oInstrument, "EASY_MODE"))
			DeleteLocalInt(oInstrument, "EASY_MODE");
		else
			SetLocalInt(oInstrument, "EASY_MODE", TRUE);
		RefreshNoteNames(oPC, oInstrument);
		RefreshModes(oPC, oInstrument);
	}
	
	else if (sAction == "MINOR_MODE")
	{
		if (GetLocalInt(oInstrument, "MINOR_MODE"))
			DeleteLocalInt(oInstrument, "MINOR_MODE");
		else
			SetLocalInt(oInstrument, "MINOR_MODE", TRUE);
		RefreshNoteNames(oPC, oInstrument);
		RefreshModes(oPC, oInstrument);
	}
	
	else if (sAction == "PREVIOUS_NOTE")
	{
		int bGoToBeginning = FALSE;
		if (iOption >= 5)
		{
			iOption -= 4;
			bGoToBeginning = TRUE;
		}
		int iTrack = GetLocalInt(oPC, "TKL_PERFORMER_OPTION");
		string sTrack = IntToString(iTrack);
		int iCurrentNote = GetLocalInt(oInstrument, "CURRENT_NOTE_TRACK" + sTrack);
		if (iCurrentNote == 0)
			iCurrentNote = 1;
		
		if (bGoToBeginning)
			iCurrentNote = 1;
		else
			iCurrentNote--;
		
		if (iCurrentNote < 1)
			iCurrentNote = 1;
		SetLocalInt(oInstrument, "CURRENT_NOTE_TRACK" + sTrack, iCurrentNote);
		PlayNote(GetLocalInt(oInstrument, "NOTE" + IntToString(iCurrentNote) + "PITCH_TRACK" + sTrack),
			GetLocalInt(oInstrument, "KEY"));
		RefreshNotePane(oPC, oInstrument);
	}
	
	else if (sAction == "NEXT_NOTE")
	{
		int bGoToEnd = FALSE;
		if (iOption >= 5)
		{
			iOption -= 4;
			bGoToEnd = TRUE;
		}
		int iTrack = GetLocalInt(oPC, "TKL_PERFORMER_OPTION");
		string sTrack = IntToString(iTrack);
		int iCurrentNote = GetLocalInt(oInstrument, "CURRENT_NOTE_TRACK" + sTrack);
		if (iCurrentNote == 0)
			iCurrentNote = 1;
		int iEnd = GetLocalInt(oInstrument, "NOTES_RECORDED_TRACK" + sTrack);
		if (bGoToEnd)
			iCurrentNote = iEnd;
		else
			iCurrentNote++;
		
		if (iCurrentNote > iEnd)
			iCurrentNote = iEnd;
		SetLocalInt(oInstrument, "CURRENT_NOTE_TRACK" + sTrack, iCurrentNote);
		PlayNote(GetLocalInt(oInstrument, "NOTE" + IntToString(iCurrentNote) + "PITCH_TRACK" + sTrack),
			GetLocalInt(oInstrument, "KEY"));
		RefreshNotePane(oPC, oInstrument);
	}
	
	else if (sAction == "CURRENT_NOTE")
	{
		int iTrack = GetLocalInt(oPC, "TKL_PERFORMER_OPTION");
		string sTrack = IntToString(iTrack);
		int iCurrentNote = GetLocalInt(oInstrument, "CURRENT_NOTE_TRACK" + sTrack);
		if (iCurrentNote == 0)
			iCurrentNote = 1;
		PlayNote(GetLocalInt(oInstrument, "NOTE" + IntToString(iCurrentNote) + "PITCH_TRACK" + sTrack),
			GetLocalInt(oInstrument, "KEY"));
	}
	
	
	else if (sAction == "HELP")
	{
		DisplayGuiScreen(oPC, "TKL_PERFORMER_HELP", FALSE, "tkl_performer_help.xml");	
	}
	
	else if (sAction == "TRACK_PLAY")
	{
		PlayTrack(oPC, oInstrument, iOption, FALSE, FALSE, TRUE);
	}
	
	else if (sAction == "DISABLE_MUSIC")
	{
		object oArea = GetArea(oPC);
		if (iOption == 0)
		{
			if (TKL_ALLOW_DISABLE_MUSIC)
			{
				MusicBackgroundStop(oArea);
				SendMessageToPC(oPC, "Background music in this area is now OFF.");
				SendMessageToPC(oPC, "Right-click this button to turn it back on.");
			}
			else
				SendMessageToPC(oPC, "This function is disabled on this server.");
		}
		else if (iOption == 1)
		{
			MusicBackgroundPlay(oArea);
			SendMessageToPC(oPC, "Background music ON.");
		}
		else if (iOption == 2)
		{
			if (TKL_ALLOW_DISABLE_SOUNDS)
			{
				AmbientSoundStop(oArea);
				SendMessageToPC(oPC, "Background sounds in this area are now OFF.");
				SendMessageToPC(oPC, "Right-click this button to turn them back on.");
			}
			else
				SendMessageToPC(oPC, "This function is disabled on this server.");
		}
		else
		{
			AmbientSoundPlay(oArea);
			SendMessageToPC(oPC, "Background sounds ON.");
		}					
	}
	
	else if (sAction == "LYRIC_RECORD")
	{
		if (TKL_NWNX4_NOT_INSTALLED)
		{
			SendMessageToPC(oPC, "This function is disabled on this server.");
			return;
		}
		SetLocalString(oPC, "TKL_PERFORMER_ACTION", "LYRIC_RECORD");
		string sMessage = "Are you sure you want to record a new Lyric Track? (The current Lyric Track will be overwritten.)";
		DisplayMessageBox(oPC, 0, sMessage, "gui_tkl_performer_message", "gui_tkl_performer_cancel", TRUE); 		
	}
	
	else if (sAction == "LYRIC_LEARN")
	{
		if (GetIsObjectValid(oInstrument) == FALSE)
			return;
		SetLocalInt(oPC, "TKL_PERFORMER_OPTION", iOption);
		SetLocalString(oPC, "TKL_PERFORMER_ACTION", "LYRIC_LEARN");
		DisplayInputBox(oPC, 0, "Please type your lyric:", "gui_tkl_performer_input", "gui_tkl_performer_cancel", TRUE);	
	}
	
	else if (sAction == "NEW")
	{
		PassTKLParameters(oPC, sAction, iOption);
		string sMessage;
		string sTrack = IntToString(iOption);
		if (iOption == 0)
			sMessage = "Are you sure you want to erase this song? (Unsaved recordings will be lost.)";
		else
			sMessage = "Are you sure you want to erase Track " + sTrack + "?";
		DisplayMessageBox(oPC, 0, sMessage, "gui_tkl_performer_message", "gui_tkl_performer_cancel", TRUE); 
	}
	
	else if (sAction == "TRANSCRIBE")
	{
		if (TKL_ONE_TRANSCRIPTION_PER_HOUR && GetLocalInt(oPC, "TKL_PERFORMER_LAST_SCORE") == GetTimeHour())
		{
			SendMessageToPC(oPC, "You need to wait a while before you transcribe again.");
			return;
		}
		if (TKL_TRANSCRIPTIONS_PER_RESET > 0 && GetLocalInt(oPC, "TKL_TRANSCRIPTIONS_DONE") >= TKL_TRANSCRIPTIONS_PER_RESET)
		{
			SendMessageToPC(oPC, "You must wait until the next server-reset before transcribing more.");
			return;
		}
		if (TKL_ONE_TRANSCRIPTION_PER_HOUR)
			SetLocalInt(oPC, "TKL_PERFORMER_LAST_SCORE", GetTimeHour());
		if (TKL_TRANSCRIPTIONS_PER_RESET > 0)
			SetLocalInt(oPC, "TKL_TRANSCRIPTIONS_DONE", GetLocalInt(oPC, "TKL_TRANSCRIPTIONS_DONE") + 1);
		if (TKL_TRANSCRIPTION_DC > 0)
		{
			int iDC = TKL_TRANSCRIPTION_DC;
			if (TKL_TRANSCRIPTION_LENGTH_PENALTY > 0)
			{
				int iTotalNotes = 
					GetLocalInt(oInstrument, "NOTES_RECORDED_TRACK1") +
					GetLocalInt(oInstrument, "NOTES_RECORDED_TRACK2") +
					GetLocalInt(oInstrument, "NOTES_RECORDED_TRACK3") +
					GetLocalInt(oInstrument, "NOTES_RECORDED_TRACK4") +
					GetLocalInt(oInstrument, "LYRICS_RECORDED");
				iDC += iTotalNotes / TKL_TRANSCRIPTION_LENGTH_PENALTY;
			}
			int iRoll = d20();
			int iSkill = GetPerform(oPC);
			SendMessageToPC(oPC, 
				"Perform check: " + 
				IntToString(iSkill) +
				" + " +
				IntToString(iRoll) +
				" = " +
				IntToString(iRoll + iSkill) +
				" vs. DC " +
				IntToString(iDC));
			if (iSkill + iRoll >= iDC)
			{
				SendMessageToPC(oPC, "Transcription Succeeded.");
			}
			else
			{
				SendMessageToPC(oPC, "Transcription Failed.");
				return;
			}	
		}
		object oScore = CreateItemOnObject("tkl_performer_score", oPC);
		string sComposer = GetLocalString(oInstrument, "ORIGINAL_COMPOSER");
		if (sComposer == "")
			sComposer = GetName(oPC);
		string sName = GetLocalString(oInstrument, "SONG_NAME");
		SetFirstName(oScore, sName + " <i>(by " + sComposer + ")</i>");
		TransferSong(oInstrument, oScore);
		SetItemCharges(oScore, TKL_TRANSCRIPTION_CHARGES);
	}
	
	else if (sAction == "STOP_RECORDING")
	{
		if (GetLocalInt(oInstrument, "RECORDING_TRACK") > 0 || GetLocalInt(oInstrument, "RECORDING_LYRICS") == TRUE)
			StopRecording(oPC, oInstrument);
	}
	
	else if (sAction == "TRACK_AHEAD")
	{
		float fAdjust;
		string sMessage;
		if (iOption > 4)
		{
			fAdjust = -3.0f;
			iOption -= 4;
		}
		else
			fAdjust = -0.1f;
		string sTrack = IntToString(iOption);
		
		float fDelay = GetLocalFloat(oInstrument, "NOTE1PLAYBACK_TRACK" + sTrack);
		if (fDelay + fAdjust < 0.0f)
		{
			sMessage = "Sorry, track " + sTrack + " can't be moved ahead any further.";
			SendMessageToPC(oPC, sMessage);
			return;
		}

		float fOffset = GetLocalFloat(oInstrument, "OFFSET" + sTrack);
		fOffset += fAdjust;
		sMessage = "Track " + sTrack + " will be adjusted by " + FloatToString(fOffset, 4, 1) + " seconds.";
		SetLocalFloat(oInstrument, "OFFSET" + sTrack, fOffset);
		
		int iTotalNotes = GetLocalInt(oInstrument, "NOTES_RECORDED_TRACK" + sTrack);
		while (iTotalNotes > 0)
		{
			SetLocalFloat(oInstrument, "NOTE" + IntToString(iTotalNotes) + "PLAYBACK_TRACK" + sTrack,
				GetLocalFloat(oInstrument, "NOTE" + IntToString(iTotalNotes) + "PLAYBACK_TRACK" + sTrack) + fAdjust);
			iTotalNotes--;
		}
		
		SendMessageToPC(oPC, sMessage);		
	}
	
	else if (sAction == "TRACK_BEHIND")
	{
		float fAdjust;
		string sMessage;
		if (iOption > 4)
		{
			fAdjust = 3.0f;
			iOption -= 4;
		}
		else
			fAdjust = 0.1f;
		string sTrack = IntToString(iOption);
		float fOffset = GetLocalFloat(oInstrument, "OFFSET" + sTrack);
		fOffset += fAdjust;
		sMessage = "Track " + sTrack + " will be adjusted by " + FloatToString(fOffset, 4, 1) + " seconds.";
		SetLocalFloat(oInstrument, "OFFSET" + sTrack, fOffset);
		int iTotalNotes = GetLocalInt(oInstrument, "NOTES_RECORDED_TRACK" + sTrack);
		while (iTotalNotes > 0)
		{
			SetLocalFloat(oInstrument, "NOTE" + IntToString(iTotalNotes) + "PLAYBACK_TRACK" + sTrack, 
				GetLocalFloat(oInstrument, "NOTE" + IntToString(iTotalNotes) + "PLAYBACK_TRACK" + sTrack) + fAdjust);
			iTotalNotes--;
		}
		
		SendMessageToPC(oPC, sMessage);		
	}
	
	else if (sAction == "TRACK_ADJUST")
	{
		string sTrack = IntToString(iOption);
		float fOffset = GetLocalFloat(oInstrument, "OFFSET" + sTrack);
		SendMessageToPC(oPC, "Click - or + to adjust the timing of this track.");
		SendMessageToPC(oPC, "Currently, Track " + sTrack + " has an offset of: " + FloatToString(fOffset, 4, 1) + " seconds.");		
	}
	
	else if (sAction == "SONG_PLAY")
	{		
		PlaySong(oPC, oInstrument, 0, TRUE);
		ACR_RPXPMarkActive(oPC);
	}
	
	else if (sAction == "CLOSE")
	{
		CloseGUIScreen(oPC, TKL_PERFORMER_SCREEN);
		CloseGUIScreen(oPC, "TKL_PERFORMER_LYRICS");
	}
	
	else if (sAction == "TRACK_RECORD")
	{
		if (TKL_NWNX4_NOT_INSTALLED)
		{
			SendMessageToPC(oPC, "This function is disabled on this server.");
			return;
		}
		SetGUIObjectHidden(oPC, TKL_PERFORMER_SCREEN, "RecordPane", TRUE);
		int iOption = GetLocalInt(oPC, "TKL_PERFORMER_OPTION");
		if (GetLocalInt(oInstrument, "METRONOME_ON"))
		{
			int iSeconds = GetLocalInt(oInstrument, "METRONOME_DURATION");
			SendMessageToPC(oPC, "Metronome will play for " + IntToString(iSeconds) + " seconds.");
			int iTempo = GetLocalInt(oInstrument, "METRONOME");
			if (iTempo == 0)
				iTempo = 60;
			PlayMetronome(oPC, iTempo, iSeconds);
			PlaySong(oPC, oInstrument, iOption, TRUE, TRUE, TRUE);
			RecordTrack(oPC, oInstrument, iOption);
		}
		else
		{
			PlaySong(oPC, oInstrument, iOption, TRUE, TRUE, TRUE);
			RecordTrack(oPC, oInstrument, iOption);		
		}
		ClearTKLPerformerVariables(oPC);		
	}
	
	else if (sAction == "RENAME")
	{
		string sOption, sOldName;
		if (iOption > 0)
		{
			sOption = IntToString(iOption);
			sOldName = GetLocalString(oInstrument, "TRACK_" + sOption + "_NAME");
			if (sOldName == "")
				sOldName = "Track " + sOption;
		}
		else
		{
			sOldName = GetLocalString(oInstrument, "SONG_NAME");
			if (sOldName == "")
				sOldName = "Opus #1";
		}
		PassTKLParameters(oPC, sAction, iOption);
		DisplayInputBox(oPC, 0, "What would you like to name this track?", "gui_tkl_performer_input", "gui_tkl_performer_cancel", TRUE, "", 0, "Rename", 0, "Cancel", sOldName);	
	}
	
	else if (sAction == "WRITE")
	{
		if (GetLocalInt(oInstrument, "METRONOME_ON") == FALSE)
		{
			SendMessageToPC(oPC, "Sorry, you can only input tracks if you have the Metronome on.");
			return;
		}
		SetGUIObjectHidden(oPC, TKL_PERFORMER_SCREEN, "RecordPane", TRUE);
		int iTrack = GetLocalInt(oPC, "TKL_PERFORMER_OPTION");
		string sOldWrite = GetLocalString(oInstrument, "WRITE_TRACK" + IntToString(iTrack));
		PassTKLParameters(oPC, sAction, iTrack);
		DisplayGuiScreen(oPC, "TKL_PERFORMER_WRITE", TRUE, "tkl_performer_write.xml");
		SetGUIObjectText(oPC, "TKL_PERFORMER_WRITE", "inputbox", -1, sOldWrite);
		//DisplayInputBox(oPC, 0, "Please write the notes for this track. (WARNING: This will overwrite the track. See the help file for instructions)", "gui_tkl_performer_input", "gui_tkl_performer_cancel", TRUE, "", 0, "Write", 0, "Cancel", sOldWrite);	
	}
	
	else if (sAction == "SONG_TEMPO")
	{
		int iTempo = GetLocalInt(oInstrument, "TEMPO");
		if (iTempo < 1)
			iTempo = 100;
		int iAdjust;
		if (iOption == 0)
			iAdjust = -1;
		else if (iOption == 1)
			iAdjust = -5;
		else if (iOption == 2)
			iAdjust = 1;
		else if (iOption == 3)
			iAdjust = 5;
		else if (iOption == 4)
		{
			SendMessageToPC(oPC, "Click + or - to adjust the speed of this song.");
			SendMessageToPC(oPC, "The current speed is " + IntToString(100 + (100-iTempo)) + "%.");
			return;
		}
	
		iTempo += iAdjust;
		int iMaxSpeed = GetMaximumSpeed(oPC);
		if (iTempo < (100 - iMaxSpeed))
		{
			SendMessageToPC(oPC, "Until you increase your Perform skill, this is as fast as you can play.");
			iTempo = 100 - iMaxSpeed;
		}
		if (iTempo < 1)
			iTempo == 1;
		SetLocalInt(oInstrument, "TEMPO", iTempo);
		SendMessageToPC(oPC, "Speed changed to  " + IntToString(100 + (100-iTempo)) + "%.");
		SetLocalFloat(oInstrument, "SONG_LENGTH", GetSongLength(oInstrument));
	}
	
	else if (sAction == "METRONOME")
	{
		int iTempo = GetLocalInt(oInstrument, "METRONOME");
		if (iTempo < 1)
			iTempo = 60;
		int iAdjust;
		
		if (iOption == 0)
			iAdjust = 1;
		else if (iOption == 1)
			iAdjust = 5;
		else if (iOption == 2)
			iAdjust = -1;
		else if (iOption == 3)
			iAdjust = -5;
		// turn on metronome
		else if (iOption == 4)
		{
			SetLocalInt(oInstrument, "METRONOME_ON", TRUE);
			SetGUIObjectDisabled(oPC, TKL_PERFORMER_SCREEN, "ApplyMetronome", FALSE);
			RefreshRecordPane(oPC, oInstrument);
			return;
		}
		// turn off metronome
		else if (iOption == 5)
		{
			DeleteLocalInt(oInstrument, "METRONOME_ON");
			SetGUIObjectDisabled(oPC, TKL_PERFORMER_SCREEN, "ApplyMetronome", TRUE);
			RefreshRecordPane(oPC, oInstrument);
			return;
		}
		// set the current value as the recorded metronome setting
		else if (iOption == 6)
		{
			SetGUIObjectDisabled(oPC, TKL_PERFORMER_SCREEN, "ApplyMetronome", TRUE);
			int iTrack = GetLocalInt(oPC, "TKL_PERFORMER_OPTION");
			SetLocalInt(oInstrument, "METRONOME_RECORDED_TRACK" + IntToString(iTrack), iTempo);
			SendMessageToPC(oPC, "Metronome " + IntToString(iTempo) + " applied to Track " + IntToString(iTrack) + ".");
			return;
		}
			
		iTempo += iAdjust;
		if (iTempo < 1)
			iTempo = 1;
		SetLocalInt(oInstrument, "METRONOME", iTempo);
		SetGUIObjectDisabled(oPC, TKL_PERFORMER_SCREEN, "ApplyMetronome", FALSE);
		RefreshRecordPane(oPC, oInstrument);
	}
	
	else if (sAction == "METRONOME_DURATION")
	{
		int iDuration = GetLocalInt(oInstrument, "METRONOME_DURATION");
		if (iDuration < 1)
			iDuration = 60;
		int iAdjust;
		if (iOption == 0)
			iAdjust = 1;
		else if (iOption == 1)
			iAdjust = 5;
		else if (iOption == 2)
			iAdjust = -1;
		else if (iOption == 3)
			iAdjust = -5;
				
		iDuration += iAdjust;
		if (iDuration < 1)
			iDuration = 1;
		if (iDuration > 300)
			iDuration = 300;
		SetLocalInt(oInstrument, "METRONOME_DURATION", iDuration);
		RefreshRecordPane(oPC, oInstrument);
	}
	
	else if (sAction == "QUANTIZE")
	{
		if (iOption == 0)
		{
			int iTrack = GetLocalInt(oPC, "TKL_PERFORMER_OPTION");
			string sTrack = IntToString(iTrack);
			int iTempo = GetLocalInt(oInstrument, "METRONOME_RECORDED_TRACK" + sTrack);
			
			float fTick = 60.0f / IntToFloat(iTempo);
			int iSubdivide = GetLocalInt(oInstrument, "QUANTIZE_SUBDIVIDE");
			if (iSubdivide == 0)
				iSubdivide = 1;
			int iTotalNotes = GetLocalInt(oInstrument, "NOTES_RECORDED_TRACK" + sTrack);
			SendMessageToPC(oPC, "Quantizing " + IntToString(iTotalNotes) + " notes.");
			while (iTotalNotes > 0)
			{
				QuantizeNote(oPC, oInstrument, iTrack, iTotalNotes, fTick, iSubdivide);
				iTotalNotes--;
			}
			SendMessageToPC(oPC, "Quantize successful.");
			SetGUIObjectHidden(oPC, TKL_PERFORMER_SCREEN, "QuantizePane", TRUE);
		}
		else
			SetLocalInt(oInstrument, "QUANTIZE_SUBDIVIDE", iOption);
	}
		
	else if (sAction == "SONG_LOAD")
	{
		string sName;
		if (GetIsDM(oPC))
			sName = GetTKLPersistString(OBJECT_INVALID, "TKL_SERVER_SONG_NAME" + IntToString(iOption));
		else
		{
			sName = GetTKLPersistString(oPC, "TKL_SONG_NAME" + IntToString(iOption));
			if (sName == "")
				sName = GetTKLPersistString(oPC, "TKL_PERFORMER_SONG_NAME" + IntToString(iOption));
		}
		//string sName = GetTKLPersistString(oPC, "TKL_SONG_NAME" + IntToString(iOption));
		//if (sName == "")
		//	sName = GetTKLPersistString(oPC, "TKL_PERFORMER_SONG_NAME" + IntToString(iOption));
		if (sName == "")
		{
			SendMessageToPC(oPC, "There is not a song in that slot.");
			return;
		}
		else
		{
			RefreshSongList(oPC);
			PassTKLParameters(oPC, sAction, iOption);
			DisplayMessageBox(oPC,0,"Are you sure you want to load " + sName + "? (Any unsaved changes will be lost)",
				"gui_tkl_performer_message", "gui_tkl_performer_cancel", TRUE);
		}		
	}
	
	else if (sAction == "SONG_SAVE")
	{
		string sText;
		string sName = GetTKLPersistString(oPC, "TKL_SONG_NAME" + IntToString(iOption));
		if (sName == "")
			sName = GetTKLPersistString(oPC, "TKL_PERFORMER_SONG_NAME" + IntToString(iOption));
		if (sName == "")
			sText = "Click 'Ok' to save this song.";
		else
			sText = "Saving this song will overwrite " + sName + ".  Are you sure?";
		PassTKLParameters(oPC, sAction, iOption);
		DisplayMessageBox(oPC,0, sText,
				"gui_tkl_performer_message", "gui_tkl_performer_cancel", TRUE);
	}
	
	else if (sAction == "SONG_PREVIEW")
	{		
		PlaySong(oPC, oInstrument, 0, TRUE, FALSE, FALSE, TRUE);
	}
	
	else if (sAction == "TRACK_PREVIEW")
	{		
		PlayTrack(oPC, oInstrument, iOption, FALSE, FALSE, TRUE, TRUE);
	}
		
	else if (sAction == "KEY_CHANGE")
	{
		SetLocalInt(oInstrument, "KEY", iOption);
		RefreshNoteNames(oPC, oInstrument);	
	}
	
	else if (sAction == "TRACK_MUTE")
	{
		string sOption = IntToString(iOption);
		if (GetLocalInt(oInstrument, "TRACK" + sOption + "MUTE"))
			DeleteLocalInt(oInstrument, "TRACK" + sOption + "MUTE");
		else
			SetLocalInt(oInstrument, "TRACK" + sOption + "MUTE", TRUE);
		RefreshMuting(oPC, oInstrument);
	}
	
	else if (sAction == "LYRIC_MUTE")
	{
		if (GetLocalInt(oInstrument, "LYRICS_MUTED"))
			DeleteLocalInt(oInstrument, "LYRICS_MUTED");
		else
			SetLocalInt(oInstrument, "LYRICS_MUTED", TRUE);
		RefreshMuting(oPC, oInstrument);
	}
	
	else if (sAction == "LAG_TOGGLE")
	{
		if (TKL_NWNX4_NOT_INSTALLED)
		{
			SendMessageToPC(oPC, "This function is disabled on this server.");
			return;
		}
		if (iOption == 1)
		{
			SetLocalInt(oPC, "LAG_CHECK_ON", TRUE);
			float fLagCheck = GetLocalFloat(oPC, "LAG_CHECK");
			if (fLagCheck <= 0.01f)
			{
				RefreshRecordPane(oPC, oInstrument);
				string sStop = StopTimer(oInstrument, "PLAYBACK");
				StartTimer(oInstrument, "PLAYBACK");
				PlaySound("tkl_performer_lag_check");
				SetGUIObjectHidden(oPC, TKL_PERFORMER_SCREEN, "LagCheckPane", FALSE);
			}
			RefreshRecordPane(oPC, oInstrument);
		}
		else if (iOption == 0)
		{
			DeleteLocalInt(oPC, "LAG_CHECK_ON");
			RefreshRecordPane(oPC, oInstrument);
		}		
	}

	else if (sAction == "RECORD_PANE")
	{
		// Set the metronome setting based on what was recorded/written (or default to 60)
		int iRecordedMetronome = GetLocalInt(oInstrument, "METRONOME_RECORDED_TRACK" + IntToString(iOption));
		if (iRecordedMetronome == 0)
			SetLocalInt(oInstrument, "METRONOME", 60);
		else
			SetLocalInt(oInstrument, "METRONOME", iRecordedMetronome);
		SetGUIObjectDisabled(oPC, TKL_PERFORMER_SCREEN, "ApplyMetronome", TRUE);
		SetGUIObjectHidden(oPC, TKL_PERFORMER_SCREEN, "RecordPane", FALSE);
		PassTKLParameters(oPC, sAction, iOption);
		RefreshRecordPane(oPC, oInstrument);
	}
	
	else if (sAction == "QUANTIZE_PANE")
	{
		string sTrack = IntToString(iOption);
		int iTempo = GetLocalInt(oInstrument, "METRONOME_RECORDED_TRACK" + sTrack);
		if (iTempo == 0)
		{
			SendMessageToPC(oPC, "Sorry, you can only quantize tracks that were recorded with the metronome on.");
			return;
		}
		SetGUIObjectHidden(oPC, TKL_PERFORMER_SCREEN, "QuantizePane", FALSE);
		PassTKLParameters(oPC, sAction, iOption);
	}
	
	else if (sAction == "LYRIC_PANE")
	{
		DisplayGuiScreen(oPC, "TKL_PERFORMER_LYRICS", FALSE, "tkl_performer_lyrics.xml");
		SetGUIObjectDisabled(oPC, "TKL_PERFORMER_LYRICS", "LyricRecordButton1", FALSE);
		SetGUIObjectDisabled(oPC, "TKL_PERFORMER_LYRICS", "LyricRecordButton2", FALSE);
		SetGUIObjectDisabled(oPC, "TKL_PERFORMER_LYRICS", "LyricMuteButton", FALSE);
		SetGUIObjectHidden(oPC, "TKL_PERFORMER_LYRICS", "LyricText3", FALSE);
		SetGUIObjectHidden(oPC, "TKL_PERFORMER_LYRICS", "LyricText4", FALSE);
		RefreshLyrics(oPC, oInstrument);
	}
	
	else if (sAction == "COPY")
	{
		int iDestinationTrack = GetLocalInt(oInstrument, "COPY_TO_TRACK");
		if (iDestinationTrack == 0)
			iDestinationTrack = 1;
		
		int iSourceTrack = GetLocalInt(oPC, "TKL_PERFORMER_OPTION");
		int bDeleteSource = GetLocalInt(oInstrument, "DELETE_SOURCE");
		int bBeats = GetLocalInt(oInstrument, "COPY_MODE_BEATS");
		float fCopyFrom, fPasteTo;
		// If we're in beats mode...
		if (bBeats)
		{
			int iMetronome = GetLocalInt(oInstrument, "METRONOME_RECORDED_TRACK" + IntToString(iSourceTrack));
			if (iMetronome == 0)
			{
				SendMessageToPC(oPC, "Sorry, you cannot copy in 'beats' mode because the source track was not recorded with a metronome.");
				return;
			}
			float fBeat = 60.0 / IntToFloat(iMetronome);
			fCopyFrom = fBeat * IntToFloat(GetLocalInt(oInstrument, "COPY_FROM_BEATS"));
			fPasteTo = fBeat * IntToFloat(GetLocalInt(oInstrument, "PASTE_TO_BEATS"));
		}
		// Otherwise if we're in seconds mode...
		else
		{
			fCopyFrom = GetLocalFloat(oInstrument, "COPY_FROM");
			fPasteTo = GetLocalFloat(oInstrument, "PASTE_TO");
		}
		//SendMessageToPC(oPC, "Copy from = " + FloatToString(fCopyFrom));
		//SendMessageToPC(oPC, "Paste to = " + FloatToString(fPasteTo));
		string sSourceTrack = IntToString(iSourceTrack);
		string sDestinationTrack = IntToString(iDestinationTrack);
		int iSourceNotes = GetLocalInt(oInstrument, "NOTES_RECORDED_TRACK" + sSourceTrack);
		int iDestinationNotes = GetLocalInt(oInstrument, "NOTES_RECORDED_TRACK" + sDestinationTrack);
		float fDelay, fAdjustedDelay;
		// Special case for if you are copying to the same track, AND deleting source notes
		// To avoid massive TMI errors, we simply alter the PLAYBACK settings of the notes in question
		if (iSourceTrack == iDestinationTrack && bDeleteSource)
		{
			while (iSourceNotes > 0)
			{
				fDelay = GetLocalFloat(oInstrument, "NOTE" + IntToString(iSourceNotes) + "PLAYBACK_TRACK" + sSourceTrack);
				if (fDelay >= fCopyFrom)
				{
					fAdjustedDelay = fDelay + fPasteTo;
					if (fAdjustedDelay < 0.0f) fAdjustedDelay = 0.0f;
					SetLocalFloat(oInstrument, "NOTE" + IntToString(iSourceNotes) + "PLAYBACK_TRACK" + sDestinationTrack, fAdjustedDelay);
				}
				iSourceNotes--;
			}		
		}
		else
		{
			SetLocalInt(oInstrument, "NOTES_RECORDED_TRACK" + sDestinationTrack, iSourceNotes + iDestinationNotes);
			while (iSourceNotes > 0)
			{
				//SendMessageToPC(oPC, "Copying Source Note " + IntToString(iSourceNotes));
				fDelay = GetLocalFloat(oInstrument, "NOTE" + IntToString(iSourceNotes) + "PLAYBACK_TRACK" + sSourceTrack);
				if (fDelay >= fCopyFrom)
				{
					fAdjustedDelay = fDelay + fPasteTo;
					if (fAdjustedDelay < 0.0f) fAdjustedDelay = 0.0f;
					SetLocalInt(oInstrument, "NOTE" + IntToString(iSourceNotes + iDestinationNotes) + "PITCH_TRACK" + sDestinationTrack,
						GetLocalInt(oInstrument, "NOTE" + IntToString(iSourceNotes) + "PITCH_TRACK" + sSourceTrack));
					SetLocalFloat(oInstrument, "NOTE" + IntToString(iSourceNotes + iDestinationNotes) + "PLAYBACK_TRACK" + sDestinationTrack,
						fAdjustedDelay);
					if (bDeleteSource)
						DeleteNote(oInstrument, iSourceTrack, iSourceNotes);
				}
				//else
				//	DeleteNote(oInstrument, iDestinationTrack, iSourceNotes);
				iSourceNotes--;
			}
		}
		// Copy over the recorded metronome settings
		SetLocalInt(oInstrument, "METRONOME_RECORDED_TRACK" + sDestinationTrack, 
			GetLocalInt(oInstrument, "METRONOME_RECORDED_TRACK" + sSourceTrack));
		
		SortNotes(oPC, oInstrument, iDestinationTrack);
		ClearTKLPerformerVariables(oPC);
		SetGUIObjectHidden(oPC, TKL_PERFORMER_SCREEN, "CopyPane", TRUE);
		//SetLocalFloat(oInstrument, "SONG_LENGTH", GetSongLength(oInstrument));
		SendMessageToPC(oPC, "Copy successful.");
	}
	
	else if (sAction == "COPY_PANE")
	{
		SetGUIObjectHidden(oPC, TKL_PERFORMER_SCREEN, "CopyPane", FALSE);
		PassTKLParameters(oPC, sAction, iOption);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "CopyTopText", -1, "Copy Track " + IntToString(iOption) + " to:");
		int iTrack;
		string sTrack, sName;
		for (iTrack=1; iTrack<=4; iTrack++)
		{
			sTrack = IntToString(iTrack);
			sName = GetLocalString(oInstrument, "TRACK_" + sTrack + "_NAME");
			if (sName == "")
				sName = "Track " + sTrack;
			SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "CopyTrackText" + sTrack, -1, "(" + sName + ")");
		}
		// Make sure that "beats" mode is allowed
		if (GetLocalInt(oInstrument, "METRONOME_RECORDED_TRACK" + IntToString(iOption)) == 0)
			DeleteLocalInt(oInstrument, "COPY_MODE_BEATS");
		RefreshCopyPane(oPC, oInstrument);
	}
	
	else if (sAction == "NOTE_PANE")
	{
		SetGUIObjectHidden(oPC, TKL_PERFORMER_SCREEN, "NotePane", FALSE);
		PassTKLParameters(oPC, sAction, iOption);
		// Make sure that "beats" mode is allowed, and set the metronome text
		string sMetronomeText = "(1 beat=";
		int iMetronome = GetLocalInt(oInstrument, "METRONOME_RECORDED_TRACK" + IntToString(iOption));
		if (iMetronome == 0)
		{
			DeleteLocalInt(oInstrument, "NOTE_EDIT_BEATS");
			sMetronomeText += "NA)";
		}
		else
		{
			float fBeat = 60.0f / IntToFloat(iMetronome);	
		 	sMetronomeText += FloatToString(fBeat, 3, 1) + " sec)";
		}
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "MetronomeBeat", -1, sMetronomeText);
		RefreshNotePane(oPC, oInstrument);
	}
	
	else if (sAction == "COPY_SETTINGS")
	{
		if (iOption > 0 && iOption < 5)
		{
			SetLocalInt(oInstrument, "COPY_TO_TRACK", iOption);
			return;
		}
		else if (iOption == 5)
		{
			SetLocalInt(oInstrument, "DELETE_SOURCE", TRUE);
		}
		else if (iOption == 6)
		{
			DeleteLocalInt(oInstrument, "DELETE_SOURCE");
		}
		else
		{
			int bBeats = GetLocalInt(oInstrument, "COPY_MODE_BEATS");
			int iAdjust;
			float fAdjust;
			string sSetting;
			switch (iOption)
			{
				case 7:	iAdjust = 1; fAdjust = 0.1f; sSetting = "COPY_FROM"; break;
				case 8:	iAdjust = 3; fAdjust = 3.0f;	sSetting = "COPY_FROM"; break;
				case 9:	iAdjust = -1; fAdjust = -0.1f; sSetting = "COPY_FROM"; break;
				case 10: iAdjust = -3; fAdjust = -3.0f; sSetting = "COPY_FROM"; break;
				case 11: iAdjust = 1; fAdjust = 0.1f; sSetting = "PASTE_TO"; break;
				case 12: iAdjust = 3; fAdjust = 3.0f; sSetting = "PASTE_TO"; break;
				case 13: iAdjust = -1; fAdjust = -0.1f; sSetting = "PASTE_TO"; break;
				case 14: iAdjust = -3; fAdjust = -3.0f; sSetting = "PASTE_TO"; break;
			}
			// If we're in "beats" copy mode
			if (bBeats)
			{
				sSetting += "_BEATS";
				int iCurrent = GetLocalInt(oInstrument, sSetting);
				if (iCurrent + iAdjust < 0 && iOption < 11) // Copy From numbers can't go below 0
				{
					iAdjust = 0;
					iCurrent = 0;
				}
				SetLocalInt(oInstrument, sSetting, iCurrent + iAdjust);
			}
			// Otherwise if we're in "seconds" copy mode
			else
			{
				float fCurrent = GetLocalFloat(oInstrument, sSetting);
				if (fCurrent + fAdjust < 0.0f && iOption < 11) // Copy From numbers can't go below 0
				{
					fAdjust = 0.0f;
					fCurrent = 0.0f;
				}
				SetLocalFloat(oInstrument, sSetting, fCurrent + fAdjust);
			}
			RefreshCopyPane(oPC, oInstrument);
		}
	}
	
	else if (sAction == "COPY_MODE")
	{
		int iSourceTrack = GetLocalInt(oPC, "TKL_PERFORMER_OPTION");
		string sTrack = IntToString(iSourceTrack);
		if (GetLocalInt(oInstrument, "METRONOME_RECORDED_TRACK" + sTrack) == 0)
		{
			if (!GetLocalInt(oInstrument, "COPY_MODE_BEATS"))
			{
					SendMessageToPC(oPC, "The source track was not recorded with a metronome, so you cannot change the copy mode to 'beats'.");
					return;
			}
		}
		SetLocalInt(oInstrument, "COPY_MODE_BEATS", !GetLocalInt(oInstrument, "COPY_MODE_BEATS"));
		RefreshCopyPane(oPC, oInstrument);
	}
	
	else if (sAction == "NOTE_SETTINGS")
	{
		int bBeats = GetLocalInt(oInstrument, "NOTE_EDIT_BEATS");
		
		int iCurrentAdjust;
		float fCurrentAdjust;
		switch (iOption)
		{
			case 1:
				iCurrentAdjust = GetLocalInt(oInstrument, "EDIT_PITCH");
				SetLocalInt(oInstrument, "EDIT_PITCH", iCurrentAdjust + 1);
				break;
			case 2:
				iCurrentAdjust = GetLocalInt(oInstrument, "EDIT_PITCH");
				SetLocalInt(oInstrument, "EDIT_PITCH", iCurrentAdjust + 3);
				break;
			case 3:
				iCurrentAdjust = GetLocalInt(oInstrument, "EDIT_PITCH");
				SetLocalInt(oInstrument, "EDIT_PITCH", iCurrentAdjust - 1);
				break;
			case 4:
				iCurrentAdjust = GetLocalInt(oInstrument, "EDIT_PITCH");
				SetLocalInt(oInstrument, "EDIT_PITCH", iCurrentAdjust - 3);
				break;
			case 5:
				if (bBeats)
				{
					iCurrentAdjust = GetLocalInt(oInstrument, "EDIT_BEATS");
					SetLocalInt(oInstrument, "EDIT_BEATS", iCurrentAdjust + 1);
				}
				else
				{
					fCurrentAdjust = GetLocalFloat(oInstrument, "EDIT_TIME");
					SetLocalFloat(oInstrument, "EDIT_TIME", fCurrentAdjust + 0.1f);
				}
				break;
			case 6:
				if (bBeats)
				{
					iCurrentAdjust = GetLocalInt(oInstrument, "EDIT_BEATS");
					SetLocalInt(oInstrument, "EDIT_BEATS", iCurrentAdjust + 3);
				}
				else
				{
					fCurrentAdjust = GetLocalFloat(oInstrument, "EDIT_TIME");
					SetLocalFloat(oInstrument, "EDIT_TIME", fCurrentAdjust + 3.0f);
				}
				break;
			case 7:
				if (bBeats)
				{
					iCurrentAdjust = GetLocalInt(oInstrument, "EDIT_BEATS");
					SetLocalInt(oInstrument, "EDIT_BEATS", iCurrentAdjust - 1);
				}
				else
				{
					fCurrentAdjust = GetLocalFloat(oInstrument, "EDIT_TIME");
					SetLocalFloat(oInstrument, "EDIT_TIME", fCurrentAdjust - 0.1f);
				}
				break;
			case 8:
				if (bBeats)
				{
					iCurrentAdjust = GetLocalInt(oInstrument, "EDIT_BEATS");
					SetLocalInt(oInstrument, "EDIT_BEATS", iCurrentAdjust - 3);
				}
				else
				{
					fCurrentAdjust = GetLocalFloat(oInstrument, "EDIT_TIME");
					SetLocalFloat(oInstrument, "EDIT_TIME", fCurrentAdjust - 3.0f);
				}
				break;
		}
		RefreshNotePane(oPC, oInstrument);
	}
	
	else if (sAction == "NOTE_MODE")
	{
		int iTrack = GetLocalInt(oPC, "TKL_PERFORMER_OPTION");
		string sTrack = IntToString(iTrack);
		switch (iOption)
		{
			case 1:
				if (GetLocalInt(oInstrument, "METRONOME_RECORDED_TRACK" + sTrack) == 0)
				{
					if (!GetLocalInt(oInstrument, "NOTE_EDIT_BEATS"))
					{
						SendMessageToPC(oPC, "This track was not recorded with a metronome, so cannot be edited by beats.");
						return;
					}
				}
				SetLocalInt(oInstrument, "NOTE_EDIT_BEATS", !GetLocalInt(oInstrument, "NOTE_EDIT_BEATS"));
				break;
			case 2:
				SetLocalInt(oInstrument, "NOTE_EDIT_CHROMATIC", !GetLocalInt(oInstrument, "NOTE_EDIT_CHROMATIC"));
				break;	
		}
		RefreshNotePane(oPC, oInstrument);
	}
	
	else if (sAction == "NOTE_EDIT")
	{
		int iTrack = GetLocalInt(oPC, "TKL_PERFORMER_OPTION");
		string sTrack = IntToString(iTrack);
		int iNote = GetLocalInt(oInstrument, "CURRENT_NOTE_TRACK" + sTrack);
		string sID = "NOTE" + IntToString(iNote) + "PITCH_TRACK" + sTrack;
		int iPitch = GetLocalInt(oInstrument, sID);
		if (iPitch == 0)
		{
			SendMessageToPC(oPC, "There is not a current note selected.");
			return;
		}
		int iNewPitch;
		int iKey = GetLocalInt(oInstrument, "KEY");
		switch (iOption)
		{
			// Delete note
			case 1:
				PassTKLParameters(oPC, "DELETE_NOTE", iTrack);
				DisplayMessageBox(oPC, 0, "Are you sure you want to delete this note?", "gui_tkl_performer_message", "gui_tkl_performer_cancel", TRUE);
				break;
			// Edit pitch
			case 2:
				PassTKLParameters(oPC, "NOTE_EDIT_PITCH", iTrack);
				DisplayMessageBox(oPC, 0, "Are you sure you want to adjust this note's pitch?", "gui_tkl_performer_message", "", TRUE);
				break;
			// Edit time
			case 3:
				PassTKLParameters(oPC, "NOTE_EDIT_TIME", iTrack);
				DisplayMessageBox(oPC, 0, "Are you sure you want to adjust this note's time?", "gui_tkl_performer_message", "", TRUE);
				break;
			// Toggle primary variation (short/long soft/loud etc.)
			case 4:
				iNewPitch = TogglePrimaryVariation(iPitch);
				PlayNote(iNewPitch, iKey);
				SetLocalInt(oInstrument, sID, iNewPitch);
				RefreshNotePane(oPC, oInstrument);
				break;
			// Toggle secondary variation (major/minor/half-diminished, percussion variations)
			case 5:
				iNewPitch = ToggleSecondaryVariation(iPitch);
				PlayNote(iNewPitch, iKey);
				SetLocalInt(oInstrument, sID, iNewPitch);
				RefreshNotePane(oPC, oInstrument);
				break;
			// Duplicate the note
			case 6:
				PassTKLParameters(oPC, "DUPLICATE_NOTE", iTrack);
				DisplayMessageBox(oPC, 0, "Are you sure you want to duplicate this note?", "gui_tkl_performer_message", "gui_tkl_performer_cancel", TRUE);
				break;
		}
	}
	
	else if (GetStringLeft(sAction, 12) == "IMPROV_TRACK")
	{
		string s = GetStringRight(sAction, 1);
		SetGUITexture(oPC, TKL_PERFORMER_SCREEN, "ImprovTrack" + s + "None", "b_sm_normal.tga");
		SetGUITexture(oPC, TKL_PERFORMER_SCREEN, "ImprovTrack" + s + "Drums", "b_sm_normal.tga");
		SetGUITexture(oPC, TKL_PERFORMER_SCREEN, "ImprovTrack" + s + "Chords", "b_sm_normal.tga");
		SetGUITexture(oPC, TKL_PERFORMER_SCREEN, "ImprovTrack" + s + "Lute", "b_sm_normal.tga");
		SetGUITexture(oPC, TKL_PERFORMER_SCREEN, "ImprovTrack" + s + "Flute", "b_sm_normal.tga");		
		switch (iOption)
		{
			case 0: SetGUITexture(oPC, TKL_PERFORMER_SCREEN, "ImprovTrack" + s + "None", "b_sm_hover.tga"); break;
			case 1: SetGUITexture(oPC, TKL_PERFORMER_SCREEN, "ImprovTrack" + s + "Drums", "b_sm_hover.tga"); break;
			case 2: SetGUITexture(oPC, TKL_PERFORMER_SCREEN, "ImprovTrack" + s + "Chords", "b_sm_hover.tga"); break;
			case 3: SetGUITexture(oPC, TKL_PERFORMER_SCREEN, "ImprovTrack" + s + "Lute", "b_sm_hover.tga"); break;
			case 4: SetGUITexture(oPC, TKL_PERFORMER_SCREEN, "ImprovTrack" + s + "Flute", "b_sm_hover.tga"); break;	
		}
		SetLocalInt(oInstrument, "IMPROV_INSTRUMENT_TRACK_" + s, iOption);
	}
	
	else if (sAction == "IMPROV_STYLE")
	{
		int iLastSelected = GetLocalInt(oInstrument, "IMPROV_STYLE");
		if (iLastSelected == 0) iLastSelected = 1;
		SetGUITexture(oPC, TKL_PERFORMER_SCREEN, "ImprovStyle" + IntToString(iLastSelected), "b_sm_normal.tga");
		SetGUITexture(oPC, TKL_PERFORMER_SCREEN, "ImprovStyle" + IntToString(iOption), "b_sm_hover.tga");
		SetLocalInt(oInstrument, "IMPROV_STYLE", iOption);
		// set the description
		string sDesc;
		switch (iOption)
		{
			case 1: sDesc = STYLE_1_DESCRIPTION; break;
			case 2: sDesc = STYLE_2_DESCRIPTION; break;
			case 3: sDesc = STYLE_3_DESCRIPTION; break;
			case 4: sDesc = STYLE_4_DESCRIPTION; break;
			case 5: sDesc = STYLE_5_DESCRIPTION; break;
			case 6: sDesc = STYLE_6_DESCRIPTION; break;
			case 7: sDesc = STYLE_7_DESCRIPTION; break;
			case 8: sDesc = STYLE_8_DESCRIPTION; break;
			case 9: sDesc = STYLE_9_DESCRIPTION; break;
			case 10: sDesc = STYLE_10_DESCRIPTION; break;
		}
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "ImprovStyleDescription", -1, sDesc);
	}
	
	else if (sAction == "IMPROVISE")
	{	
		int iStyle = GetLocalInt(oInstrument, "IMPROV_STYLE");
		if (iStyle == 0) iStyle = 1;
		int iPerformRequired = 0;
		switch (iStyle)
		{
			case 1: iPerformRequired = STYLE_1_PERFORM_REQUIRED; break;
			case 2: iPerformRequired = STYLE_2_PERFORM_REQUIRED; break;
			case 3: iPerformRequired = STYLE_3_PERFORM_REQUIRED; break;
			case 4: iPerformRequired = STYLE_4_PERFORM_REQUIRED; break;
			case 5: iPerformRequired = STYLE_5_PERFORM_REQUIRED; break;
			case 6: iPerformRequired = STYLE_6_PERFORM_REQUIRED; break;
			case 7: iPerformRequired = STYLE_7_PERFORM_REQUIRED; break;
			case 8: iPerformRequired = STYLE_8_PERFORM_REQUIRED; break;
			case 9: iPerformRequired = STYLE_9_PERFORM_REQUIRED; break;
			case 10: iPerformRequired = STYLE_10_PERFORM_REQUIRED; break;
		
		}
		if (iPerformRequired > 0)
		{
			if (GetPerform(oPC) < iPerformRequired)
			{
				SendMessageToPC(oPC, "You will need a higher Perform skill before you can play this style.");
				return;
			}
		}
		
		// Erase previous lyrics
		EraseLyrics(oInstrument);
		EraseLyricTrack(oInstrument);
		
		SetImprovStyle(oPC, iStyle);
		Improvise(oPC);
		DelayCommand(5.0, ClearImprovStyle(oPC));
	}
	
	else if (sAction == "EMBELLISH_PANE")
	{
		int iTrack = GetLocalInt(oPC, "TKL_PERFORMER_OPTION");
		string sTrack = IntToString(iTrack);
		int iNote = GetLocalInt(oInstrument, "CURRENT_NOTE_TRACK" + sTrack);
		int iChord = GetLocalInt(oInstrument, "NOTE" + IntToString(iNote) + "PITCH_TRACK" + sTrack);
		// Make sure the current note is a chord
		if (iChord < 101 || iChord > 186)
		{
			SendMessageToPC(oPC, "The current note is not a chord. (You can only 'Embellish' chords')");
			return;
		}
		
		// Show the pane and reset all buttons and variables
		SetGUIObjectHidden(oPC, TKL_PERFORMER_SCREEN, "EmbellishPane", FALSE);
		int i;
		for (i = 1; i <= 13; i++)
		{
			SetGUITexture(oPC, TKL_PERFORMER_SCREEN, "Embellish" + IntToString(i), "b_sm_normal.tga");
		}
		DeleteLocalInt(oInstrument, "EMBELLISHMENT_TO_ADD");
	}
	
	else if (sAction == "EMBELLISH")
	{
		int iTrack = GetLocalInt(oPC, "TKL_PERFORMER_OPTION");
		string sTrack = IntToString(iTrack);
		string sNote = IntToString(GetLocalInt(oInstrument, "CURRENT_NOTE_TRACK" + sTrack));
		int iChord = GetLocalInt(oInstrument, "NOTE" + sNote + "PITCH_TRACK" + sTrack);
		int iLastSelected = GetLocalInt(oInstrument, "EMBELLISHMENT_TO_ADD");
		// Delay the note if it is a rolled chord
		float fNoteDelay = 0.0f;
		if (iChord < 151) fNoteDelay = TKL_CHORD_ROLL_OFFSET;
						
		// If iOption is not 0, the user is previewing the chord with the embellishment.
		if (iOption > 0)
		{
			int iKey = GetLocalInt(oInstrument, "KEY");
			int iEmbellishment = GetEmbellishmentPitch(iChord, iOption);
			
			// First play the chord and note together
			PlayNote(iChord, iKey);
			DelayCommand(fNoteDelay, PlayNote(iEmbellishment, iKey));
			
			// Now unhighlight and highlight the buttons
			if (iLastSelected > 0)
				SetGUITexture(oPC, TKL_PERFORMER_SCREEN, "Embellish" + IntToString(iLastSelected), "b_sm_normal.tga");
			SetGUITexture(oPC, TKL_PERFORMER_SCREEN, "Embellish" + IntToString(iOption), "b_sm_hover.tga");	
			
			// Set the variable to keep track of the selected embellishment
			SetLocalInt(oInstrument, "EMBELLISHMENT_TO_ADD", iOption);	
		}
		// Otherwise go ahead and add the embellishment as a new note in the track
		else
		{
			int iEmbellishment = GetEmbellishmentPitch(iChord, iLastSelected);
			int iTotalNotes = GetLocalInt(oInstrument, "NOTES_RECORDED_TRACK" + sTrack);
			string sNewID = "NOTE" + IntToString(iTotalNotes + 1);
			SetLocalInt(oInstrument, sNewID + "PITCH_TRACK" + sTrack, iEmbellishment);
			SetLocalFloat(oInstrument, sNewID + "PLAYBACK_TRACK" + sTrack, 
				fNoteDelay + GetLocalFloat(oInstrument, "NOTE" + sNote + "PLAYBACK_TRACK" + sTrack));
			SetLocalInt(oInstrument, "NOTES_RECORDED_TRACK" + sTrack, iTotalNotes + 1);
			SortNotes(oPC, oInstrument, iTrack);
			RefreshNotePane(oPC, oInstrument);
		}	
	}
	
	else if (sAction == "LYRIC_RECORD_PANE")
	{
		float fSecondsPerLyric = GetLocalFloat(oInstrument, "SECONDS_PER_LYRIC");
		SetGUIObjectText(oPC, "TKL_PERFORMER_LYRICS", "LyricAutomationField", -1, FloatToString(fSecondsPerLyric, 3, 1));
	}
	
	else if (sAction == "LYRIC_AUTOMATION")
	{
		float fSecondsPerLyric = GetLocalFloat(oInstrument, "SECONDS_PER_LYRIC");
		
		float fAdjust;
		switch (iOption)
		{	
			// If 0 through 3, adjust the SecondsPerLyric variable
			case 0: fAdjust = 0.1f; break;
			case 1: fAdjust = 1.0f; break;
			case 2: fAdjust = -0.1f; break;
			case 3: fAdjust = -1.0f; break;
			// If 4, launch the input screen
			case 4:
				if (fSecondsPerLyric <= 0.0f)
				{
					SendMessageToPC(oPC, "Before you Write lyrics, you need to set a certain number of seconds in between each lyric.");
					return;
				}
				PassTKLParameters(oPC, "WRITE_LYRICS", 0);
				SetGUIObjectHidden(oPC, "TKL_PERFORMER_LYRICS", "LyricRecordPane", TRUE);
				string sOldWrite = GetLocalString(oInstrument, "WRITE_LYRICS");
				PassTKLParameters(oPC, "WRITE_LYRICS", 0);
				DisplayGuiScreen(oPC, "TKL_PERFORMER_WRITE", TRUE, "tkl_performer_write.xml");
				SetGUIObjectText(oPC, "TKL_PERFORMER_WRITE", "inputbox", -1, sOldWrite); 
				return;
				break;		
		}
		SetLocalFloat(oInstrument, "SECONDS_PER_LYRIC", fAdjust + fSecondsPerLyric);
		SetGUIObjectText(oPC, "TKL_PERFORMER_LYRICS", "LyricAutomationField", -1, FloatToString(fAdjust + fSecondsPerLyric, 3, 1));
	}
}
