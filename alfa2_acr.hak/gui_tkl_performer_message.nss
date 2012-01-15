/*
Author: brockfanning
Date: Early 2008...
Purpose: These are various actions performed after the PC clicks "OK" on a confirmation window.

1/25/09: added functionality for DMs having access to "server songs", when Saving and Loading -brockfanning
1/26/09: added diatonic pitch changes and beat time changes -brockfanning
1/31: added Duplicate Note
*/

#include "tkl_performer_include"

// Convert any melody pitch into a number from 1 to 25, regardless of instrument
int GetAbsolutePitch(int iPitch)
{
	// first check for pitched percussion (loud and soft)
	if (iPitch >= 324 && iPitch <= 335)
		iPitch -= 323;
		
	if (iPitch >= 374 && iPitch <= 385)
		iPitch -= 373;

	// next check for drum notes
	if (iPitch  > 300) iPitch -= 300;

	// next check for flute notes
	if (iPitch > 200) iPitch -= 200;

	// next check for chords
	if (iPitch > 100) iPitch -= 100;
	
	// next check for short notes
	if (iPitch > 50) iPitch -= 50;

	return iPitch;
}

// Returns true if a pitch is a scale tone
int GetIsDiatonic(int iPitch)
{
	int bReturn = FALSE;
	switch (iPitch)
	{
		case 1: case 13: case 25: 
		case 3: case 15:
		case 5: case 17:
		case 6: case 18:
		case 8: case 20:
		case 10: case 22:
		case 12: case 24: bReturn = TRUE;
	}
	return bReturn;
}

// Returns a nearest diatonic note
int GetNearestDiatonic(int iPitch, int bRoundUp, int bPercussion)
{
	if (bPercussion) return iPitch;
	
	if (GetIsDiatonic(iPitch)) return iPitch;

	else if (bRoundUp) return iPitch + 1;

	else return iPitch - 1;	
}

// Returns the next note in a scale
int GetNextDiatonic(int iPitch, int bDrums, int bPercussion)
{
	// for percussion, go up 1, but not more than 20
	if (bPercussion)
	{
		int iReturnPercussion = iPitch + 1;
		if (iReturnPercussion > 20) iReturnPercussion = 20;
		return iReturnPercussion;
	}
	
	// Usually go a whole step
	int iReturn = iPitch + 2;

	// But in these cases only go a half step
	switch (iPitch)
	{
		case 5: case 17:
		case 12: case 24: iReturn = iPitch + 1;
	}

	int iMax = 25;
	if (bDrums) iMax = 13; // Drums only have 1 octave

	// make sure we don't go off the charts...
	if (iReturn > iMax) iReturn = iMax;
	return iReturn;
}

// Returns the previous note in a scale
int GetPreviousDiatonic(int iPitch, int bPercussion)
{
	// for percussion, go up 1, but not more than 20
	if (bPercussion)
	{
		int iReturnPercussion = iPitch - 1;
		if (iReturnPercussion < 1) iReturnPercussion = 1;
		return iReturnPercussion;
	}
	
	// Usually go a whole step
	int iReturn = iPitch - 2;

	// But in these cases only go a half step
	switch (iPitch)
	{
		case 6: case 18:
		case 1: case 13: case 25: iReturn = iPitch - 1;
	}

	// make sure we don't go off the charts...
	if (iReturn < 1) iReturn = 1;
	return iReturn;
}

