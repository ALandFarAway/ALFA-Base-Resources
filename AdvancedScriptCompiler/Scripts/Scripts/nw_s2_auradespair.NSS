//::///////////////////////////////////////////////
//:: Aura of Despair
//:: NW_S2_AuraDespair.nss
//:: Copyright (c) 2006 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Blackguard supernatural ability that causes all
	enemies within 10' to take a -2 penalty on all saves.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 05/30/2006
//:: Rewrote On: 10/15/2008 by Justin Reynard (JWR-OEI)
//:: Persistent Aura's are handled differently now.
//:://////////////////////////////////////////////
//:: RPGplayer1 12/22/2008:
//::  Won't strip despair auras from other blackguards
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
		if (GetEffectType(eTest) == EFFECT_TYPE_AREA_OF_EFFECT && GetEffectSpellId(eTest) == SPELLABLILITY_AURA_OF_DESPAIR)
		{
			RemoveEffect(oTarget, eTest);
		}
		eTest = GetNextEffect(oTarget);
	}
	
	// strip any extra aura objects, but not from other blackguards
	
	object o = GetFirstObjectInArea(GetArea(oTarget));
	while(GetIsObjectValid(o))
	{
		if (GetObjectType(o)==OBJECT_TYPE_AREA_OF_EFFECT)
		{
			//SpeakString("FOUND AOE OBJECT WITH SPELL ID: "+IntToString(GetAreaOfEffectSpellId(o)));
			if (  GetAreaOfEffectSpellId(o)==SPELLABLILITY_AURA_OF_DESPAIR && GetAreaOfEffectCreator(o) == oTarget )
			{
				//SpeakString("FOUND/DESTROY OLD AOE OBJECT");
				DestroyObject(o);
			}
		}	
		o = GetNextObjectInArea(GetArea(oTarget));
	}
	
	
	
	effect eAOE = EffectAreaOfEffect(AOE_PER_AURA_OF_DESPAIR);
	//Create an instance of the AOE Object using the Apply Effect function
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABLILITY_AURA_OF_DESPAIR, FALSE));
	DelayCommand(0.0f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAOE, oTarget));
	
}