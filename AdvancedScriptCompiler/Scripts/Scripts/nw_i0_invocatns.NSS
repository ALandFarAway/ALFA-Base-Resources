//::///////////////////////////////////////////////
//:: Warlock Invocations Include
//:: NW_I0_INVOCATIONS
//:://////////////////////////////////////////////
/*
    Warlock Eldritch Essence & Blast Shape Invocations
    can be combined together (one of each) to modify
    the basic Eldritch Blast (Feat) behavior.
    Eldritch Essence Invocations apply extra effects to
    the target(s), whereas Blast Shape Invocations
    modify the # of targets affected.

    Internally, these combined invocations prioritize
    on the Blast Shape Invocations as the primary Spell.
    What this means is that the Blast Shape will always
    be the stored "Spell" in the UI, with the Essences
    being "Metamagics" that are applied to it.  This is
    because Blast Shapes control Ranges/AoE, and also so
    that only the Blast Shape Scripts need to worry about
    whether they have combined effects...
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: August 19, 2005
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Modified By: Brian Fox (BDF - OEI)
//:: Modified On: 6/29/06
//:: Modified the "Shape" functions to check for essences and create corresponding EffectVisualEffect
//:: Also modified the parameters of DoEldritchBlast, DoEldritchCombinedEffects, and DoEssenceXXX to recognize if they were called by "shapes"
//:://////////////////////////////////////////////
//:: AFW-OEI 02/20/2007: Added effects of Eldritch Master: +2 to the touch attack rolls and 50% extra damage.
//:: AFW-OEI 02/21/2007: Added the Epic Eldritch Blast chain: +1d6 to eldritch blast damage per Epic Eldritch Blast feat.
//:: AFW-OEI 05/08/2007: Added Hindering and Binding Blast Eldritch Essences.
//::PKM-OEI: 05.30.07: Touch attacks now do critical hit damage

#include "nw_i0_spells"
#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "x2_i0_spells"
#include "nwn2_inc_spells"


// JLR - OEI 07/20/05 -- Warlock Funcs
// Returns the highest level of Eldritch Blast available
int GetEldritchBlastLevel(object oCaster);

// Returns the base damage from the Eldritch Blast
int GetEldritchBlastDmg(object oCaster, object oTarget, int nAllowReflexSave=FALSE, int nIgnoreResists=FALSE, int nHalfDmg=FALSE, int nTouch=1);

// Does the actual Eldritch Blast...returns TRUE if it succeeded (so can do secondary effects)
int DoEldritchBlast(object oCaster, 
					object oTarget, 
					int bCalledFromShape = FALSE,
					int bDoTouchTest = TRUE, 
					int nDmgType = DAMAGE_TYPE_MAGICAL, 
					int nAllowReflexSave = FALSE, 
					int nIgnoreResists = FALSE, 
					int nHalfDmg = FALSE, 
					int nVFX = VFX_BEAM_ELDRITCH
					);

// Does the Metamagic Combined Effects
int DoEldritchCombinedEffects(object oTarget, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE);
void DoEldritchCombinedEffectsWrapper(object oTarget, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE);

// These do the Eldritch Essence Effects:
int DoEssenceDrainingBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE);
int DoEssenceFrightfulBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE);
int DoEssenceBeshadowedBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE);
void RunEssenceBrimstoneBlastImpact(object oTarget, object oCaster, int nRoundsLeft);
int DoEssenceBrimstoneBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE);
int DoEssenceHellrimeBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE);
int DoEssenceBewitchingBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE);
int DoEssenceNoxiousBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE);
void RunEssenceVitriolicBlastImpact(object oTarget, object oCaster, int nRoundsLeft);
int DoEssenceVitriolicBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE);
int DoEssenceUtterdarkBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE);
int DoEssenceHinderingBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE);
int DoEssenceBindingBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE);

// These do the Blast Shape Effects:
int DoShapeEldritchSpear();
int DoShapeHideousBlow();
int DoShapeEldritchChain();
int DoShapeEldritchCone();
int DoShapeEldritchDoom();


//::///////////////////////////////////////////////
//:: Functions
//::///////////////////////////////////////////////


// -------------------------------------------------------------------
// Returns the highest level of Eldritch Blast available
// AFW-OEI 02/21/2007: Removed hard damage cap.
int GetEldritchBlastLevel(object oCaster)
{
    int nBlstLvl = 0;

    if ( GetHasFeat(FEAT_ELDRITCH_BLAST_14, oCaster ) )         { nBlstLvl = 14; }
    else if ( GetHasFeat(FEAT_ELDRITCH_BLAST_13, oCaster ) )    { nBlstLvl = 13; }
    else if ( GetHasFeat(FEAT_ELDRITCH_BLAST_12, oCaster ) )    { nBlstLvl = 12; }
    else if ( GetHasFeat(FEAT_ELDRITCH_BLAST_11, oCaster ) )    { nBlstLvl = 11; }
    else if ( GetHasFeat(FEAT_ELDRITCH_BLAST_10, oCaster ) )    { nBlstLvl = 10; }
    else if ( GetHasFeat(FEAT_ELDRITCH_BLAST_9, oCaster ) )     { nBlstLvl = 9; }
    else if ( GetHasFeat(FEAT_ELDRITCH_BLAST_8, oCaster ) )     { nBlstLvl = 8; }
    else if ( GetHasFeat(FEAT_ELDRITCH_BLAST_7, oCaster ) )     { nBlstLvl = 7; }
    else if ( GetHasFeat(FEAT_ELDRITCH_BLAST_6, oCaster ) )     { nBlstLvl = 6; }
    else if ( GetHasFeat(FEAT_ELDRITCH_BLAST_5, oCaster ) )     { nBlstLvl = 5; }
    else if ( GetHasFeat(FEAT_ELDRITCH_BLAST_4, oCaster ) )     { nBlstLvl = 4; }
    else if ( GetHasFeat(FEAT_ELDRITCH_BLAST_3, oCaster ) )     { nBlstLvl = 3; }
    else if ( GetHasFeat(FEAT_ELDRITCH_BLAST_2, oCaster ) )     { nBlstLvl = 2; }
    else if ( GetHasFeat(FEAT_ELDRITCH_BLAST_1, oCaster ) )     { nBlstLvl = 1; }
    
    // AFW-OEI 02/21/2007: Epic Eldritch Blasts
    if      (GetHasFeat(FEAT_EPIC_ELDRITCH_BLAST_10, oCaster))      { nBlstLvl += 10; }
    else if (GetHasFeat(FEAT_EPIC_ELDRITCH_BLAST_9, oCaster) )      { nBlstLvl +=  9; }
    else if (GetHasFeat(FEAT_EPIC_ELDRITCH_BLAST_8, oCaster) )      { nBlstLvl +=  8; }
    else if (GetHasFeat(FEAT_EPIC_ELDRITCH_BLAST_7, oCaster) )      { nBlstLvl +=  7; }
    else if (GetHasFeat(FEAT_EPIC_ELDRITCH_BLAST_6, oCaster) )      { nBlstLvl +=  6; }
    else if (GetHasFeat(FEAT_EPIC_ELDRITCH_BLAST_5, oCaster) )      { nBlstLvl +=  5; }
    else if (GetHasFeat(FEAT_EPIC_ELDRITCH_BLAST_4, oCaster) )      { nBlstLvl +=  4; }
    else if (GetHasFeat(FEAT_EPIC_ELDRITCH_BLAST_3, oCaster) )      { nBlstLvl +=  3; }
    else if (GetHasFeat(FEAT_EPIC_ELDRITCH_BLAST_2, oCaster) )      { nBlstLvl +=  2; }
    else if (GetHasFeat(FEAT_EPIC_ELDRITCH_BLAST_1, oCaster) )      { nBlstLvl +=  1; }
 

// NOTE: Need to Add in Prestige "+1 Spellcasting" Bonuses here...

    return nBlstLvl;
}


// Returns the base damage from the Eldritch Blast
int GetEldritchBlastDmg(object oCaster, object oTarget, int nAllowReflexSave, int nIgnoreResists, int nHalfDmg, int nTouch/*=1*/)
{
    int nDmg = 0;

    // Note: Caster Lvl is /2 for purposes of Spell Resistance (done internally in code)
    //Make SR Check
    if ( nIgnoreResists || (!MyResistSpell(oCaster, oTarget)) )
    {
        int nDmgDice = GetEldritchBlastLevel(oCaster);
        nDmg = d6(nDmgDice);
		//Critical hit
		if (nTouch == 2 && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
		{
			nDmg = d6(nDmgDice * 2);
		}
        
        // AFW-OEI 02/20/2007: Eldritch Master increases damage by 50%
        if (GetHasFeat(FEAT_EPIC_ELDRITCH_MASTER, oCaster))
        {
            nDmg = nDmg + nDmg/2;
        }
        
        if ( nHalfDmg )
        {
            nDmg = nDmg / 2;
            if ( nDmg == 0 )
            {
                nDmg = 1;
            }
        }
        
        // Some Invocations allow chance to halve the damage
        if ( nAllowReflexSave )
        {
            nDmg = GetReflexAdjustedDamage(nDmg, oTarget, GetSpellSaveDC());
        }
    }

    return nDmg;
}


//int METAMAGIC_ELDRITCH_SHAPES = (METAMAGIC_INVOC_ELDRITCH_SPEAR | METAMAGIC_INVOC_HIDEOUS_BLOW | METAMAGIC_INVOC_ELDRITCH_CHAIN | METAMAGIC_INVOC_ELDRITCH_CONE | METAMAGIC_INVOC_ELDRITCH_DOOM);


int DoEldritchBlast(object oCaster, object oTarget, int bCalledFromShape, int bDoTouchTest, int nDmgType, int nAllowReflexSave, int nIgnoreResists, int nHalfDmg, int nVFX)
{
    // Default Blast w/no mods
    int nMetaMagic = GetMetaMagicFeat();
	int nHitVFX = VFX_INVOCATION_ELDRITCH_HIT;	// default is Edlritch
	int nTouch;
    //if ( nMetaMagic != METAMAGIC_NONE )
    //if ( !(nMetaMagic & METAMAGIC_ELDRITCH_SHAPES) )
	
	// adjust the VFX according to the essence
    if ( nMetaMagic & METAMAGIC_INVOC_DRAINING_BLAST )         { nHitVFX = VFX_INVOCATION_DRAINING_HIT; }
    else if ( nMetaMagic & METAMAGIC_INVOC_FRIGHTFUL_BLAST )   { nHitVFX = VFX_INVOCATION_FRIGHTFUL_HIT; }
    else if ( nMetaMagic & METAMAGIC_INVOC_BESHADOWED_BLAST )  { nHitVFX = VFX_INVOCATION_BESHADOWED_HIT; }
    else if ( nMetaMagic & METAMAGIC_INVOC_BRIMSTONE_BLAST )   { nHitVFX = VFX_INVOCATION_BRIMSTONE_HIT; }
    else if ( nMetaMagic & METAMAGIC_INVOC_HELLRIME_BLAST )    { nHitVFX = VFX_INVOCATION_HELLRIME_HIT; }
    else if ( nMetaMagic & METAMAGIC_INVOC_BEWITCHING_BLAST )  { nHitVFX = VFX_INVOCATION_BEWITCHING_HIT; }
    else if ( nMetaMagic & METAMAGIC_INVOC_NOXIOUS_BLAST )     { nHitVFX = VFX_INVOCATION_NOXIOUS_HIT; }
    else if ( nMetaMagic & METAMAGIC_INVOC_VITRIOLIC_BLAST )   { nHitVFX = VFX_INVOCATION_VITRIOLIC_HIT; }
    else if ( nMetaMagic & METAMAGIC_INVOC_UTTERDARK_BLAST )   { nHitVFX = VFX_INVOCATION_UTTERDARK_HIT; }
    else if ( nMetaMagic & METAMAGIC_INVOC_HINDERING_BLAST )   { nHitVFX = VFX_INVOCATION_HINDERING_HIT; }
    else if ( nMetaMagic & METAMAGIC_INVOC_BINDING_BLAST )     { nHitVFX = VFX_INVOCATION_BINDING_HIT; }

    effect eBeam = EffectBeam(nVFX, oCaster, BODY_NODE_HAND);

    if(bDoTouchTest)
    {
        // AFW-OEI 02/20/2007: Eldritch Master adds +2 to the attack roll.
        int nBonus = 0;
        if (GetHasFeat(FEAT_EPIC_ELDRITCH_MASTER, oCaster))
        {
            nBonus = 2;
        }
    
		nTouch      = TouchAttackRanged(oTarget, TRUE, nBonus);
		if (GetLocalInt(OBJECT_SELF, "NW_EB_TOUCH_RESULT")) //collect only when requested
		{
		    SetLocalInt(OBJECT_SELF, "NW_EB_TOUCH_RESULT", nTouch);
		}
		
        //if ( TouchAttackRanged( oTarget, TRUE, nBonus ) == TOUCH_ATTACK_RESULT_MISS )
		if (nTouch == TOUCH_ATTACK_RESULT_MISS)
        {
            // We only want to display the beam visual effect if the blast was NOT called from any of the Shape spells; otherwise, the shape will already have been displayed.
            if ( !bCalledFromShape )
            {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam,oTarget,1.0);
            }
            // Failed
            SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), TRUE));
            return FALSE;
        }
    }


    // Spell Effects not allowed to stack...
    // FIX: moved to essence code, to prevent losing effects if target saves from new attack
    //RemoveEffectsFromSpell(oTarget, GetSpellId());

    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster) == TRUE)
    {
        SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));

        int nDmg = GetEldritchBlastDmg(oCaster, oTarget, nAllowReflexSave, nIgnoreResists, nHalfDmg, nTouch);

        if ( nDmg > 0 )  // Make sure wasn't resisted
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), TRUE));

            //Set damage effect
            float fDelay = 0.0;
            effect eDam = EffectDamage(nDmg, nDmgType);
            effect eVis = EffectVisualEffect( nHitVFX );
            
            //Apply the damage effect
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget);
            DelayCommand( fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget) );

			// We only want to display the beam visual effect if the blast was NOT called from any of the Shape spells; otherwise, the shape will already have been displayed.
			if ( !bCalledFromShape )
			{
            	DelayCommand( fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam,oTarget,1.0) );
			}
			
            return TRUE;
        }
        if ( !bCalledFromShape )
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam,oTarget,1.0);
        }
    }
    return FALSE;
}


