//::///////////////////////////////////////////////
//:: Aura of Protection: On Enter
//:: NW_S1_AuraProtA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Acts as a double strength Magic Circle against
    evil and a Minor Globe for those friends in
    the area.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On:Jan 8, 2002, 2001
//:://////////////////////////////////////////////
//:: RPGplayer1 03/19/2008:
//::  Will work on allies
//::  Will give proper +4 bonus

#include "NW_I0_SPELLS"

void main()
{
    //Declare major variables
    effect eProt = CreateProtectionFromAlignmentLink(ALIGNMENT_EVIL, 2);
    effect eGlobe = EffectSpellLevelAbsorption(3, 0);
    effect eDur = EffectVisualEffect(VFX_DUR_GLOBE_MINOR);

    effect eLink = EffectLinkEffects(eProt, eGlobe);
    eLink = EffectLinkEffects(eLink, eDur);

    object oTarget = GetEnteringObject();
    //Faction Check
    //if(GetIsFriend(oTarget, GetAreaOfEffectCreator()))
    if(spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, GetAreaOfEffectCreator()))
    {
        //Apply the VFX impact and effects
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
    }
}