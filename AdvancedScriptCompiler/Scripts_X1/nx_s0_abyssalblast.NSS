//::///////////////////////////////////////////////
//:: Abyssal Blast
//:: nx_s0_abyssal_blast.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
   Death Knights can cast an infernal fireball called Abyssal Blast. 
   It functions like a combination of the fireball and flamestrike 
   spells, exploding in a sphere which does half fire damage and half
   divine damage. It deals 1d6 points of damage per HD of the death knight 
   (maximum 20d6), and a Reflex save (DC 10 + 1/2 the death knight's HD + 
   death knight's CHA modifier) is allowed for half damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Michael Diekmann
//:: Created On: 05/21/2007
//:://////////////////////////////////////////////
// ChazM 6/13/07 - fix signal event id.

#include "nwn2_inc_spells"
#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode())
    {
	    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    //Declare major variables
    object oCaster 		= 	OBJECT_SELF;
    int nHitDice 		= 	GetHitDice(oCaster);
    int nFireDamage;
	int nDivineDamage;
	int nSaveDC 		= 	10 + nHitDice/2 + GetAbilityModifier(ABILITY_CHARISMA, oCaster);
    float fDelay;   
    effect eFireVis 	= 	EffectVisualEffect(VFX_HIT_SPELL_FIRE);
	effect eDivineVis 	= 	EffectVisualEffect(VFX_HIT_SPELL_FLAMESTRIKE);
    effect eFireDam;
	effect eDivineDam;
	effect eLink;
    //Get the spell target location as opposed to the spell target.
    location lTarget 	= 	GetSpellTargetLocation();
    //Limit hit dice for the purposes of damage cap
    if (nHitDice > 20)
    {
        nHitDice = 20;
    }
    

    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    	{
         	//Fire cast spell at event for the specified target
	    	SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), TRUE)); // hostile spell
			
             //Get the distance between the explosion and the target to calculate delay
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
            if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
        	{
                //Roll damage for each target
                nFireDamage = d6(nHitDice);
                //Adjust the damage based on the Reflex Save with calculated DC value.
                nDivineDamage = GetReflexAdjustedDamage(nFireDamage/2, oTarget, nSaveDC, SAVING_THROW_TYPE_DIVINE);
				nFireDamage = GetReflexAdjustedDamage(nFireDamage/2, oTarget, nSaveDC, SAVING_THROW_TYPE_FIRE);
                //Set the damage effect
                eFireDam = EffectDamage(nFireDamage, DAMAGE_TYPE_FIRE);
				eDivineDam = EffectDamage(nDivineDamage, DAMAGE_TYPE_DIVINE);
                if(nFireDamage > 0 || nDivineDamage > 0)
                {
					//Link all damage and visual effects
					eLink = EffectLinkEffects( eDivineDam, eFireDam );
					eLink = EffectLinkEffects( eLink, eDivineVis );
					eLink = EffectLinkEffects( eLink, eFireVis );
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));
                }
            }
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
	
}