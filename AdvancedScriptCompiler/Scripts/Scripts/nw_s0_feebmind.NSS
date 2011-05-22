//::///////////////////////////////////////////////
//:: Feeblemind
//:: [NW_S0_FeebMind.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Target must make a Will save or take ability
//:: damage to Intelligence equaling 1d4 per 4 levels.
//:: Duration of 1 rounds per 2 levels.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 2, 2001
//:://////////////////////////////////////////////


// (Update JLR - OEI 07/22/05) -- Added Charisma Loss


#include "x0_I0_SPELLS"    
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
    object oTarget = GetSpellTargetObject();
    int nDuration = GetCasterLevel(OBJECT_SELF)/2;
    int nDice = GetCasterLevel(OBJECT_SELF)/4;
    //Check to make at least 1d4 damage is done
    if (nDice < 1)
    {
        nDice = 1;
    }
    int nLoss = d4(nDice);
    //Check to make sure the duration is 1 or greater
    if (nDuration < 1)
    {
        nDuration == 1;
    }
    int nMetaMagic = GetMetaMagicFeat();
    effect eFeeb;
    effect eVis = EffectVisualEffect(VFX_DUR_SPELL_FEEBLEMIND);

	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FEEBLEMIND));
        //Make SR check
    	if (!MyResistSpell(OBJECT_SELF, oTarget))
    	{
            //Make an will save

            int nWillResult = WillSave(oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS);
            if (nWillResult == 0)
            {
     		     //Enter Metamagic conditions
    		      if (nMetaMagic == METAMAGIC_MAXIMIZE)
    		      {
    			     nLoss = nDice * 4;
    		      }
    		      if (nMetaMagic == METAMAGIC_EMPOWER)
    		      {
                     nLoss = nLoss + (nLoss/2);
    		      }
    		      if (nMetaMagic == METAMAGIC_EXTEND)
                  {
                     nDuration = nDuration * 2;
    		      }
                  //Set the ability damage
                  eFeeb = EffectAbilityDecrease(ABILITY_INTELLIGENCE, nLoss);
                  effect eFeeb2 = EffectAbilityDecrease(ABILITY_CHARISMA, nLoss);	// JLR - OEI 07/22/05
                  effect eLink = EffectLinkEffects(eFeeb, eVis);
                  eLink = EffectLinkEffects(eLink, eFeeb2);

                  //Apply the VFX impact and ability damage effect.
                  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
                  //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
            else
            // * target was immune
            if (nWillResult == 2)
            {
                SpeakStringByStrRef(40105, TALKVOLUME_WHISPER);
            }
        }
    }
}