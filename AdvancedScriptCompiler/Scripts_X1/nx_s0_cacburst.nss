//::///////////////////////////////////////////////
//:: Cacophonic Burst
//:: NX_s0_cacburst.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	Cacophonic Burst
	Evocation [Sonic]
	Level: Bard 5, sorceror/wizard 5
	Components: V,S
	Range: Long
	Area: 20 ft. radius
	Saving Throw: Reflex half
	Spell Resistance: Yes
	 
	You create a burst of low, discordant noise to 
	erupt at the chosen location.  It deals 1d6 points
	of sonic damage per caster level (maximum 15d6) 
	to all creatures within the area.
	 
	NOTE: The rule stating that this spell cannot penetrate 
	the silence spell is omitted because it's really hard 
	to do that and none of our other sonic spells use this rule.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills, using elements from nw_s0_fireball (10.18.00 Noel Borstad)
//:: Created On: 11.30.06
//:://////////////////////////////////////////////
//:: JSH-OEI 11/14/08: Incorporated rpgplayer1's fixes.

#include "nw_i0_spells" 
#include "X0_I0_SPELLS"
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
	object oCaster = OBJECT_SELF;
	location lTarget = GetSpellTargetLocation();
	int nDamage;
	int nCasterLvl = GetCasterLevel(oCaster);
	float fDelay;
	effect eImpactVis = EffectVisualEffect(VFX_COM_HIT_SONIC);
	effect eDam;
	
//determine unmodded damage	
	if (nCasterLvl > 15)
	{
		nCasterLvl = 15;
	}

	nDamage = d6(nCasterLvl);
	nDamage = ApplyMetamagicVariableMods(nDamage, 6*nCasterLvl);

//target discrimination and application of effects
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	
	while (GetIsObjectValid(oTarget))
	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			
			nDamage = d6(nCasterLvl);
			nDamage = ApplyMetamagicVariableMods(nDamage, 6*nCasterLvl);
		
			//Signal spell cast at event
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 1016));
			//delay the explosion impacts for visual flair
			fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
			if (!MyResistSpell(oCaster, oTarget, fDelay))
			{
				//reflex save
				nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_SONIC);
				//set damage effect
				eDam = EffectDamage(nDamage, DAMAGE_TYPE_SONIC);
				if (nDamage > 0)
				{
					// Apply effects to the currently selected target.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpactVis, oTarget));
				}
			}
		}
		//find my next victim
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	}
}
	