//::///////////////////////////////////////////////
//:: [Recall Spirit] 
//:: [acr_s0_recallspirit.nss]
//:://////////////////////////////////////////////
//:: Raise the target from the dead without penalty
//:: so long as the target has been dead for less
//:: than two rounds.
//:://////////////////////////////////////////////
//:: Created By: Zelknolf
//:: Created On: Nov 22, 2011
//:://////////////////////////////////////////////

// Modified by Riotnrrd for ALFA 1/7/2009
// Changed duration 1 hr / level
// Reduce save DC by 5 if is in combat

#include "x0_I0_SPELLS"    
#include "x2_inc_spellhook" 
#include "acr_death_i"

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
*/

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    object oTarget = GetSpellTargetObject();
    if(!ACR_GetIsCorpse(oTarget))
    {
        SendMessageToPC(OBJECT_SELF, "You can not bring someone back from the dead until that person has died.");
        return;
    }

    int nRaiseAt = (GetTimeHour() * 3600) + (GetTimeMinute() * 60) + GetTimeSecond());
    int nDeadAt  = ACR_GetPersistentInt(oCorpse, ACR_DTH_INSTANT);

    int nRaiseDay = (GetCalendarYear() * 336) + (GetCalendarMonth() * 28) + GetCalendarDay();
    int nDeadDay  = ACR_GetPersistentInt(oCorpse, ACR_DTH_TIMESTAMP);

    if(nDeadAt > 86388 && nRaiseAt < 12 && abs(nRaiseDay - nDeadDay) == 1)
    {
        nDeadAt -= 86400;
        int nDeadFor = nRaiseAt - nDeadAt;
        if(nDeadFor <= 12)
        {
            ACR_CorpseOnResurrect(OBJECT_SELF, oTarget, 1157);
            return;
        }
        else
        {
            SendMessageToPC(OBJECT_SELF, "That person has been dead too long to be brought back.");
            return;
        }
    }
    else if(nRaiseDay == nDeadDay && (nRaiseAt - nDeadAt) <= 12)
    {
        ACR_CorpseOnResurrect(OBJECT_SELF, oTarget, 1157);
        return;
    }
    else
    {
        SendMessageToPC(OBJECT_SELF, "That person has been dead too long to be brought back.");
        return;
    }
}