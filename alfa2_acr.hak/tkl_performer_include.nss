/*
Script:
Author: brockfanning
Date: Early 2008...
Purpose: This script the key functions for the TKL performer that are used in
multiple scripts.  If any of these functions are only used in one script, they
should probably be moved to that script.

5/31/08: Many bugs fixed... brockfanning
6/11/08: added offset constants for rolled notes
1/23/09: 	-moved some functions here from gui_tkl_performer_input (GetMelodyPitch, GetChordPitch, GetPercussionPitch)
			-added SetupImprovPane, added it to LaunchTKLPerformer
			-added a whole buttload of improvisation functions
			-moved the "Write" code here so that it could be used by multiple scripts (WriteNote, WriteTrack)
			-write function ignores line breaks
			-write function chooses random percussion variation if not specified
			-'repeat' functionality added to write function
			-added lyric numbers to RefreshLyrics
			-Made WriteTrack recursive, to avoid TMI errors
3/11/09: 	-allow DMs to "throw" their voice to NPCs when singing lyrics
*/

// Various color constants for the buttons.
const string sColor = "<color=orange>";
const string sEndColor = "</color>";
const string sMinorEndColor = "m</color>";
const string sDimEndColor = "*</color>";
const string sMinorEnd = "m";

// The name of the main GUI screen
const string TKL_PERFORMER_SCREEN = "TKL_PERFORMER";
// The name of the Obsidian database, which will appear in the server's
// My Documents/Neverwinter Nights 2/database folder.
const string TKL_PERFORMER_DATABASE = "tkl_performer";
// A small time-offset to apply to rolled chords, when using Quantize or Write. 
const float TKL_CHORD_ROLL_OFFSET =	0.25f;
// A small time-offset to apply to drum rolls, when using Quantize or Write.
const float TKL_DRUM_ROLL_OFFSET = 	0.12f;

// Some improvisation-related constants
const int IMPROV_INSTRUMENT_NONE = 0;
const int IMPROV_INSTRUMENT_LUTE_NOTES = 3;
const int IMPROV_INSTRUMENT_LUTE_CHORDS = 2;
const int IMPROV_INSTRUMENT_DRUM = 1;
const int IMPROV_INSTRUMENT_FLUTE = 4;

const int IMPROV_MOVEMENT_REPEAT = 0;
const int IMPROV_MOVEMENT_LEAP = 1;
const int IMPROV_MOVEMENT_STEP = 2;

const int TOTAL_STYLES = 10;

const int WRITE_RECURSION_LIMIT = 100;

// The name of the TKL database setting indicating that we have migrated the
// player to use the central database.
const string ACR_TKL_MIGRATED = "ACR_TKL_MIGRATED";

#include "nwnx_time"
#include "tkl_performer_settings"
#include "acr_db_persist_i"

// Define to 1 to use the ACR Persist database.

#define TKL_PERFORMER_USE_ACR_PERSIST 1

// Determine the length of the song, given its current speed.
float GetSongLength(object oInstrument);
// Return the same chord in a different key.
int TransposeChord(int iChord, int iNewKey);
// Play a note in a key, for all PCs to hear.
void PlayNote(int iNote, int iKey);
// Clear certain variables that are used to pass parameters between scripts.
void ClearTKLPerformerVariables(object oPC);
// Refresh the Lyrics buttons on the GUI.
void RefreshLyrics(object oPC, object oInstrument, int bUsePerform = TRUE);
// Refresh the Track and Song names on the GUI.
void RefreshNames(object oPC, object oInstrument);
// Refresh the songlist for the Load and Save buttons on the GUI.
void RefreshSongList(object oPC);
// Assign correct note names, given the major or minor key.
void SetNoteNames(object oPC, int bMinor, string s1, string s2, string s3, string s4, string s5, string s6, string s7);
// Refresh the note names on the GUI.
void RefreshNoteNames(object oPC, object oInstrument);
// Erase one track.
void EraseTrack(object oInstrument, int iTrack, int bEraseName=TRUE);
// Enable Play buttons, for after a song is finished playing.
void EnableButtons(object oPC, object oInstrument);
// Disable Play buttons, for while a song is playing.
void DisableButtons(object oPC, object oInstrument, int bPreview=FALSE);
// Play the "lyric track".
void PlayLyrics(object oPC, object oInstrument, int bPreview=FALSE, int bIgnoreTempo=FALSE);
// Play one track.
void PlayTrack(object oPC, object oInstrument, int iTrack, int bIgnoreKey=FALSE, int bIgnoreTempo=FALSE, int bDisableButtons=FALSE, int bPreview=FALSE);
// Play all tracks.
void PlaySong(object oPC, object oInstrument, int iExcludeTrack=0, int bLyrics=FALSE, int bIgnoreKey=FALSE, int bIgnoreTempo=FALSE, int bPreview=FALSE);
// Record one track.
void RecordTrack(object oPC, object oInstrument, int iTrack);
// Play Metronome clicks.
void PlayMetronome(object oPC, int iTempo, int iSeconds);
// Set up certain variables for passing parameters between scripts.
void PassTKLParameters(object oPC, string sAction, int iOption);
// Erase the "lyric track".
void EraseLyricTrack(object oInstrument);
// Erase all saved lyrics.
void EraseLyrics(object oInstrument);
// Transfer the song from one item to another.
void TransferSong(object oInstrument, object oNew, int bFeedback=FALSE);
// Stop recording.
void StopRecording(object oPC, object oInstrument);
// Refresh the Record windown on the GUI.
void RefreshRecordPane(object oPC, object oInstrument);
// Refresh the Mute buttons on the GUI.
void RefreshMuting(object oPC, object oInstrument);
// Refresh the Mode buttons (Easy, Major/Minor) on the GUI.
void RefreshModes(object oPC, object oInstrument);
// Launch the system, for when a PC equips an instrument.
void LaunchTKLPerformer(object oPC, object oItem, string sGUIFile);
// Shut down the system, for when a PC closes the window.
void ShutDownTKLPerformer(object oPC, object oItem);
// Find the last note (longest delay) on a track, for sorting.
void FindLastNote(object oPC, object oInstrument, int iTrack);
// Clean up track after sorting.
void FinalizeNoteSorting(object oPC, object oInstrument, int iTrack);
// Re-sort all notes in a track from first (shortest delay) to last (longest delay).
void SortNotes(object oPC, object oInstrument, int iTrack);
// Return a name for a pitch number, based on instrument type.
string GetNoteName(int iPitch);
// Refresh the Copy window in the GUI.
void RefreshCopyPane(object oPC, object oInstrument);
// Clear some lingering variables.
void ResetExpiringVariables(object oPC, object oInstrument);
// Refresh the Note window in the GUI.
void RefreshNotePane(object oPC, object oInstrument);
// Delete one note.
void DeleteNote(object oInstrument, int iTrack, int iNote);
// Return the maximum speed a PC can set the song.
int GetMaximumSpeed(object oPC);
// Get a Drum pitch from text
int GetPercussionPitch(string sChar2, int iRow);
// Get a Chord pitch from text
int GetChordPitch(string sChar, string sChar2, string sQuality);
// Get a Note pitch from text
int GetMelodyPitch(string sChar, string sChar2, int iRow, int bDrums, int iInstrumentOffset);
// Set up the Improv pane as the instrument is equipped
void SetupImprovPane(object oPC, object oInstrument);
// Convert a long list of slash-separated strings into separate strings
int ParseImprovVariables(object oObject, string sUnparsed, string sVariable);
// Set a lot of variables on the PC for use by the Improvise function
void SetImprovStyle(object oPC, int iStyle);
// Clear a certain variable
void ClearImprovVariables(object oObject, string sVariable);
// Clear all of the afore-mentioned variables after the improvisation is done
void ClearImprovStyle(object oPC);
// Create a song
void Improvise(object oPC);
// Convert a string into a chord pitch
int ParseChord(string sChord);
// Returns TRUE if iNote is a chord tone of iChord
int GetIsChordTone(int iChord, int iNote);
// Modifies a delay IF the pitch is drum-roll or rolled chord
float GetOffset(int iPitch, float fDelay);
// For use in Improvise, this is separated out to avoid TMI errors
void ImproviseMelodyMeasure(object oPC, int iTrack, int iMeasure, float fCurrentBeat, int iLastNote, int iLastMovement, int bAscending, int iNotesRecorded);
// For use in Improvise, this is separated out to avoid TMI errors
void ImprovisePercussionMeasure(object oPC, int iTrack, int iMeasure, float fCurrentBeat, int iNotesRecorded);
// Use in the WriteTrack function
void WriteNote(object oInstrument, int iNotesRecorded, int iTrack, int iPitch, float fDelay);
// For use with the "Write" code.  It returns the number of notes written.
void WriteTrack(object oPC, object oInstrument, int iTrack, string sInput, string sGUIFile, int iNotesWritten=0, int iPosition=0, int iRepeatStart=0, int iRepeatsDone=0, float fDelay=0.0f, int iRecursions=0);
// For use with AssignCommand
void SetSongLength(object oInstrument);
// For use with WriteLyrics
void WriteLyric(object oInstrument, int iLyricsRecorded, int iLyric, float fDelay);
// Write a track of lyrics
void WriteLyrics(object oPC, object oInstrument, string sInput);
// Read a persist string from the TKL persist data store.
string GetTKLPersistString(object oPC, string sValueName);
// Write a persist string to the TKL persist data store.
void SetTKLPersistString(object oPC, string sValueName, string sValueData);
// Read a persist float from the TKL persist data store.
float GetTKLPersistFloat(object oPC, string sValueName);
// Write a persist float to the TKL persist data store.
void SetTKLPersistFloat(object oPC, string sValueName, float fValueData);
// Materialize a TKL instrument object using persisted data.
object RetrieveTKLPersistInstrumentObject(object oPC, string sValueName, location lLocation, object oOwner);
// Save a TKL instrument object to the persist store.
void StoreTKLPersistInstrumentObject(object oPC, string sValueName, object oInstrument);
// Upgrade the legacy campaign database to use the ACR Persist database.
void UpgradeTKLDatabase(object oTarget);

float GetSongLength(object oInstrument)
{
	float fSongLength, fTrackLength;
	int iTrack, iTotalNotes;
	int iTempo = GetLocalInt(oInstrument, "TEMPO");
	if (iTempo == 0)
		iTempo = 100;
	float fTempo = IntToFloat(iTempo) * 0.01f;
	string sTrack;
	for (iTrack = 1; iTrack <= 4; iTrack++)
	{
		sTrack = IntToString(iTrack);
		iTotalNotes = GetLocalInt(oInstrument, "NOTES_RECORDED_TRACK" + sTrack);
		if (iTotalNotes > 0)
		{
			fTrackLength = GetLocalFloat(oInstrument, "NOTE" + IntToString(iTotalNotes) +
				"PLAYBACK_TRACK" + sTrack);
			fTrackLength *= fTempo;
			if (fSongLength < fTrackLength)
				fSongLength = fTrackLength;
		}
	}
	iTotalNotes = GetLocalInt(oInstrument, "LYRICS_RECORDED");
	if (iTotalNotes > 0)
	{
		fTrackLength = GetLocalFloat(oInstrument, "LYRIC" + IntToString(iTotalNotes) + "PLAYBACK");
		fTrackLength *= fTempo;
		if (fSongLength < fTrackLength)
			fSongLength = fTrackLength;
	}
	return fSongLength;
}

int TransposeChord(int iChord, int iNewKey)
{
	if (iNewKey == 0)
		return iChord;
	int iNewChord = iChord + iNewKey;
	// get the correct pitch of high chords
	if ((iChord < 113 && iNewChord > 112) || 
		(iChord < 163 && iNewChord > 162) ||
		(iChord < 125 && iNewChord > 124) ||
		(iChord < 175 && iNewChord > 174) ||
		(iChord < 137 && iNewChord > 136) ||
		(iChord < 187 && iNewChord > 186))
		iNewChord -= 12;
	
	return iNewChord;
}

void PlayNote(int iNote, int iKey)
{
	// transpose chords
	if (iNote > 100 && iNote < 200)
		iNote = TransposeChord(iNote, iKey);
	// don't transpose percussion
	else if ((iNote > 300 && iNote < 321) || (iNote > 350 && iNote < 371))
		iKey = 0;
	// transpose everything else
	else
		iNote = iNote + iKey;
	string sNote = "tkl_performer_" + IntToString(iNote);
	PlaySound(sNote);
}

void ClearTKLPerformerVariables(object oPC)
{
	DeleteLocalInt(oPC, "TKL_PERFORMER_OPTION");
	DeleteLocalString(oPC, "TKL_PERFORMER_ACTION");
}

void RefreshLyrics(object oPC, object oInstrument, int bUsePerform = TRUE)
{
	int iPerform = GetPerform(oPC);
	if (TKL_PERFORM_AFFECTS_LYRICS && bUsePerform)
		iPerform *= TKL_LYRICS_PER_PERFORM_POINT;
	else
		iPerform = 65;
	int i;
	string sButton;
	string sText;
	for (i = 1; i <= 64; i++)
	{
		sButton = IntToString(i);
		if (i > iPerform)
		{
			SetGUIObjectText(oPC, "TKL_PERFORMER_LYRICS", "Lyric" + sButton + "Button", 0, "[Unavailable Slot]");	
			SetGUIObjectDisabled(oPC, "TKL_PERFORMER_LYRICS", "Lyric" + sButton + "Button", TRUE);
		}
		else
		{
			sText = GetStringLeft(GetLocalString(oInstrument, "LYRIC" + sButton), 12);
			if (sText == "")
				sText = IntToString(i) + ". [Empty Slot]";
			else
				sText = IntToString(i) + ". " + sText;
			SetGUIObjectText(oPC, "TKL_PERFORMER_LYRICS", "Lyric" + sButton + "Button", 0, sText);	
			SetGUIObjectDisabled(oPC, "TKL_PERFORMER_LYRICS", "Lyric" + sButton + "Button", FALSE);		
		}
	} 
}

void RefreshNames(object oPC, object oInstrument)
{
	string sSongName = GetLocalString(oInstrument, "SONG_NAME");
	if (sSongName == "")
	{
		sSongName = "Untitled";
		SetLocalString(oInstrument, "SONG_NAME", "Untitled");
	}
	string sTrack1Name = GetLocalString(oInstrument, "TRACK_1_NAME");
	if (sTrack1Name == "")
	{
		sTrack1Name = "Track 1";
		SetLocalString(oInstrument, "TRACK_1_NAME", "Track 1");
	}
	string sTrack2Name = GetLocalString(oInstrument, "TRACK_2_NAME");
	if (sTrack2Name == "")
	{
		sTrack2Name = "Track 2";
		SetLocalString(oInstrument, "TRACK_2_NAME", "Track 2");
	}
	string sTrack3Name = GetLocalString(oInstrument, "TRACK_3_NAME");
	if (sTrack3Name == "")
	{
		sTrack3Name = "Track 3";
		SetLocalString(oInstrument, "TRACK_3_NAME", "Track 3");
	}
	string sTrack4Name = GetLocalString(oInstrument, "TRACK_4_NAME");
	if (sTrack4Name == "")
	{
		sTrack4Name = "Track 4";
		SetLocalString(oInstrument, "TRACK_4_NAME", "Track 4");
	}
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "SongButton", -1, sSongName);
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "MinorSongButton", -1, sSongName);
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "EasySongButton", -1, sSongName);
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "LiveSongButton", -1, sSongName);
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "EasyMinorSongButton", -1, sSongName);
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "EasyLiveSongButton", -1, sSongName);
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "EasyMinorLiveSongButton", -1, sSongName);
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "MinorLiveSongButton", -1, sSongName);
	
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "Track1Button", -1, sTrack1Name);
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "MinorTrack1Button", -1, sTrack1Name);
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "EasyTrack1Button", -1, sTrack1Name);
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "LiveTrack1Button", -1, sTrack1Name);
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "EasyMinorTrack1Button", -1, sTrack1Name);
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "EasyLiveTrack1Button", -1, sTrack1Name);
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "EasyMinorLiveTrack1Button", -1, sTrack1Name);
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "MinorLiveTrack1Button", -1, sTrack1Name);
	
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "Track2Button", -1, sTrack2Name);
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "MinorTrack2Button", -1, sTrack2Name);
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "EasyTrack2Button", -1, sTrack2Name);
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "LiveTrack2Button", -1, sTrack2Name);
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "EasyMinorTrack2Button", -1, sTrack2Name);
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "EasyLiveTrack2Button", -1, sTrack2Name);
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "EasyMinorLiveTrack2Button", -1, sTrack2Name);
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "MinorLiveTrack2Button", -1, sTrack2Name);
	
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "Track3Button", -1, sTrack3Name);
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "MinorTrack3Button", -1, sTrack3Name);
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "EasyTrack3Button", -1, sTrack3Name);
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "LiveTrack3Button", -1, sTrack3Name);
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "EasyMinorTrack3Button", -1, sTrack3Name);
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "EasyLiveTrack3Button", -1, sTrack3Name);
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "EasyMinorLiveTrack3Button", -1, sTrack3Name);
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "MinorLiveTrack3Button", -1, sTrack3Name);
	
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "Track4Button", -1, sTrack4Name);
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "MinorTrack4Button", -1, sTrack4Name);
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "EasyTrack4Button", -1, sTrack4Name);
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "LiveTrack4Button", -1, sTrack4Name);
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "EasyMinorTrack4Button", -1, sTrack4Name);
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "EasyLiveTrack4Button", -1, sTrack4Name);
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "EasyMinorLiveTrack4Button", -1, sTrack4Name);
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "MinorLiveTrack4Button", -1, sTrack4Name);
}

void RefreshSongList(object oPC)
{
	int bDM = GetIsDM(oPC);
	int iMaxSongs = GetPerform(oPC);
	if (TKL_PERFORM_AFFECTS_SONGS && !bDM)
		iMaxSongs = FloatToInt(IntToFloat(iMaxSongs) * TKL_SONGS_PER_PERFORM_POINT);
	else
		iMaxSongs = 11;
	string sName, sSong;
	int i, bDisable;
	for (i=1; i<=10; i++)
	{
		if (i > iMaxSongs)
		{
			bDisable = TRUE;
			sName = "[Unavailable Slot: You need more Perform ranks]";
		}
		else
		{
			bDisable = FALSE;
			if (bDM)
				sName = GetTKLPersistString(OBJECT_INVALID, "TKL_SERVER_SONG_NAME" + IntToString(i));
			else
			{
				sName = GetTKLPersistString(oPC, "TKL_SONG_NAME" + IntToString(i));
				if (sName == "")
					sName = GetTKLPersistString(oPC, "TKL_PERFORMER_SONG_NAME" + IntToString(i));
			}
			if (sName == "")
				sName = "[Empty Slot]";
		}
		sSong = IntToString(i);
		SetGUIObjectDisabled(oPC, TKL_PERFORMER_SCREEN, "Load" + sSong + "Button", bDisable);
		SetGUIObjectDisabled(oPC, TKL_PERFORMER_SCREEN, "Save" + sSong + "Button", bDisable);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "Load" + sSong + "Button", -1, sName);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "Save" + sSong + "Button", -1, sName);
	}
}

