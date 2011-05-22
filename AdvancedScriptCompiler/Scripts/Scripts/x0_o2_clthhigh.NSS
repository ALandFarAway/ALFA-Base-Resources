//::///////////////////////////////////////////////////
//:: X0_O2_CLTHHIGH.NSS
//:: OnOpened/OnDeath script for a treasure container.
//:: Treasure type: Clothing: belts, boots, bracers, cloaks, helms, gloves
//:: Treasure level: TREASURE_TYPE_HIGH
//::
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/21/2002
//::///////////////////////////////////////////////////

#include "x0_i0_treasure"

void main()
{

    CTG_CreateSpecificBaseTypeTreasure(TREASURE_TYPE_HIGH, GetLastOpener(), OBJECT_SELF, TREASURE_BASE_TYPE_CLOTHING);

}

