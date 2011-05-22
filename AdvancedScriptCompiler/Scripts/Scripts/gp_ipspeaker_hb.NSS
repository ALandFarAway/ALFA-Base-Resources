// gp_ipspeaker_hb
/*
   Heartbeat handler to start conversation with the PC when conditions are safe.
   Safe being, NPC speaker and PC (including faction) are not in combat nor in conversation.

   Used with gg_death_talk.nss (GroupOnDeathBeginConversation)
*/
// BMA-OEI 1/24/06

#include "ginc_debug"
#include "ginc_ipspeaker"
#include "ginc_cutscene"

void main()
{
	IPSpeakerHeartbeat();
}