void SetNoteNames(object oPC, int bMinor, string s1, string s2, string s3, string s4, string s5, string s6, string s7)
{
	string sPrefix;
	object oInstrument = GetLocalObject(oPC, "TKL_PERFORMER_INSTRUMENT");
	if (GetLocalInt(oInstrument, "EASY_MODE"))
		sPrefix += "Easy";
	if (GetLocalInt(oInstrument, "MINOR_MODE"))
		sPrefix += "Minor";
	if (!GetLocalInt(oInstrument, "RECORD_MODE"))
		sPrefix += "Live";			

	// Set names for Major keys	
	if (bMinor == FALSE)
	{
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note1", -1, s1);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note2", -1, "");
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note3", -1, s2);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note4", -1, "");
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note5", -1, s3);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note6", -1, s4);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note7", -1, "");
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note8", -1, s5);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note9", -1, "");
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note10", -1, s6);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note11", -1, "");
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note12", -1, s7);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note12b", -1, s1);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note13", -1, s1);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note14", -1, "");
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note15", -1, s2);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note16", -1, "");
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note17", -1, s3);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note18", -1, s4);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note19", -1, "");
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note20", -1, s5);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note21", -1, "");
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note22", -1, s6);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note23", -1, "");
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note24", -1, s7);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note24b", -1, s1);
		
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord1", -1, sColor + s1 + sEndColor);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord2", -1, "");
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord3", -1, s2);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord4", -1, "");
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord5", -1, s3);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord6", -1, sColor + s4 + sEndColor);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord7", -1, "");
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord8", -1, sColor + s5 + sEndColor);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord9", -1, "");
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord10", -1, s6);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord11", -1, "");
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord12", -1, s7);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord13", -1, s1 + sMinorEnd);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord14", -1, "");
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord15", -1, sColor + s2 + sMinorEndColor);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord16", -1, "");
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord17", -1, sColor + s3 + sMinorEndColor);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord18", -1, s4 + sMinorEnd);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord19", -1, "");
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord20", -1, s5 + sMinorEnd);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord21", -1, "");
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord22", -1, sColor + s6 + sMinorEndColor);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord23", -1, "");
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord24", -1, sColor + s7 + sDimEndColor);
	}
	// Or set names for Minor keys
	else
	{	
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note1", -1, s1);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note2", -1, "");
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note3", -1, s2);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note4", -1, s3);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note5", -1, "");
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note6", -1, s4);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note7", -1, "");
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note8", -1, s5);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note9", -1, s6);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note10", -1, "");
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note11", -1, s7);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note12", -1, "");
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note12b", -1, s1);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note13", -1, s1);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note14", -1, "");
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note15", -1, s2);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note16", -1, s3);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note17", -1, "");
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note18", -1, s4);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note19", -1, "");
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note20", -1, s5);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note21", -1, s6);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note22", -1, "");
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note23", -1, s7);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note24", -1, "");
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Note24b", -1, s1);
		
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord1", -1, s1);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord2", -1, "");
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord3", -1, s2);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord4", -1, sColor + s3 + sEndColor);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord5", -1, "");
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord6", -1, s4);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord7", -1, "");
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord8", -1, sColor + s5 + sEndColor);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord9", -1, sColor + s6 + sEndColor);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord10", -1, "");
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord11", -1, sColor + s7 + sEndColor);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord12", -1, "");
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord13", -1, sColor + s1 + sMinorEndColor);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord14", -1, "");
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord15", -1, sColor + s2 + sDimEndColor);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord16", -1, s3 + sMinorEnd);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord17", -1, "");
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord18", -1, sColor + s4 + sMinorEndColor);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord19", -1, "");
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord20", -1, s5 + sMinorEnd);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord21", -1, s6 + sMinorEnd);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord22", -1, "");
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord23", -1, s7 + sMinorEnd);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, sPrefix + "Chord24", -1, "");
	}
}


void RefreshNoteNames(object oPC, object oInstrument)
{
	int iKey = GetLocalInt(oInstrument, "KEY");
	int iMinorMode = GetLocalInt(oInstrument, "MINOR_MODE");
	switch (iKey)
	{
		case 0:
			if (iMinorMode == FALSE)
				SetNoteNames(oPC, FALSE, "C", "D", "E", "F", "G", "A", "B");
			else
				SetNoteNames(oPC, TRUE, "C", "D", "Eb", "F", "G", "Ab", "Bb");
			SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "KeyButton", -1, "C");
			break;
		case 1:
			if (iMinorMode == FALSE)
				SetNoteNames(oPC, FALSE, "Db", "Eb", "F", "Gb", "Ab", "Bb", "C");
			else
				SetNoteNames(oPC, TRUE, "C#", "D#", "E", "F#", "G#", "A", "B");
			SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "KeyButton", -1, "Db");
			break;
		case 2:
			if (iMinorMode == FALSE)
				SetNoteNames(oPC, FALSE, "D", "E", "F#", "G", "A", "B", "C#");
			else
				SetNoteNames(oPC, TRUE, "D", "E", "F", "G", "A", "Bb", "C");
			SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "KeyButton", -1, "D");
			break;
		case 3:
			if (iMinorMode == FALSE)
				SetNoteNames(oPC, FALSE, "Eb", "F", "G", "Ab", "Bb", "C", "D");
			else
				SetNoteNames(oPC, TRUE, "Eb", "F", "Gb", "Ab", "Bb", "Cb", "Db");
			SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "KeyButton", -1, "Eb");
			break;
		case 4:
			if (iMinorMode == FALSE)
				SetNoteNames(oPC, FALSE, "E", "F#", "G#", "A", "B", "C#", "D#");
			else
				SetNoteNames(oPC, TRUE, "E", "F#", "G", "A", "B", "C", "D");
			SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "KeyButton", -1, "E");
			break;
		case 5:
			if (iMinorMode == FALSE)
				SetNoteNames(oPC, FALSE, "F", "G", "A", "Bb", "C", "D", "E");
			else
				SetNoteNames(oPC, TRUE, "F", "G", "Ab", "Bb", "C", "Db", "Eb");
			SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "KeyButton", -1, "F");
			break;
		case 6:
			if (iMinorMode == FALSE)
				SetNoteNames(oPC, FALSE, "Gb", "Ab", "Bb", "Cb", "Db", "Eb", "F");
			else
				SetNoteNames(oPC, TRUE, "F#", "G#", "A", "B", "C#", "D", "E");
			SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "KeyButton", -1, "Gb");
			break;
		case 7:
			if (iMinorMode == FALSE)
				SetNoteNames(oPC, FALSE, "G", "A", "B", "C", "D", "E", "F#");
			else
				SetNoteNames(oPC, TRUE, "G", "A", "Bb", "C", "D", "Eb", "F");
			SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "KeyButton", -1, "G");
			break;
		case 8:
			if (iMinorMode == FALSE)
				SetNoteNames(oPC, FALSE, "Ab", "Bb", "C", "Db", "Eb", "F", "G");
			else
				SetNoteNames(oPC, TRUE, "Ab", "Bb", "Cb", "Db", "Eb", "Fb", "Gb");
			SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "KeyButton", -1, "Ab");
			break;
		case 9:
			if (iMinorMode == FALSE)
				SetNoteNames(oPC, FALSE, "A", "B", "C#", "D", "E", "F#", "G#");
			else
				SetNoteNames(oPC, TRUE, "A", "B", "C", "D", "E", "F", "G");
			SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "KeyButton", -1, "A");
			break;
		case 10:
			if (iMinorMode == FALSE)
				SetNoteNames(oPC, FALSE, "Bb", "C", "D", "Eb", "F", "G", "A");
			else
				SetNoteNames(oPC, TRUE, "Bb", "C", "Db", "Eb", "F", "Gb", "Ab");
			SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "KeyButton", -1, "Bb");
			break;
		case 11:
			if (iMinorMode == FALSE)
				SetNoteNames(oPC, FALSE, "B", "C#", "D#", "E", "F#", "G#", "A#");
			else
				SetNoteNames(oPC, TRUE, "B", "C#", "D", "E", "F#", "G", "A");
			SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "KeyButton", -1, "B");
			break;
			
	}
}

void EraseTrack(object oInstrument, int iTrack, int bEraseName=TRUE)
{
	string sTrack = IntToString(iTrack);
	int iTotalNotes = GetLocalInt(oInstrument, "NOTES_RECORDED_TRACK" + sTrack);
	string sID;
	while (iTotalNotes > 0)
	{
		sID = "NOTE" + IntToString(iTotalNotes);
		DeleteLocalInt(oInstrument, sID + "PITCH_TRACK" + sTrack);
		DeleteLocalFloat(oInstrument, sID + "PLAYBACK_TRACK" + sTrack);
		iTotalNotes--;
	}
	DeleteLocalInt(oInstrument, "NOTES_RECORDED_TRACK" + sTrack);
	if (bEraseName)
		DeleteLocalString(oInstrument, "TRACK_" + sTrack + "_NAME");
	DeleteLocalFloat(oInstrument, "OFFSET" + sTrack);
	DeleteLocalInt(oInstrument, "METRONOME_RECORDED_TRACK" + sTrack);
	DeleteLocalString(oInstrument, "WRITE_TRACK" + sTrack);
	SetLocalFloat(oInstrument, "SONG_LENGTH", GetSongLength(oInstrument));
	DeleteLocalInt(oInstrument, "NOTE_EDIT_BEATS");
}

void EnableButtons(object oPC, object oInstrument)
{
	SetGUIObjectDisabled(oPC, TKL_PERFORMER_SCREEN, "SongPlayButton", FALSE);
	SetGUIObjectDisabled(oPC, TKL_PERFORMER_SCREEN, "Track1PlayButton", FALSE);
	SetGUIObjectDisabled(oPC, TKL_PERFORMER_SCREEN, "Track2PlayButton", FALSE);
	SetGUIObjectDisabled(oPC, TKL_PERFORMER_SCREEN, "Track3PlayButton", FALSE);
	SetGUIObjectDisabled(oPC, TKL_PERFORMER_SCREEN, "Track4PlayButton", FALSE);
	SetGUIObjectDisabled(oPC, TKL_PERFORMER_SCREEN, "SongPreviewButton", FALSE);
	SetGUIObjectDisabled(oPC, TKL_PERFORMER_SCREEN, "Track1RecordButton", FALSE);
	SetGUIObjectDisabled(oPC, TKL_PERFORMER_SCREEN, "Track2RecordButton", FALSE);
	SetGUIObjectDisabled(oPC, TKL_PERFORMER_SCREEN, "Track3RecordButton", FALSE);
	SetGUIObjectDisabled(oPC, TKL_PERFORMER_SCREEN, "Track4RecordButton", FALSE);
}

void DisableButtons(object oPC, object oInstrument, int bPreview=FALSE)
{
	SetGUIObjectDisabled(oPC, TKL_PERFORMER_SCREEN, "SongPlayButton", TRUE);
	SetGUIObjectDisabled(oPC, TKL_PERFORMER_SCREEN, "Track1PlayButton", TRUE);
	SetGUIObjectDisabled(oPC, TKL_PERFORMER_SCREEN, "Track2PlayButton", TRUE);
	SetGUIObjectDisabled(oPC, TKL_PERFORMER_SCREEN, "Track3PlayButton", TRUE);
	SetGUIObjectDisabled(oPC, TKL_PERFORMER_SCREEN, "Track4PlayButton", TRUE);
	SetGUIObjectDisabled(oPC, TKL_PERFORMER_SCREEN, "SongPreviewButton", TRUE);
	SetGUIObjectDisabled(oPC, TKL_PERFORMER_SCREEN, "Track1RecordButton", TRUE);
	SetGUIObjectDisabled(oPC, TKL_PERFORMER_SCREEN, "Track2RecordButton", TRUE);
	SetGUIObjectDisabled(oPC, TKL_PERFORMER_SCREEN, "Track3Recordutton", TRUE);
	SetGUIObjectDisabled(oPC, TKL_PERFORMER_SCREEN, "Track4RecordButton", TRUE);
	float fDelay = GetLocalFloat(oInstrument, "SONG_LENGTH");
	if (bPreview && fDelay > TKL_PREVIEW)
		fDelay = TKL_PREVIEW;
	DelayCommand(fDelay, EnableButtons(oPC, oInstrument));
}

void PlayLyrics(object oPC, object oInstrument, int bPreview=FALSE, int bIgnoreTempo=FALSE)
{
	if (GetLocalInt(oInstrument, "LYRICS_MUTED"))
	{
		SendMessageToPC(oPC, "Lyrics muted.");
		return;
	}
	int iLyricsRecorded = GetLocalInt(oInstrument, "LYRICS_RECORDED");
	int iLyricsSang = 1;
	int iTempo = GetLocalInt(oInstrument, "TEMPO");
	if (iTempo == 0)
		iTempo = 100;
	float fDelay;
	float fTempo;
	if (bIgnoreTempo == FALSE)
		fTempo = IntToFloat(iTempo) * 0.01f;
	else
		fTempo = 1.0f;
	string sText;
	int iLyric, bDMThrow;
	object oThrow;
	if (GetIsDM(oPC))
	{
		oThrow = GetPlayerCurrentTarget(oPC);
		if (GetObjectType(oThrow) == OBJECT_TYPE_CREATURE && GetIsPC(oThrow) == FALSE)
			bDMThrow = TRUE;
	}
	while (iLyricsSang <= iLyricsRecorded)
	{
		fDelay = GetLocalFloat(oInstrument, "LYRIC" + IntToString(iLyricsSang) + "PLAYBACK");
		fDelay *= fTempo;
		if (bPreview == TRUE && fDelay > TKL_PREVIEW)
			iLyricsSang = iLyricsRecorded + 1;
		iLyric = GetLocalInt(oInstrument, "LYRIC" + IntToString(iLyricsSang) + "TEXT");
		sText = GetLocalString(oInstrument, "LYRIC" + IntToString(iLyric));
		if (bDMThrow)
			DelayCommand(fDelay, AssignCommand(oThrow, SpeakString(sText)));
		else
			DelayCommand(fDelay, SpeakString(sText));
		iLyricsSang++;
	}
}

void PlayTrack(object oPC, object oInstrument, int iTrack, int bIgnoreKey=FALSE, int bIgnoreTempo=FALSE, int bDisableButtons=FALSE, int bPreview=FALSE)
{
	int iKey = GetLocalInt(oInstrument, "KEY");
	if (bIgnoreKey == TRUE)
		iKey = 0;
	int iTempo = GetLocalInt(oInstrument, "TEMPO");
	if (iTempo == 0)
		iTempo = 100;
	float fTempo;
	if (bIgnoreTempo == FALSE)
		fTempo = IntToFloat(iTempo) * 0.01f;
	else
		fTempo = 1.0f;
	float fDelay;
	string sTrack = IntToString(iTrack);
	if (GetLocalInt(oInstrument, "TRACK" + sTrack + "MUTE"))
	{
		SendMessageToPC(oPC, "Track " + sTrack + " muted.");
		return;
	}
	int iTotalNotes = GetLocalInt(oInstrument, "NOTES_RECORDED_TRACK" + sTrack);
	int iNotesPlayed = 1;
	int iNote;
	while (iNotesPlayed <= iTotalNotes)
	{
		fDelay = GetLocalFloat(oInstrument, "NOTE" + IntToString(iNotesPlayed) + 
			"PLAYBACK_TRACK" + sTrack);
		iNote = GetLocalInt(oInstrument, "NOTE" + IntToString(iNotesPlayed) +
			"PITCH_TRACK" + sTrack);
		fDelay *= fTempo;
		if (bPreview == TRUE && fDelay > TKL_PREVIEW)
			iNotesPlayed = iTotalNotes + 1;
		DelayCommand(fDelay, PlayNote(iNote, iKey));
		iNotesPlayed++;
	}
	if (bDisableButtons)
	{
		DisableButtons(oPC, oInstrument, bPreview);
	}
		
}

void PlaySong(object oPC, object oInstrument, int iExcludeTrack=0, int bLyrics=FALSE, int bIgnoreKey=FALSE, int bIgnoreTempo=FALSE, int bPreview=FALSE)
{
	int i;
	for (i=1; i<=4; i++)
	{
		if (i != iExcludeTrack) PlayTrack(oPC, oInstrument, i, bIgnoreKey, bIgnoreTempo, FALSE, bPreview);
	}
	if (bLyrics)
		PlayLyrics(oPC, oInstrument, bPreview, bIgnoreTempo);
	DisableButtons(oPC, oInstrument, bPreview);
}

void RecordTrack(object oPC, object oInstrument, int iTrack)
{
	if (GetLocalString(oInstrument, "ORIGINAL_COMPOSER") == "")
		SetLocalString(oInstrument, "ORIGINAL_COMPOSER", GetName(oPC));
	EraseTrack(oInstrument, iTrack, FALSE);
	SetLocalInt(oInstrument, "RECORD_MODE", TRUE);
	RefreshModes(oPC, oInstrument);
	StartTimer(oInstrument, "PLAYBACK");		
	DeleteLocalInt(oInstrument, "NOTES_RECORDED_TRACK" + IntToString(iTrack));
	SendMessageToPC(oPC, "Recording started.");
	SetLocalInt(oInstrument, "RECORDING_TRACK", iTrack);
	SetGUIObjectHidden(oPC, TKL_PERFORMER_SCREEN, "StopRecordingPane", FALSE);
}

void PlayMetronome(object oPC, int iTempo, int iSeconds)
{
	float fTick = 60.0f / IntToFloat(iTempo);
	float fDelay;
	while (fDelay < IntToFloat(iSeconds))
	{
		DelayCommand(fDelay, PlaySound("tkl_performer_metronome"));
		fDelay += fTick;	
	}
}

void PassTKLParameters(object oPC, string sAction, int iOption)
{
	SetLocalInt(oPC, "TKL_PERFORMER_OPTION", iOption);
	SetLocalString(oPC, "TKL_PERFORMER_ACTION", sAction);
}

