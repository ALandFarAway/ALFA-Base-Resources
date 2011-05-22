
//::///////////////////////////////////////////////////
//:: X0_TRAPDLY_PSPRY
//:: OnTriggered script for a projectile trap
//:: Spell fired: SPELL_PRISMATIC_SPRAY
//:: Spell caster level: 13
//::
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/17/2002
//::///////////////////////////////////////////////////

#include "x0_i0_projtrap"

void main()
{
    TriggerProjectileTrap(SPELL_PRISMATIC_SPRAY, GetEnteringObject(), 13);
}

