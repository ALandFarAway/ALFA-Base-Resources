//::///////////////////////////////////////////////
//:: Cone: Mephit_Dust_Breath
//:: NW_S1_MephDust
//:://////////////////////////////////////////////
/*
  A cone of irritating dust eminated from the
  monster. On a failed reflex save, causes -4 to
  AC and -2 to to attacks for 3 rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: rjshae
//:: Created On: July 8, 2015
//:://////////////////////////////////////////////

const string VFX_IMP_DUST_S = "fx_dust_hit";
const string VFX_DUR_CONE_DUST = "fx_dust_cone_mouth";
const int SPELLABILITY_MEPHIT_DUST_BREATH = 1219;

#include "NW_I0_SPELLS"
#include "acr_spells_i"
void main()
{
    //Declare major variables
    int nHD = GetHitDice(OBJECT_SELF);
    int nDC = 11 + (nHD/2);
    float fDelay;
    location lTargetLocation = GetSpellTargetLocation();
    object oTarget;
    effect eCone;
	effect eVis = EffectNWN2SpecialEffectFile( VFX_IMP_DUST_S );
	effect eSpray = EffectNWN2SpecialEffectFile( VFX_DUR_CONE_DUST );
	
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSpray, OBJECT_SELF, 2.0);
    //Get first target in spell area
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            //Dust cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_MEPHIT_DUST_BREATH));
			
			// Reflex save
            if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC)) {
            	//Determine effect delay
            	fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
				
				// Check for an existing effect
				if ( GetHasSpellEffect( SPELLABILITY_MEPHIT_DUST_BREATH, oTarget ) ) {
					RemoveEffectsFromSpell( oTarget, SPELLABILITY_MEPHIT_DUST_BREATH );
				}
				
				// Create the penalty effects
				effect eACPenalty = EffectACDecrease( 4 );
				effect eAttackPenalty = EffectAttackDecrease( 2 );
				effect eCone = EffectLinkEffects( eACPenalty, eAttackPenalty );
				eCone = ExtraordinaryEffect( eCone );
				eCone = SetEffectSpellId( eCone, SPELLABILITY_MEPHIT_DUST_BREATH );
				
                //Apply the VFX impact and effects
				float fDur = RoundsToSeconds( 3 );
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCone, oTarget, fDur));
            	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
			}
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
    }
}