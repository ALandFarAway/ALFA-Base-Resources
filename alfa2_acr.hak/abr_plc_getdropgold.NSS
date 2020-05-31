#include "acr_placeable_i"
#include "acr_dropgold_i"

void main()
{
    object oPC, oGroundGold;
    int nAmountGold;

    ACR_PlaceableOnUsed();

    oGroundGold = OBJECT_SELF;
    oPC = GetLastUsedBy();

    nAmountGold = GetLocalInt(oGroundGold, ACR_DROPGOLD_AMOUNT);
    DestroyObject(oGroundGold);

    // Give gold
    GiveGoldToCreature(oPC, nAmountGold);

    // Show some fancy vfx
    PlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 1.0);
}
