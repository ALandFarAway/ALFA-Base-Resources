// gtr_autosave
//
// If the PC enters this trigger, and it's a single-player game, we autosave.

// EPF 6/13/07

#include "ginc_misc"

void main()
{
	object oPC = GetEnteringObject();
	
	if(GetIsPC(oPC) && !IsMarkedAsDone() && GetIsSinglePlayer())
	{
		MarkAsDone();
		DoSinglePlayerAutoSave();
	}
}