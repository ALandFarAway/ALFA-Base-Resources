/*
Script: tkl_cardgame_include
Author: brockfanning
Date: 8/15/07
Purpose: Various functions for use by gui_tkl_cardgame and tkl_cardgame_chair.
*/

#include "tkl_cardgame_descriptions"

//****************************CONSTANTS*****************************

const string DRAW_TEXT = 			"<color=white> <i>draws.</i></c></c>";
const string DRAW_FACEUP_TEXT =		"<color=white> <i>draws face-up: </i></c>";
const string DISCARD_TEXT = 		"<color=gray> <i>discards: </i></c>";
const string DISCARD_FACEUP_TEXT =	"<color=gray> <i>discards from table: </i></c>";
const string DRAW_FROM_DISCARD_TEXT =	"<color=white> <i>draws from discard: </i></c>";
const string DRAW_FACEUP_FROM_DISCARD_TEXT =	"<color=white> <i>draws face-up from discard: </i></c>";
const string DEAL_TEXT =			"<color=dimgray> <i>deals to ";
const string TAKE_TEXT =			"<color=lightgrey> <i>takes: </i></c>";
const string PLAY_TEXT =			"<color=lightgrey> <i>plays: </i></c>";
const string SHUFFLE_TEXT =			"<color=white> <i>shuffles discard pile into deck.</i></c></c>";
const string DRAW_TO_BOARD_TEXT =	"<color=lightcoral> <i>draws to board: </i></c>";
const string DISCARD_FROM_BOARD_TEXT =	"<color=coral> <i>discards from board: </i></c>";
const string POT_ADD_TEXT =			"<color=silver> <i>bets: </i></c>";
const string BANK_CLEAR_TEXT =		"<color=gold> <i>clears ";
const string POT_CLEAR_TEXT =		"<color=silver> <i>clears ";
const string ALL_POTS_TEXT =		"<color=silver> <i>takes the pot: </i></c>";
const string PASS_TEXT =			" <i>passes the turn to</i> ";

//**************************PROTOTYPES******************************

// Refresh the card icons for the player's GUI.
void RefreshCards(object oPC);

// Refresh the player names for the player's GUI.
void RefreshPlayers(object oPC);

// Return the screen name for the GUI of the given player.
string GetScreenName(int iPlayer);

// Return the XML file for the GUI of the given player.
string GetXMLFile(int iPlayer);

// Reset the game by moving all cards back to the deck.
void ResetGame(object oPC);

// Refresh the card icons for the Board area of the game.
void RefreshBoard(object oPC);

// Get a text color for each player.
string GetPlayerColor(int iPlayer);

// Send a message to all players.
void SendMessageToPlayers(object oDeck, string sMessage);

// Change the card info to a specific card object.
void ChangeCardInfo(object oPC, object oCard);

void RefreshBets(object oPC);

string HisOrHer(object oPC, int bCapitalize = FALSE);

//*****************************IMPLEMENTATION***************************

