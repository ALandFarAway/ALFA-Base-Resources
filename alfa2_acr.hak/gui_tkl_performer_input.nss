/*
Author: brockfanning
Date: Early 2008...
Purpose: These are various actions performed after the PC inputs their own text.

--added high C's to Write function -bf, 6/4/08
--added offsets for rolled notes
--moved GetChordPitch, GetPercussionPitch, GetMelodyPitch to tkl_performer_include
--allow DMs to rename the original composer when renaming the song.
*/

#include "tkl_performer_include"

void main(string sInput)
{
	object oPC = OBJECT_SELF;
	string sAction = GetLocalString(oPC, "TKL_PERFORMER_ACTION");
	int iOption = GetLocalInt(oPC, "TKL_PERFORMER_OPTION");
	string sOption = IntToString(iOption);
	object oInstrument = GetLocalObject(oPC, "TKL_PERFORMER_INSTRUMENT");
	
	if (sAction == "LYRIC_LEARN")
	{
		if (sInput == "")
		{
			SendMessageToPC(oPC, "Input is blank for lyric learning");
			return;
		}
		SetLocalString(oInstrument, "LYRIC" + sOption, sInput);
		SetGUIObjectText(oPC, "TKL_PERFORMER_LYRICS", "Lyric" + sOption + "Button", 0, sOption + ". " + GetStringLeft(sInput, 12));	
		ClearTKLPerformerVariables(oPC);
	}
	
	else if (sAction == "RENAME")
	{
		if (iOption > 0)
		{
			SetLocalString(oInstrument, "TRACK_" + sOption + "_NAME", sInput);	
		}
		else
		{
			SetLocalString(oInstrument, "SONG_NAME", sInput);
			// Allow DMs to specify a composer name.
			if (GetIsDM(oPC))
			{
				string sOldComposer = GetLocalString(oInstrument, "ORIGINAL_COMPOSER");
				PassTKLParameters(oPC, "SET_COMPOSER", 0);
				DisplayInputBox(oPC, 0, "Please specify the name of this song's composer.", "gui_tkl_performer_input", "gui_tkl_performer_cancel", TRUE, "", 0, "OK", 0, "Skip", sOldComposer);
			}	
		}
		RefreshNames(oPC, oInstrument);
		ClearTKLPerformerVariables(oPC);
	}
	
	else if (sAction == "WRITE")
	{
		string sOldWrite = GetLocalString(oInstrument, "WRITE_TRACK" + sOption);
		if (sInput == "" || sInput == sOldWrite)
		{
			SendMessageToPC(oPC, "The track was not changed.");
			return;
		}
		
		string sGUIFile = GetLocalString(oInstrument, "GUI_FILE");
		WriteTrack(oPC, oInstrument, iOption, sInput, sGUIFile);
		ClearTKLPerformerVariables(oPC);
	}
	
	else if (sAction == "WRITE_LYRICS")
	{
		string sOldWrite = GetLocalString(oInstrument, "WRITE_LYRICS");
		if (sInput == "" || sInput == sOldWrite)
		{
			SendMessageToPC(oPC, "The track was not changed.");
			return;
		}
		
		WriteLyrics(oPC, oInstrument, sInput);
		ClearTKLPerformerVariables(oPC);
	}
	
	else if (sAction == "ORIGINAL_COMPOSER")
	{
		SetLocalString(oInstrument, "ORIGINAL_COMPOSER", sInput);
		ClearTKLPerformerVariables(oPC);
	}
}