//::///////////////////////////////////////////////
//:: Aura of Fear On Enter
//:: NW_S1_DragFearA.nss
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
//:: LastUpdated: 24, Oct 2003, GeorgZ
//:: Modified By: Constant Gaw - OEI 7/31/06
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"
#include "nw_i0_plot"

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

    int nHD = GetHitDice(oCreator);
	int nCHRBonus = (GetCharisma(oCreator) - 10)/ 2;
	int nDC = 10 + (nHD / 2) + nCHRBonus; 
    //int nDC = GetDragonFearDC(GetHitDice(GetAreaOfEffectCreator()));
	//10 + GetHitDice(GetAreaOfEffectCreator())/3;
	
	int nNumRounds = d6(4);
	
    int nDuration = GetScaledDuration(nNumRounds, oTarget);
    //--------------------------------------------------------------------------
    // Capping at 20
    //--------------------------------------------------------------------------
/*  if (nDuration > 20)
    {
        nDuration = 20;
    }*/
	
	// Some HotU stuff...
	/*
    //--------------------------------------------------------------------------
    // Yaron does not like the stunning beauty of a very specific dragon to
    // last more than 10 rounds ....
    //--------------------------------------------------------------------------
    if (GetTag(GetAreaOfEffectCreator()) == "q3_vixthra")
    {
        nDuration = 3+d6();
    }
	*/
	
    if(GetIsEnemy(oTarget, GetAreaOfEffectCreator()))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELLABILITY_AURA_FEAR));
        //Make a saving throw check
        if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR))
	  	{
			if ((GetHitDice(oTarget) <= 4) ||
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