void EraseLyricTrack(object oInstrument)
{
	int iTotalLyrics = GetLocalInt(oInstrument, "LYRICS_RECORDED");
	while (iTotalLyrics > 0)
	{
		DeleteLocalInt(oInstrument, "LYRIC" + IntToString(iTotalLyrics) + "TEXT");
		DeleteLocalFloat(oInstrument, "LYRIC" + IntToString(iTotalLyrics) + "PLAYBACK");
		iTotalLyrics--;
	}
	SetLocalFloat(oInstrument, "SONG_LENGTH", GetSongLength(oInstrument));
	DeleteLocalInt(oInstrument, "LYRICS_RECORDED");
	DeleteLocalString(oInstrument, "WRITE_LYRICS");
}

void EraseLyrics(object oInstrument)
{
	int i;
	for (i=1; i<=64; i++)
	{
		DeleteLocalString(oInstrument, "LYRIC" + IntToString(i));
	}
	object oPC = GetItemPossessor(oInstrument);
	if (GetIsObjectValid(oPC))
		RefreshLyrics(oPC, oInstrument);
}

void TransferSong(object oInstrument, object oNew, int bFeedback=FALSE)
{
	if (!GetIsObjectValid(oInstrument) || !GetIsObjectValid(oNew))
	{
		return;
	}
	
	object oPC = GetItemPossessor(oNew);
	
	EraseTrack(oNew, 4);
	EraseTrack(oNew, 3);
	EraseTrack(oNew, 2);
	EraseTrack(oNew, 1);
	DeleteLocalString(oNew, "SONG_NAME");
	//EraseLyrics(oNew);
	EraseLyricTrack(oNew);
	//DeleteLocalInt(oNew, "KEY");
	//DeleteLocalInt(oNew, "TEMPO");
	//DeleteLocalString(oNew, "ORIGINAL_COMPOSER");
	
	SetLocalInt(oNew, "EASY_MODE", GetLocalInt(oInstrument, "EASY_MODE"));
	SetLocalInt(oNew, "MINOR_MODE", GetLocalInt(oInstrument, "MINOR_MODE"));
	SetLocalInt(oNew, "RECORD_MODE", GetLocalInt(oInstrument, "RECORD_MODE"));
	SetLocalInt(oNew, "KEY", GetLocalInt(oInstrument, "KEY"));
	SetLocalInt(oNew, "RECORDING_TRACK", GetLocalInt(oInstrument, "RECORDING_TRACK"));
	SetLocalInt(oNew, "NOTES_RECORDED_TRACK1", GetLocalInt(oInstrument, "NOTES_RECORDED_TRACK1"));
	SetLocalInt(oNew, "NOTES_RECORDED_TRACK2", GetLocalInt(oInstrument, "NOTES_RECORDED_TRACK2"));
	SetLocalInt(oNew, "NOTES_RECORDED_TRACK3", GetLocalInt(oInstrument, "NOTES_RECORDED_TRACK3"));
	SetLocalInt(oNew, "NOTES_RECORDED_TRACK4", GetLocalInt(oInstrument, "NOTES_RECORDED_TRACK4"));	
	SetLocalInt(oNew, "METRONOME_RECORDED_TRACK1", GetLocalInt(oInstrument, "METRONOME_RECORDED_TRACK1"));
	SetLocalInt(oNew, "METRONOME_RECORDED_TRACK2", GetLocalInt(oInstrument, "METRONOME_RECORDED_TRACK2"));
	SetLocalInt(oNew, "METRONOME_RECORDED_TRACK3", GetLocalInt(oInstrument, "METRONOME_RECORDED_TRACK3"));
	SetLocalInt(oNew, "METRONOME_RECORDED_TRACK4", GetLocalInt(oInstrument, "METRONOME_RECORDED_TRACK4"));
	SetLocalInt(oNew, "TEMPO", GetLocalInt(oInstrument, "TEMPO"));
	SetLocalInt(oNew, "OFFSET1", GetLocalInt(oInstrument, "OFFSET1"));
	SetLocalInt(oNew, "OFFSET2", GetLocalInt(oInstrument, "OFFSET2"));
	SetLocalInt(oNew, "OFFSET3", GetLocalInt(oInstrument, "OFFSET3"));
	SetLocalInt(oNew, "OFFSET4", GetLocalInt(oInstrument, "OFFSET4"));
	SetLocalString(oNew, "TRACK_1_NAME", GetLocalString(oInstrument, "TRACK_1_NAME"));
	SetLocalString(oNew, "TRACK_2_NAME", GetLocalString(oInstrument, "TRACK_2_NAME"));
	SetLocalString(oNew, "TRACK_3_NAME", GetLocalString(oInstrument, "TRACK_3_NAME"));
	SetLocalString(oNew, "TRACK_4_NAME", GetLocalString(oInstrument, "TRACK_4_NAME"));
	SetLocalString(oNew, "SONG_NAME", GetLocalString(oInstrument, "SONG_NAME"));
	SetLocalInt(oNew, "METRONOME", GetLocalInt(oInstrument, "METRONOME"));
	SetLocalInt(oNew, "METRONOME_ON", GetLocalInt(oInstrument, "METRONOME_ON"));
	SetLocalInt(oNew, "LYRICS_RECORDED", GetLocalInt(oInstrument, "LYRICS_RECORDED"));
	SetLocalFloat(oNew, "SONG_LENGTH", GetLocalFloat(oInstrument, "SONG_LENGTH"));
	SetLocalString(oNew, "ORIGINAL_COMPOSER", GetLocalString(oInstrument, "ORIGINAL_COMPOSER"));
	SetLocalInt(oNew, "CURRENT_NOTE_TRACK1", GetLocalInt(oInstrument, "CURRENT_NOTE_TRACK1"));
	SetLocalInt(oNew, "CURRENT_NOTE_TRACK2", GetLocalInt(oInstrument, "CURRENT_NOTE_TRACK2"));
	SetLocalInt(oNew, "CURRENT_NOTE_TRACK3", GetLocalInt(oInstrument, "CURRENT_NOTE_TRACK3"));
	SetLocalInt(oNew, "CURRENT_NOTE_TRACK4", GetLocalInt(oInstrument, "CURRENT_NOTE_TRACK4"));
	SetLocalString(oNew, "WRITE_TRACK1", GetLocalString(oInstrument, "WRITE_TRACK1"));
	SetLocalString(oNew, "WRITE_TRACK2", GetLocalString(oInstrument, "WRITE_TRACK2"));
	SetLocalString(oNew, "WRITE_TRACK3", GetLocalString(oInstrument, "WRITE_TRACK3"));
	SetLocalString(oNew, "WRITE_TRACK4", GetLocalString(oInstrument, "WRITE_TRACK4"));
	SetLocalFloat(oNew, "SECONDS_PER_LYRIC", GetLocalFloat(oInstrument, "SECONDS_PER_LYRIC"));
	SetLocalInt(oNew, "USE_LYRIC_AUTOMATION", GetLocalInt(oInstrument, "USE_LYRIC_AUTOMATION"));
	int i;
	string s;
	i = GetLocalInt(oInstrument, "NOTES_RECORDED_TRACK1");
	if (i > 0 && bFeedback) SendMessageToPC(oPC, "Track 1 learned.");
	while (i > 0)
	{
		s = IntToString(i);
		SetLocalInt(oNew, "NOTE" + s + "PITCH_TRACK1", GetLocalInt(oInstrument, "NOTE" + s + "PITCH_TRACK1"));
		SetLocalFloat(oNew, "NOTE" + s + "PLAYBACK_TRACK1", GetLocalFloat(oInstrument, "NOTE" + s + "PLAYBACK_TRACK1"));
		i--;
	}
	
	i = GetLocalInt(oInstrument, "NOTES_RECORDED_TRACK2");
	if (i > 0 && bFeedback) SendMessageToPC(oPC, "Track 2 learned.");
	while (i > 0)
	{
		s = IntToString(i);
		SetLocalInt(oNew, "NOTE" + s + "PITCH_TRACK2", GetLocalInt(oInstrument, "NOTE" + s + "PITCH_TRACK2"));
		SetLocalFloat(oNew, "NOTE" + s + "PLAYBACK_TRACK2", GetLocalFloat(oInstrument, "NOTE" + s + "PLAYBACK_TRACK2"));
		i--;
	}
	
	i = GetLocalInt(oInstrument, "NOTES_RECORDED_TRACK3");
	if (i > 0 && bFeedback) SendMessageToPC(oPC, "Track 3 learned.");
	while (i > 0)
	{
		s = IntToString(i);
		SetLocalInt(oNew, "NOTE" + s + "PITCH_TRACK3", GetLocalInt(oInstrument, "NOTE" + s + "PITCH_TRACK3"));
		SetLocalFloat(oNew, "NOTE" + s + "PLAYBACK_TRACK3", GetLocalFloat(oInstrument, "NOTE" + s + "PLAYBACK_TRACK3"));
		i--;
	}
	
	i = GetLocalInt(oInstrument, "NOTES_RECORDED_TRACK4");
	if (i > 0 && bFeedback) SendMessageToPC(oPC, "Track 4 learned.");
	while (i > 0)
	{
		s = IntToString(i);
		SetLocalInt(oNew, "NOTE" + s + "PITCH_TRACK4", GetLocalInt(oInstrument, "NOTE" + s + "PITCH_TRACK4"));
		SetLocalFloat(oNew, "NOTE" + s + "PLAYBACK_TRACK4", GetLocalFloat(oInstrument, "NOTE" + s + "PLAYBACK_TRACK4"));
		i--;
	}
	
	i = GetLocalInt(oInstrument, "LYRICS_RECORDED");
	if (i > 0 && bFeedback) SendMessageToPC(oPC, "Lyrics learned.");
	while (i > 0)
	{
		s = IntToString(i);
		SetLocalInt(oNew, "LYRIC" + s + "TEXT", GetLocalInt(oInstrument, "LYRIC" + s + "TEXT"));
		SetLocalFloat(oNew, "LYRIC" + s + "PLAYBACK", GetLocalFloat(oInstrument, "LYRIC" + s + "PLAYBACK"));
		i--;
	}
	
	for (i=1; i<=64; i++)
	{
		s = IntToString(i);
		SetLocalString(oNew, "LYRIC" + s, GetLocalString(oInstrument, "LYRIC" + s));
	}
	
	if (GetIsObjectValid(oPC) && GetIsObjectValid(GetLocalObject(oPC, "TKL_PERFORMER_INSTRUMENT")))
	{
		RefreshLyrics(oPC, oNew);
		RefreshNames(oPC, oNew);
		RefreshNoteNames(oPC, oNew);
		RefreshModes(oPC, oNew);
		int iTempo = GetLocalInt(oNew, "TEMPO");
		if (iTempo == 0)
		{
			SetLocalInt(oNew, "TEMPO", 100);
			iTempo = 100;
		}
		int iMaxSpeed = GetMaximumSpeed(oPC);
		if (iTempo < (100 - iMaxSpeed))
			SetLocalInt(oNew, "TEMPO", 100 - iMaxSpeed);
		SetLocalFloat(oNew, "SONG_LENGTH", GetSongLength(oNew));
	}
}

void StopRecording(object oPC, object oInstrument)
{
	string sStop = StopTimer(oInstrument, "PLAYBACK");
	int iTrack = GetLocalInt(oInstrument, "RECORDING_TRACK");
	DeleteLocalInt(oInstrument, "RECORDING_TRACK");
	int bRecordingLyrics = GetLocalInt(oInstrument, "RECORDING_LYRICS");
	DeleteLocalInt(oInstrument, "RECORDING_LYRICS");
	string sTrack = IntToString(iTrack);
	float fLagCheck = GetLocalFloat(oPC, "LAG_CHECK");
	int bLagCheckOn = GetLocalInt(oPC, "LAG_CHECK_ON");
	float fCurrent;
	if (bLagCheckOn)
	{
		string sID;
		int iNotesRecorded;
		if (iTrack > 0)
			iNotesRecorded = GetLocalInt(oInstrument, "NOTES_RECORDED_TRACK" + sTrack);
		else if (bRecordingLyrics)
			iNotesRecorded = GetLocalInt(oInstrument, "LYRICS_RECORDED");
		while (iNotesRecorded > 0)
		{
			if (iTrack > 0)
			{
				sID = "NOTE" + IntToString(iNotesRecorded) + "PLAYBACK_TRACK" + sTrack;
				fCurrent = GetLocalFloat(oInstrument, sID);
				SetLocalFloat(oInstrument, sID, fCurrent - fLagCheck);
			}
			else if (bRecordingLyrics)
			{
				sID = "LYRIC" + IntToString(iNotesRecorded) + "PLAYBACK";
				fCurrent = GetLocalFloat(oInstrument, sID);
				SetLocalFloat(oInstrument, sID, fCurrent - fLagCheck);				
			}
			iNotesRecorded--;
		}
	}
	if (GetLocalInt(oInstrument, "METRONOME_ON") && iTrack > 0)
	{
		int iMetronome = GetLocalInt(oInstrument, "METRONOME");
		if (iMetronome == 0)
			iMetronome = 60;
		SetLocalInt(oInstrument, "METRONOME_RECORDED_TRACK" + sTrack, iMetronome);
	}
	else
		DeleteLocalInt(oInstrument, "METRONOME_RECORDED_TRACK" + sTrack);
		
	SendMessageToPC(oPC, "Recording stopped.");
	// check to see if the last note is the final note of the song
	SetLocalFloat(oInstrument, "SONG_LENGTH", GetSongLength(oInstrument));
	if (bRecordingLyrics)
		SetGUIObjectHidden(oPC, "TKL_PERFORMER_LYRICS", "StopRecordingPane", TRUE);
	else
		SetGUIObjectHidden(oPC, TKL_PERFORMER_SCREEN, "StopRecordingPane", TRUE);
		
	DeleteLocalInt(oInstrument, "RECORD_MODE");
	RefreshModes(oPC, oInstrument);
}

void RefreshRecordPane(object oPC, object oInstrument)
{
	int bMetronomeOn = GetLocalInt(oInstrument, "METRONOME_ON");
	int bLagCheckOn = GetLocalInt(oPC, "LAG_CHECK_ON");
	int iMetronomeDuration = GetLocalInt(oInstrument, "METRONOME_DURATION");
	if (iMetronomeDuration == 0)
	{
		iMetronomeDuration = 60;
		SetLocalInt(oInstrument, "METRONOME_DURATION", 60);
	}
	int iMetronomeTempo = GetLocalInt(oInstrument, "METRONOME");
	if (iMetronomeTempo == 0)
	{
		iMetronomeTempo = 60;
		SetLocalInt(oInstrument, "METRONOME", 60);
	}
	float fSecondsPerBeat = 60.0f / IntToFloat(iMetronomeTempo);
	string sSecondsPerBeat = FloatToString(fSecondsPerBeat, 4, 2);
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "MetronomeSecondsPerBeat", -1, "<color=grey>(1 beat=" + sSecondsPerBeat + " sec)</color>");
	
	float fLagCheck = GetLocalFloat(oPC, "LAG_CHECK");
	int iTrack = GetLocalInt(oPC, "TKL_PERFORMER_OPTION");
	string sTrackName = GetLocalString(oInstrument, "TRACK_" + IntToString(iTrack) + "_NAME");
	if (sTrackName == "")
		sTrackName = "Track " + IntToString(iTrack);
	sTrackName = "<color=grey>" + sTrackName + "</color>";
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "RecordTrackName", -1, sTrackName);
	int bSwitch;
	if (bMetronomeOn)
	{
		bSwitch = FALSE;
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "MetronomeStatus", -1, "<color=grey>(enabled)</color>");
	}
	else
	{
		bSwitch = TRUE;
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "MetronomeStatus", -1, "<color=grey>(disabled)</color>");
	}	
	SetGUIObjectHidden(oPC, TKL_PERFORMER_SCREEN, "MetronomeTempoField", bSwitch);
	SetGUIObjectHidden(oPC, TKL_PERFORMER_SCREEN, "MetronomeDurationField", bSwitch);
	SetGUIObjectDisabled(oPC, TKL_PERFORMER_SCREEN, "MetronomeTempoUp", bSwitch);
	SetGUIObjectDisabled(oPC, TKL_PERFORMER_SCREEN, "MetronomeTempoDown", bSwitch);
	SetGUIObjectDisabled(oPC, TKL_PERFORMER_SCREEN, "MetronomeDurationUp", bSwitch);
	SetGUIObjectDisabled(oPC, TKL_PERFORMER_SCREEN, "MetronomeDurationDown", bSwitch);
	if (bLagCheckOn)
	{
		bSwitch = FALSE;
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "LagFixStatus", -1, "<color=grey>(enabled)</color>");
	}
	else
	{
		bSwitch = TRUE;
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "LagFixStatus", -1, "<color=grey>(disabled)</color>");
	}
	SetGUIObjectHidden(oPC, TKL_PERFORMER_SCREEN, "LagCheckInstructions", bSwitch);
	SetGUIObjectDisabled(oPC, TKL_PERFORMER_SCREEN, "LagCheckButton", bSwitch);
	
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "MetronomeTempoField", -1, IntToString(iMetronomeTempo));
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "MetronomeDurationField", -1, IntToString(iMetronomeDuration));
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "LagCheckButton", -1, FloatToString(fLagCheck, 4, 3));
}

void RefreshMuting(object oPC, object oInstrument)
{
	string s;
	int i;
	for (i=1; i<=4; i++)
	{
		s = IntToString(i);
		if (GetLocalInt(oInstrument, "TRACK" + s + "MUTE"))
			SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "Track" + s + "MuteButton", -1, "Un-Mute");
		else
			SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "Track" + s + "MuteButton", -1, "Mute");
	}
	
	if (GetLocalInt(oInstrument, "LYRICS_MUTED"))
		SetGUIObjectText(oPC, "TKL_PERFORMER_LYRICS", "LyricMuteButton", -1, "UN-MUTE");
	else
		SetGUIObjectText(oPC, "TKL_PERFORMER_LYRICS", "LyricMuteButton", -1, "MUTE LYRICS");
}

