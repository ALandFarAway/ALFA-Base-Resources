//::///////////////////////////////////////////////////
//:: X0_S1_PETRGAZE
//:: Petrification gaze monster ability. 
//:: Fortitude save (DC 15) or be turned to stone permanently.
//:: This will be changed to a temporary effect.
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/14/2002
//::///////////////////////////////////////////////////
//:: Used by Basilisk


#include "x0_i0_spells"
#include "acr_creature_i"
#include "acr_spells_i"

void main()
{
    object oTarget = GetSpellTargetObject();
    int nHitDice = GetHitDice(OBJECT_SELF);
    int nDC = nHitDice / 2 + GetAbilityModifier(ABILITY_CHARISMA);

    location lTargetLocation = GetSpellTargetLocation();

    //Get first target in spell area
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
    while(GetIsObjectValid(oTarget))
    {
        // Undead are immune to this spell.
        if (!ACR_GetIsUndead(oTarget) &&
            ACR_CanGazeAttack(oTarget)) {
            float fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
            int nSpellID = GetSpellId();
            object oSelf = OBJECT_SELF;
            DelayCommand(fDelay,  DoPetrification(nHitDice, oSelf, oTarget, nSpellID, nDC));
        }
		
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
    }
}