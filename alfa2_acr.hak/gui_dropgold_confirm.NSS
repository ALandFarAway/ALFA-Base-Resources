#include "acr_dropgold_i"

void main(string sAmount)
{
    object oPC = OBJECT_SELF;
    SetLocalInt(oPC, ACR_DROPGOLD_AMOUNT_TMP, StringToInt(sAmount));
}