// -------------------------------------------------------------------
//
int DoEldritchCombinedEffects(object oTarget, int bDoTouchTest, int nAllowReflexSave, int nHalfDmg)
{
    int nMetaMagic = GetMetaMagicFeat();
    if ( nMetaMagic & METAMAGIC_INVOC_DRAINING_BLAST )         { return DoEssenceDrainingBlast(OBJECT_SELF, oTarget, TRUE, bDoTouchTest, nAllowReflexSave, nHalfDmg); }
    else if ( nMetaMagic & METAMAGIC_INVOC_FRIGHTFUL_BLAST )   { return DoEssenceFrightfulBlast(OBJECT_SELF, oTarget, TRUE, bDoTouchTest, nAllowReflexSave, nHalfDmg); }
    else if ( nMetaMagic & METAMAGIC_INVOC_BESHADOWED_BLAST )  { return DoEssenceBeshadowedBlast(OBJECT_SELF, oTarget, TRUE, bDoTouchTest, nAllowReflexSave, nHalfDmg); }
    else if ( nMetaMagic & METAMAGIC_INVOC_BRIMSTONE_BLAST )   { return DoEssenceBrimstoneBlast(OBJECT_SELF, oTarget, TRUE, bDoTouchTest, nAllowReflexSave, nHalfDmg); }
    else if ( nMetaMagic & METAMAGIC_INVOC_HELLRIME_BLAST )    { return DoEssenceHellrimeBlast(OBJECT_SELF, oTarget, TRUE, bDoTouchTest, nAllowReflexSave, nHalfDmg); }
    else if ( nMetaMagic & METAMAGIC_INVOC_BEWITCHING_BLAST )  { return DoEssenceBewitchingBlast(OBJECT_SELF, oTarget, TRUE, bDoTouchTest, nAllowReflexSave, nHalfDmg); }
    else if ( nMetaMagic & METAMAGIC_INVOC_NOXIOUS_BLAST )     { return DoEssenceNoxiousBlast(OBJECT_SELF, oTarget, TRUE, bDoTouchTest, nAllowReflexSave, nHalfDmg); }
    else if ( nMetaMagic & METAMAGIC_INVOC_VITRIOLIC_BLAST )   { return DoEssenceVitriolicBlast(OBJECT_SELF, oTarget, TRUE, bDoTouchTest, nAllowReflexSave, nHalfDmg); }
    else if ( nMetaMagic & METAMAGIC_INVOC_UTTERDARK_BLAST )   { return DoEssenceUtterdarkBlast(OBJECT_SELF, oTarget, TRUE, bDoTouchTest, nAllowReflexSave, nHalfDmg); }
    else if ( nMetaMagic & METAMAGIC_INVOC_HINDERING_BLAST )   { return DoEssenceHinderingBlast(OBJECT_SELF, oTarget, TRUE, bDoTouchTest, nAllowReflexSave, nHalfDmg); }
    else if ( nMetaMagic & METAMAGIC_INVOC_BINDING_BLAST )     { return DoEssenceBindingBlast(OBJECT_SELF, oTarget, TRUE, bDoTouchTest, nAllowReflexSave, nHalfDmg); }
    else
    {
        // No extra effects
		//SpeakString("DoEldritchCombinedEffects(...): No blast invocation.");	// DEBUG!
        return DoEldritchBlast(OBJECT_SELF, oTarget, TRUE, bDoTouchTest, DAMAGE_TYPE_MAGICAL, nAllowReflexSave, FALSE, nHalfDmg);
    }
}

