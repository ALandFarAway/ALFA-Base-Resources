//::///////////////////////////////////////////////
//:: Cloudkill: On Enter
//:: NW_S0_CloudKillA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All creatures with 3 or less HD die, those with
    4 to 6 HD must make a save Fortitude Save or die.
    Those with more than 6 HD take 1d4 CON damage
    every round. Fortitude saves for half.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////
//:: PKM-OEI 09.18.06: Modified to make closer to the PHB rules
//:: RPGplayer1 14/04/2008:
//::  Will stack CON damage (by setting SpellId to -1)
//::  CON damage changed to Extraordinary (to prevent dispelling)

#include "X0_I0_SPELLS"

void main()
{


    //Declare major variables
    object oTarget = GetEnteringObject();
    int nHD = GetHitDice(oTarget);
    effect eDeath = EffectDeath();
    effect eVis =   EffectVisualEffect(VFX_IMP_DEATH);
    //effect eNeg = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);	// NWN1 VFX
    effect eNeg = EffectVisualEffect( VFX_HIT_SPELL_POISON );	// NWN2 VFX
    //effect eSpeed = EffectMovementSpeedDecrease(50);
    //effect eVis2 = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);	// NWN1 VFX
    //effect eVis2 = EffectVisualEffect( VFX_IMP_SLOW );	// NWN2 VFX
    //effect eLink = EffectLinkEffects(eSpeed, eVis2);
	int nDC = GetSpellSaveDC();

    float fDelay= GetRandomDelay(0.5, 1.5);
    effect eDam;
    int nDam = d4();
    int nMetaMagic = GetMetaMagicFeat();

    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_MAXIMIZE)
    {
        nDam = 4;//Damage is at max
    }
    else if (nMetaMagic == METAMAGIC_EMPOWER)
    {
        nDam =  nDam + (nDam/2); //Damage/Healing is +50%
    }
    eDam = EffectAbilityDecrease(ABILITY_CONSTITUTION, nDam);
    eDam = SetEffectSpellId(eDam, -1);
    eDam = ExtraordinaryEffect(eDam);

    if(spellsIsTarget(oTarget,SPELL_TARGET_STANDARDHOSTILE , GetAreaOfEffectCreator()) )
    {
		if(GetIsImmune(oTarget, IMMUNITY_TYPE_POISON))
		{
			return;
		}
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CLOUDKILL));
        //Make SR Check
        if(!MyResistSpell(GetAreaOfEffectCreator(), oTarget, fDelay))
        {
            //Determine spell effect based on the targets HD
            if (nHD <= 3)
            {
                if(!GetIsImmune(oTarget, IMMUNITY_TYPE_DEATH))
                {
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
                }
            }
            else if (nHD >= 4 && nHD <= 6)
            {
                //Make a save or die
                if(!MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_DEATH, OBJECT_SELF, fDelay))
                {
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
                else
                {
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDam, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eNeg, oTarget));
                    /*if(!MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay))
                    {
                        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
                    }*/
                }
            }
            else
            {
				if (FortitudeSave(oTarget, nDC, SAVING_THROW_TYPE_POISON, OBJECT_SELF))
				{
					nDam = nDam/2;
					eDam = EffectAbilityDecrease(ABILITY_CONSTITUTION, nDam);
					eDam = SetEffectSpellId(eDam, -1);
					eDam = ExtraordinaryEffect(eDam);
					DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDam, oTarget));
                	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eNeg, oTarget));

				}
				else
				{	
                	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDam, oTarget));
                	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eNeg, oTarget));
                	//ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
				}
            }
        }
    }
}