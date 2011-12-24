/*
Author: brockfanning
Date: Early 2008...
Purpose: This launches TKL performer whenever a PC equips this instrument.
*/

#include "tkl_performer_include"

void main()
{
	object oPC = GetPCItemLastEquippedBy();
	SendMessageToPC(oPC, "Loading musical instrument...");
	DelayCommand(1.0, LaunchTKLPerformer(oPC, GetPCItemLastEquipped(), "tkl_performer_lute.xml"));				
}