// Refresh the card icons for the player's GUI.
void RefreshCards(object oPC)
{
	// Gather the various objects and variables from the PC.
	object oDeck = GetLocalObject(oPC, "DECK");
	object oHand = GetLocalObject(oPC, "HAND");
	int iPlayer = GetLocalInt(oPC, "CARD_PLAYER");
	string sPlayer = IntToString(iPlayer);
	
	// Gather the current players using the deck.
	object oPlayer1 = GetLocalObject(oDeck, "CARD_PLAYER_1");
	object oPlayer2 = GetLocalObject(oDeck, "CARD_PLAYER_2");
	object oPlayer3 = GetLocalObject(oDeck, "CARD_PLAYER_3");
	object oPlayer4 = GetLocalObject(oDeck, "CARD_PLAYER_4");
	
	// Declare a bunch of variables to be used later.
	int iCardsInHand, iCardsOnTable;
	string sCardsInHand, sCardsOnTable;
	string sDeckAmount, sDiscardAmount;
	string sName, sIcon;
	string sHandAmountUIObject, sHandAmount;
	string sTableAmountUIObject, sTableAmount;
	string sCardUIObject, sCardTextUIObject;
	string sScreenName = GetScreenName(iPlayer);
	
	// Cycle through the player's hand.
	object oCard = GetFirstItemInInventory(oHand);
	while (GetIsObjectValid(oCard))
	{
		sName = GetName(oCard);
		string sIcon = GetTag(oCard) + "_sm.tga";
		
		// If this card is face-up, set that icon in all players' GUI.
		if (GetLocalInt(oCard, "FACEUP"))
		{
			iCardsOnTable++;
			sCardsOnTable = IntToString(iCardsOnTable);
			sCardUIObject = "Player" + sPlayer + "TableCard" + sCardsOnTable + "Icon";
			SetGUITexture(oPlayer1, "CARDGAME_PLAYER1", sCardUIObject, sIcon);
			SetGUITexture(oPlayer2, "CARDGAME_PLAYER2", sCardUIObject, sIcon);
			SetGUITexture(oPlayer3, "CARDGAME_PLAYER3", sCardUIObject, sIcon);
			SetGUITexture(oPlayer4, "CARDGAME_PLAYER4", sCardUIObject, sIcon);
			// Set a string on the hand object to identify the card later, by row number.
			SetLocalObject(oHand, "TABLE_ROW_" + sCardsOnTable, oCard);	
		}
		// Otherwise it is face-down, so only set it in the current player's GUI.	
		else
		{
			iCardsInHand++;
			sCardsInHand = IntToString(iCardsInHand);
			sCardUIObject = "Player" + sPlayer + "HandCard" + sCardsInHand + "Icon";
			SetGUITexture(oPC, sScreenName, sCardUIObject, sIcon);
			// Set a string on the hand object to identify the card later, by row number.
			SetLocalObject(oHand, "HAND_ROW_" + sCardsInHand, oCard);
		}
		oCard = GetNextItemInInventory(oHand);
	}
	// Calculate the number of cards in the players hand and table.
	sHandAmountUIObject = "Player" + sPlayer + "HandAmount";
	sHandAmount = IntToString(iCardsInHand);	
	sTableAmountUIObject = "Player" + sPlayer + "TableAmount";
	sTableAmount = IntToString(iCardsOnTable);
	SetLocalInt(oHand, "CARDS_IN_HAND", iCardsInHand);
	SetLocalInt(oHand, "CARDS_ON_TABLE", iCardsOnTable);
	
	// Set empty icons for remaining rows if the totals are less than 10.
	if (iCardsInHand < 10)
	{
		iCardsInHand++;
		while (iCardsInHand <= 10)
		{
			sCardsInHand = IntToString(iCardsInHand);
			sCardUIObject = "Player" + sPlayer + "HandCard" + sCardsInHand + "Icon"; 
			SetGUITexture(oPC, sScreenName, sCardUIObject, "");
			DeleteLocalObject(oHand, "HAND_ROW_" + sCardsInHand);
			iCardsInHand++;
		}
	}
	if (iCardsOnTable < 10)
	{
		iCardsOnTable++;
		while (iCardsOnTable <= 10)
		{
			sCardsOnTable = IntToString(iCardsOnTable);
			sCardUIObject = "Player" + sPlayer + "TableCard" + sCardsOnTable + "Icon";
			SetGUITexture(oPlayer1, "CARDGAME_PLAYER1", sCardUIObject, "");
			SetGUITexture(oPlayer2, "CARDGAME_PLAYER2", sCardUIObject, "");
			SetGUITexture(oPlayer3, "CARDGAME_PLAYER3", sCardUIObject, "");
			SetGUITexture(oPlayer4, "CARDGAME_PLAYER4", sCardUIObject, "");
			DeleteLocalObject(oHand, "TABLE_ROW_" + sCardsOnTable);
			iCardsOnTable++;
		}
	}	
	
	// Set the text for the Hand and Table amounts on all players' GUIs.
	SetGUIObjectText(oPlayer1, "CARDGAME_PLAYER1", sHandAmountUIObject, -1, sHandAmount + " cards");
	SetGUIObjectText(oPlayer2, "CARDGAME_PLAYER2", sHandAmountUIObject, -1, sHandAmount + " cards");
	SetGUIObjectText(oPlayer3, "CARDGAME_PLAYER3", sHandAmountUIObject, -1, sHandAmount + " cards");
	SetGUIObjectText(oPlayer4, "CARDGAME_PLAYER4", sHandAmountUIObject, -1, sHandAmount + " cards");
	SetGUIObjectText(oPlayer1, "CARDGAME_PLAYER1", sTableAmountUIObject, -1, sTableAmount + " cards");
	SetGUIObjectText(oPlayer2, "CARDGAME_PLAYER2", sTableAmountUIObject, -1, sTableAmount + " cards");
	SetGUIObjectText(oPlayer3, "CARDGAME_PLAYER3", sTableAmountUIObject, -1, sTableAmount + " cards");
	SetGUIObjectText(oPlayer4, "CARDGAME_PLAYER4", sTableAmountUIObject, -1, sTableAmount + " cards");		

	// Refresh the Discard Pile.
	// Find the last card put into the discard pile and set the appropriate icon.
	object oDiscard = GetLocalObject(oPC, "DISCARD");
	int iTotalDiscards = GetLocalInt(oDiscard, "TOTAL_CARDS");
	if (iTotalDiscards > 0)
	{
		oCard = GetLocalObject(oDiscard, "DISCARD" + IntToString(iTotalDiscards));
		sIcon = GetTag(oCard) + "_sm.tga";
		SetGUITexture(oPlayer1, "CARDGAME_PLAYER1", "Discard1Icon", sIcon);
		SetGUITexture(oPlayer2, "CARDGAME_PLAYER2", "Discard1Icon", sIcon);
		SetGUITexture(oPlayer3, "CARDGAME_PLAYER3", "Discard1Icon", sIcon);
		SetGUITexture(oPlayer4, "CARDGAME_PLAYER4", "Discard1Icon", sIcon);
	}
	// If the discard pile is empty, set an "empty" icon.
	else
	{
		SetLocalInt(oDiscard, "TOTAL_CARDS", 0);
		SetGUITexture(oPlayer1, "CARDGAME_PLAYER1", "Discard1Icon", "inv_slot.tga");
		SetGUITexture(oPlayer2, "CARDGAME_PLAYER2", "Discard1Icon", "inv_slot.tga");
		SetGUITexture(oPlayer3, "CARDGAME_PLAYER3", "Discard1Icon", "inv_slot.tga");
		SetGUITexture(oPlayer4, "CARDGAME_PLAYER4", "Discard1Icon", "inv_slot.tga");
	}
	
	// Set the text for the Deck and Discard amounts on all players' GUIs.
	sDeckAmount = IntToString(GetLocalInt(oDeck, "TOTAL_CARDS"));
	sDiscardAmount = IntToString(iTotalDiscards);
	SetGUIObjectText(oPlayer1, "CARDGAME_PLAYER1", "DiscardAmount", -1, sDiscardAmount + " cards");
	SetGUIObjectText(oPlayer1, "CARDGAME_PLAYER1", "DeckAmount", -1, sDeckAmount + " cards");
	SetGUIObjectText(oPlayer2, "CARDGAME_PLAYER2", "DiscardAmount", -1, sDiscardAmount + " cards");
	SetGUIObjectText(oPlayer2, "CARDGAME_PLAYER2", "DeckAmount", -1, sDeckAmount + " cards");
	SetGUIObjectText(oPlayer3, "CARDGAME_PLAYER3", "DiscardAmount", -1, sDiscardAmount + " cards");
	SetGUIObjectText(oPlayer3, "CARDGAME_PLAYER3", "DeckAmount", -1, sDeckAmount + " cards");
	SetGUIObjectText(oPlayer4, "CARDGAME_PLAYER4", "DiscardAmount", -1, sDiscardAmount + " cards");
	SetGUIObjectText(oPlayer4, "CARDGAME_PLAYER4", "DeckAmount", -1, sDeckAmount + " cards");			

	// Refresh the communal "board" for all players' GUIs.
	object oBoard = GetLocalObject(oPC, "BOARD");
	int iCardsOnBoard;
	string sCardsOnBoard;
	string sBoardAmountUIObject, sBoardAmount;
	// Cycle through the board.
	oCard = GetFirstItemInInventory(oBoard);
	while (GetIsObjectValid(oCard))
	{
		sName = GetName(oCard);
		sIcon = GetTag(oCard) + "_sm.tga";
		
		iCardsOnBoard++;
		sCardsOnBoard = IntToString(iCardsOnBoard);
		sCardUIObject = "Player5TableCard" + sCardsOnBoard + "Icon";

		SetGUITexture(oPlayer1, "CARDGAME_PLAYER1", sCardUIObject, sIcon);
		SetGUITexture(oPlayer2, "CARDGAME_PLAYER2", sCardUIObject, sIcon);
		SetGUITexture(oPlayer3, "CARDGAME_PLAYER3", sCardUIObject, sIcon);
		SetGUITexture(oPlayer4, "CARDGAME_PLAYER4", sCardUIObject, sIcon);
		
		SetLocalObject(oBoard, "TABLE_ROW_" + sCardsOnBoard, oCard);	
		oCard = GetNextItemInInventory(oBoard);
	}
	// Calculate the amount of cards on the board.
	sBoardAmountUIObject = "Player5TableAmount";	
	sBoardAmount = IntToString(iCardsOnBoard);
	SetLocalInt(oBoard, "CARDS_ON_TABLE", iCardsOnBoard);
	// Set any unused slots to an empty icon.
	if (iCardsOnBoard < 10)
	{
		iCardsOnBoard++;
		while (iCardsOnBoard <= 10)
		{
			sCardsOnBoard = IntToString(iCardsOnBoard);
			sCardUIObject = "Player5TableCard" + sCardsOnBoard + "Icon";
			SetGUITexture(oPlayer1, "CARDGAME_PLAYER1", sCardUIObject, "");
			SetGUITexture(oPlayer2, "CARDGAME_PLAYER2", sCardUIObject, "");
			SetGUITexture(oPlayer3, "CARDGAME_PLAYER3", sCardUIObject, "");
			SetGUITexture(oPlayer4, "CARDGAME_PLAYER4", sCardUIObject, "");
			DeleteLocalObject(oBoard, "TABLE_ROW_" + sCardsOnBoard);
			iCardsOnBoard++;
		}
	}	
	// Set the text for the Board amount in all players' GUIs.	
	SetGUIObjectText(oPlayer1, "CARDGAME_PLAYER1", sBoardAmountUIObject, -1, sBoardAmount + " cards");
	SetGUIObjectText(oPlayer2, "CARDGAME_PLAYER2", sBoardAmountUIObject, -1, sBoardAmount + " cards");
	SetGUIObjectText(oPlayer3, "CARDGAME_PLAYER3", sBoardAmountUIObject, -1, sBoardAmount + " cards");
	SetGUIObjectText(oPlayer4, "CARDGAME_PLAYER4", sBoardAmountUIObject, -1, sBoardAmount + " cards");		
}

