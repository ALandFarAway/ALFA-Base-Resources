//::///////////////////////////////////////////////
//:: Snake's Swiftness
//:: NX2_S0_SnakeSwift.nss
//:: Copyright (c) 2008 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	
*/
//:://////////////////////////////////////////////
//:: Created By: Justin Reynard (JWR-OEI)
//:: Created On: 07/29/2008
//:://////////////////////////////////////////////


#include "nw_i0_spells"
#include "x2_inc_spellhook"

void main()
{
	 if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
	
	object oTarget = GetSpellTargetObject(); // should NOT be OBJECT_SELF

	if ( !GetHasSpellEffect(SPELL_SNAKES_SWIFTNESS, oTarget) )
	{
		effect eHaste = EffectHaste();
   		effect eDur = EffectVisualEffect( VFX_HIT_SPELL_SNAKESSWIFTNESS );
    	effect eLink = EffectLinkEffects(eHaste, eDur);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1));
	}
	
	
}