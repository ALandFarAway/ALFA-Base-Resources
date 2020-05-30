#include "acr_dropgold_i"

void main(string sAmount)
{
    object oPC = OBJECT_SELF;

    if (sAmount == "")
    {
        SendMessageToPC(oPC, "You cannot drop nothing.");
        return;
    }

    object oGroundGold;
    int nAmount = StringToInt(sAmount);
    location lLoc = GetLocalLocation(oPC, ACR_LAST_GOLD_DROP_LOC);
    string sTemplate;
    // merely randomizing the appearance between a stack of coins and a pile with with a pouch
    if (Random(2))
    {
        sTemplate = "acr_gold_drop_1";
    }
    else
    {
        sTemplate = "acr_gold_drop_2";
    }

    if (GetGold(oPC) >= nAmount && nAmount > 0)
    {
        if (GetDistanceBetweenLocations(GetLocation(oPC), lLoc) <= MAXIMUM_DROP_DISTANCE)
        {
            PlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 1.0);
            TakeGoldFromCreature(nAmount, oPC, TRUE);
            oGroundGold = CreateObject(OBJECT_TYPE_PLACEABLE, sTemplate, lLoc);
            SetLocalInt(oGroundGold, "nGoldAmount", nAmount);
        }
        else
        {
            SendMessageToPC(oPC, "Target location too far away.");
        }
    }
    else
    {
        SendMessageToPC(oPC, "Not enough gold.");
    }
}
