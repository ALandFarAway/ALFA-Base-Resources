/*
Script: gui_tkl_cardgame_pot
Author: brockfanning
Date: 10/01/07
Purpose: GUI script for when a player adds to his or her pot.
*/

#include "tkl_cardgame_include"

void main(string sAmount)
{
	// Set up the variables.
	object oPC = OBJECT_SELF;
	object oDeck = GetLocalObject(oPC, "DECK");
	int iPlayer = GetLocalInt(oPC, "CARD_PLAYER");
	string sPlayerColor = GetPlayerColor(iPlayer);
	string sName = GetName(oPC);
	int iAmount = StringToInt(sAmount);
	int iBankTotal = GetLocalInt(oPC, "BANK_TOTAL");
	int iPotTotal = GetLocalInt(oPC, "POT_TOTAL");
	// A PC can't add more gold than they have left in their bank.
	int iMax = iBankTotal - iPotTotal;
	if (iAmount == 0)
		return;
	if (iAmount > iMax)
	{
		SendMessageToPC(oPC, "You only have " + IntToString(iMax) + " gold in your bank.");
		return;
	}
	else if (iAmount <= 0)
	{
		SendMessageToPC(oPC, "Invalid number.");
		return;
	}
	else
	{
		iPotTotal += iAmount;
		// Set the new value for the PC's pot total.
		SetLocalInt(oPC, "POT_TOTAL", iPotTotal);
		// Set the increase amount as default, to save the PC from having to type it again
		// next time.
		SetLocalInt(oPC, "POT_LAST", iAmount);
		// Tell everybody what happened.
		SendMessageToPlayers(oDeck, sPlayerColor + sName + "</c>" + POT_ADD_TEXT + 
			IntToString(iAmount) + " gold.</c>");
		// Update the GUI on the screen.
		RefreshBets(oPC);
	}
}