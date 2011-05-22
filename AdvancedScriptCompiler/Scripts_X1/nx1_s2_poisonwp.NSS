// nx1_s2_poisonwp
/*
   Spell allows to add temporary poison properties to a melee weapon or stack of ammunition.
*/
// JSH/ChazM 5/11/07

#include "x2_inc_itemprop"
#include "X2_inc_switches"


void main()
{
    object oItem   = GetSpellCastItem();
    object oPC     = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    string sTag    = GetTag(oItem);
	float fDur     = IntToFloat(18); // 18 seconds/3 rounds
 		
  	if (oTarget == OBJECT_INVALID || GetObjectType(oTarget) != OBJECT_TYPE_ITEM)
  	{
       FloatingTextStrRefOnCreature(83359,oPC);         //"Invalid target "
       return;
  	}
  	int nType = GetBaseItemType(oTarget);
  	if (!IPGetIsMeleeWeapon(oTarget) &&
      !IPGetIsProjectile(oTarget)   &&
       nType != BASE_ITEM_SHURIKEN &&
       nType != BASE_ITEM_DART &&
       nType != BASE_ITEM_THROWINGAXE)
  	{
       FloatingTextStrRefOnCreature(83359,oPC);         //"* Failure: Target must be a melee weapon or projectile *"
       return;
  	}
	 	
	if (IPGetIsBludgeoningWeapon(oTarget))
 	{
       FloatingTextStrRefOnCreature(83367,oPC);         //"* Failure: Target weapon must do slashing or piercing damage *"
       return;
 	}
	
	/*
	if (IPGetItemHasItemOnHitPropertySubType(oTarget, 19)) // 19 == itempoison
 	{
        FloatingTextStrRefOnCreature(83407,oPC); // weapon already poisoned
        return;
 	}
	*/
	
  	// Get the 2da row to lookup the poison from the last three letters of the tag
	int nRow = StringToInt(GetStringRight(sTag,3)); // last 3 digits of tag determine row of poison.2da to checked  

 	if (nRow ==0)
 	{
   	 	FloatingTextStrRefOnCreature(83360,oPC);         //"Nothing happens
    	WriteTimestampedLogEntry ("Error: Item with tag " +GetTag(oItem) + " has the PoisonWeapon spellscript attached but tag does not contain 3 letter recipe code at the end!");
    	return;
  	}
	/*
   int nSaveDC     =  StringToInt(Get2DAString(X2_IP_POISONWEAPON_2DA,"SaveDC",nRow));
   int nDuration   =  StringToInt(Get2DAString(X2_IP_POISONWEAPON_2DA,"Duration",nRow));
   int nPoisonType =  StringToInt(Get2DAString(X2_IP_POISONWEAPON_2DA,"PoisonType",nRow)) ;
   int nApplyDC    =  StringToInt(Get2DAString(X2_IP_POISONWEAPON_2DA,"ApplyCheckDC",nRow)) ;
	*/
	
	int bHasFeat = GetHasFeat(960, oPC); // Handle Poison
	if (!bHasFeat) // If no Handle Poison feat, then 5% chance of failure
	{
        // * Force attacks of opportunity
		AssignCommand(oPC,ClearAllActions(TRUE));

		// Poison restricted to assassins and blackguards only?
        if (GetModuleSwitchValue(MODULE_SWITCH_RESTRICT_USE_POISON_TO_FEAT) == TRUE)
        {
        	FloatingTextStrRefOnCreature(84420,oPC);               //"Failed"
            return;
        }

        // int nDex = GetAbilityModifier(ABILITY_DEXTERITY,oPC) ;
        int nCheck = d20(1);
        if (nCheck == 1) // rolled a 1
        {
        	FloatingTextStrRefOnCreature(200923,oPC);               //"Failed"
            return;
       	}
       	else
       	{
          	FloatingTextStrRefOnCreature(200924,oPC);               //"Success"
       	}
   	}
   	else
   	{
       // some feedback to
       FloatingTextStrRefOnCreature(83369,oPC);         //"Auto success "
    }

	// Check to see if the weapon already has poison applied to it.
   	if (!GetItemHasItemProperty(oTarget, ITEM_PROPERTY_ON_MONSTER_HIT))
   	{
		itemproperty ip = ItemPropertyOnMonsterHitProperties(IP_CONST_ONMONSTERHIT_POISON, nRow);
  		IPSafeAddItemProperty(oTarget, ip, fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING,TRUE,TRUE);
	   	effect eVis = EffectVisualEffect(VFX_IMP_PULSE_NATURE);
    	FloatingTextStrRefOnCreature(83361,oPC);         //"Weapon is coated with poison"
        IPSafeAddItemProperty(oTarget, ItemPropertyVisualEffect(ITEM_VISUAL_ACID), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING,TRUE,FALSE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oTarget));
    }
    else
    {
       FloatingTextStrRefOnCreature(200926,oPC);         //"Nothing happens
    }
    
}