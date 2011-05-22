// gc_reputation
/*
    This checks the reputation of the speaking player
        nRepLevel   = Checks how noble or ignoble the player's rep is from +4 (Idolized) to -4 (Vilified)
        nRepNumber  = See if it is over a specific number value (overrides previous int)
*/
// FAB 10/12/04

int StartingConditional(int nRepLevel, int nRepNumber)
{

    object oPC = GetPCSpeaker();

    if ( nRepNumber != 0 )
    {
        if ( GetLocalInt(oPC,"Player's Reputation") >= nRepNumber ) return TRUE;
        else return FALSE;
    }

    int nRepCurrent;    // This is the reputation level of the PC right now
    int nRepValue;      // The straight Reputation Score
    nRepValue = GetLocalInt( oPC,"Player's Reputation" );

    if ( nRepCurrent <= -110 ) nRepLevel = -4;
    else if ( nRepCurrent <= -80 ) nRepLevel = -3;
    else if ( nRepCurrent <= -50 ) nRepLevel = -2;
    else if ( nRepCurrent <= -25 ) nRepLevel = -1;
    else if ( nRepCurrent <= 24 ) nRepLevel = 0;
    else if ( nRepCurrent <= 49 ) nRepLevel = 1;
    else if ( nRepCurrent <= 79 ) nRepLevel = 2;
    else if ( nRepCurrent <= 109 ) nRepLevel = 3;
    else nRepLevel = 4;

    if ( nRepLevel >= nRepCurrent ) return TRUE;

    return FALSE;

}
