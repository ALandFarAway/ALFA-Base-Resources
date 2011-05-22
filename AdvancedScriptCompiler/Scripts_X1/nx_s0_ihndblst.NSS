//::///////////////////////////////////////////////
//:: Invocation: Hindering Blast (Warlock Invocation)
//:: nx_s0_ihndblst.nss
//:://////////////////////////////////////////////
/*
	Hindering Blast
	Greater, 4th, Eldritch Essence
	 
	You transform your eldritch blast into a
	hindering blast.  Any living creature struck by
	a hindering blast must succeed on a Will save or
	be slowed for 1 round in addition to the normal
	damage from the blast.
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
    DoEssenceHinderingBlast(OBJECT_SELF, oTarget);
	
	// signal event done in DoEldritchBlast()
}