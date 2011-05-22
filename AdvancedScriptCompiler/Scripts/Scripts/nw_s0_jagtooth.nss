//::///////////////////////////////////////////////
//:: Jagged Tooth
//:: nw_s0_jagtooth.nss
//:: Copyright (c) 2006 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	This spell doubles the critical threat range of one natural weapon
	that deals either slashing or peircing damage.  Multiple spell effects
	that increase a weapon's threat range don't stack.  This spell is
	typically cast on animal companions.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: Oct 19, 2006
//:://////////////////////////////////////////////


#include "nw_i0_spells"
#include "x2_inc_spellhook" 
#include "nwn2_inc_metmag"
#include "x2_inc_itemprop"

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

//Declare major variables
	object			oTarget		=	GetSpellTargetObject();
	object			oCaster		=	OBJECT_SELF;
	object			oWeapon1	=	GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oTarget);
	object			oWeapon2	=	GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oTarget);
	object			oWeapon3	=	GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oTarget);
	itemproperty	iKeen		=	ItemPropertyKeen();
	float			fDuration	=	IntToFloat(600*GetCasterLevel(oCaster));
	effect			eVis		=	EffectVisualEffect(VFX_SPELL_DUR_JAGGED_TOOTH);
	
//Determine duration
					fDuration	=	ApplyMetamagicDurationMods(fDuration);

//Validate target and apply effect, IPSafeAddItemProperty automatically handles stacking rules.
	if (GetIsObjectValid(oTarget))
	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster))
		{
			if (GetRacialType(oTarget) == RACIAL_TYPE_ANIMAL
				|| GetRacialType(oTarget) == RACIAL_TYPE_BEAST
				|| GetRacialType(oTarget) == RACIAL_TYPE_MAGICAL_BEAST
				|| GetRacialType(oTarget) == RACIAL_TYPE_DRAGON
				|| GetRacialType(oTarget) == RACIAL_TYPE_VERMIN)
			{
				if (GetIsObjectValid(oWeapon1))
				{
					if (!IPGetIsBludgeoningWeapon(oWeapon1))
					{
						IPSafeAddItemProperty(oWeapon1, iKeen, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
						ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, fDuration);
					}
				}
				else if (GetIsObjectValid(oWeapon2))
				{
					if (!IPGetIsBludgeoningWeapon(oWeapon2))
					{
						IPSafeAddItemProperty(oWeapon2, iKeen, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
						ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, fDuration);
					}
				}
				else if (GetIsObjectValid(oWeapon3))
				{
					if (!IPGetIsBludgeoningWeapon(oWeapon3))
					{
						IPSafeAddItemProperty(oWeapon3, iKeen, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
						ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, fDuration);
					}
				}
			}
		}
	}
}