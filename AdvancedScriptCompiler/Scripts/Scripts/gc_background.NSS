// gc_background
//
// Check background trait for the PC.  Background constants are as follows:

//  BACKGROUND_NONE			    = 0;
//  BACKGROUND_BULLY			= 1;
//  BACKGROUND_COMPLEX			= 2;
//  BACKGROUND_DEVOUT			= 3;
//  BACKGROUND_FARMER			= 4;
//  BACKGROUND_LADYSMAN			= 5;
//  BACKGROUND_THEFLIRT			= 6;
//  BACKGROUND_MILITIA			= 7;
//  BACKGROUND_NATURALLEADER	= 8;
//  BACKGROUND_TALETELLER		= 9;
//  BACKGROUND_TROUBLEMAKER		= 10;
//  BACKGROUND_WILDCHILD		= 11;
//  BACKGROUND_WIZARDSAPPRENTICE	= 12;
	
// EPF 2/22/06
	
int StartingConditional(int nBackground)
{
	object oPC = GetFactionLeader(GetPCSpeaker());
	
	return GetCharBackground(oPC) == nBackground;
}