// Refresh the player names for the player's GUI.
void RefreshPlayers(object oPC)
{
	// Gather the nearest Deck and the four players currently using it.
	object oDeck = GetLocalObject(oPC, "DECK");
	object oPlayer1 = GetLocalObject(oDeck, "CARD_PLAYER_1");
	object oPlayer2 = GetLocalObject(oDeck, "CARD_PLAYER_2");
	object oPlayer3 = GetLocalObject(oDeck, "CARD_PLAYER_3");
	object oPlayer4 = GetLocalObject(oDeck, "CARD_PLAYER_4");
	string sName1;
	string sName2;
	string sName3;
	string sName4;

	// Make sure each player is still online and is within 5 meters.	
	if (GetIsObjectValid(oPlayer1) && GetDistanceBetween(oPlayer1, oDeck) < 5.0)
		sName1 = GetName(oPlayer1);
	else
	{
		sName1 = "[empty seat]";
		DeleteLocalObject(oDeck, "CARD_PLAYER_1");
		SendMessageToPC(oPlayer1, "You are too far away to play cards.");
	}
		
	if (GetIsObjectValid(oPlayer2) && GetDistanceBetween(oPlayer2, oDeck) < 5.0)
		sName2 = GetName(oPlayer2);
	else
	{
		sName2 = "[empty seat]";
		DeleteLocalObject(oDeck, "CARD_PLAYER_2");
		SendMessageToPC(oPlayer2, "You are too far away to play cards.");
	}
		
	if (GetIsObjectValid(oPlayer3) && GetDistanceBetween(oPlayer3, oDeck) < 5.0)
		sName3 = GetName(oPlayer3);
	else
	{
		sName3 = "[empty seat]";
		DeleteLocalObject(oDeck, "CARD_PLAYER_3");
		SendMessageToPC(oPlayer3, "You are too far away to play cards.");
	}
		
	if (GetIsObjectValid(oPlayer4) && GetDistanceBetween(oPlayer4, oDeck) < 5.0)
		sName4 = GetName(oPlayer4);
	else
	{
		sName4 = "[empty seat]";
		DeleteLocalObject(oDeck, "CARD_PLAYER_4");
		SendMessageToPC(oPlayer4, "You are too far away to play cards.");
	}	

	// For each player that is currently playing, set the text for all 4 seats in his or her GUI.	
	if (sName1 != "[empty seat]")
	{
		SetGUIObjectText(oPlayer1, "CARDGAME_PLAYER1", "Player1Button", -1, sName1);
		SetGUIObjectText(oPlayer1, "CARDGAME_PLAYER1", "Player2Button", -1, sName2);
		SetGUIObjectText(oPlayer1, "CARDGAME_PLAYER1", "Player3Button", -1, sName3);
		SetGUIObjectText(oPlayer1, "CARDGAME_PLAYER1", "Player4Button", -1, sName4);
	}
	
	if (sName2 != "[empty seat]")
	{
		SetGUIObjectText(oPlayer2, "CARDGAME_PLAYER2", "Player1Button", -1, sName1);
		SetGUIObjectText(oPlayer2, "CARDGAME_PLAYER2", "Player2Button", -1, sName2);
		SetGUIObjectText(oPlayer2, "CARDGAME_PLAYER2", "Player3Button", -1, sName3);
		SetGUIObjectText(oPlayer2, "CARDGAME_PLAYER2", "Player4Button", -1, sName4);
	}

	if (sName3 != "[empty seat]")
	{
		SetGUIObjectText(oPlayer3, "CARDGAME_PLAYER3", "Player1Button", -1, sName1);
		SetGUIObjectText(oPlayer3, "CARDGAME_PLAYER3", "Player2Button", -1, sName2);
		SetGUIObjectText(oPlayer3, "CARDGAME_PLAYER3", "Player3Button", -1, sName3);
		SetGUIObjectText(oPlayer3, "CARDGAME_PLAYER3", "Player4Button", -1, sName4);
	}
	
	if (sName4 != "[empty seat]")
	{
		SetGUIObjectText(oPlayer4, "CARDGAME_PLAYER4", "Player1Button", -1, sName1);
		SetGUIObjectText(oPlayer4, "CARDGAME_PLAYER4", "Player2Button", -1, sName2);
		SetGUIObjectText(oPlayer4, "CARDGAME_PLAYER4", "Player3Button", -1, sName3);
		SetGUIObjectText(oPlayer4, "CARDGAME_PLAYER4", "Player4Button", -1, sName4);
	}		
}

