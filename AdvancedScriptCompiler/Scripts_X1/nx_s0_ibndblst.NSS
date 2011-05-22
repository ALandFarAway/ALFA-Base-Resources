//::///////////////////////////////////////////////
//:: Invocation: Binding Blast (Warlock Invocation)
//:: nx_s0_ibndblst.nss
//:://////////////////////////////////////////////
/*
	Binding Blast
	Dark; 7th, Eldritch Essence
	 
	You transform your eldritch blast into a
	binding blast.  Any creature struck by a binding
	blast must succeed on a Will save or be stunned
	for 1 round.  This is a mind-affecting effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 05/08/2007
//:://////////////////////////////////////////////


#include "nw_i0_invocatns"
#include "x2_inc_spellhook" 

void main()
{
    if (!X2PreSpellCastCode())
    {	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    //Declare major variables
    object oTarget = GetSpellTargetObject();

    // Additional Effects: (Combust Effect)
    DoEssenceBindingBlast(OBJECT_SELF, oTarget);
	
	// signal event done in DoEldritchBlast()
}