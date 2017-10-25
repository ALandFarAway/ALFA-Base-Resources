//::///////////////////////////////////////////////
//:: Scorching Ray
//:: [NX1_S0_scorchingray.nss]
//:: Copyright (c) 2007 Obsidian Ent.
//:://////////////////////////////////////////////
//:: Target must make a Fort save or take ability
//:: damage to Strength equaling 1d6 +1 per 2 levels,
//:: to a maximum of +5.  Duration of 1 round per
//:: caster level.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 2, 2001
//:://////////////////////////////////////////////

// (Updated JLR - OEI 07/05/05 NWN2 3.5)
//:: AFW-OEI 06/06/2006:
//::	Ray spells require a ranged touch attack.

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
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
    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
	effect eRay;
	
	int nNumRays = 0;
	if (nCasterLvl >= 11)
		nNumRays = 3;			// 3 Rays @ lvl 11
	else if (nCasterLvl >= 7)
		nNumRays = 2;			// 2 Rays @ lvl 7
	else if (nCasterLvl >= 3)
		nNumRays = 1;			// 1 Ray  @ lvl 3
		
	if (nNumRays == 0)
		return;
	
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {
		int ni=0;
		float fDelay = 2.5;
		
		effect eFire = EffectNWN2SpecialEffectFile("fx_ignition");
		//ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFire, oTarget, fDelay+(nNumRays-1));
		
		while (ni<nNumRays) {
			
	        //Fire cast spell at event for the specified target
	        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
	 
			// Ray spells require a ranged touch attack
			//if (TouchAttackRanged(oTarget) != TOUCH_ATTACK_RESULT_MISS) 
			if (FALSE)
			{	//Make SR check
	        	if (!MyResistSpell(OBJECT_SELF, oTarget))
	        	{	
					int nDamage = d6(4);
				
					//Enter Metamagic conditions
	    			int nMetaMagic = GetMetaMagicFeat();
	                if (nMetaMagic == METAMAGIC_MAXIMIZE)
	                {
	                    nDamage = 6*4;
	                }
	                if (nMetaMagic == METAMAGIC_EMPOWER)
	                {
	                     nDamage = nDamage + (nDamage/2);
	                }
					
	                //Set ability damage effect
	                effect eFireDamage = EffectDamage(nDamage, DAMAGE_TYPE_FIRE, DAMAGE_POWER_NORMAL, FALSE);
	  			    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_FIRE);
	                effect eLink = EffectLinkEffects(eFireDamage, eVis);
					eRay = EffectBeam(VFX_BEAM_FIRE, OBJECT_SELF, BODY_NODE_HAND);
	
	                //Apply the ability damage effect and VFX impact
	                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));
				}
	        }
			else {
				eRay = EffectBeam(VFX_BEAM_FIRE, OBJECT_SELF, BODY_NODE_HAND);		// ,FALSE for miss ray (that doesn't work)
				
				SpeakString("I missed!" + FloatToString(IntToFloat(Random(501))/100.0));
				effect eVis = EffectVisualEffect(VFX_HIT_SPELL_FIRE);
				location lMiss = Location(GetArea(oTarget), GetPosition(oTarget)+Vector(0.0, 0.0, 5.0), 0.0);	// above head
		        DelayCommand(fDelay, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lMiss));				// explosion
		   		DelayCommand((fDelay-0.5), ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eRay, lMiss, 0.5));	// missed beam that doesn't work
		   		DelayCommand((fDelay-0.5), ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 0.5));	// nails him in the chest
				object oMiss = CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", lMiss);
				DelayCommand((fDelay-0.5), ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oMiss, 0.5));
			}
			DelayCommand((fDelay-0.5), ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 0.5));
						
			ni++;
			fDelay = fDelay + 1.0;
		}
    }
}