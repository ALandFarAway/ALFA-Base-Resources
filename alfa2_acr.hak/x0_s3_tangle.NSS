//::///////////////////////////////////////////////
//:: Tanglefoot bag
//:: x0_s3_tangle
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Grenade.
    Fires at a target. If hit, the target takes
    direct damage. If missed, all enemies within
    an area of effect take splash damage.

    HOWTO:
        Will entangle target.
        + If a saving throw REFLEX vs. DC 15 is failed the creature
          is immobile (HELD)
          
        DURATION: 1 turn
		
	Edit by AcadiusLost for ALFA, 9/21/2010 (added recognition of ABR item tag)
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 10, 2002
//:: Edited 9/21/2010 by AcadiusLost for ALFA
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
void main()
{
    //Declare major variables
    effect eHold = EffectEntangle();
    effect eEntangle = EffectVisualEffect(VFX_DUR_ENTANGLE);
    object oTarget = GetSpellTargetObject();
    effect eLink = EffectLinkEffects(eHold, eEntangle);
	int nDur;

	int nSaveDC = 0;

	object oItem = GetSpellCastItem();
	string sTag = GetStringLowerCase(GetTag(oItem));

	if ((sTag == "x1_wmgrenade006") || (sTag == "abr_it_msc_tanglefoot"))
	{
		nSaveDC = 15;
		nDur = 2;
	}
	else if (sTag == "n2_it_tang_2")
	{
		nSaveDC = 17;
		nDur = 3;
	}
	else if (sTag == "n2_it_tang_3")
	{
		nSaveDC = 19;
		nDur = 4;
	}
	else if (sTag == "n2_it_tang_4")
	{
		nSaveDC = 21;
		nDur = 6;
	}
    
    if(spellsIsTarget(oTarget,SPELL_TARGET_STANDARDHOSTILE,OBJECT_SELF) )
	{
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), TRUE));
        //Make reflex save
        if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, nSaveDC))
        {
           //Apply linked effects
           ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDur));
        }
    }
}