void DoEldritchCombinedEffectsWrapper(object oTarget, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE)
{
    DoEldritchCombinedEffects(oTarget, FALSE, nAllowReflexSave, nHalfDmg);
}


// -------------------------------------------------------------------
// Eldritch Essence Effects:
int DoEssenceDrainingBlast(object oCaster, object oTarget, int bCalledFromShape, int bDoTouchTest, int nAllowReflexSave, int nHalfDmg)
{
    // First, do Base Effects:
    if ( DoEldritchBlast(oCaster, oTarget, bCalledFromShape, bDoTouchTest, DAMAGE_TYPE_MAGICAL, nAllowReflexSave, FALSE, nHalfDmg, VFX_INVOCATION_DRAINING_RAY) )
    {
        // Additional Effects: (Slow Effect)
        if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        {
            if(!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC()))
            {
                float fDuration = RoundsToSeconds(1);

                effect eSlow = EffectSlow();
                effect eDur = EffectVisualEffect( VFX_IMP_SLOW );
                effect eLink = EffectLinkEffects(eSlow, eDur);
                //effect eVis = EffectVisualEffect( VFX_INVOCATION_DRAINING_HIT );	// handled by DoEldritchBlast()

                // Spell Effects not allowed to stack...
                RemoveEffectsFromSpell(oTarget, GetSpellId());

                //Apply the slow effect and VFX impact
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
                //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);	// handled by DoEldritchBlast()
                return TRUE;
            }
        }
    }
    return FALSE;
}


int DoEssenceFrightfulBlast(object oCaster, object oTarget, int bCalledFromShape, int bDoTouchTest, int nAllowReflexSave, int nHalfDmg)
{
    // First, do Base Effects:
    if ( DoEldritchBlast(oCaster, oTarget, bCalledFromShape, bDoTouchTest, DAMAGE_TYPE_MAGICAL, nAllowReflexSave, FALSE, nHalfDmg, VFX_INVOCATION_FRIGHTFUL_RAY) )
    {
        // Additional Effects: (Cause Fear Effect)
        if ((GetHitDice(oTarget) < 6) && GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        {
            if(!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FEAR))
            {
                float fDuration = RoundsToSeconds(10);

                effect eScare = EffectFrightened();
                effect eSave = EffectSavingThrowDecrease(SAVING_THROW_WILL, 2, SAVING_THROW_TYPE_MIND_SPELLS);
                effect eMind = EffectVisualEffect( VFX_DUR_SPELL_FEAR );
                //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);	// handled by VFX_DUR_SPELL_FEAR
                effect eDamagePenalty = EffectDamageDecrease(2);
                effect eAttackPenalty = EffectAttackDecrease(2);
                effect eLink = EffectLinkEffects(eMind, eScare);
                effect eLink2 = EffectLinkEffects(eSave, eDamagePenalty);
                eLink2 = EffectLinkEffects(eLink2, eAttackPenalty);
                eLink2 = EffectLinkEffects(eLink2, eLink);

                // Spell Effects not allowed to stack...
                RemoveEffectsFromSpell(oTarget, GetSpellId());

                //Apply linked effects and VFX impact
                //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, fDuration);
                return TRUE;
            }
        }
    }
    return FALSE;
}


