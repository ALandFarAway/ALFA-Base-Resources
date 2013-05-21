////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ACR GUI Player Report
//     Filename : gui_playerreport
//    $Revision:: 1.0           $ current version of the file
//        $Date:: 3/23/2012           $ date the file was created or modified
//       Author : Zelknolf
//
//    Var Prefix:
//
//  Description
//  This script is called from the various buttons on the player report window
//  which replaces the party list for DMs.
//
//  Revision History
//  2012-4-08   Zelknolf  Inception
//  2012-4-21   Zelknolf  Splitting functions out to include acr_report_i
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_db_persist_i"
#include "acr_resting_i"
#include "dmfi_inc_command"
#include "acr_report_i"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

int PLAYER_REPORT_SHOW_GUI          = 0;
int PLAYER_REPORT_SHOW_INVENTORY    = 1;
int PLAYER_REPORT_ALLOW_REST        = 2;
int PLAYER_REPORT_ALLOW_STUDY       = 3;
int PLAYER_REPORT_BOOT_PLAYER       = 4;
int PLAYER_REPORT_GIVE_ITEM         = 5;
int PLAYER_REPORT_TAKE_ITEM         = 6;
int PLAYER_REPORT_GOTO_PLAYER       = 7;
int PLAYER_REPORT_INVENTORY_BUTTONS = 8;
int PLAYER_REPORT_CURSE_TOGGLE      = 9;
int PLAYER_REPORT_PLOT_TOGGLE       = 10;
int PLAYER_REPORT_STOLEN_TOGGLE     = 11;

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void PopulateInventoryList(object oTarget, object oItem, int nEquipped = FALSE);
void UpdateInventoryRow(object oTarget, object oItem, int nEquipped = FALSE);

string GetAlignmentIcon(object oRowPC);
string GetDeityIcon(object oRowPC);
string GetMainClassIcon(object oRowPC);
string GetWealthIcon(object oRowPC);


////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void PopulateInventoryList(object oTarget, object oItem, int nEquipped = FALSE)
{
    string sName = GetName(oItem);
    if(nEquipped == TRUE)
    {
        string sColor = "<C=#FFFF55>";
        if(GetPlotFlag(oItem))       sColor = "<C=#55FFFF>";
        if(GetStolenFlag(oItem))     sColor = "<C=#55FF55>";
        if(GetItemCursedFlag(oItem)) sColor = "<C=#FF55FF>";
        sName = sColor+sName+"</C>";
    }
    else
    {
        string sColor = "<C=#FFFFFF>";
        if(GetPlotFlag(oItem))       sColor = "<C=#99FFFF>";
        if(GetStolenFlag(oItem))     sColor = "<C=#99FF99>";
        if(GetItemCursedFlag(oItem)) sColor = "<C=#FF99FF>";
        sName = sColor+sName+"</C>";
    }

    int nStack = GetItemStackSize(oItem);
    if(nStack > 1)
        sName += " ("+IntToString(nStack)+")";

    int nPrice = GetGoldPieceValue(oItem);
    string sPrice = IntToString(nPrice);

    int nLevel = 1;
    if(nPrice > 188500) nLevel = 20;
    else if(nPrice > 143000) nLevel = 19;
    else if(nPrice > 110500) nLevel = 18;
    else if(nPrice > 84500)  nLevel = 17;
    else if(nPrice > 65000)  nLevel = 16;
    else if(nPrice > 48750)  nLevel = 15;
    else if(nPrice > 35750)  nLevel = 14;
    else if(nPrice > 28600)  nLevel = 13;
    else if(nPrice > 21450)  nLevel = 12;
    else if(nPrice > 15925)  nLevel = 11;
    else if(nPrice > 11700)  nLevel = 10;
    else if(nPrice > 8775)   nLevel = 9;
    else if(nPrice > 6175)   nLevel = 8;
    else if(nPrice > 4225)   nLevel = 7;
    else if(nPrice > 2925)   nLevel = 6;
    else if(nPrice > 1750)   nLevel = 5;
    else if(nPrice > 875)    nLevel = 4;
    else if(nPrice > 300)    nLevel = 3;
    string sLevel = IntToString(nLevel);

    string sIcon = Get2DAString("nwn2_icons", "ICON", GetItemIcon(oItem)); 
    if(sIcon == "") sIcon = "temp0.tga";
    else sIcon += ".tga";

    string sRowName = IntToString(ObjectToInt(oItem));

    AddListBoxRow(OBJECT_SELF, "SCREEN_INVENTORYREPORT", "inventoryreport", sRowName, "LISTBOX_ITEM_TEXT=  "+sName+";LISTBOX_ITEM_PRICE=  "+sPrice+";LISTBOX_ITEM_LEVEL=  "+sLevel,   "LISTBOX_ITEM_ICON="+sIcon, "5="+sRowName, "unhide");
    return;
}

