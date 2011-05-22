// gb_assoc_conv
/*
	Associate On Conversation
    
    Determines the course of action to be taken
    by the generic script after dialogue or a
    shout is initiated.

*/
// ChazM 2/15/07
// EPF 7/25/07 - henchmen respond to commands from anybody in their faction if it's a single player game - prevents players from
// having to possess the henchman's master in order to assign it commands.

#include "x0_inc_henai"
// * This function checks to make sure no
// * dehibilating effects are on the player that should
// * Don't use getcommandable for this since the dying system
// * will sometimes leave a player in a noncommandable state
int AbleToTalk(object oSelf)
{
    if (GetCommandable(oSelf) == FALSE)
    {
        if (GetHasEffect(EFFECT_TYPE_CONFUSED, oSelf) || GetHasEffect(EFFECT_TYPE_DOMINATED, oSelf) ||
            GetHasEffect(EFFECT_TYPE_PETRIFY, oSelf) || GetHasEffect(EFFECT_TYPE_PARALYZE, oSelf)   ||
            GetHasEffect(EFFECT_TYPE_STUNNED, oSelf) || GetHasEffect(EFFECT_TYPE_FRIGHTENED, oSelf)
        )
        {
            return FALSE;
        }
    }
    return TRUE;
}
void main()
{
    object oMaster = GetMaster();
    int nMatch = GetListenPatternNumber();
    object oShouter = GetLastSpeaker();
    object oIntruder;

    if (nMatch == -1) {
        if(AbleToTalk(OBJECT_SELF) || GetCurrentAction() != ACTION_OPENLOCK)
        {
            ClearActions(CLEAR_NW_CH_AC4_28);
            
            // * if in XP2, use an alternative dialog file
            string sDialog = "";
            if (GetLocalInt(GetModule(), "X2_L_XP2") ==  1)
            {
                sDialog = "x2_associate";
            }
            BeginConversation(sDialog);
        }
    } else {
        // listening pattern matched. Respond to the master, or anybody in the faction if it's a single player game
        if (GetIsObjectValid(oShouter) && (oMaster == oShouter || (GetIsSinglePlayer() && GetFactionEqual(oShouter,OBJECT_SELF))))
        {
            SetCommandable(TRUE);
            bkRespondToHenchmenShout(oShouter, nMatch, oIntruder, TRUE);
        }
    }

    // Signal user-defined event
    if(GetSpawnInCondition(NW_FLAG_ON_DIALOGUE_EVENT)) {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_DIALOGUE));
    }
}