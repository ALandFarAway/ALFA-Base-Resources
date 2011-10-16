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

void CheckArmor(object oShield, object oTarget, float fDuration);

void main()
{
	if (!X2PreSpellCastCode()) return;
	
	object oTarget = GetSpellTargetObject();
	object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
	
	int nBaseAC = 0;
	int nEnhancedAC = 0;
	int nCasterLevel = GetCasterLevel(oTarget);
	float fDuration = TurnsToSeconds(nCasterLevel);	
	
		
	if(GetIsObjectValid(oShield))
	{
		if(GetBaseItemType(oShield) == 14)
			nBaseAC = 1;
		if(GetBaseItemType(oShield) == 56)
			nBaseAC = 2;
		if(GetBaseItemType(oShield) == 57)
			nBaseAC = 4;
		itemproperty ipArmor = GetFirstItemProperty(oShield);
		while(GetIsItemPropertyValid(ipArmor))
		{
			if(GetItemPropertyType(ipArmor) == ITEM_PROPERTY_AC_BONUS)
			{
				int nEnhancement = GetItemPropertyCostTableValue(ipArmor);
				if(nEnhancedAC < nEnhancement)
					nEnhancedAC = nEnhancement;		
			}
			ipArmor = GetNextItemProperty(oShield);
		}	
	}
	
	int nMageArmorBonus = 4 - nBaseAC;
	effect eMageArmor, eDur, eLink;
	
	if(nMageArmorBonus < 1)
	{
		//=== This spell isn't helping right now. That's okay; the VFX will keep us warm at night ===//
		eLink = EffectVisualEffect(100003);
	}
	else
	{
		nMageArmorBonus += nEnhancedAC;
		eMageArmor = EffectACIncrease(nMageArmorBonus, AC_SHIELD_ENCHANTMENT_BONUS);		
		eDur = EffectVisualEffect(100003);
		eLink = EffectLinkEffects(eMageArmor, eDur);
	}
	

	
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
	DelayCommand(6.0f, CheckArmor(oShield, oTarget, fDuration));
}

void CheckArmor(object oShield, object oTarget, float fDuration)
{
	fDuration -= 6.0f;
		
	//=== The spell has ended or expired. Return to save memory. ===//
	int bDispelled = TRUE;
	
	effect eEffect = GetFirstEffect(oTarget);	
	while(GetIsEffectValid(eEffect))
	{
		if(GetEffectType(eEffect)         == EFFECT_TYPE_VISUALEFFECT &&
		   GetEffectInteger(eEffect, 0)   == 100003 &&
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
	if(oShield == GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget))
	{
		DelayCommand(6.0f, CheckArmor(oShield, oTarget, fDuration));
		return;
	}
	
	//=== Armor is new; we need to re-apply the effect with new calculations ===//
	eEffect = GetFirstEffect(oTarget);
	while(GetIsEffectValid(eEffect))
	{		
		if(GetEffectType(eEffect)         == EFFECT_TYPE_VISUALEFFECT &&
		   GetEffectInteger(eEffect, 0)   == 100003 &&
		   GetEffectSubType(eEffect)      == SUBTYPE_MAGICAL &&
		   GetEffectDurationType(eEffect) == DURATION_TYPE_TEMPORARY)
		     RemoveEffect(oTarget, eEffect);		
		eEffect = GetNextEffect(oTarget);
	}
	
	object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
	
	int nBaseAC = 0;
	int nEnhancedAC = 0;
	int nCasterLevel = GetCasterLevel(oTarget);
	
	if(GetIsObjectValid(oShield))
	{
		if(GetBaseItemType(oShield) == 14)
			nBaseAC = 1;
		if(GetBaseItemType(oShield) == 56)
			nBaseAC = 2;
		if(GetBaseItemType(oShield) == 57)
			nBaseAC = 4;
		itemproperty ipArmor = GetFirstItemProperty(oShield);
		while(GetIsItemPropertyValid(ipArmor))
		{
			if(GetItemPropertyType(ipArmor) == ITEM_PROPERTY_AC_BONUS)
			{
				int nEnhancement = GetItemPropertyCostTableValue(ipArmor);
				if(nEnhancedAC < nEnhancement)
					nEnhancedAC = nEnhancement;		
			}
			ipArmor = GetNextItemProperty(oShield);
		}	
	}
	
	int nMageArmorBonus = 4 - nBaseAC;
	effect eMageArmor, eDur, eLink;
	
	if(nMageArmorBonus < 1)
	{
		//==== This is a placeholder. It exists in case someone casts dispel ===//
		eMageArmor = EffectSkillDecrease(0, 1);
	}
	else
	{
		nMageArmorBonus += nEnhancedAC;
		eMageArmor = EffectACIncrease(nMageArmorBonus, AC_SHIELD_ENCHANTMENT_BONUS);		
	}
	
	eDur = EffectVisualEffect(100003);
	eLink = EffectLinkEffects(eMageArmor, eDur);
	
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);	
	DelayCommand(6.0f, CheckArmor(oShield, oTarget, fDuration));	
}