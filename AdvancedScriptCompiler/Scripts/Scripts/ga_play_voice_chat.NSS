//::///////////////////////////////////////////////////////////////////////////
//::
//::	ga_play_voice_chat( int nVoiceChat, string sTag )
//::
//::	This is basically just a wrapper for PlayVoiceChat.
/*
		* int nVoiceChat must be one of the following right-hand values:
		
		int	VOICE_CHAT_ATTACK       	=	0;
		int	VOICE_CHAT_BATTLECRY1   	=	1;
		int	VOICE_CHAT_BATTLECRY2   	=	2;
		int	VOICE_CHAT_BATTLECRY3   	=	3;
		int	VOICE_CHAT_HEALME       	=	4;
		int	VOICE_CHAT_HELP         	=	5;
		int	VOICE_CHAT_ENEMIES      	=	6;
		int	VOICE_CHAT_FLEE         	=	7;
		int	VOICE_CHAT_TAUNT        	=	8;
		int	VOICE_CHAT_GUARDME      	=	9;
		int	VOICE_CHAT_HOLD         	=	10;
		int	VOICE_CHAT_GATTACK1     	=	11;
		int	VOICE_CHAT_GATTACK2     	=	12;
		int	VOICE_CHAT_GATTACK3     	=	13;
		int	VOICE_CHAT_PAIN1        	=	14;
		int	VOICE_CHAT_PAIN2        	=	15;
		int	VOICE_CHAT_PAIN3        	=	16;
		int	VOICE_CHAT_NEARDEATH    	=	17;
		int	VOICE_CHAT_DEATH        	=	18;
		int	VOICE_CHAT_POISONED     	=	19;
		int	VOICE_CHAT_SPELLFAILED  	=	20;
		int	VOICE_CHAT_WEAPONSUCKS  	=	21;
		int	VOICE_CHAT_FOLLOWME     	=	22;
		int	VOICE_CHAT_LOOKHERE     	=	23;
		int	VOICE_CHAT_GROUP        	=	24;
		int	VOICE_CHAT_MOVEOVER     	=	25;
		int	VOICE_CHAT_PICKLOCK     	=	26;
		int	VOICE_CHAT_SEARCH       	=	27;
		int	VOICE_CHAT_HIDE         	=	28;
		int	VOICE_CHAT_CANDO        	=	29;
		int	VOICE_CHAT_CANTDO       	=	30;
		int	VOICE_CHAT_TASKCOMPLETE 	=	31;
		int	VOICE_CHAT_ENCUMBERED   	=	32;
		int	VOICE_CHAT_SELECTED     	=	33;
		int	VOICE_CHAT_HELLO        	=	34;
		int	VOICE_CHAT_YES          	=	35;
		int	VOICE_CHAT_NO           	=	36;
		int	VOICE_CHAT_STOP         	=	37;
		int	VOICE_CHAT_REST         	=	38;
		int	VOICE_CHAT_BORED        	=	39;
		int	VOICE_CHAT_GOODBYE      	=	40;
		int	VOICE_CHAT_THANKS       	=	41;
		int	VOICE_CHAT_LAUGH        	=	42;
		int	VOICE_CHAT_CUSS         	=	43;
		int	VOICE_CHAT_CHEER        	=	44;
		int	VOICE_CHAT_TALKTOME     	=	45;
		int	VOICE_CHAT_GOODIDEA     	=	46;
		int	VOICE_CHAT_BADIDEA      	=	47;
		int	VOICE_CHAT_THREATEN     	=	48;	
		
		* string sTag is the tag of the creature that you want to perform 
		the voice chat.
		By default, this creature is the owner of the conversation.
		See ginc_param_const->GetTarget() for more information.
		
		** Not all sound sets have mappings to all the voice chats! **
		If you request a voice chat ID that isn't valid for the target's
		sound set, no sound will play and you WILL NOT receive any feedback
		notifying you that the ID is invalid.
		
		As a general rule, all PC and companion sound sets will contain 
		mappings to all the voice chats.  Other sound sets may contain
		mappings to an attack, battle, pain, and death voice chat, at minimum.
*/
//::
//::///////////////////////////////////////////////////////////////////////////
//::
//::	Created by: Brian Fox
//::	Created on: 9/6/06
//::
//::///////////////////////////////////////////////////////////////////////////
#include "ginc_param_const"


void main( int nVoiceChat, string sTag )
{
	object oTarget = GetTarget( sTag );
	
	if ( GetIsObjectValid(oTarget) )
	{
		PlayVoiceChat( nVoiceChat, oTarget );
	}
	else
	{
		PrettyError( "ga_play_voice_chat ERROR: " + sTag + " is not a valid object!" );
	}
}


