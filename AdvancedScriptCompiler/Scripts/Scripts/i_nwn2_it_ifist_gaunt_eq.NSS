// i_nwn2_it_ifist_gaunt_eq

#include "x2_inc_itemprop"

void main()
{
    // * This code runs when the item is equipped
    object oPC      = GetPCItemLastEquippedBy();
    object oItem    = GetPCItemLastEquipped();
	object oBelt;

	// Enhanced Gauntlet Properties
		
	itemproperty ipBlindHit = ItemPropertyOnHitProps(IP_CONST_ONHIT_BLINDNESS, IP_CONST_ONHIT_SAVEDC_24, 
		IP_CONST_ONHIT_DURATION_10_PERCENT_3_ROUNDS);
	itemproperty ipDazeHit = ItemPropertyOnHitProps(IP_CONST_ONHIT_DAZE, IP_CONST_ONHIT_SAVEDC_22, 
		IP_CONST_ONHIT_DURATION_10_PERCENT_2_ROUNDS);
	itemproperty ipSleepHit = ItemPropertyOnHitProps(IP_CONST_ONHIT_SLEEP, IP_CONST_ONHIT_SAVEDC_20, 
		IP_CONST_ONHIT_DURATION_5_PERCENT_2_ROUNDS);
	itemproperty ipDamBonus = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGEBONUS_1d6);
	itemproperty ipAttBonus = ItemPropertyAttackBonus(4);
	itemproperty ipStrBonus = ItemPropertyAbilityBonus(IP_CONST_ABILITY_STR, 4);
	itemproperty ipRaceDamBonus = ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_GIANT, 
		IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_1d8);
	
	// Enhanced Belt Properties
	
	itemproperty ipSaveBonus = ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 2);
	itemproperty ipConBonus = ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON, 4);
	itemproperty ipSpellResist = ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_10);
	itemproperty ipImmunity = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_PARALYSIS);
//	itemproperty ipCast = ItemPropertyCastSpell(IP_CONST_CASTSPELL_IRON_BODY_15, 
//		IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
		
	if (GetResRef(GetItemInSlot(INVENTORY_SLOT_BELT, oPC)) == "nwn2_it_ifist_belt")
	{	
		// Add Enhancements to Gauntlets	
		IPRemoveAllItemProperties(oItem, DURATION_TYPE_PERMANENT);
		
		AddItemProperty(DURATION_TYPE_PERMANENT, ipDazeHit, oItem);
		AddItemProperty(DURATION_TYPE_PERMANENT, ipBlindHit, oItem);
		AddItemProperty(DURATION_TYPE_PERMANENT, ipSleepHit, oItem);
		AddItemProperty(DURATION_TYPE_PERMANENT, ipDamBonus, oItem);
		AddItemProperty(DURATION_TYPE_PERMANENT, ipAttBonus, oItem);
		AddItemProperty(DURATION_TYPE_PERMANENT, ipRaceDamBonus, oItem);
		AddItemProperty(DURATION_TYPE_PERMANENT, ipStrBonus, oItem);
		
		// Add Enhancements to Belt
		oBelt = GetItemInSlot(INVENTORY_SLOT_BELT, oPC);
		
		IPRemoveAllItemProperties(oBelt, DURATION_TYPE_PERMANENT);
		
		AddItemProperty(DURATION_TYPE_PERMANENT, ipSaveBonus, oBelt);
		AddItemProperty(DURATION_TYPE_PERMANENT, ipConBonus, oBelt);
		AddItemProperty(DURATION_TYPE_PERMANENT, ipSpellResist, oBelt);
		AddItemProperty(DURATION_TYPE_PERMANENT, ipImmunity, oBelt);
//		AddItemProperty(DURATION_TYPE_PERMANENT, ipCast, oBelt);
	}	
	
}