int GetDiatonicJump(int iInterval, int iPitch)
{
	//object oPC = GetFirstPC();
	//SendMessageToPC(oPC, "Interval = " + IntToString(iInterval));
	//SendMessageToPC(oPC, "Pitch = " + IntToString(iPitch));
	if (iInterval == 0) return iPitch;

	// Track whether this is pitched percussion, for later use in the GetNextDiatonic function
	int bPitchedDrums = FALSE;
	int bPercussion = FALSE;
	if ((iPitch > 300 && iPitch < 321) || iPitch > 350 && iPitch < 371) bPercussion = TRUE;
	else if (iPitch > 300) bPitchedDrums = TRUE;
	
	// First we convert the pitch into a number between 1 and 25, but keep track of the original
	int iAbsolutePitch = GetAbsolutePitch(iPitch);

	//SendMessageToPC(oPC, "Absolute Pitch = " + IntToString(iAbsolutePitch));
	// Keep track of the amount that was subtracted, so we can add it back at the end
	int iAddAtTheEnd = iPitch - iAbsolutePitch;
	//SendMessageToPC(oPC, "Add at the End = " + IntToString(iAddAtTheEnd));
	// If we're jumping down, we'll start by rounding down to the next lowest diatonic tone.
	// If we're jumping up, we'll start by round up to the next highest diatonic tone.
	int bRoundUp = FALSE;
	if (iInterval < 0) bRoundUp = TRUE;
	int iDiatonic = GetNearestDiatonic(iAbsolutePitch, bRoundUp, bPercussion);
 	//SendMessageToPC(oPC, "Nearest Diatonic = " + IntToString(iDiatonic));
	// Cycle through diatonic notes, a number of times equal to the interval
	int i;
	for (i = 1; i <= abs(iInterval); i++)
	{
		if (iInterval > 0) iDiatonic = GetNextDiatonic(iDiatonic, bPitchedDrums, bPercussion);
		else iDiatonic = GetPreviousDiatonic(iDiatonic, bPercussion);
	}
	//SendMessageToPC(oPC, "Diatonic After Jump = " + IntToString(iDiatonic));
	//SendMessageToPC(oPC, "Returning = " + IntToString(iDiatonic + iAddAtTheEnd));
	return iDiatonic + iAddAtTheEnd;
}

int GetHighestNote(int iNote)
{
	if (iNote >= 1 && iNote <= 25)
		return 25;
	else if (iNote >= 51 && iNote <= 75)
		return 75;
	else if (iNote >= 101 && iNote <= 112)
		return 112;
	else if (iNote >= 113 && iNote <= 124)
		return 124;
	else if (iNote >= 125 && iNote <= 136)
		return 136;
	else if (iNote >= 151 && iNote <= 162)
		return 162;
	else if (iNote >= 163 && iNote <= 174)
		return 174;
	else if (iNote >= 175 && iNote <= 186)
		return 186;
	else if (iNote >= 201 && iNote <= 225)
		return 225;
	else if (iNote >= 251 && iNote <= 275)
		return 275;
	else if (iNote >= 301 && iNote <= 310)
		return 310;
	else if (iNote >= 311 && iNote <= 320)
		return 320;
	else if (iNote >= 324 && iNote <= 335)
		return 335;
	else if (iNote >= 351 && iNote <= 360)
		return 360;
	else if (iNote >= 361 && iNote <= 370)
		return 370;
	else if (iNote >= 374 && iNote <= 385)
		return 385;
	else
		return 0;
}

int GetLowestNote(int iNote)
{
	if (iNote >= 1 && iNote <= 24)
		return 1;
	else if (iNote >= 51 && iNote <= 74)
		return 51;
	else if (iNote >= 101 && iNote <= 112)
		return 101;
	else if (iNote >= 113 && iNote <= 124)
		return 113;
	else if (iNote >= 125 && iNote <= 136)
		return 125;
	else if (iNote >= 151 && iNote <= 162)
		return 151;
	else if (iNote >= 163 && iNote <= 174)
		return 163;
	else if (iNote >= 175 && iNote <= 186)
		return 175;
	else if (iNote >= 201 && iNote <= 224)
		return 201;
	else if (iNote >= 251 && iNote <= 274)
		return 251;
	else if (iNote >= 301 && iNote <= 310)
		return 301;
	else if (iNote >= 311 && iNote <= 320)
		return 311;
	else if (iNote >= 324 && iNote <= 335)
		return 324;
	else if (iNote >= 351 && iNote <= 360)
		return 351;
	else if (iNote >= 361 && iNote <= 370)
		return 361;
	else if (iNote >= 374 && iNote <= 385)
		return 374;
	else
		return 0;
}

