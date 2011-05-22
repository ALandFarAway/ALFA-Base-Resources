// gc_check_level
/*
    This script checks to see if the PC's level is equal to or greater than a value
        nLevel  = The tag name you want to check to see if the PC has
        nMP     = If in MP - set this to 1 if you want to make sure all players are
                  the appropriate level
*/
// FAB 10/5

int StartingConditional(int nLevel, int nMP)
{

    object oPC = GetPCSpeaker();

    if ( nMP == 0 )
    {
        if ( GetHitDice(oPC) >= nLevel ) return TRUE;
    }
    else
    {
        oPC = GetFirstPC();
        while( GetIsObjectValid(oPC) )
        {
            if( GetHitDice(oPC) < nLevel ) return FALSE;
            oPC = GetNextPC();
        }
        return TRUE;
    }

    return FALSE;

}
