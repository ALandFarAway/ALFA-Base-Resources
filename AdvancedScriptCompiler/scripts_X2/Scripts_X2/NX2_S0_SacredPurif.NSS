//::///////////////////////////////////////////////
//:: Sacred Purification
//:: NX2_S0_SacredPurif.nss
//:: Copyright (c) 2008 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
    you can expend a turn undead
	attempt to create a pulse of divine energy. All living
	creatures within 60 feet of you heal an amount of damage
	equal to 1d8 points + your Charisma bonus (if any). All undead
	creatures in this area take damage equal to 1d8 points + your
	Charisma bonus.
*/
//:://////////////////////////////////////////////
//:: Created By: JWR-OEI
//:: Created On: May 23 2008
//:://////////////////////////////////////////////
//:: RPGplayer1 12/18/2008: Separate healing roll for each target

#include "x0_i0_spells"
#include "x2_inc_itemprop"
#include "nwn2_inc_spells"


void main()
{

   if (!GetHasFeat(FEAT_TURN_UNDEAD, OBJECT_SELF))
   {
        SpeakStringByStrRef(STR_REF_FEEDBACK_NO_MORE_TURN_ATTEMPTS);
   }
   else 
   {
   // we have turn undead attempts left.
   		object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_VAST, GetLocation(OBJECT_SELF), TRUE);
		int nDam = d8(1);
		int nBonus = GetAbilityModifier(ABILITY_CHARISMA);
		int totalDamage = nDam + nBonus;
		
		while(GetIsObjectValid(oTarget))
		{
			if (GetRacialType(oTarget)==RACIAL_TYPE_UNDEAD)
			{
				effect e = EffectDamage(totalDamage, DAMAGE_TYPE_DIVINE);
				effect ePlane = EffectVisualEffect( VFX_HIT_SPELL_HOLY );
				effect eLink = EffectLinkEffects(e, ePlane);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
			}
			else if(spellsIsTarget( oTarget, SPELL_TARGET_ALLALLIES, OBJECT_SELF ))
			{
				effect e = EffectHeal(totalDamage);
				effect ePlane = EffectVisualEffect( VFX_HIT_CURE_AOE );
				effect eLink = EffectLinkEffects(e, ePlane);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
			
			}
			totalDamage = d8(1) + nBonus; //FIX: New roll for each target
			oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_VAST, GetLocation(OBJECT_SELF), TRUE);
		}
	effect eImpactVis = EffectVisualEffect(VFX_FEAT_TURN_UNDEAD);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, GetLocation(OBJECT_SELF));	
   	DecrementRemainingFeatUses(OBJECT_SELF, FEAT_TURN_UNDEAD);
	}
} 