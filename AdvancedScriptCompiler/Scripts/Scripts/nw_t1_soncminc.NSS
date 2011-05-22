//::///////////////////////////////////////////////
//:: Minor Sonic Trap
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Will save or the creature is stunned
//:: for 2 rounds.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 16, 2001
//:://////////////////////////////////////////////
//:: RPGplayer1 08/16/2008: Added faction check (to avoid hitting neutrals)
//:: RPGplayer1 08/16/2008: Makes damage roll for each target
//:: RPGplayer1 12/30/2008: Improved faction check, to pass creator for crafted traps properly

#include "NW_I0_SPELLS"

void main()
{
    //Declare major variables
    object oTarget;
    effect eStun = EffectStunned();
    effect eFNF = EffectVisualEffect( VFX_HIT_SPELL_SONIC );
    effect eMind = EffectVisualEffect( VFX_DUR_SPELL_DAZE );
    effect eLink = EffectLinkEffects(eStun, eMind);
    effect eDam = EffectDamage(d4(2), DAMAGE_TYPE_SONIC);

    object oCreator = GetTrapCreator(OBJECT_SELF);
    if (oCreator == OBJECT_INVALID)
    {
        oCreator = OBJECT_SELF; //pre-placed traps have no creator
    }

    //Apply the FNF to the spell location
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eFNF, GetLocation(GetEnteringObject()));
    //Get the first target in the spell area
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM,GetLocation(GetEnteringObject()));
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCreator))
        {
            //Roll damage for each target
            eDam = EffectDamage(d4(2), DAMAGE_TYPE_SONIC);
        DelayCommand(0.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
        //Make a Will roll to avoid being stunned
        if(!MySavingThrow(SAVING_THROW_WILL, oTarget, 12, SAVING_THROW_TYPE_TRAP))
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(2));
        }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, GetLocation(GetEnteringObject()));
    }
}