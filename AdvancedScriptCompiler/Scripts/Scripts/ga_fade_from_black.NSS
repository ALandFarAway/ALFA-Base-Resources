// ga_fade_from_black
// 
// wrapper function for FadeToBlackParty() to fade all party members from black.  If the screen
// had previously faded into a specific color, FadeToBlackParty() will fade back from that color.
//
// fSpeed controls how quickly, in seconds, the screen will fade to black.  Setting this to 0 will 
// result in an instant fade from black.  Standard value is 1.0.
//
// bColor allows users to specify what color the screen should fade back from.  Basic colorlist:
// 0 = black	
// Note: bColor
//	
// CGaw 2/13/06 - Created.

#include "ginc_cutscene"
	
void main(float fSpeed)
{
    object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());

	FadeToBlackParty(oPC, 0, fSpeed);
}