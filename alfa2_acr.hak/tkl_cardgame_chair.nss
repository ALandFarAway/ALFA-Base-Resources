/*
Script: tkl_cardgame_chair
Author: brockfanning
Date: 8/15/07
Purpose: Should be placed in the OnUsed field of any "card chair", which should also have an
inventory, be useable, and plot-locked.
*/

#include "tkl_cardgame_include"

// Trying this wrapper to help with problems with the sitting animation. (The problem is
// that sometimes other PCs appear to be sitting backwards or standing sideways.)
void VoidAnimation(object oObject, string sAnimationName, int nLooping, float fSpeed = 1.0f)
{
	PlayCustomAnimation(oObject, sAnimationName, nLooping, fSpeed);
}

void main()
{
	// Get the necessary objects for this cardgame setup.
	object oChair = OBJECT_SELF;
	object oPC = GetLastUsedBy();
	object oDeck = GetNearestObjectByTag("p_cards_deck", oChair);
	object oDiscard = GetNearestObjectByTag("p_cards_discard", oChair);
	object oBoard = GetNearestObjectByTag("p_cards_board", oChair);

	// Abort if the setup is not complete.	
	if (!GetIsObjectValid(oDeck))
	{
		SendMessageToPC(oPC, "Report this bug: there is no deck.");
		return;
	}

	if (!GetIsObjectValid(oDiscard))
	{
		SendMessageToPC(oPC, "Report this bug: there is no discard pile.");
		return;
	}
	
	if (!GetIsObjectValid(oBoard))
	{
		SendMessageToPC(oPC, "Report this bug: there is no table.");
		return;
	}
	
	// Have the PC sit in the chair.  Doesn't work too well with small PCs.
	location lLoc = Location(GetArea(oChair),
		GetPosition(oChair),
		GetFacing(oChair) + 180.0f);
	AssignCommand(oPC,JumpToLocation(lLoc));
	AssignCommand(oPC, VoidAnimation(oPC,"sitidle",1));
	
	// Check to see if the player just moved from another chair.
	int iPreviousChair = GetLocalInt(oPC, "CARD_PLAYER");
	// Get more necessary variables.
	int iPlayer = GetLocalInt(oChair, "CARD_PLAYER");
	string sPlayer = IntToString(iPlayer);
	string sScreenName = GetScreenName(iPlayer);
	string sXMLFile = GetXMLFile(iPlayer);
	
	// Set various elements on the PC, for use in the other scripts.
	SetLocalInt(oPC, "CARD_PLAYER", iPlayer);
	SetLocalObject(oPC, "DECK", oDeck);
	SetLocalObject(oPC, "DISCARD", oDiscard);
	SetLocalObject(oPC, "HAND", oChair);
	SetLocalObject(oPC, "BOARD", oBoard);
	
	// Set the PC as a local object on the deck, to keep track of it later.
	// Also delete any old versions, in case the PC just hopped to another chair.
	if (iPreviousChair == 1)
	{
		DeleteLocalObject(oDeck, "CARD_PLAYER_1");
		CloseGUIScreen(oPC, "CARDGAME_PLAYER1");
		
	}
	else if (iPreviousChair == 2)
	{
		DeleteLocalObject(oDeck, "CARD_PLAYER_2");
		CloseGUIScreen(oPC, "CARDGAME_PLAYER2");
	}
	else if (iPreviousChair == 3)
	{
		DeleteLocalObject(oDeck, "CARD_PLAYER_3");
		CloseGUIScreen(oPC, "CARDGAME_PLAYER3");
	}
	else if (iPreviousChair == 4)
	{
		DeleteLocalObject(oDeck, "CARD_PLAYER_4");
		CloseGUIScreen(oPC, "CARDGAME_PLAYER4");
	}		
	SetLocalObject(oDeck, "CARD_PLAYER_" + sPlayer, oPC);
	
	// Launch the UI.
	DisplayGuiScreen(oPC, sScreenName, FALSE, sXMLFile);
	// Refresh the player names.
	RefreshPlayers(oPC);
	
	// Get all the current players and refresh the cards and bets for everyone.
	object oPlayer1 = GetLocalObject(oDeck, "CARD_PLAYER_1");
	object oPlayer2 = GetLocalObject(oDeck, "CARD_PLAYER_2");
	object oPlayer3 = GetLocalObject(oDeck, "CARD_PLAYER_3");
	object oPlayer4 = GetLocalObject(oDeck, "CARD_PLAYER_4");	
	RefreshCards(oPlayer1);
	RefreshCards(oPlayer2);
	RefreshCards(oPlayer3);
	RefreshCards(oPlayer4);
	RefreshBets(oPlayer1);
	RefreshBets(oPlayer2);
	RefreshBets(oPlayer3);
	RefreshBets(oPlayer4);
	
	// Check to see if this is the first and only player.  If so, reset the game by moving
	// all cards back to the deck.
	object oCard, oNew, oPlace;
	if (iPlayer == 1)
	{
		if (!GetIsObjectValid(oPlayer2) && !GetIsObjectValid(oPlayer3) && !GetIsObjectValid(oPlayer4))
			ResetGame(oPC);
	}
	else if (iPlayer == 2)
	{
		if (!GetIsObjectValid(oPlayer1) && !GetIsObjectValid(oPlayer3) && !GetIsObjectValid(oPlayer4))
			ResetGame(oPC);
	}	
	else if (iPlayer == 3)
	{
		if (!GetIsObjectValid(oPlayer1) && !GetIsObjectValid(oPlayer2) && !GetIsObjectValid(oPlayer4))
			ResetGame(oPC);
	}
	else if (iPlayer == 4)
	{
		if (!GetIsObjectValid(oPlayer1) && !GetIsObjectValid(oPlayer2) && !GetIsObjectValid(oPlayer3))
			ResetGame(oPC);
	}					
}