int DoEssenceBeshadowedBlast(object oCaster, object oTarget, int bCalledFromShape, int bDoTouchTest, int nAllowReflexSave, int nHalfDmg)
{
    // First, do Base Effects:
    if ( DoEldritchBlast(oCaster, oTarget, bCalledFromShape, bDoTouchTest, DAMAGE_TYPE_MAGICAL, nAllowReflexSave, FALSE, nHalfDmg, VFX_INVOCATION_BESHADOWED_RAY) )
    {
        // Additional Effects: (Darkness)
        if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        {
            //Make Fort save
            if(!MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC()))
            {
                float fDuration = RoundsToSeconds(1);
				int nDex = GetAbilityScore( oTarget, ABILITY_DEXTERITY );
				

                //effect eDark = EffectDarkness();
				effect eDark = EffectBlindness();
				effect eAC = EffectACDecrease( 2 );
				effect eLink = EffectLinkEffects( eDark, eAC );
                //effect eDur = EffectVisualEffect(VFX_INVOCATION_BESHADOWED_HIT);	// handled by DoEldritchBlast()
                //effect eLink = EffectLinkEffects(eDark, eDur);	// handled by DoEldritchBlast()

                // Spell Effects not allowed to stack...
                RemoveEffectsFromSpell(oTarget, GetSpellId());

                //Apply the effect and VFX impact
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
				
				if (nDex > 10)
				{
					int nDecr = (nDex-10);
					effect eDex = EffectAbilityDecrease( ABILITY_DEXTERITY, nDecr);
					
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDex, oTarget, fDuration);
				}
                return TRUE;
            }
        }
    }
    return FALSE;
}


void RunEssenceBrimstoneBlastImpact(object oTarget, object oCaster, int nRoundsLeft)
{
	//SpeakString("RunEssenceBrimstoneBlastImpact(...): Entering function.");	// DEBUG!
	
	// AFW-OEI 07/06/2006: Can't "dispel" fire, so no need to check effects
    //if (GZGetDelayedSpellEffectsExpired(SPELL_I_BRIMSTONE_BLAST, oTarget, oCaster))
    //{
    //    return;
    //}

	
    if ((GetIsDead(oTarget) == FALSE) && (nRoundsLeft > 0))
    {
        int nDC = GetDelayedSpellInfoSaveDC(SPELL_I_BRIMSTONE_BLAST, oTarget, oCaster);

		
        if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_FIRE))
        {
            int nDmg = d6(2);
            effect eDmg = EffectDamage(nDmg,DAMAGE_TYPE_FIRE);
            

            ApplyEffectToObject(DURATION_TYPE_INSTANT,eDmg,oTarget);
            //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oTarget, 6.0);	// handled by DoEldritchBlast()

            nRoundsLeft = nRoundsLeft - 1;
            DelayCommand(RoundsToSeconds(1), RunEssenceBrimstoneBlastImpact(oTarget, oCaster, nRoundsLeft));	// Delay for one more round
        }
        else
        {
            RemoveDelayedSpellInfo(SPELL_I_BRIMSTONE_BLAST, oTarget, oCaster);
            //GZRemoveSpellEffects(SPELL_I_BRIMSTONE_BLAST, oTarget);
        }
    }
}


int DoEssenceBrimstoneBlast(object oCaster, object oTarget, int bCalledFromShape, int bDoTouchTest, int nAllowReflexSave, int nHalfDmg)
{
	//SpeakString("DoEssenceBrimstoneBlast(...): Entering function.");	// DEBUG!
	int nHasSpellEffect = GetHasSpellEffect(GetSpellId(), oTarget);

    // First, do Base Effects:
    if ( DoEldritchBlast(oCaster, oTarget, bCalledFromShape, bDoTouchTest, DAMAGE_TYPE_FIRE, nAllowReflexSave, FALSE, nHalfDmg, VFX_INVOCATION_BRIMSTONE_RAY) )
    {
        // Additional Effects: (Combust)
        if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        {
			
            // Doesn't Stack!
            if (nHasSpellEffect == 1)
            {
                //FloatingTextStrRefOnCreature(100775, OBJECT_SELF, FALSE);
                return FALSE;
            }

            int nCasterLvl = GetCasterLevel(OBJECT_SELF);
            int nRoundsLeft;
            if ( nCasterLvl >= 20 )       { nRoundsLeft = 4; }
            else if ( nCasterLvl >= 15 )  { nRoundsLeft = 3; }
            else if ( nCasterLvl >= 10 )  { nRoundsLeft = 2; }
            else                          { nRoundsLeft = 1; }

            int nDC = GetSpellSaveDC();
            SaveDelayedSpellInfo(SPELL_I_BRIMSTONE_BLAST, oTarget, oCaster, nDC);
			effect eVFX = ExtraordinaryEffect(EffectVisualEffect(894));
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oTarget, RoundsToSeconds(nRoundsLeft));	
			DelayCommand(RoundsToSeconds(1), RunEssenceBrimstoneBlastImpact(oTarget, oCaster, nRoundsLeft));	// First check should be one round after the blast hit
				
	        return TRUE;
        }
    }
    return FALSE;
}


int DoEssenceHellrimeBlast(object oCaster, object oTarget, int bCalledFromShape, int bDoTouchTest, int nAllowReflexSave, int nHalfDmg)
{
    // First, do Base Effects:
    if ( DoEldritchBlast(oCaster, oTarget, bCalledFromShape, bDoTouchTest, DAMAGE_TYPE_COLD, nAllowReflexSave, FALSE, nHalfDmg, VFX_INVOCATION_HELLRIME_RAY) )
    {
        // Additional Effects: (Dex Penalty)
        if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        {
            if(!MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC()))
            {
                float fDuration = RoundsToSeconds(3);

                effect eDex = EffectAbilityDecrease(ABILITY_DEXTERITY, 4);
                //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
				//effect eVis = EffectVisualEffect( VFX_INVOCATION_HELLRIME_HIT );	// handled by DoEldritchBlast()
               // effect eLink = EffectLinkEffects(eDex, eDur);

                // Spell Effects not allowed to stack...
                RemoveEffectsFromSpell(oTarget, GetSpellId());

                //Apply the effect and VFX impact
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDex, oTarget, fDuration);
                //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);	// handled by DoEldritchBlast()
                return TRUE;
            }
        }
    }
    return FALSE;
}


