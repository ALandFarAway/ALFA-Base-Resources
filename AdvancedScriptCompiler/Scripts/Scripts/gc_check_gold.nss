// gc_check_gold
/*
    This script checks to see if the PC has more than a certain amount of gold
        nGold   = The amount of gold you want to make sure the player has
        nMP     = If in MP - set this to 1 if you want to make sure all players have enough gold
*/
// FAB 10/5

int StartingConditional(int nGold, int nMP)
{

    object oPC = GetPCSpeaker();

    if ( nMP == 0 )
    {
        if ( GetGold(oPC) >= nGold ) return TRUE;
    }
    else
    {
        oPC = GetFirstPC();
        while( GetIsObjectValid(oPC) )
        {
            if( GetGold(oPC) < nGold ) return FALSE;
            oPC = GetNextPC();
        }
        return TRUE;
    }

    return FALSE;

}