// Return the screen name for the GUI of the given player.
string GetScreenName(int iPlayer)
{
	string sScreenName;
	if (iPlayer == 1)
		sScreenName = "CARDGAME_PLAYER1";
	else if (iPlayer == 2)
		sScreenName = "CARDGAME_PLAYER2";
	else if (iPlayer == 3)
		sScreenName = "CARDGAME_PLAYER3";
	else if (iPlayer == 4)
		sScreenName = "CARDGAME_PLAYER4";
	return sScreenName;
}

// Return the XML file for the GUI of the given player.
string GetXMLFile(int iPlayer)
{
	string sXMLFile;
	if (iPlayer == 1)
		sXMLFile = "tkl_cardgame_player1.xml";
	else if (iPlayer == 2)
		sXMLFile = "tkl_cardgame_player2.xml";
	else if (iPlayer == 3)
		sXMLFile = "tkl_cardgame_player3.xml";
	else if (iPlayer == 4)
		sXMLFile = "tkl_cardgame_player4.xml";
	return sXMLFile;
}

// Reset the game by moving all cards back to the deck.
void ResetGame(object oPC)
{
	// Declare the variables and locate the deck.
	object oCard, oNew, oPlace;
	float fDelay = 0.01f;
	object oDeck = GetLocalObject(oPC, "DECK");
	
	// Start by moving all cards from the discard pile back to the deck.
	oPlace =  GetLocalObject(oPC, "DISCARD");
	oCard = GetFirstItemInInventory(oPlace);
	while (GetIsObjectValid(oCard))
	{
		fDelay += 0.01f;
		oNew = CopyItem(oCard, oDeck);
		DestroyObject(oCard, fDelay);
		oCard = GetNextItemInInventory(oPlace);
	}
	SetLocalInt(oPlace, "TOTAL_CARDS", 0);
	
	// Next move all cards from the board.
	oPlace =  GetLocalObject(oPC, "BOARD");
	oCard = GetFirstItemInInventory(oPlace);
	while (GetIsObjectValid(oCard))
	{
		fDelay += 0.01f;
		oNew = CopyItem(oCard, oDeck);
		DestroyObject(oCard, fDelay);
		oCard = GetNextItemInInventory(oPlace);
	}
	
	// Next, the chairs.
	int i;
	for (i = 1; i <= 4; i++)
	{
		oPlace = GetNearestObjectByTag("p_cards_chair" + IntToString(i), oDeck);
		oCard = GetFirstItemInInventory(oPlace);
		while (GetIsObjectValid(oCard))
		{
			fDelay += 0.01f;
			oNew = CopyItem(oCard, oDeck);
			DestroyObject(oCard, fDelay);
			oCard = GetNextItemInInventory(oPlace);
		}
	}
	
	// Reset bets and banks
	DeleteLocalInt(oPC, "BANK_TOTAL");
	DeleteLocalInt(oPC, "POT_TOTAL");
	RefreshBets(oPC);
	
	// Set the deck as having 52 cards, and refresh the cards for the PC.
	SetLocalInt(oDeck, "TOTAL_CARDS", GetLocalInt(oDeck, "STARTING_CARDS"));
	DelayCommand(fDelay * 2.0, RefreshCards(oPC));		
}

