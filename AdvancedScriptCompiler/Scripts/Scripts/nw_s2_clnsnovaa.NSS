//::///////////////////////////////////////////////
//:: Cleansing Nova: On Enter
//:: nw_s2_clnsnovaa.nss
//:: Copyright (c) 2006 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
    New targets entering the nova may take damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On:04/24/2006
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

int GetIsValidNovaTarget( object oTarget )
{
	int nRacialType = GetRacialType(oTarget);
	if ( nRacialType == RACIAL_TYPE_UNDEAD ||	// Only target Undead OR Outsiders
		 nRacialType == RACIAL_TYPE_OUTSIDER )
		return TRUE;

	return FALSE;
}
	
void main()
{
    //Declare major variables
	object oCaster 		= GetAreaOfEffectCreator();
	int    nCasterLevel = GetTotalLevels( oCaster, TRUE );
    effect eDam    	 	= EffectDamage(nCasterLevel, DAMAGE_TYPE_FIRE);		// Nova damage = character level
    object oTarget 		= GetEnteringObject();	    							// Capture the entering object.
	
    //Declare and assign personal impact visual effect.
    effect eVis = EffectVisualEffect( VFX_HIT_SPELL_FIRE );	//
	effect eLink = EffectLinkEffects( eDam, eVis );
	
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELLABILITY_CLEANSING_NOVA));

		if (GetIsValidNovaTarget(oTarget))
		{
	        //Make SR check.
	        if(!MyResistSpell(oCaster, oTarget))
	        {
                // Apply effects to the currently selected target.
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
                //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	         }
		}
    }
}