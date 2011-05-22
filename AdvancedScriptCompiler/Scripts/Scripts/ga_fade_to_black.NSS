// ga_fade_to_black
// 
// wrapper function for FadeToBlackParty() to fade all party members to black.
//
// fSpeed controls how quickly, in seconds, the screen will fade to black.  Setting this to 0 will 
// result in an instant fade to black.
//
// fFailsafe indicates the maximum lenght of time, in seconds, that the screen will remain black
// before automatically fading back in.  Leave at 0.0 to use the default value of 15 seconds.

// nColor allows users to specify what color the screen should fade into.  Basic colorlist:
// 0 = black, 16777215 = white.  Hex Values for colors may be found in NWN2_Colors.2da, though
// they must be converted to decimal form before use.
//
// CGaw 2/13/06 - Created.
// CGaw 3/10/06 - Added color value information.
// ChazM 9/26/06 - changed fFailsafe default.

#include "ginc_cutscene"
#include "ginc_math"
	
void main(float fSpeed, float fFailsafe, int nColor)
{
    object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	
	if (IsFloatNearInt(fFailsafe, 0))
		fFailsafe = 15.0f;

	FadeToBlackParty(oPC, 1, fSpeed, fFailsafe, nColor);	
}