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

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

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

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// This is a generic function used to send notifications to players.
// oPC is the creature object representing the player to be notified. If oPC is not controlled by a player, this function fails.
// nNotifyType refers to the NOTIFY_TYPE_ constants.
// sNotifyAbbreviation is the one-line message to be displayed in the tickler display
// sNotifyMessage is the full content of the message to be sent to oPC
// sNotifyWindow is the GUI window to be used. If left blank, a generic message box will be used.
void NotifyPlayer( object oPC, int nNotifyType, string sNotifyAbbreviation, string sNotifyMessage, string sNotifyWindow="");

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// *** BEGIN PUBLIC FUNCTIONS ***
////////////////////////////////////////////////////////////////////////////////

void NotifyPlayer( object oPC, int nNotifyType, string sNotifyWindow, string sNotifyAbbreviation, string sNotifyMessage)
{
// TODO: Everything here
    SendMessageToPC(oPC, sNotifyMessage);
}