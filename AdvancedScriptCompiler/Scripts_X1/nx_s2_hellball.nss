//::///////////////////////////////////////////////
//:: Hellball
//:: nx_s2_hellball
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Type of Feat: Epic
	Prerequisites: 21st level, Spellcraft 30, the ability to cast 9th level spells.
	Specifics: The character can cast the Epic Spell Hellball.
	
	Classes: Druid, Duskblade, Wizard, Sorcerer, Spirit Shaman, Warlock
	Spellcraft Required: 30
	Caster Level: Epic
	Innate Level: Epic
	School: Evocation
	Descriptor(s): Fire, Acid, Electrical, Sonic
	Components: Verbal, Somatic
	Range: Long
	Area of Effect / Target: Huge
	Duration: Instant
	Save: Reflex ½ (DC +5)
	Spell Resistance: Yes
	
	You unleash a massive blast of energy that detonates upon all in the area of effect,
	dealing 10d6 fire damage, 10d6 acid damage, 10d6 electrical damage, and 10d6 sonic damage.
	The Hellball ignores Evasion and Improved Evasion.


	Use: Selected.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo
//:: Created On: 04/10/2007
//:://////////////////////////////////////////////
//:: AFW-OEI 06/25/2007: Reduce DC from +15 to +5.


#include "X0_I0_SPELLS"
#include "x2_i0_spells"
#include "x2_inc_spellhook"


void main()
{
	if (!X2PreSpellCastCode())
	{	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	    return;
	}

    float fDelay;
    int nTotalDamage;
    int nSpellDC = GetSpellSaveDC() + 5;	// Epic Spells are DC +5
	
    //effect eExplode 	  = EffectVisualEffect(VFX_HIT_HELLBALL_AOE);
	effect eHitVFX		  = EffectVisualEffect(VFX_HIT_HELLBALL);
    //effect eVisAcid 	  = EffectVisualEffect(VFX_HIT_SPELL_ACID);
    //effect eVisElectrical = EffectVisualEffect(VFX_HIT_SPELL_LIGHTNING);
    //effect eVisFire 	  = EffectVisualEffect(VFX_HIT_SPELL_FIRE);
	//effect eVisSonic 	  = EffectVisualEffect(VFX_HIT_SPELL_SONIC);

    int nDamageAcid, nDamageElectrical, nDamageFire, nDamageSonic;
    effect eDamAcid, eDamElectrical, eDamFire, eDamSonic;

    location lTarget = GetSpellTargetLocation();

    //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    while (GetIsObjectValid(oTarget))
    {
	    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	    {
		    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
		    fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20 + 0.5f;
			
			//Roll damage for each target
			nDamageAcid 	  = d6(10);
			nDamageElectrical = d6(10);
			nDamageFire 	  = d6(10);
			nDamageSonic 	  = d6(10);
			
			// No Evasion for Hellball
			if (MySavingThrow(SAVING_THROW_REFLEX, oTarget, nSpellDC, SAVING_THROW_TYPE_SPELL, OBJECT_SELF, fDelay) > 0)
			{
			    nDamageAcid 	  /= 2;
			    nDamageElectrical /= 2;
			    nDamageFire 	  /= 2;
			    nDamageSonic 	  /= 2;
			}
			
			nTotalDamage = nDamageAcid + nDamageElectrical +nDamageFire + nDamageSonic;
			
			//Set the damage effects
			eDamAcid 	   = EffectDamage(nDamageAcid, 		 DAMAGE_TYPE_ACID);
			eDamElectrical = EffectDamage(nDamageElectrical, DAMAGE_TYPE_ELECTRICAL);
			eDamFire 	   = EffectDamage(nDamageFire, 		 DAMAGE_TYPE_FIRE);
			eDamSonic 	   = EffectDamage(nDamageSonic, 	 DAMAGE_TYPE_SONIC);
			
			if(nTotalDamage > 0)
			{
			    // Apply effects to the currently selected target.
			    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamAcid, 		oTarget));
			    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamElectrical, oTarget));
			    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamFire, 		oTarget));
			    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamSonic, 		oTarget));
			
			    //These visual effects are applied to the target object, not the location as above.
			    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHitVFX, oTarget));
			    //DelayCommand(fDelay, 		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisAcid, 	   oTarget));
			    //DelayCommand(fDelay + 0.2f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisElectrical, oTarget));
			    //DelayCommand(fDelay + 0.5f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisFire, 	   oTarget));
			    //DelayCommand(fDelay + 0.7f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisSonic, 	   oTarget));
			}
        }
		
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }


}