void UpdateInventoryRow(object oTarget, object oItem, int nEquipped = FALSE)
{
    string sName = GetName(oItem);
    if(nEquipped == TRUE)
    {
        string sColor = "<C=#FFFF55>";
        if(GetPlotFlag(oItem))       sColor = "<C=#55FFFF>";
        if(GetStolenFlag(oItem))     sColor = "<C=#55FF55>";
        if(GetItemCursedFlag(oItem)) sColor = "<C=#FF55FF>";
        sName = sColor+sName+"</C>";
    }
    else
    {
        string sColor = "<C=#FFFFFF>";
        if(GetPlotFlag(oItem))       sColor = "<C=#99FFFF>";
        if(GetStolenFlag(oItem))     sColor = "<C=#99FF99>";
        if(GetItemCursedFlag(oItem)) sColor = "<C=#FF99FF>";
        sName = sColor+sName+"</C>";
    }

    int nStack = GetItemStackSize(oItem);
    if(nStack > 1)
        sName += " ("+IntToString(nStack)+")";

    int nPrice = GetGoldPieceValue(oItem);
    string sPrice = IntToString(nPrice);

    int nLevel = 1;
    if(nPrice > 188500) nLevel = 20;
    else if(nPrice > 143000) nLevel = 19;
    else if(nPrice > 110500) nLevel = 18;
    else if(nPrice > 84500)  nLevel = 17;
    else if(nPrice > 65000)  nLevel = 16;
    else if(nPrice > 48750)  nLevel = 15;
    else if(nPrice > 35750)  nLevel = 14;
    else if(nPrice > 28600)  nLevel = 13;
    else if(nPrice > 21450)  nLevel = 12;
    else if(nPrice > 15925)  nLevel = 11;
    else if(nPrice > 11700)  nLevel = 10;
    else if(nPrice > 8775)   nLevel = 9;
    else if(nPrice > 6175)   nLevel = 8;
    else if(nPrice > 4225)   nLevel = 7;
    else if(nPrice > 2925)   nLevel = 6;
    else if(nPrice > 1750)   nLevel = 5;
    else if(nPrice > 875)    nLevel = 4;
    else if(nPrice > 300)    nLevel = 3;
    string sLevel = IntToString(nLevel);

    string sIcon = Get2DAString("nwn2_icons", "ICON", GetItemIcon(oItem)); 
    if(sIcon == "") sIcon = "temp0.tga";
    else sIcon += ".tga";

    string sRowName = IntToString(ObjectToInt(oItem));

    ModifyListBoxRow(OBJECT_SELF, "SCREEN_INVENTORYREPORT", "inventoryreport", sRowName, "LISTBOX_ITEM_TEXT=  "+sName+";LISTBOX_ITEM_PRICE=  "+sPrice+";LISTBOX_ITEM_LEVEL=  "+sLevel,   "LISTBOX_ITEM_ICON="+sIcon, "5="+sRowName, "unhide");
    return;
}

string GetAlignmentIcon(object oRowPC)
{
    string sAlignIcon = "align_";
    int nGoodEvil = GetAlignmentGoodEvil(oRowPC);
    int nLawChaos = GetAlignmentLawChaos(oRowPC);
    if(nGoodEvil == ALIGNMENT_GOOD)
    {
        if(nLawChaos == ALIGNMENT_LAWFUL)       sAlignIcon += "lg.tga";
        else if(nLawChaos == ALIGNMENT_NEUTRAL) sAlignIcon += "ng.tga";
        else                                    sAlignIcon += "cg.tga";
    }
    else if(nGoodEvil == ALIGNMENT_NEUTRAL)
    {
        if(nLawChaos == ALIGNMENT_LAWFUL)       sAlignIcon += "ln.tga";
        else if(nLawChaos == ALIGNMENT_NEUTRAL) sAlignIcon += "n.tga";
        else                                    sAlignIcon += "cn.tga";
    }
    else
    {
        if(nLawChaos == ALIGNMENT_LAWFUL)       sAlignIcon += "le.tga";
        else if(nLawChaos == ALIGNMENT_NEUTRAL) sAlignIcon += "ne.tga";
        else                                    sAlignIcon += "ce.tga";
    }
    return sAlignIcon;
}