int DoEssenceBewitchingBlast(object oCaster, object oTarget, int bCalledFromShape, int bDoTouchTest, int nAllowReflexSave, int nHalfDmg)
{
    // First, do Base Effects:
    if ( DoEldritchBlast(oCaster, oTarget, bCalledFromShape, bDoTouchTest, DAMAGE_TYPE_MAGICAL, nAllowReflexSave, FALSE, nHalfDmg, VFX_INVOCATION_BEWITCHING_RAY) )
    {
        // Additional Effects: (Confusion)
        if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        {
            if (!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS))
            {
                float fDuration = RoundsToSeconds(1);

                //effect eVis = EffectVisualEffect( VFX_INVOCATION_BEWITCHING_HIT );	// handled by DoEldritchBlast()
                effect eConfuse = EffectConfused();
                effect eMind = EffectVisualEffect( VFX_DUR_SPELL_CONFUSION );
                //effect eDur = EffectVisualEffect( VFX_INVOCATION_BEWITCHING_HIT );
                //Link duration VFX and confusion effects
                effect eLink = EffectLinkEffects(eMind, eConfuse);
                //eLink = EffectLinkEffects(eLink, eDur);

                // Spell Effects not allowed to stack...
                RemoveEffectsFromSpell(oTarget, GetSpellId());

                //Apply linked effect and VFX Impact
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
                //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);	// handled by DoEldritchBlast()
                return TRUE;
            }
        }
    }
    return FALSE;
}


int DoEssenceNoxiousBlast(object oCaster, object oTarget, int bCalledFromShape, int bDoTouchTest, int nAllowReflexSave, int nHalfDmg)
{
    // First, do Base Effects:
    if ( DoEldritchBlast(oCaster, oTarget, bCalledFromShape, bDoTouchTest, DAMAGE_TYPE_MAGICAL, nAllowReflexSave, FALSE, nHalfDmg, VFX_INVOCATION_NOXIOUS_RAY) )
    {
        // Additional Effects: (Daze)
        if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        {
            if (!MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC()))
            {
                float fDuration = RoundsToSeconds(10);

                effect eMind = EffectVisualEffect( VFX_DUR_SPELL_DAZE );
                effect eDaze = EffectDazed();
                //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
                effect eLink = EffectLinkEffects(eMind, eDaze);
                //eLink = EffectLinkEffects(eLink, eDur);
                //effect eVis = EffectVisualEffect( VFX_INVOCATION_NOXIOUS_HIT );	// handled by DoEldritchBlast()

                // Spell Effects not allowed to stack...
                RemoveEffectsFromSpell(oTarget, GetSpellId());

                //Apply the effect and VFX impact
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
                //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);	// handled by DoEldritchBlast()
                return TRUE;
            }
        }
    }
    return FALSE;
}


void RunEssenceVitriolicBlastImpact(object oTarget, object oCaster, int nRoundsLeft)
{
// AFW-OEI 07/06/2006: Vitriolic Blast has no save and ignores spell resistance!.

// JLR-OEI 06/30/06: Delayed spell info not desired here...because no associated effect keyed to target
//    if (GZGetDelayedSpellEffectsExpired(SPELL_I_VITRIOLIC_BLAST, oTarget, oCaster))
//    {
//        return;
//    }

	//SpeakString("RunEssenceVitriolicBlastImpact(...): Entering function.");	// DEBUG!

    if ((GetIsDead(oTarget) == FALSE) && (nRoundsLeft > 0))
    {
//        int nDC = GetDelayedSpellInfoSaveDC(SPELL_I_VITRIOLIC_BLAST, oTarget, oCaster);
//        {
            int nDmg = d6(2);
            effect eDmg = EffectDamage(nDmg,DAMAGE_TYPE_ACID);
            //effect eVFX = EffectVisualEffect( VFX_IMP_ACID_S );	// handled by DoEldritchBlast()

            ApplyEffectToObject(DURATION_TYPE_INSTANT,eDmg,oTarget);
            //ApplyEffectToObject(DURATION_TYPE_INSTANT,eVFX,oTarget);	// handled by DoEldritchBlast()

            nRoundsLeft = nRoundsLeft - 1;
            DelayCommand(RoundsToSeconds(1), RunEssenceVitriolicBlastImpact(oTarget, oCaster, nRoundsLeft));	// Delay for one more round
//        }
    }
    else
    {
//        RemoveDelayedSpellInfo(SPELL_I_VITRIOLIC_BLAST, oTarget, oCaster);
//        GZRemoveSpellEffects(SPELL_I_VITRIOLIC_BLAST, oTarget);
    }
}


int DoEssenceVitriolicBlast(object oCaster, object oTarget, int bCalledFromShape, int bDoTouchTest, int nAllowReflexSave, int nHalfDmg)
{
	//SpeakString("DoEssenceVitriolicBlast(...): Entering function.");	// DEBUG!

	int nHasSpellEffect = GetHasSpellEffect(GetSpellId(), oTarget);

    // First, do Base Effects:
    if ( DoEldritchBlast(oCaster, oTarget, bCalledFromShape, bDoTouchTest, DAMAGE_TYPE_ACID, nAllowReflexSave, TRUE, nHalfDmg, VFX_INVOCATION_VITRIOLIC_RAY) )
    {
        // Additional Effects: (Acid)
        if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        {
            int nDC = GetSpellSaveDC();
            {
                // Doesn't Stack!
                //if (GetHasSpellEffect(GetSpellId(),oTarget))    // JLR-OEI 06/30/06: This will always return true due to above eldritch blast dmg effect that gets applied
                if (nHasSpellEffect == 1)
				{
                    //FloatingTextStrRefOnCreature(100775, OBJECT_SELF, FALSE);
                    return FALSE;
                }

                int nCasterLvl = GetCasterLevel(OBJECT_SELF);
                int nRoundsLeft;
                if ( nCasterLvl >= 20 )       { nRoundsLeft = 4; }
                else if ( nCasterLvl >= 15 )  { nRoundsLeft = 3; }
                else if ( nCasterLvl >= 10 )  { nRoundsLeft = 2; }
                else                          { nRoundsLeft = 1; }

				// JLR-OEI 06/30/06: Delayed spell info not desired here...because no associated effect keyed to target
//                SaveDelayedSpellInfo(SPELL_I_VITRIOLIC_BLAST, oTarget, oCaster, nDC);

                DelayCommand(RoundsToSeconds(1), RunEssenceVitriolicBlastImpact(oTarget, oCaster, nRoundsLeft)); // First check should be one round after the blast hit

                //Apply the effect and VFX impact
//                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                return TRUE;
            }
        }
    }
    return FALSE;
}


