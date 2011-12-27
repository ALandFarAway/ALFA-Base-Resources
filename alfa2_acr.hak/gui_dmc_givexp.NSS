////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ACR GUI Script
//     Filename : gui_dmc_givexp
//    $Revision:: 542        $ current version of the file
//        $Date:: 2008-11-15#$ date the file was created or modified
//       Author : Cipher
//
//    Var Prefix: ACR_GUI
//  Dependencies: None
//
//  Description
//  This script is called from the Give Experience radial option on the DM context menu.
//
//  Revision History
//  2008/04/08  Cipher  Inception
//  2008/04/14  Cipher  Do not log XP awards to non PCs.
//  2008/04/15  Cipher  Reformatted log message slightly.
//  2008/04/15  Cipher  Migrated XP award and logging to acr_xp_i
//  2008/04/23  Cipher  Fixed party XP bug, renamed oPC to oDM for clarity
//  2008/04/23  Cipher  Added notification of XP reward to targeted PC
//  2008/05/12  Cipher  Added recommended GP reward value to help guide DMs
//  2008/11/15  AcadiusLost  Added reporting of PC's % RPXP for DMs
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#include "acr_xp_i"
#include "acr_1984_i"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
const string ACR_GUI_SCREEN_DM_GIVEXP = "SCREEN_DM_GIVEXP";
const string ACR_GUI_FILENAME_DM_GIVEXP = "dmgivexp.xml";

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void main(int nQuestRating, int nRPRating, float fSessionLength, int nRPBonus, int bInit, int bAwardXP, int bPartyXP)
{
    object oDM = OBJECT_SELF;
    object oTarget = GetPlayerCurrentTarget(oDM);

    // only allow script execution by DMs
    if (!(GetIsDM(oDM) || GetIsDMPossessed(oDM))) { return; }
	// gather the % RPXP
	string sRPXP = FloatToString(GetLocalFloat(oTarget, _RPXP_PERCENT), 2, 1);
	
    // compute the XP
    int nXP = FloatToInt((nQuestRating + nRPRating) * fSessionLength) + nRPBonus;

    // initialization - launch the GUI
    if (bInit)
    {
        // display the xp input screen and xp total of the target player on the GUI
        DisplayGuiScreen(oDM, ACR_GUI_SCREEN_DM_GIVEXP, FALSE, ACR_GUI_FILENAME_DM_GIVEXP);

        // initialize the local GUI variables with defaults for totalling XP properly on-screen
        SetLocalGUIVariable(oDM, ACR_GUI_SCREEN_DM_GIVEXP, 0, IntToString(nQuestRating));
        SetLocalGUIVariable(oDM, ACR_GUI_SCREEN_DM_GIVEXP, 1, IntToString(nRPRating));
        SetLocalGUIVariable(oDM, ACR_GUI_SCREEN_DM_GIVEXP, 2, FloatToString(fSessionLength,2,1));
        SetGUIObjectText(oDM, ACR_GUI_SCREEN_DM_GIVEXP, "TITLE", -1, "Give XP to " + GetName(oTarget));
    }

    // if XP shouldn't be awarded yet, display the total on the GUI for review
    if (!bAwardXP)
    {
        float fFactor; int nECL = ACR_GetECL(oTarget);

        // determine the multiplication factor for determining GP reward
        if (nECL <= 8) { fFactor = 1.25; }
        else if (nECL <= 12) { fFactor = 2.5; }
        else if (nECL <= 16) { fFactor = 5.0; }
        else { fFactor = 10.0; }

        SetGUIObjectText(oDM, ACR_GUI_SCREEN_DM_GIVEXP, "MESSAGETEXT", -1, "<b>TOTAL XP:  <color=red>" + IntToString(nXP) + "</b></color>\n\n(" + IntToString(nQuestRating) + "xp + " + IntToString(nRPRating) + "xp) x " + FloatToString(fSessionLength,2,1) + "hrs\n\n\n<b>Recommended Reward Value:  " + FloatToString(nXP * fFactor, 0, 0) + "gp</b>");
    }
    // otherwise, process the input
    else
    { 
        // close the GUI and give the target player the experience points
        CloseGUIScreen(oDM, ACR_GUI_SCREEN_DM_GIVEXP);

        // award and log the xp
        ACR_AwardDMSessionXP(oTarget, oDM, fSessionLength, nRPRating, nQuestRating, nRPBonus);
        SendMessageToPC(oDM, GetName(oTarget) + " awarded " + IntToString(nXP) + "xp");

        // loop through party members for party rewards
        if (bPartyXP)
        {
            object oPartyMember = GetFirstFactionMember(oTarget);

            // create a quest entry for all the players in the party
            while (GetIsObjectValid(oPartyMember))
            {
                // skip the targeted player - they have already received the XP
                if (oPartyMember != oTarget)
                {
                    // award and log the xp, notify the awarding DM
                    ACR_AwardDMSessionXP(oPartyMember, oDM, fSessionLength, nRPRating, nQuestRating, nRPBonus);
                    SendMessageToPC(oDM, GetName(oPartyMember) + " awarded " + IntToString(nXP) + "xp");
                }
                oPartyMember = GetNextFactionMember(oTarget);
            }
        }
    }
	SendMessageToPC(oDM, GetName(oTarget)+" has earned "+sRPXP+"% of their XP from the RPXP scripts.");
}
