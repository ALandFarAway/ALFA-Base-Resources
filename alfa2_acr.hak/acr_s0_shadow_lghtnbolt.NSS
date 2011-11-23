//::///////////////////////////////////////////////
//:: Shadow Lightning Bolt
//:: acr_S0_Shadow_LightnBolt
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does 1d6 per level in a 5ft tube for 30m
*/
//:://////////////////////////////////////////////
//:: Created By: Noel Borstad
//:: Created On:  March 8, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: May 2, 2001

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 
#include "ginc_debug"

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
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    //Limit caster level
    if (nCasterLevel > 10)
    {
        nCasterLevel = 10;
    }
    int nDamage;
    int nMetaMagic = GetMetaMagicFeat();
    //Set the lightning stream to start at the caster's hands
    effect eLightning = EffectBeam(VFX_BEAM_LIGHTNING, OBJECT_SELF, BODY_NODE_HAND);
    effect eVis  = EffectVisualEffect(VFX_HIT_SPELL_LIGHTNING);
    effect eDamage;
    object oTarget = GetSpellTargetObject();
    location lTarget = GetLocation(oTarget);
	location lTarget2 = GetSpellTargetLocation();
	
	//string sTarget2 = "wp_lbolttrgt2";
    object oNextTarget, oTarget2;
    float fDelay;
    int nCnt = 1;
	
	// If you target a location, this will spawn in an invisible creature to act as the endpoint on the beam, then delete itself
	object oPoint = CreateObject(OBJECT_TYPE_CREATURE, "c_attachspellnode" , lTarget2);
	SetScriptHidden(oPoint, TRUE);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLightning, oPoint, 1.0);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPoint);
	DestroyObject(oPoint, 2.0);
	
	//CreateObject(OBJECT_TYPE_WAYPOINT, sTarget2, lTarget2);
	//object oPoint = GetObjectByTag(sTarget2);
	//ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLightning, oPoint, 1.0);
	//PrettyDebug("Lightning bolt!  Woo Hoo!");
    oTarget2 = GetNearestObject(OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, OBJECT_SELF, nCnt);
    while(GetIsObjectValid(oTarget2) && GetDistanceToObject(oTarget2) <= 30.0)
    {
        //Get first target in the lightning area by passing in the location of first target and the casters vector (position)
        oTarget = GetFirstObjectInShape(SHAPE_SPELLCYLINDER, 30.0, lTarget2, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF));
		//PrettyDebug("investigating target " + GetName(oTarget));
         while (GetIsObjectValid(oTarget))
        {
           //Exclude the caster from the damage effects
           if (oTarget != OBJECT_SELF && oTarget2 == oTarget)
           {
                if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
            	{
                   //Fire cast spell at event for the specified target
					//PrettyDebug("Signaling Lightning Bolt on " + GetName(oTarget));
                   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_LIGHTNING_BOLT));
                   //Make an SR check
                   if (!MyResistSpell(OBJECT_SELF, oTarget))
        	       {
				   		//Make Will save to disbelieve
                    	if(!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE))
                    	{
                        	//Roll damage
                       		nDamage =  d6(nCasterLevel);
        		        	//Enter Metamagic conditions
        		        	if (nMetaMagic == METAMAGIC_MAXIMIZE)
        		        	{
        			    	     nDamage = 6 * nCasterLevel;//Damage is at max
                        	}
        		        	if (nMetaMagic == METAMAGIC_EMPOWER)
        		        	{
        			    	     nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
                        	}
                        	//Adjust damage based on Reflex Save, Evasion and Improved Evasion
                        	nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(),SAVING_THROW_TYPE_ELECTRICITY);
                        	//Set damage effect
                        	eDamage = EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL);
                        	if(nDamage > 0)
                        	{
                            	fDelay = GetSpellEffectDelay(GetLocation(oTarget), oTarget);
                            	//Apply VFX impcat, damage effect and lightning effect
                            	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget));
                            	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget));
                        	}
						}
						else
						{
						    //Roll damage
                       		nDamage =  d6(nCasterLevel);
        		        	//Enter Metamagic conditions
        		        	if (nMetaMagic == METAMAGIC_MAXIMIZE)
        		        	{
        			    	     nDamage = 6 * nCasterLevel;//Damage is at max
                        	}
        		        	if (nMetaMagic == METAMAGIC_EMPOWER)
        		        	{
        			    	     nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
                        	}
                        	//Adjust damage based on Reflex Save, Evasion and Improved Evasion
                        	nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(),SAVING_THROW_TYPE_ELECTRICITY);
                        	//Reduce for disbelief
							nDamage = nDamage/5;
							//Set damage effect
                        	eDamage = EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL);
                        	if(nDamage > 0)
                        	{
                            	fDelay = GetSpellEffectDelay(GetLocation(oTarget), oTarget);
                            	//Apply VFX impcat, damage effect and lightning effect
                            	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget));
                            	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget));
                        	}
						}
                    }
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLightning,oTarget,1.0);
                    //Set the currect target as the holder of the lightning effect
                    oNextTarget = oTarget;
                    eLightning = EffectBeam(VFX_BEAM_LIGHTNING, oNextTarget, BODY_NODE_CHEST);
                }
           }
           //Get the next object in the lightning cylinder
           oTarget = GetNextObjectInShape(SHAPE_SPELLCYLINDER, 30.0, lTarget2, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF));
        }
        nCnt++;
        oTarget2 = GetNearestObject(OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, OBJECT_SELF, nCnt);
    }
}