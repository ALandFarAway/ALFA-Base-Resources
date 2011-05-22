//::///////////////////////////////////////////////
//:: Protective Aura
//:: NW_S2_ProtAura.nss
//:: Copyright (c) 2006 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
    Grants a bonus to saves and AC to allies within
	the spell radius.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 05/17/2006
//:: Rewrote On: 10/15/2008 by Justin Reynard (JWR-OEI)
//:: Persistent Aura's are handled differently now.
//:://////////////////////////////////////////////
//:: RPGplayer1 12/22/2008:
//::  Won't strip protective auras from other Nines
//::  Put aura in DelayCommand to prevent losing Persistent Aura icon on save game load

#include "nw_i0_spells"
#include "x2_inc_spellhook"

void main()
{
	//SpeakString("Firing Aura");
    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    object oTarget = GetSpellTargetObject();

	// Strip any Auras first
	effect eTest = GetFirstEffect(oTarget);
	while(GetIsEffectValid(eTest))
	{
		if (GetEffectType(eTest) == EFFECT_TYPE_AREA_OF_EFFECT && GetEffectSpellId(eTest) == SPELLABILITY_PROTECTIVE_AURA)
		{
			RemoveEffect(oTarget, eTest);
		}
		eTest = GetNextEffect(oTarget);
	}
	
	// strip any extra aura objects, but not from other Nines
	
	object o = GetFirstObjectInArea(GetArea(oTarget));
	while(GetIsObjectValid(o))
	{
		if (GetObjectType(o)==OBJECT_TYPE_AREA_OF_EFFECT)
		{
			//SpeakString("FOUND AOE OBJECT WITH SPELL ID: "+IntToString(GetAreaOfEffectSpellId(o)));
			if (  GetAreaOfEffectSpellId(o)==SPELLABILITY_PROTECTIVE_AURA && GetAreaOfEffectCreator(o) == oTarget )
			{
				//SpeakString("FOUND/DESTROY OLD AOE OBJECT");
				DestroyObject(o);
			}
		}	
		o = GetNextObjectInArea(GetArea(oTarget));
	}
	
	
	int    nLevel  = GetLevelByClass(CLASS_NWNINE_WARDER);
	effect eAOE = EffectAreaOfEffect(AOE_PER_PROTECTIVE_AURA);
	if (nLevel >= 4)
	{
		eAOE = EffectAreaOfEffect(AOE_PER_PROTECTIVE_AURA_II);
	}
	//Create an instance of the AOE Object using the Apply Effect function
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_PROTECTIVE_AURA, FALSE));
	DelayCommand(0.0f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAOE, oTarget));
	
}