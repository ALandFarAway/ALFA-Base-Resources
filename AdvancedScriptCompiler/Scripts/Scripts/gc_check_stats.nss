// gc_check_stats
/*
    This script checks to see if the player (PC_Speaker) has stats above a certain number
        nStat   = The integer of which stat to check for (list boxes will be done later)
        nVal    = The value the stat needs to equal or exceed
*/
// FAB 10/11

int StartingConditional(int nStat, int nVal)
{

    object oPC = GetPCSpeaker();
    int nNewStat;

    switch ( nStat )
    {
        case 0:     // Strength
            nNewStat = ABILITY_STRENGTH;
            break;
        case 1:     // Dexterity
            nNewStat = ABILITY_DEXTERITY;
            break;
        case 2:     // Constitution
            nNewStat = ABILITY_CONSTITUTION;
            break;
        case 3:     // Intelligence
            nNewStat = ABILITY_INTELLIGENCE;
            break;
        case 4:     // Wisdom
            nNewStat = ABILITY_WISDOM;
            break;
        case 5:     // Charisma
            nNewStat = ABILITY_CHARISMA;
            break;
    }

    string sSTR = IntToString( nVal );

    if ( GetAbilityScore(oPC,nNewStat) >= nVal ) return TRUE;

    return FALSE;

}