string GetDeityIcon(object oRowPC)
{
    string sDeity = GetDeity(oRowPC);
    int nDeity;

    if(sDeity == "No Deity")                nDeity = 0;
    if(sDeity == "Ao")                      nDeity = 1;
    if(sDeity == "Aerdrie Faenya")          nDeity = 2;
    if(sDeity == "Angharradh")              nDeity = 3;
    if(sDeity == "Corellon Larethian")      nDeity = 4;		
    if(sDeity == "Erevan Ilesere")          nDeity = 5;
    if(sDeity == "Fenmarel Mestarine")      nDeity = 6;
    if(sDeity == "Hanali Celanil")          nDeity = 7;
    if(sDeity == "Labelas Enoreth")         nDeity = 8;
    if(sDeity == "Rillfane Rallathil")      nDeity = 9;
    if(sDeity == "Sehanine Moonbow")        nDeity = 10;
    if(sDeity == "Shevarash")               nDeity = 11;
    if(sDeity == "Solonor Thelandira")      nDeity = 12;
    if(sDeity == "Eilistraee")              nDeity = 13;
    if(sDeity == "Ghaunadaur")              nDeity = 14;
    if(sDeity == "Kiransalee")              nDeity = 15;
    if(sDeity == "Lolth")                   nDeity = 16;
    if(sDeity == "Seveltarm")               nDeity = 17;
    if(sDeity == "Vhaeraun")                nDeity = 18;
    if(sDeity == "Arvoreen")                nDeity = 19;
    if(sDeity == "Brandobaris")             nDeity = 20;
    if(sDeity == "Cyrrollalee")             nDeity = 21;
    if(sDeity == "Sheela Peryroyl")         nDeity = 22;
    if(sDeity == "Urogalan")                nDeity = 23;
    if(sDeity == "Yondalla")                nDeity = 24;
    if(sDeity == "Abbathor")                nDeity = 25;
    if(sDeity == "Berronar Truesilver")     nDeity = 26;
    if(sDeity == "Clangeddin Silverbeard")  nDeity = 27;
    if(sDeity == "Deep Duerra")             nDeity = 28;
    if(sDeity == "Dugmaren Brightmantle")   nDeity = 29;
    if(sDeity == "Dumathoin")               nDeity = 30;
    if(sDeity == "Gorm Gulthyn")            nDeity = 31;
    if(sDeity == "Haela Brightaxe")         nDeity = 32;
    if(sDeity == "Laduguer")                nDeity = 33;
    if(sDeity == "Marthammor Duin")         nDeity = 34;
    if(sDeity == "Moradin")                 nDeity = 35;
    if(sDeity == "Sharindlar")              nDeity = 36;
    if(sDeity == "Thard Harr")              nDeity = 37;
    if(sDeity == "Vergadain")               nDeity = 38;
    if(sDeity == "Baervan Wildwanderer")    nDeity = 39;
    if(sDeity == "Baravar Cloakshadow")     nDeity = 40;
    if(sDeity == "Callarduran Smoothhands") nDeity = 41;
    if(sDeity == "Flandal Steelskin")       nDeity = 42;
    if(sDeity == "Gaerdal Ironhand")        nDeity = 43;
    if(sDeity == "Garl Glittergold")        nDeity = 44;
    if(sDeity == "Segojan Earthcaller")     nDeity = 45;
    if(sDeity == "Urdeen")                  nDeity = 46;
    if(sDeity == "Bahgtru")                 nDeity = 47;
    if(sDeity == "Gruumsh")                 nDeity = 48;
    if(sDeity == "Ilneval")                 nDeity = 49;
    if(sDeity == "Luthic")                  nDeity = 50;
    if(sDeity == "Shargaas")                nDeity = 51;
    if(sDeity == "Yurtrus")                 nDeity = 52;
    if(sDeity == "Akadi")                   nDeity = 53;
    if(sDeity == "Auril")                   nDeity = 54;
    if(sDeity == "Azuth")                   nDeity = 55;
    if(sDeity == "Bane")                    nDeity = 56;
    if(sDeity == "Beshaba")                 nDeity = 57;
    if(sDeity == "Chauntea")                nDeity = 58;
    if(sDeity == "Cyric")                   nDeity = 59;
    if(sDeity == "Deneir")                  nDeity = 60;
    if(sDeity == "Eldath")                  nDeity = 61;
    if(sDeity == "Finder Wyvernspur")       nDeity = 62;
    if(sDeity == "Garagos")                 nDeity = 63;
    if(sDeity == "Gargauth")                nDeity = 64;
    if(sDeity == "Gond")                    nDeity = 65;
    if(sDeity == "Grumbar")                 nDeity = 66;
    if(sDeity == "Gwaeron Windstrom")       nDeity = 67;
    if(sDeity == "Helm")                    nDeity = 68;
    if(sDeity == "Hoar")                    nDeity = 69;
    if(sDeity == "Ilmater")                 nDeity = 70;
    if(sDeity == "Istishia")                nDeity = 71;
    if(sDeity == "Jergal")                  nDeity = 72;
    if(sDeity == "Kelemvor")                nDeity = 73;
    if(sDeity == "Kossuth")                 nDeity = 74;
    if(sDeity == "Lathander")               nDeity = 75;
    if(sDeity == "Lliira")                  nDeity = 76;
    if(sDeity == "Loviatar")                nDeity = 77;
    if(sDeity == "Lurue")                   nDeity = 78;
    if(sDeity == "Malar")                   nDeity = 79;
    if(sDeity == "Mask")                    nDeity = 80;
    if(sDeity == "Mielikki")                nDeity = 81;
    if(sDeity == "Milil")                   nDeity = 82;
    if(sDeity == "Mystra")                  nDeity = 83;
    if(sDeity == "Oghma")                   nDeity = 84;
    if(sDeity == "Red Knight")              nDeity = 85;
    if(sDeity == "Savras")                  nDeity = 86;
    if(sDeity == "Selune")                  nDeity = 87;
    if(sDeity == "Shar")                    nDeity = 88;
    if(sDeity == "Sharess")                 nDeity = 89;
    if(sDeity == "Shaundakul")              nDeity = 90;
    if(sDeity == "Shiallia")                nDeity = 91;
    if(sDeity == "Siamorphe")               nDeity = 92;
    if(sDeity == "Silvanus")                nDeity = 93;
    if(sDeity == "Sune")                    nDeity = 94;
    if(sDeity == "Talona")                  nDeity = 95;
    if(sDeity == "Talos")                   nDeity = 96;
    if(sDeity == "Tempus")                  nDeity = 97;
    if(sDeity == "Torm")                    nDeity = 98;
    if(sDeity == "Tymora")                  nDeity = 99;
    if(sDeity == "Tyr")                     nDeity = 100;
    if(sDeity == "Umberlee")                nDeity = 101;
    if(sDeity == "Valkur")                  nDeity = 102;
    if(sDeity == "Velsharoon")              nDeity = 103;
    if(sDeity == "Waukeen")                 nDeity = 104;
    if(sDeity == "None")                    nDeity = 105;
    if(sDeity == "Sseht")                   nDeity = 106;
    if(sDeity == "Leira")                   nDeity = 107;
    if(sDeity == "Ubtao")                   nDeity = 108;

    if(sDeity == "Horus-Re")                nDeity = 148;
    if(sDeity == "Amaunator")               nDeity = 149;
    if(sDeity == "Deep Sashelas")           nDeity = 150;
    if(sDeity == "Tiamat")                  nDeity = 151;		
    if(sDeity == "Uthgar")                  nDeity = 152;
    if(sDeity == "Bahamut")                 nDeity = 153;			

    return Get2DAString("nwn2_deities", "IconID", nDeity)+".tga";
}

