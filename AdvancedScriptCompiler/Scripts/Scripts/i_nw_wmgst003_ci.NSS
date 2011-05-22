// OnAcquire Script for Staff of the Magi
// Regulates Item Recharging.
// CGaw OEI 7/13/06
	
#include "ginc_item"
#include "ginc_debug"
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 
	
void AddItemProperties(object oItem)
{
	itemproperty ipDispel = ItemPropertyCastSpell(IP_CONST_CASTSPELL_DISPEL_MAGIC_10, 
		IP_CONST_CASTSPELL_NUMUSES_3_CHARGES_PER_USE);
	itemproperty ipInv = ItemPropertyCastSpell(IP_CONST_CASTSPELL_INVISIBILITY_3, 
		IP_CONST_CASTSPELL_NUMUSES_2_CHARGES_PER_USE);
	itemproperty ipAResist = ItemPropertyCastSpell(IP_CONST_CASTSPELL_ASSAY_RESISTANCE_7, 
		IP_CONST_CASTSPELL_NUMUSES_4_CHARGES_PER_USE);
	itemproperty ipLSMantle = ItemPropertyCastSpell(IP_CONST_CASTSPELL_LESSER_SPELL_MANTLE_9, 
		IP_CONST_CASTSPELL_NUMUSES_5_CHARGES_PER_USE);
	itemproperty ipFireball = ItemPropertyCastSpell(IP_CONST_CASTSPELL_FIREBALL_10, 
		IP_CONST_CASTSPELL_NUMUSES_3_CHARGES_PER_USE);
	itemproperty ipWeb = ItemPropertyCastSpell(IP_CONST_CASTSPELL_WEB_3, 
		IP_CONST_CASTSPELL_NUMUSES_2_CHARGES_PER_USE);
	itemproperty ipWFire = ItemPropertyCastSpell(IP_CONST_CASTSPELL_WALL_OF_FIRE_9, 
		IP_CONST_CASTSPELL_NUMUSES_4_CHARGES_PER_USE);
	itemproperty ipILMStrm = ItemPropertyCastSpell(IP_CONST_CASTSPELL_ISAACS_LESSER_MISSILE_STORM_13, 
		IP_CONST_CASTSPELL_NUMUSES_4_CHARGES_PER_USE);
	itemproperty ipMMiss = ItemPropertyCastSpell(IP_CONST_CASTSPELL_MAGIC_MISSILE_9, 
		IP_CONST_CASTSPELL_NUMUSES_1_CHARGE_PER_USE);
	itemproperty ipIMArm = ItemPropertyCastSpell(IP_CONST_CASTSPELL_IMPROVED_MAGE_ARMOR_10, 
		IP_CONST_CASTSPELL_NUMUSES_3_CHARGES_PER_USE);
	itemproperty ipPfE = ItemPropertyCastSpell(IP_CONST_CASTSPELL_PROTECTION_FROM_EVIL_1, 
		IP_CONST_CASTSPELL_NUMUSES_1_CHARGE_PER_USE);
	itemproperty ipCoCold = ItemPropertyCastSpell(IP_CONST_CASTSPELL_CONE_OF_COLD_15, 
		IP_CONST_CASTSPELL_NUMUSES_5_CHARGES_PER_USE);
	itemproperty ipLightBolt = ItemPropertyCastSpell(IP_CONST_CASTSPELL_LIGHTNING_BOLT_10, 
		IP_CONST_CASTSPELL_NUMUSES_3_CHARGES_PER_USE);
	itemproperty ipLMBlank = ItemPropertyCastSpell(IP_CONST_CASTSPELL_LESSER_MIND_BLANK_9, 
		IP_CONST_CASTSPELL_NUMUSES_5_CHARGES_PER_USE);
	itemproperty ipGStoneskin = ItemPropertyCastSpell(IP_CONST_CASTSPELL_STONESKIN_7, 
		IP_CONST_CASTSPELL_NUMUSES_4_CHARGES_PER_USE);
			
	AddItemProperty(DURATION_TYPE_PERMANENT, ipDispel, oItem);
	AddItemProperty(DURATION_TYPE_PERMANENT, ipInv, oItem);
//	AddItemProperty(DURATION_TYPE_PERMANENT, ipAResist, oItem);
	AddItemProperty(DURATION_TYPE_PERMANENT, ipLSMantle, oItem);
	AddItemProperty(DURATION_TYPE_PERMANENT, ipFireball, oItem);
	AddItemProperty(DURATION_TYPE_PERMANENT, ipWeb, oItem);
	AddItemProperty(DURATION_TYPE_PERMANENT, ipWFire, oItem);
	AddItemProperty(DURATION_TYPE_PERMANENT, ipILMStrm, oItem);
	AddItemProperty(DURATION_TYPE_PERMANENT, ipMMiss, oItem);
//	AddItemProperty(DURATION_TYPE_PERMANENT, ipIMArm, oItem);
//	AddItemProperty(DURATION_TYPE_PERMANENT, ipPfE, oItem);
	AddItemProperty(DURATION_TYPE_PERMANENT, ipCoCold, oItem);
	AddItemProperty(DURATION_TYPE_PERMANENT, ipLightBolt, oItem);
	AddItemProperty(DURATION_TYPE_PERMANENT, ipLMBlank, oItem);
	AddItemProperty(DURATION_TYPE_PERMANENT, ipGStoneskin, oItem);
}

