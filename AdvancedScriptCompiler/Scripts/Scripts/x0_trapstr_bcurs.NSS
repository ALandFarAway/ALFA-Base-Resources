
//::///////////////////////////////////////////////////
//:: X0_TRAPSTR_BCURS
//:: OnTriggered script for a projectile trap
//:: Spell fired: SPELL_BESTOW_CURSE
//:: Spell caster level: 7
//::
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/17/2002
//::///////////////////////////////////////////////////

#include "x0_i0_projtrap"

void main()
{
    TriggerProjectileTrap(SPELL_BESTOW_CURSE, GetEnteringObject(), 7);
}

