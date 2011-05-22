//:://///////////////////////////////////////////////
//:: Righteous Might
//:: nw_s0_sngodisc.nss
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//::////////////////////////////////////////////////
//:: Created By: Brock Heinz
//:: Created On: 08/11/05
//::////////////////////////////////////////////////
/*
        5.2.5.3.1	Righteous Might
        PHB, pg. 273
        School:		    Transmutation
        Components: 	Verbal, Somatic
        Range:		    Personal
        Target:		    You
        Duration:		1 round / level

        This increases the size of the caster by 50%. All size increasing spells 
        use this effect, and no size increasing spells stack (the second size 
        increasing spell automatically fails if targeted on someone who has Enlarge 
        Person cast on them for example). They get a +4 Strength Bonus, +2 Constitution Bonus, 
        and a +2 natural armor AC bonus. Additionally the caster gains damage resistance 3/evil 
        (if they are non-evil) or 5/good (if they are evil). At 12th level the damage 
        resistance goes up to 6, and at 15th it goes up to 9. They get a -1 attack 
        and -1 AC penalty because of size. All melee weapons deal +3 damage. 

        [B] They threaten opponents within 10 feet instead of 5 feet. This may
        not be implemented depending on how the AoO works in the Aurora engine.


        [Rules Note] In 3.5 melee weapons actually go up one size category. The
        +3 damage is an average of some of the typical weapons a PC would use. 
        E.g. a longsword goes from 1d8 to 2d6 (avg. gain of 2.5) and a two-handed 
        sword goes from 2d6 to 3d6 (avg. gain of 3.5).
        Also in the Righteous Might description in the PHB it covers cases where 
        you don't have enough space to grow that much. That part of the spell is 
        removed from NWN2 for simplicity's sake. Also the stats don't match the 
        PHB - they match the errata on the WotC web-site.

*/


// JLR - OEI 08/23/05 -- Metamagic changes

#include "nw_i0_spells"
#include "x2_inc_spellhook" 
#include "nwn2_inc_spells" 

void main()
{

    if (!X2PreSpellCastCode())
    {
        // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    // Determine and validate the target ( this SHOULD be the caster!)
    object oTarget = GetSpellTargetObject();

	if ( HasSizeIncreasingSpellEffect( oTarget ) == TRUE || GetHasSpellEffect( 803, oTarget ) )
	{
		// TODO: fizzle effect? 
		FloatingTextStrRefOnCreature( 3734, oTarget );  //"Failed"
		return;
	}

    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
    float fDuration  = ApplyMetamagicDurationMods(RoundsToSeconds(nCasterLvl));
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	int nAlignment = GetAlignmentGoodEvil( oTarget );
	
	int nDmgResist;
	int nDmgType;

	if ( nAlignment != ALIGNMENT_EVIL )
	{
//		nDmgType = DAMAGE_TYPE_NEGATIVE;
		nDmgType = ALIGNMENT_EVIL;
	}
	else
	{
//		nDmgType = DAMAGE_TYPE_POSITIVE;
		nDmgType = ALIGNMENT_GOOD;
	}

	if ( nCasterLvl >= 15 ) 		nDmgResist = 9;
	else if ( nCasterLvl >= 12 ) 	nDmgResist = 6;
	else 							nDmgResist = 3;


	// Effects 
    //effect eVis 	= EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
	
//	effect eResist	= EffectDamageResistance( nDmgType, nDmgResist );
	effect eResist  = EffectDamageReduction(nDmgResist, nDmgType, 0, DR_TYPE_ALIGNMENT);
    effect eStr 	= EffectAbilityIncrease(ABILITY_STRENGTH, 4);
    effect eCon 	= EffectAbilityIncrease(ABILITY_CONSTITUTION, 2);
    effect eACInc 	= EffectACIncrease(2, AC_NATURAL_BONUS); 
    effect eACDec   = EffectACDecrease(1, AC_DODGE_BONUS);
	effect eAtkDec	= EffectAttackDecrease( 1, ATTACK_BONUS_MISC ); // ATTACK_BONUS_MISC???
    effect eDmg 	= EffectDamageIncrease(3, DAMAGE_TYPE_MAGICAL);	// Should be Melee-only!
    effect eScale 	= EffectSetScale(1.5);
    effect eDur 	= EffectVisualEffect( VFX_HIT_SPELL_ENLARGE_PERSON );
    effect eLink 	= EffectLinkEffects(eStr, eCon);
    eLink = EffectLinkEffects(eLink, eResist);
    eLink = EffectLinkEffects(eLink, eACInc);
    eLink = EffectLinkEffects(eLink, eACDec);
    eLink = EffectLinkEffects(eLink, eAtkDec);
	eLink = EffectLinkEffects(eLink, eDmg);
    eLink = EffectLinkEffects(eLink, eScale);
    eLink = EffectLinkEffects(eLink, eDur);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    //Apply the VFX impact and effects
    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
}