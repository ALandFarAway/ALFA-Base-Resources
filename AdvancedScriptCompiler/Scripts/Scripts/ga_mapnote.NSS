
//ga_mapnote

//  Turns on and off map notes on the mini-map.
//		sTag - Tag of the mapnote to turn on or off
//		bActive - TRUE(1) will turn the map note on, making it visible to the player
//				  FALSE(0) will turn off the map note, making it invisible to the player


#include "ginc_param_const"

void main(string sTag, int bActive)
{
	SetMapPinEnabled(GetTarget(sTag),bActive);
}