//::///////////////////////////////////////////////
//:: Aid, Mass
//:: NX_s0_massaid.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	Aid, Mass
	Enchantment (Compulsion)[Mind Affecting]
	Level: Cleric 3
	Range: Close
	Duration: ?
	Targets: One or more creatures within a 30ft radius.
	 
	Subjects gain +1 on attack rolls and saves against fear
	effects plus temporary hitpoints equal to 1d8 + caster
	level (to a maximum of 1d8 + 15 at caster level 15).
*/
//:://////////////////////////////////////////////
//:: Created By: Ryan Young
//:: Created On: 1.12.2007
//::
//:: Modification of nw_s0_aid.nss
//::
//:://////////////////////////////////////////////
//:: Updates to scripts go here.

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


    // Declare major variables
    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
    float fDuration = TurnsToSeconds(nCasterLvl);
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	location lTarget = GetSpellTargetLocation();

	// effects
    effect eAttack = EffectAttackIncrease(1);
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_FEAR);
    effect eVis = EffectVisualEffect(VFX_DUR_SPELL_AID);
    effect eLink = EffectLinkEffects(eAttack, eSave);
	eLink = EffectLinkEffects(eLink, eVis);

	// find the first target
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	object oCaster = OBJECT_SELF;
	
	while (GetIsObjectValid(oTarget)) {
		if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster)) {
		
			//Fire cast spell at event for the specified target
    		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
			
			//if (!MyResistSpell(oCaster, oTarget)) {
				int nBonus = d8(1);
			    //Enter Metamagic conditions
			    nBonus = ApplyMetamagicVariableMods(nBonus, 8);
				
				// apply level cap
				if (nCasterLvl >= 15) {
					nBonus = nBonus + 15;
				}
				else {
					nBonus = nBonus + nCasterLvl;
				}
				// different HP bonus for each creature inside the radius
				effect eHP = EffectTemporaryHitpoints(nBonus);    

				//FIX: for the last time, STOP linking HP to other effects,
				//     otherwise they get canceled the moment HP gets depleted
				//effect eTotal = EffectLinkEffects(eLink, eHP);
				effect eOnDispell = EffectOnDispel(0.0f, RemoveEffectsFromSpell(oTarget, 1052)); //linking for dispel is fine
				effect eTotal = EffectLinkEffects(eLink, eOnDispell);
				eHP = EffectLinkEffects(eHP, eOnDispell);

    			//should not stack with Aid or itself
    			RemoveEffectsFromSpell(oTarget, SPELL_AID);
    			RemoveEffectsFromSpell(oTarget, GetSpellId());

    			//Apply the VFX impact and effects
    			ApplyEffectToObject(nDurType, eTotal, oTarget, fDuration);
    			ApplyEffectToObject(nDurType, eHP, oTarget, fDuration);
			//}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}		
}