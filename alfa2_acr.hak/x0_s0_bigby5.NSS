//::///////////////////////////////////////////////
//:: Bigby's Crushing Hand
//:: [x0_s0_bigby5]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Similar to Bigby's Grasping Hand.
    If Grapple succesful then will hold the opponent and do 2d6 + 12 points
    of damage EACH round for 1 round/level


   // Mark B's famous advice:
   // Note:  if the target is dead during one of these second-long heartbeats,
   // the DelayCommand doesn't get run again, and the whole package goes away.
   // Do NOT attempt to put more than two parameters on the delay command.  They
   // may all end up on the stack, and that's all bad.  60 x 2 = 120.

*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 7, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By: PKM-OEI 08.09.06
//:: PKM-OEI 08.18.06 - Forced a grapple check each round for the duration
//:: AFW-OEI 07/23/2007: Apply paralysis effect icon while you're grappled.

#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "x2_i0_spells"
#include "nwn2_inc_spells"

int nSpellID = 463;
int RunGrappleHit( object oTarget );
void RunGrappleHold( object oTarget, int nDuration, int nMetaMagic );
void RunHandImpact( object oTarget, object oCaster, int nDuration, int nMetaMagic );

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
    if (GetHasSpellEffect(nSpellID,oTarget) ||  GetHasSpellEffect(461,oTarget)  )
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
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BIGBYS_CRUSHING_HAND, TRUE));

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
						DelayCommand( RoundsToSeconds(i), RunGrappleHold(oTarget, nDuration, nMetaMagic) );
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
        + GetCasterLevel(OBJECT_SELF) + 12 + -1;
    int nTargetRoll = GetAC(oTarget);

    // * grapple HIT succesful,
    if (nCasterRoll >= nTargetRoll)
    {
		return TRUE;
	}
	return FALSE;
}

void RunGrappleHold( object oTarget, int nDuration, int nMetaMagic )
{

    //--------------------------------------------------------------------------
    // Check if the spell has expired (check also removes effects)
    //--------------------------------------------------------------------------
	int nSpellID = 463;
	object oCaster = OBJECT_SELF;
    if (GZGetDelayedSpellEffectsExpired(nSpellID,oTarget,oCaster))
    {
        return;
    }
	
	int nCasterRoll;
	int nTargetRoll;
	int nCasterModifier = GetCasterAbilityModifier(OBJECT_SELF);
	
	nCasterRoll = d20(1) + nCasterModifier
    	+ GetCasterLevel(OBJECT_SELF) + 12 + 4;
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
        }
		*/

        effect eHand = EffectVisualEffect(VFX_DUR_BIGBYS_CRUSHING_HAND);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, 6.0 );
		ApplyEffectToObject( DURATION_TYPE_INSTANT, eHand, oTarget );

        object oSelf = OBJECT_SELF;
		DelayCommand( 0.8, RunHandImpact(oTarget, oSelf, nDuration, nMetaMagic));
        FloatingTextStrRefOnCreature(2478, OBJECT_SELF);
	}	
	else
    {
    	FloatingTextStrRefOnCreature(83309, OBJECT_SELF);
    }
}

void RunHandImpact(object oTarget, object oCaster, int nDuration, int nMetaMagic)
{

   	int nDam = MaximizeOrEmpower(6,2,nMetaMagic, 12);
   	effect eDam = EffectDamage(nDam, DAMAGE_TYPE_BLUDGEONING);
   	effect eVis = EffectVisualEffect( VFX_HIT_SPELL_EVOCATION );
   	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
   	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
 //	DelayCommand(6.0f,RunHandImpact(oTarget,oCaster, nDuration));

}