void main()
{
	object oPC = OBJECT_SELF;
	string sAction = GetLocalString(oPC, "TKL_PERFORMER_ACTION");
	int iOption = GetLocalInt(oPC, "TKL_PERFORMER_OPTION");
	string sOption = IntToString(iOption);
	object oInstrument = GetLocalObject(oPC, "TKL_PERFORMER_INSTRUMENT");
	int bDM = GetIsDM(oPC);

	if (sAction == "LYRIC_RECORD")
	{
		DeleteLocalFloat(oInstrument, "SECONDS_PER_LYRIC");
		DeleteLocalString(oInstrument, "WRITE_LYRICS");
		//DeleteLocalInt(oInstrument, "USE_LYRIC_AUTOMATION");
		StartTimer(oInstrument, "PLAYBACK");
		SetLocalInt(oInstrument, "RECORDING_LYRICS", TRUE);
		DeleteLocalInt(oInstrument, "LYRICS_RECORDED");
		SetGUIObjectHidden(oPC, "TKL_PERFORMER_LYRICS", "StopRecordingPane", FALSE);
		PlaySong(oPC, oInstrument, 0, FALSE, FALSE, TRUE);
		ClearTKLPerformerVariables(oPC);	
	}
	
	//if (sAction == "LYRIC_AUTOMATION")
	//{
	//	float fSecondsPerLyric = GetLocalFloat(oInstrument, "SECONDS_PER_LYRIC");
		
	//	SetLocalInt(oInstrument, "USE_LYRIC_AUTOMATION", TRUE);
	//	ClearTKLPerformerVariables(oPC);
	//}
		
	else if (sAction == "SONG_LOAD")
	{
		object oNewInstrument;
		// For DMs, access a single list of "server" songs
		if (bDM)
			oNewInstrument = RetrieveTKLPersistInstrumentObject(OBJECT_INVALID, "TKL_SERVER_INST_" +
				IntToString(iOption), GetLocation(oPC), oPC);
		// For PCs, access an individual list of private songs
		else
		{
			oNewInstrument = RetrieveTKLPersistInstrumentObject(oPC, "TKL_INST_" +
				IntToString(iOption), GetLocation(oPC), oPC);
			if (GetIsObjectValid(oNewInstrument) == FALSE)
				oNewInstrument = RetrieveTKLPersistInstrumentObject(oPC, "TKL_PERFORMER_INSTRUMENT_" +
					IntToString(iOption), GetLocation(oPC), oPC);
		}
		if (GetIsObjectValid(oNewInstrument) == FALSE)
		{
			SendMessageToPC(oPC, "Error: Sorry, there is no song saved in this slot.");
			return;
		}
		TransferSong(oNewInstrument, oInstrument);
		DestroyObject(oNewInstrument);
		ClearTKLPerformerVariables(oPC);
		SendMessageToPC(oPC, "Song loaded.");
	}
	
	else if (sAction == "SONG_SAVE")
	{
		// For DMs, access a single list of "server" songs
		if (bDM)
			StoreTKLPersistInstrumentObject(OBJECT_INVALID, "TKL_SERVER_INST_" + IntToString(iOption),
				oInstrument);
		// For PCs, access an individual list of private songs
		else
			StoreTKLPersistInstrumentObject(oPC, "TKL_INST_" + IntToString(iOption),
				oInstrument);
		string sName = GetLocalString(oInstrument, "SONG_NAME");
		if (sName == "")
			sName = "Untitled";
		if (bDM)
			SetTKLPersistString(OBJECT_INVALID, "TKL_SERVER_SONG_NAME" + IntToString(iOption), sName);
		else
			SetTKLPersistString(oPC, "TKL_SONG_NAME" + IntToString(iOption), sName);
		RefreshSongList(oPC);
		ClearTKLPerformerVariables(oPC);
		SendMessageToPC(oPC, "Song saved.");
	}
	
	else if (sAction == "NEW")
	{
		if (iOption == 0)
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
			RefreshNoteNames(oPC, oInstrument);	
			DeleteLocalString(oInstrument, "ORIGINAL_COMPOSER");
		}
		else
		{
			EraseTrack(oInstrument, iOption);
		}
		RefreshNames(oPC, oInstrument);
		ClearTKLPerformerVariables(oPC);
		SendMessageToPC(oPC, "Current song erased.");
	}
	
	else if (sAction == "DELETE_NOTE")
	{
		int iNote = GetLocalInt(oInstrument, "CURRENT_NOTE_TRACK" + sOption);
		DeleteNote(oInstrument, iOption, iNote);
		RefreshNotePane(oPC, oInstrument);
	}
	
	else if (sAction == "DUPLICATE_NOTE")
	{
		int iNote = GetLocalInt(oInstrument, "CURRENT_NOTE_TRACK" + sOption);
		int iTotalNotes = GetLocalInt(oInstrument, "NOTES_RECORDED_TRACK" + sOption);
		string sOldID = "NOTE" + IntToString(iNote);
		string sNewID = "NOTE" + IntToString(iTotalNotes + 1);
		SetLocalInt(oInstrument, sNewID + "PITCH_TRACK" + sOption, 
			GetLocalInt(oInstrument, sOldID + "PITCH_TRACK" + sOption));
		SetLocalFloat(oInstrument, sNewID + "PLAYBACK_TRACK" + sOption, 
			GetLocalFloat(oInstrument, sOldID + "PLAYBACK_TRACK" + sOption));
		SetLocalInt(oInstrument, "NOTES_RECORDED_TRACK" + sOption, iTotalNotes + 1);
		SortNotes(oPC, oInstrument, iOption);
		RefreshNotePane(oPC, oInstrument);	
	}
	
	else if (sAction == "NOTE_EDIT_PITCH")
	{
		int iNote = GetLocalInt(oInstrument, "CURRENT_NOTE_TRACK" + sOption);
		int iEditPitch = GetLocalInt(oInstrument, "EDIT_PITCH");
		if (iNote == 0 || iEditPitch == 0)
		{
			SendMessageToPC(oPC, "Pitch unchanged.");
			return;
		}		
		string sID = "NOTE" + IntToString(iNote) + 	"PITCH_TRACK" + sOption;
		int iCurrent = GetLocalInt(oInstrument, sID);
		int iLowestNote = GetLowestNote(iCurrent);
		int iHighestNote = GetHighestNote(iCurrent);
		int iNew;
		if (!GetLocalInt(oInstrument, "NOTE_EDIT_CHROMATIC"))
			iNew = GetDiatonicJump(iEditPitch, iCurrent);
		else
			iNew = iCurrent + iEditPitch;
		if (iNew < iLowestNote)
		{
			iNew = iLowestNote;
			SendMessageToPC(oPC, "Lowest note reached.");
		}
		else if (iNew > iHighestNote)
		{
			iNew = iHighestNote;
			SendMessageToPC(oPC, "Highest note reached.");
		}
		
		SetLocalInt(oInstrument, sID, iNew);
		RefreshNotePane(oPC, oInstrument);
	}
	
	else if (sAction == "NOTE_EDIT_TIME")
	{
		int iNote = GetLocalInt(oInstrument, "CURRENT_NOTE_TRACK" + sOption);
		float fEditTime;
		
		// If we are editing beats...
		if (GetLocalInt(oInstrument, "NOTE_EDIT_BEATS"))
		{
			int iMetronome = GetLocalInt(oInstrument, "METRONOME_RECORDED_TRACK" + sOption);
			if (iMetronome == 0)
			{
				SendMessageToPC(oPC, "Error: No metronome info on track; cannot edit beats");
				return;
			}
			int iJump = GetLocalInt(oInstrument, "EDIT_BEATS");
			if (iNote == 0 || iJump == 0)
			{
				SendMessageToPC(oPC, "Time unchanged.");
				return;
			}
			float fBeat = 60.0f / IntToFloat(iMetronome);
			fEditTime = IntToFloat(iJump) * fBeat;		
		}
		
		// Otherwise if we are editing seconds...
		else
		{
			fEditTime = GetLocalFloat(oInstrument, "EDIT_TIME");
			if (iNote == 0 || fEditTime == 0.0f)
			{
				SendMessageToPC(oPC, "Time unchanged.");
				return;
			}
		}
		string sID = "NOTE" + IntToString(iNote) + 	"PLAYBACK_TRACK" + sOption;
		float fCurrent = GetLocalFloat(oInstrument, sID);
		if (fCurrent + fEditTime < 0.0f)
			fCurrent = 0.0f;
		else
			fCurrent += fEditTime;
		SetLocalFloat(oInstrument, sID, fCurrent);
		SendMessageToPC(oPC, "Time changed to " + FloatToString(fCurrent));
		SortNotes(oPC, oInstrument, iOption);
		RefreshNotePane(oPC, oInstrument);
	}
}
