/*
Script: gui_tkl_cardgame_bank
Author: brockfanning
Date: 10/01/07
Purpose: GUI script for when a player adds to his or her bank.
*/

#include "tkl_cardgame_include"

void main(string sAmount)
{
	// Set up the variables
	object oPC = OBJECT_SELF;
	object oDeck = GetLocalObject(oPC, "DECK");
	int iPlayer = GetLocalInt(oPC, "CARD_PLAYER");
	string sPlayerColor = GetPlayerColor(iPlayer);
	string sName = GetName(oPC);
	int iAmount = StringToInt(sAmount);
	int iGP = GetGold(oPC);
	int iBankTotal = GetLocalInt(oPC, "BANK_TOTAL");
	// A PC can't add more gold than they have.
	int iMax = iGP - iBankTotal;
	if (iAmount == 0)
		return;
	
	if (iAmount > iMax)
	{
		SendMessageToPC(oPC, "You only have " + IntToString(iMax) + " gold left.");
		return;
	}
	else if (iAmount <= 0)
	{
		SendMessageToPC(oPC, "Invalid number.");
		return;
	}
	else
	{
		iBankTotal += iAmount;
		// Set the new value for the PC's bank total.
		SetLocalInt(oPC, "BANK_TOTAL", iBankTotal);
		// Set the increase amount as default, to save the PC from having to type it again
		// next time.
		SetLocalInt(oPC, "BANK_LAST", iAmount);
		// Tell everybody what happened.
		SendMessageToPlayers(oDeck, sPlayerColor + sName + "</c><color=gold> <i>adds to " +
			HisOrHer(oPC) + " bank: </i></c>" + IntToString(iAmount) + " gold.");
		// Update the GUI on the screen.
		RefreshBets(oPC);
	}
}