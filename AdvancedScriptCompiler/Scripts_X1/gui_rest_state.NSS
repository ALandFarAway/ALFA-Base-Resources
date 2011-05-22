// gui_rest_state(int iState)
/*
	Behavior script for resting
	
	state 0 is rest
	state 1 is wait
*/
// ChazM 4/11/08

#include "ginc_restsys"

void main(int iState)
{
	object oPlayerObject = OBJECT_SELF;
	SetRestOptionState(oPlayerObject, iState);
}