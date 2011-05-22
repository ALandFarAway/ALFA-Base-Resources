//::///////////////////////////////////////////////
//:: Chastise Spirits
//:: nx_s2_chastisespirits
//:://////////////////////////////////////////////
/*
    Beginning at 2nd level, a spirit shaman can
    deal 1d4 damage/shaman level to all spirits
    within 30 feet. The affected spirits get a
    Will save (DC 10 + shaman level + Cha modifier)
    for half damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 03/13/2007
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
    effect   eVis       = EffectVisualEffect(VFX_HIT_CHASTISE_SPIRITS);
    
    int nSaveDC = 10 + nShamanLvl + GetAbilityModifier(ABILITY_CHARISMA);

    int nDamage;
	int nSaveResult;
    float fDelay;
    effect eDam;
    
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {    //Cycle through the targets within the spell shape until an invalid object is captured.
        if ( spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster) &&
             GetIsSpirit(oTarget) &&    // Only targets spirits
             oTarget != oCaster )       // Caster is not injured by the spell.
        {
            SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));           // Fire cast spell at event for the specified target
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;  // Get the distance between the spirit shaman and the target to calculate the delay     

			// Will Save for 1/2 damage.
            nDamage = d4(nShamanLvl);
			nSaveResult = WillSave(oTarget, nSaveDC);
			if (nSaveResult == SAVING_THROW_CHECK_IMMUNE)
			{
				nDamage = 0;
			}
			else if (nSaveResult == SAVING_THROW_CHECK_SUCCEEDED)
			{
				nDamage = nDamage/2;
			}
			
            if ( nDamage > 0 )
            {
                //Set the damage effect
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_DIVINE);
                
                // Apply effects to the currently selected target.
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                
                //This visual effect is applied to the target object not the location as above.  This visual effect
                //represents the impact that erupts on the target not on the ground.
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            } 
        }
        
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}