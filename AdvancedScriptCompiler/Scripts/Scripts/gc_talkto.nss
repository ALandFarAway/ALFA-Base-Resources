// gc_talkto(string sTarget)
/* This checks to see if you have not talked to this person before. See ga_talkto.nss.

   Parameters:
     string sTarget = Target of the NPC. If blank, use dialog OWNER.
*/
// FAB 9/30
// BMA 4/28/05 added GetTarget()

#include "ginc_param_const"

int StartingConditional(string sTarget)
{
    object oTarget = GetTarget(sTarget, TARGET_OWNER);
    
    if (GetLocalInt(oTarget, "TalkedTo") != 1)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}

