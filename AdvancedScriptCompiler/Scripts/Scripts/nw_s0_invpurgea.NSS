//::///////////////////////////////////////////////
//:: Invisibilty Purge: On Enter
//:: NW_S0_InvPurgeA
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     All invisible creatures in the AOE become
     visible.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
//::March 31: Made it so it will actually remove
//  the effects of Improved Invisibility
#include "x0_i0_spells"

void main()
{
	int bRemovedEffect = FALSE;
    //Declare major variables
    object oTarget = GetEnteringObject();

    if (GetHasSpellEffect(SPELL_GREATER_INVISIBILITY, oTarget) == TRUE)
    {
        RemoveAnySpellEffects(SPELL_GREATER_INVISIBILITY, oTarget);
		bRemovedEffect = TRUE;
    }
    else
    if (GetHasSpellEffect(SPELL_INVISIBILITY, oTarget) == TRUE)
    {
        RemoveAnySpellEffects(SPELL_INVISIBILITY, oTarget);
		bRemovedEffect = TRUE;
    }
    else
    if (GetHasSpellEffect(SPELLABILITY_AS_GREATER_INVISIBLITY, oTarget) == TRUE)
    {
        RemoveAnySpellEffects(SPELLABILITY_AS_GREATER_INVISIBLITY, oTarget);
		bRemovedEffect = TRUE;
    }

    effect eInvis = GetFirstEffect(oTarget);

    int bIsImprovedInvis = FALSE;
    while(GetIsEffectValid(eInvis))
    {
        if (GetEffectType(eInvis) == EFFECT_TYPE_GREATERINVISIBILITY)	// JLR - OEI 07/11/05 -- Name Changed
        {
            bIsImprovedInvis = TRUE;
        }
        //check for invisibility
        if(GetEffectType(eInvis) == EFFECT_TYPE_INVISIBILITY || bIsImprovedInvis)
        {
            if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELL_INVISIBILITY_PURGE));
            }
            else
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELL_INVISIBILITY_PURGE, FALSE));
            }
            //remove invisibility
            RemoveEffect(oTarget, eInvis);
            if (bIsImprovedInvis)
            {
                RemoveSpellEffects(SPELL_GREATER_INVISIBILITY, oTarget, oTarget);	// JLR - OEI 07/11/05 -- Name Changed
            }
			bRemovedEffect = TRUE;
        }
        //Get Next Effect
        eInvis = GetNextEffect(oTarget);
    }
	if (bRemovedEffect == TRUE)
	{
		effect bHit = EffectVisualEffect(VFX_DUR_SPELL_INVISIBILITY_PURGE);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, bHit, oTarget);
	}
}