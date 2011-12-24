/*
Script: gui_tkl_cardgame
Author: brockfanning
Date: 8/4/07
Purpose: This script covers all the various actions in the card game, using passed parameters
from the xml files.

brockfanning, 1/21/08: fixed bugs with view cards in hand, and with cards being visible when dealing

*/

#include "tkl_cardgame_include"

void main(string sOption, int iRow)
{
	// Set up some basic objects and variables that will be used in most of the options.
	// These variables are set on the PC when the PC sits in a card chair.
	object oPC = OBJECT_SELF;
	object oDeck = GetLocalObject(oPC, "DECK");
	object oHand = GetLocalObject(oPC, "HAND");
	object oDiscard = GetLocalObject(oPC, "DISCARD");
	object oBoard = GetLocalObject(oPC, "BOARD");
	int iPlayer = GetLocalInt(oPC, "CARD_PLAYER");
	string sPlayerColor = GetPlayerColor(iPlayer);
	string sFloatyText = "";
	
	// Get the screen name of this players GUI, depending on which number player they are.
	string sScreenName = GetScreenName(iPlayer);
	
	// The PC draws a card.  This option makes use of the second parameter, Row, which in
	// this case just refers to a player number to give the card to.  This allows players to
	// deal cards to other players.
	if (sOption == "DRAW")
	{	
		// Check to see if the PC is drawing or being dealt to.  If the passed iRow parameter
		// is not equal to the iPlayer int, it means the PC is being dealt to.
		int bDealt = FALSE;
		if (iPlayer != iRow)
		{
			bDealt = TRUE;
			oPC = GetLocalObject(oDeck, "CARD_PLAYER_" + IntToString(iRow));
			sFloatyText = sPlayerColor + GetName(OBJECT_SELF) + DEAL_TEXT + GetName(oPC) + ".</i></c></c>";
			// Make sure that player exists.
			if (!GetIsObjectValid(oPC))
			{
				SendMessageToPC(OBJECT_SELF, "There is not a player in that seat.");
				return;
			}
		}
		else
			//sFloatyText = sPlayerColor + GetName(oPC) + " <i>draws</i>.</c>";
			sFloatyText = sPlayerColor + GetName(oPC) + DRAW_TEXT;    
		
		// Re-set some initial variables, as the PC object may have changed.
		oHand = GetLocalObject(oPC, "HAND");
		iPlayer = GetLocalInt(oPC, "CARD_PLAYER");
		sScreenName = GetScreenName(iPlayer);
		
		// Make sure the hand isn't too full, or the deck empty.
		int iCardsInDeck = GetLocalInt(oDeck, "TOTAL_CARDS");
		int iCardsInHand = GetLocalInt(oHand, "CARDS_IN_HAND");
		if (iCardsInHand >= 10)
		{
			if (bDealt)
			{
				SendMessageToPC(OBJECT_SELF, GetName(oPC) + "'s hand is full at 10 cards.");
				return;
			}
			else
			{
				SendMessageToPC(oPC, "Your hand is full at 10 cards.");
				return;
			}
		}
		if (iCardsInDeck == 0)
		{
			if (bDealt)
			{
				SendMessageToPC(OBJECT_SELF, "The deck is empty.");
				return;
			}
			else
			{
				SendMessageToPC(oPC, "The deck is empty.");
				return;
			}
		}
		
		// Choose a random card from the deck and copy is to the PC's hand.
		int iRandomCard = 1 + Random(iCardsInDeck);
		int i = 1;
		object oCard = GetFirstItemInInventory(oDeck);
		while (i < iRandomCard)
		{
			oCard = GetNextItemInInventory(oDeck);
			i++;
		}
		object oDrawn = CopyItem(oCard, oHand);
		DestroyObject(oCard);
		// Set the card as "face down"
		//SetLocalInt(oDrawn, "FACEUP", FALSE);
		// Set the new total on the deck.
		SetLocalInt(oDeck, "TOTAL_CARDS", iCardsInDeck - 1);
		// Announce what happened.
		SendMessageToPlayers(oDeck, sFloatyText);
		// SFX
		PlaySound("tkl_cardgame_draw");
		// Update the card info pane of the player being dealt to, or the dealer.
		if (bDealt)
			ChangeCardInfo(OBJECT_SELF, oDrawn);
		else
			ChangeCardInfo(oPC, oDrawn);	
		// Refresh the GUI to reflect the new card, delayed to let stuff happen.
		DelayCommand(0.1f, RefreshCards(oPC));
	}
	
	// Display a larger image of one of Player 1's cards.
	else if (sOption == "ZOOM_TABLE_PLAYER_1")
	{
		object oPlayer = GetLocalObject(oDeck, "CARD_PLAYER_1");
		object oPlayerHand = GetLocalObject(oPlayer, "HAND");
		object oCard = GetLocalObject(oPlayerHand, "TABLE_ROW_" + IntToString(iRow + 1));
		ChangeCardInfo(oPC, oCard);
	}
	
	// Display a larger image of one of Player 2's cards.
	else if (sOption == "ZOOM_TABLE_PLAYER_2")
	{
		object oPlayer = GetLocalObject(oDeck, "CARD_PLAYER_2");
		object oPlayerHand = GetLocalObject(oPlayer, "HAND");
		object oCard = GetLocalObject(oPlayerHand, "TABLE_ROW_" + IntToString(iRow + 1));
		ChangeCardInfo(oPC, oCard);
	}
	
	// Display a larger image of one of Player 3's cards.
	else if (sOption == "ZOOM_TABLE_PLAYER_3")
	{
		object oPlayer = GetLocalObject(oDeck, "CARD_PLAYER_3");
		object oPlayerHand = GetLocalObject(oPlayer, "HAND");
		object oCard = GetLocalObject(oPlayerHand, "TABLE_ROW_" + IntToString(iRow + 1));
		ChangeCardInfo(oPC, oCard);
	}
	
	// Display a larger image of one of Player 4's cards.
	else if (sOption == "ZOOM_TABLE_PLAYER_4")
	{
		object oPlayer = GetLocalObject(oDeck, "CARD_PLAYER_4");
		object oPlayerHand = GetLocalObject(oPlayer, "HAND");
		object oCard = GetLocalObject(oPlayerHand, "TABLE_ROW_" + IntToString(iRow + 1));
		ChangeCardInfo(oPC, oCard);
	}
	
	// Display a larger image of one of Player 1's cards.
	else if (sOption == "ZOOM_HAND_PLAYER_1")
	{
		object oPlayer = GetLocalObject(oDeck, "CARD_PLAYER_1");
		object oPlayerHand = GetLocalObject(oPlayer, "HAND");
		object oCard = GetLocalObject(oPlayerHand, "HAND_ROW_" + IntToString(iRow + 1));
		ChangeCardInfo(oPC, oCard);
	}
	
	// Display a larger image of one of Player 2's cards.
	else if (sOption == "ZOOM_HAND_PLAYER_2")
	{
		object oPlayer = GetLocalObject(oDeck, "CARD_PLAYER_2");
		object oPlayerHand = GetLocalObject(oPlayer, "HAND");
		object oCard = GetLocalObject(oPlayerHand, "HAND_ROW_" + IntToString(iRow + 1));
		ChangeCardInfo(oPC, oCard);
	}
	
	// Display a larger image of one of Player 3's cards.
	else if (sOption == "ZOOM_HAND_PLAYER_3")
	{
		object oPlayer = GetLocalObject(oDeck, "CARD_PLAYER_3");
		object oPlayerHand = GetLocalObject(oPlayer, "HAND");
		object oCard = GetLocalObject(oPlayerHand, "HAND_ROW_" + IntToString(iRow + 1));
		ChangeCardInfo(oPC, oCard);
	}
	
	// Display a larger image of one of Player 4's cards.
	else if (sOption == "ZOOM_HAND_PLAYER_4")
	{
		object oPlayer = GetLocalObject(oDeck, "CARD_PLAYER_4");
		object oPlayerHand = GetLocalObject(oPlayer, "HAND");
		object oCard = GetLocalObject(oPlayerHand, "HAND_ROW_" + IntToString(iRow + 1));
		ChangeCardInfo(oPC, oCard);
	}
		
	// The PC discards the selected card from his or her hand.
	else if (sOption == "DISCARD")
	{
		// This option uses the Row parameter, which is an integer showing which row is
		// currently selected by the player in the GUI.  It actually starts at 0 for Row 1,
		// so we have to add 1 to it.  Using this info we can get the name of the card, which
		// should have been set during the RefreshCards function.
		object oCard = GetLocalObject(oHand, "HAND_ROW_" + IntToString(iRow + 1));
		if (!GetIsObjectValid(oCard))
		{
			SendMessageToPC(oPC, "You must select a card in your hand to discard.");
			return;
		}
		
		string sCardName = GetName(oCard);
		// Copy the item to the discard pile.
		object oDiscarded = CopyItem(oCard, oDiscard);
		// Update the total on the discard pile.
		int iTotalDiscards = GetLocalInt(oDiscard, "TOTAL_CARDS");
		iTotalDiscards++;
		// Set the card as a local object on the discard pile, so that later we can see the
		// order the cards were placed there.
		SetLocalObject(oDiscard, "DISCARD" + IntToString(iTotalDiscards), oDiscarded);
		SetLocalInt(oDiscard, "TOTAL_CARDS", iTotalDiscards);
		// Destroy the old verison still in the player's hand.
		DestroyObject(oCard);
		// Refresh the GUI, delayed to allow stuff to happen first.
		DelayCommand(0.1f, RefreshCards(oPC));
		// Refresh the Card Info image.
		object oNextCard = GetLocalObject(oHand, "HAND_ROW_" + IntToString(iRow + 2));
		if (GetIsObjectValid(oNextCard))
			ChangeCardInfo(oPC, oNextCard);
		// Announce what happened.
		sFloatyText = sPlayerColor + GetName(oPC) + DISCARD_TEXT + sCardName + ".</c>";
		SendMessageToPlayers(oDeck, sFloatyText);
		// SFX
		PlaySound("tkl_cardgame_discard");
	}
	
	// The PC discards the selected card from the table.
	// For comments, see the "DISCARD" option.  This is pretty much the same.
	else if (sOption == "DISCARD_FROM_TABLE")
	{
		object oCard = GetLocalObject(oHand, "TABLE_ROW_" + IntToString(iRow + 1));
		if (!GetIsObjectValid(oCard))
		{
			SendMessageToPC(oPC, "You must select a card on the table to discard.");
			return;
		}

		string sCardName = GetName(oCard);
		object oDiscarded = CopyItem(oCard, oDiscard);
		
		int iTotalDiscards = GetLocalInt(oDiscard, "TOTAL_CARDS");
		iTotalDiscards++;
		SetLocalObject(oDiscard, "DISCARD" + IntToString(iTotalDiscards), oDiscarded);
		SetLocalInt(oDiscard, "TOTAL_CARDS", iTotalDiscards);
		
		DestroyObject(oCard);
		DelayCommand(0.1f, RefreshCards(oPC));
		object oNextCard = GetLocalObject(oHand, "TABLE_ROW_" + IntToString(iRow + 2));
		if (GetIsObjectValid(oNextCard))
			ChangeCardInfo(oPC, oNextCard);
		sFloatyText = sPlayerColor + GetName(oPC) + DISCARD_FACEUP_TEXT + sCardName + ".</c>";
		SendMessageToPlayers(oDeck, sFloatyText);
		PlaySound("tkl_cardgame_discardtable");
	}
	
	// The PC takes a card from the table to his or her hand.
	else if (sOption == "TAKE")
	{		
		// This option uses the Row parameter, which is an integer showing which row is
		// currently selected by the player in the GUI.  It actually starts at 0 for Row 1,
		// so we have to add 1 to it.  Using this info we can get the name of the card, which
		// should have been set during the RefreshCards function.
		object oCard = GetLocalObject(oHand, "TABLE_ROW_" + IntToString(iRow + 1));
		if (!GetIsObjectValid(oCard))
		{
			SendMessageToPC(oPC, "You must select a card on the table to take.");
			return;
		}
		
		// Make sure the hand isn't too full.
		int iCardsInHand = GetLocalInt(oHand, "CARDS_IN_HAND");
		if (iCardsInHand >= 10)
		{
			SendMessageToPC(oPC, "Your hand is full at 10 cards.");
			return;
		}
		
		string sCardName = GetName(oCard);
		// Set the card to face down by deleting any FACEUP variable.
		DeleteLocalInt(oCard, "FACEUP");
		// Refresh the card in the GUI.
		DelayCommand(0.1f, RefreshCards(oPC));
		// Refresh the Card Info image.
		object oNextCard = GetLocalObject(oHand, "TABLE_ROW_" + IntToString(iRow + 2));
		if (GetIsObjectValid(oNextCard))
			ChangeCardInfo(oPC, oNextCard);
		// Announce what happened.
		sFloatyText = sPlayerColor + GetName(oPC) + TAKE_TEXT + sCardName + ".</c>";
		SendMessageToPlayers(oDeck, sFloatyText);
		PlaySound("tkl_cardgame_take");
	}
	
	// The PC plays a card from his or her hand to the table.
	// For comments, see the "TAKE" option, it's pretty much the same.
	else if (sOption == "PLAY")
	{
		object oCard = GetLocalObject(oHand, "HAND_ROW_" + IntToString(iRow + 1));
		if (!GetIsObjectValid(oCard))
		{
			SendMessageToPC(oPC, "You must select a card from your hand to play.");
			return;
		}
		
		// Make sure the hand isn't too full.
		int iCardsInHand = GetLocalInt(oHand, "CARDS_ON_TABLE");
		if (iCardsInHand >= 10)
		{
			SendMessageToPC(oPC, "Your table is full at 10 cards.");
			return;
		}

		string sCardName = GetName(oCard);
		SetLocalInt(oCard, "FACEUP", TRUE);
		DelayCommand(0.1f, RefreshCards(oPC));
		object oNextCard = GetLocalObject(oHand, "HAND_ROW_" + IntToString(iRow + 2));
		if (GetIsObjectValid(oNextCard))
			ChangeCardInfo(oPC, oNextCard);
		sFloatyText = sPlayerColor + GetName(oPC) + PLAY_TEXT + sCardName + ".</c>";
		SendMessageToPlayers(oDeck, sFloatyText);
		PlaySound("tkl_cardgame_play");
	}
	
	// The PC draws a card from the discard pile face-up on the table.
	else if (sOption == "DRAW_FACEUP_FROM_DISCARD")
	{
		// Check the number of cards in the discard pile, make sure it is at least 1.
		int iTotalDiscards = GetLocalInt(oDiscard, "TOTAL_CARDS");
		if (iTotalDiscards <= 0)
		{
			SetLocalInt(oDiscard, "TOTAL_CARDS", 0);
			SendMessageToPC(oPC, "There are no cards in the discard pile to draw.");
			return;
		}
		// Check the number of cards on the PC's table.
		int iCardsOnTable = GetLocalInt(oHand, "CARDS_ON_TABLE");
		if (iCardsOnTable >= 10)
		{
			SendMessageToPC(oPC, "Your tabletop is full at 10 cards.");
			return;
		} 
		// Find the last card to be discarded.
		object oCard = GetLocalObject(oDiscard, "DISCARD" + IntToString(iTotalDiscards));
		// Move that card to the player's hand.
		object oDrawn = CopyItem(oCard, oHand);
		DestroyObject(oCard);
		iTotalDiscards--;
		// Set the new total on the discard pile.
		SetLocalInt(oDiscard, "TOTAL_CARDS", iTotalDiscards);
		// Set the card as face-up.
		SetLocalInt(oDrawn, "FACEUP", TRUE);
		// Announce what happened.
		sFloatyText = sPlayerColor + GetName(oPC) + DRAW_FACEUP_FROM_DISCARD_TEXT + GetName(oDrawn) + ".</c>";
		SendMessageToPlayers(oDeck, sFloatyText);
		// Update the card info pane of the player.
		ChangeCardInfo(oPC, oDrawn);
		//string sIcon = GetTag(oDrawn) + ".tga";
		//SetGUITexture(oPC, sScreenName, "InfoImage", sIcon);
		// Refresh the cards, delayed to let stuff happen.
		DelayCommand(0.1f, RefreshCards(oPC));
		// SFX
		PlaySound("tkl_cardgame_drawtable");
	}
	
	// The PC draws a card face-up from the deck.
	// For comments, see the "DRAW" option, it's pretty much the same.
	else if (sOption == "DRAW_FACEUP")
	{
		//string sDealerScreenName = sScreenName;
		int bDealt = FALSE;
		if (iPlayer != iRow)
		{
			bDealt = TRUE;
			oPC = GetLocalObject(oDeck, "CARD_PLAYER_" + IntToString(iRow));
			sFloatyText = sPlayerColor + GetName(OBJECT_SELF) + DEAL_TEXT + GetName(oPC) + ":</i></c>";
			// Make sure that player exists.
			if (!GetIsObjectValid(oPC))
			{
				SendMessageToPC(OBJECT_SELF, "There is not a player in that seat.");
				return;
			}
		}
		else
			sFloatyText = sPlayerColor + GetName(oPC) + DRAW_FACEUP_TEXT;  
		
		oHand = GetLocalObject(oPC, "HAND");
		iPlayer = GetLocalInt(oPC, "CARD_PLAYER");
		sScreenName = GetScreenName(iPlayer);
		
		int iCardsInDeck = GetLocalInt(oDeck, "TOTAL_CARDS");
		int iCardsOnTable = GetLocalInt(oHand, "CARDS_ON_TABLE");
		if (iCardsOnTable >= 10)
		{
			if (bDealt)
			{
				SendMessageToPC(OBJECT_SELF, GetName(oPC) + "'s tabletop is full at 10 cards.");
				return;
			}
			else
			{
				SendMessageToPC(oPC, "Your tabletop is full at 10 cards.");
				return;
			}
		}
		if (iCardsInDeck == 0)
		{
			if (bDealt)
			{
				SendMessageToPC(OBJECT_SELF, "The deck is empty.");
				return;
			}
			else
			{
				SendMessageToPC(oPC, "The deck is empty.");
				return;
			}
		}
		int iRandomCard = 1 + Random(iCardsInDeck);
		int i = 1;
		object oCard = GetFirstItemInInventory(oDeck);
		while (i < iRandomCard)
		{
			oCard = GetNextItemInInventory(oDeck);
			i++;
		}
		object oDrawn = CopyItem(oCard, oHand);
		string sDrawnName = GetName(oDrawn);
		DestroyObject(oCard);
		SetLocalInt(oDeck, "TOTAL_CARDS", iCardsInDeck - 1);
		SetLocalInt(oDrawn, "FACEUP", TRUE);
		sFloatyText = sFloatyText + sDrawnName + "</c>";
		SendMessageToPlayers(oDeck, sFloatyText);
		// Update the card info pane of the player being dealt to, as well as the dealer.
		ChangeCardInfo(oPC, oDrawn);
		if (bDealt)
			ChangeCardInfo(OBJECT_SELF, oDrawn);
		DelayCommand(0.1f, RefreshCards(oPC));
		PlaySound("tkl_cardgame_drawtable");		
	}
	
	// The PC draws a card from the discard pile to his or her hand.
	// For comments see the "DRAW_FACEUP_FROM_DISCARD" option, it's pretty much the same.
	else if (sOption == "DRAW_FROM_DISCARD")
	{
		int iTotalDiscards = GetLocalInt(oDiscard, "TOTAL_CARDS");
		if (iTotalDiscards <= 0)
		{
			SetLocalInt(oDiscard, "TOTAL_CARDS", 0);
			SendMessageToPC(oPC, "There are no cards in the discard pile to draw.");
			return;
		}
		int iCardsInHand = GetLocalInt(oHand, "CARDS_IN_HAND");
		if (iCardsInHand >= 10)
		{
			SendMessageToPC(oPC, "Your hand is full at 10 cards.");
			return;
		}
		object oCard = GetLocalObject(oDiscard, "DISCARD" + IntToString(iTotalDiscards));
		object oDrawn = CopyItem(oCard, oHand);
		DestroyObject(oCard);
		iTotalDiscards--;
		SetLocalInt(oDiscard, "TOTAL_CARDS", iTotalDiscards);
		//SetLocalInt(oDrawn, "FACEUP", FALSE);
		sFloatyText = sPlayerColor + GetName(oPC) + DRAW_FROM_DISCARD_TEXT + GetName(oDrawn) + ".</c>";
		SendMessageToPlayers(oDeck, sFloatyText);
		ChangeCardInfo(oPC, oDrawn);
		DelayCommand(0.1f, RefreshCards(oPC));
		PlaySound("tkl_cardgame_draw");
	}
	
	// The PC shuffle's the discard pile into the deck.
	else if (sOption == "SHUFFLE")
	{
		// Get the deck and discard card totals.
		int iTotalDiscards = GetLocalInt(oDiscard, "TOTAL_CARDS");
		int iTotalCards = GetLocalInt(oDeck, "TOTAL_CARDS");
		
		// Start cycling through the discard pile, moving all cards to the deck.
		object oCard = GetFirstItemInInventory(oDiscard);
		while (GetIsObjectValid(oCard))
		{
			object oShuffled = CopyItem(oCard, oDeck);
			DestroyObject(oCard);
			//SetLocalInt(oShuffled, "FACEUP", FALSE);
			oCard = GetNextItemInInventory(oDiscard);
		}
		
		// Set new totals on the deck and discard.
		SetLocalInt(oDiscard, "TOTAL_CARDS", 0);
		SetLocalInt(oDeck, "TOTAL_CARDS", iTotalDiscards + iTotalCards);
		
		// Announce what happened.
		sFloatyText = sPlayerColor + GetName(oPC) + SHUFFLE_TEXT;
		SendMessageToPlayers(oDeck, sFloatyText);
		// Play SFX.
		PlaySound("tkl_cardgame_shuffle");
		// Refresh the players, in case some people have logged off or left the room.
		DelayCommand(0.1f, RefreshPlayers(oPC));
		// Refresh the cards as well.
		DelayCommand(0.2f, RefreshCards(oPC));
	}
	
	// The PC closes or ESC's from the GUI.
	else if (sOption == "CLOSE")
	{
		CloseGUIScreen(oPC, sScreenName);
	}
	
	// The PC opens/closes a Player pane.
	else if (sOption == "PLAYER")
	{
		string sPlayer = IntToString(iRow);
		if (GetLocalInt(oPC, sScreenName + "DISPLAY_PLAYER_" + sPlayer))
		{
			SetGUIObjectHidden(oPC, sScreenName, "Player" + sPlayer + "Pane", TRUE);
			DeleteLocalInt(oPC, sScreenName + "DISPLAY_PLAYER_" + sPlayer);
		}
		else
		{
			SetGUIObjectHidden(oPC, sScreenName, "Player" + sPlayer + "Pane", FALSE);
			SetLocalInt(oPC, sScreenName + "DISPLAY_PLAYER_" + sPlayer, TRUE);
		}
	}
	
	// The PC opens/closes the Board pane.
	else if (sOption == "BOARD")
	{
		if (GetLocalInt(oPC, sScreenName + "BOARD_DISPLAY"))
		{
			SetGUIObjectHidden(oPC, sScreenName, "Player5Pane", TRUE);
			DeleteLocalInt(oPC, sScreenName + "BOARD_DISPLAY");
		}
		else
		{
			SetGUIObjectHidden(oPC, sScreenName, "Player5Pane", FALSE);
			SetLocalInt(oPC, sScreenName + "BOARD_DISPLAY", TRUE);
		}
	}
	
	// The PC draws a card face-up onto the communal "board".
	// For comments, see the "DRAW" option, it's pretty much the same.
	else if (sOption == "DRAW_TO_BOARD")
	{
		int iCardsInDeck = GetLocalInt(oDeck, "TOTAL_CARDS");
		int iCardsOnTable = GetLocalInt(oBoard, "CARDS_ON_TABLE");
		if (iCardsOnTable >= 10)
		{
			SendMessageToPC(oPC, "The board is full at 10 cards.");
			return;
		}
		if (iCardsInDeck == 0)
		{
			SendMessageToPC(oPC, "The deck is empty.");
			return;
		}
		int iRandomCard = 1 + Random(iCardsInDeck);
		int i = 1;
		object oCard = GetFirstItemInInventory(oDeck);
		while (i < iRandomCard)
		{
			oCard = GetNextItemInInventory(oDeck);
			i++;
		}
		object oDrawn = CopyItem(oCard, oBoard);
		string sDrawnName = GetName(oDrawn);
		DestroyObject(oCard);
		SetLocalInt(oDeck, "TOTAL_CARDS", iCardsInDeck - 1);
		sFloatyText = sPlayerColor + GetName(oPC) + DRAW_TO_BOARD_TEXT + sDrawnName + ".</c>";
		SendMessageToPlayers(oDeck, sFloatyText);
		//string sIcon = GetTag(oDrawn) + ".tga";
		//SetGUITexture(oPC, sScreenName, "InfoImage", sIcon);
		ChangeCardInfo(oPC, oDrawn);
		PlaySound("tkl_cardgame_drawtable");
		DelayCommand(0.1f, RefreshCards(oPC));		
	}
	
	// The PC discards a card from the communal "board".
	// For comments see the "DISCARD" option, it's pretty much the same.
	else if (sOption == "DISCARD_FROM_BOARD")
	{
		object oCard = GetLocalObject(oBoard, "TABLE_ROW_" + IntToString(iRow + 1));
		if (!GetIsObjectValid(oCard))
		{
			SendMessageToPC(oPC, "You must select a card on the board to discard.");
			return;
		}
		object oDiscarded = CopyItem(oCard, oDiscard);
		string sCardName = GetName(oCard);
		int iTotalDiscards = GetLocalInt(oDiscard, "TOTAL_CARDS");
		iTotalDiscards++;
		SetLocalObject(oDiscard, "DISCARD" + IntToString(iTotalDiscards), oDiscarded);
		SetLocalInt(oDiscard, "TOTAL_CARDS", iTotalDiscards);
		
		DestroyObject(oCard);
		DelayCommand(0.1f, RefreshCards(oPC));
		object oNextCard = GetLocalObject(oBoard, "TABLE_ROW_" + IntToString(iRow + 2));
		if (GetIsObjectValid(oNextCard))
			ChangeCardInfo(oPC, oNextCard);
		sFloatyText = sPlayerColor + GetName(oPC) + DISCARD_FROM_BOARD_TEXT + sCardName + ".</c>";
		SendMessageToPlayers(oDeck, sFloatyText);
		PlaySound("tkl_cardgame_discardtable");
	}
	
	// Display a larger image of a card on the board.
	else if (sOption == "ZOOM_BOARD")
	{
		object oCard = GetLocalObject(oBoard, "TABLE_ROW_" + IntToString(iRow + 1));
		ChangeCardInfo(oPC, oCard);
	}
	
	// Display a larger image of the top discard.
	else if (sOption == "ZOOM_DISCARD")
	{
		int iTotalDiscards = GetLocalInt(oDiscard, "TOTAL_CARDS");
		if (iTotalDiscards > 0)
		{
			object oCard = GetLocalObject(oDiscard, "DISCARD" + IntToString(iTotalDiscards));
			ChangeCardInfo(oPC, oCard);
		}
	}
	
	// Display the description of the card.
	else if (sOption == "DESCRIPTION")
	{
		if (GetLocalInt(oPC, sScreenName + "CARD_DESCRIPTION_DISPLAY"))
		{
			SetGUIObjectHidden(oPC, sScreenName, "CardDescriptionPane", TRUE);
			DeleteLocalInt(oPC, sScreenName + "CARD_DESCRIPTION_DISPLAY");
		}
		else
		{
			SetGUIObjectHidden(oPC, sScreenName, "CardDescriptionPane", FALSE);
			SetLocalInt(oPC, sScreenName + "CARD_DESCRIPTION_DISPLAY", TRUE);
		}
	}
	
	// Display the larger image of the card.
	else if (sOption == "INFO")
	{
		if (GetLocalInt(oPC, sScreenName + "CARD_INFO_DISPLAY"))
		{
			SetGUIObjectHidden(oPC, sScreenName, "CardInfoPane", TRUE);
			DeleteLocalInt(oPC, sScreenName + "CARD_INFO_DISPLAY");
		}
		else
		{
			SetGUIObjectHidden(oPC, sScreenName, "CardInfoPane", FALSE);
			SetLocalInt(oPC, sScreenName + "CARD_INFO_DISPLAY", TRUE);
		}
	}
	
	// Add gold to a PC's bank.
	else if (sOption == "BANK_ADD")
	{
		int iBankTotal = GetLocalInt(oPC, "BANK_TOTAL");
		int iGP = GetGold(oPC);
		int iMax = iGP - iBankTotal;
		string sLast = IntToString(GetLocalInt(oPC, "BANK_LAST"));
		if (iMax <= 0)
		{
			SendMessageToPC(oPC, "You need some more gold before you can add to your bank.");
			return;
		}
		string sText = "How much do you want to add to your bank? (up to " +
			IntToString(iMax) + ")";
		if (sLast == "0")
			DisplayInputBox(oPC, 0, sText, "gui_tkl_cardgame_bank");
		else
			DisplayInputBox(oPC, 0, sText, "gui_tkl_cardgame_bank", "", TRUE, "SCREEN_STRINGINPUT_MESSAGEBOX", 0, "OK", 0, "CANCEL", sLast); 
	}
	
	// Add gold to a PC's bets.
	else if (sOption == "POT_ADD")
	{
		int iBankTotal = GetLocalInt(oPC, "BANK_TOTAL");
		int iPotTotal = GetLocalInt(oPC, "POT_TOTAL");
		int iMax = iBankTotal - iPotTotal;
		string sLast = IntToString(GetLocalInt(oPC, "POT_LAST"));
		if (iMax <= 0)
		{
			SendMessageToPC(oPC, "You need to put some gold into your bank before you can make a bet.");
			return;
		}
		string sText = "How much do you want to bet? (up to " +
			IntToString(iMax) + ")";
		if (sLast == "0")
			DisplayInputBox(oPC, 0, sText, "gui_tkl_cardgame_pot");
		else
			DisplayInputBox(oPC, 0, sText, "gui_tkl_cardgame_pot", "", TRUE, "SCREEN_STRINGINPUT_MESSAGEBOX", 0, "OK", 0, "CANCEL", sLast); 
	}
	
	// Clear a PC's bank to 0.
	else if (sOption == "BANK_CLEAR")
	{
		string sName = GetName(oPC);
		string sHisOrHer = HisOrHer(oPC);
		int iBank = GetLocalInt(oPC, "BANK_TOTAL");	
		DeleteLocalInt(oPC, "BANK_TOTAL");
		DeleteLocalInt(oPC, "POT_TOTAL");
		SendMessageToPlayers(oDeck, sPlayerColor + sName + "</c>" + BANK_CLEAR_TEXT +
			sHisOrHer + " bank: </i></c>"  + IntToString(iBank) + " gold."); 
		RefreshBets(oPC);
	}
	
	// Clear a PC's bets to 0.
	else if (sOption == "POT_CLEAR")
	{
		string sName = GetName(oPC);
		string sHisOrHer = HisOrHer(oPC);
		int iPot = GetLocalInt(oPC, "POT_TOTAL");
		DeleteLocalInt(oPC, "POT_TOTAL");
		SendMessageToPlayers(oDeck, sPlayerColor + sName + "</c>" + POT_CLEAR_TEXT +
			sHisOrHer + " bets: </i></c>" + IntToString(iPot) + " gold."); 
		RefreshBets(oPC);
	}
	
	// Take the gold that has been bet by a particular player.
	else if (sOption == "POT_TAKE")
	{
		object oLoser = GetLocalObject(oDeck, "CARD_PLAYER_" + IntToString(iRow));
		if (!GetIsObjectValid(oLoser))
		{
			SendMessageToPC(oPC, "There is not a player in that seat.");
			return;
		}
		string sLoserName = GetName(oLoser);
		string sWinnerName = GetName(oPC);
		int iPot = GetLocalInt(oLoser, "POT_TOTAL");
		if (iPot == 0)
		{
			SendMessageToPC(oPC, sLoserName + " does not have any gold in " + HisOrHer(oLoser) +
				" pot.");
			return;
		}
		string sLoserColor = GetPlayerColor(iRow);
		TakeGoldFromCreature(iPot, oLoser);
		DeleteLocalInt(oLoser, "POT_TOTAL");
		int iBank = GetLocalInt(oPC, "BANK_TOTAL");
		iBank += iPot;
		SetLocalInt(oPC, "BANK_TOTAL", iBank);
		SetLocalInt(oLoser, "BANK_TOTAL", GetLocalInt(oLoser, "BANK_TOTAL") - iPot);
		SendMessageToPlayers(oDeck, sPlayerColor + sWinnerName + "</c><color=silver><i> takes</c> " +
			sLoserColor + sLoserName + "'s bets: </c></i>" + IntToString(iPot) + " gold.");
		RefreshBets(oPC);
		RefreshBets(oLoser); 	
	}
	
	// Take ALL gold that has been bet by players.
	else if (sOption == "TAKE_ALL_POTS")
	{
		object oLoser;
		string sName = GetName(oPC);
		int iPot;
		int iWinnings;
		int i;
		
		for (i = 1; i <= 4; i++)
		{
			oLoser = GetLocalObject(oDeck, "CARD_PLAYER_" + IntToString(i));
			if (GetIsObjectValid(oLoser) && oLoser != oPC)
			{
				iPot = GetLocalInt(oLoser, "POT_TOTAL");
				TakeGoldFromCreature(iPot, oLoser);
				DeleteLocalInt(oLoser, "POT_TOTAL");
				SetLocalInt(oLoser, "BANK_TOTAL", GetLocalInt(oLoser, "BANK_TOTAL") - iPot);
				iWinnings += iPot;
				RefreshBets(oLoser);
			}
		}
		
		if (iWinnings > 0)
		{
			int iBank = GetLocalInt(oPC, "BANK_TOTAL");
			iBank += iWinnings;
			SetLocalInt(oPC, "BANK_TOTAL", iBank);
			iWinnings += GetLocalInt(oPC, "POT_TOTAL");
		}
		else
			iWinnings = GetLocalInt(oPC, "POT_TOTAL");
			
		DeleteLocalInt(oPC, "POT_TOTAL");
		SendMessageToPlayers(oDeck, sPlayerColor + sName + "</c>" + ALL_POTS_TEXT +
			IntToString(iWinnings) + " gold.");
		RefreshBets(oPC);		
	}
	
	// Display the instructions.
	else if (sOption == "HELP")
	{
		ActionExamine(oDeck);
	}
	
	// Pass the turn to a particular player.
	else if (sOption == "PASS")
	{
		object oPassee = GetLocalObject(oDeck, "CARD_PLAYER_" + IntToString(iRow));
		if (!GetIsObjectValid(oPassee))
		{
			SendMessageToPC(oPC, "There is not a player in that seat.");
			return;
		}
		if (oPC == oPassee)
			return;
		string sPassee = GetName(oPassee);
		string sPasser = GetName(oPC);
		string sPasseeColor = GetPlayerColor(iRow);
		SendMessageToPlayers(oDeck, sPlayerColor + sPasser + "</c>" + PASS_TEXT +
			sPasseeColor + sPassee + ".</c>");
	}
}
