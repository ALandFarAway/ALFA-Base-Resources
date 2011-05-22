//	gtr_terrain_ex
/* 
	On Exit script for a terrain trigger:
	- Sets encounter spawn timer back to 0.
*/

#include "ginc_overland"	
		
void main()
{
	SetLocalInt(OBJECT_SELF, VAR_ENC_TIMER, 0);
}