string GetMainClassIcon(object oRowPC)
{
    int nClass  = GetClassByPosition(1, oRowPC);
    int nClass2 = GetClassByPosition(2, oRowPC);
    int nClass3 = GetClassByPosition(3, oRowPC);
    int nClass4 = GetClassByPosition(4, oRowPC);
    if(GetLevelByClass(nClass2, oRowPC) > GetLevelByClass(nClass, oRowPC)) nClass = nClass2;
    if(GetLevelByClass(nClass3, oRowPC) > GetLevelByClass(nClass, oRowPC)) nClass = nClass3;
    if(GetLevelByClass(nClass4, oRowPC) > GetLevelByClass(nClass, oRowPC)) nClass = nClass4;
    if(((nClass2 > 26 && nClass2 < 38) ||
        (nClass2 > 39 && nClass2 < 55) ||
        (nClass2 > 55 && nClass2 < 58) ||
        (nClass2 > 58)) && 
         nClass2 != CLASS_TYPE_INVALID)    nClass = nClass2;
    if(((nClass3 > 26 && nClass3 < 38) ||
        (nClass3 > 39 && nClass3 < 55) ||
        (nClass3 > 55 && nClass3 < 58) ||
        (nClass3 > 58)) && 
         nClass3 != CLASS_TYPE_INVALID)    nClass = nClass3;
    if(((nClass4 > 26 && nClass4 < 38) ||
        (nClass4 > 39 && nClass4 < 55) ||
        (nClass4 > 55 && nClass4 < 58) ||
        (nClass4 > 58)) && 
         nClass4 != CLASS_TYPE_INVALID)    nClass = nClass4;

    return Get2DAString("classes", "Icon", nClass)+".tga";
}

string GetWealthIcon(object oRowPC)
{
    int nWealthLevel = GetWealthLevel(oRowPC);
    string sWealthIcon = "";
    if(nWealthLevel == WEALTH_LEVEL_BELOW_LOW)   sWealthIcon = "wealth_vpoor.tga";
    else if(nWealthLevel == WEALTH_LEVEL_LOW)    sWealthIcon = "wealth_poor.tga";
    else if(nWealthLevel == WEALTH_LEVEL_TARGET) sWealthIcon = "wealth_avg.tga";
    else if(nWealthLevel == WEALTH_LEVEL_HIGH)   sWealthIcon = "wealth_high.tga";
    else                                         sWealthIcon = "wealth_over.tga";

    return sWealthIcon;
}

