// gc_is_male
/*
    This checks to see if the PC Speaker is male, returns TRUE if it's a boy
*/
// FAB 10/11

int StartingConditional()
{

    object oPC = GetPCSpeaker();

    if ( GetGender(oPC) == GENDER_MALE ) return TRUE;

    return FALSE;

}
