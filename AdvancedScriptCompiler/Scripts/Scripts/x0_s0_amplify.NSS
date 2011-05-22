//::///////////////////////////////////////////////
//:: Amplify
//:: x0_s0_amplify.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The caster or target is able to hear sounds better.
    Listen skill increases by 20.
    DURATION: 1 round/level
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: July 30, 2002
//:://////////////////////////////////////////////


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
    object oTarget = GetSpellTargetObject();
    //effect eVis = EffectVisualEffect(VFX_HIT_SPELL_TRANSMUTATION);	// no longer using NWN1 VFX
    effect eVis = EffectVisualEffect( VFX_DUR_SPELL_AMPLIFY );	// uses NWN2 VFX
    int nMetaMagic = GetMetaMagicFeat();

    effect eHide = EffectSkillIncrease(SKILL_LISTEN, 20);

    //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);	// no longer using NWN1 VFX
    effect eLink = EffectLinkEffects(eHide, eVis);

    int nDuration = GetCasterLevel(OBJECT_SELF); // * Duration 1 turn/level
     if (nMetaMagic == METAMAGIC_EXTEND)	//Duration is +100%
    {
         nDuration = nDuration * 2;
    }

    //Fire spell cast at event for target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
    //Apply VFX impact and bonus effects
    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);	// no longer using NWN1 VFX
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));

}





