//::///////////////////////////////////////////////
//:: Call Lightning Storm
//:: NX_s0_callstorm.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
    This spells smites an area around the caster
    with bolts of lightning which strike all enemies.
    Bolts do 3d6 per level up 15d6 and the reflex save
	is made at a -4 penalty.
	
	NOTE: The bioware implimentation of this spell
	is nothing like the PHB, so this is an approximation
	of the intended behavior.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills based on nw_s0_calllghtn (05.22.01 Preston Watamaniuk)
//:: Created On: 11.29.06
//:://////////////////////////////////////////////
//:: Updates to scripts go here.

#include "nw_i0_spells" 
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-23 by GeorgZ
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
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_LIGHTNING);
	effect eVis2 = EffectVisualEffect(916); //VFX_SPELL_HIT_CALL_LIGHTNING
	effect eDur = EffectVisualEffect(915); //VFX_SPELL_DUR_CALL_LIGHTNING
	effect eLink = EffectLinkEffects(eVis, eVis2);
    effect eDam;
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetSpellTargetLocation();
    //Limit Caster level for the purposes of damage
    if (nCasterLvl > 15)
    {
        nCasterLvl = 15;
    }
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE,OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oCaster, 1.75);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
        {
           //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CALL_LIGHTNING));
            //Get the distance between the explosion and the target to calculate delay
            fDelay = GetRandomDelay(1.4, 2.25);	// AFW-OEI 07/10/2007: Increase delay to synch better with AoE VFX.
            if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
            {
                //Roll damage for each target
                nDamage = d6(nCasterLvl);
                //Resolve metamagic
				nDamage = ApplyMetamagicVariableMods(nDamage, 90);
				
                //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
                nDamage = GetReflexAdjustedDamage(nDamage, oTarget, (GetSpellSaveDC()+4), SAVING_THROW_TYPE_ELECTRICITY);
                //Set the damage effect
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL);
                if(nDamage > 0)
                {
                    // Apply effects to the currently selected target.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    //This visual effect is applied to the target object not the location as above.  This visual effect
                    //represents the flame that erupts on the target not on the ground.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));
                }
             }
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}