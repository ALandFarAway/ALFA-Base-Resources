//::///////////////////////////////////////////////
//:: Cone: Grit
//:: NW_S1_ConeGrit
//:://////////////////////////////////////////////
/*
  A cone of damage eminated from the monster. Does
  a set amount of damage based upon the creatures
  HD and can be halved with a Reflex Save.
*/
//:://////////////////////////////////////////////
//:: Created By: rjshae
//:: Created On: July 5, 2015
//:://////////////////////////////////////////////

const string VFX_IMP_GRIT_S = "fx_grit_hit"; // sp_acid_hit.sef
const string VFX_DUR_CONE_GRIT = "fx_grit_cone_mouth"; // sp_acid_cone_mouth.sef
const int SPELLABILITY_CONE_GRIT = 1216;

#include "NW_I0_SPELLS"
#include "acr_spells_i"
void main()
{
    //Declare major variables
    int nHD = GetHitDice(OBJECT_SELF);
    int nDamage;
    int nLoop = nHD / 3;
    int nDC = 10 + (nHD/2);
    float fDelay;
    if(nLoop == 0)
    {
        nLoop = 1;
    }
    location lTargetLocation = GetSpellTargetLocation();
    object oTarget;
    effect eCone;
	effect eVis = EffectNWN2SpecialEffectFile( VFX_IMP_GRIT_S );
	effect eSpray = EffectNWN2SpecialEffectFile( VFX_DUR_CONE_GRIT );
	
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSpray, OBJECT_SELF, 2.0);
    //Get first target in spell area
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            //Calculate the damage
            nDamage = d8(nLoop);
            //Dust cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_CONE_GRIT));
            //Determine effect delay
            fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
            //Set damage effect
            eCone = EffectDamage(nDamage, DAMAGE_TYPE_PIERCING);
			//Adjust damage according to Reflex Save, Evasion or Improved Evasion
			nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC());
            if(nDamage > 0)
            {
                //Apply the VFX impact and effects
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eCone, oTarget));
            }
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
    }
}