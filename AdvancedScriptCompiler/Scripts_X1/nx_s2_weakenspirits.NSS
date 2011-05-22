//::///////////////////////////////////////////////
//:: Weaken Spirits
//:: nx_s2_weakenspirits
//:://////////////////////////////////////////////
/*
	A spirit shaman can choose to strip spirits of
	their defenses by using a daily use of her
	chastise spirits ability. When a spirit is
	weakened, it loses its spell resistance, any
	damage reduction, and any miss chance or
	concealment effect it may have. This weakening
	effect lasts for 1 round plus 1 additional round
	for every 3 spirit shaman levels. Spirits that
	make their Will save (DC 10 + shaman level +
	Cha modifier) are unaffected by the weakening
	effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 03/19/2007
//:://////////////////////////////////////////////

#include "nwn2_inc_spells"
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 

void main()
{
    if (!X2PreSpellCastCode())
    {	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
    

    //Declare major variables
    object   oCaster    = OBJECT_SELF;
    int      nShamanLvl = GetLevelByClass(CLASS_TYPE_SPIRIT_SHAMAN, oCaster);
    location lTarget    = GetSpellTargetLocation();
    effect   eVis       = EffectVisualEffect(VFX_HIT_WEAKEN_SPIRITS);
    
    int nSaveDC = 10 + nShamanLvl + GetAbilityModifier(ABILITY_CHARISMA);

    float fDelay;
	float fDuration = RoundsToSeconds(1 + nShamanLvl/3);
	//SpeakString("nx_s2_weakenspirits: fDuration = " + FloatToString(fDuration));
    
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {    //Cycle through the targets within the spell shape until an invalid object is captured.
        if ( spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster) &&
             GetIsSpirit(oTarget) &&    // Only targets spirits
             oTarget != oCaster )       // Caster is not affected by the spell.
        {
			if (WillSave(oTarget, nSaveDC) == SAVING_THROW_CHECK_FAILED)
			{
	            SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));           // Fire cast spell at event for the specified target
	            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;  // Get the distance between the spirit shaman and the target to calculate the delay     
	
				effect eSR = EffectSpellResistanceDecrease(100);
				effect eDR = EffectDamageReductionNegated();
				effect eConceal = EffectConcealmentNegated();
				
				effect eLink = EffectLinkEffects(eSR, eDR);
				eLink = EffectLinkEffects(eLink, eConceal);
				
		    	// Apply effects to the currently selected target.
	            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration));
	              
	            //This visual effect is applied to the target object not the location as above.  This visual effect
	            //represents the impact that erupts on the target not on the ground.
	            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
			}
        }
        
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
	
	DecrementRemainingFeatUses(OBJECT_SELF, FEAT_CHASTISE_SPIRITS);
}