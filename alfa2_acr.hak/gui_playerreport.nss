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
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_resting_i"
#include "dmfi_inc_command"

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

int GetLowWealth(int nXP);
int GetMedWealth(int nXP);
int GetHighWealth(int nXP);
int GetCutoffWealth(int nXP);


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
         nClass2 != CLASS_TYPE_INVALID)    nClass = nClass3;
    if(((nClass4 > 26 && nClass4 < 38) ||
        (nClass4 > 39 && nClass4 < 55) ||
        (nClass4 > 55 && nClass4 < 58) ||
        (nClass4 > 58)) && 
         nClass2 != CLASS_TYPE_INVALID)    nClass = nClass4;

    return Get2DAString("classes", "Icon", nClass)+".tga";
}

string GetWealthIcon(object oRowPC)
{
    string sWealthIcon = "";
    int nWealth = GetGold(oRowPC);
    int nCount = 0;
    object oItem = GetItemInSlot(nCount, oRowPC);
    while(nCount < 14)
    {
        nWealth += GetGoldPieceValue(oItem);
        nCount++;
        oItem = GetItemInSlot(nCount, oRowPC);
    }
    oItem = GetFirstItemInInventory(oRowPC);
    while(GetIsObjectValid(oItem))
    {
        nWealth += GetGoldPieceValue(oItem);
        oItem = GetNextItemInInventory(oRowPC);
    }
    int nLowWealth  = GetLowWealth(GetXP(oRowPC));
    int nMedWealth  = GetMedWealth(GetXP(oRowPC));
    int nHighWealth = GetHighWealth(GetXP(oRowPC));
    int nCutOff     = GetCutoffWealth(GetXP(oRowPC));
    if(nWealth < nLowWealth)       sWealthIcon = "wealth_vpoor.tga";
    else if(nWealth < nMedWealth)  sWealthIcon = "wealth_poor.tga";
    else if(nWealth < nHighWealth) sWealthIcon = "wealth_avg.tga";
    else if(nWealth < nCutOff)     sWealthIcon = "wealth_high.tga";
    else                           sWealthIcon = "wealth_over.tga";

    return sWealthIcon;
}

int GetLowWealth(int nXP)
{
    int nPercent, nBelowNumber, nAboveNumber;
    if(nXP < 1000)
    {
        nPercent = (100 * nXP) / 1000;
        nBelowNumber = 300;
        nAboveNumber = 650;
    }
    else if(nXP < 3000)
    {
        nPercent = (100 * (nXP - 1000)) / 2000;
        nBelowNumber = 650;
        nAboveNumber = 1925;
    }
    else if(nXP < 6000)
    {
        nPercent = (100 * (nXP - 3000)) / 3000;
        nBelowNumber = 1925;
        nAboveNumber = 3850;
    }
    else if(nXP < 10000)
    {
        nPercent = (100 * (nXP - 6000)) / 4000;
        nBelowNumber = 3850;
        nAboveNumber = 6425;
    }
    else if(nXP < 15000)
    {
        nPercent = (100 * (nXP - 10000)) / 5000;
        nBelowNumber = 6425;
        nAboveNumber = 9300;
    }
    else if(nXP < 21000)
    {
        nPercent = (100 * (nXP - 15000)) / 6000;
        nBelowNumber = 9300;
        nAboveNumber = 13575;
    }
    else if(nXP < 28000)
    {
        nPercent = (100 * (nXP - 21000)) / 7000;
        nBelowNumber = 13575;
        nAboveNumber = 19300;
    }
    else if(nXP < 36000)
    {
        nPercent = (100 * (nXP - 28000)) / 8000;
        nBelowNumber = 19300;
        nAboveNumber = 25750;
    }
    else if(nXP < 45000)
    {
        nPercent = (100 * (nXP - 36000)) / 9000;
        nBelowNumber = 25750;
        nAboveNumber = 35025;
    }
    else if(nXP < 55000)
    {
        nPercent = (100 * (nXP - 45000)) / 10000;
        nBelowNumber = 35025;
        nAboveNumber = 47200;
    }
    else if(nXP < 66000)
    {
        nPercent = (100 * (nXP - 55000)) / 11000;
        nBelowNumber = 47200;
        nAboveNumber = 62925;
    }
    else if(nXP < 78000)
    {
        nPercent = (100 * (nXP - 66000)) / 12000;
        nBelowNumber = 62925;
        nAboveNumber = 78650;
    }
    else if(nXP < 91000)
    {
        nPercent = (100 * (nXP - 78000)) / 13000;
        nBelowNumber = 78650;
        nAboveNumber = 107250;
    }
    else if(nXP < 105000)
    {
        nPercent = (100 * (nXP - 91000)) / 14000;
        nBelowNumber = 107250;
        nAboveNumber = 143000;
    }
    else if(nXP < 120000)
    {
        nPercent = (100 * (nXP - 105000)) / 15000;
        nBelowNumber = 143000;
        nAboveNumber = 185900;
    }
    else if(nXP < 136000)
    {
        nPercent = (100 * (nXP - 120000)) / 16000;
        nBelowNumber = 185900;
        nAboveNumber = 243100;
    }
    else if(nXP < 153000)
    {
        nPercent = (100 * (nXP - 136000)) / 17000;
        nBelowNumber = 243100;
        nAboveNumber = 314600;
    }
    else if(nXP < 171000)
    {
        nPercent = (100 * (nXP - 153000)) / 18000;
        nBelowNumber = 314600;
        nAboveNumber = 414700;
    }
    else if(nXP < 190000)
    {
        nPercent = (100 * (nXP - 171000)) / 19000;
        nBelowNumber = 414700;
        nAboveNumber = 500000;
    }
    else
    {
        nPercent = 100;
        nBelowNumber = 500000;
        nAboveNumber = 500000;
    }

    return (((nAboveNumber - nBelowNumber) * nPercent) / 100) + nBelowNumber;
}

