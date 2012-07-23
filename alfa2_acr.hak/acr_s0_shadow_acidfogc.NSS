//::///////////////////////////////////////////////
//:: Shadow Acid Fog: Heartbeat
//:: acr_S0_Shadow_AcidFogc.nss
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
    int nDamage = d6(2);
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ACID);
    object oTarget;
    float fDelay;
	SetLocalInt(OBJECT_SELF, "ACR_SHADOW_BELIEVE_" + ObjectToString(GetAreaOfEffectCreator()), 1);

   //--------------------------------------------------------------------------
    // GZ 2003-Oct-15
    // When the caster is no longer there, all functions calling
    // GetAreaOfEffectCreator will fail. Its better to remove the barrier then
    //--------------------------------------------------------------------------
    if (!GetIsObjectValid(GetAreaOfEffectCreator()))
    {
        DestroyObject(OBJECT_SELF);
        return;
    }


    //Start cycling through the AOE Object for viable targets including doors and placable objects.
    oTarget = GetFirstInPersistentObject(OBJECT_SELF);
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
        {
            /*if(!MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_ACID, GetAreaOfEffectCreator(), fDelay))
            {
                 nDamage = d6();
            }*/

            nDamage = d6(2);

        	//Enter Metamagic conditions
        	if (nMetaMagic == METAMAGIC_MAXIMIZE)
        	{
        	    nDamage = 12;//Damage is at max
        	}
        	if (nMetaMagic == METAMAGIC_EMPOWER)
        	{
        	    nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
        	}

            fDelay = GetRandomDelay(0.4, 1.2);
            //Fire cast spell at event for the affected target
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
						//Set the damage effect
        				eDam = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
						eDam = EffectLinkEffects(eVis, eDam);
						//Apply damage and visuals
						ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
					}
					else
					{
						SetLocalInt(OBJECT_SELF, "ACR_SHADOW_BELIEVE_" + ObjectToString(oTarget), 1);
						//Reduce for disbelief
						nDamage = (nDamage*3)/5;
						
						//Set the damage effect
        				eDam = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
						eDam = EffectLinkEffects(eVis, eDam);
						//Apply damage and visuals
						ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
					}
            	}
				else
				{
					//Reduce for disbelief
					nDamage = (nDamage*3)/5;
						
					//Set the damage effect
        			eDam = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
					eDam = EffectLinkEffects(eVis, eDam);
					//Apply damage and visuals
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
				}
        	}
		}
        //Get next target.
        oTarget = GetNextInPersistentObject(OBJECT_SELF);
    }
}