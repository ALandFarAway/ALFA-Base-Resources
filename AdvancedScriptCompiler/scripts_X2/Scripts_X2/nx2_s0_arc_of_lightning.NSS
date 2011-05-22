//::///////////////////////////////////////////////
//:: Arc of Lighting
//:: nx2_s0_arc_of_lightning.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Arc of Lighting
	Conjuration (Creation) [Electricity]
	Level: Druid 4, sorceror/wizard 5
	Components: V, S
	Range: Close
	Area: A line between two creatures
	Saving Throw: Reflex half
	Spell Resistance: No
	 
	This bolt deal 1d6 points of electricity damage to per caster level (maximum 15d6) to 
	both creatures and to anything in the line beteen them. 

*/
//:://////////////////////////////////////////////
//:: Created By: Michael Diekmann
//:: Created On: 08/28/2007
//:://////////////////////////////////////////////
//:: RPGplayer1 11/22/2008: Added support for metamagic

#include "nwn2_inc_spells"
#include "x2_inc_spellhook"

// Gets a random creature near target creature
object GetRandomCreature(object oTarget)
{
	location lTarget = GetLocation(oTarget);
	// Get first object in area around the target
    object oTarget2 = GetFirstObjectInShape(SHAPE_SPHERE, 15.0, lTarget);
	// as long as we have a valid target
	while(GetIsObjectValid(oTarget2))
	{
		// make sure it is in the hostile faction as well and not the original target
		if(GetFactionEqual(oTarget, oTarget2) && oTarget != oTarget2)
			return oTarget2;
		oTarget2 = GetNextObjectInShape(SHAPE_SPHERE, 15.0, lTarget);
	}
	return OBJECT_INVALID;
}
void main()
{
    if (!X2PreSpellCastCode())
    {
	    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
	// Get necessary objects
	object oTarget		= GetSpellTargetObject();
	object oCaster		= OBJECT_SELF;
	//Get random second target
	object oTarget2 	= GetRandomCreature(oTarget);
	// Get locations and positions
	location lTarget 	= GetLocation(oTarget);
	location lTarget2	= GetLocation(oTarget2);
	vector vTarget		= GetPositionFromLocation(lTarget);
	// Caster level
	int nCasterLevel 	= GetCasterLevel(oCaster);
	if(nCasterLevel > 15)
		nCasterLevel = 15;
	// Effect placeholders
	int nDamage 		= d6(nCasterLevel);
	effect eDamage		= EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL);
	effect eBeam		= EffectBeam(VFX_BEAM_LIGHTNING , oTarget2, BODY_NODE_CHEST);
	effect eHit			= EffectVisualEffect(VFX_HIT_SPELL_LIGHTNING);
	
	// no matter what damage original target
	if(GetIsObjectValid(oTarget))
	{
		nDamage = d6(nCasterLevel);
		nDamage = ApplyMetamagicVariableMods(nDamage, nCasterLevel * 6);
		nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_ELECTRICITY, oCaster); 
		eDamage	= EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
		ApplyEffectToObject(DURATION_TYPE_INSTANT,eHit,oTarget);
	}

	// if we have a valid second object
	if(GetIsObjectValid(oTarget2))
	{
		// create a lightning bolt between the two target
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oTarget, 5.0f);
		// in order to get all object in a line between the two target, create a cone starting
		// at one and ending at the other with a small width, creating a line
		oTarget = GetFirstObjectInShape(SHAPE_CONE, 0.1, lTarget2, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_ITEM | OBJECT_TYPE_PLACEABLE, vTarget); 
		// While spell target is valid
		while (GetIsObjectValid(oTarget))
		{
			// check to see if hostile
			if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)) 
			{
				// Get damage apply effects
				nDamage = d6(nCasterLevel);
				nDamage = ApplyMetamagicVariableMods(nDamage, nCasterLevel * 6);
				nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_ELECTRICITY, oCaster);
				eDamage	= EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
				ApplyEffectToObject(DURATION_TYPE_INSTANT,eHit,oTarget);
				
				//Fire cast spell at event for the specified target
	    		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), TRUE));
			}
			oTarget = GetNextObjectInShape(SHAPE_CONE, 0.1, lTarget2, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_ITEM | OBJECT_TYPE_PLACEABLE, vTarget);
		}
	}
}