void ExplodeStaff(object oItem, int nCurrentCharges)
{
    //Declare major variables
    object oCaster = OBJECT_SELF;
	int nDamage;
    float fDelay;
    
    /* Brock H. - OEI 03/03/06 -- Handled by the ImpactSEF column in the spells.2da
    effect eExplode = EffectVisualEffect(VFX_FNF_FIREBALL); */
    
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
	effect eShake = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);
	effect eExplosion = EffectNWN2SpecialEffectFile("sp_mswarm_lrg_imp.sef");
	effect eMagExplosion = EffectNWN2SpecialEffectFile("fx_magical_explosion.sef");
    effect eDam;
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetLocation(GetItemPossessor(oItem));
	
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplosion, lTarget);
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eMagExplosion, lTarget);
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eShake, lTarget, 0.5f);
    
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget);
	
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
		//Get the distance between the explosion and the target to calculate delay
		fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
		
//	    if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
//	 	{
	    	//Roll damage for each target
	        nDamage = 6 * nCurrentCharges;

	        //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
	        nDamage = GetReflexAdjustedDamage(nDamage, oTarget, 17, SAVING_THROW_TYPE_NONE);
	        //Set the damage effect
	        eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_ENERGY);
			
	        if(nDamage > 0)
	        {
	            // Apply effects to the currently selected target.
	            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
	            //This visual effect is applied to the target object not the location as above.  This visual effect
	            //represents the flame that erupts on the target not on the ground.
	            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
	        }
//		}
    //Select the next target within the spell shape.
    oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget);
	}
	DestroyObject(oItem);
}

void main()
{
	object oItem = GetSpellTargetObject();
	int nCurrentCharges = GetItemCharges(oItem);
	int nSpell2DARowNum = GetSpellId();
	int nSpellLevel = StringToInt(Get2DAString("spells", "Wiz_Sorc", nSpell2DARowNum));
			
	if (nSpellLevel == 0)
	{
		nSpellLevel = StringToInt(Get2DAString("spells", "Innate", nSpell2DARowNum));
	}
				
	if (nCurrentCharges + nSpellLevel > 50)
	{			
		nCurrentCharges = 50;
		ExplodeStaff(oItem, nCurrentCharges);
	}
	
	else if (nCurrentCharges < 5)
	{
		IPRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_CAST_SPELL, DURATION_TYPE_PERMANENT, -1);
		AddItemProperties(oItem);	
		SetItemCharges(oItem, nCurrentCharges + nSpellLevel);
	}
	
	else
	{
		SetItemCharges(oItem, nCurrentCharges + nSpellLevel);			
	}	
}