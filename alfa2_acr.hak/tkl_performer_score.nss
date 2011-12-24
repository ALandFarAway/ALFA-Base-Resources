/*
Author: brockfanning
Date: Early 2008...
Purpose: This is the script that is called when someone activates the "score"
item that is produced by bards using TKL Performer with the "Transcribe"
function.

starting comments...
5/31/08: Added functionality for non-bards to use it to read lyrics. -bf
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
		SetGUIObjectDisabled(oPC, "TKL_PERFORMER_LYRICS", "LyricRecordButton", TRUE);
		SetGUIObjectDisabled(oPC, "TKL_PERFORMER_LYRICS", "LyricMuteButton", TRUE);
		SetGUIObjectHidden(oPC, "TKL_PERFORMER_LYRICS", "LyricText3", TRUE);
		SetGUIObjectHidden(oPC, "TKL_PERFORMER_LYRICS", "LyricText4", TRUE);
		SetLocalObject(oPC, "TKL_PERFORMER_SCORE", oScore);
		return;
	}	
	TransferSong(oScore, oInstrument);
}