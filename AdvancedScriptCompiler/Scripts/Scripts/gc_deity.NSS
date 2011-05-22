// gc_deity(string sDeity)
/*
	Checks the deity of the PC Speaker.
	
	Note: Deity name is not case sensitive.
*/
// ChazM-OEI 3/28/07

int StartingConditional(string sDeity)
{
	sDeity = GetStringUpperCase(sDeity);
	object oPC = GetPCSpeaker();
	string sPCDeity = GetStringUpperCase(GetDeity(oPC));

	return (sDeity == sPCDeity);
}