int DoEssenceUtterdarkBlast(object oCaster, object oTarget, int bCalledFromShape, int bDoTouchTest, int nAllowReflexSave, int nHalfDmg)
{
    // First, do Base Effects:
    if ( DoEldritchBlast(oCaster, oTarget, bCalledFromShape, bDoTouchTest, DAMAGE_TYPE_NEGATIVE, nAllowReflexSave, FALSE, nHalfDmg, VFX_INVOCATION_UTTERDARK_RAY) )
    {
        if(!MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC()))
        {
            effect eVis = EffectVisualEffect( VFX_DUR_SPELL_ENERGY_DRAIN );
            effect eDrain = EffectNegativeLevel(2);
            eDrain = SupernaturalEffect(eDrain);
			effect eLink = EffectLinkEffects( eDrain, eVis );

            // Spell Effects not allowed to stack...
            RemoveEffectsFromSpell(oTarget, GetSpellId());

            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
            //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDrain, oTarget, HoursToSeconds(1));
            //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            return TRUE;
        }
    }
    return FALSE;
}

int DoEssenceHinderingBlast(object oCaster, object oTarget, int bCalledFromShape, int bDoTouchTest, int nAllowReflexSave, int nHalfDmg)
{
    // First, do Base Effects:
    if ( DoEldritchBlast(oCaster, oTarget, bCalledFromShape, bDoTouchTest, DAMAGE_TYPE_MAGICAL, nAllowReflexSave, FALSE, nHalfDmg, VFX_INVOCATION_HINDERING_RAY) )
    {
        if(!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC()))
        {
            effect eVis = EffectVisualEffect( VFX_DUR_SPELL_SLOW );
            effect eSlow = EffectSlow();
            eSlow = SupernaturalEffect(eSlow);
			effect eLink = EffectLinkEffects( eSlow, eVis );

            // Spell Effects not allowed to stack...
            RemoveEffectsFromSpell(oTarget, GetSpellId());

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1));
            return TRUE;
        }
    }
    return FALSE;
}

int DoEssenceBindingBlast(object oCaster, object oTarget, int bCalledFromShape, int bDoTouchTest, int nAllowReflexSave, int nHalfDmg)
{
	//SpeakString("nw_i0_invocatns: DoEssenceBindingBlast");

    // First, do Base Effects:
    if ( DoEldritchBlast(oCaster, oTarget, bCalledFromShape, bDoTouchTest, DAMAGE_TYPE_MAGICAL, nAllowReflexSave, FALSE, nHalfDmg, VFX_INVOCATION_BINDING_RAY) )
    {
        if(!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC()))
        {
            effect eVis = EffectVisualEffect( VFX_DUR_STUN );
            effect eStun = EffectStunned();
            eStun = SupernaturalEffect(eStun);
			effect eLink = EffectLinkEffects( eStun, eVis );

            // Spell Effects not allowed to stack...
            RemoveEffectsFromSpell(oTarget, GetSpellId());

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1));
            return TRUE;
        }
    }
    return FALSE;
}

// -------------------------------------------------------------------
// Blast Shape Effects:
int DoShapeEldritchSpear()
{
				
    //Declare major variables
    object oTarget = GetSpellTargetObject();


    int nMetaMagic = GetMetaMagicFeat();
    if ( nMetaMagic & METAMAGIC_INVOC_DRAINING_BLAST )         { return DoEssenceDrainingBlast( OBJECT_SELF, oTarget, FALSE, TRUE ); }
    else if ( nMetaMagic & METAMAGIC_INVOC_FRIGHTFUL_BLAST )   { return DoEssenceFrightfulBlast( OBJECT_SELF, oTarget, FALSE, TRUE ); }
    else if ( nMetaMagic & METAMAGIC_INVOC_BESHADOWED_BLAST )  { return DoEssenceBeshadowedBlast( OBJECT_SELF, oTarget, FALSE, TRUE ); }
    else if ( nMetaMagic & METAMAGIC_INVOC_BRIMSTONE_BLAST )   { return DoEssenceBrimstoneBlast( OBJECT_SELF, oTarget, FALSE, TRUE ); }
    else if ( nMetaMagic & METAMAGIC_INVOC_HELLRIME_BLAST )    { return DoEssenceHellrimeBlast( OBJECT_SELF, oTarget, FALSE, TRUE ); }
    else if ( nMetaMagic & METAMAGIC_INVOC_BEWITCHING_BLAST )  { return DoEssenceBewitchingBlast( OBJECT_SELF, oTarget, FALSE, TRUE ); }
    else if ( nMetaMagic & METAMAGIC_INVOC_NOXIOUS_BLAST )     { return DoEssenceNoxiousBlast( OBJECT_SELF, oTarget, FALSE, TRUE ); }
    else if ( nMetaMagic & METAMAGIC_INVOC_VITRIOLIC_BLAST )   { return DoEssenceVitriolicBlast( OBJECT_SELF, oTarget, FALSE, TRUE ); }
    else if ( nMetaMagic & METAMAGIC_INVOC_UTTERDARK_BLAST )   { return DoEssenceUtterdarkBlast( OBJECT_SELF, oTarget, FALSE, TRUE ); }
    else if ( nMetaMagic & METAMAGIC_INVOC_HINDERING_BLAST )   { return DoEssenceHinderingBlast( OBJECT_SELF, oTarget, FALSE, TRUE ); }
    else if ( nMetaMagic & METAMAGIC_INVOC_BINDING_BLAST )     { return DoEssenceBindingBlast( OBJECT_SELF, oTarget, FALSE, TRUE ); }
    else
    {
        // No extra effects
		//SpeakString("DoEldritchCombinedEffects(...): No blast invocation.");	// DEBUG!
        return DoEldritchBlast( OBJECT_SELF, oTarget, FALSE, TRUE );
    }




    //return FALSE;
}


int DoShapeHideousBlow()
{
    //Declare major variables
    object oTarget = GetSpellTargetObject();

    // Handle combined Eldritch Essence Effects, if any
    return DoEldritchCombinedEffects(oTarget, FALSE);
}


