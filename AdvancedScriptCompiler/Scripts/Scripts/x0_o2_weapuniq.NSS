//::///////////////////////////////////////////////////
//:: X0_O2_WEAPUNIQ.NSS
//:: OnOpened/OnDeath script for a treasure container.
//:: Treasure type: Any kind of weapon
//:: Treasure level: TREASURE_TYPE_UNIQUE
//::
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/21/2002
//::///////////////////////////////////////////////////

#include "x0_i0_treasure"

void main()
{

    CTG_CreateSpecificBaseTypeTreasure(TREASURE_TYPE_UNIQUE, GetLastOpener(), OBJECT_SELF, TREASURE_BASE_TYPE_WEAPON);

}

