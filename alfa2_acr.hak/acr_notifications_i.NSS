////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_notifications_i.nss
//    $Revision:: 655      $ current version of the file
//        $Date:: 2012-06-01#$ date the file was created or modified
//       Author : Zelknolf
//
//   Var Prefix : 
//  Dependencies:
//
//  Description
//  This script controls a generic messaging format, meant to present the large
//  quantities of information that our core rules attempt to convey more digestable
//
//  Revision History
//  2012/06/01 - Inception
//
////////////////////////////////////////////////////////////////////////////////

#ifndef ACR_NOTIFICATIONS_I
#define ACR_NOTIFICATIONS_I

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// This is used for items which require action and input from the player
// for proper function in play.
// This type of message cannot be supressed.
const int NOTIFY_TYPE_URGENT  = 0;

// This is used to tell the player of things which are broken, though the
// player may or may not need to actually act on the information, depending
// on other unchecked factors.
// This type of message cannot be supressed.
const int NOTIFY_TYPE_ERROR   = 1;

// This is used to tell the player of things which are not ideal, and which the
// player would likely benefit from acting on, though which do not require
// action.
// This type of message can be supressed.
const int NOTIFY_TYPE_WARNING = 2;

// This is used to provide simple information to the player, which doesn't
// necessarily provide benefit.
// This type of message cannot be supressed.
const int NOTIFY_TYPE_INFO    = 3;

// This is used to provide helpful input to some means of play, which is meant
// to enhance play or use of th engine.
// This type of message can be supressed.
const int NOTIFY_TYPE_TIP     = 4;

const string NOTIFY_EVENT_CLICKED_TICKER = "1";

const string NOTIFY_EVENT_DISMISSED_TICKLER = "2";

// When provided as a window type for use with the notifications system, this 
// refers to a typical message box with the OK and Cancel buttons. If no
// cancel button is specified, no cancel button is drawn.
const string NOTIFY_WINDOW_MESSAGE_BOX = "messagebox";

// When provided as a window type for use with the notifications system, this
// refers to a message with no message box. If a verbose message is provided
// anyway, the verbose message will be sent to the server window.
const string NOTIFY_WINDOW_NO_CALLBACK = "nocallback";


// When provided as a window type for use with the notifications system, this
// refers to a message box which has the URL element associated with the on
// click. In this unique case, the OK Callback is the URL to be used.
const string NOTIFY_WINDOW_URL_BOX = "urlbox";

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// This is a generic function used to send notifications to players.
// oPC is the creature object representing the player to be notified. If oPC is not controlled by a player, this function fails.
// nNotifyType refers to the NOTIFY_TYPE_ constants.
// sNotifyAbbreviation is the one-line message to be displayed in the tickler display
// sNotifyMessage is the full content of the message to be sent to oPC
// sNotifyWindow is the GUI window to be used. If left blank, a generic message box will be used.
void NotifyPlayer( object oPC, int nNotifyType, string sNotifyAbbreviation, string sNotifyMessage, string sNotifyWindow="", string sOKCB="", string sCancelCB="", string sOKText="", string sCancelText="");

// This is a generic function used to continue the message-sending process after a
// player has responded to the tickler.
// oPC is the clicking object.
// sRowName is the name of the row and the ID of the event.
// sNotifyWindow is the kind of window used to send the message.
// sNotifyMessage is the full text of the message.
void HandleRowClick( object oPC, string sRowName, string sNotifyWindow, string sNotifyMessage, string sOKCB="", string sCancelCB="", string sOKText="", string sCancelText="");

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// *** BEGIN PUBLIC FUNCTIONS ***
////////////////////////////////////////////////////////////////////////////////

int _GetUniqueMessageId()
{
    int nReturn = GetLocalInt(GetModule(), "ACR_NOTIFY_MESSAGE_NUMBER") + 1;
    SetLocalInt(GetModule(), "ACR_NOTIFY_MESSAGE_NUMBER", nReturn);
    return nReturn;
}

string _GetIconFromType(int nNotifyType)
{
    if(nNotifyType == NOTIFY_TYPE_URGENT)  return "notify_urg.tga";
    if(nNotifyType == NOTIFY_TYPE_ERROR)   return "notify_err.tga";
    if(nNotifyType == NOTIFY_TYPE_WARNING) return "notify_war.tga";
    if(nNotifyType == NOTIFY_TYPE_INFO)    return "notify_inf.tga";
    if(nNotifyType == NOTIFY_TYPE_TIP)     return "notify_tip.tga";
    return "";
}

void NotifyPlayer( object oPC, int nNotifyType, string sNotifyAbbreviation, string sNotifyMessage, string sNotifyWindow="", string sOKCB="", string sCancelCB="", string sOKText="", string sCancelText="")
{
    DisplayGuiScreen(oPC, "SCREEN_NOTIFY", FALSE, "notifylist.xml");

    // Assign the message a unique number, so we can check against it later.
    int nMessageNumber = _GetUniqueMessageId();
    string sRowName = "NOTIFY_PLAYER_"+IntToString(nMessageNumber);
    SetLocalString(GetModule(), sRowName, GetName(oPC));
    string sIcon = _GetIconFromType(nNotifyType);
    AddListBoxRow(oPC, "SCREEN_NOTIFY", "notify", sRowName, "LISTBOX_ITEM_TEXT="+sNotifyAbbreviation, "LISTBOX_ITEM_ICON="+sIcon, "6="+sRowName+";7="+sNotifyWindow+";8="+sNotifyMessage+";9="+sOKCB+";10="+sCancelCB+";11="+sOKText+";12="+sCancelText, "unhide");
}

void HandleRowClick( object oPC, string sRowName, string sNotifyWindow, string sNotifyMessage, string sOKCB="", string sCancelCB="", string sOKText="", string sCancelText="")
{
    string sTargetName = GetLocalString(GetModule(), sRowName);
    if(sTargetName != GetName(oPC))
    {
        // This might actually be a malicious user, but let's be coy. Plus, what if it's a bug?
        SendMessageToPC(oPC, "Whoops! That message wasn't actually for you. Please ignore it.");
        RemoveListBoxRow(oPC, "SCREEN_NOTIFY", "notify", sRowName);
        return;
    }

    // Make sure we only use the message once.
    DeleteLocalString(GetModule(), sRowName);

    // Message box
    if(sNotifyWindow == NOTIFY_WINDOW_MESSAGE_BOX)
    {
        // If we didn't specify a cancel button text, then we don't show it.
        int bCancel = TRUE;
        if(sCancelText == "") bCancel = FALSE;
        DisplayMessageBox(oPC, -1, sNotifyMessage, sOKCB, sCancelCB, bCancel, "SCREEN_MESSAGEBOX_DEFAULT", -1, sOKText, -1, sCancelText);
    }
    else if(sNotifyWindow == NOTIFY_WINDOW_URL_BOX)
    {
        // TODO: hook up Basilica's URL box and call this for the Client Extension version and 
        // Community ID to Drupal ID link messages.
    }
    else
    {
        if(sNotifyMessage != "")
            SendMessageToPC( oPC, sNotifyMessage );
    }

    // Still want to dismiss the row at the end.
    RemoveListBoxRow(oPC, "SCREEN_NOTIFY", "notify", sRowName);
}

#endif