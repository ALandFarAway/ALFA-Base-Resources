//::///////////////////////////////////////////////
//:: War Glory
//:: NW_S2_WarGlory.nss
//:: Copyright (c) 2006 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
    Grants a bonus to hit to allies and penalties
	to saves for enemies.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 05/19/2006
//:://////////////////////////////////////////////
//:: RPGplayer1 01/25/2009: Updated to match other persistent auras

#include "nw_i0_spells"
#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    object oTarget = GetSpellTargetObject();

	// Strip any Protective Auras first
	//RemoveSpellEffects(SPELLABILITY_WAR_GLORY, OBJECT_SELF, oTarget);
	
	//Create an instance of the AOE Object using the Apply Effect function
	// AFW-OEI 09/21/2006: Only apply effects if you don't already have them.
	//	The RemoveSpellEffects brute-force call was causing problems with effect icons.
	/*if (!GetHasSpellEffect(SPELLABILITY_WAR_GLORY, OBJECT_SELF))
	{
		effect eAOE = EffectAreaOfEffect(AOE_PER_WAR_GLORY);
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_WAR_GLORY, FALSE));
	    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAOE, oTarget);
	}*/

	// Strip any Auras first
	effect eTest = GetFirstEffect(oTarget);
	while(GetIsEffectValid(eTest))
	{
		if (GetEffectType(eTest) == EFFECT_TYPE_AREA_OF_EFFECT && GetEffectSpellId(eTest) == SPELLABILITY_WAR_GLORY)
		{
			RemoveEffect(oTarget, eTest);
		}
		eTest = GetNextEffect(oTarget);
	}
	
	// strip any extra aura objects, but not from other warpriests
	
	object o = GetFirstObjectInArea(GetArea(oTarget));
	while(GetIsObjectValid(o))
	{
		if (GetObjectType(o)==OBJECT_TYPE_AREA_OF_EFFECT)
		{
			//SpeakString("FOUND AOE OBJECT WITH SPELL ID: "+IntToString(GetAreaOfEffectSpellId(o)));
			if (  GetAreaOfEffectSpellId(o)==SPELLABILITY_WAR_GLORY && GetAreaOfEffectCreator(o) == oTarget )
			{
				//SpeakString("FOUND/DESTROY OLD AOE OBJECT");
				DestroyObject(o);
			}
		}	
		o = GetNextObjectInArea(GetArea(oTarget));
	}
	
	
	
	effect eAOE = EffectAreaOfEffect(AOE_PER_WAR_GLORY);
	//Create an instance of the AOE Object using the Apply Effect function
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_WAR_GLORY, FALSE));
	DelayCommand(0.0f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAOE, oTarget));
	
}