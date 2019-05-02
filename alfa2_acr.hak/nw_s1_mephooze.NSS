//::///////////////////////////////////////////////
//:: Cone:MEPHIT_OOZE_BREATH
//:: NW_S1_MephOoze
//:://////////////////////////////////////////////
/*
  A cone of caustic liquid eminated from the
  monster. It causes 1d4 acid damage with DC 12
  reflex save for half. On a failed save, target
  creatures have -4 AC and -2 attack penalty for
  three rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: rjshae
//:: Created On: August 4, 2016
//:://////////////////////////////////////////////

const int SPELLABILITY_MEPHIT_OOZE_BREATH = 1221;

#include "NW_I0_SPELLS"
#include "acr_spells_i"
void main()
{
object oPC = GetFirstPC();
SendMessageToPC( oPC, "NW_S1_MephOoze" );
    //Declare major variables
    int nHD = GetHitDice(OBJECT_SELF);
    int nDC = 11 + (nHD/2);
    float fDist;
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    location lTargetLocation = GetSpellTargetLocation();
    int nDamage;
    object oTarget;
    effect eCone;
	effect eVis = EffectVisualEffect( VFX_IMP_ACID_S );
	effect eSpray = EffectVisualEffect( VFX_DUR_CONE_ACID );
    effect eAcid;
	float fMaxDelay = 0.0f; // Used to determine the duration of the flame cone.
	
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSpray, OBJECT_SELF, 2.0);
    //Get first target in spell area
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            //Dust cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_MEPHIT_OOZE_BREATH));
			
            //Calculate the delay time on the application of effects based on the distance
            //between the caster and the target
            fDist = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
			//fDist += 2.0f;
			if (fDist > fMaxDelay)
			{
				fMaxDelay = fDist;
			}
			nDamage = d4(nCasterLevel);
			//Enter Metamagic conditions
			if (nMetaMagic == METAMAGIC_MAXIMIZE)
			{
				nDamage = 4 * nCasterLevel;//Damage is at max
			}
			else if (nMetaMagic == METAMAGIC_EMPOWER)
			{
				nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
			}
			
			//Run the damage through the various reflex save and evasion feats
			nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_ACID);
			eAcid = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
			if(nDamage > 0)
			{
				// Apply effects to the currently selected target.
				DelayCommand(fDist, ApplyEffectToObject(DURATION_TYPE_INSTANT, eAcid, oTarget));
				DelayCommand(fDist, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
			}
			
			// Reflex save
            if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC)) {
				// Check for an existing effect
				if ( GetHasSpellEffect( SPELLABILITY_MEPHIT_OOZE_BREATH, oTarget ) ) {
					RemoveEffectsFromSpell( oTarget, SPELLABILITY_MEPHIT_OOZE_BREATH );
				}
				
				// Create the penalty effects
				effect eACPenalty = EffectACDecrease( 4 );
				effect eAttackPenalty = EffectAttackDecrease( 2 );
				effect eCone = EffectLinkEffects( eACPenalty, eAttackPenalty );
				eCone = ExtraordinaryEffect( eCone );
				eCone = SetEffectSpellId( eCone, SPELLABILITY_MEPHIT_OOZE_BREATH );
				
                //Apply the VFX impact and effects
				float fDur = RoundsToSeconds( 3 );
                DelayCommand(fDist, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCone, oTarget, fDur) );
				DelayCommand(6.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				DelayCommand(12.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
			}
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
    }
}