// gc_is_female
/*
    This checks to see if the PC Speaker is female, returns TRUE if it's a girl
*/
// FAB 10/11

int StartingConditional()
{

    object oPC = GetPCSpeaker();

    if ( GetGender(oPC) == GENDER_FEMALE ) return TRUE;

    return FALSE;

}
