//::///////////////////////////////////////////////
//:: Divine Vengeance
//:: x0_s2_divveng.nss
//:: Copyright (c) 2002 Bioware Corp.
//::			   2008 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
    Up to (turn undead amount) per day the character may add 2d6 bonus to all
    weapon damage until the end of your next action

    based on work x2_s2_divmight.nss By "Brent"
	
	Adapted to last for rounds equal to your charisma bonus, instead of one
	turn (same as Divine Might)
*/
//:://////////////////////////////////////////////
//:: Created By: JWR-OEI
//:: Created On: May 23 2008
//:://////////////////////////////////////////////
//:: RPGplayer1 11/22/2008: Fixed DAMAGEBONUS constant
//:: RPGplayer1 12/22/2008: Increased duration by 1 round, since activating this feat makes you unable to attack for 1 round

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
   if(GetHasFeatEffect(2153) == FALSE)
   {
        //Declare major variables
        object oTarget = GetSpellTargetObject();
        int nLevel = GetCasterLevel(OBJECT_SELF);

        effect eVis = EffectVisualEffect( VFX_HIT_SPELL_EVOCATION );
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

        int nDamageBonus = d6(2);
		int nCharismaBonus = GetAbilityModifier(ABILITY_CHARISMA);
		if ( nCharismaBonus < 1 )
		{
			nCharismaBonus = 1;
		}
 
        //int nDamage1 = IPGetDamageBonusConstantFromNumber(nDamageBonus);
        int nDamage1 = IP_CONST_DAMAGEBONUS_2d6;

        effect eDamage1 = EffectDamageIncrease(nDamage1,DAMAGE_TYPE_DIVINE, RACIAL_TYPE_UNDEAD);
        effect eLink = EffectLinkEffects(eDamage1, eDur);
        eLink = SupernaturalEffect(eLink);

        // * Do not allow this to stack
        RemoveEffectsFromSpell(oTarget, GetSpellId());

        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DIVINE_VENGEANCE, FALSE));

        //Apply Link and VFX effects to the target
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nCharismaBonus+1));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
       
        DecrementRemainingFeatUses(OBJECT_SELF, FEAT_TURN_UNDEAD);
    }
}