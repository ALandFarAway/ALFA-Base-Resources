// OnActivate Script for Staff of the Magi
// Creates Retributive Strike.
// CGaw OEI 8/2/06

void main()
{
    // * This code runs when the Unique Power property of the item is used
    object oPC      = GetItemActivator();
    object oItem    = GetItemActivated();
	location lTarget = GetLocation(oPC);
	int nCurrentCharges = GetItemCharges(oItem);

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