#include "acr_dropgold_i"


void main()
{
    object oPC = OBJECT_SELF;
    int nTotalGold = GetGold(oPC);
    SetGUIObjectText(oPC, ACR_DROPGOLD_WINDOW, ACR_DROPGOLD_AMOUNT_FIELD, -1, IntToString(nTotalGold));
}
