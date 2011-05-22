// ga_talkto(string sTarget)
/* Set "TalkedTo" flag that you have talked to the target.

   Parameters:
     string sTarget = Tag of the NPC. If blank, use OBJECT_SELF.
*/
// FAB 9/30
// BMA 4/28/05 added GetTarget()

#include "ginc_param_const"

void main(string sTarget)
{
    object oTarget = GetTarget(sTarget, TARGET_OBJECT_SELF);

    SetLocalInt(oTarget, "TalkedTo", 1);
}
