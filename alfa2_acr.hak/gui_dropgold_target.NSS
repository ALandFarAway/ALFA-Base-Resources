#include "x0_i0_position"
#include "acr_dropgold_i"

void main(string xValue, string yValue, string zValue)
{
    object oPC, oGroundGold;
    int nAmountDropped;
    string sGoldTemplate, sFullDescription, sAmountDescription;
    vector vGoldTarget;
    location lGoldTargetLocation, lPCLocation;
    float fGoldFacingAngle;
    
    oPC = OBJECT_SELF;

    // Fetch gold amount and clear out temporary variable
    nAmountDropped = GetLocalInt(oPC, ACR_DROPGOLD_AMOUNT_TMP);
    DeleteLocalInt(oPC, ACR_DROPGOLD_AMOUNT_TMP);

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

    // Fetch direction gold is facing from PC
    lPCLocation = GetLocation(oPC);
    fGoldFacingAngle = GetAngleBetweenLocations(lPCLocation, lGoldTargetLocation);

    if (!GetIsLocationValid(lGoldTargetLocation)) {
        SendMessageToPC(oPC, "Target location is invalid.");
	    return;
    }

    if (GetDistanceBetweenLocations(lPCLocation, lGoldTargetLocation) > ACR_DROPGOLD_MAXIMUM_DROP_DISTANCE) {
        SendMessageToPC(oPC, "Target location too far away.");
        return;
    }

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

    // Take our gold!
    TakeGoldFromCreature(nAmountDropped, oPC, TRUE);

    // Create a gold object and drop it, reflecting the amonut
    oGroundGold = CreateObject(OBJECT_TYPE_PLACEABLE, sGoldTemplate, lGoldTargetLocation);
    SetLocalInt(oGroundGold, ACR_DROPGOLD_AMOUNT, nAmountDropped);
    SetDescription(oGroundGold, sFullDescription);

    // Show some fancy visual stuff at the end
    SetFacing(fGoldFacingAngle);
    PlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 1.0);
}
