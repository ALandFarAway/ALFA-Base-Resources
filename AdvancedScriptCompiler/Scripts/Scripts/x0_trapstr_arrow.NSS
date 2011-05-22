
//::///////////////////////////////////////////////////
//:: X0_TRAPSTR_ARROW
//:: OnTriggered script for a projectile trap
//:: Spell fired: SPELL_TRAP_ARROW
//:: Spell caster level: 7
//::
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/17/2002
//::///////////////////////////////////////////////////

#include "x0_i0_projtrap"

void main()
{
    TriggerProjectileTrap(SPELL_TRAP_ARROW, GetEnteringObject(), 7,
                          OBJECT_INVALID, OBJECT_SELF,
                          PROJECTILE_PATH_TYPE_HOMING);
}

