/* MEDIUM check for skill sleight_of_hand */

#include "nw_i0_plot" 

int StartingConditional()
{
	return AutoDC(DC_MEDIUM, SKILL_SLEIGHT_OF_HAND, GetPCSpeaker());
}
