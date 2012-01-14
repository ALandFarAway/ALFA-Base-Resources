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


void main ( int nEvent, string sChatString )
{
    if(nEvent == CHAT_SELECT_EVENT_OPEN)
    {
        ACR_CallIPCScript(ACR_SERVER_IPC_POPULATE_CHAT_SELECT, 0, 0, 0, 0, 0, "", OBJECT_SELF);
    }
    else if(nEvent == CHAT_SELECT_EVENT_EXPAND)
    {
        SetLocalInt(OBJECT_SELF, "chatselect_expanded", 0);
        ACR_CallIPCScript(ACR_SERVER_IPC_POPULATE_CHAT_SELECT, 0, 0, 0, 0, 0, "", OBJECT_SELF);
    }
    else if(nEvent == CHAT_SELECT_EVENT_COLLAPSE)
    {
        SetLocalInt(OBJECT_SELF, "chatselect_expanded", 1);
        ACR_CallIPCScript(ACR_SERVER_IPC_POPULATE_CHAT_SELECT, 0, 0, 0, 0, 0, "", OBJECT_SELF);
    }
    else if(nEvent == CHAT_SELECT_EVENT_CLOSE)
    {
    }
    else if(nEvent == CHAT_SELECT_EVENT_STAGETELL)
    {
        if(ACR_GetPlayerClientExtensionVersion(OBJECT_SELF) < ACR_MakeClientExtensionVersion(1,0,0,21)) // not a recent-enough CE
            SetGUIObjectText(OBJECT_SELF, "SCREEN_MESSAGEMP_1", "inputbox", -1, sChatString);
        else // has CE
        {
            SetGUIObjectText(OBJECT_SELF, "SCREEN_MESSAGEMP_1", "inputbox", -1, "");
            SendMessageToPC(OBJECT_SELF, "SCliExt15"+sChatString);
        }	
    }
}