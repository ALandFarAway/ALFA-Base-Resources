//::///////////////////////////////////////////////
//:: Shadow Grease: Heartbeat
//:: acr_S0_Shadow_Greaseb.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creatures entering the zone of grease must make
    a reflex save or fall down.  Those that make
    their save have their movement reduced by 1/2.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 1, 2001
//:://////////////////////////////////////////////
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "acr_spells_i"

void main()
{


    //Declare major variables
    object oTarget;
	object Module = GetModule();
    effect eFall = EffectKnockdown();
	effect eHit = EffectVisualEffect(VFX_HIT_SPELL_ENCHANTMENT);
	effect eLink = EffectLinkEffects(eFall, eHit);
    float fDelay;
	int bValid = FALSE;
    effect eAOE;
	SetLocalInt(OBJECT_SELF, "ACR_SHADOW_BELIEVE_" + ObjectToString(GetAreaOfEffectCreator()), 1);
	//Secondary effects of slowing
	effect eVis2 = EffectVisualEffect(VFX_IMP_SLOW);
    effect eSlow2 = EffectMovementSpeedDecrease(50);
    effect eLink2 = EffectLinkEffects(eVis2, eSlow2);
	effect eHit2 = EffectVisualEffect(VFX_HIT_SPELL_ENCHANTMENT);
    //Get first target in spell area
    oTarget = GetFirstInPersistentObject();
    while(GetIsObjectValid(oTarget))
    {
       // if(!GetHasFeat(FEAT_WOODLAND_STRIDE, oTarget) &&(GetCreatureFlag(OBJECT_SELF, CREATURE_VAR_IS_INCORPOREAL) != TRUE) )
       if( (GetCreatureFlag(OBJECT_SELF, CREATURE_VAR_IS_INCORPOREAL) != TRUE) )	// AFW-OEI 05/01/2006: Woodland Stride no longer protects from spells.
       {
            if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
            {
                fDelay = GetRandomDelay(0.0, 2.0);
				if(!GetLocalInt(OBJECT_SELF, "ACR_SHADOW_BELIEVE_" + ObjectToString(oTarget)))
				{
					//Will save vs. disbelief
					if(!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE, OBJECT_SELF))
					{
                		if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay))
                		{
                    		DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 4.0));
                		}
					}
					else
					{
						SetLocalInt(OBJECT_SELF, "ACR_SHADOW_BELIEVE_" + ObjectToString(oTarget), 1);
						//Disbelieved conjuration effects are still 20% likely to occur.
						if(d100() <= 20)
						{
							//Apply reduced movement effect and VFX_Impact
                			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink2, oTarget);
                			ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit2, oTarget);
							//Make reflex save.
							if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay))
                			{
                    			DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 4.0));
                			}
						}
						else
						{
							if(GetHasSpellEffect(3027, oTarget))
    						{
        						//Search through the valid effects on the target.
        						eAOE = GetFirstEffect(oTarget);
        						while (GetIsEffectValid(eAOE) && bValid == FALSE)
        						{
            						if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            						{
                						if(GetEffectType(eAOE) == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE)
                						{
                    						//If the effect was created by the Acid_Fog then remove it
                    						if(GetEffectSpellId(eAOE) == 3027)
                    						{
                        						RemoveEffect(oTarget, eAOE);
                        						bValid = TRUE;
                    						}
                						}
            						}
            						//Get next effect on the target
            						eAOE = GetNextEffect(oTarget);
        						}
    						}
						}
					}
				}
				else
				{
					//Disbelieved conjuration effects are still 20% likely to occur.
					if(d100() <= 20)
					{
						//Apply reduced movement effect and VFX_Impact
                		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink2, oTarget);
                		ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit2, oTarget);
						//Make reflex save.
						if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay))
                		{
                    		DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 4.0));
                		}
					}
					else
					{
						if(GetHasSpellEffect(3027, oTarget))
    					{
        					//Search through the valid effects on the target.
        					eAOE = GetFirstEffect(oTarget);
        					while (GetIsEffectValid(eAOE) && bValid == FALSE)
        					{
            					if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            					{
                					if(GetEffectType(eAOE) == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE)
                					{
                    					//If the effect was created by the Acid_Fog then remove it
                    					if(GetEffectSpellId(eAOE) == 3027)
                    					{
                        					RemoveEffect(oTarget, eAOE);
                        					bValid = TRUE;
                    					}
                					}
            					}
            					//Get next effect on the target
            					eAOE = GetNextEffect(oTarget);
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