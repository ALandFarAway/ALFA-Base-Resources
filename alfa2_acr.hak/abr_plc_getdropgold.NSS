#include "acr_placeable_i"
#include "acr_dropgold_i"

void main()
{
    object oPC, oGroundGold;
    string nAmountGold;

    ACR_PlaceableOnUsed();

    oGroundGold = OBJECT_SELF;
    oPC = GetLastOpenedBy();

    nAmountGold = GetLocalInt(oGroundGold, ACR_DROPGOLD_AMOUNT);
    DestroyObject(oGroundGold);

    GiveGoldToCreature(oPC, nAmountGold);
	SendMessageToPC(oPC, "Acquired " + IntToString(nAmountGold) + "GP");
}
