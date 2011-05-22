// i_nwn2_it_ifist_hammer_ac
// OnActivate Script for Hammer of Ironfist
// Creates Clap of Thunder.
// CGaw OEI 8/18/06
// ChazM 9/1/06 - replaced item prop removal with IPRemoveMatchingItemProperties(); commented out extraneous includes.

#include "nw_i0_spells"
//#include "X0_I0_SPELLS"
//#include "ginc_math"
#include "ginc_item"

void ShockwaveEffects(object oItem, object oItemHolder, location lTarget);

void PlayCustomAnimationWrapper(object oObject, string sAnimationName, int nLooping, float fSpeed)
{
	PlayCustomAnimation(oObject, sAnimationName, nLooping, fSpeed);
}

void ItemPropertyCheck(object oItem)
{
	itemproperty ipDamageBonus = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL, 
		IP_CONST_DAMAGEBONUS_1d8);

	if (GetItemCharges(oItem) == 0)
	{
		RemoveSEFFromObject(oItem, "fx_defaultitem_elect.sef");
		IPRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_DAMAGE_BONUS, -1, -1); // ignore duration and subtype
		IPRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_CAST_SPELL, -1, -1);
	}	
}

void main()
{
    // * This code runs when the Unique Power property of the item is used
    object oItemHolder = GetItemActivator();
    object oItem    = GetItemActivated();
	location lTarget = GetLocation(oItemHolder);
	int nCurrentCharges = GetItemCharges(oItem);

	effect eShake = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);
	effect eExplosion = EffectNWN2SpecialEffectFile("sp_lightning_aoe.sef");
	effect eBolt = EffectNWN2SpecialEffectFile("sp_call_lightning.sef");
	effect eShockwave = EffectNWN2SpecialEffectFile("fx_shockwave.sef");

	PlayCustomAnimationWrapper(oItemHolder, "liftswordloop", 1, 2.0f);	
	DelayCommand(2.0f, 	PlayCustomAnimationWrapper(oItemHolder, "%", 1, 1.0));	
	DelayCommand(1.0f, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eBolt, lTarget));
	DelayCommand(1.2f, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplosion, lTarget));
	DelayCommand(1.2f, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eShake, lTarget, 0.5f));
	DelayCommand(1.2f, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eShockwave, lTarget, 0.5f));
	DelayCommand(1.4f, ShockwaveEffects(oItem, oItemHolder, lTarget));	
	DelayCommand(1.5f, ItemPropertyCheck(oItem));	
}	
	
void ShockwaveEffects(object oItem, object oItemHolder, location lTarget)
{    
	float fDelay;
	object oTarget;
	effect eDam = EffectDamage(d8(6), DAMAGE_TYPE_ELECTRICAL, DAMAGE_POWER_ENERGY);
    effect eHit = EffectNWN2SpecialEffectFile("sp_sonic_hit.sef");
	effect eHit2 = EffectNWN2SpecialEffectFile("sp_lightning_hit.sef");
	effect eStun = EffectStunned();
	effect eDeaf = EffectDeaf();
	int iHitRequirement = 15 + RandomIntBetween(1, 15);
	
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_VAST, lTarget, FALSE, OBJECT_TYPE_CREATURE);
	
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {	
	    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oItemHolder) && (oTarget != oItemHolder))
		{
			//Get the distance between the explosion and the target to calculate delay
			fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
			
	        if (!MySavingThrow(SAVING_THROW_FORT, oTarget, 25))
			{
	            // Apply effects to the currently selected target.
	            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget));
	            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, 9.0f));
	            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDeaf, oTarget, 18.0f));			
		    }  
			
			DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit2, oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));			
		}
		
    //Select the next target within the spell shape.
    oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_VAST, lTarget);
	}

	SetLocalInt(oItem, "times_hit_req", iHitRequirement);
	SetLocalInt(oItem, "times_hit", 0);
	SetLocalInt(oItem, "knockdown_capable", 0);
}