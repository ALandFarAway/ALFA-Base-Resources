//::///////////////////////////////////////////////
//:: Glass Doppelganger
//:: nx_s0_glass_doppel_buff.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Caster Level(s): Sorc/wiz 5
	Innate Level: 5
	School: Illusion
	Descriptor(s): Shadow
	Component(s): V, S
	Range: Touch
	Area of Effect / Target: Single creature
	Duration: 1 round / level
	Save: No
	Spell Resistance: No
	
	This spell forms a living glass creation that
	is an exact copy of the target with the following
	exceptions: The creature is made out of glass,
	and thus more brittle, being summoned in at 1/4
	of the current hitpoints of the target. The
	summoned creature has 15 resistance to fire,
	cold, electricity, acid, peircing, and slashing
	damage types. The summoned creature gains
	vulnerability 50% to sonic and bludgeoning damage.
	The glass copy is allied with the caster, but
	not under direct control, acting as a summoned
	animal or a henchman. Creatures copied are must
	have the same or fewer hit dice than the caster
	has caster levels, with a hard cap of 15 HD.
	Copied creatures have no memorized spells. 
	
	
	This script handles the buff to the doppelganger.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 05/15/2007
//:://////////////////////////////////////////////
//:: AFW-OEI 07/12/2007: NX1 VFX

#include "nwn2_inc_spells"
#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode())
    {   // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
    
	effect eFire = EffectDamageResistance(DAMAGE_TYPE_FIRE, 15);
	effect eCold = EffectDamageResistance(DAMAGE_TYPE_COLD, 15);
	effect eElec = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 15);
	effect eAcid = EffectDamageResistance(DAMAGE_TYPE_ACID, 15);

	//FIX: This is not resistance, but DR, so selected damage type should pass: bludgeoning
	//effect ePiercing = EffectDamageReduction(15, DAMAGE_TYPE_PIERCING, 0, DR_TYPE_DMGTYPE);
	//effect eSlashing = EffectDamageReduction(15, DAMAGE_TYPE_SLASHING, 0, DR_TYPE_DMGTYPE);
	effect eBludgeoning = EffectDamageReduction(15, DAMAGE_TYPE_ALL, 0, DR_TYPE_DMGTYPE); //DAMAGE_TYPE_ALL is bludgeoning DR, don't ask me why

	effect eSonicVulnerability = EffectDamageImmunityDecrease(DAMAGE_TYPE_SONIC, 50);
	effect eBludgeoningVulnerability = EffectDamageImmunityDecrease(DAMAGE_TYPE_BLUDGEONING, 50);
	effect eDur = EffectVisualEffect(VFX_DUR_SPELL_GLASS_DOPPELGANGER);

	
	effect eLink = EffectLinkEffects(eFire, eCold);
	eLink = EffectLinkEffects(eLink, eElec);
	eLink = EffectLinkEffects(eLink, eAcid);
	//eLink = EffectLinkEffects(eLink, ePiercing);
	//eLink = EffectLinkEffects(eLink, eSlashing);
	eLink = EffectLinkEffects(eLink, eBludgeoning);
	eLink = EffectLinkEffects(eLink, eSonicVulnerability);
	eLink = EffectLinkEffects(eLink, eBludgeoningVulnerability);
	eLink = EffectLinkEffects(eLink, eDur);
	eLink = ExtraordinaryEffect(eLink);
	
	//Apply the effects
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, OBJECT_SELF);	// Permanent duration is OK, since doppelganger will expire...

	TakeGoldFromCreature(GetGold(OBJECT_SELF), OBJECT_SELF, TRUE);
}