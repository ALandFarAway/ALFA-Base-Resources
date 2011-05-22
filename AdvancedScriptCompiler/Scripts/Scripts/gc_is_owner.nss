// gc_is_owner
/*
    This script checks if the owner of the dialogue is the given tag
        sTag        = This is the tag of the object you are checking for
*/
// TDE 2/22/05
// ChazM 3/10/05

int StartingConditional(string sTag)
{
    if (GetTag(OBJECT_SELF) == sTag)
        return TRUE;

    return FALSE;
}


