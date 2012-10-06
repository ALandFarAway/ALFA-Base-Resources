//::///////////////////////////////////////////////
//:: Balance Domain Power
//:: acr_s0_baldom
//:://////////////////////////////////////////////
/*
   The balance domain power offers a significant, but temporary
   bonus to armor class for the caster.
*/
/////////////////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Zelknolf
//:: Created On: 10/06/12
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "acr_spells_i"
#include "x2_i0_spells"
#include "nw_i0_spells"

void RunImpact(object oTarget, object oCaster, int nMetamagic);

void main()
{
    object oTarget = GetSpellTargetObject();

    //--------------------------------------------------------------------------
    // Spellcast Hook Code
    // Added 2003-06-20 by Georg
    // If you want to make changes to all spells, check x2_inc_spellhook.nss to
    // find out more
    //--------------------------------------------------------------------------
    if (!ACR_PrecastEvent())
    {
        return;
    }

    //--------------------------------------------------------------------------
    // Setup VFX
    //--------------------------------------------------------------------------
    effect eCha = SupernaturalEffect(EffectAbilityIncrease(ABILITY_CHARISMA, 4));

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCha, OBJECT_SELF, TurnsToSeconds(1));

}