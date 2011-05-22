// ga_reputation
/*
    This adjusts the reputation of the calling player
        nActLevel   = How noble or ignoble was the act from +4 (Idolized) to -4 (Vilified)
        nRepOver    = This overides the reputation to the given value (DANGER!)
*/
// FAB 10/12/04

void main(int nActLevel, int nRepOver)
{

    string sActLevel;
    int nRepLevel;      // This is the reputation level of the PC right now
    int nRepValue;      // The straight Reputation Score
    string sRepDelta;   // How much the reputation will change
    int nRepDelta;      // How much the reputation will change
    int nRepShift;      // Used for shifting reputation by a set amount
    object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());

    // CHECK REPUTATION OVERRIDE - apply if set and then bail out of the script
    if ( nRepOver != 0 )
    {
        SetLocalInt( oPC,"Player's Reputation",nRepOver );
        return;
    }

    // Determines the act level for the 2DA check
    switch (nActLevel)
    {
        case -4:        // Vilified Act
            sActLevel = "Vilified";
            break;
        case -3:        // Loathed Act
            sActLevel = "Loathed";
            break;
        case -2:        // Disliked Act
            sActLevel = "Disliked";
            break;
        case -1:        // Unwelcome Act
            sActLevel = "Unwelcome";
            break;
        case 1:         // Known Act
            sActLevel = "Known";
            break;
        case 2:         // Liked Act
            sActLevel = "Liked";
            break;
        case 3:         // Honored Act
            sActLevel = "Honored";
            break;
        case 4:         // Idolized Act
            sActLevel = "Idolized";
            break;
    }

    //int nRepLevel;      // This is the reputation level of the PC right now

    // Look at the PC's current rep to see where they are on the table
    nRepValue = GetLocalInt( oPC,"Player's Reputation" );

    if ( nRepValue <= -110 ) nRepLevel = 8;
    else if ( nRepValue <= -80 ) nRepLevel = 7;
    else if ( nRepValue <= -50 ) nRepLevel = 6;
    else if ( nRepValue <= -25 ) nRepLevel = 5;
    else if ( nRepValue <= 24 ) nRepLevel = 4;
    else if ( nRepValue <= 49 ) nRepLevel = 3;
    else if ( nRepValue <= 79 ) nRepLevel = 2;
    else if ( nRepValue <= 109 ) nRepLevel = 1;
    else nRepLevel = 0;

    sRepDelta = Get2DAString( "Reputation",sActLevel,nRepLevel );

    // This is an alignment shift - so deal with it appropriately
    if ( GetStringLeft(sRepDelta,2) == "S:" )
    {
        nRepShift = StringToInt( GetStringRight( sRepDelta,GetStringLength(sRepDelta)-2 ) );
        switch ( nRepShift )
        {
            case -2:    // Shift reputation to Disliked
                SetLocalInt( oPC,"Player's Reputation",-65 );
                return;
                break;
            case -1:    // Shift reputation to Unwelcome
                SetLocalInt( oPC,"Player's Reputation",-38 );
                return;
                break;
            case 0:    // Shift reputation to Neutral
                SetLocalInt( oPC,"Player's Reputation",0 );
                return;
                break;
            case 1:    // Shift reputation to Known
                SetLocalInt( oPC,"Player's Reputation",38 );
                return;
                break;
            case 2:    // Shift reputation to Liked
                SetLocalInt( oPC,"Player's Reputation",65 );
                return;
                break;
            case 3:    // Shift reputation to Honored
                SetLocalInt( oPC,"Player's Reputation",92 );
                return;
                break;
        }
    }

    nRepDelta = StringToInt( sRepDelta );
    SetLocalInt( oPC,"Player's Reputation",nRepValue + nRepDelta );

}
