//::///////////////////////////////////////////////////
//:: X0_S1_PETRBREATH
//:: Petrification breath monster ability. 
//:: Fortitude save (DC 17) or be turned to stone permanently.
//:: This will be changed to a temporary effect.
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/14/2002
//::///////////////////////////////////////////////////


#include "x0_i0_spells"
#include "acr_creature_i"
#include "acr_spells_i"


//
void main()
{
    //SendMessageToPC(GetFirstPC(FALSE), "x0_s1_petrbreath"); // kL_add.

    object oCaster = OBJECT_SELF;

    int iDuration = GetHitDice(oCaster);
    int iSpellId  = GetSpellId();

    location lSpell = GetSpellTargetLocation();
    object oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 11.f, lSpell, TRUE);
    while (GetIsObjectValid(oTarget))
    {
        float fDelay = GetDistanceToObject(oTarget) / 20;
        DelayCommand(fDelay, DoPetrification(iDuration, oCaster, oTarget, iSpellId, 17));

        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 11.f, lSpell, TRUE);
    }
}