//::///////////////////////////////////////////////
//:: Prismatic Spray
//:: [NW_S0_PrisSpray.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Sends out a prismatic cone that has a random
//:: effect for each target struck.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Dec 19, 2000
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001
//:: Last Updated By: Aidan Scanlan On: April 11, 2001
//:: Last Updated By: Preston Watamaniuk, On: June 11, 2001
//:: Last Updated By: Brock Heinz, OEI, 08/17/05 (added Flesh to Stone)

int ApplyPrismaticEffect(int nEffect, object oTarget);

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 

const int PS_EFFECT_FIRE 			= 0;
const int PS_EFFECT_ACID 			= 1;
const int PS_EFFECT_ELECTRICITY 	= 2;
const int PS_EFFECT_POISON 			= 3;
const int PS_EFFECT_PARALYZE		= 4;
const int PS_EFFECT_CONFUSION		= 5;
const int PS_EFFECT_DEATH 			= 6;
const int PS_EFFECT_STONE 			= 7;
const int PS_EFFECT_COUNT 			= 8;

//Set the delay to apply to effects based on the distance to the target
float GetDelayForTarget( object oTarget )
{
	float fDelay = 1.5 + GetDistanceBetween(OBJECT_SELF, oTarget)/20;
	return fDelay;
}

void main()
{
    if (!X2PreSpellCastCode())
    {
		// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

	//SpawnScriptDebugger();

    //Declare major variables
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic	 = GetMetaMagicFeat();
    int nRandom, nHD, nVisual, bTwoEffects;
	effect eCone = EffectVisualEffect(VFX_DUR_CONE_COLORSPRAY);
	float fMaxDelay = 0.0f; // Used to determine length of Cone effect
    effect eVisual; int nVisual2 = 0;

    //Get first target in the spell area
	object oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 11.0, GetSpellTargetLocation());
	while (GetIsObjectValid(oTarget))
	{
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    	{
		   
		    float fDelay = GetDelayForTarget( oTarget );
			if (fMaxDelay < fDelay)
			{
				fMaxDelay = fDelay;
			}

            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_PRISMATIC_SPRAY));
            //Make an SR check
            //if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay) && (oTarget != OBJECT_SELF))
            if(oTarget != OBJECT_SELF && !MyResistSpell(OBJECT_SELF, oTarget, fDelay)) //FIX: prevents caster from getting SR check against himself
            {
                //Blind the target if they are less than 9 HD
                nHD = GetHitDice(oTarget);
                if (nHD <= 8)
                {
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBlindness(), oTarget, RoundsToSeconds(nCasterLevel));
                }

                //Determine if 1 or 2 effects are going to be applied
                nRandom = Random( PS_EFFECT_COUNT+1 ); // Get an integer between 0 and nMaxInteger-1.
				//nRandom = 7;
                if ( nRandom == PS_EFFECT_COUNT )
                {
                    //Get the visual effect
                    nVisual = ApplyPrismaticEffect( Random(PS_EFFECT_COUNT), oTarget);
                    nVisual2 = ApplyPrismaticEffect( Random(PS_EFFECT_COUNT), oTarget);
                }
                else
                {
                    //Get the visual effect
                    nVisual = ApplyPrismaticEffect(nRandom, oTarget);
                }
                //Set the visual effect
                if(nVisual != 0)
                {
                    eVisual = EffectVisualEffect(nVisual);
                    //Apply the visual effect
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget));
                }
                if(nVisual2 != 0)
                {
                    eVisual = EffectVisualEffect(nVisual2);
                    //Apply the visual effect
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget));
                }
            }
        }
        //Get next target in the spell area
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 11.0, GetSpellTargetLocation());
	}
	// Apply Cone visual fx
	fMaxDelay += 0.5f;
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCone, OBJECT_SELF, fMaxDelay);
}

///////////////////////////////////////////////////////////////////////////////
//  ApplyPrismaticEffect
///////////////////////////////////////////////////////////////////////////////
/*  Given a reference integer and a target, this function will apply the effect
    of corresponding prismatic cone to the target.  To have any effect the
    reference integer (nEffect) must be from 1 to 7.*/