int DoShapeEldritchChain()
{
	//SpeakString("DoShapeEldritchChain(): Entering function.");	// DEBUG!

    //Declare major variables
    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
    //Limit caster level
    // June 2/04 - Bugfix: Cap the level BEFORE the damage calculation, not after. Doh.
    if (nCasterLvl > 20) { nCasterLvl = 20; }
    int nNumAffected = 0;
    int nMetaMagic = GetMetaMagicFeat();
	
	int nChain1VFX = VFX_INVOCATION_ELDRITCH_CHAIN;	// default Chain1 is Eldritch
	int nChain2VFX = VFX_INVOCATION_ELDRITCH_CHAIN2;	// default Chain2 is Eldritch
	int nHitVFX = VFX_INVOCATION_ELDRITCH_HIT;	// default nHitVFX is Eldritch

	// adjust the VFX according to the essence
    if ( nMetaMagic & METAMAGIC_INVOC_DRAINING_BLAST )         
	{ 
		nChain1VFX = VFX_INVOCATION_DRAINING_CHAIN; 
		nChain2VFX = VFX_INVOCATION_DRAINING_CHAIN2;
		nHitVFX = VFX_INVOCATION_DRAINING_HIT;
	}
    else if ( nMetaMagic & METAMAGIC_INVOC_FRIGHTFUL_BLAST )   
	{ 
		nChain1VFX = VFX_INVOCATION_FRIGHTFUL_CHAIN; 
		nChain2VFX = VFX_INVOCATION_FRIGHTFUL_CHAIN2; 
		nHitVFX = VFX_INVOCATION_FRIGHTFUL_HIT;
	}
    else if ( nMetaMagic & METAMAGIC_INVOC_BESHADOWED_BLAST )  
	{ 
		nChain1VFX = VFX_INVOCATION_BESHADOWED_CHAIN; 
		nChain2VFX = VFX_INVOCATION_BESHADOWED_CHAIN2; 
		nHitVFX = VFX_INVOCATION_BESHADOWED_HIT;
	}
    else if ( nMetaMagic & METAMAGIC_INVOC_BRIMSTONE_BLAST )   
	{ 
		nChain1VFX = VFX_INVOCATION_BRIMSTONE_CHAIN; 
		nChain2VFX = VFX_INVOCATION_BRIMSTONE_CHAIN2; 
		nHitVFX = VFX_INVOCATION_BRIMSTONE_HIT;
	}
    else if ( nMetaMagic & METAMAGIC_INVOC_HELLRIME_BLAST )    
	{ 
		nChain1VFX = VFX_INVOCATION_HELLRIME_CHAIN; 
		nChain2VFX = VFX_INVOCATION_HELLRIME_CHAIN2; 
		nHitVFX = VFX_INVOCATION_HELLRIME_HIT;
	}
    else if ( nMetaMagic & METAMAGIC_INVOC_BEWITCHING_BLAST )  
	{ 
		nChain1VFX = VFX_INVOCATION_BEWITCHING_CHAIN; 
		nChain2VFX = VFX_INVOCATION_BEWITCHING_CHAIN2; 
		nHitVFX = VFX_INVOCATION_BEWITCHING_HIT;
	}
    else if ( nMetaMagic & METAMAGIC_INVOC_NOXIOUS_BLAST )     
	{ 
		nChain1VFX = VFX_INVOCATION_NOXIOUS_CHAIN; 
		nChain2VFX = VFX_INVOCATION_NOXIOUS_CHAIN2; 
		nHitVFX = VFX_INVOCATION_NOXIOUS_HIT;
	}
    else if ( nMetaMagic & METAMAGIC_INVOC_VITRIOLIC_BLAST )   
	{ 
		nChain1VFX = VFX_INVOCATION_VITRIOLIC_CHAIN; 
		nChain2VFX = VFX_INVOCATION_VITRIOLIC_CHAIN2; 
		nHitVFX = VFX_INVOCATION_VITRIOLIC_HIT;
	}
    else if ( nMetaMagic & METAMAGIC_INVOC_UTTERDARK_BLAST )   
	{ 
		nChain1VFX = VFX_INVOCATION_UTTERDARK_CHAIN; 
		nChain2VFX = VFX_INVOCATION_UTTERDARK_CHAIN2; 
		nHitVFX = VFX_INVOCATION_UTTERDARK_HIT;
	}
    else if ( nMetaMagic & METAMAGIC_INVOC_HINDERING_BLAST )   
	{ 
		nChain1VFX = VFX_INVOCATION_HINDERING_CHAIN; 
		nChain2VFX = VFX_INVOCATION_HINDERING_CHAIN2; 
		nHitVFX = VFX_INVOCATION_HINDERING_HIT;
	}
    else if ( nMetaMagic & METAMAGIC_INVOC_BINDING_BLAST )   
	{ 
		nChain1VFX = VFX_INVOCATION_BINDING_CHAIN; 
		nChain2VFX = VFX_INVOCATION_BINDING_CHAIN2; 
		nHitVFX = VFX_INVOCATION_BINDING_HIT;
	}
	
    //Declare lightning effect connected the casters hands
    effect eLightning = EffectBeam( nChain1VFX, OBJECT_SELF, BODY_NODE_HAND );
    effect eVis  = EffectVisualEffect( nHitVFX );
    object oFirstTarget = GetSpellTargetObject();
    object oHolder;
    object oTarget;
    location lSpellLocation;
    //Hit the initial target

    //if ( TouchAttackRanged( oTarget ) == TOUCH_ATTACK_RESULT_MISS )
    //{
    //    // Failed
    //    return FALSE;
    //}

    //setting this to non-zero will trigger collecting touch attack success info from DoEldritchCombinedEffects
    SetLocalInt(OBJECT_SELF, "NW_EB_TOUCH_RESULT", 1);

    //Apply effect to the first target and the VFX impact.
    if(DoEldritchCombinedEffects(oFirstTarget))
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oFirstTarget);
    }
    //Apply the lightning stream effect to the first target, connecting it with the caster
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLightning,oFirstTarget,0.5);


    //Reinitialize the lightning effect so that it travels from the first target to the next target
    eLightning = EffectBeam(nChain2VFX, oFirstTarget, BODY_NODE_CHEST);


    float fDelay = 0.2;
    int nCnt = 0;
    // Warlock Counts
    int nMaxCnt;
    if ( nCasterLvl >= 20 )      { nMaxCnt = 4; }
    else if ( nCasterLvl >= 15 ) { nMaxCnt = 3; }
    else if ( nCasterLvl >= 10 ) { nMaxCnt = 2; }
    else                         { nMaxCnt = 1; }


    // *
    // * Secondary Targets
    // *


    // AFW-OEI 02/20/2007: Eldritch Master adds +2 to the attack roll.
    int nBonus = 0;
    if (GetHasFeat(FEAT_EPIC_ELDRITCH_MASTER, OBJECT_SELF))
    {
        nBonus = 2;
    }   
    
    //Get the first target in the spell shape
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oFirstTarget), TRUE, OBJECT_TYPE_CREATURE );

    int nTouch = GetLocalInt(OBJECT_SELF, "NW_EB_TOUCH_RESULT");
    DeleteLocalInt(OBJECT_SELF, "NW_EB_TOUCH_RESULT");
    if ( nTouch == TOUCH_ATTACK_RESULT_MISS )
    {
	    // Failed
		return FALSE;
	}
    while (GetIsObjectValid(oTarget) && nCnt < nMaxCnt)
    {
		//SpeakString("DoShapeEldritchChain(): Chain target while loop iteration.");	// DEBUG!

        //Make sure the caster's faction is not hit and the first target is not hit
        if (oTarget != oFirstTarget && spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
        {
		    nTouch = TouchAttackRanged( oTarget, TRUE, nBonus );
		    if ( nTouch == TOUCH_ATTACK_RESULT_MISS )
            {
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLightning,oTarget,0.5));
    			    // Failed
    				return FALSE;
    		}
            //Connect the new lightning stream to the older target and the new target
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLightning,oTarget,0.5));
            {
                if ( nTouch == TOUCH_ATTACK_RESULT_CRITICAL && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT) )
                {
                    DelayCommand(fDelay, DoEldritchCombinedEffectsWrapper(oTarget,FALSE));
                }
                else
                {
                    DelayCommand(fDelay, DoEldritchCombinedEffectsWrapper(oTarget,FALSE,TRUE));
                }
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget));
            }
            oHolder = oTarget;

            //change the currect holder of the lightning stream to the current target
            if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
            {
                eLightning = EffectBeam( nChain2VFX, oHolder, BODY_NODE_CHEST );
            }
            else
            {
                // * April 2003 trying to make sure beams originate correctly
                effect eNewLightning = EffectBeam( nChain2VFX, oHolder, BODY_NODE_CHEST );
                if(GetIsEffectValid(eNewLightning))
                {
                    eLightning =  eNewLightning;
                }
            }

            fDelay = fDelay + 0.1f;
	        //Count the number of targets that have been hit.
	        if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE && !GetIsDead(oTarget))	// added the GetIsDead check to keep from cheating the player when corpses are hit, which were counting against the max count
	        {
	            nCnt++;
	        }
        }
		
        //Get the next target in the shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oFirstTarget), TRUE, OBJECT_TYPE_CREATURE);
    }

    return TRUE;
}


