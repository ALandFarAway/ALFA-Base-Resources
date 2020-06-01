#include "acr_dropgold_i"


void main(string sOperation, string sCurrentAmount)
{
    object oPC = OBJECT_SELF;
    int nGoldToSet, nCurrentGold, nMaxGold;

    nCurrentGold = StringToInt(sCurrentAmount);
    nMaxGold = GetGold(oPC);

    if (sOperation == ACR_GUI_DROPGOLD_AMOUNT_ADD) {
        nGoldToSet = (
            nMaxGold > nCurrentGold ? nCurrentGold + 1 : nMaxGold
        );
    }
    else if (sOperation == ACR_GUI_DROPGOLD_AMOUNT_SUBTRACT) {
        nGoldToSet = (
            0 < nCurrentGold ? nCurrentGold - 1 : 0 
        );
    }
    else if (sOperation == ACR_GUI_DROPGOLD_AMOUNT_ALL) {
        nGoldToSet = nMaxGold;
    }
    else {
        SendMessageToPC(oPC, "Error: unimplemented");
    }

    SetGUIObjectText(oPC, ACR_GUI_DROPGOLD_WINDOW, ACR_GUI_DROPGOLD_AMOUNT_FIELD, -1, IntToString(nGoldToSet));
}