void main(int nAction, int nTargetObject)
{
    object oPC = OBJECT_SELF;

    if(nAction == PLAYER_REPORT_SHOW_GUI)
    {
        /* As everyone who opens the player list calls this, we end without chatter for players. */
        if(!GetIsDM(oPC) && !GetIsDMPossessed(oPC)) return;


        /* From here on, everyone is a DM. */
        ACR_IncrementStatistic("PLAYER_REPORT_OPEN");
        CloseGUIScreen(OBJECT_SELF, "SCREEN_PLAYERLIST");
        DisplayGuiScreen(oPC, "SCREEN_PLAYERREPORT", FALSE, "playerreport.xml");
        ClearListBox(oPC, "SCREEN_PLAYERREPORT", "playerreport");
        object oBlueParty, oGreenParty, oCyanParty, oRedParty, oMagentaParty, oBrownParty, oGreyParty;
        int bBlueUsed = FALSE;
        int bGreenUsed = FALSE;
        int bCyanUsed = FALSE;
        int bRedUsed = FALSE;
        int bMagentaUsed = FALSE;
        int bBrownUsed = FALSE;
        int bGreyUsed = FALSE;

        object oRowPC = GetFirstPC();
        while(GetIsObjectValid(oRowPC))
        {
            string sName = GetName(oRowPC);
            string sNameDisplay = "<C=#AAAAAA>"+GetPCPlayerName(oRowPC)+"</C> \n  "+sName;
            string sAlignIcon  = GetAlignmentIcon(oRowPC);
            string sDeityIcon  = GetDeityIcon(oRowPC);
            string sClassIcon  = GetMainClassIcon(oRowPC);
            string sWealthIcon = GetWealthIcon(oRowPC);

            /* If we've already flagged this PC as a member of a party, just color the PC's name appropriately. */
            if(GetLocalInt(oRowPC, "BLUE_PARTY"))
            {
                sNameDisplay = "<C=#0000AA>"+GetPCPlayerName(oRowPC)+"</C> \n  <C=#5555FF>"+sName+"</C>";
                bBlueUsed = TRUE;
            }
            else if(GetLocalInt(oRowPC, "GREEN_PARTY"))
            {
                sNameDisplay = "<C=#00AA00>"+GetPCPlayerName(oRowPC)+"</C> \n  <C=#55FF55>"+sName+"</C>";
                bGreenUsed = TRUE;
            }
            else if(GetLocalInt(oRowPC, "CYAN_PARTY"))
            {
                sNameDisplay = "<C=#00AAAA>"+GetPCPlayerName(oRowPC)+"</C> \n  <C=#55FFFF>"+sName+"</C>";
                bCyanUsed = TRUE;
            }
            else if(GetLocalInt(oRowPC, "RED_PARTY"))
            {
                sNameDisplay = "<C=#AA0000>"+GetPCPlayerName(oRowPC)+"</C> \n  <C=#FF5555>"+sName+"</C>";
                bRedUsed = TRUE;
            }
            else if(GetLocalInt(oRowPC, "MAGENTA_PARTY"))
            {
                sNameDisplay = "<C=#AA00AA>"+GetPCPlayerName(oRowPC)+"</C> \n  <C=#FF55FF>"+sName+"</C>";
                bMagentaUsed = TRUE;
            }
            else if(GetLocalInt(oRowPC, "BROWN_PARTY"))
            {
                sNameDisplay = "<C=#AA5500>"+GetPCPlayerName(oRowPC)+"</C> \n  <C=#FFFF55>"+sName+"</C>";
                bBrownUsed = TRUE;
            }
            else if(GetLocalInt(oRowPC, "GREY_PARTY"))
            {
                sNameDisplay = "<C=#555555>"+GetPCPlayerName(oRowPC)+"</C> \n  <C=#AAAAAA>"+sName+"</C>";
                bGreyUsed = TRUE;
            }

            /* If there's no party identified, we need to see if the PC is in a party. */
            else
            {
                /* We know no color is assigned yet, so start blank. */
                string sFactionColor = "";
                object oFactionPC = GetFirstFactionMember(oRowPC);
                while(GetIsObjectValid(oFactionPC))
                {
                    /* We're only in a party if there's someone else in it. */
                    if(oFactionPC != oRowPC)
                    {
                        /* If we -still- haven't picked a color by the time we get to the current PC, look for one. */
                        if(sFactionColor == "")
                        {
                            if(!bBlueUsed)
                            {
                                sFactionColor = "BLUE_PARTY";
                                bBlueUsed = TRUE;
                            }
                            else if(!bGreenUsed)
                            {
                                sFactionColor = "GREEN_PARTY";
                                bGreenUsed = TRUE;
                            }
                            else if(!bCyanUsed)
                            {
                                sFactionColor = "CYAN_PARTY";
                                bCyanUsed = TRUE;
                            }
                            else if(!bRedUsed)
                            {
                                sFactionColor = "RED_PARTY";
                                bRedUsed = TRUE;
                            }
                            else if(!bMagentaUsed)
                            {
                                sFactionColor = "MAGENTA_PARTY";
                                bMagentaUsed = TRUE;
                            }
                            else if(!bBrownUsed)
                            {
                                sFactionColor = "BROWN_PARTY";
                                bBrownUsed = TRUE;
                            }
                            else if(!bGreyUsed)
                            {
                                sFactionColor = "GREY_PARTY";
                                bGreyUsed = TRUE;
                            }
                            else sFactionColor = "SCRAP";
                        }

                        if(sFactionColor != "" &&
                           sFactionColor != "SCRAP")
                        {
                            /* Temporarily store colors, just in case of key mashing or many DMs calling it. */
                            SetLocalInt(oFactionPC, sFactionColor, 1);
                            DelayCommand(0.5f, DeleteLocalInt(oFactionPC, sFactionColor));
                        }
                    }
                    oFactionPC = GetNextFactionMember(oRowPC);
                }

                /* If we've picked a color, make this row use that color-- and trust that the settings above will catch the others. */
                if(sFactionColor != "" &&
                   sFactionColor != "SCRAP")
                {
                    if(sFactionColor == "BLUE_PARTY")
                        sNameDisplay = "<C=#0000AA>"+GetPCPlayerName(oRowPC)+"</C> \n  <C=#5555FF>"+sName+"</C>";
                    else if(sFactionColor == "GREEN_PARTY")
                        sNameDisplay = "<C=#00AA00>"+GetPCPlayerName(oRowPC)+"</C> \n  <C=#55FF55>"+sName+"</C>";
                    else if(sFactionColor == "CYAN_PARTY")
                        sNameDisplay = "<C=#00AAAA>"+GetPCPlayerName(oRowPC)+"</C> \n  <C=#55FFFF>"+sName+"</C>";
                    else if(sFactionColor == "RED_PARTY")
                        sNameDisplay = "<C=#AA0000>"+GetPCPlayerName(oRowPC)+"</C> \n  <C=#FF5555>"+sName+"</C>";
                    else if(sFactionColor == "MAGENTA_PARTY")
                        sNameDisplay = "<C=#AA00AA>"+GetPCPlayerName(oRowPC)+"</C> \n  <C=#FF55FF>"+sName+"</C>";
                    else if(sFactionColor == "BROWN_PARTY")
                        sNameDisplay = "<C=#AA5500>"+GetPCPlayerName(oRowPC)+"</C> \n  <C=#FFFF55>"+sName+"</C>";
                    else if(sFactionColor == "GREY_PARTY")
                        sNameDisplay = "<C=#555555>"+GetPCPlayerName(oRowPC)+"</C> \n  <C=#AAAAAA>"+sName+"</C>";
                }
            }

            AddListBoxRow(oPC, "SCREEN_PLAYERREPORT", "playerreport", sName, "LISTBOX_ITEM_TEXT=  "+sNameDisplay,   "LISTBOX_ALIGN_ICON="+sAlignIcon+";LISTBOX_DEITY_ICON="+sDeityIcon+";LISTBOX_CLASS_ICON="+sClassIcon+";LISTBOX_WEALTH_ICON="+sWealthIcon+";LISTBOX_STYLE_ICON=acr_spade.tga", "5="+IntToString(ObjectToInt(oRowPC)), "unhide");
            oRowPC = GetNextPC();
        }
    }

    if(!GetIsDM(oPC) && !GetIsDMPossessed(oPC))
    {
        SendMessageToPC(OBJECT_SELF, "You are not a DM, and may not do this.");
        return;
    }

    if(nAction == PLAYER_REPORT_SHOW_INVENTORY)
    {
        object oTarget = IntToObject(nTargetObject);
        if(GetIsObjectValid(oTarget) == FALSE)
        {
            SendMessageToPC(OBJECT_SELF, "I cannot find that player.");
            return;
        }
        DisplayGuiScreen(oPC, "SCREEN_INVENTORYREPORT", FALSE, "playeritemsreport.xml");
        SetLocalGUIVariable(oPC, "SCREEN_INVENTORYREPORT", 7, IntToString(nTargetObject));
        ClearListBox(oPC, "SCREEN_INVENTORYREPORT", "inventoryreport");

        int nWealth = GetGold(oTarget);
				AddListBoxRow(OBJECT_SELF, "SCREEN_INVENTORYREPORT", "inventoryreport", "nw_it_gold", "LISTBOX_ITEM_TEXT=  Gold;LISTBOX_ITEM_PRICE=  "+IntToString(GetGold(oTarget))+";LISTBOX_ITEM_LEVEL=  1",   "LISTBOX_ITEM_ICON=it_gold.tga", "5= ", "unhide");
        int nCount = 0;
        object oItem = GetItemInSlot(nCount, oTarget);
        while(nCount < 18)
        {
            if(GetIsObjectValid(oItem))
            {
                PopulateInventoryList(OBJECT_SELF, oItem, TRUE);
                nWealth += GetGoldPieceValue(oItem);
            }
            nCount++;
            oItem = GetItemInSlot(nCount, oTarget);
        }

        oItem = GetFirstItemInInventory(oTarget);
        while(GetIsObjectValid(oItem))
        {
            PopulateInventoryList(OBJECT_SELF, oItem);
            nWealth += GetGoldPieceValue(oItem);
            oItem = GetNextItemInInventory(oTarget);
        }

        int nLowWealth    = GetLowWealth(GetXP(oTarget));
        int nMedWealth    = GetMedWealth(GetXP(oTarget));
        int nHighWealth   = GetHighWealth(GetXP(oTarget));
        int nCutOffWealth = GetCutoffWealth(GetXP(oTarget));
        
        string sReportBar = IntToString(nWealth);

        if(nWealth < nLowWealth)
            sReportBar = "<C=#FF5555>"+sReportBar+" | "+IntToString(nLowWealth - nWealth)+" BELOW LOW END ("+IntToString(nLowWealth)+")</C>";
        else if(nWealth < nMedWealth)
            sReportBar = "<C=#FFFF55>"+sReportBar+" | "+IntToString(nMedWealth - nWealth)+" Below Target ("+IntToString(nMedWealth)+")</C>";
        else if(nWealth < nHighWealth)
            sReportBar = "<C=#FFFFDD>"+sReportBar+" | "+IntToString(nWealth - nMedWealth)+" Above Target ("+IntToString(nMedWealth)+")</C>";
        else if(nWealth < nCutOffWealth)
            sReportBar = "<C=#FF5555>"+sReportBar+" | "+IntToString(nWealth - nHighWealth)+" ABOVE HIGH END ("+IntToString(nHighWealth)+")</C>";
        else
            sReportBar = "<C=#FF5555>=== "+sReportBar+" | "+IntToString(nWealth - nCutOffWealth)+" ABOVE THE CUTOFF!!  ("+IntToString(nCutOffWealth)+")===</C>";

        SetGUIObjectText(OBJECT_SELF, "SCREEN_INVENTORYREPORT", "InventorySummary", -1, sReportBar);
        SetGUIObjectText(OBJECT_SELF, "SCREEN_INVENTORYREPORT", "INVENTORY_HEADER", -1, "Inventory: "+GetName(oTarget));

        return;
    }

    else if(nAction == PLAYER_REPORT_ALLOW_REST)
    {
        object oTarget = IntToObject(nTargetObject);
        if(GetIsObjectValid(oTarget) == FALSE)
        {
            SendMessageToPC(OBJECT_SELF, "I cannot find that player.");
            return;
        }
        SendMessageToPC(OBJECT_SELF, "Resetting rest for "+GetName(oTarget)+".");
        ACR_DeletePersistentVariable(oTarget, ACR_REST_TIMER);
        return;
    }

    else if(nAction == PLAYER_REPORT_ALLOW_STUDY)
    {
        object oTarget = IntToObject(nTargetObject);
        if(GetIsObjectValid(oTarget) == FALSE)
        {
            SendMessageToPC(OBJECT_SELF, "I cannot find that player.");
            return;
        }
        SendMessageToPC(OBJECT_SELF, "Resetting prayer and study for "+GetName(oTarget)+".");
        ACR_DeletePersistentVariable(oTarget, ACR_REST_STUDY_TIMER);
        ACR_DeletePersistentVariable(oTarget, ACR_REST_PRAYER_TIMER);
        return;
    }

    else if(nAction == PLAYER_REPORT_BOOT_PLAYER)
    {
        object oTarget = IntToObject(nTargetObject);
        if(GetIsObjectValid(oTarget) == FALSE || GetIsPC(oTarget) == FALSE)
        {
            SendMessageToPC(OBJECT_SELF, "I cannot find that player.");
            return;
        }

        SendMessageToPC(OBJECT_SELF, "Booting "+GetName(oTarget)+".");
        SendMessageToPC(oTarget, "You have been booted by "+GetName(OBJECT_SELF)+".");
        WriteTimestampedLogEntry(GetName(OBJECT_SELF)+" booted "+GetName(oTarget)+".");
        BootPC(oTarget);
    }

    else if(nAction == PLAYER_REPORT_GIVE_ITEM)
    {
        object oTarget = IntToObject(nTargetObject);
        object oItem   = GetLocalObject(OBJECT_SELF, "LAST_DRAGGED_ITEM");

        if(GetIsObjectValid(oTarget) == FALSE)
        {
            SendMessageToPC(OBJECT_SELF, "I cannot find that player.");
            return;
        }
        if(GetIsObjectValid(oItem) == FALSE)
        {
            SendMessageToPC(OBJECT_SELF, "I cannot find that item.");
            return;
        }

        object oNewItem = CopyItem(oItem, oTarget, TRUE);
        DestroyObject(oItem);

        PopulateInventoryList(oTarget, oNewItem);
        return;
    }

    else if(nAction == PLAYER_REPORT_TAKE_ITEM)
    {
        object oItem = IntToObject(nTargetObject);
        if(GetIsObjectValid(oItem) == FALSE)
        {
            SendMessageToPC(OBJECT_SELF, "I cannot find that item.");
            return;
        }

        CopyItem(oItem, OBJECT_SELF, TRUE);
        DestroyObject(oItem);

        RemoveListBoxRow(OBJECT_SELF, "SCREEN_INVENTORYREPORT", "inventoryreport", IntToString(nTargetObject));
        return;
    }

    else if(nAction == PLAYER_REPORT_GOTO_PLAYER)
    {
        object oTarget = IntToObject(nTargetObject);
        if(oTarget == OBJECT_SELF)
        {
            SendMessageToPC(OBJECT_SELF, "You already are where you are. Noob.");
            return;
        }
        if(GetIsObjectValid(oTarget) == FALSE)
        {
            SendMessageToPC(OBJECT_SELF, "I can't find that player.");
            return;
        }

        location lTarget = GetLocation(oTarget);
        if(GetIsObjectValid(GetAreaFromLocation(lTarget)) == FALSE)
        {
            SendMessageToPC(OBJECT_SELF, "I have no idea where that player is, but it doesn't look safe.");
            return;
        }

        if(GetAreaFromLocation(lTarget) == GetArea(OBJECT_SELF))
        {
            if(GetDistanceBetween(oTarget, OBJECT_SELF) < 10.0f)
            {
                object oTool = DMFI_GetTool(OBJECT_SELF);
                SetLocalObject(oTool, DMFI_TARGET, oTarget);
                DMFI_RunCommandCode(oTool, OBJECT_SELF, PRM_FOLLOW + PRM_ + PRM_ON);
                return;
            }
        }
        JumpToLocation(lTarget);
        return;
    }

    else if(nAction == PLAYER_REPORT_INVENTORY_BUTTONS)
    {
        object oItem = IntToObject(nTargetObject);
        if(!GetIsObjectValid(oItem)) return;
        if(GetPlotFlag(oItem))
        {
            SetGUIObjectHidden(OBJECT_SELF, "SCREEN_INVENTORYREPORT", "plot", TRUE);
            SetGUIObjectHidden(OBJECT_SELF, "SCREEN_INVENTORYREPORT", "unplot", FALSE);
        }
        else
        {
            SetGUIObjectHidden(OBJECT_SELF, "SCREEN_INVENTORYREPORT", "plot", FALSE);
            SetGUIObjectHidden(OBJECT_SELF, "SCREEN_INVENTORYREPORT", "unplot", TRUE);
        }

        if(GetStolenFlag(oItem))
        {
            SetGUIObjectHidden(OBJECT_SELF, "SCREEN_INVENTORYREPORT", "stolen", TRUE);
            SetGUIObjectHidden(OBJECT_SELF, "SCREEN_INVENTORYREPORT", "unstolen", FALSE);
        }
        else
        {
            SetGUIObjectHidden(OBJECT_SELF, "SCREEN_INVENTORYREPORT", "stolen", FALSE);
            SetGUIObjectHidden(OBJECT_SELF, "SCREEN_INVENTORYREPORT", "unstolen", TRUE);
        }

        if(GetItemCursedFlag(oItem))
        {
            SetGUIObjectHidden(OBJECT_SELF, "SCREEN_INVENTORYREPORT", "curse", TRUE);
            SetGUIObjectHidden(OBJECT_SELF, "SCREEN_INVENTORYREPORT", "uncurse", FALSE);
        }
        else
        {
            SetGUIObjectHidden(OBJECT_SELF, "SCREEN_INVENTORYREPORT", "curse", FALSE);
            SetGUIObjectHidden(OBJECT_SELF, "SCREEN_INVENTORYREPORT", "uncurse", TRUE);
        }

        return;
    }

    else if(nAction == PLAYER_REPORT_CURSE_TOGGLE)
    {
        object oItem = IntToObject(nTargetObject);
        if(!GetIsObjectValid(oItem)) return;

        if(GetItemCursedFlag(oItem))
        {
            SetItemCursedFlag(oItem, FALSE);
            UpdateInventoryRow(OBJECT_SELF, oItem);
            SetGUIObjectHidden(OBJECT_SELF, "SCREEN_INVENTORYREPORT", "curse", FALSE);
            SetGUIObjectHidden(OBJECT_SELF, "SCREEN_INVENTORYREPORT", "uncurse", TRUE);
        }
        else
        {
            SetItemCursedFlag(oItem, TRUE);
            UpdateInventoryRow(OBJECT_SELF, oItem);
            SetGUIObjectHidden(OBJECT_SELF, "SCREEN_INVENTORYREPORT", "curse", TRUE);
            SetGUIObjectHidden(OBJECT_SELF, "SCREEN_INVENTORYREPORT", "uncurse", FALSE);
        }
    }

    else if(nAction == PLAYER_REPORT_PLOT_TOGGLE)
    {
        object oItem = IntToObject(nTargetObject);
        if(!GetIsObjectValid(oItem)) return;

        if(GetPlotFlag(oItem))
        {
            SetPlotFlag(oItem, FALSE);
            UpdateInventoryRow(OBJECT_SELF, oItem);
            SetGUIObjectHidden(OBJECT_SELF, "SCREEN_INVENTORYREPORT", "plot", FALSE);
            SetGUIObjectHidden(OBJECT_SELF, "SCREEN_INVENTORYREPORT", "unplot", TRUE);
        }
        else
        {
            SetPlotFlag(oItem, TRUE);
            UpdateInventoryRow(OBJECT_SELF, oItem);
            SetGUIObjectHidden(OBJECT_SELF, "SCREEN_INVENTORYREPORT", "plot", TRUE);
            SetGUIObjectHidden(OBJECT_SELF, "SCREEN_INVENTORYREPORT", "unplot", FALSE);
        }
    }

    else if(nAction == PLAYER_REPORT_STOLEN_TOGGLE)
    {
        object oItem = IntToObject(nTargetObject);
        if(!GetIsObjectValid(oItem)) return;

        if(GetStolenFlag(oItem))
        {
            SetStolenFlag(oItem, FALSE);
            UpdateInventoryRow(OBJECT_SELF, oItem);
            SetGUIObjectHidden(OBJECT_SELF, "SCREEN_INVENTORYREPORT", "stolen", FALSE);
            SetGUIObjectHidden(OBJECT_SELF, "SCREEN_INVENTORYREPORT", "unstolen", TRUE);
        }
        else
        {
            SetStolenFlag(oItem, TRUE);
            UpdateInventoryRow(OBJECT_SELF, oItem);
            SetGUIObjectHidden(OBJECT_SELF, "SCREEN_INVENTORYREPORT", "stolen", TRUE);
            SetGUIObjectHidden(OBJECT_SELF, "SCREEN_INVENTORYREPORT", "unstolen", FALSE);
        }
    }

}
