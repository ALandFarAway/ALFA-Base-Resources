/*
Author: brockfanning
Date: Early 2008...
Purpose: This clears a few variables if the PC cancels an action.
*/

#include "tkl_performer_include"

void main()
{
	object oPC = OBJECT_SELF;
	ClearTKLPerformerVariables(oPC);
}