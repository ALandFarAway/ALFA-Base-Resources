// gb_assoc_attack
/*
    Associate On Attacked
    
*/
// ChazM 2/15/07

#include "X0_INC_HENAI"

void main()
{
    SpeakString("NW_I_WAS_ATTACKED", TALKVOLUME_SILENT_TALK);
    if(!GetAssociateState(NW_ASC_IS_BUSY))
    {
        SetCommandable(TRUE);
        if(!GetAssociateState(NW_ASC_MODE_STAND_GROUND))
        {
            if(!GetIsObjectValid(GetAttackTarget()) && !GetIsObjectValid(GetAttemptedSpellTarget()))
            {
                if(GetIsObjectValid(GetLastAttacker()))
                {
                    if(GetAssociateState(NW_ASC_MODE_DEFEND_MASTER))
                    {
                        object oTarget = GetLastAttacker(GetMaster());
                        HenchmenCombatRound(oTarget);
                    }
                    else
                    {
                        HenchmenCombatRound(OBJECT_INVALID);
                    }

                }
            }
            if(GetSpawnInCondition(NW_FLAG_ATTACK_EVENT))
            {
                SignalEvent(OBJECT_SELF, EventUserDefined(1005));
            }
        }
    }
}

