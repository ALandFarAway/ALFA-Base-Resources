//::///////////////////////////////////////////////
//:: User Defined Henchmen Script
//:: gb_assoc_usrdef
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The most complicated script in the game.
    ... ever
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: March 18, 2002
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
#include "hench_i0_hensho"


void main()
{
//    Jug_Debug("*****" + GetName(OBJECT_SELF) + " user defined " + IntToString(GetUserDefinedEventNumber()));

    int nEvent = GetUserDefinedEventNumber();

    if (nEvent == 20000 + ACTION_MODE_STEALTH)
    {
        if (!GetIsFighting(OBJECT_SELF) && !GetHenchAssociateState(HENCH_ASC_DISABLE_AUTO_HIDE))
        {
            int bStealth = GetActionMode(GetMaster(), ACTION_MODE_STEALTH);
            RelayModeToAssociates(ACTION_MODE_STEALTH, bStealth);
        }
    }
    else if (nEvent == 20000 + ACTION_MODE_DETECT)
    {
        if (!GetIsFighting(OBJECT_SELF))
        {
            int bDetect = GetActionMode(GetMaster(), ACTION_MODE_DETECT);
            RelayModeToAssociates(ACTION_MODE_DETECT, bDetect);
        }
    }
    // * If a creature has the integer variable X2_L_CREATURE_NEEDS_CONCENTRATION set to TRUE
    // * it may receive this event. It will unsummon the creature immediately
    else if (nEvent == X2_EVENT_CONCENTRATION_BROKEN)
    {
        effect eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eVis,GetLocation(OBJECT_SELF));
        FloatingTextStrRefOnCreature(84481,GetMaster(OBJECT_SELF));
        DestroyObject(OBJECT_SELF,0.1f);
    }
}