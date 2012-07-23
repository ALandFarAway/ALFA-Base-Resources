//::///////////////////////////////////////////////
//:: Shadow Evard's Black Tentacles: On Enter
//:: acr_S0_Shadow_Evardsa.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Upon entering the mass of rubbery tentacles the
    target is struck by 1d4 tentacles.  Each has
    a chance to hit of 5 + 1d20. If it succeeds then
    it does 1d6 damage and the target must make
    a Fortitude Save versus paralysis or be paralyzed
    for 1 round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: July 20, 2001
// Modified by NESchampion 2 Dec 2011

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "acr_spells_i"

void main()
{

    object oTarget = GetEnteringObject();
	int nSaveDC = GetSpellSaveDC();
    effect eParal = EffectParalyze(nSaveDC, SAVING_THROW_FORT);
    effect eDur = EffectVisualEffect(VFX_DUR_PARALYZED);
    effect eLink = EffectLinkEffects(eDur, eParal);
    effect eDam;
	
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    int nAC = GetAC(oTarget);
    int nHits = d4();
    int nRoll;
    float fDelay;
	SetLocalInt(OBJECT_SELF, "ACR_SHADOW_BELIEVE_" + ObjectToString(GetAreaOfEffectCreator()), 1);
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_EVARDS_BLACK_TENTACLES));
        for (nHits = d4(); nHits > 0; nHits--)
        {
		    //Spell resistance check
            if(!MyResistSpell(GetAreaOfEffectCreator(), oTarget))
            {
            	fDelay = GetRandomDelay(1.0, 2.2);
            	nRoll = 5 + d20();
            	if( ((nRoll >= nAC) || (nRoll == 25)) && (nRoll != 6) )
            	{
					//Belief check
					if(!GetLocalInt(OBJECT_SELF, "ACR_SHADOW_BELIEVE_" + ObjectToString(oTarget)))
					{
						//Will save vs. disbelief
						if(!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE, OBJECT_SELF))
						{
                			nDamage = d6() + 4;
                			//Enter Metamagic conditions
                			if (nMetaMagic == METAMAGIC_MAXIMIZE)
                			{
                			    nDamage = 6 + 4;//Damage is at max
                			}
                			else if (nMetaMagic == METAMAGIC_EMPOWER)
                			{
                			    nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
                			}
				
							eDam = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_PLUS_TWO);
	            			DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
	            			if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC, SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay))
	            			{
	            			    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1)));
	            			}
						}
						else
						{
							nDamage = d6() + 4;
                			//Enter Metamagic conditions
                			if (nMetaMagic == METAMAGIC_MAXIMIZE)
                			{
                			    nDamage = 6 + 4;//Damage is at max
                			}
                			else if (nMetaMagic == METAMAGIC_EMPOWER)
                			{
                			    nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
                			}
							//Reduce for disbelief
							nDamage = (nDamage*3)/5;
							eDam = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_PLUS_TWO);
	            			DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
							//Disbelieved conjuration effects are still 60% likely to occur.
							if(d100() <= 60)
							{
	            				if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC, SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay))
	            				{
	            			    	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1)));
	            				}
							}
						}
            		}
					else
					{
						nDamage = d6() + 4;
                		//Enter Metamagic conditions
                		if (nMetaMagic == METAMAGIC_MAXIMIZE)
                		{
                		    nDamage = 6 + 4;//Damage is at max
                		}
                		else if (nMetaMagic == METAMAGIC_EMPOWER)
                		{
                		    nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
                		}
						//Reduce for disbelief
						nDamage = (nDamage*3)/5;
						eDam = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_PLUS_TWO);
	            		DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
						//Disbelieved conjuration effects are still 60% likely to occur.
						if(d100() <= 60)
						{
	            			if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC, SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay))
	            			{
	            		    	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1)));
	            			}
						}
					}
				}
			}      
		}
	}
}