///////////////////////////////////////////////////////////////////////////////
//  Created By: Aidan Scanlan On: April 11, 2001
///////////////////////////////////////////////////////////////////////////////

int ApplyPrismaticEffect(int nEffect, object oTarget)
{

    effect 	ePrism;
    effect 	eVis;
    effect 	eDur 	= EffectVisualEffect( VFX_DUR_SPELL_PRISMATIC_SPRAY );
    effect	eLink;
    int 	nDamage = 0;
    int 	nVis 	= 0;
     float 	fDelay	= GetDelayForTarget( oTarget );

    //Based on the random number passed in, apply the appropriate effect and set the visual to
    //the correct constant
    switch(nEffect)
    {
        case PS_EFFECT_FIRE://fire
			{
	            nDamage = 20;
	            nVis = VFX_HIT_SPELL_FIRE;
	            nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(),SAVING_THROW_TYPE_FIRE);
	            ePrism = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
	            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, ePrism, oTarget));
			}
        break;

        case PS_EFFECT_ACID: //Acid
			{
	            nDamage = 40;
	            nVis = VFX_HIT_SPELL_ACID;
	            nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(),SAVING_THROW_TYPE_ACID);
	            ePrism = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
	            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, ePrism, oTarget));
			}
        break;

        case PS_EFFECT_ELECTRICITY: //Electricity
			{
	            nDamage = 80;
	            nVis = VFX_HIT_SPELL_LIGHTNING;
	            nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(),SAVING_THROW_TYPE_ELECTRICITY);
	            ePrism = EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL);
	            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, ePrism, oTarget));
			}
        break;

        case PS_EFFECT_POISON: //Poison
            {
                effect ePoison = EffectPoison(POISON_BEBILITH_VENOM);
				nVis = VFX_HIT_SPELL_POISON;
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, ePoison, oTarget));
            }
        break;

        case PS_EFFECT_PARALYZE: //Paralyze
            {
				nVis = VFX_HIT_SPELL_ENCHANTMENT;
                effect eDur2 = EffectVisualEffect(VFX_DUR_PARALYZED);
				int nSaveDC = GetSpellSaveDC();
                if (MySavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC) == 0)
                {
                    ePrism = EffectParalyze(nSaveDC, SAVING_THROW_FORT);
                    eLink = EffectLinkEffects(eDur2, ePrism);
//                    eLink = EffectLinkEffects(eLink, eDur2);
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(10)));
                }
            }
        break;

        case PS_EFFECT_CONFUSION: //Confusion
            {
                effect eDur = EffectVisualEffect( VFX_DUR_SPELL_CONFUSION );
                ePrism = EffectConfused();
                eLink = EffectLinkEffects(eDur, ePrism);
                //eLink = EffectLinkEffects(eLink, eDur);

                if (!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, fDelay))
                {
                    //nVis = VFX_HIT_SPELL_ENCHANTMENT;
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(10)));
                }
            }
        break;

        case PS_EFFECT_DEATH: //Death
            {
                if (!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_DEATH, OBJECT_SELF, fDelay))
                {
                    nVis = VFX_HIT_SPELL_NECROMANCY;
                    ePrism = EffectDeath();
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, ePrism, oTarget));
                }
            }
        break;

		case PS_EFFECT_STONE: // Flesh to Stone 
			{
                //if (!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_DEATH, OBJECT_SELF, fDelay))
                {
					//nVis = VFX_HIT_SPELL_TRANSMUTATION;
				    //object oTarget = GetSpellTargetObject();
				    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
				
				    //if (MyResistSpell(OBJECT_SELF,oTarget) <1)
				    {
				    	DelayCommand(fDelay, DoPetrification(nCasterLvl, OBJECT_SELF, oTarget, GetSpellId(), GetSpellSaveDC()) );
					}
				}
			}
    }
    return nVis;
}