//::///////////////////////////////////////////////
//:: Snilloc's Snowball Swarm

// Created by Riotnrrd for ALFA 2/2009

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 

void main()
{


    if (!ACR_PrecastEvent())
    {
	    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    //Declare major variables
    object oCaster = OBJECT_SELF;
    int nCasterLvl = GetCasterLevel(oCaster);
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
	int nBonus = (nCasterLvl - 3) / 2;
	if (nBonus < 0) nBonus = 0;
	if (nBonus > 3) nBonus = 3;
    float fDelay;
    
    effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
    effect eDam;
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetSpellTargetLocation();

    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    	{
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
			if (!MyResistSpell(OBJECT_SELF, oTarget))
			{
				//Roll damage for each target
				nDamage = d6(2) + d6(nBonus);
				//Resolve metamagic
				if (nMetaMagic == METAMAGIC_MAXIMIZE)
				{
					nDamage = 12 + 6 * nBonus;
				}
				else if (nMetaMagic == METAMAGIC_EMPOWER)
				{
					nDamage = nDamage + nDamage / 2;
				}
				//Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
				nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_COLD);
				//Set the damage effect
				eDam = EffectDamage(nDamage, DAMAGE_TYPE_COLD);
				if(nDamage > 0)
				{
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				}
			}
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}