int GetMedWealth(int nXP)
{
    int nPercent, nBelowNumber, nAboveNumber;
    if(nXP < 1000)
    {
        nPercent = (100 * nXP) / 1000;
        nBelowNumber = 600;
        nAboveNumber = 1175;
    }
    else if(nXP < 3000)
    {
        nPercent = (100 * (nXP - 1000)) / 2000;
        nBelowNumber = 1175;
        nAboveNumber = 3500;
    }
    else if(nXP < 6000)
    {
        nPercent = (100 * (nXP - 3000)) / 3000;
        nBelowNumber = 3500;
        nAboveNumber = 7025;
    }
    else if(nXP < 10000)
    {
        nPercent = (100 * (nXP - 6000)) / 4000;
        nBelowNumber = 7025;
        nAboveNumber = 11700;
    }
    else if(nXP < 15000)
    {
        nPercent = (100 * (nXP - 10000)) / 5000;
        nBelowNumber = 11700;
        nAboveNumber = 16900;
    }
    else if(nXP < 21000)
    {
        nPercent = (100 * (nXP - 15000)) / 6000;
        nBelowNumber = 16900;
        nAboveNumber = 24700;
    }
    else if(nXP < 28000)
    {
        nPercent = (100 * (nXP - 21000)) / 7000;
        nBelowNumber = 24700;
        nAboveNumber = 35100;
    }
    else if(nXP < 36000)
    {
        nPercent = (100 * (nXP - 28000)) / 8000;
        nBelowNumber = 35100;
        nAboveNumber = 46800;
    }
    else if(nXP < 45000)
    {
        nPercent = (100 * (nXP - 36000)) / 9000;
        nBelowNumber = 46800;
        nAboveNumber = 63700;
    }
    else if(nXP < 55000)
    {
        nPercent = (100 * (nXP - 45000)) / 10000;
        nBelowNumber = 63700;
        nAboveNumber = 85800;
    }
    else if(nXP < 66000)
    {
        nPercent = (100 * (nXP - 55000)) / 11000;
        nBelowNumber = 85800;
        nAboveNumber = 114400;
    }
    else if(nXP < 78000)
    {
        nPercent = (100 * (nXP - 66000)) / 12000;
        nBelowNumber = 114400;
        nAboveNumber = 143000;
    }
    else if(nXP < 91000)
    {
        nPercent = (100 * (nXP - 78000)) / 13000;
        nBelowNumber = 143000;
        nAboveNumber = 195000;
    }
    else if(nXP < 105000)
    {
        nPercent = (100 * (nXP - 91000)) / 14000;
        nBelowNumber = 195000;
        nAboveNumber = 260000;
    }
    else if(nXP < 120000)
    {
        nPercent = (100 * (nXP - 105000)) / 15000;
        nBelowNumber = 260000;
        nAboveNumber = 338000;
    }
    else if(nXP < 136000)
    {
        nPercent = (100 * (nXP - 120000)) / 16000;
        nBelowNumber = 338000;
        nAboveNumber = 442000;
    }
    else if(nXP < 153000)
    {
        nPercent = (100 * (nXP - 136000)) / 17000;
        nBelowNumber = 442000;
        nAboveNumber = 572000;
    }
    else if(nXP < 171000)
    {
        nPercent = (100 * (nXP - 153000)) / 18000;
        nBelowNumber = 572000;
        nAboveNumber = 754000;
    }
    else if(nXP < 190000)
    {
        nPercent = (100 * (nXP - 171000)) / 19000;
        nBelowNumber = 754000;
        nAboveNumber = 1000000;
    }
    else
    {
        nPercent = 100;
        nBelowNumber = 1000000;
        nAboveNumber = 1000000;
    }
	
    return (((nAboveNumber - nBelowNumber) * nPercent) / 100) + nBelowNumber;
}

