//::///////////////////////////////////////////////
//:: Shadow Stinking Cloud
//:: acr_S0_Shadow_StinkCldC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Those within the area of effect must make a
    fortitude save or be dazed.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "acr_spells_i"

void main()
{


    //Declare major variables
    effect eStink = EffectDazed();
    effect eMind = EffectVisualEffect( VFX_DUR_SPELL_DAZE );
    //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eMind, eStink);
    //eLink = EffectLinkEffects(eLink, eDur);
	SetLocalInt(OBJECT_SELF, "ACR_SHADOW_BELIEVE_" + ObjectToString(GetAreaOfEffectCreator()), 1);
    //effect eVis = EffectVisualEffect(VFX_IMP_DAZED_S);
    effect eFind;
    object oTarget;
    object oCreator;
    float fDelay;
	
			int nDC = GetSpellSaveDC();
			if (nDC >= 100)
			{
				nDC = GetLocalInt(GetAreaOfEffectCreator(), "DC171");
				if (nDC == 0)
					nDC = 16;
			}		
	
    //Get the first object in the persistant area
    oTarget = GetFirstInPersistentObject();
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_STINKING_CLOUD));
            {
				if(!MyResistSpell(GetAreaOfEffectCreator(), oTarget) && !GetLocalInt(OBJECT_SELF, "ACR_SHADOW_BELIEVE_" + ObjectToString(oTarget)))
				{
					//Will Save vs. Disbelief
					if(!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE, OBJECT_SELF))
					{
                		//Make a Fort Save
                		if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_POISON))
                		{
                   			fDelay = GetRandomDelay(0.75, 1.75);
                   			//Apply the VFX impact and linked effects
                   			if (GetIsImmune(oTarget, IMMUNITY_TYPE_POISON) == FALSE)
                   			{
                     			DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(2)));
                   			}
                		}
                		else
                		{
                    		//If the Fort save was successful remove the Dazed effect
                    		eFind = GetFirstEffect(oTarget);
                    		while (GetIsEffectValid(eFind))
                    		{
                        		if(eFind == EffectDazed())
                        		{
                            		oCreator = GetEffectCreator(eFind);
                            		if(oCreator == GetAreaOfEffectCreator())
                            		{
                                		RemoveEffect(oTarget, eFind);
                            		}
                        		}
                        	eFind = GetNextEffect(oTarget);
                    		}
                		}
					}
					else
					{
						SetLocalInt(OBJECT_SELF, "ACR_SHADOW_BELIEVE_" + ObjectToString(oTarget), 1);
						//Disbelieved conjuration effects are still 20% likely to occur.
						if(d100() <= 20)
						{
							//Make a Fort Save
                			if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_POISON))
                			{
                   				fDelay = GetRandomDelay(0.75, 1.75);
                   				//Apply the VFX impact and linked effects
                   				if (GetIsImmune(oTarget, IMMUNITY_TYPE_POISON) == FALSE)
                   				{
                     				DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(2)));
                   				}
                			}
							else
                			{
                    			//If the Fort save was successful remove the Dazed effect
                    			eFind = GetFirstEffect(oTarget);
                    			while (GetIsEffectValid(eFind))
                    			{
                        			if(eFind == EffectDazed())
                        			{
                            			oCreator = GetEffectCreator(eFind);
                            			if(oCreator == GetAreaOfEffectCreator())
                            			{
                                			RemoveEffect(oTarget, eFind);
                            			}
                        			}
                        		eFind = GetNextEffect(oTarget);
                    			}
                			}
						}
						else
						{
							//If the Will save was successful remove the Dazed effect
    	                	eFind = GetFirstEffect(oTarget);
        	            	while (GetIsEffectValid(eFind))
            	        	{
                	        	if(eFind == EffectDazed())
                    	    	{
                        	    	oCreator = GetEffectCreator(eFind);
                            		if(oCreator == GetAreaOfEffectCreator())
                            		{
                                		RemoveEffect(oTarget, eFind);
                            		}
                        		}
                        		eFind = GetNextEffect(oTarget);
                    		}
						}
					}
				}
            }
        }
        //Get next target in spell area
        oTarget = GetNextInPersistentObject();
    }
}