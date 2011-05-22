//::///////////////////////////////////////////////
//:: Deadly Tangle Trap
//:: NW_T1_TangStrC
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Targets within 10ft of the entering character
    are slowed unless they make a reflex save with
    a DC of 35.  Effect lasts for 5 Rounds
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 4th, 2001
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"

void main()
{
    //Declare major variables
    int nDuration = 5;
    object oTarget = GetEnteringObject();
    location lTarget = GetLocation(oTarget);
    effect eSlow = EffectSlow();
    effect eVis = EffectVisualEffect( VFX_DUR_SPELL_SLOW );

    //Find first target in the size
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget);
    //Cycle through the objects in the radius
    while (GetIsObjectValid(oTarget))
    {
        if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, 35, SAVING_THROW_TYPE_TRAP))
        {
            //Apply slow effect and slow effect
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSlow, oTarget, RoundsToSeconds(nDuration));
        }
        //Get next target in the shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget);
    }
}