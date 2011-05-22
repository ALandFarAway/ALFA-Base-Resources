//::///////////////////////////////////////////////
//:: Invisibility Sphere: On Enter
//:: NW_S0_InvSphA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All allies within 15ft are rendered invisible.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
#include "nw_i0_spells"
#include "x2_inc_spellhook" 
#include "X0_I0_SPELLS"

void main()
{
    //Declare major variables
    object oTarget = GetEnteringObject();
	object oCaster = GetAreaOfEffectCreator();

	effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);   
	effect eVis = EffectVisualEffect(VFX_DUR_INVISIBILITY);
	effect eLink = EffectLinkEffects(eInvis, eVis);
    
	if ( spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster) )
	{ 	
		if (GetIsDead(oTarget) == FALSE)
		{ 	       	
			SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_INVISIBILITY_SPHERE, FALSE));
      		ApplyEffectToObject( DURATION_TYPE_PERMANENT, eLink, oTarget );
		}
	}			
}