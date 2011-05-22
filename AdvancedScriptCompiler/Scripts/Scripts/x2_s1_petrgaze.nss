//::///////////////////////////////////////////////
//:: Gaze attack for shifter forms
//:: x2_s1_petrgaze
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*

  Petrification gaze  for polymorph type
  basilisk and medusa

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: July, 09, 2003
//:://////////////////////////////////////////////

#include "x0_i0_spells"
#include "x2_inc_shifter"

void main()
{

    //--------------------------------------------------------------------------
    // Enforce artifical use limit on that ability
    //--------------------------------------------------------------------------
    if (ShifterDecrementGWildShapeSpellUsesLeft() <1 )
    {
        FloatingTextStrRefOnCreature(83576, OBJECT_SELF);
        return;
    }

    //--------------------------------------------------------------------------
    // Make sure we are not blind
    //--------------------------------------------------------------------------
    if( GZCanNotUseGazeAttackCheck(OBJECT_SELF))
    {
        return;
    }

    //--------------------------------------------------------------------------
    // Calculate Save DC
    //--------------------------------------------------------------------------
    int nDC = ShifterGetSaveDC(OBJECT_SELF,SHIFTER_DC_EASY_MEDIUM);

    float fDelay;
    object oTarget = GetSpellTargetObject();
    int nHitDice = GetCasterLevel(OBJECT_SELF);
    location lTargetLocation = GetSpellTargetLocation();
    int nSpellID = GetSpellId();
    object oSelf = OBJECT_SELF;

    //--------------------------------------------------------------------------
    // Loop through all available targets in spellcone
    //--------------------------------------------------------------------------
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
    while(GetIsObjectValid(oTarget))
    {
        fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;

        if (spellsIsTarget(oTarget,SPELL_TARGET_STANDARDHOSTILE,OBJECT_SELF) && oTarget != OBJECT_SELF)
        {
            DelayCommand(fDelay,  DoPetrification(nHitDice, oSelf, oTarget, nSpellID, nDC));
            //Get next target in spell area
        }
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
    }

}


