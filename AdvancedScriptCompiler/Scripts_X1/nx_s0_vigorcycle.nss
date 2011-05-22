//::///////////////////////////////////////////////
//:: Vigorous Cycle
//:: NX_s0_Vigorcycle.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	Classes: Cleric 6, Druid 6
	
	Fast healing 1 on entire party for 10 rounds + 1 
	round/level (max 25).
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: 12.04.06
//:://////////////////////////////////////////////
//:: AFW-OEI 07/18/2007: Weaker versions of vigor will not override the stronger versions,
//::	but versions of the same or greater strength will replace each other.

#include "nw_i0_spells" 
#include "nwn2_inc_spells"
#include "x2_inc_spellhook"

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

// End of Spell Cast Hook

    //Declare major variables
	location lTarget = GetSpellTargetLocation();
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    effect eRegen;
    effect eVis = EffectVisualEffect( VFX_DUR_SPELL_VIGOROUS_CYCLE );
	
	int nCasterLevel = GetCasterLevel(OBJECT_SELF);
	
	if (nCasterLevel > 30)
	{
		nCasterLevel = 30;
	}

    int nBonus = 3;
    float fDuration = RoundsToSeconds(10+nCasterLevel); 
    
    //Set the bonus regen effect
    eRegen = EffectRegenerate(nBonus, 6.0);
	eRegen = EffectLinkEffects( eRegen, eVis );

	//Check for metamagic
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
    
	while (GetIsObjectValid(oTarget))
	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, OBJECT_SELF))
		{
			// AFW-OEI 07/18/2007: Strip all vigor effcts and replace them with this spell's effects.
			RemoveEffectsFromSpell(oTarget, SPELL_LESSER_VIGOR);
			RemoveEffectsFromSpell(oTarget, SPELL_MASS_LESSER_VIGOR);
			RemoveEffectsFromSpell(oTarget, SPELL_VIGOR);
			RemoveEffectsFromSpell(oTarget, SPELL_VIGOROUS_CYCLE);
		
			//Fire cast spell at event for the specified target
    		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 1023, FALSE));

			//Apply the bonus effect and VFX impact
    		ApplyEffectToObject(nDurType, eRegen, oTarget, fDuration);
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
}