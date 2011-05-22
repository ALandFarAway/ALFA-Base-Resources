//::///////////////////////////////////////////////
//:: Earthquake
//:: X0_S0_Earthquake
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
// Ground shakes. 1d6 damage, max 10d6
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 22 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs May 01, 2003
//:: PKM-OEI 08.10.06 - VFX Update
//:: EPF 8/28/06 - added knockdown and arcane spell failure because the spell just sucks without them.

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 
#include "ginc_math"

void MyPlayCustomAnimation(object oCreature, string sAnim, int bLoop)
{
	PlayCustomAnimation(oCreature,sAnim,bLoop);
}

void main()
{
/* 
  Spellcast Hook Code 
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
*/

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables

    object oCaster = OBJECT_SELF;
    int nCasterLvl = GetCasterLevel(oCaster);
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    float fDelay;
    float nSize =  RADIUS_SIZE_COLOSSAL;
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_EVOCATION);
	effect eQuake = EffectVisualEffect( 875 );
    effect eDam;
    effect eShake = EffectVisualEffect(356); // screen shake
	
	// Link the shake to the other VFX
	effect eLink = EffectLinkEffects( eShake, eQuake );
	
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetSpellTargetLocation();
    //Limit Caster level for the purposes of damage
    if (nCasterLvl > 10)
    {
        nCasterLvl = 10;
    }
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, OBJECT_SELF, RoundsToSeconds(6));
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eLink, lTarget, RoundsToSeconds(6));
	
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, nSize, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    
	object oArea = GetArea(oCaster);
	
	while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    	{
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_EARTHQUAKE));
            //Get the distance between the explosion and the target to calculate delay
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;

// Earthquake does not allow spell resistance
//            if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
    	    
			 nDamage = MaximizeOrEmpower(6, nCasterLvl,  GetMetaMagicFeat());
             //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion. (Don't bother for caster)
             if (oTarget != oCaster)
             {
                 nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_ALL);
             }
             //Set the damage effect
             eDam = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING);
             // * caster can't be affected by the spell
			 
		if (oTarget != oCaster)
		{
			 // knockdown check - targets must reflex save or be knocked down for a round
			 // EPF  - 8/28/06 - trying to match this spell with PHB, since without knockdown it's underpowered
			 // Also put in a reflex save for the "falling into the fissure" aspect of the spell
			 
			 int nKnockdownSave = ReflexSave(oTarget, 15);
			 
			 if(nKnockdownSave == SAVING_THROW_CHECK_FAILED)
			 {
			 	float fKnockdownDelayOffset = RandomFloat(0.3);
			 	DelayCommand(fDelay + fKnockdownDelayOffset, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oTarget, RoundsToSeconds(1)));
			 }
			 
			 // concentration check for casters - they lose spells if they miss this
			 if(GetCurrentAction(oTarget) == ACTION_CASTSPELL)
			 {
				int nConcentrationDC = 20 + GetSpellLevel(SPELL_EARTHQUAKE);
				
				if(!GetIsSkillSuccessful(oTarget,SKILL_CONCENTRATION, nConcentrationDC))
				{
					DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSpellFailure(100), oTarget, RoundsToSeconds(1)));	
				}
			 }
		}
			 
             if( (nDamage > 0) && (oTarget != oCaster))
             {

                 // Apply effects to the currently selected target.
                 DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                 //This visual effect is applied to the target object not the location as above.  This visual effect
                 //represents the flame that erupts on the target not on the ground.
                 DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
             }
            
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, nSize, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}