int GetHighWealth(int nXP)
{
    int nPercent, nBelowNumber, nAboveNumber;
    if(nXP < 1000)
    {
        nPercent = (100 * nXP) / 1000;
        nBelowNumber = 2000;
        nAboveNumber = 3500;
    }
    else if(nXP < 3000)
    {
        nPercent = (100 * (nXP - 1000)) / 2000;
        nBelowNumber = 3500;
        nAboveNumber = 5100;
    }
    else if(nXP < 6000)
    {
        nPercent = (100 * (nXP - 3000)) / 3000;
        nBelowNumber = 5100;
        nAboveNumber = 10175;
    }
    else if(nXP < 10000)
    {
        nPercent = (100 * (nXP - 6000)) / 4000;
        nBelowNumber = 10175;
        nAboveNumber = 16975;
    }
    else if(nXP < 15000)
    {
        nPercent = (100 * (nXP - 10000)) / 5000;
        nBelowNumber = 16975;
        nAboveNumber = 24500;
    }
    else if(nXP < 21000)
    {
        nPercent = (100 * (nXP - 15000)) / 6000;
        nBelowNumber = 24500;
        nAboveNumber = 35825;
    }
    else if(nXP < 28000)
    {
        nPercent = (100 * (nXP - 21000)) / 7000;
        nBelowNumber = 35825;
        nAboveNumber = 50900;
    }
    else if(nXP < 36000)
    {
        nPercent = (100 * (nXP - 28000)) / 8000;
        nBelowNumber = 50900;
        nAboveNumber = 67850;
    }
    else if(nXP < 45000)
    {
        nPercent = (100 * (nXP - 36000)) / 9000;
        nBelowNumber = 67850;
        nAboveNumber = 92375;
    }
    else if(nXP < 55000)
    {
        nPercent = (100 * (nXP - 45000)) / 10000;
        nBelowNumber = 92375;
        nAboveNumber = 124425;
    }
    else if(nXP < 66000)
    {
        nPercent = (100 * (nXP - 55000)) / 11000;
        nBelowNumber = 124425;
        nAboveNumber = 165875;
    }
    else if(nXP < 78000)
    {
        nPercent = (100 * (nXP - 66000)) / 12000;
        nBelowNumber = 165875;
        nAboveNumber = 207350;
    }
    else if(nXP < 91000)
    {
        nPercent = (100 * (nXP - 78000)) / 13000;
        nBelowNumber = 207350;
        nAboveNumber = 282750;
    }
    else if(nXP < 105000)
    {
        nPercent = (100 * (nXP - 91000)) / 14000;
        nBelowNumber = 282750;
        nAboveNumber = 377000;
    }
    else if(nXP < 120000)
    {
        nPercent = (100 * (nXP - 105000)) / 15000;
        nBelowNumber = 377000;
        nAboveNumber = 490100;
    }
    else if(nXP < 136000)
    {
        nPercent = (100 * (nXP - 120000)) / 16000;
        nBelowNumber = 490100;
        nAboveNumber = 640900;
    }
    else if(nXP < 153000)
    {
        nPercent = (100 * (nXP - 136000)) / 17000;
        nBelowNumber = 640900;
        nAboveNumber = 829400;
    }
    else if(nXP < 171000)
    {
        nPercent = (100 * (nXP - 153000)) / 18000;
        nBelowNumber = 829400;
        nAboveNumber = 1093300;
    }
    else if(nXP < 190000)
    {
        nPercent = (100 * (nXP - 171000)) / 19000;
        nBelowNumber = 1093300;
        nAboveNumber = 1500000;
    }
    else
    {
        nPercent = 100;
        nBelowNumber = 1500000;
        nAboveNumber = 1500000;
    }
	
    return (((nAboveNumber - nBelowNumber) * nPercent) / 100) + nBelowNumber;
}

