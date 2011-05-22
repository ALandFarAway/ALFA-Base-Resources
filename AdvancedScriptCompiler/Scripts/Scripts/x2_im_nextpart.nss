//////////////////////////////////////////////////////////
/*
   Item Appearance Modification Conversation
   Changes the appearance of the currently active armorpart
   on the tailor to the next available appearance
*/
// created/updated 2003-06-24 Georg Zoeller, Bioware Corp
//////////////////////////////////////////////////////////

#include "x2_inc_craft"
void main()
{
    int nPart =  GetLocalInt(OBJECT_SELF,"X2_TAILOR_CURRENT_PART");
    object oPC = GetPCSpeaker();
    object oItem = CIGetCurrentModItem(oPC);

    int nCurrentAppearance;
    if (CIGetCurrentModMode(oPC) ==  X2_CI_MODMODE_ARMOR)
    {
        nCurrentAppearance = GetItemAppearance(oItem,ITEM_APPR_TYPE_ARMOR_MODEL,nPart);
    }

    if(GetIsObjectValid(oItem) == TRUE)
    {
        // Store the cost for modifying this item here
        int nCost;
        int nDC;
        object oNew;
        AssignCommand(oPC,ClearAllActions(TRUE));
        if (CIGetCurrentModMode(oPC) ==  X2_CI_MODMODE_ARMOR)
        {
            oNew = IPGetModifiedArmor(oItem, nPart, X2_IP_ARMORTYPE_NEXT, TRUE);
            CISetCurrentModItem(oPC,oNew);
            AssignCommand(oPC, ActionEquipItem(oNew, INVENTORY_SLOT_CHEST));
            nCost = CIGetArmorModificationCost(CIGetCurrentModBackup(oPC),oNew);
            nDC =CIGetArmorModificationDC(CIGetCurrentModBackup(oPC),oNew);
        } else if (CIGetCurrentModMode(oPC) ==  X2_CI_MODMODE_WEAPON)
        {
            oNew = IPGetModifiedWeapon(oItem, nPart, X2_IP_WEAPONTYPE_NEXT, TRUE);
            CISetCurrentModItem(oPC,oNew);
            AssignCommand(oPC, ActionEquipItem(oNew, INVENTORY_SLOT_RIGHTHAND));
            nCost = CIGetWeaponModificationCost(CIGetCurrentModBackup(oPC),oNew); //CIGetArmorModificationCost(CIGetCurrentModBackup(oPC),oNew);
            nDC =15 ; //CIGetArmorModificationDC(CIGetCurrentModBackup(oPC),oNew);
        }
        CIUpdateModItemCostDC(oPC, nDC, nCost);
    }
}
