//==================================================
// Mage Armor
// By: Zelknolf
// Date: Nov 3, 2010
//==================================================
//
/*
	This version of Mage Armor is designed to bring
	the spell closer to the spell as described in
	the 3.5 PHB. Though the spell does not offer
	any special bonuses against incorporeal 
	attackers, it appropriately stacks / does not
	stack with magical armor, regular armor, armor-
	improving spells such as Magic Vestment, and
	bracers of armor.
*/
//==================================================

#include "nwn2_inc_spells"
#include "nw_i0_spells"
#include "x2_inc_spellhook" 

void CheckArmor(object oArmor, object oTarget, float fDuration);

void main()
{
	if (!X2PreSpellCastCode()) return;
	
	object oTarget = GetSpellTargetObject();
	object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget);
	
	int nBaseAC = 0;
	int nEnhancedAC = 0;
	int nCasterLevel = GetCasterLevel(oTarget);
	float fDuration = HoursToSeconds(nCasterLevel);	
	
		
	if(GetIsObjectValid(oArmor))
	{
		int nArmorType = GetArmorRulesType(oArmor);
		nBaseAC = StringToInt(Get2DAString("armorrulestats", "ACBONUS", nArmorType));
		itemproperty ipArmor = GetFirstItemProperty(oArmor);
		while(GetIsItemPropertyValid(ipArmor))
		{
			if(GetItemPropertyType(ipArmor) == ITEM_PROPERTY_AC_BONUS)
			{
				int nEnhancement = GetItemPropertyCostTableValue(ipArmor);
				if(nEnhancedAC < nEnhancement)
					nEnhancedAC = nEnhancement;		
			}
			ipArmor = GetNextItemProperty(oArmor);
		}	
	}
	
	int nMageArmorBonus = 6 - nBaseAC;
	effect eMageArmor, eDur, eLink;
	
	if(nMageArmorBonus < 1)
	{
		//=== This spell isn't helping right now. That's okay; the VFX will keep us warm at night ===//
		eLink = EffectVisualEffect(100002);
	}
	else
	{
		nMageArmorBonus += nEnhancedAC;
		eMageArmor = EffectACIncrease(nMageArmorBonus, AC_ARMOUR_ENCHANTMENT_BONUS);		
		eDur = EffectVisualEffect(100002);
		eLink = EffectLinkEffects(eMageArmor, eDur);
	}
	

	
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
	DelayCommand(6.0f, CheckArmor(oArmor, oTarget, fDuration));
}

void CheckArmor(object oArmor, object oTarget, float fDuration)
{
	fDuration -= 6.0f;
		
	//=== The spell has ended or expired. Return to save memory. ===//
	int bDispelled = TRUE;
	
	effect eEffect = GetFirstEffect(oTarget);	
	while(GetIsEffectValid(eEffect))
	{
		if(GetEffectType(eEffect)         == EFFECT_TYPE_VISUALEFFECT &&
		   GetEffectInteger(eEffect, 0)   == 100002 &&
		   GetEffectSubType(eEffect)      == SUBTYPE_MAGICAL &&
		   GetEffectDurationType(eEffect) == DURATION_TYPE_TEMPORARY)
		     bDispelled = FALSE;
		eEffect = GetNextEffect(oTarget);
	}

	if(bDispelled)
		return;
		
	//=== This is another mage armor spell. Return to save memory. ===//
	if(fDuration < 0.0f)
		return;

	//=== Armor has not changed. No need to calculate. ===//				
	if(oArmor == GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget))
	{
		DelayCommand(6.0f, CheckArmor(oArmor, oTarget, fDuration));
		return;
	}
	
	//=== Armor is new; we need to re-apply the effect with new calculations ===//
	eEffect = GetFirstEffect(oTarget);
	while(GetIsEffectValid(eEffect))
	{		
		if(GetEffectType(eEffect)         == EFFECT_TYPE_VISUALEFFECT &&
		   GetEffectInteger(eEffect, 0)   == 100002 &&
		   GetEffectSubType(eEffect)      == SUBTYPE_MAGICAL &&
		   GetEffectDurationType(eEffect) == DURATION_TYPE_TEMPORARY)
		     RemoveEffect(oTarget, eEffect);		
		eEffect = GetNextEffect(oTarget);
	}
	
	object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget);
	
	int nBaseAC = 0;
	int nEnhancedAC = 0;
	int nCasterLevel = GetCasterLevel(oTarget);
	
	if(GetIsObjectValid(oArmor))
	{
		int nArmorType = GetArmorRulesType(oArmor);
		nBaseAC = StringToInt(Get2DAString("armorrulestats", "ACBONUS", nArmorType));
		itemproperty ipArmor = GetFirstItemProperty(oArmor);
		while(GetIsItemPropertyValid(ipArmor))
		{
			if(GetItemPropertyType(ipArmor) == ITEM_PROPERTY_AC_BONUS)
			{
				int nEnhancement = GetItemPropertyCostTableValue(ipArmor);
				if(nEnhancedAC < nEnhancement)
					nEnhancedAC = nEnhancement;		
			}
			ipArmor = GetNextItemProperty(oArmor);
		}	
	}
	
	int nMageArmorBonus = 6 - nBaseAC;
	effect eMageArmor, eDur, eLink;
	
	if(nMageArmorBonus < 1)
	{
		//==== This is a placeholder. It exists in case someone casts dispel ===//
		eMageArmor = EffectSkillDecrease(0, 1);
	}
	else
	{
		nMageArmorBonus += nEnhancedAC;
		eMageArmor = EffectACIncrease(nMageArmorBonus, AC_ARMOUR_ENCHANTMENT_BONUS);		
	}
	
	eDur = EffectVisualEffect(100002);
	eLink = EffectLinkEffects(eMageArmor, eDur);
	
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);	
	DelayCommand(6.0f, CheckArmor(oArmor, oTarget, fDuration));	
}