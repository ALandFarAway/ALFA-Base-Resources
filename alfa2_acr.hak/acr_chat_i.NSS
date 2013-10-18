////////////////////////////////////////////////////////////////////////////////
//
//  System Name : Alfa Core Rules
//     Filename : acr_chat_script
//        Date  : 2007-11-30
//       Author : AcadiusLost
//
//    Var Prefix: ACR_CHAT_
//  Dependencies: NWNx4, xp_chat plugin
//
//  Description
//  hooks emotes and spoken words, to validate activity for RP XP caching
//
//  Revision History
//  date  author  remarks
//  2007/11/30  AcadiusLost   Inception
//
////////////////////////////////////////////////////////////////////////////////

#ifndef ACR_CHAT_I
#define ACR_CHAT_I

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_xp_i"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void ACR_InitializeChat() {
    // adapted from SIMTools, fky_chat_inc.nss
    int nCount;
    object oMod = GetModule();
    // Allocate Memory
    //string sMemory;
    //for( nCount = 0; nCount < 8; nCount++ ) // Reserve 8*128 bytes
    //    sMemory += "................................................................................................................................";
    //SetLocalString(oMod, "NWNX!CHAT!SPACER", sMemory);
}


void ACR_ChatOnClientEnter(object oPlayer)
{
  if( !GetIsObjectValid(oPlayer) ) return;

  object oMod = GetModule();
  //SetLocalString(oPlayer, "NWNX!CHAT!GETID", ObjectToString(oPlayer) + "        ");
  //string sID = GetLocalString(oPlayer, "NWNX!CHAT!GETID");
  //int nID = StringToInt(sID);
  //if( nID != -1)
  //{
  //  SetLocalObject(oMod, "SpeechList_" + sID, oPlayer);
  //  SetLocalInt(oPlayer, "SpeechPlayerID_", nID);
  //}
  //DeleteLocalString(oPlayer, "NWNX!CHAT!GETID");
}


void ACR_ChatOnClientExit(object oPlayer)
{
  if( !GetIsObjectValid(oPlayer) ) return;

  //int nID = GetLocalInt(oPlayer, "SpeechPlayerID_");
  //DeleteLocalInt(oPlayer, "SpeechPlayerID_");
  //DeleteLocalObject(GetModule(), "SpeechList_" + IntToString(nID));
}

#endif