int GetCutoffWealth(int nXP)
{
    int nPercent, nBelowNumber, nAboveNumber;
    if(nXP < 1000)
    {
        nPercent = (100 * nXP) / 1000;
        nBelowNumber = 13350;
        nAboveNumber = 13350;
    }
    else if(nXP < 3000)
    {
        nPercent = (100 * (nXP - 1000)) / 2000;
        nBelowNumber = 13350;
        nAboveNumber = 13350;
    }
    else if(nXP < 6000)
    {
        nPercent = (100 * (nXP - 3000)) / 3000;
        nBelowNumber = 13350;
        nAboveNumber = 13350;
    }
    else if(nXP < 10000)
    {
        nPercent = (100 * (nXP - 6000)) / 4000;
        nBelowNumber = 13350;
        nAboveNumber = 22225;
    }
    else if(nXP < 15000)
    {
        nPercent = (100 * (nXP - 10000)) / 5000;
        nBelowNumber = 22225;
        nAboveNumber = 32100;
    }
    else if(nXP < 21000)
    {
        nPercent = (100 * (nXP - 15000)) / 6000;
        nBelowNumber = 32100;
        nAboveNumber = 46925;
    }
    else if(nXP < 28000)
    {
        nPercent = (100 * (nXP - 21000)) / 7000;
        nBelowNumber = 46925;
        nAboveNumber = 66700;
    }
    else if(nXP < 36000)
    {
        nPercent = (100 * (nXP - 28000)) / 8000;
        nBelowNumber = 66700;
        nAboveNumber = 88925;
    }
    else if(nXP < 45000)
    {
        nPercent = (100 * (nXP - 36000)) / 9000;
        nBelowNumber = 88925;
        nAboveNumber = 121025;
    }
    else if(nXP < 55000)
    {
        nPercent = (100 * (nXP - 45000)) / 10000;
        nBelowNumber = 121025;
        nAboveNumber = 163025;
    }
    else if(nXP < 66000)
    {
        nPercent = (100 * (nXP - 55000)) / 11000;
        nBelowNumber = 163025;
        nAboveNumber = 217350;
    }
    else if(nXP < 78000)
    {
        nPercent = (100 * (nXP - 66000)) / 12000;
        nBelowNumber = 217350;
        nAboveNumber = 271700;
    }
    else if(nXP < 91000)
    {
        nPercent = (100 * (nXP - 78000)) / 13000;
        nBelowNumber = 271700;
        nAboveNumber = 370500;
    }
    else if(nXP < 105000)
    {
        nPercent = (100 * (nXP - 91000)) / 14000;
        nBelowNumber = 370500;
        nAboveNumber = 494000;
    }
    else if(nXP < 120000)
    {
        nPercent = (100 * (nXP - 105000)) / 15000;
        nBelowNumber = 494000;
        nAboveNumber = 642200;
    }
    else if(nXP < 136000)
    {
        nPercent = (100 * (nXP - 120000)) / 16000;
        nBelowNumber = 642200;
        nAboveNumber = 839800;
    }
    else if(nXP < 153000)
    {
        nPercent = (100 * (nXP - 136000)) / 17000;
        nBelowNumber = 839800;
        nAboveNumber = 1086800;
    }
    else if(nXP < 171000)
    {
        nPercent = (100 * (nXP - 153000)) / 18000;
        nBelowNumber = 1086800;
        nAboveNumber = 1432600;
    }
    else if(nXP < 190000)
    {
        nPercent = (100 * (nXP - 171000)) / 19000;
        nBelowNumber = 1432600;
        nAboveNumber = 2000000;
    }
    else
    {
        nPercent = 100;
        nBelowNumber = 2000000;
        nAboveNumber = 2000000;
    }
	
    return (((nAboveNumber - nBelowNumber) * nPercent) / 100) + nBelowNumber;
}

void main(int nAction, int nTargetObject)
{
    object oPC = OBJECT_SELF;

    if(nAction == PLAYER_REPORT_SHOW_GUI)
    {
        if(GetIsDM(oPC))
        {
            CloseGUIScreen(OBJECT_SELF, "SCREEN_PLAYERLIST");
            DisplayGuiScreen(oPC, "SCREEN_PLAYERREPORT", FALSE, "playerreport.xml");
            ClearListBox(oPC, "SCREEN_PLAYERREPORT", "playerreport");
            object oRowPC = GetFirstPC();
            while(GetIsObjectValid(oRowPC))
            {
                string sName = GetName(oRowPC);
                string sNameDisplay = "<C=#AAAAAA>"+GetPCPlayerName(oRowPC)+"</C> \n  "+sName;
                string sAlignIcon  = GetAlignmentIcon(oRowPC);
                string sDeityIcon  = GetDeityIcon(oRowPC);
                string sClassIcon  = GetMainClassIcon(oRowPC);
                string sWealthIcon = GetWealthIcon(oRowPC);
                AddListBoxRow(oPC, "SCREEN_PLAYERREPORT", "playerreport", sName, "LISTBOX_ITEM_TEXT=  "+sNameDisplay,   "LISTBOX_ALIGN_ICON="+sAlignIcon+";LISTBOX_DEITY_ICON="+sDeityIcon+";LISTBOX_CLASS_ICON="+sClassIcon+";LISTBOX_WEALTH_ICON="+sWealthIcon+";LISTBOX_STYLE_ICON=acr_spade.tga", "5="+IntToString(ObjectToInt(oRowPC)), "unhide");
                oRowPC = GetNextPC();
            }
        }
        else return;
    }

    /*if(!GetIsDM(oPC)) // Commented out during testing.
    {
        SendMessageToPC(OBJECT_SELF, "You are not a DM, and may not do this.");
        return;
    }*/

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