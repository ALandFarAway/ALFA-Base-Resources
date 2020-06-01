#include "acr_1984_i"
#include "acr_dropgold_i"


void _drop_placeable_gold(object oPC, int nAmountDropped, location lGoldTargetLocation)
{
    object oGroundGold;
    string sGoldTemplate, sFullDescription, sAmountDescription;

    if (nAmountDropped == 1) {
        sAmountDescription = "a single gold coin";
    }
    else {
        sAmountDescription = IntToString(nAmountDropped) + " gold coins";
    }

    // Randomize the appearance: gold stack (1) or gold pouch (2)
    if (Random(2) == FALSE) {
        sGoldTemplate = "acr_gold_drop_1";
        sFullDescription = "A pile containing " + sAmountDescription + ".";
    }
    else {
        sGoldTemplate = "acr_gold_drop_2";
        sFullDescription = "A pouch containing " + sAmountDescription + ".";
    }

    // Create a gold object and drop it, reflecting the amonut
    oGroundGold = CreateObject(OBJECT_TYPE_PLACEABLE, sGoldTemplate, lGoldTargetLocation);
    SetLocalInt(oGroundGold, ACR_DROPGOLD_AMOUNT, nAmountDropped);
    SetDescription(oGroundGold, sFullDescription);
}


void _drop_container_gold(object oPC, int nAmountDropped, object oTarget)
{
    CreateItemOnObject("NW_IT_GOLD001", oTarget, nAmountDropped);
}


void main(string sAmount, object oTarget, string xValue, string yValue, string zValue)
{
    object oPC;
    int nAmountDropped, bTargetIsObject;
    vector vGoldTarget;
    location lGoldTargetLocation, lPCLocation;

    oPC = OBJECT_SELF;
    nAmountDropped = StringToInt(sAmount);
    bTargetIsObject = GetIsObjectValid(oTarget);

    if (nAmountDropped <= 0) {
        SendMessageToPC(oPC, "You cannot drop nothing.");
        return;
    }

    if (GetGold(oPC) < nAmountDropped) {
        SendMessageToPC(oPC, "Not enough gold.");
        return;
    }

    // Fetch vector to drop
    vGoldTarget = Vector(StringToFloat(xValue), StringToFloat(yValue), StringToFloat(zValue));
    // Fetch location from vector (and set it facing the way the PC is facing)
    lGoldTargetLocation = Location(GetArea(oPC), vGoldTarget, GetFacing(oPC));
    lPCLocation = GetLocation(oPC);

    if (!GetIsLocationValid(lGoldTargetLocation)) {
        SendMessageToPC(oPC, "Target location is invalid.");
        return;
    }

    if (!GetIsDM(oPC) && GetDistanceBetweenLocations(lPCLocation, lGoldTargetLocation) > ACR_DROPGOLD_MAXIMUM_DROP_DISTANCE) {
        SendMessageToPC(oPC, "Target location is too far away.");
        return;
    }

    if (bTargetIsObject) {
        if (GetObjectType(oTarget) != OBJECT_TYPE_PLACEABLE || !GetHasInventory(oTarget)) {
            SendMessageToPC(oPC, "Gold can not be put into that.");
            return;
        }
        if (!GetIsDM(oPC) && !GetIsOpen(oTarget)) {
            SendMessageToPC(oPC, "Target container must be open.");
            return;
        }
    }

    // Take our gold!
    TakeGoldFromCreature(nAmountDropped, oPC, TRUE);

    // Drop our gold!
    if (bTargetIsObject) {
        _drop_container_gold(oPC, nAmountDropped, oTarget);
    }
    else {
        _drop_placeable_gold(oPC, nAmountDropped, lGoldTargetLocation);
    }

    // Show some fancy visual stuff at the end
    AssignCommand(oPC, SetFacingPoint(vGoldTarget));
    PlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 1.0);

    // Finally, log
    ACR_LogOnUnacquiredGold(oPC, nAmountDropped, oTarget);
}
