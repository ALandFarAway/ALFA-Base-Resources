//::///////////////////////////////////////////////////////////////////////////
//::
//::	nw_s0_shadescaster.nss
//::
//::	This is the ImpactScript for spell ID 969. If the caster clicks on 
//::	himself he will cast Premonition, Protection from Spells, and Shield.
//::
//::///////////////////////////////////////////////////////////////////////////
//::
//::	Created by: Brian Fox
//::	Created on: 6/27/06
//::
//::///////////////////////////////////////////////////////////////////////////
//:: RPGplayer1 07/17/2008: Delinked damage reduction from other effects to prevent other buffs from being canceled when maximum damage is absorbed

#include "nw_i0_spells"
#include "x2_inc_spellhook" 


void main()
{
    if (!X2PreSpellCastCode())
    {
		// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

	int nCasterLevel = GetCasterLevel( OBJECT_SELF );
    int nDuration = nCasterLevel; // Duration is 1 hr per level of the caster

    if (GetMetaMagicFeat() == METAMAGIC_EXTEND)
    {
		nDuration = nDuration *2;	//Duration is +100%
    }

	object oTarget = GetSpellTargetObject();

    if ( oTarget == OBJECT_SELF )	// This may be redundant since the 2DA defines the spell as self-only
    {
		//Fire cast spell at event for the specified target
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
		
		// Get rid of old effects
		RemoveEffectsFromSpell(oTarget, SPELL_PROTECTION_FROM_SPELLS);
		RemoveEffectsFromSpell(oTarget, SPELL_PREMONITION);
		RemoveEffectsFromSpell(oTarget, SPELL_SHIELD);
		RemoveEffectsFromSpell(oTarget, GetSpellId());
		
		effect eLink;
		
		// The unified VFX
		effect eVis = EffectVisualEffect( VFX_SPELL_SHADES_BUFF );
		
		// Premonition	
		int nLimit = GetCasterLevel(oTarget) * 10;
		//effect eStone = EffectDamageReduction(30, DAMAGE_POWER_PLUS_FIVE, nLimit);	// 3.0 DR rules
		effect eStone = EffectDamageReduction( 30, GMATERIAL_METAL_ADAMANTINE, nLimit, DR_TYPE_GMATERIAL );		// 3.5 DR approximation
		//eLink = EffectLinkEffects(eStone, eVis); // Link it up! //No, do not!
		
		// Protection from Spells
		effect ePfS_Save = EffectSavingThrowIncrease(SAVING_THROW_ALL, 8, SAVING_THROW_TYPE_SPELL);
		//eLink = EffectLinkEffects(ePfS_Save, eLink);
		eLink = EffectLinkEffects(ePfS_Save, eVis);
		
		//Immunity to Magic Missiles
		effect eSpell = EffectSpellImmunity(SPELL_MAGIC_MISSILE);
		eLink = EffectLinkEffects(eLink, eSpell);
		
		//Shield
		effect eMA_AC = EffectACIncrease(4, AC_SHIELD_ENCHANTMENT_BONUS);
		eLink = EffectLinkEffects(eMA_AC, eLink);

		//Needed for dispels to see this as single spell
		effect eOnDispell = EffectOnDispel(0.0f, RemoveEffectsFromSpell(oTarget, SPELL_SHADES_TARGET_CASTER));
		eLink = EffectLinkEffects(eLink, eOnDispell);
		eStone = EffectLinkEffects(eStone, eOnDispell);
		
		//Apply the armor bonuses and the VFX impact
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStone, oTarget, HoursToSeconds(nDuration));
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration));
    }
}