// Get a text color for each player.
string GetPlayerColor(int iPlayer)
{
	string sTextColor;
	if (iPlayer == 1)
		sTextColor = "<color=lightgreen>";
	else if (iPlayer == 2)
		sTextColor = "<color=lightblue>";
	else if (iPlayer == 3)
		sTextColor = "<color=pink>";
	else if (iPlayer == 4)
		sTextColor = "<color=orange>";
	return sTextColor;
}

// Send a message to all players.
void SendMessageToPlayers(object oDeck, string sMessage)
{
	object oPlayer1 = GetLocalObject(oDeck, "CARD_PLAYER_1");
	object oPlayer2 = GetLocalObject(oDeck, "CARD_PLAYER_2");
	object oPlayer3 = GetLocalObject(oDeck, "CARD_PLAYER_3");
	object oPlayer4 = GetLocalObject(oDeck, "CARD_PLAYER_4");
	
	SendMessageToPC(oPlayer1, sMessage);
	SendMessageToPC(oPlayer2, sMessage);
	SendMessageToPC(oPlayer3, sMessage);
	SendMessageToPC(oPlayer4, sMessage);
}

// Refresh the large card image and card info to a specific card for a specific player.
void ChangeCardInfo(object oPC, object oCard)
{
	if (!GetIsObjectValid(oCard))
		return;
	string sIcon = GetTag(oCard) + ".tga";
	int iPlayer = GetLocalInt(oPC, "CARD_PLAYER");
	string sScreenName = GetScreenName(iPlayer);
	SetGUITexture(oPC, sScreenName, "InfoImage", sIcon);
	string sDescription = GetCardDescription(oCard);
	SetGUIObjectText(oPC, sScreenName, "CardDescriptionText", -1, sDescription);
	string sName = GetName(oCard);
	SetGUIObjectText(oPC, sScreenName, "CardInfoText", -1, "<color=black>" + sName + "</c>");	
}

