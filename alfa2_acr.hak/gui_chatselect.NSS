//========================================================
/*
    New Chat Select GUI scripts.
    By: Zelknolf
    2012/1/14

    This script handles the various player interactions
    with the new chat select GUI, and with intentions of
    being compatible with cross-server tells.
*/
//========================================================

#include "acr_server_ipc_i"
#include "acr_scliext_i"


int CHAT_SELECT_EVENT_OPEN      = 1;
int CHAT_SELECT_EVENT_EXPAND    = 2;
int CHAT_SELECT_EVENT_COLLAPSE  = 3;
int CHAT_SELECT_EVENT_CLOSE     = 4;
int CHAT_SELECT_EVENT_STAGETELL = 5;


void main ( string sEvent, string sChatString )
{
    int nEvent = StringToInt(sEvent);
    if(nEvent == CHAT_SELECT_EVENT_OPEN)
    {
        DisplayGuiScreen(OBJECT_SELF, "ChatSelect", FALSE, "chatselect_2.xml");
        CloseGUIScreen(OBJECT_SELF, "SCREEN_PLAYERMENU_POPUP");
        ACR_PopulateChatSelect(GetOwnedCharacter(OBJECT_SELF));
    }
    else if(nEvent == CHAT_SELECT_EVENT_EXPAND)
    {
        SetLocalInt(OBJECT_SELF, "chatselect_expanded", 1);

        // Note that ACR_PopulateChatSelect resets the header text.
        ACR_PopulateChatSelect(GetOwnedCharacter(OBJECT_SELF));
    }
    else if(nEvent == CHAT_SELECT_EVENT_COLLAPSE)
    {
        SetLocalInt(OBJECT_SELF, "chatselect_expanded", 0);

        // Note that ACR_PopulateChatSelect resets the header text.
        DelayCommand(0.2f, SetGUIObjectHidden(OBJECT_SELF, "ChatSelect", "Collapse_Button", TRUE));
        ACR_PopulateChatSelect(GetOwnedCharacter(OBJECT_SELF));
    }
    else if(nEvent == CHAT_SELECT_EVENT_CLOSE)
    {
    }
    else if(nEvent == CHAT_SELECT_EVENT_STAGETELL)
    {
        if(ACR_GetPlayerClientExtensionVersion(GetOwnedCharacter(OBJECT_SELF)) < ACR_MakeClientExtensionVersion(1,0,0,21)) // not a recent-enough CE
        {
            if(GetStringLeft(sChatString, 1) == "#") // tell to a remote server; it'll be awkward, but we need to salvage something.
                DelayCommand(0.1f, SetGUIObjectText(OBJECT_SELF, "SCREEN_MESSAGEMP_1", "inputbox", -1, sChatString));
        }
        else // has CE
        {
            if(GetStringLeft(sChatString, 1) == "#")
            {
                DelayCommand(0.05f, SetGUIObjectText(OBJECT_SELF, "SCREEN_MESSAGEMP_1", "inputbox", -1, ""));
                DelayCommand(0.10f, ACR_OpenChatInputBox(OBJECT_SELF, sChatString));
            }
        }	
    }
}
