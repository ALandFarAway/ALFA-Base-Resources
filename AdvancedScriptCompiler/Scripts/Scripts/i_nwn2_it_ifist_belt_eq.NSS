// i_nwn2_it_ifist_belt_eq

#include "x2_inc_itemprop"

void main()
{
    // * This code runs when the item is equipped
    object oPC      = GetPCItemLastEquippedBy();
    object oItem    = GetPCItemLastEquipped();
	object oGaunt;
	
	// Enhanced Belt Properties
	
	itemproperty ipSaveBonus = ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 2);
	itemproperty ipConBonus = ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON, 4);
	itemproperty ipSpellResist = ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_10);
	itemproperty ipImmunity = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_PARALYSIS);
//	itemproperty ipCast = ItemPropertyCastSpell(IP_CONST_CASTSPELL_IRON_BODY_15, 
//		IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
		
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
		
	if (GetResRef(GetItemInSlot(INVENTORY_SLOT_ARMS, oPC)) == "nwn2_it_ifist_gaunt")
	{	
		// Add Enhancements to Belt
		IPRemoveAllItemProperties(oItem, DURATION_TYPE_PERMANENT);
		
		AddItemProperty(DURATION_TYPE_PERMANENT, ipSaveBonus, oItem);
		AddItemProperty(DURATION_TYPE_PERMANENT, ipConBonus, oItem);
		AddItemProperty(DURATION_TYPE_PERMANENT, ipSpellResist, oItem);
		AddItemProperty(DURATION_TYPE_PERMANENT, ipImmunity, oItem);
//		AddItemProperty(DURATION_TYPE_PERMANENT, ipCast, oItem);
		
		// Add Enhancements to Gauntlets		
		oGaunt = GetItemInSlot(INVENTORY_SLOT_ARMS, oPC);
		
		IPRemoveAllItemProperties(oGaunt, DURATION_TYPE_PERMANENT);
		
		AddItemProperty(DURATION_TYPE_PERMANENT, ipDazeHit, oGaunt);
		AddItemProperty(DURATION_TYPE_PERMANENT, ipBlindHit, oGaunt);
		AddItemProperty(DURATION_TYPE_PERMANENT, ipSleepHit, oGaunt);
		AddItemProperty(DURATION_TYPE_PERMANENT, ipDamBonus, oGaunt);
		AddItemProperty(DURATION_TYPE_PERMANENT, ipAttBonus, oGaunt);
		AddItemProperty(DURATION_TYPE_PERMANENT, ipDazeHit, oGaunt);
		AddItemProperty(DURATION_TYPE_PERMANENT, ipRaceDamBonus, oGaunt);
		AddItemProperty(DURATION_TYPE_PERMANENT, ipStrBonus, oGaunt);
	}	
	
}