void RefreshModes(object oPC, object oInstrument)
{
	int bRecordMode = GetLocalInt(oInstrument, "RECORD_MODE");
	int bMinorMode = GetLocalInt(oInstrument, "MINOR_MODE");
	int bEasyMode = GetLocalInt(oInstrument, "EASY_MODE");
	
	string sPane = "Main";
	
	if (bEasyMode == FALSE)
		SetGUITexture(oPC, TKL_PERFORMER_SCREEN, "EasyButton", "skill_points_container.tga");
	else
	{
		SetGUITexture(oPC, TKL_PERFORMER_SCREEN, "EasyButton", "b_overlay.tga");
		sPane += "Easy";
	}	
			
	if (bMinorMode == FALSE)
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "MinorButton", 0, "MAJOR");	
	else
	{
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "MinorButton", 0, "MINOR");	
		sPane += "Minor";
	}
	
	if (bRecordMode == FALSE)
	{
		SetGUITexture(oPC, TKL_PERFORMER_SCREEN, "LiveButton", "b_overlay.tga");
		sPane+= "Live";
	}
	else
		SetGUITexture(oPC, TKL_PERFORMER_SCREEN, "LiveButton", "skill_points_container.tga");
		
	SetGUIObjectHidden(oPC, TKL_PERFORMER_SCREEN, "MainPane", TRUE);
	SetGUIObjectHidden(oPC, TKL_PERFORMER_SCREEN, "MainEasyMinorLivePane", TRUE);
	SetGUIObjectHidden(oPC, TKL_PERFORMER_SCREEN, "MainEasyMinorPane", TRUE);
	SetGUIObjectHidden(oPC, TKL_PERFORMER_SCREEN, "MainMinorLivePane", TRUE);
	SetGUIObjectHidden(oPC, TKL_PERFORMER_SCREEN, "MainEasyPane", TRUE);
	SetGUIObjectHidden(oPC, TKL_PERFORMER_SCREEN, "MainMinorPane", TRUE);
	SetGUIObjectHidden(oPC, TKL_PERFORMER_SCREEN, "MainLivePane", TRUE);
	SetGUIObjectHidden(oPC, TKL_PERFORMER_SCREEN, "MainEasyLivePane", TRUE);
	
	SetGUIObjectHidden(oPC, TKL_PERFORMER_SCREEN, sPane + "Pane", FALSE);
}

void LaunchTKLPerformer(object oPC, object oItem, string sGUIFile)
{
	if (GetSkillRank(SKILL_PERFORM, oPC, TRUE) < TKL_MINIMUM_PERFORM_TO_USE)
	{
		SendMessageToPC(oPC, "You need to have " + IntToString(TKL_MINIMUM_PERFORM_TO_USE) + 
			" BASE ranks of Perform before you can use this instrument.");
		return;
	}
	SetLocalObject(oPC, "TKL_PERFORMER_INSTRUMENT", oItem);
	EnableButtons(oPC, oItem);
	DisplayGuiScreen(oPC, TKL_PERFORMER_SCREEN, FALSE, sGUIFile);
	RefreshModes(oPC, oItem);
	RefreshNoteNames(oPC, oItem);
	RefreshSongList(oPC);
	RefreshNames(oPC, oItem);
	string sStop = StopTimer(oItem, "PLAYBACK");
	float fLagCheck = GetTKLPersistFloat(oPC, "LAG_CHECK");
	if (fLagCheck > 0.01f)
		SetLocalFloat(oPC, "LAG_CHECK", fLagCheck);
	SetLocalString(oItem, "GUI_FILE", sGUIFile);
	ResetExpiringVariables(oPC, oItem);
	int iTempo = GetLocalInt(oItem, "TEMPO");
	if (iTempo == 0)
	{
		SetLocalInt(oItem, "TEMPO", 100);
		iTempo = 100;
	}
	int iMaxSpeed = GetMaximumSpeed(oPC);
	if (iTempo < (100 - iMaxSpeed))
		SetLocalInt(oItem, "TEMPO", 100 - iMaxSpeed);
	SetLocalFloat(oItem, "SONG_LENGTH", GetSongLength(oItem));
	SetupImprovPane(oPC, oItem);
}

void ShutDownTKLPerformer(object oPC, object oItem)
{
	if (GetLocalInt(oItem, "RECORDING_TRACK") > 0 ||	GetLocalInt(oItem, "RECORDING_LYRICS") == TRUE)
	{
		StopRecording(oPC, oItem);
		DeleteLocalInt(oItem, "RECORD_MODE");
	}
	DeleteLocalObject(oPC, "TKL_PERFORMER_INSTRUMENT");
	CloseGUIScreen(oPC, TKL_PERFORMER_SCREEN);
	CloseGUIScreen(oPC, "TKL_PERFORMER_LYRICS");
}

void FindLastNote(object oPC, object oInstrument, int iTrack)
{
	string sTrack = IntToString(iTrack);
	int iPitch, iPitchCompare;
	float fLongestDelay, fDelayCompare;
	string sID, sOldID, sNewID;
	int iTotalNotes =  GetLocalInt(oInstrument, "NOTES_RECORDED_TRACK" + sTrack);
	int iTempNote = iTotalNotes;
	int iLastNote, iFindLastNote;
	// for each number, cycle through all the notes and find the "last" one, then set it temporarily to that number
	iFindLastNote = iTotalNotes;
	while (iFindLastNote > 0)
	{
		sID = "NOTE" + IntToString(iFindLastNote);
		fDelayCompare = GetLocalFloat(oInstrument, sID + "PLAYBACK_TRACK" + sTrack);
		if (fDelayCompare >= fLongestDelay)
		{
			fLongestDelay = fDelayCompare;
			iLastNote = iFindLastNote;
		}
		iFindLastNote--;	
	}
	int iSlotForNewNote = GetLocalInt(oPC, "NOTES_SORTED");
	SetLocalInt(oPC, "NOTES_SORTED", iSlotForNewNote + 1);
	// start from the end, adding notes from last to first
	iSlotForNewNote = iTotalNotes - iSlotForNewNote;
	
	//SendMessageToPC(oPC, "Last note is # " + IntToString(iLastNote));
	sOldID = "NOTE" + IntToString(iLastNote);
	sNewID = "NOTE" + IntToString(iSlotForNewNote);
	//transfer the values from the "last note" to the end of the new temp sequence
	SetLocalInt(oInstrument, sNewID + "PITCH_TEMP", GetLocalInt(oInstrument, sOldID + "PITCH_TRACK" + sTrack));
	SetLocalFloat(oInstrument, sNewID + "PLAYBACK_TEMP", GetLocalFloat(oInstrument, sOldID + "PLAYBACK_TRACK" + sTrack));
	//set the "last note" to -10.0, so it will not be counted again.
	SetLocalFloat(oInstrument, sOldID + "PLAYBACK_TRACK" + sTrack, -10.0f);
}

void FinalizeNoteSorting(object oPC, object oInstrument, int iTrack)
{
	string sTrack = IntToString(iTrack);
	int iTempNote =  GetLocalInt(oInstrument, "NOTES_RECORDED_TRACK" + sTrack);
	string sID;
	while (iTempNote > 0)
	{
		sID = "NOTE" + IntToString(iTempNote);
		SetLocalInt(oInstrument, sID + "PITCH_TRACK" + sTrack, GetLocalInt(oInstrument, sID + "PITCH_TEMP"));
		SetLocalFloat(oInstrument, sID + "PLAYBACK_TRACK" + sTrack, GetLocalFloat(oInstrument, sID + "PLAYBACK_TEMP"));
		DeleteLocalInt(oInstrument, sID + "PITCH_TEMP");
		DeleteLocalFloat(oInstrument, sID + "PLAYBACK_TEMP");
		iTempNote--;
	}
	DeleteLocalInt(oPC, "NOTES_SORTED");
}

void SortNotes(object oPC, object oInstrument, int iTrack)
{
	string sTrack = IntToString(iTrack);
	int iTotalNotes =  GetLocalInt(oInstrument, "NOTES_RECORDED_TRACK" + sTrack);
	AssignCommand(oPC, SendMessageToPC(oPC, "Sorting track " + sTrack + "... Please wait..."));
	while (iTotalNotes > 0)
	{
		//SendMessageToPC(oPC, "Sorting note " + IntToString(iTotalNotes));
		AssignCommand(oPC, FindLastNote(oPC, oInstrument, iTrack));
		iTotalNotes--;
	}
	AssignCommand(oPC, FinalizeNoteSorting(oPC, oInstrument, iTrack));
	AssignCommand(oPC, SetSongLength(oInstrument));
	AssignCommand(oPC, SendMessageToPC(oPC, "Finished sorting track " + sTrack + "."));
}

string GetNoteName(int iPitch)
{
	string sInstrument;
	// is this a melody note?
	if (iPitch < 100 || (iPitch > 200 && iPitch < 300) || (iPitch > 323 && iPitch < 350) || (iPitch > 373 && iPitch < 400))
	{
		if (iPitch < 100)
		{
			sInstrument = "Lute Note: ";
			if (iPitch > 50)
				iPitch -= 50;
		}
		else if (iPitch > 200 && iPitch < 300)
		{
			sInstrument = "Flute Note: ";
			if (iPitch > 250)
				iPitch -= 50;
			iPitch -= 200;
		}
		else if ((iPitch > 323 && iPitch < 350) || (iPitch > 373 && iPitch < 400))
		{
			sInstrument = "Drum Note: ";
			if (iPitch > 373)
				iPitch -= 50;
			iPitch -= 323;
		}
		
		switch (iPitch)
		{
			case 1:	return sInstrument + "C1";
			case 2:	return sInstrument + "Db1";
			case 3:	return sInstrument + "D1";
			case 4:	return sInstrument + "Eb1";
			case 5:	return sInstrument + "E1";
			case 6:	return sInstrument + "F1";
			case 7:	return sInstrument + "Gb1";
			case 8:	return sInstrument + "G1";
			case 9:	return sInstrument + "Ab1";
			case 10:return sInstrument + "A1";
			case 11:return sInstrument + "Bb1";
			case 12:return sInstrument + "B1";
			case 13:return sInstrument + "C2";
			case 14:return sInstrument + "Db2";
			case 15:return sInstrument + "D2";
			case 16:return sInstrument + "Eb2";
			case 17:return sInstrument + "E2";
			case 18:return sInstrument + "F2";
			case 19:return sInstrument + "Gb2";
			case 20:return sInstrument + "G2";
			case 21:return sInstrument + "Ab2";
			case 22:return sInstrument + "A2";
			case 23:return sInstrument + "Bb2";
			case 24:return sInstrument + "B2";
			case 25:return sInstrument + "C3";
			case 26:return sInstrument + "Db3";
			case 27:return sInstrument + "D3";
			case 28:return sInstrument + "Eb3";
			case 29:return sInstrument + "E3";
			case 30:return sInstrument + "F3";
			case 31:return sInstrument + "Gb3";
			case 32:return sInstrument + "G3";
			case 33:return sInstrument + "Ab3";
			case 34:return sInstrument + "A3";
			case 35:return sInstrument + "Bb3";
			case 36:return sInstrument + "B3";
		}
	}
	
	// or is this a chord?
	else if (iPitch < 200)
	{
		sInstrument = "Lute Chord: ";
		if (iPitch > 150)
			iPitch -= 50;
		switch (iPitch)
		{
			case 101:return sInstrument + "C Major";
			case 102:return sInstrument + "Db Major";
			case 103:return sInstrument + "D Major";
			case 104:return sInstrument + "Eb Major";
			case 105:return sInstrument + "E Major";
			case 106:return sInstrument + "F Major";
			case 107:return sInstrument + "Gb Major";
			case 108:return sInstrument + "G Major";
			case 109:return sInstrument + "Ab Major";
			case 110:return sInstrument + "A Major";
			case 111:return sInstrument + "Bb Major";
			case 112:return sInstrument + "B Major";
			case 113:return sInstrument + "C minor";
			case 114:return sInstrument + "Db minor";
			case 115:return sInstrument + "D minor";
			case 116:return sInstrument + "Eb minor";
			case 117:return sInstrument + "E minor";
			case 118:return sInstrument + "F minor";
			case 119:return sInstrument + "Gb minor";
			case 120:return sInstrument + "G minor";
			case 121:return sInstrument + "Ab minor";
			case 122:return sInstrument + "A minor";
			case 123:return sInstrument + "Bb minor";
			case 124:return sInstrument + "B minor";
			case 125:return sInstrument + "C half-diminished";
			case 126:return sInstrument + "Db half-diminished";
			case 127:return sInstrument + "D half-diminished";
			case 128:return sInstrument + "Eb half-diminished";
			case 129:return sInstrument + "E half-diminished";
			case 130:return sInstrument + "F half-diminished";
			case 131:return sInstrument + "Gb half-diminished";
			case 132:return sInstrument + "G half-diminished";
			case 133:return sInstrument + "Ab half-diminished";
			case 134:return sInstrument + "A half-diminished";
			case 135:return sInstrument + "Bb half-diminished";
			case 136:return sInstrument + "B half-diminished";	
		}
	}
	// or is this a percussion sound?
	else
	{
		sInstrument = "Percussion Hit: ";
		if (iPitch > 350)
			iPitch -= 50;
		switch (iPitch)
		{
			case 301: return sInstrument + "Cow Bell (a1)";
			case 302: return sInstrument + "Taiko (b1)";
			case 303: return sInstrument + "Triangle (c1)";
			case 304: return sInstrument + "Guiro (d1)";
			case 305: return sInstrument + "Frame Drum (e1)";
			case 306: return sInstrument + "Open Snare (f1)";
			case 307: return sInstrument + "Closed Snare (g1)";
			case 308: return sInstrument + "Tabla (h1)";
			case 309: return sInstrument + "Tambourine (i1)";
			case 310: return sInstrument + "Anvil (j1)";
			case 311: return sInstrument + "Cow Bell (a2)";
			case 312: return sInstrument + "Taiko (b2)";
			case 313: return sInstrument + "Triangle (c2)";
			case 314: return sInstrument + "Guiro (d2)";
			case 315: return sInstrument + "Frame Drum (e2)";
			case 316: return sInstrument + "Open Snare (f2)";
			case 317: return sInstrument + "Closed Snare (g2)";
			case 318: return sInstrument + "Tabla (h2)";
			case 319: return sInstrument + "Tambourine (i2)";
			case 320: return sInstrument + "Anvil (j2)";
		}
	}
	return "Unrecognized Pitch";
}

void RefreshCopyPane(object oPC, object oInstrument)
{
	int bBeats = GetLocalInt(oInstrument, "COPY_MODE_BEATS");
	if (bBeats)
	{
		int iCopyFrom = GetLocalInt(oInstrument, "COPY_FROM_BEATS");
		int iPasteTo = GetLocalInt(oInstrument, "PASTE_TO_BEATS");
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "CopyFromField", -1, IntToString(iCopyFrom));
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "PasteToField", -1, IntToString(iPasteTo));
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "CopyMode", -1, "(beats)");
	}
	else
	{
		float fCopyFrom = GetLocalFloat(oInstrument, "COPY_FROM");
		float fPasteTo = GetLocalFloat(oInstrument, "PASTE_TO");
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "CopyFromField", -1, FloatToString(fCopyFrom, 3, 1));
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "PasteToField", -1, FloatToString(fPasteTo, 3, 1));
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "CopyMode", -1, "(seconds)");
	}
}

void ResetExpiringVariables(object oPC, object oInstrument)
{
	DeleteLocalFloat(oInstrument, "COPY_FROM");
	DeleteLocalFloat(oInstrument, "PASTE_TO");
	DeleteLocalInt(oInstrument, "COPY_TO_TRACK");
	DeleteLocalInt(oInstrument, "DELETE_SOURCE");
	DeleteLocalInt(oInstrument, "EDIT_PITCH");
	DeleteLocalFloat(oInstrument, "EDIT_TIME");
	DeleteLocalInt(oInstrument, "CURRENT_NOTE_TRACK1");
	DeleteLocalInt(oInstrument, "CURRENT_NOTE_TRACK2");
	DeleteLocalInt(oInstrument, "CURRENT_NOTE_TRACK3");
	DeleteLocalInt(oInstrument, "CURRENT_NOTE_TRACK4");
	DeleteLocalInt(oInstrument, "METRONOME_ON");
	DeleteLocalInt(oInstrument, "LAG_CHECK_ON");
}

