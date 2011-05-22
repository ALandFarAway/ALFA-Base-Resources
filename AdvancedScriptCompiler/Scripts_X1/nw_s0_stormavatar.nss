//::///////////////////////////////////////////////
//:: Storm Avatar
//:: nw_s0_stormavatar.nss
//:: Copyright (c) 2006 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	You become empowered by the swift strength and destructive 
	fury of a fierce storm, lightning crackling from your eyes for the 
	duration of the spell.  Wind under your feet enables you to travel
	at 200% normal speed (effects do not stack with haste, expeditious retreat
	and similar spells) and prevents you from being knocked down by any force 
	shot of death.  Missile Weapons fired at you are deflected harmlesly.  Finally
	all melee attacks you make do an additional 3d6 points of electrical damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: Oct 11, 2006
//:://////////////////////////////////////////////

#include "nw_i0_spells"
#include "x2_i0_spells"
#include "x2_inc_spellhook"


void main()
{
    /*
      Spellcast Hook Code
      Added 2003-07-07 by Georg Zoeller
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more

    */

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

//Major variables
	object	oMyWeapon	=	IPGetTargetedOrEquippedMeleeWeapon();
	object	oCaster		=	OBJECT_SELF;
	effect	eDur		=	EffectVisualEffect(925);
	effect	eSpeed		=	EffectMovementSpeedIncrease(200);
	effect 	eImmuneKO	=	EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN);
	effect 	eImmuneMi	=	EffectConcealment(100, MISS_CHANCE_TYPE_VS_RANGED);
	int		nDamageType	= 	IP_CONST_DAMAGETYPE_ELECTRICAL;
	int		nDamage		=	IP_CONST_DAMAGEBONUS_3d6;
	float 	fDuration	=	RoundsToSeconds(GetCasterLevel(oCaster));

//link effects
	effect	eLink		=	EffectLinkEffects( eDur, eSpeed );
			eLink		=	EffectLinkEffects( eLink, eImmuneKO );
			eLink		=	EffectLinkEffects( eLink, eImmuneMi );

//Determine duration
	fDuration = ApplyMetamagicDurationMods(fDuration);

//Determine Damage bonus granted
// AFW-OEI 03/21/2007: Since we're dealing with damage constants and not damage, the metamagic function is going
//	to do the wrong thing.  Forget Maximize/Empower for the Storm Avatar.
	//nDamage		=	ApplyMetamagicVariableMods(nDamage, 12);
	
//This spell should not be allowed to stack with itself
	if (GetHasSpellEffect(1007, oCaster))
	{
		RemoveSpellEffects( 1007, oCaster, oCaster);
	}	

//Apply damage bonus to equipped weapon
	if (GetIsObjectValid(oMyWeapon))
	{
		itemproperty ipElectrify = ItemPropertyDamageBonus(nDamageType, nDamage);
	
		//IPSafeAddItemProperty(oMyWeapon, ipElectrify, fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, TRUE, FALSE);	// AFW-OEI 08/14/2007: Let Subtypes be different.
		IPSafeAddItemProperty(oMyWeapon, ipElectrify, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);	// FIX: should work with shock weapons too
	}
	
//Apply linked effects to caster
	if (GetIsObjectValid(oCaster))
	{
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, fDuration);
	}
}