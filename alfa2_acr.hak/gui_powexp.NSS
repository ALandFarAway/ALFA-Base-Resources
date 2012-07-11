//========================================================
/*
    New Power Attack and Combat Expertise Granular GUI
    By: Zelknolf
    2012/1/14

    This script handles the toggling of combat expertise
    and power attack at a more-granular level than we find
    in the default NWN2 implementation.
*/
//========================================================

#include "acr_combat_actions_i"

void main ( string sEvent, string sAmount )
{
    int nEvent = StringToInt(sEvent);
    int nAmount = StringToInt(sAmount);
	
	_HandlePowExpGUIEvent( OBJECT_SELF, nEvent, nAmount );
}
