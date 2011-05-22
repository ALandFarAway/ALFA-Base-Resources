//::///////////////////////////////////////////////
//:: Fireburst
//:: NW_S0_Fireburst
//:://////////////////////////////////////////////
/*
    Burst of Fire from caster damaging everyone within
    5 feet.  Does 1d8/lvl (max 5d8) to everyone in
    range except for the caster.
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: July 11, 2005
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Update Pass By: Preston W, On: Aug 1, 2001

// JLR - OEI 08/23/05 -- Metamagic changes
#include "nwn2_inc_spells"


#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 

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
    int nMaxLvl;
    if ( nCasterLvl > 5 )
    {
        nMaxLvl = 5;
    }
    else
    {
        nMaxLvl = nCasterLvl;
    }
    int nDamage;
	int nDamage2;
    float fDelay;
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_FIRE);
    effect eDam,eDam2, eDam3;
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetSpellTargetLocation();
    //Apply the ice storm VFX at the location captured above.
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oTarget != oCaster) //Additional target check to make sure that the caster cannot be harmed by this spell
        {
            fDelay = GetRandomDelay(0.15, 0.35);
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FIREBURST));
            if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
            {
			
				nDamage = d8(nMaxLvl);
				nDamage = ApplyMetamagicVariableMods(nDamage, nMaxLvl * 8);
				nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FIRE);
				/*int nSave = ReflexSave(oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FIRE, OBJECT_SELF);
				
				if (nSave == 2)
				{
					return;
				}
				else if (nSave == 1)
				{
					nDamage = nDamage/2;
				}
				else
				{
					nDamage = nDamage;
				}*/
				
				 if ( nDamage > 0 )
                {
                    //Set the damage effect
                    eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
                    // Apply effects to the currently selected target.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    //This visual effect is applied to the target object not the location as above.  This visual effect
                    //represents the impact that erupts on the target not on the ground.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                } 
                /*//Roll damage for each target
                nDamage = d8(nMaxLvl);
                //Resolve metamagic
                nDamage = ApplyMetamagicVariableMods(nDamage, nMaxLvl * 8);
				nDamage2 = nDamage;
                nDamage2 = GetReflexAdjustedDamage(nDamage/2, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FIRE);
				nDamage = nDamage/2 + nDamage2;
                if ( nDamage > 0 )
                {
                    //Set the damage effect
                    eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
                    // Apply effects to the currently selected target.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    //This visual effect is applied to the target object not the location as above.  This visual effect
                    //represents the impact that erupts on the target not on the ground.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                } */
            }
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}