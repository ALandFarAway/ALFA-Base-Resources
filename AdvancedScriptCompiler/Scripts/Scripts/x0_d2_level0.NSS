//::///////////////////////////////////////////////
//:: x0_d2_level0
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns true if henchman in default levelup mode
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

int StartingConditional()
{
    if (GetLocalInt(OBJECT_SELF, "X0_L_LEVELRULES") == 0)
    {
        return TRUE;
    }
    return FALSE;
}
