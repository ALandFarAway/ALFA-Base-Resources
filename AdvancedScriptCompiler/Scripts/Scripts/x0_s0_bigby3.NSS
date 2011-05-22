//::///////////////////////////////////////////////
//:: Bigby's Grasping Hand
//:: [x0_s0_bigby3]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    make an attack roll. If succesful target is held for 1 round/level


*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 7, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By: PKM-OEI 08.09.06
//:: PKM-OEI- 08.18.06 - Old spell commented out, new spell based on bigby 5
//:: AFW-OEI 07/23/2007: Apply paralysis effect icon while you're grappled.


#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "x2_i0_spells"
#include "nwn2_inc_spells"

int nSpellID = GetSpellId();	// 11/09/06 - BDF(OEI): let's use GetSpellID() instead
int RunGrappleHit( object oTarget );
void RunGrappleHold( object oTarget, int nDuration );

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

    object oTarget = GetSpellTargetObject();

    //--------------------------------------------------------------------------
    // This spell no longer stacks. If there is one hand, that's enough
    //--------------------------------------------------------------------------
    //if (GetHasSpellEffect(nSpellID,oTarget) ||  GetHasSpellEffect(461,oTarget)  )
    if (GetHasSpellEffect(nSpellID,oTarget) ||  GetHasSpellEffect(463,oTarget)  )
    {
        FloatingTextStrRefOnCreature(100775,OBJECT_SELF,FALSE);
        return;
    }

    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();

    //Check for metamagic extend
    if (nMetaMagic == METAMAGIC_EXTEND) //Duration is +100%
    {
         nDuration = nDuration * 2;
    }

    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellID, TRUE));

        //SR
        if(!MyResistSpell(OBJECT_SELF, oTarget))
        {
            // * grapple HIT succesful,
            if (RunGrappleHit( oTarget ))
            {			
				effect eHold = EffectVisualEffect( VFX_DUR_PARALYZED );	
				float fDuration = RoundsToSeconds( nDuration );
        		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHold, oTarget, fDuration);
                //RunGrappleHold( oTarget, nDuration );
				int i;
				for ( i = 0; i <= nDuration; i++ )
				{
					if ( !GetIsDead(OBJECT_SELF) && GetArea(oTarget) == GetArea(OBJECT_SELF) )
					{
						DelayCommand( RoundsToSeconds(i), RunGrappleHold(oTarget, nDuration) );
					}
				}
            }
        }
    }
}



int RunGrappleHit( object oTarget )
{
	int nCasterModifier = GetCasterAbilityModifier(OBJECT_SELF);
    int nCasterRoll = d20(1)
    	+ nCasterModifier
    	+ GetCasterLevel(OBJECT_SELF) + 10 + -1;

    int nTargetRoll = GetAC(oTarget);

    // * grapple HIT succesful,
    if (nCasterRoll >= nTargetRoll)
    {
		return TRUE;
	}
	return FALSE;
}

void RunGrappleHold( object oTarget, int nDuration )
{

    //--------------------------------------------------------------------------
    // Check if the spell has expired (check also removes effects)
    //--------------------------------------------------------------------------
	//int nSpellID = 461;
	object oCaster = OBJECT_SELF;
    if (GZGetDelayedSpellEffectsExpired(nSpellID,oTarget,oCaster))
    {
        return;
    }
	
	int nCasterRoll;
	int nTargetRoll;
	int nCasterModifier = GetCasterAbilityModifier(OBJECT_SELF);
	
     nCasterRoll = d20(1) + nCasterModifier
    	+ GetCasterLevel(OBJECT_SELF) + 10 +4;

    nTargetRoll = d20(1)
	    + GetBaseAttackBonus(oTarget)
    	+ GetSizeModifier(oTarget)
        + GetAbilityModifier(ABILITY_STRENGTH, oTarget);

    if (HasSizeIncreasingSpellEffect(oTarget) || GetHasSpellEffect(803, oTarget))
        nTargetRoll = nTargetRoll + 4;

    if (nCasterRoll >= nTargetRoll)
	{    
		//effect eKnockdown = EffectParalyze();
		effect eKnockdown = EffectCutsceneImmobilize();
		effect eIcon	  = EffectEffectIcon(16);	// Paralyze
			   eKnockdown = EffectLinkEffects(eKnockdown, eIcon);
        
		/* //We no longer need this check, EffectCutsceneImmobilize will handle it all
		// creatures immune to paralzation are still prevented from moving
        if (GetIsImmune(oTarget, IMMUNITY_TYPE_PARALYSIS) ||
        GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS))
        {
        	eKnockdown = EffectCutsceneImmobilize();
        }*/

        effect eHand = EffectVisualEffect(VFX_DUR_BIGBYS_GRASPING_HAND);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, 6.0 );
		ApplyEffectToObject( DURATION_TYPE_INSTANT, eHand, oTarget );

        object oSelf = OBJECT_SELF;
		FloatingTextStrRefOnCreature(2478, OBJECT_SELF);
	}	
	else
    {
    	FloatingTextStrRefOnCreature(83309, OBJECT_SELF);
    }
}









/*#include "x0_i0_spells"

#include "x2_inc_spellhook"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more



    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    effect eVis = EffectVisualEffect( VFX_DUR_PARALYZED );

    //Check for metamagic extend
    if (nMetaMagic == METAMAGIC_EXTEND) //Duration is +100%
    {
         nDuration = nDuration * 2;
    }

    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 461, TRUE));

        // Check spell resistance
        if(!MyResistSpell(OBJECT_SELF, oTarget))
        {
            // Check caster ability vs. target's AC

            int nCasterModifier = GetCasterAbilityModifier(OBJECT_SELF);
            int nCasterRoll = d20(1)
                + nCasterModifier
                + GetCasterLevel(OBJECT_SELF) + 10 + -1;

            int nTargetRoll = GetAC(oTarget);

            // * grapple HIT succesful,
            if (nCasterRoll >= nTargetRoll)
            {
                // * now must make a GRAPPLE check to
                // * hold target for duration of spell
                // * check caster ability vs. target's size & strength
                nCasterRoll = d20(1) + nCasterModifier
                    + GetCasterLevel(OBJECT_SELF) + 10 +4;

                nTargetRoll = d20(1)
                             + GetBaseAttackBonus(oTarget)
                             + GetSizeModifier(oTarget)
                             + GetAbilityModifier(ABILITY_STRENGTH, oTarget);

                if (nCasterRoll >= nTargetRoll)
                {
                    // Hold the target paralyzed
                    effect eKnockdown = EffectParalyze();

                    // creatures immune to paralzation are still prevented from moving
                    if (GetIsImmune(oTarget, IMMUNITY_TYPE_PARALYSIS) ||
                        GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS))
                    {
                        eKnockdown = EffectCutsceneImmobilize();
                    }

                    //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE); //NWN1 VFX
                    effect eHand = EffectVisualEffect(VFX_DUR_BIGBYS_GRASPING_HAND);
                    //effect eLink = EffectLinkEffects(eKnockdown, eDur);
                    //eLink = EffectLinkEffects(eHand, eLink);
                    //eLink = EffectLinkEffects(eVis, eLink);
					effect eLink = EffectLinkEffects( eKnockdown, eHand );
					eLink = EffectLinkEffects( eLink, eVis );

                    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds( nDuration ) );

//                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
//                                        eVis, oTarget,RoundsToSeconds(nDuration));
                    FloatingTextStrRefOnCreature(2478, OBJECT_SELF);
                }
                else
                {
                    FloatingTextStrRefOnCreature(83309, OBJECT_SELF);
                }
            }
        }
    }
}
*/