void RefreshNotePane(object oPC, object oInstrument)
{
	int iTrack = GetLocalInt(oPC, "TKL_PERFORMER_OPTION");
	string sTrack = IntToString(iTrack);
	int iNote = GetLocalInt(oInstrument, "CURRENT_NOTE_TRACK" + sTrack);
	if (iNote == 0)
	{
		iNote = 1;
		SetLocalInt(oInstrument, "CURRENT_NOTE_TRACK" + sTrack, iNote);
	}
	int iMaxNotes = GetLocalInt(oInstrument, "NOTES_RECORDED_TRACK" + sTrack);
	if (iNote > iMaxNotes)
		iNote = iMaxNotes;
	string sNote = IntToString(iNote);
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "CurrentNote", -1, "NOTE #" + sNote);
	int iPitch = GetLocalInt(oInstrument, "NOTE" + sNote + "PITCH_TRACK" + sTrack);
	int iKey = GetLocalInt(oInstrument, "KEY");
	
	// Check for "diatonic" mode or "beat" mode
	int bChromatic = GetLocalInt(oInstrument, "NOTE_EDIT_CHROMATIC");
	int bBeats = GetLocalInt(oInstrument, "NOTE_EDIT_BEATS");
	string sEditPitch = IntToString(GetLocalInt(oInstrument, "EDIT_PITCH"));
	string sEditTime;
	if (bBeats == FALSE)
		sEditTime = FloatToString(GetLocalFloat(oInstrument, "EDIT_TIME"), 3, 1);
	else
		sEditTime = IntToString(GetLocalInt(oInstrument, "EDIT_BEATS"));
		
	if (bChromatic)
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "NotePitchMode", -1, "(half steps)");
	else
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "NotePitchMode", -1, "(scale tones)");
	if (bBeats)
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "NoteTimeMode", -1, "(beats)");
	else
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "NoteTimeMode", -1, "(seconds)");	
	
	// transpose chords
	if (iPitch > 100 && iPitch < 200)
		iPitch = TransposeChord(iPitch, iKey);
	// don't transpose percussion
	else if ((iPitch > 300 && iPitch < 321) || (iPitch > 350 && iPitch < 371))
		iKey = 0;
	// transpose everything else
	else
		iPitch = iPitch + iKey;
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "NoteName", -1, GetNoteName(iPitch));
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "NoteTrackName", -1, "Track " + sTrack);
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "NotePitchField", -1, sEditPitch);
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "NoteTimeField", -1, sEditTime);
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "NoteTotalNotes", -1, "(" + IntToString(iMaxNotes) + " Notes)");
	float fTime = GetLocalFloat(oInstrument, "NOTE" + sNote + "PLAYBACK_TRACK" + sTrack);
	SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "NoteTime", -1, "Time: " + FloatToString(fTime, 4, 2));
	
	// hide/reveal the primary variation pane, and set the primary variation button and text
	if (iPitch == 0)
		SetGUIObjectHidden(oPC, TKL_PERFORMER_SCREEN, "NotePrimaryPane", TRUE);
	else
		SetGUIObjectHidden(oPC, TKL_PERFORMER_SCREEN, "NotePrimaryPane", FALSE
		);
	// for lute notes and flute notes...
	if ((iPitch >= 1 && iPitch <= 99) || (iPitch >= 201 && iPitch <= 299))
	{
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "NotePrimaryType", -1, "SUSTAIN");
		if ((iPitch >= 1 && iPitch <= 49) || (iPitch >= 201 && iPitch <= 249))
			SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "NotePrimaryValue", -1, "Normal");
		else
			SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "NotePrimaryValue", -1, "Short");
	}
	// for lute chords...
	if (iPitch >= 101 && iPitch <= 199)
	{
		SetGUIObjectHidden(oPC, TKL_PERFORMER_SCREEN, "EmbellishChord", FALSE);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "NotePrimaryType", -1, "ATTACK");
		if (iPitch >= 101 && iPitch <= 149)
			SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "NotePrimaryValue", -1, "Rolled");
		else
			SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "NotePrimaryValue", -1, "Normal");
	}
	else
		SetGUIObjectHidden(oPC, TKL_PERFORMER_SCREEN, "EmbellishChord", TRUE);
		
	// for percussion hits
	if (iPitch >= 301 && iPitch <= 399)
	{
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "NotePrimaryType", -1, "VOLUME");
		if (iPitch >= 301 && iPitch <= 349)
			SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "NotePrimaryValue", -1, "Normal");
		else
			SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "NotePrimaryValue", -1, "Loud");	
	}
	
	// set the secondary button and text, if necessary
	
	// for lute chords...
	if (iPitch >= 101 && iPitch <= 199)
	{
		SetGUIObjectHidden(oPC, TKL_PERFORMER_SCREEN, "NoteSecondaryPane", FALSE);
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "NoteSecondaryType", -1, "QUALITY");
		if ((iPitch >= 101 && iPitch <= 112) || (iPitch >= 151 && iPitch <= 162))
			SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "NoteSecondaryValue", -1, "Major");
		else if ((iPitch >= 113 && iPitch <= 124) || (iPitch >= 163 && iPitch <= 174))
			SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "NoteSecondaryValue", -1, "Minor");
		else
			SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "NoteSecondaryValue", -1, "Half-Dim.");
	}
	// for percussion variations...
	else if (iPitch >= 301 && iPitch <= 399)
	{
		SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "NoteSecondaryType", -1, "VARIATION");
		if ((iPitch >= 301 && iPitch <= 310) || (iPitch >= 351 && iPitch <= 360))
		{
			SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "NoteSecondaryValue", -1, "1");
			SetGUIObjectHidden(oPC, TKL_PERFORMER_SCREEN, "NoteSecondaryPane", FALSE);
		}
		else if ((iPitch >= 311 && iPitch <= 320) || (iPitch >= 361 && iPitch <= 370))
		{
			SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "NoteSecondaryValue", -1, "2");
			SetGUIObjectHidden(oPC, TKL_PERFORMER_SCREEN, "NoteSecondaryPane", FALSE);
		}
		else
			SetGUIObjectHidden(oPC, TKL_PERFORMER_SCREEN, "NoteSecondaryPane", TRUE);
	}
	else
		SetGUIObjectHidden(oPC, TKL_PERFORMER_SCREEN, "NoteSecondaryPane", TRUE);
		
}

void DeleteNote(object oInstrument, int iTrack, int iNote)
{
	//SendMessageToPC(GetFirstPC(), "Deleting note " + IntToString(iNote));
	string sTrack = IntToString(iTrack);
	string sID = "NOTE" + IntToString(iNote);
	int iTotalNotes = GetLocalInt(oInstrument, "NOTES_RECORDED_TRACK" + sTrack);
	DeleteLocalInt(oInstrument, sID + "PITCH_TRACK" + sTrack);
	DeleteLocalFloat(oInstrument, sID + "PLAYBACK_TRACK" + sTrack);
	iNote++;
	// move all the proceeding notes up by one.
	string sOldNoteID;
	string sNewNoteID;
	int iOldPitch;
	while (iNote <= iTotalNotes)
	{
		sOldNoteID = "NOTE" + IntToString(iNote);
		iOldPitch = GetLocalInt(oInstrument, sOldNoteID + "PITCH_TRACK" + sTrack);
		if (iOldPitch != 0)
		{
			//SendMessageToPC(GetFirstPC(), "Delete: Moving " + sOldNoteID); 
			sNewNoteID = "NOTE" + IntToString(iNote - 1);
			SetLocalInt(oInstrument, sNewNoteID + "PITCH_TRACK" + sTrack, iOldPitch);
			SetLocalFloat(oInstrument, sNewNoteID + "PLAYBACK_TRACK" + sTrack,
				GetLocalFloat(oInstrument, sOldNoteID + "PLAYBACK_TRACK" + sTrack));
		}
		iNote++;
	}
	// finally delete the one remaining note
	DeleteLocalInt(oInstrument, "NOTE" + IntToString(iNote) + "PITCH_TRACK" + sTrack);
	DeleteLocalFloat(oInstrument, "NOTE" + IntToString(iNote) + "PLAYBACK_TRACK" + sTrack);
	SetLocalInt(oInstrument, "NOTES_RECORDED_TRACK" + sTrack, iTotalNotes - 1);
}

int GetMaximumSpeed(object oPC)
{
	int iMaxSpeed = 99;
	if (TKL_PERFORM_AFFECTS_SPEED)
	{
		iMaxSpeed = GetPerform(oPC) * TKL_SPEED_PER_PERFORM_POINT;
		if (iMaxSpeed > 99)
			iMaxSpeed = 99;
	}
	return iMaxSpeed;
}

int GetPercussionPitch(string sChar2, int iRow)
{
	string sLower = GetStringLowerCase(sChar2);
	int iPitch;
	if (sLower == "a")
		iPitch = 1;
	else if (sLower == "b")
		iPitch = 2;
	else if (sLower == "c")
		iPitch = 3;
	else if (sLower == "d")
		iPitch = 4;
	else if (sLower == "e")
		iPitch = 5;
	else if (sLower == "f")
		iPitch = 6;
	else if (sLower == "g")
		iPitch = 7;
	else if (sLower == "h")
		iPitch = 8;
	else if (sLower == "i")
		iPitch = 9;
	else if (sLower == "j")
		iPitch = 10;
	else
		return -1;
	// add 10 for 2nd row
	if (iRow == 1)
		iPitch += 10;
	// add 50 for uppercase (ie, accent)
	if (sChar2 == GetStringUpperCase(sChar2))
		iPitch += 50;
	// add the Percussion offset
	iPitch += 300;
	return iPitch;
}

int GetChordPitch(string sChar, string sChar2, string sQuality)
{
	int iPitch = 0;
	string sLower = GetStringLowerCase(sChar);
	if (sChar2 == "#")
		iPitch++;
	else if (sChar2 == "b")
		iPitch--;
	
	if (sLower == "c")
		iPitch += 1;
	else if (sLower == "d")
		iPitch += 3;
	else if (sLower == "e")
		iPitch += 5;
	else if (sLower == "f")
		iPitch += 6;
	else if (sLower == "g")
		iPitch += 8;
	else if (sLower == "a")
		iPitch += 10;
	else if (sLower == "b")
		iPitch += 12;
	else
		return -1;
	
	// don't allow B#'s
	if (iPitch > 12)
		iPitch = 12;
	// check for minor
	if (sQuality == "m")
	{
		iPitch += 12;
	}
	// check for half-diminished
	else if (sQuality == "*")
	{
		iPitch += 24;
	}
		
	// check for rolled chords
	if (sChar == GetStringUpperCase(sChar))
		iPitch += 50;
	// add the instrument offset for chords
	iPitch += 100;
	
	return iPitch;	
}

int GetMelodyPitch(string sChar, string sChar2, int iRow, int bDrums, int iInstrumentOffset)
{
	int iPitch = 0;
	string sLower = GetStringLowerCase(sChar);
	if (sChar2 == "#")
		iPitch++;
	else if (sChar2 == "b")
		iPitch--;
	
	if (sLower == "c")
		iPitch += 1;
	else if (sLower == "d")
		iPitch += 3;
	else if (sLower == "e")
		iPitch += 5;
	else if (sLower == "f")
		iPitch += 6;
	else if (sLower == "g")
		iPitch += 8;
	else if (sLower == "a")
		iPitch += 10;
	else if (sLower == "b")
		iPitch += 12;
	else
		return -1;
	
	// don't allow B#'s
	if (iPitch > 12)
		iPitch = 12;
	// check for second octave
	if (iRow == 2)
		iPitch += 12;
	// check for third octave, for high C's
	if (iRow == 3)
		iPitch += 24;
	// check for short note
	if (bDrums == TRUE && sChar == GetStringUpperCase(sChar))
		iPitch += 50;
	if (bDrums == FALSE && sChar == GetStringLowerCase(sChar))
		iPitch += 50;
	// add the instrument offset
	iPitch += iInstrumentOffset;
	
	return iPitch;	
}

void SetupImprovPane(object oPC, object oInstrument)
{
	int i, iSelected;
	string s;
	// for each track..
	for (i = 1; i <= 4; i++)
	{
		s = IntToString(i);
		// Clear all instrument buttons
		SetGUITexture(oPC, TKL_PERFORMER_SCREEN, "ImprovTrack" + s + "None", "b_sm_normal.tga");
		SetGUITexture(oPC, TKL_PERFORMER_SCREEN, "ImprovTrack" + s + "Drums", "b_sm_normal.tga");
		SetGUITexture(oPC, TKL_PERFORMER_SCREEN, "ImprovTrack" + s + "Chords", "b_sm_normal.tga");
		SetGUITexture(oPC, TKL_PERFORMER_SCREEN, "ImprovTrack" + s + "Lute", "b_sm_normal.tga");
		SetGUITexture(oPC, TKL_PERFORMER_SCREEN, "ImprovTrack" + s + "Flute", "b_sm_normal.tga");
		// Highlight the currently selected button
		iSelected = GetLocalInt(oInstrument, "IMPROV_INSTRUMENT_TRACK_" + s);
		switch (iSelected)
		{
			case 0: SetGUITexture(oPC, TKL_PERFORMER_SCREEN, "ImprovTrack" + s + "None", "b_sm_hover.tga"); break;
			case 1: SetGUITexture(oPC, TKL_PERFORMER_SCREEN, "ImprovTrack" + s + "Drums", "b_sm_hover.tga"); break;
			case 2: SetGUITexture(oPC, TKL_PERFORMER_SCREEN, "ImprovTrack" + s + "Chords", "b_sm_hover.tga"); break;
			case 3: SetGUITexture(oPC, TKL_PERFORMER_SCREEN, "ImprovTrack" + s + "Lute", "b_sm_hover.tga"); break;
			case 4: SetGUITexture(oPC, TKL_PERFORMER_SCREEN, "ImprovTrack" + s + "Flute", "b_sm_hover.tga"); break;	
		}
	}
	// for each style...
	iSelected = GetLocalInt(oInstrument, "IMPROV_STYLE");
	if (iSelected == 0) iSelected = 1;
	for (i = 1; i <= 10; i++)
	{
		s = IntToString(i);
		// highlight the selected styel
		if (i == iSelected)
			SetGUITexture(oPC, TKL_PERFORMER_SCREEN, "ImprovStyle" + s, "b_sm_hover.tga");
		// unhighlight all the other ones
		else
			SetGUITexture(oPC, TKL_PERFORMER_SCREEN, "ImprovStyle" + s, "b_sm_normal.tga");
		// set the text on the buttons
		switch (i)
		{
			case 1: SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "ImprovStyle1", -1, STYLE_1_NAME); break;
			case 2: SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "ImprovStyle2", -1, STYLE_2_NAME); break;
			case 3: SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "ImprovStyle3", -1, STYLE_3_NAME); break;
			case 4: SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "ImprovStyle4", -1, STYLE_4_NAME); break;
			case 5: SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "ImprovStyle5", -1, STYLE_5_NAME); break;
			case 6: SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "ImprovStyle6", -1, STYLE_6_NAME); break;
			case 7: SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "ImprovStyle7", -1, STYLE_7_NAME); break;
			case 8: SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "ImprovStyle8", -1, STYLE_8_NAME); break;
			case 9: SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "ImprovStyle9", -1, STYLE_9_NAME); break;
			case 10: SetGUIObjectText(oPC, TKL_PERFORMER_SCREEN, "ImprovStyle10", -1, STYLE_10_NAME); break;
		}
	}
	
	// Finally set the description for the selected style
	string sDesc;
	switch (iSelected)
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

// This parses a string of slash-separated variables (sUnparsed), and sets them as numbered local strings (sVariable1, sVariable2, etc.) on the Object.
// It returns the total number of variables parsed.
int ParseImprovVariables(object oObject, string sUnparsed, string sVariable)
{
	int iTotal = 0;
	string sParsed;
	int iSlash = FindSubString(sUnparsed, "/");
	while (iSlash != -1)
	{
		iTotal++;
		sParsed = GetStringLeft(sUnparsed, iSlash);
		SetLocalString(oObject, sVariable + IntToString(iTotal), sParsed);
		sUnparsed = GetStringRight(sUnparsed, GetStringLength(sUnparsed) - GetStringLength(sParsed) - 1);
		iSlash = FindSubString(sUnparsed, "/");
	}
	return iTotal;
}