void RefreshBets(object oPC)
{
	int iPlayer = GetLocalInt(oPC, "CARD_PLAYER");
	string sPlayer = IntToString(iPlayer); 
	object oDeck = GetLocalObject(oPC, "DECK");
	// Gather the current players using the deck.
	object oPlayer1 = GetLocalObject(oDeck, "CARD_PLAYER_1");
	object oPlayer2 = GetLocalObject(oDeck, "CARD_PLAYER_2");
	object oPlayer3 = GetLocalObject(oDeck, "CARD_PLAYER_3");
	object oPlayer4 = GetLocalObject(oDeck, "CARD_PLAYER_4");
	// Calculate the total pot.
	int iAllPots = 	GetLocalInt(oPlayer1, "POT_TOTAL") +
					GetLocalInt(oPlayer2, "POT_TOTAL") +
					GetLocalInt(oPlayer3, "POT_TOTAL") +
					GetLocalInt(oPlayer4, "POT_TOTAL");	
	string sAllPotsText = IntToString(iAllPots) + " gp";
	// Get the Bets and Bank for this PC.
	int iPot = GetLocalInt(oPC, "POT_TOTAL");
	int iBank = GetLocalInt(oPC, "BANK_TOTAL");
	string sPotText = "0 gp";
	string sBankText = "0 gp";
	if (iPot > 0)
		sPotText = IntToString(iPot) + " gp";
	if (iBank > 0)
		sBankText = IntToString(iBank) + " gp";
	// Set the UI text fields for all players.
	SetGUIObjectText(oPlayer1, "CARDGAME_PLAYER1", "PotTextPlayer" + sPlayer, -1, sPotText);
	SetGUIObjectText(oPlayer2, "CARDGAME_PLAYER2", "PotTextPlayer" + sPlayer, -1, sPotText);
	SetGUIObjectText(oPlayer3, "CARDGAME_PLAYER3", "PotTextPlayer" + sPlayer, -1, sPotText);
	SetGUIObjectText(oPlayer4, "CARDGAME_PLAYER4", "PotTextPlayer" + sPlayer, -1, sPotText);
	SetGUIObjectText(oPlayer1, "CARDGAME_PLAYER1", "BankTextPlayer" + sPlayer, -1, sBankText);
	SetGUIObjectText(oPlayer2, "CARDGAME_PLAYER2", "BankTextPlayer" + sPlayer, -1, sBankText);
	SetGUIObjectText(oPlayer3, "CARDGAME_PLAYER3", "BankTextPlayer" + sPlayer, -1, sBankText);
	SetGUIObjectText(oPlayer4, "CARDGAME_PLAYER4", "BankTextPlayer" + sPlayer, -1, sBankText);			
	SetGUIObjectText(oPlayer1, "CARDGAME_PLAYER1", "AllPotsText", -1, sAllPotsText);
	SetGUIObjectText(oPlayer2, "CARDGAME_PLAYER2", "AllPotsText", -1, sAllPotsText);
	SetGUIObjectText(oPlayer3, "CARDGAME_PLAYER3", "AllPotsText", -1, sAllPotsText);
	SetGUIObjectText(oPlayer4, "CARDGAME_PLAYER4", "AllPotsText", -1, sAllPotsText);
}

// A script to correctly return 'his' or 'her' based on the PC's gender.
string HisOrHer(object oPC, int bCapitalize = FALSE)
{
	if (GetGender(oPC) == GENDER_MALE)
	{
		if (bCapitalize)
			return "His";
		else
			return "his";
	}
	else
	{
		if (bCapitalize)
			return "Her";
		else
			return "her";
	}
}