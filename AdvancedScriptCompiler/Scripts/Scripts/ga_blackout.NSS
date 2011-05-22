// ga_blackout
// 
// wrapper function for FadeToBlackParty() to instantly make screen black.  Useful for the
// first node of conversations.

// CGaw & BMa 2/13/06 - Created.

#include "ginc_cutscene"
	
void main()
{
    object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());

	FadeToBlackParty(oPC, 1, 0.0);	
}