// This sets up the variables necessary for improvisation, based on certain pre-determined styles.
void SetImprovStyle(object oPC, int iStyle)
{
	string sMelodicRhythms, sPercussiveRhythms, sChords, sStrumPatterns, sNotes, sAltNotes, sStyleName;
	int iBeatsPerMinute;
	switch(iStyle)
	{
		// This is a generic 3-count style, with the chord progression from "Greensleeves".
		case 1:
			sStyleName =			STYLE_1_NAME;
			iBeatsPerMinute =		STYLE_1_BEATS_PER_MINUTE;
			sMelodicRhythms = 		STYLE_1_MELODIC_RHYTHMS;
			sPercussiveRhythms = 	STYLE_1_PERCUSSIVE_RHYTHMS;	
			sChords = 				STYLE_1_CHORDS;
			sStrumPatterns = 		STYLE_1_STRUM_PATTERNS;
			sNotes = 				STYLE_1_NOTES;
			sAltNotes =				STYLE_1_ALT_NOTES;
			break;
		case 2:
			sStyleName =			STYLE_2_NAME;
			iBeatsPerMinute =		STYLE_2_BEATS_PER_MINUTE;
			sMelodicRhythms = 		STYLE_2_MELODIC_RHYTHMS;
			sPercussiveRhythms = 	STYLE_2_PERCUSSIVE_RHYTHMS;	
			sChords = 				STYLE_2_CHORDS;
			sStrumPatterns = 		STYLE_2_STRUM_PATTERNS;
			sNotes = 				STYLE_2_NOTES;
			sAltNotes =				STYLE_2_ALT_NOTES;
			break;
		case 3:
			sStyleName =			STYLE_3_NAME;
			iBeatsPerMinute =		STYLE_3_BEATS_PER_MINUTE;
			sMelodicRhythms = 		STYLE_3_MELODIC_RHYTHMS;
			sPercussiveRhythms = 	STYLE_3_PERCUSSIVE_RHYTHMS;	
			sChords = 				STYLE_3_CHORDS;
			sStrumPatterns = 		STYLE_3_STRUM_PATTERNS;
			sNotes = 				STYLE_3_NOTES;
			sAltNotes =				STYLE_3_ALT_NOTES;
			break;
		case 4:
			sStyleName =			STYLE_4_NAME;
			iBeatsPerMinute =		STYLE_4_BEATS_PER_MINUTE;
			sMelodicRhythms = 		STYLE_4_MELODIC_RHYTHMS;
			sPercussiveRhythms = 	STYLE_4_PERCUSSIVE_RHYTHMS;	
			sChords = 				STYLE_4_CHORDS;
			sStrumPatterns = 		STYLE_4_STRUM_PATTERNS;
			sNotes = 				STYLE_4_NOTES;
			sAltNotes =				STYLE_4_ALT_NOTES;
			break;
		case 5:
			sStyleName =			STYLE_5_NAME;
			iBeatsPerMinute =		STYLE_5_BEATS_PER_MINUTE;
			sMelodicRhythms = 		STYLE_5_MELODIC_RHYTHMS;
			sPercussiveRhythms = 	STYLE_5_PERCUSSIVE_RHYTHMS;	
			sChords = 				STYLE_5_CHORDS;
			sStrumPatterns = 		STYLE_5_STRUM_PATTERNS;
			sNotes = 				STYLE_5_NOTES;
			sAltNotes =				STYLE_5_ALT_NOTES;
			break;
		case 6:
			sStyleName =			STYLE_6_NAME;
			iBeatsPerMinute =		STYLE_6_BEATS_PER_MINUTE;
			sMelodicRhythms = 		STYLE_6_MELODIC_RHYTHMS;
			sPercussiveRhythms = 	STYLE_6_PERCUSSIVE_RHYTHMS;	
			sChords = 				STYLE_6_CHORDS;
			sStrumPatterns = 		STYLE_6_STRUM_PATTERNS;
			sNotes = 				STYLE_6_NOTES;
			sAltNotes =				STYLE_6_ALT_NOTES;
			break;
		case 7:
			sStyleName =			STYLE_7_NAME;
			iBeatsPerMinute =		STYLE_7_BEATS_PER_MINUTE;
			sMelodicRhythms = 		STYLE_7_MELODIC_RHYTHMS;
			sPercussiveRhythms = 	STYLE_7_PERCUSSIVE_RHYTHMS;	
			sChords = 				STYLE_7_CHORDS;
			sStrumPatterns = 		STYLE_7_STRUM_PATTERNS;
			sNotes = 				STYLE_7_NOTES;
			sAltNotes =				STYLE_7_ALT_NOTES;
			break;
		case 8:
			sStyleName =			STYLE_8_NAME;
			iBeatsPerMinute =		STYLE_8_BEATS_PER_MINUTE;
			sMelodicRhythms = 		STYLE_8_MELODIC_RHYTHMS;
			sPercussiveRhythms = 	STYLE_8_PERCUSSIVE_RHYTHMS;	
			sChords = 				STYLE_8_CHORDS;
			sStrumPatterns = 		STYLE_8_STRUM_PATTERNS;
			sNotes = 				STYLE_8_NOTES;
			sAltNotes =				STYLE_8_ALT_NOTES;
			break;
		case 9:
			sStyleName =			STYLE_9_NAME;
			iBeatsPerMinute =		STYLE_9_BEATS_PER_MINUTE;
			sMelodicRhythms = 		STYLE_9_MELODIC_RHYTHMS;
			sPercussiveRhythms = 	STYLE_9_PERCUSSIVE_RHYTHMS;	
			sChords = 				STYLE_9_CHORDS;
			sStrumPatterns = 		STYLE_9_STRUM_PATTERNS;
			sNotes = 				STYLE_9_NOTES;
			sAltNotes =				STYLE_9_ALT_NOTES;
			break;
		case 10:
			sStyleName =			STYLE_10_NAME;
			iBeatsPerMinute =		STYLE_10_BEATS_PER_MINUTE;
			sMelodicRhythms = 		STYLE_10_MELODIC_RHYTHMS;
			sPercussiveRhythms = 	STYLE_10_PERCUSSIVE_RHYTHMS;	
			sChords = 				STYLE_10_CHORDS;
			sStrumPatterns = 		STYLE_10_STRUM_PATTERNS;
			sNotes = 				STYLE_10_NOTES;
			sAltNotes =				STYLE_10_ALT_NOTES;
			break;
	}

	// Parse and store the melodic rhythm variables
	int iTotalMelodicRhythms = ParseImprovVariables(oPC, sMelodicRhythms, "MELODIC_RHYTHM");
	if (iTotalMelodicRhythms < 1)
	{
		SendMessageToPC(oPC, "Error with style " + sStyleName + ", style has no melodic rhythms defined.");
		ClearImprovStyle(oPC);
		return;
	}
	SetLocalInt(oPC, "TOTAL_MELODIC_RHYTHMS", iTotalMelodicRhythms);
	int iMelodicRhythmBeats = GetStringLength(GetLocalString(oPC, "MELODIC_RHYTHM1"));

	// Parse and store the percussive rhythm variables
	int iTotalPercussiveRhythms = ParseImprovVariables(oPC, sPercussiveRhythms, "PERCUSSIVE_RHYTHM");
	if (iTotalPercussiveRhythms < 1)
	{
		SendMessageToPC(oPC, "Error with style " + sStyleName + ", style has no percussive rhythms defined.");
		ClearImprovStyle(oPC);
		return;
	}
	SetLocalInt(oPC, "TOTAL_PERCUSSIVE_RHYTHMS", iTotalPercussiveRhythms);
	int iPercussiveRhythmBeats = GetStringLength(GetLocalString(oPC, "PERCUSSIVE_RHYTHM1"));

	// Parse and store the chord variables
	int iTotalChords = ParseImprovVariables(oPC, sChords, "CHORD");
	if (iTotalChords < 1)
	{
		SendMessageToPC(oPC, "Error with style " + sStyleName + ", style has no chords defined.");
		ClearImprovStyle(oPC);
		return;
	}
	SetLocalInt(oPC, "TOTAL_CHORDS", iTotalChords);
	
	// Parse and store the strum variables
	int iTotalStrumPatterns = ParseImprovVariables(oPC, sStrumPatterns, "STRUM_PATTERN");
	if (iTotalStrumPatterns < 1)
	{
		SendMessageToPC(oPC, "Error with style " + sStyleName + ", style has no strum patterns defined.");
		ClearImprovStyle(oPC);
		return;
	}
	SetLocalInt(oPC, "TOTAL_STRUM_PATTERNS", iTotalStrumPatterns);
	int iStrumPatternBeats = GetStringLength(GetLocalString(oPC, "STRUM_PATTERN1"));

	// Parse and store the note variables
	int iTotalNotes = ParseImprovVariables(oPC, sNotes, "NOTE");
	if (iTotalNotes < 1)
	{
		SendMessageToPC(oPC, "Error with style " + sStyleName + ", style has no notes defined.");
		ClearImprovStyle(oPC);
		return;
	}
	SetLocalInt(oPC, "TOTAL_NOTES", iTotalNotes);

	// Finally, parse and store the alternate note variables
	int iTotalAltNotes = ParseImprovVariables(oPC, sAltNotes, "ALT_NOTE");
	if (iTotalAltNotes > 0)
		SetLocalInt(oPC, "TOTAL_ALT_NOTES", iTotalAltNotes);
	
	// Final check: make sure the number of beats is the same for all three: melodic, percussive, and strums
	if (iMelodicRhythmBeats != iPercussiveRhythmBeats ||
		iPercussiveRhythmBeats != iStrumPatternBeats ||
		iMelodicRhythmBeats != iStrumPatternBeats)
	{
		SendMessageToPC(oPC, "Error with style " + sStyleName + ", the Melodic Rhythm, Percussive Rhythm, and Strum Patterns ALL need to have the same number of beats.");
		ClearImprovStyle(oPC);
		return;
	}
	SetLocalInt(oPC, "BEATS_PER_MEASURE", iMelodicRhythmBeats);	
	SetLocalInt(oPC, "BEATS_PER_MINUTE", iBeatsPerMinute);
	
	SetLocalString(oPC, "STYLE_NAME", sStyleName);

	return;
}

void ClearImprovVariables(object oObject, string sVariable)
{
	int i;
	for (i = 1; i <= GetLocalInt(oObject, "TOTAL_" + sVariable + "S"); i++)
	{
		DeleteLocalString(oObject, sVariable + IntToString(i));
	}
	DeleteLocalInt(oObject, "TOTAL_" + sVariable + "S");
}

// To be used afterwards, to clean up all variables
void ClearImprovStyle(object oPC)
{
	ClearImprovVariables(oPC, "MELODIC_RHYTHM");
	ClearImprovVariables(oPC, "PERCUSSIVE_RHYTHM");
	ClearImprovVariables(oPC, "CHORD");
	ClearImprovVariables(oPC, "STRUM_PATTERN");
	ClearImprovVariables(oPC, "NOTE");
	ClearImprovVariables(oPC, "ALT_NOTE");
	DeleteLocalInt(oPC, "BEATS_PER_MEASURE");
	DeleteLocalInt(oPC, "BEATS_PER_MINUTE");
	DeleteLocalString(oPC, "STYLE_NAME");	
}

// This turn a string of text into a pitch number for a chord ("block" style)
int ParseChord(string sChord)
{
	int iChar;
	string sChar;
	string sChordLetter = "";
	string sChordAccidental = "";
	string sChordQuality = "";
	
	// Cycle through each character in the chord, to get the parts
	for (iChar = 0; iChar < GetStringLength(sChord); iChar++)
	{
		sChar = GetSubString(sChord, iChar, 1);
		if (FindSubString("ABCDEFG", sChar) != -1)
			sChordLetter = sChar;
		else if (FindSubString("#b", sChar) != -1)
			sChordAccidental = sChar;
		else if (FindSubString("Mm", sChar) != -1)
			sChordQuality = sChar;					
	}
	return GetChordPitch(sChordLetter, sChordAccidental, sChordQuality);
}

// This turn a string of text into a pitch number for a note (1-36)
int ParseNote(string sNote)
{
	int iChar;
	string sChar;
	string sNoteLetter = "";
	string sNoteAccidental = "";
	int iNoteOctave = 1;
	
	// Cycle through each character in the chord, to get the parts
	for (iChar = 0; iChar < GetStringLength(sNote); iChar++)
	{
		sChar = GetSubString(sNote, iChar, 1);
		if (FindSubString("ABCDEFG", sChar) != -1)
			sNoteLetter = sChar;
		else if (FindSubString("#b", sChar) != -1)
			sNoteAccidental = sChar;
		else if (FindSubString("123", sChar) != -1)
			iNoteOctave = StringToInt(sChar);					
	}
	return GetMelodyPitch(sNoteLetter, sNoteAccidental, iNoteOctave, FALSE, 0);
}

void Improvise(object oPC)
{
	// Gather the improv-related variables
	int iTotalMelodicRhythms = GetLocalInt(oPC, "TOTAL_MELODIC_RHYTHMS");
	int iTotalPercussiveRhythms = GetLocalInt(oPC, "TOTAL_PERCUSSIVE_RHYTHMS");
	int iTotalChords = GetLocalInt(oPC, "TOTAL_CHORDS");
	int iTotalStrumPatterns = GetLocalInt(oPC, "TOTAL_STRUM_PATTERNS");
	int iBeatsPerMeasure = GetLocalInt(oPC, "BEATS_PER_MEASURE");
	int iBeatsPerMinute = GetLocalInt(oPC, "BEATS_PER_MINUTE");
	
	object oInstrument = GetLocalObject(oPC, "TKL_PERFORMER_INSTRUMENT");
	
	// First set up the name of the song
	SetLocalString(oInstrument, "SONG_NAME", GetLocalString(oPC, "STYLE_NAME"));
	
	// Set up the length of 1 beat
	float fBeat = 60.0f / IntToFloat(iBeatsPerMinute);
	float fCurrentBeat = 0.0f;
	
	// Cycle through all 4 tracks and create the improvisations
	int iMeasure, iTrack, iBeat, iNotePitch, iChordPitch, iNotesRecorded, iInstrument;
	string sTrack, sMeasure, sNoteType, sNotePitch, sChordPitch, sRhythm, sStrum;
	for (iTrack = 1; iTrack <= 4; iTrack++)
	{
		EraseTrack(oInstrument, iTrack, FALSE);
		sTrack = IntToString(iTrack);
		iNotesRecorded = 0;
		fCurrentBeat = 0.0f;
		iInstrument = GetLocalInt(oInstrument, "IMPROV_INSTRUMENT_TRACK_" + sTrack);
		switch (iInstrument)
		{
			case IMPROV_INSTRUMENT_DRUM:				
				AssignCommand(oPC, ImprovisePercussionMeasure(oPC, iTrack, 1, 0.0f, 0));
	
				// Set the track name
				SetLocalString(oInstrument, "TRACK_" + sTrack + "_NAME", "Drums");
				break;
			
			case IMPROV_INSTRUMENT_LUTE_CHORDS:			
				// Cycle through each measure of the song
				for (iMeasure = 1; iMeasure <= iTotalChords; iMeasure++)
				{					
					// Get the "block" pitch of this chord (we will subtract 50 to get the "rolled" pitch)
					sChordPitch = GetLocalString(oPC, "CHORD" + IntToString(iMeasure));
					iChordPitch = ParseChord(sChordPitch);
				
					// Pick a random strum pattern for this measure
					sMeasure = GetLocalString(oPC, "STRUM_PATTERN" + IntToString(Random(iTotalStrumPatterns) + 1));
					
					// Cycle through each beat in this strum pattern
					for (iBeat = 0; iBeat < iBeatsPerMeasure; iBeat++)
					{
						sStrum = GetSubString(sMeasure, iBeat, 1);
						
						// If the note is not a '-' (rest), go on to write the note
						if (sStrum != "-")
						{
							// If the pitch can be found, record it.
							if (iChordPitch != -1)
							{
								// But first check for a "rolled" chord
								if (sStrum == "2") iChordPitch -= 50;
								
								// NOW write the note
								iNotesRecorded++;
								SetLocalFloat(oInstrument, "NOTE" + IntToString(iNotesRecorded) + "PLAYBACK_TRACK" + sTrack, GetOffset(iChordPitch, fCurrentBeat));
								SetLocalInt(oInstrument, "NOTE" + IntToString(iNotesRecorded) + "PITCH_TRACK" + sTrack, iChordPitch);
							}
						}
						
						// Move on to the next beat
						fCurrentBeat += fBeat;
					}	
				}
				
				// Add an ending (rolled) chord
				iNotesRecorded++;
				iChordPitch = ParseChord(GetLocalString(oPC, "CHORD1")) - 50;
				SetLocalFloat(oInstrument, "NOTE" + IntToString(iNotesRecorded) + "PLAYBACK_TRACK" + sTrack, fCurrentBeat);
				SetLocalInt(oInstrument, "NOTE" + IntToString(iNotesRecorded) + "PITCH_TRACK" + sTrack, iChordPitch);
							
				// Set the total number of notes
				SetLocalInt(oInstrument, "NOTES_RECORDED_TRACK" + sTrack, iNotesRecorded);
				
				// Set the track name
				SetLocalString(oInstrument, "TRACK_" + sTrack + "_NAME", "Chords");
				
				break;
				
			case IMPROV_INSTRUMENT_LUTE_NOTES:
			case IMPROV_INSTRUMENT_FLUTE:
				// This is moved into a separate function and AssignCommanded to avoid TMI errors		
				AssignCommand(oPC, ImproviseMelodyMeasure(oPC, iTrack, 1, 0.0, 0, 0, FALSE, 0));
						
				// Set the track name
				if (iInstrument == IMPROV_INSTRUMENT_LUTE_NOTES)
					SetLocalString(oInstrument, "TRACK_" + sTrack + "_NAME", "Lute");
				else if (iInstrument == IMPROV_INSTRUMENT_FLUTE)
					SetLocalString(oInstrument, "TRACK_" + sTrack + "_NAME", "Flute");
				break;
					
			default:
				SetLocalString(oInstrument, "TRACK_" + sTrack + "_NAME", "Track " + IntToString(iTrack));
				break;			
		}
	}
	
	// Set a few variables necessary for the completed song
	SetLocalString(oInstrument, "ORIGINAL_COMPOSER", GetName(oPC));
	SetLocalInt(oInstrument, "METRONOME_RECORDED_TRACK1", iBeatsPerMinute);
	SetLocalInt(oInstrument, "METRONOME_RECORDED_TRACK2", iBeatsPerMinute);
	SetLocalInt(oInstrument, "METRONOME_RECORDED_TRACK3", iBeatsPerMinute);
	SetLocalInt(oInstrument, "METRONOME_RECORDED_TRACK4", iBeatsPerMinute);
	
	// Set the song length after a short delay, to give the melody tracks time to complete
	DelayCommand(3.0f, SetLocalFloat(oInstrument, "SONG_LENGTH", GetSongLength(oInstrument)));
	
	// Refresh the song and track names
	RefreshNames(oPC, oInstrument);	
}

// Moved this to a separate function so that it could be "AssignCommand"ed.
void ImprovisePercussionMeasure(object oPC, int iTrack, int iMeasure, float fCurrentBeat, int iNotesRecorded)
{
	int iTotalPercussiveRhythms = GetLocalInt(oPC, "TOTAL_PERCUSSIVE_RHYTHMS");
	int iBeatsPerMeasure = GetLocalInt(oPC, "BEATS_PER_MEASURE");
	int iBeatsPerMinute = GetLocalInt(oPC, "BEATS_PER_MINUTE");
	int iTotalChords = GetLocalInt(oPC, "TOTAL_CHORDS");
	
	// Pick a random rhythm for this measure
	string sRhythm = GetLocalString(oPC, "PERCUSSIVE_RHYTHM" + IntToString(Random(iTotalPercussiveRhythms) + 1));
	
	// Set up the length of 1 beat
	float fBeat = 60.0f / IntToFloat(iBeatsPerMinute);
	
	object oInstrument = GetLocalObject(oPC, "TKL_PERFORMER_INSTRUMENT");
	
	string sTrack = IntToString(iTrack);	
	string sNotePitch;
	int iBeat, iNotePitch;
	// Cycle through each beat in this rhythm
	for (iBeat = 0; iBeat < iBeatsPerMeasure; iBeat++)
	{
		sNotePitch = GetSubString(sRhythm, iBeat, 1);
		
		// If the note is not a '-' (rest), try to figure out the pitch
		if (sNotePitch != "-")
		{
			iNotePitch = GetPercussionPitch(sNotePitch, d2()); // choose a random "variation"
			
			// If the pitch can be found, record it.
			if (iNotePitch != -1)
			{
				iNotesRecorded++;
				SetLocalFloat(oInstrument, "NOTE" + IntToString(iNotesRecorded) + "PLAYBACK_TRACK" + sTrack, GetOffset(iNotePitch, fCurrentBeat));
				SetLocalInt(oInstrument, "NOTE" + IntToString(iNotesRecorded) + "PITCH_TRACK" + sTrack, iNotePitch);
			}
		}
		
		// Move on to the next beat
		fCurrentBeat += fBeat;
	}
		
	// Do another measure if necessary
	if (iMeasure < iTotalChords)
		ImprovisePercussionMeasure(oPC, iTrack, iMeasure + 1, fCurrentBeat, iNotesRecorded);
	else
	{
		// Add an ending note
		SetLocalInt(oInstrument, "NOTES_RECORDED_TRACK" + sTrack, iNotesRecorded);		
	}
		
}

