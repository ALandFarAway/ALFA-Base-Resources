////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ACR GUI Script
//     Filename : gui_infestation
//        $Date:: 2014-10-11#$ date the file was created or modified
//       Author : Zelknolf
//
//    Var Prefix: ACR_GUI
//  Dependencies: None
//
//  Description
//  This script is called from the infestation GUI.
//
//  Revision History
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_quest_i"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

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

void main(string Command, string Param1, int Param2)
{
    if(!GetIsDM(OBJECT_SELF))
    {
        SendMessageToPC(OBJECT_SELF, "Only DMs may use this script.");
        return;
    }
    
    string sInfest = GetLocalString(GetArea(OBJECT_SELF), ACR_QST_INFESTATION_NAME);
    
    if(Command == "1")
    {
        PopulateInfestationGui();
    }
    else if(Command == "2")
    {
        string spawnUI = "target_single.xml";
        string spawnUIScreenName = "TARGET_SINGLE";
        SetGlobalGUIVariable(OBJECT_SELF, 199, "gui_infestpick");
        SetGlobalGUIVariable(OBJECT_SELF, 200, "");
        SetGlobalGUIVariable(OBJECT_SELF, 198, "creature");
        SetGlobalGUIVariable(OBJECT_SELF, 201, "2");
        DisplayGuiScreen(OBJECT_SELF, spawnUIScreenName, 0, spawnUI, 0);
    }
    else if(Command == "3")
    {
        if(sInfest == "") 
        {
            SendMessageToAllDMs("No infestation found to remove creatures from.");
            return;
        }
        if(Param1 == "")
        {
            SendMessageToAllDMs("No creature found to remove from infestation.");
            return;
        }
        if(Param2 == 0)
        {
            SendMessageToAllDMs("Tier to remove from is invalid.");
            return;
        }
        RemoveInfestationSpawn(sInfest, Param2, Param1);
        PopulateInfestationGui();
    }
    else if(Command == "4")
    {
        string spawnUI = "target_single.xml";
        string spawnUIScreenName = "TARGET_SINGLE";
        SetGlobalGUIVariable(OBJECT_SELF, 199, "gui_infestpick");
        SetGlobalGUIVariable(OBJECT_SELF, 200, "");
        SetGlobalGUIVariable(OBJECT_SELF, 198, "creature");
        SetGlobalGUIVariable(OBJECT_SELF, 201, "4");
        DisplayGuiScreen(OBJECT_SELF, spawnUIScreenName, 0, spawnUI, 0);
    }
    else if(Command == "5")
    {
        if(sInfest == "") 
        {
            SendMessageToAllDMs("No infestation found to remove bosses from.");
            return;
        }
        if(Param1 == "")
        {
            SendMessageToAllDMs("No boss found to remove from infestation.");
            return;
        }
        RemoveInfestationBoss(sInfest, Param1);
        PopulateInfestationGui();
    }
    else if(Command == "6")
    {
        if(sInfest == "") 
        {
            SendMessageToAllDMs("No infestation found to remove creatures from.");
            return;
        }
        if(Param1 == "")
        {
            SendMessageToAllDMs("No creature found to remove from infestation.");
            return;
        }
        if(Param2 == 0)
        {
            SendMessageToAllDMs("Tier to increase from is invalid.");
            return;
        }
        IncreaseInfestationCreatureTier(sInfest, Param1, Param2);
        PopulateInfestationGui();
    }
    else if(Command == "7")
    {
        if(sInfest == "") 
        {
            SendMessageToAllDMs("No infestation found to remove creatures from.");
            return;
        }
        if(Param1 == "")
        {
            SendMessageToAllDMs("No creature found to remove from infestation.");
            return;
        }
        if(Param2 == 0)
        {
            SendMessageToAllDMs("Tier to decrease from is invalid.");
            return;
        }
        DecreaseInfestationCreatureTier(sInfest, Param1, Param2);
        PopulateInfestationGui();
    }
}