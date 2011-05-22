//:://////////////////////////////////////////////////
//:: X0_D1_HEN_FIRED
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////////
/*
Fires the current henchman and leaves the player with
no henchman.
 */
//:://////////////////////////////////////////////////
//:: Created By: Naomi Novik
//:: Created On: 09/13/2002
//:://////////////////////////////////////////////////


#include "x0_i0_henchman"

void main()
{   ClearAllActions();
    FireHenchman(GetPCSpeaker());
}
