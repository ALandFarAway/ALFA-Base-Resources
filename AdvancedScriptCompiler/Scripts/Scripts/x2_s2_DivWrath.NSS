//::///////////////////////////////////////////////
//:: Divine Wrath
//:: x2_s2_DivWrath
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The Divine Champion is able to channel a portion
    of their gods power once per day giving them a +3
    bonus on attack rolls, damage, and saving throws
    for a number of rounds equal to their Charisma
    bonus. They also gain damage reduction of +1/5.
    At 10th level, an additional +2 is granted to
    attack rolls and saving throws.

    Epic Progression
    Every five levels past 10 an additional +2
    on attack rolls, damage and saving throws is added. As well the damage
    reduction increases by 5 and the damage power required to penetrate
    damage reduction raises by +1 (to a maximum of /+5).

	3.5 Rules (NWN2):
	Once per day, a 5th-level divine champion can channel
	a portion of her patron deity's power to greatly enhance
	her own battle prowess.  She gains damage reduction 5/- and
	a +3 bonus on attack rolls, damage, and saving htorws for a
	number of rounds equal to her Charisma modifier (minimum 1
	round).
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Feb 05, 2003
//:: Updated On: Jul 21, 2003 Georg Zoeller -
//                            Epic Level progession
//:: Updated On: 05/02/2006 Andrew Woo (AFW-OEI)
//::	3.5 rules compliance.
//:://////////////////////////////////////////////
//::PKM-OEI 07.11.06 VFX Pass

#include "nw_i0_spells"

void main()
{
    //Declare major variables
    object oTarget = OBJECT_SELF;
    int nDuration = GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF);
    if(nDuration <= 0)
    {
		nDuration = 1;	    //Check that if nDuration is not above 0, make it 1.
    //    FloatingTextStrRefOnCreature(100967,OBJECT_SELF);
    //    return;
    }

    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_HOLY);
    //eVis = EffectLinkEffects(EffectVisualEffect(VFX_IMP_GOOD_HELP),eVis);
    effect eAttack, eDamage, eSaving, eReduction;
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 621, FALSE));

    int nAttackB = 3;
    int nDamageB = DAMAGE_BONUS_3;
    int nSaveB = 3 ;
    int nDmgRedB = 5;
    //int nDmgRedP = DR_TYPE_NONE;	// 3.0 DR rules
    int nDmgRedP = GMATERIAL_METAL_ADAMANTINE;	// approximated 3.5 DR rules
	int nDmgType = DR_TYPE_NONE;

    // --------------- Epic Progression ---------------------------

    int nLevel = GetLevelByClass(CLASS_TYPE_DIVINECHAMPION,oTarget) ;
    int nLevelB = (nLevel / 5)-1;
    if (nLevelB <=0)
    {
        nLevelB =0;
    }
    else
    {
        nAttackB += (nLevelB*2); // +2 to attack every 5 levels past 5
        nSaveB += (nLevelB*2); // +2 to saves every 5 levels past 5
    }

    if (nLevelB >6 )
    {
        //nDmgRedP = DAMAGE_POWER_PLUS_FIVE;
        nDmgRedB = 7*5;
        nDamageB = DAMAGE_BONUS_17;
    }
    else if (nLevelB >5 )
    {
        //nDmgRedP = DAMAGE_POWER_PLUS_FIVE;
        nDmgRedB = 6*5;
        nDamageB = DAMAGE_BONUS_15;
    }
    else if (nLevelB >4 )
    {
        //nDmgRedP = DAMAGE_POWER_PLUS_FIVE;
        nDmgRedB = 5*5;
        nDamageB = DAMAGE_BONUS_13;
    }
    else if (nLevelB >3)
    {
        //nDmgRedP = DAMAGE_POWER_PLUS_FOUR;
        nDmgRedB = 4*5;
        nDamageB = DAMAGE_BONUS_11;
    }
    else if (nLevelB >2)
    {
        //nDmgRedP = DAMAGE_POWER_PLUS_THREE;
        nDmgRedB = 3*5;
        nDamageB = DAMAGE_BONUS_9;
    }
    else if (nLevelB >1)
    {
        //nDmgRedP = DAMAGE_POWER_PLUS_TWO;
        nDmgRedB = 2*5;
        nDamageB = DAMAGE_BONUS_7;
    }
    else if (nLevelB >0)
    {
        nDamageB = DAMAGE_BONUS_5;
    }
    //--------------------------------------------------------------
    //
    //--------------------------------------------------------------

    eAttack = EffectAttackIncrease(nAttackB,ATTACK_BONUS_MISC);
    eDamage = EffectDamageIncrease(nDamageB, DAMAGE_TYPE_DIVINE);
    eSaving = EffectSavingThrowIncrease(SAVING_THROW_ALL,nSaveB, SAVING_THROW_TYPE_ALL);
    eReduction = EffectDamageReduction( nDmgRedB, nDmgRedP, 0, nDmgType );
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    effect eLink = EffectLinkEffects(eAttack, eDamage);
    eLink = EffectLinkEffects(eSaving,eLink);
    eLink = EffectLinkEffects(eReduction,eLink);
    eLink = EffectLinkEffects(eDur,eLink);
    eLink = SupernaturalEffect(eLink);

    // prevent stacking with self
    RemoveEffectsFromSpell(oTarget, GetSpellId());


    //Apply the armor bonuses and the VFX impact
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}