//::///////////////////////////////////////////////
//:: Shadow Acid Fog: On Enter
//:: acr_S0_Shadow_AcidFoga.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All creatures within the AoE take 2d6 acid damage
    per round and upon entering if they fail a Fort Save
    their movement is halved.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////
//:: RPGplayer1 08/29/2008: Will ignore SR check, in case of Acid Bomb (won't work otherwise)

#include "X0_I0_SPELLS"
#include "acr_spells_i"

void main()
{

    //Declare major variables
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ACID);
    effect eSlow = EffectMovementSpeedDecrease(50);
    object oTarget = GetEnteringObject();
    float fDelay = GetRandomDelay(1.0, 2.2);
	SetLocalInt(OBJECT_SELF, "ACR_SHADOW_BELIEVE_" + ObjectToString(GetAreaOfEffectCreator()), 1);

    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
    {
        //Fire cast spell at event for the target
        SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELL_ACID_FOG));
        //Spell resistance check
        if(!MyResistSpell(GetAreaOfEffectCreator(), oTarget, fDelay))
        {
			//Belief check
			if(!GetLocalInt(OBJECT_SELF, "ACR_SHADOW_BELIEVE_" + ObjectToString(oTarget)))
			{
				//Will save vs. disbelief
				if(!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE, OBJECT_SELF))
				{
            		//Roll Damage
            		//Enter Metamagic conditions
            		nDamage = d6(4);
            		if (nMetaMagic == METAMAGIC_MAXIMIZE)
            		{
            		    nDamage = 24;//Damage is at max
            		}
            		else if (nMetaMagic == METAMAGIC_EMPOWER)
           			{
            			nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
           			}
            		//Make a Fortitude Save to avoid the effects of the movement hit.
            		if(!MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_ACID, GetAreaOfEffectCreator(), fDelay))
            		{
            		    //slowing effect
            		    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSlow, oTarget);
            		}

            		//Set Damage Effect with the modified damage
            		eDam = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
            		//Apply damage and visuals
            		DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
           			DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
				}
				else
				{
					SetLocalInt(OBJECT_SELF, "ACR_SHADOW_BELIEVE_" + ObjectToString(oTarget), 1);
					//Roll Damage
            		//Enter Metamagic conditions
            		nDamage = d6(4);
            		if (nMetaMagic == METAMAGIC_MAXIMIZE)
            		{
            		    nDamage = 24;//Damage is at max
            		}
            		else if (nMetaMagic == METAMAGIC_EMPOWER)
           			{
            			nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
           			}
					
					//Disbelieved conjuration effects are still 60% likely to occur.
					if(d100() <= 60)
					{
            			//Make a Fortitude Save to avoid the effects of the movement hit.
            			if(!MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_ACID, GetAreaOfEffectCreator(), fDelay))
            			{
            		    	//slowing effect
            		    	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSlow, oTarget);
            			}
					}
					
					//Reduce for disbelief
					nDamage = (nDamage*3)/5;
					
            		//Set Damage Effect with the modified damage
            		eDam = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
            		//Apply damage and visuals
            		DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
           			DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
				}
			}
			else
			{
				//Roll Damage
            	//Enter Metamagic conditions
            	nDamage = d6(4);
            	if (nMetaMagic == METAMAGIC_MAXIMIZE)
            	{
            	    nDamage = 24;//Damage is at max
            	}
            	else if (nMetaMagic == METAMAGIC_EMPOWER)
           		{
            		nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
           		}
					
				//Disbelieved conjuration effects are still 60% likely to occur.
				if(d100() <= 60)
				{
            		//Make a Fortitude Save to avoid the effects of the movement hit.
            		if(!MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_ACID, GetAreaOfEffectCreator(), fDelay))
            		{
            	    	//slowing effect
            	    	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSlow, oTarget);
            		}
				}
					
				//Reduce for disbelief
				nDamage = (nDamage*3)/5;
					
            	//Set Damage Effect with the modified damage
            	eDam = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
            	//Apply damage and visuals
            	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
           		DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
			}
        }
    }
}