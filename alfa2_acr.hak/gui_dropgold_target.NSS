#include "acr_dropgold_i"

void main(string xValue, string yValue, string zValue)
{
    object oPC = OBJECT_SELF;
    vector vVector = Vector(StringToFloat(xValue), StringToFloat(yValue), StringToFloat(zValue));
    location lLoc = Location(GetArea(oPC), vVector, GetFacing(oPC));

    if (GetIsLocationValid(lLoc) && GetDistanceBetweenLocations(GetLocation(oPC), lLoc) <= MAXIMUM_DROP_DISTANCE)
    {
        SetLocalLocation(oPC, ACR_LAST_GOLD_DROP_LOC, lLoc);
        DisplayGuiScreen(oPC, "SCREEN_GOLD_DROP", FALSE, "golddropinputbox.xml");
    }
    else
    {
        SendMessageToPC(oPC, "Location invalid or too far away.");
    }
}
