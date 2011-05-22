/* HARD check for skill sleight_of_hand */

#include "nw_i0_plot" 

int StartingConditional()
{
	return AutoDC(DC_HARD, SKILL_SLEIGHT_OF_HAND, GetPCSpeaker());
}
