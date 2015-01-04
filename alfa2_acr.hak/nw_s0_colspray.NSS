//::///////////////////////////////////////////////
//:: Color Spray
//:: NW_S0_ColSpray.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    A cone of sparkling lights flashes out in a cone
    from the casters hands affecting all those within
    the Area of Effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 25, 2001
//:://////////////////////////////////////////////
//:: RPGplayer1 03/19/2008: Caster won't trigger spell resistance check
//:: RPGplayer1 04/04/2008: Those immune to mind effects won't get blindness

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 

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
    int nMetaMagic = GetMetaMagicFeat();
    int nHD;
    int nDuration;
    float fDelay;
	float fMaxDelay = 0.0f; // Used to determine length of spell cone
    object oTarget;
    effect eSleep = EffectSleep();
    effect eStun = EffectStunned();
    effect eBlind = EffectBlindness();
	effect eCone = EffectVisualEffect(VFX_DUR_CONE_COLORSPRAY);

    effect eLink2 = EffectLinkEffects(eStun, eSleep);

    effect eLink3 = EffectLinkEffects(eBlind, eSleep);

	effect eHit = EffectVisualEffect(VFX_HIT_SPELL_ILLUSION);

    //Get first object in the spell cone
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, GetSpellTargetLocation(), TRUE);
    //Cycle through the target until the current object is invalid
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    	{
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_COLOR_SPRAY));
            fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/30;
			if (fDelay > fMaxDelay)
			{
				fMaxDelay = fDelay;
			}
			
            //if(!MyResistSpell(OBJECT_SELF, oTarget, fDelay) && oTarget != OBJECT_SELF)
            if(oTarget != OBJECT_SELF && !MyResistSpell(OBJECT_SELF, oTarget, fDelay)) //FIX: prevents caster from getting SR check against himself
            {
                if(!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, fDelay))
                {
                      nDuration = 3 + d4();
                      //Enter Metamagic conditions
    		          if (nMetaMagic == METAMAGIC_MAXIMIZE)
    		          {
    			         nDuration = 7;//Damage is at max
    		          }
    		          else if (nMetaMagic == METAMAGIC_EMPOWER)
    		          {
    			         nDuration = nDuration + (nDuration/2); //Damage/Healing is +50%
    		          }
    		          else if (nMetaMagic == METAMAGIC_EXTEND)
    		          {
    			         nDuration = nDuration *2;	//Duration is +100%
    		          }
					
					DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget));
                    nHD = GetHitDice(oTarget);
                    if(nHD <= 2)
                    {
                         //Apply the VFX impact and effects
                         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSleep, oTarget, RoundsToSeconds(nDuration)));
                    }
                    //FIX: prevents blindness from being applied if immune to mind effects
                    // in that case, it's ok to apply stun in order to show immunity message
                    else if(nHD > 2 && nHD < 5 && !GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, OBJECT_SELF))
                    {
                         nDuration = nDuration - 1;
                         //Apply the VFX impact and effects
                         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlind, oTarget, RoundsToSeconds(nDuration)));
                    }
                    else
                    {
                         nDuration = nDuration - 2;
                         //Apply the VFX impact and effects
                         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, RoundsToSeconds(nDuration)));
                    }
                }
            }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, GetSpellTargetLocation(), TRUE);
    }
	fMaxDelay += 0.5f;
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCone, OBJECT_SELF, fMaxDelay);
}