// Moved this to a separate function so that it could be "AssignCommand"ed.
// Otherwise we run into TMI errors.  It returns the current beat
void ImproviseMelodyMeasure(object oPC, int iTrack, int iMeasure, float fCurrentBeat, int iLastNote, int iLastMovement, int bAscending, int iNotesRecorded)
{
	int iBeat, iNotePitch, iChordPitch, iInstrument, iTotalNotes, iNewNote;
	int bDownbeat = FALSE;
	string sTrack, sMeasure, sNoteType, sNotePitch, sChordPitch, sBreath;
	
	int iTotalMelodicRhythms = GetLocalInt(oPC, "TOTAL_MELODIC_RHYTHMS");
	int iTotalChords = GetLocalInt(oPC, "TOTAL_CHORDS");
	int iBeatsPerMeasure = GetLocalInt(oPC, "BEATS_PER_MEASURE");
	int iBeatsPerMinute = GetLocalInt(oPC, "BEATS_PER_MINUTE");
	
	object oInstrument = GetLocalObject(oPC, "TKL_PERFORMER_INSTRUMENT");
	
	// Set up the length of 1 beat
	float fBeat = 60.0f / IntToFloat(iBeatsPerMinute);
	
	sTrack = IntToString(iTrack);
	iInstrument = GetLocalInt(oInstrument, "IMPROV_INSTRUMENT_TRACK_" + sTrack);
				
	// First check to see whether to use the normal notes or "alt" notes
	sChordPitch = GetLocalString(oPC, "CHORD" + IntToString(iMeasure));
	iChordPitch = ParseChord(sChordPitch);
	if (GetStringLeft(sChordPitch, 1) == "?")
		sNoteType = "ALT_NOTE";
	else
		sNoteType = "NOTE";
	
	// Get the total number of notes to choose from
	iTotalNotes = GetLocalInt(oPC, "TOTAL_" + sNoteType + "S"); 
	
	// Pick a random melodic rhythm for this measure
	sMeasure = GetLocalString(oPC, "MELODIC_RHYTHM" + IntToString(Random(iTotalMelodicRhythms) + 1));
	
	// Cycle through each beat in this melodic rhythm
	for (iBeat = 0; iBeat < iBeatsPerMeasure; iBeat++)
	{
		//debug(oPC, "improvising melody measure " + IntToString(iMeasure) + " beat " + IntToString(iBeat));
		sBreath = GetSubString(sMeasure, iBeat, 1);
		
		// Track whether this is a downbeat or upbeat
		bDownbeat = !bDownbeat;
		
		// If the note is not a '-' (rest), go on to write the note
		if (sBreath != "-")
		{
			// If this is the first note of the song, pick a random note to start with
			if (iLastNote == 0) iLastNote = Random(iTotalNotes) + 1;

			// If the last movement was a leap, 75% chance of changing directions
			if (iLastMovement == IMPROV_MOVEMENT_LEAP)
				if (d4() > 4) bAscending = !bAscending;
				
			// If the last movement was a step, 25% chance of changing directions
			else if (iLastMovement == IMPROV_MOVEMENT_STEP)
				if (d4() == 4) bAscending = !bAscending;
			
			// If the last movement was repeat, 50% chance of changing directions
			else if (iLastMovement == IMPROV_MOVEMENT_REPEAT)
				if (d2() == 1) bAscending = !bAscending;	
			
			// Choose the next note: 50% step, 25% leap, 25% repeat
			switch (d4())
			{
				case 1:
				case 2:
					iLastMovement = IMPROV_MOVEMENT_STEP;
					if (bAscending) iNewNote = iLastNote + 1;
					else iNewNote = iLastNote - 1;
					break;
				case 3:
					iLastMovement = IMPROV_MOVEMENT_LEAP;
					if (bAscending) iNewNote = iLastNote + d6();
					else iNewNote = iLastNote - d6();
					break;
				case 4:
					iLastMovement = IMPROV_MOVEMENT_REPEAT;
					iNewNote = iLastNote;
					break;
			}
			
			// Special case: If the last note was a "leading tone", then always go up step-wise
			if (GetStringRight(GetLocalString(oPC, sNoteType + IntToString(iLastNote)), 1) == ">")
			{
				iLastMovement = IMPROV_MOVEMENT_STEP;
				bAscending = TRUE;
				iNewNote = iLastNote + 1;
			}
						
			// If we went too high or low, correct that and then change direction
			if (iNewNote > iTotalNotes)
			{
				iNewNote = iTotalNotes;
				bAscending = FALSE;
			}
			else if (iNewNote < 1)
			{
				iNewNote = 1;
				bAscending = TRUE;
			}
			
			iNotePitch = ParseNote(GetLocalString(oPC, sNoteType + IntToString(iNewNote)));
			
			// If this is a downbeat, keep going until we find a chord tone
			if (bDownbeat)
			{
				while (GetIsChordTone(iChordPitch, iNotePitch) == FALSE)
				{
					// If we're ascending, make sure we don't go too high
					if (bAscending)
					{
						iNewNote++;
						if (iNewNote > iTotalNotes) 
						{
							iNewNote -= 2;
							bAscending = FALSE;
						}
					}
					// If we're descending, make sure we don't go too low
					else
					{
						iNewNote--;
						if (iNewNote < 1)
						{
							iNewNote = 2;
							bAscending = TRUE;
						}	
					}
					iNotePitch = ParseNote(GetLocalString(oPC, sNoteType + IntToString(iNewNote)));	
				}
			}
						
			// Save the last note
			iLastNote = iNewNote;
			
			// If the pitch can be found, record it.
			if (iNotePitch != -1)
			{
				// But first check for a short note and add the instrument offset for flutes
				if (sBreath == "1") iNotePitch += 50;
				if (iInstrument == IMPROV_INSTRUMENT_FLUTE) iNotePitch += 200;
				string sDown;
				if (bDownbeat) sDown = "DOWN-BEAT: ";
				else sDown = "UP-BEAT: ";
				
				// NOW write the note
				iNotesRecorded++;
				SetLocalFloat(oInstrument, "NOTE" + IntToString(iNotesRecorded) + "PLAYBACK_TRACK" + sTrack, fCurrentBeat);
				SetLocalInt(oInstrument, "NOTE" + IntToString(iNotesRecorded) + "PITCH_TRACK" + sTrack, iNotePitch);
			}
		}
		
		// Move on to the next beat
		fCurrentBeat += fBeat;	
	}
	// Do another measure if necessary
	if (iMeasure < iTotalChords)
		ImproviseMelodyMeasure(oPC, iTrack, iMeasure + 1, fCurrentBeat, iLastNote, iLastMovement, bAscending, iNotesRecorded);
	else
	{
		// Add an ending note
		iNotesRecorded++;
		iNotePitch = ParseNote(GetLocalString(oPC, "NOTE1"));
		if (iInstrument == IMPROV_INSTRUMENT_FLUTE) iNotePitch += 200;
		SetLocalFloat(oInstrument, "NOTE" + IntToString(iNotesRecorded) + "PLAYBACK_TRACK" + sTrack, fCurrentBeat);
		SetLocalInt(oInstrument, "NOTE" + IntToString(iNotesRecorded) + "PITCH_TRACK" + sTrack, iNotePitch);
		SetLocalInt(oInstrument, "NOTES_RECORDED_TRACK" + sTrack, iNotesRecorded);		
	}			
}

// Returns TRUE if iNote is a chord tone of iChord.
// NOTE: This function assumes iChord is 151-186, and iNote is 1-36
// If they are outside of these ranges, it will always return TRUE.
int GetIsChordTone(int iChord, int iNote)
{	
	// condense iNote down to 1 octave, to make things easier
	while (iNote > 12) iNote -= 12;

	// Otherwise, depending on the chord, return a result
	switch (iChord)
	{
		// Majors
		case 151: // C
			if (iNote == 1 || iNote == 5 || iNote == 8) return TRUE;
			else return FALSE; break;
		case 152: // C#
			if (iNote == 2 || iNote == 6 || iNote == 9) return TRUE;
			else return FALSE; break;
		case 153: // D
			if (iNote == 3 || iNote == 7 || iNote == 10) return TRUE;
			else return FALSE; break;
		case 154: // D#
			if (iNote == 4 || iNote == 8 || iNote == 11) return TRUE;
			else return FALSE; break;
		case 155: // E
			if (iNote == 5 || iNote == 9 || iNote == 12) return TRUE;
			else return FALSE; break;
		case 156: // F
			if (iNote == 6 || iNote == 10 || iNote == 1) return TRUE;
			else return FALSE; break;
		case 157: // F#
			if (iNote == 7 || iNote == 11 || iNote == 2) return TRUE;
			else return FALSE; break;	
		case 158: // G
			if (iNote == 8 || iNote == 12 || iNote == 3) return TRUE;
			else return FALSE; break;
		case 159: // G#
			if (iNote == 9 || iNote == 1 || iNote == 4) return TRUE;
			else return FALSE; break;	
		case 160: // A
			if (iNote == 10 || iNote == 2 || iNote == 5) return TRUE;
			else return FALSE; break;
		case 161: // A#
			if (iNote == 11 || iNote == 3 || iNote == 6) return TRUE;
			else return FALSE; break;
		case 162: // B
			if (iNote == 12 || iNote == 4 || iNote == 7) return TRUE;
			else return FALSE; break;
		// Minors
		case 163: // Cm
			if (iNote == 1 || iNote == 4 || iNote == 8) return TRUE;
			else return FALSE; break;
		case 164: // C#m
			if (iNote == 2 || iNote == 5 || iNote == 9) return TRUE;
			else return FALSE; break;
		case 165: // Dm
			if (iNote == 3 || iNote == 6 || iNote == 10) return TRUE;
			else return FALSE; break;
		case 166: // D#m
			if (iNote == 4 || iNote == 7 || iNote == 11) return TRUE;
			else return FALSE; break;	
		case 167: // Em
			if (iNote == 5 || iNote == 8 || iNote == 12) return TRUE;
			else return FALSE; break;
		case 168: // Fm
			if (iNote == 6 || iNote == 9 || iNote == 1) return TRUE;
			else return FALSE; break;
		case 169: // F#m
			if (iNote == 7 || iNote == 10 || iNote == 2) return TRUE;
			else return FALSE; break;
		case 170: // Gm
			if (iNote == 8 || iNote == 11 || iNote == 3) return TRUE;
			else return FALSE; break;
		case 171: // G#m
			if (iNote == 9 || iNote == 12 || iNote == 4) return TRUE;
			else return FALSE; break;
		case 172: // Am
			if (iNote == 10 || iNote == 1 || iNote == 5) return TRUE;
			else return FALSE; break;
		case 173: // A#m
			if (iNote == 11 || iNote == 2 || iNote == 6) return TRUE;
			else return FALSE; break;
		case 174: // Bm
			if (iNote == 12 || iNote == 3 || iNote == 7) return TRUE;
			else return FALSE; break;
		// Diminished
		case 175: // C*
			if (iNote == 1 || iNote == 4 || iNote == 7) return TRUE;
			else return FALSE; break;	
		case 176: // C#*
			if (iNote == 2 || iNote == 5 || iNote == 8) return TRUE;
			else return FALSE; break;
		case 177: // D*
			if (iNote == 3 || iNote == 6 || iNote == 9) return TRUE;
			else return FALSE; break;
		case 178: // D#*
			if (iNote == 4 || iNote == 7 || iNote == 10) return TRUE;
			else return FALSE; break;
		case 179: // E*
			if (iNote == 5 || iNote == 8 || iNote == 11) return TRUE;
			else return FALSE; break;
		case 180: // F*
			if (iNote == 6 || iNote == 9 || iNote == 12) return TRUE;
			else return FALSE; break;
		case 181: // F#*
			if (iNote == 7 || iNote == 10 || iNote == 1) return TRUE;
			else return FALSE; break;
		case 182: // G*
			if (iNote == 8 || iNote == 11 || iNote == 2) return TRUE;
			else return FALSE; break;
		case 183: // G#*
			if (iNote == 9 || iNote == 12 || iNote == 3) return TRUE;
			else return FALSE; break;
		case 184: // A*
			if (iNote == 10 || iNote == 1 || iNote == 4) return TRUE;
			else return FALSE; break;	
		case 185: // A#*
			if (iNote == 11 || iNote == 2 || iNote == 5) return TRUE;
			else return FALSE; break;
		case 186: // B*
			if (iNote == 12 || iNote == 3 || iNote == 6) return TRUE;
			else return FALSE; break;	
	}
	return TRUE;
}

float GetOffset(int iPitch, float fDelay)
{
	if (iPitch > 100 && iPitch < 137)
		fDelay -= TKL_CHORD_ROLL_OFFSET;
	else if (iPitch == 316 || iPitch == 317 || iPitch == 366 || iPitch == 367)
		fDelay -= TKL_DRUM_ROLL_OFFSET;
	return fDelay;
}

void WriteNote(object oInstrument, int iNotesRecorded, int iTrack, int iPitch, float fDelay)
{
	string sTrack = IntToString(iTrack);
	iNotesRecorded++;
	string sID = "NOTE" + IntToString(iNotesRecorded);
	// Apply "rolled" note offsets if necessary
	if (iPitch > 100 && iPitch < 137)
		fDelay -= TKL_CHORD_ROLL_OFFSET;
	else if (iPitch == 316 || iPitch == 317 || iPitch == 366 || iPitch == 367)
		fDelay -= TKL_DRUM_ROLL_OFFSET;
	SetLocalFloat(oInstrument, sID + "PLAYBACK_TRACK" + sTrack, fDelay);
	SetLocalInt(oInstrument, sID + "PITCH_TRACK" + sTrack, iPitch);
}

void WriteTrack(object oPC, object oInstrument, int iTrack, string sInput, string sGUIFile, int iNotesWritten=0, int iPosition=0, int iRepeatStart=0, int iRepeatsDone=0, float fDelay=0.0f, int iRecursions=0)
{
	EraseTrack(oInstrument, iTrack, FALSE);
	string sOption = IntToString(iTrack);
	SetLocalString(oInstrument, "WRITE_TRACK" + sOption, sInput);
	float fWriteDelay;
	int iTempo = GetLocalInt(oInstrument, "METRONOME");
	if (iTempo == 0)
		iTempo = 60;
	float fTick = 60.0f / IntToFloat(iTempo);
	int iPitch;
	string sChar = GetSubString(sInput, iPosition, 1);
	string sChar2 = GetSubString(sInput, iPosition + 1, 1);
	string sChar3 = GetSubString(sInput, iPosition + 2, 1);
	int iRow;
	int iInstrumentOffset = 0;
	int bDrums = FALSE;
	if (sGUIFile == "tkl_performer_flute.xml")
		iInstrumentOffset = 200;
	else if (sGUIFile == "tkl_performer_drum.xml")
	{
		iInstrumentOffset = 323;
		bDrums = TRUE;
	}
	while (sChar != "")
	{
		string sLowerChar = GetStringLowerCase(sChar);
		// check for starting repeat symbols
		if (sChar == "|" && sChar2 == ":")
		{
			iPosition += 2;
			iRepeatStart = iPosition;
			iRepeatsDone = 0;
		}
		
		// check for ending repeat symbols
		else if (sChar == ":" && sChar2 == "|")
		{
			int iSymbolLength = 2;
			int iTotalRepeats = 0;
			// check for a specified number of repeats
			if (GetStringLowerCase(sChar3) == "x")
			{
				int iRepeatPosition = iPosition + 3;
				string sRepeatChar = GetSubString(sInput, iRepeatPosition, 1);
				string sRepeats;
				int iDigitLength;
				for (iDigitLength = 0; iDigitLength < 4; iDigitLength++)
				{
					// If the closing | is found, break out of the loop
					if (sRepeatChar == "|")
					{
						iTotalRepeats = StringToInt(sRepeats);
						iSymbolLength = 4 + iDigitLength; // :| + x + digit length + |
						break;
					}
					// Otherwise add one more digit
					else
					{
						sRepeats += sRepeatChar;
						iRepeatPosition++;
						sRepeatChar = GetSubString(sInput, iRepeatPosition, 1);
					}
				}
				// Make sure the total repeats was found
				if (iTotalRepeats <= 0)
				{
					SendMessageToPC(oPC, "Error at character " + IntToString(iPosition) + ": Invalid Repeat number.");
					SetLocalInt(oInstrument, "NOTES_RECORDED_TRACK" + sOption, iNotesWritten);
					return;
				}
			}
			// Default of 2 repeats
			if (iTotalRepeats == 0) iTotalRepeats = 2;
			
			// Maximum # of repeats = 200
			if (iTotalRepeats > 200)
			{
				iTotalRepeats = 200;
				SendMessageToPC(oPC, "Maximum Number of Repeats = 200.");
			}
			
			// Check to see if more repeats need to be done
			if (iRepeatsDone < iTotalRepeats - 1)
			{
				iPosition = iRepeatStart;
				iRepeatsDone++;
			}
			// Otherwise skip the repeat symbol and continue with the track
			else
			{
				iPosition += iSymbolLength;
			}		
		}
		
		// check for symbols to ignore: | _ / ; [space]
		else if (sChar == "_" || sChar == " " || sChar == "/" || sChar == ";" || sChar == "|")
		{
			iPosition++;
		}
		// check for rest
		else if (sChar == "-" || sChar == ">")
		{
			iPosition++;
			// Check for a beat division, such as .2, .3, or .4
			if (GetSubString(sInput, iPosition, 1) == ".")
			{
				float fDivision = StringToFloat(GetSubString(sInput, iPosition + 1, 1));
				if (fDivision <= 1.0f) fDivision = 1.0f;
				fDelay += (fTick / fDivision);
				iPosition += 2;
			}
			else
				fDelay += fTick;
		}
		// check for percussion
		else if (sLowerChar == "p")
		{
			if (sGUIFile != "tkl_performer_drum.xml")
			{
				SendMessageToPC(oPC, "Error at character " + IntToString(iPosition) + ": You can only write percussion sounds while holding a drum.");
				SetLocalInt(oInstrument, "NOTES_RECORDED_TRACK" + sOption, iNotesWritten);
				return;
			}
			iRow = StringToInt(sChar3);
			int iPositionIncrease = 3;
			if (iRow != 1 && iRow != 2)
			{
				iRow = d2(); // if not specified, choose a random variation
				iPositionIncrease = 2;
			}
			iPitch = GetPercussionPitch(sChar2, iRow);
			if (iPitch == -1)
			{
				SendMessageToPC(oPC, "Error at character " + IntToString(iPosition) + ": Percussion 'p' must be followed by one of the letters 'a' through 'j', indicating which percussion sound to use.");
				SetLocalInt(oInstrument, "NOTES_RECORDED_TRACK" + sOption, iNotesWritten);
				return;
			}
			AssignCommand(oPC, DelayCommand(fWriteDelay, WriteNote(oInstrument, iNotesWritten, iTrack, iPitch, fDelay)));
			fWriteDelay += 0.01f;
			iPosition += iPositionIncrease;	
			iNotesWritten++;
			// Check for a beat division, such as .2, .3, or .4
			if (GetSubString(sInput, iPosition, 1) == ".")
			{
				float fDivision = StringToFloat(GetSubString(sInput, iPosition + 1, 1));
				if (fDivision <= 1.0f) fDivision = 1.0f;
				fDelay += (fTick / fDivision);
				iPosition += 2;
			}
			else
				fDelay += fTick;
			
			// Check to see if the function needs to be "recursed" (every 400 notes)
			if (iNotesWritten / WRITE_RECURSION_LIMIT > iRecursions)
			{
				AssignCommand(oPC, DelayCommand(fWriteDelay, WriteTrack(oPC, oInstrument, iTrack, sInput, sGUIFile, iNotesWritten, iPosition, iRepeatStart, iRepeatsDone, fDelay, iRecursions+1)));	
				return;
			}
		}
		// check for melody
		else if ((sLowerChar == "a" || sLowerChar == "b" || sLowerChar == "c" || sLowerChar == "d" || sLowerChar == "e" || sLowerChar == "f" || sLowerChar == "g")
					&& (sChar2 != "m" && sChar2 != "M")
					&& (sChar3 != "m" && sChar3 != "M"))
		{
			// check for sharp or flat
			if (sChar2 == "#" || sChar2 == "b")
			{
				iRow = StringToInt(sChar3);
				iPosition++;
			}
			else
			{
				iRow = StringToInt(sChar2);
			}
			if (iRow != 1 && iRow != 2 && iRow != 3)
			{
				SendMessageToPC(oPC, "Error at character " + IntToString(iPosition) + ": Melody notes must end with a 1 or 2 (or 3 for a high C) to indicate which row to use.");
				SetLocalInt(oInstrument, "NOTES_RECORDED_TRACK" + sOption, iNotesWritten);
				return;
			}
			if (sGUIFile == "tkl_performer_drum.xml" && iRow != 1)
			{
				SendMessageToPC(oPC, "Error at character " + IntToString(iPosition) + ": Drum melody notes must end with a 1.");
				SetLocalInt(oInstrument, "NOTES_RECORDED_TRACK" + sOption, iNotesWritten);
				return;
			}
			if (iRow == 3 && sLowerChar != "c")
			{
				SendMessageToPC(oPC, "Error at character " + IntToString(iPosition) + ": The only note that can use the '3' row is C.");
				SetLocalInt(oInstrument, "NOTES_RECORDED_TRACK" + sOption, iNotesWritten);
				return;
			}
			
			iPitch = GetMelodyPitch(sChar, sChar2, iRow, bDrums, iInstrumentOffset);
			if (iPitch == -1)
			{
				SendMessageToPC(oPC, "Error at character " + IntToString(iPosition) + ": Invalid melody note.");
				SetLocalInt(oInstrument, "NOTES_RECORDED_TRACK" + sOption, iNotesWritten);
				return;
			}
			AssignCommand(oPC, DelayCommand(fWriteDelay, WriteNote(oInstrument, iNotesWritten, iTrack, iPitch, fDelay)));
			fWriteDelay += 0.01f;
			iPosition += 2;	
			iNotesWritten++;
			// Check for a beat division, such as .2, .3, or .4
			if (GetSubString(sInput, iPosition, 1) == ".")
			{
				float fDivision = StringToFloat(GetSubString(sInput, iPosition + 1, 1));
				if (fDivision <= 1.0f) fDivision = 1.0f;
				fDelay += (fTick / fDivision);
				iPosition += 2;
			}
			else
				fDelay += fTick;
			
			// Check to see if the function needs to be "recursed" (every 400 notes)
			if (iNotesWritten / WRITE_RECURSION_LIMIT > iRecursions)
			{
				AssignCommand(oPC, DelayCommand(fWriteDelay, WriteTrack(oPC, oInstrument, iTrack, sInput, sGUIFile, iNotesWritten, iPosition, iRepeatStart, iRepeatsDone, fDelay, iRecursions+1)));	
				return;
			}	
		}
		
		// check for chords
		else if ((sLowerChar == "a" || sLowerChar == "b" || sLowerChar == "c" || sLowerChar == "d" || sLowerChar == "e" || sLowerChar == "f" || sLowerChar == "g")
					&& ((sChar2 == "m" || sChar2 == "M" || sChar2 == "*")
					|| (sChar3 == "m" || sChar3 == "M" || sChar3 == "*")))
		{
			if (sGUIFile != "tkl_performer_lute.xml")
			{
				SendMessageToPC(oPC, "Error at character " + IntToString(iPosition) + ": You can only write harmony sounds (chords) while holding a lute.");
				SetLocalInt(oInstrument, "NOTES_RECORDED_TRACK" + sOption, iNotesWritten);
				return;
			}
		
			string sQuality;
			// check for sharp or flat
			if (sChar2 == "#" || sChar2 == "b")
			{
				iPosition++;
				sQuality = sChar3;
			}
			else
				sQuality = sChar2;
			

			iPitch = GetChordPitch(sChar, sChar2, sQuality);
			if (iPitch == -1)
			{
				SendMessageToPC(oPC, "Error at character " + IntToString(iPosition) + ": Invalid chord note.");
				SetLocalInt(oInstrument, "NOTES_RECORDED_TRACK" + sOption, iNotesWritten);
				return;
			}
			AssignCommand(oPC, DelayCommand(fWriteDelay, WriteNote(oInstrument, iNotesWritten, iTrack, iPitch, fDelay)));
			fWriteDelay += 0.01f;
			iPosition += 2;	
			iNotesWritten++;
			// Check for a beat division, such as .2, .3, or .4
			if (GetSubString(sInput, iPosition, 1) == ".")
			{
				float fDivision = StringToFloat(GetSubString(sInput, iPosition + 1, 1));
				if (fDivision <= 1.0f) fDivision = 1.0f;
				fDelay += (fTick / fDivision);
				iPosition += 2;
			}
			else
				fDelay += fTick;
				
			// Check to see if the function needs to be "recursed" (every 400 notes)
			if (iNotesWritten / WRITE_RECURSION_LIMIT > iRecursions)
			{
				AssignCommand(oPC, DelayCommand(fWriteDelay, WriteTrack(oPC, oInstrument, iTrack, sInput, sGUIFile, iNotesWritten, iPosition, iRepeatStart, iRepeatsDone, fDelay, iRecursions+1)));	
				return;
			}	
		}
		else
		{
			SendMessageToPC(oPC, "Error at character " + IntToString(iPosition) + ": Invalid note.");
			//SendMessageToPC(oPC, "sChar = " + sChar + " sChar2 = " + sChar2 + " sChar3 = " + sChar3); 
			SetLocalInt(oInstrument, "NOTES_RECORDED_TRACK" + sOption, iNotesWritten);
			return;
		}
		
		sChar = GetSubString(sInput, iPosition, 1);
		sChar2 = GetSubString(sInput, iPosition + 1, 1);
		sChar3 = GetSubString(sInput, iPosition + 2, 1);		
	}
	
	SetLocalInt(oInstrument, "NOTES_RECORDED_TRACK" + sOption, iNotesWritten);
	SetLocalInt(oInstrument, "METRONOME_RECORDED_TRACK" + sOption, iTempo);
	AssignCommand(oPC, DelayCommand(fWriteDelay + 0.01f, SetSongLength(oInstrument)));
	AssignCommand(oPC, DelayCommand(fWriteDelay + 0.02f, SendMessageToPC(oPC, "Track " + sOption + " learned.")));
}

