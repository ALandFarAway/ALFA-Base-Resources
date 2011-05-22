//::///////////////////////////////////////////////
//:: Naked
//:: NW_D2_GNaked
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does a check to see if the PC talking to
    the character has nothing in his chest slot
    (no armor or clothing)
    25% chance of going down to next priority
*/
//:://////////////////////////////////////////////
//:: Created By: David Gaider
//:: Created On: November 7, 2001
//:://////////////////////////////////////////////

int StartingConditional()
{
    if ((GetLocalInt(OBJECT_SELF,"counter")!=1) && (GetLocalInt(OBJECT_SELF,"counter")!=2))
    {
        int roll=d100();
        if (roll>33)
        {
            object oItem=GetItemInSlot(INVENTORY_SLOT_CHEST,GetPCSpeaker());
            if(!GetIsObjectValid(oItem))
            {
                return TRUE;
            }
            return FALSE;
        }
        return FALSE;
    }
    return FALSE;
}

