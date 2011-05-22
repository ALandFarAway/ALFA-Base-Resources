//gb_statue_conv
/*
  OnConversation event handler for statue creatures.
  
*/
// ChazM 3/30/07

#include "nw_i0_generic"
#include "ginc_behavior"

//  The defualt handler won't have creatures talk when they are petrified
//  and also the commandable stuff causes problems.
void main()
{
	PrettyDebug("NW_C2_DEFAULT4");
    ClearActions(CLEAR_NW_C2_DEFAULT4_29);
	
    BeginConversation();
	//SetFacing(GetFacing(OBJECT_SELF), TRUE);	
    return;
}	