void SetSongLength(object oInstrument)
{
	SetLocalFloat(oInstrument, "SONG_LENGTH", GetSongLength(oInstrument));
	//SendMessageToPC(GetFirstPC(), "New Song Length = " + FloatToString(GetSongLength(oInstrument)));
}

void WriteLyric(object oInstrument, int iLyricsRecorded, int iLyric, float fDelay)
{
	iLyricsRecorded++;
	string sID = "LYRIC" + IntToString(iLyricsRecorded);
	SetLocalFloat(oInstrument, sID + "PLAYBACK", fDelay);
	SetLocalInt(oInstrument, sID + "TEXT", iLyric);
}

void WriteLyrics(object oPC, object oInstrument, string sInput)
{
	float fTick = GetLocalFloat(oInstrument, "SECONDS_PER_LYRIC");
	if (fTick <= 0.0f)
	{
		SendMessageToPC(oPC, "Before using Lyric Write, you must set a number of seconds per lyric.");
		return;
	}
	EraseLyricTrack(oInstrument);
	SetLocalString(oInstrument, "WRITE_LYRICS", sInput);
	float fWriteDelay, fDelay;
	int iLyricsWritten;
	int iPosition, iLyric, iLastLyricWritten;
	string sChar = GetSubString(sInput, iPosition, 1);
	string sChar2 = GetSubString(sInput, iPosition + 1, 1);
	string sChar3 = GetSubString(sInput, iPosition + 2, 1);
	int iRepeatStart, iRepeatsDone;
	while (sChar != "")
	{
		string sLowerChar = GetStringLowerCase(sChar);
		// check for starting repeat symbols
		if (sChar == "|" && sChar2 == ":")
		{
			iPosition += 2;
			iRepeatStart = iPosition;
			iRepeatsDone = 0;
		}
		
		// check for ending repeat symbols
		else if (sChar == ":" && sChar2 == "|")
		{
			int iSymbolLength = 2;
			int iTotalRepeats = 0;
			// check for a specified number of repeats
			if (GetStringLowerCase(sChar3) == "x")
			{
				int iRepeatPosition = iPosition + 3;
				string sRepeatChar = GetSubString(sInput, iRepeatPosition, 1);
				string sRepeats;
				int iDigitLength;
				for (iDigitLength = 0; iDigitLength < 4; iDigitLength++)
				{
					// If the closing | is found, break out of the loop
					if (sRepeatChar == "|")
					{
						iTotalRepeats = StringToInt(sRepeats);
						iSymbolLength = 4 + iDigitLength; // :| + x + digit length + |
						break;
					}
					// Otherwise add one more digit
					else
					{
						sRepeats += sRepeatChar;
						iRepeatPosition++;
						sRepeatChar = GetSubString(sInput, iRepeatPosition, 1);
					}
				}
				// Make sure the total repeats was found
				if (iTotalRepeats <= 0)
				{
					SendMessageToPC(oPC, "Error at character " + IntToString(iPosition) + ": Invalid Repeat number.");
					SetLocalInt(oInstrument, "LYRICS_RECORDED", iLyricsWritten);
					return;
				}
			}
			// Default of 2 repeats
			if (iTotalRepeats == 0) iTotalRepeats = 2;
			
			// Maximum # of repeats = 200
			if (iTotalRepeats > 200)
			{
				iTotalRepeats = 200;
				SendMessageToPC(oPC, "Maximum Number of Repeats = 200.");
			}
			
			// Check to see if more repeats need to be done
			if (iRepeatsDone < iTotalRepeats - 1)
			{
				iPosition = iRepeatStart;
				iRepeatsDone++;
			}
			// Otherwise skip the repeat symbol and continue with the track
			else
			{
				iPosition += iSymbolLength;
			}		
		}
		
		// Check for a ^ followed by an L, indicating a sequence of lyrics
		else if (sChar == "^" && GetStringLowerCase(sChar2) == "l")
		{
			if (iLastLyricWritten == 0)
			{
				SendMessageToPC(oPC, "Error at character " + IntToString(iPosition) + ": Lyric sequence syntax error.");
				SetLocalInt(oInstrument, "LYRICS_RECORDED", iLyricsWritten);
				return;
			}
			// Get the Lyric number after the ^L
			// First check the 2 characters after the ^L for a double digit lyric number
			string sNextTwo = GetSubString(sInput, iPosition + 2, 2);
			int iEndPoint = StringToInt(sNextTwo);
			// If necessary check the 1 character after the ^L for a single digit lyric number
			if (iEndPoint == 0) iEndPoint = StringToInt(GetStringLeft(sNextTwo, 1));
			if (iEndPoint == 0)
			{
				SendMessageToPC(oPC, "Error at character " + IntToString(iPosition) + ": Lyric sequence syntax error.");
				SetLocalInt(oInstrument, "LYRICS_RECORDED", iLyricsWritten);
				return;
			}
			int i;
			for (i = iLastLyricWritten + 1; i <= iEndPoint; i++)
			{
				AssignCommand(oPC, DelayCommand(fWriteDelay, WriteLyric(oInstrument, iLyricsWritten, i, fDelay)));
				fDelay += fTick;
				iLyricsWritten++;
				iLastLyricWritten = i;
				fWriteDelay += 0.01f;	
			}
			iPosition += 2 + GetStringLength(IntToString(iEndPoint));
		}
		
		// check for symbols to ignore: | _ / ; [space]
		else if (sChar == "_" || sChar == " " || sChar == "/" || sChar == ";" || sChar == "|")
		{
			iPosition++;
		}
		// check for rest
		else if (sChar == "-" || sChar == ">")
		{	
			iPosition++;
			// Check for a beat division, such as .2, .3, or .4
			if (GetSubString(sInput, iPosition, 1) == ".")
			{
				float fDivision = StringToFloat(GetSubString(sInput, iPosition + 1, 1));
				if (fDivision <= 1.0f) fDivision = 1.0f;
				fDelay += (fTick / fDivision);
				iPosition += 2;
			}
			else
				fDelay += fTick;
			
		}
		
		// Check for a Lyric
		else if (sLowerChar == "l")
		{
			// Get the Lyric number after the L
			// First check the 2 characters after the L for a double digit lyric number
			string sNextTwo = GetSubString(sInput, iPosition + 1, 2);
			int iLyricNumber = StringToInt(sNextTwo);
			// If necessary check the 1 character after the :L for a single digit lyric number
			if (iLyricNumber == 0) iLyricNumber = StringToInt(GetStringLeft(sNextTwo, 1));
			if (iLyricNumber == 0)
			{
				SendMessageToPC(oPC, "Error at character " + IntToString(iPosition) + ": Lyric syntax error.");
				SetLocalInt(oInstrument, "LYRICS_RECORDED", iLyricsWritten);
				return;
			}
			AssignCommand(oPC, DelayCommand(fWriteDelay, WriteLyric(oInstrument, iLyricsWritten, iLyricNumber, fDelay)));
			iLyricsWritten++;
			iLastLyricWritten = iLyricNumber;
			fWriteDelay += 0.01f;	
			iPosition += 1 + GetStringLength(IntToString(iLyricNumber));
			// Check for a beat division, such as .2, .3, or .4
			if (GetSubString(sInput, iPosition, 1) == ".")
			{
				float fDivision = StringToFloat(GetSubString(sInput, iPosition + 1, 1));
				if (fDivision <= 1.0f) fDivision = 1.0f;
				fDelay += (fTick / fDivision);
				iPosition += 2;
			}
			else
				fDelay += fTick;
		}
		else
		{
			SendMessageToPC(oPC, "Error at character " + IntToString(iPosition) + ": Invalid lyric syntax.");
			//SendMessageToPC(oPC, "sChar = " + sChar + " sChar2 = " + sChar2 + " sChar3 = " + sChar3); 
			SetLocalInt(oInstrument, "LYRICS_RECORDED", iLyricsWritten);
			return;
		}
		
		sChar = GetSubString(sInput, iPosition, 1);
		sChar2 = GetSubString(sInput, iPosition + 1, 1);
		sChar3 = GetSubString(sInput, iPosition + 2, 1);		
	}
	
	SetLocalInt(oInstrument, "LYRICS_RECORDED", iLyricsWritten);
	AssignCommand(oPC, DelayCommand(fWriteDelay + 0.01f, SetSongLength(oInstrument)));
	AssignCommand(oPC, DelayCommand(fWriteDelay + 0.02f, SendMessageToPC(oPC, "Lyrics learned.")));
}

string GetTKLPersistString(object oPC, string sValueName)
{
#if TKL_PERFORMER_USE_ACR_PERSIST
	if (oPC == OBJECT_INVALID)
		oPC = GetModule();

	UpgradeTKLDatabase(oPC);

	return ACR_GetPersistentString(oPC, sValueName);
#else
	return GetCampaignString(TKL_PERFORMER_DATABASE, sValueName, oPC);
#endif
}

void SetTKLPersistString(object oPC, string sValueName, string sValueData)
{
#if TKL_PERFORMER_USE_ACR_PERSIST
	if (oPC == OBJECT_INVALID)
		oPC = GetModule();

	UpgradeTKLDatabase(oPC);

	ACR_SetPersistentString(oPC, sValueName, sValueData);
#else
	SetCampaignString(TKL_PERFORMER_DATABASE, sValueName, sValueData, oPC);
#endif
}

float GetTKLPersistFloat(object oPC, string sValueName)
{
#if TKL_PERFORMER_USE_ACR_PERSIST
	if (oPC == OBJECT_INVALID)
		oPC = GetModule();

	UpgradeTKLDatabase(oPC);

	return ACR_GetPersistentFloat(oPC, sValueName);
#else
	return GetCampaignFloat(TKL_PERFORMER_DATABASE, sValueName, oPC);
//	return StringToFloat(GetTKLPersistString(oPC, sValueName));
#endif
}

void SetTKLPersistFloat(object oPC, string sValueName, float fValueData)
{
#if TKL_PERFORMER_USE_ACR_PERSIST
	if (oPC == OBJECT_INVALID)
		oPC = GetModule();

	UpgradeTKLDatabase(oPC);

	ACR_SetPersistentFloat(oPC, sValueName, fValueData);
#else
	SetCampaignFloat(TKL_PERFORMER_DATABASE, sValueName, fValueData, oPC);
//	SetTKLPersistString(oPC, sValueName, FloatToString(fValueData));
#endif
}

object RetrieveTKLPersistInstrumentObject(object oPC, string sValueName, location lLocation, object oOwner)
{
#if TKL_PERFORMER_USE_ACR_PERSIST
	object oInstrument;

	UpgradeTKLDatabase(oPC);

	// Just use the campaign database if the score is "server global".
	if (oPC == OBJECT_INVALID)
		return RetrieveCampaignObject(TKL_PERFORMER_DATABASE, sValueName, lLocation, oOwner, oPC);

	// Otherwise, create a temporary waypoint object and populate its local
	// script variables from the database.  The TKL code will delete the object
	// immediately after (it doesn't need to even be an item object); the entire
	// purpose here is just to save and restore all of the locals on the object
	// itself.  A waypoint is used as it has no effect on the game world.
	oInstrument = CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", lLocation, FALSE);

	if (!ACR_LoadObjectVariablesFromPersistStore(oInstrument, oPC, "TKLOBJ_" + sValueName))
	{
		// No object by this name in the database.
		DestroyObject(oInstrument);
		return OBJECT_INVALID;
	}

	return oInstrument;
#else
	return RetrieveCampaignObject(TKL_PERFORMER_DATABASE, sValueName, lLocation, oOwner, oPC);
#endif
}

void StoreTKLPersistInstrumentObject(object oPC, string sValueName, object oInstrument)
{
#if TKL_PERFORMER_USE_ACR_PERSIST
	UpgradeTKLDatabase(oPC);

	// Just use the campaign database if the score is "server global".
	if (oPC == OBJECT_INVALID)
	{
		StoreCampaignObject(TKL_PERFORMER_DATABASE, sValueName, oInstrument, oPC);
		return;
	}

	// Store the local variables of the object into the database.  No other data
	// other than the locals are stored, but that is all that TKL needs.
	ACR_SaveObjectVariablesToPersistStore(oInstrument, oPC, "TKLOBJ_" + sValueName);
#else
	StoreCampaignObject(TKL_PERFORMER_DATABASE, sValueName, oInstrument, oPC);
#endif
}

void UpgradeTKLDatabase(object oTarget)
{
#if TKL_PERFORMER_USE_ACR_PERSIST
	if (oTarget == GetModule())
		oTarget = OBJECT_INVALID;

	// Not implemented right now.  If implemented, what we would do here is to
	// read the campaign database data for this target and transfer it to the
	// central database.
#endif
}