int DoShapeEldritchCone()
{
	//SpawnScriptDebugger();
    //Declare major variables
    location lTargetLocation = GetSpellTargetLocation();
    object oTarget;
    float fMaxDelay = 1.0;
    int nMetaMagic = GetMetaMagicFeat();
	int nConeVFX = VFX_INVOCATION_ELDRITCH_CONE;	// default cone is Eldritch

	// adjust the VFX according to the essence
    if ( nMetaMagic & METAMAGIC_INVOC_DRAINING_BLAST )         { nConeVFX = VFX_INVOCATION_DRAINING_CONE; }
    else if ( nMetaMagic & METAMAGIC_INVOC_FRIGHTFUL_BLAST )   { nConeVFX = VFX_INVOCATION_FRIGHTFUL_CONE; }
    else if ( nMetaMagic & METAMAGIC_INVOC_BESHADOWED_BLAST )  { nConeVFX = VFX_INVOCATION_BESHADOWED_CONE; }
    else if ( nMetaMagic & METAMAGIC_INVOC_BRIMSTONE_BLAST )   { nConeVFX = VFX_INVOCATION_BRIMSTONE_CONE; }
    else if ( nMetaMagic & METAMAGIC_INVOC_HELLRIME_BLAST )    { nConeVFX = VFX_INVOCATION_HELLRIME_CONE; }
    else if ( nMetaMagic & METAMAGIC_INVOC_BEWITCHING_BLAST )  { nConeVFX = VFX_INVOCATION_BEWITCHING_CONE; }
    else if ( nMetaMagic & METAMAGIC_INVOC_NOXIOUS_BLAST )     { nConeVFX = VFX_INVOCATION_NOXIOUS_CONE; }
    else if ( nMetaMagic & METAMAGIC_INVOC_VITRIOLIC_BLAST )   { nConeVFX = VFX_INVOCATION_VITRIOLIC_CONE; }
    else if ( nMetaMagic & METAMAGIC_INVOC_UTTERDARK_BLAST )   { nConeVFX = VFX_INVOCATION_UTTERDARK_CONE; }
    else if ( nMetaMagic & METAMAGIC_INVOC_HINDERING_BLAST )   { nConeVFX = VFX_INVOCATION_HINDERING_CONE; }
    else if ( nMetaMagic & METAMAGIC_INVOC_BINDING_BLAST )     { nConeVFX = VFX_INVOCATION_BINDING_CONE; }

	effect eCone = EffectVisualEffect( nConeVFX );
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCone, OBJECT_SELF, fMaxDelay);
	
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while(GetIsObjectValid(oTarget))
    {
        if (oTarget != OBJECT_SELF)
        {
        // Handle combined Eldritch Essence Effects, if any
        DoEldritchCombinedEffects(oTarget, FALSE, TRUE);
        }

        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
    return TRUE;
}


int DoShapeEldritchDoom()
{
    int nMetaMagic = GetMetaMagicFeat();
	int nDoomVFX = VFX_INVOCATION_ELDRITCH_AOE;	// default Doom is Eldritch

	// adjust the VFX according to the essence
    if ( nMetaMagic & METAMAGIC_INVOC_DRAINING_BLAST )         { nDoomVFX = VFX_INVOCATION_DRAINING_DOOM; }
    else if ( nMetaMagic & METAMAGIC_INVOC_FRIGHTFUL_BLAST )   { nDoomVFX = VFX_INVOCATION_FRIGHTFUL_DOOM; }
    else if ( nMetaMagic & METAMAGIC_INVOC_BESHADOWED_BLAST )  { nDoomVFX = VFX_INVOCATION_BESHADOWED_DOOM; }
    else if ( nMetaMagic & METAMAGIC_INVOC_BRIMSTONE_BLAST )   { nDoomVFX = VFX_INVOCATION_BRIMSTONE_DOOM; }
    else if ( nMetaMagic & METAMAGIC_INVOC_HELLRIME_BLAST )    { nDoomVFX = VFX_INVOCATION_HELLRIME_DOOM; }
    else if ( nMetaMagic & METAMAGIC_INVOC_BEWITCHING_BLAST )  { nDoomVFX = VFX_INVOCATION_BEWITCHING_DOOM; }
    else if ( nMetaMagic & METAMAGIC_INVOC_NOXIOUS_BLAST )     { nDoomVFX = VFX_INVOCATION_NOXIOUS_DOOM; }
    else if ( nMetaMagic & METAMAGIC_INVOC_VITRIOLIC_BLAST )   { nDoomVFX = VFX_INVOCATION_VITRIOLIC_DOOM; }
    else if ( nMetaMagic & METAMAGIC_INVOC_UTTERDARK_BLAST )   { nDoomVFX = VFX_INVOCATION_UTTERDARK_DOOM; }
    else if ( nMetaMagic & METAMAGIC_INVOC_HINDERING_BLAST )   { nDoomVFX = VFX_INVOCATION_HINDERING_DOOM; }
    else if ( nMetaMagic & METAMAGIC_INVOC_BINDING_BLAST )     { nDoomVFX = VFX_INVOCATION_BINDING_DOOM; }
 
   //Declare major variables
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetSpellTargetLocation();

    // Visual on the Location itself...
    effect eExplode = EffectVisualEffect( nDoomVFX );
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);

    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        // Handle combined Eldritch Essence Effects, if any
        DoEldritchCombinedEffects(oTarget, FALSE, TRUE);

        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
    return TRUE;
}

//void main() {}	// keep this line uncommented before saving/checking in; used only for compiling purposes

// -------------------------------------------------------------------