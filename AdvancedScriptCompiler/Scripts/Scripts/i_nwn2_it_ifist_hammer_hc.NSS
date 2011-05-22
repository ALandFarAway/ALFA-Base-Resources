// OnHit Script for Hammer of Ironfist
// Recharges weapon.
// CGaw OEI 8/18/06

#include "ginc_math"
#include "nw_i0_spells"
#include "ginc_debug"

void main()
{
    // * This code runs when the item scores a hit on an opponent
	object oItem  		= GetSpellCastItem();    // The item casting triggering this spellscript
	object oSpellOrigin = OBJECT_SELF ;
	object oSpellTarget = GetSpellTargetObject();
	object oPossessor = GetItemPossessor(oItem);
	int nCurrentCharges = GetItemCharges(oItem);
	int nTimesHit = GetLocalInt(oItem, "times_hit");
	int nTimesToHitRequied = GetLocalInt(oItem, "times_hit_req");
	effect eWeaponEffect = EffectNWN2SpecialEffectFile("sp_lightning_aoe.sef");
	effect eRecharge = EffectNWN2SpecialEffectFile("sp_lightning_cast.sef");
	effect eKnockdown = EffectKnockdown();
	itemproperty ipDamageBonus = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGEBONUS_1d8);
	itemproperty ipCast = ItemPropertyCastSpell(IP_CONST_CASTSPELL_UNIQUE_POWER_SELF_ONLY, IP_CONST_CASTSPELL_NUMUSES_1_CHARGE_PER_USE);
	
	SetLocalInt(oItem, "times_hit", nTimesHit + 1);

	if (GetLocalInt(oItem, "knockdown_capable") == 1)
	{
		if (RandomIntBetween(1, 20) == 20)
		{
			if (!MySavingThrow(SAVING_THROW_FORT, oSpellTarget, 20))
			{
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oSpellTarget, 9.0f);
				PrettyMessage("Knocking dude down.");
			}
		}
	}
	
	if (GetLocalInt(oItem, "times_hit") >= nTimesToHitRequied)
	{
		SetLocalInt(oItem, "times_hit", 0);
		
		if (nCurrentCharges == 0)
		{			
			SetItemCharges(oItem, nCurrentCharges + 1);	
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eWeaponEffect, oItem);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRecharge, oPossessor);
			AddItemProperty(DURATION_TYPE_PERMANENT, ipDamageBonus, oItem);
			AddItemProperty(DURATION_TYPE_PERMANENT, ipCast, oItem);
			SetLocalInt(oItem, "knockdown_capable", 1);
		}
	}
}