//::///////////////////////////////////////////////
//:: Aura of Fear On Enter
//:: NW_S1_AuraFearA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Upon entering the aura of the creature the player
    must make a will save or be struck with fear because
    of the creatures presence.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 25, 2001
//:: Modified By: Constant Gaw - OEI 7/31/06
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"

void main()
{
    //Declare major variables
    object oTarget = GetEnteringObject();
	object oCreator = GetAreaOfEffectCreator();
    //effect eVis = EffectVisualEffect(VFX_IMP_FEAR_S);
    effect eDur = EffectVisualEffect( VFX_DUR_SPELL_FEAR );
    //effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eFear = EffectFrightened();
    effect eLink = EffectLinkEffects(eFear, eDur);
    //eLink = EffectLinkEffects(eLink, eDur2);
	effect eAttackPen = EffectAttackDecrease(2, ATTACK_BONUS_MISC);
	effect eSavePen = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL);
	effect eSkillPen = EffectSkillDecrease(SKILL_ALL_SKILLS, 2);
	effect eShakenLink1 = EffectLinkEffects(eAttackPen, eSavePen);
	effect eShakenLink2 = EffectLinkEffects(eSkillPen, eDur);
	effect eLink2 = EffectLinkEffects(eShakenLink1, eShakenLink2);

    int nHD = GetHitDice(GetAreaOfEffectCreator());
//  int nDC = 10 + GetHitDice(GetAreaOfEffectCreator())/3;
    int nDC = 10 + GetHitDice(GetAreaOfEffectCreator());
    int nDuration = GetScaledDuration(nHD, oTarget);
		
	if(GetIsEnemy(oTarget, GetAreaOfEffectCreator()))
	{
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELLABILITY_AURA_FEAR));
        //Make a saving throw check
        if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR))
        {
			if ((GetHitDice(oCreator) - GetHitDice(oTarget) >= 6) ||
			    GetIsImmune(oTarget, IMMUNITY_TYPE_FEAR) ||
			    GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, GetAreaOfEffectCreator()))
			{
	            //Apply the VFX impact and effects
	            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
	            //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			}
			
			else 
			{
				//Apply Shaken Effect 
				//Characters who are shaken take a -2 penalty on attack rolls, 
				//saving throws, skill checks, and ability checks (note: cannot apply ability
				//penalty).
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, RoundsToSeconds(nDuration));
			}	
        }
    }
}