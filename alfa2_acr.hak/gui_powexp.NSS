//========================================================
/*
    New Power Attack and Combat Expertise Granular GUI
    By: Zelknolf
    2012/1/14

    This script handles the toggling of combat expertise
    and power attack at a more-granular level than we find
    in the default NWN2 implementation.
*/
//========================================================

#include "acr_combat_actions_i"

void main ( string sEvent, string sAmount )
{
    int nEvent = StringToInt(sEvent);
    int nAmount = StringToInt(sAmount);

    if(nEvent == POWER_EXPERT_EVENT_OPEN_MENU)
    {
        int bHasCE  = GetHasFeat(FEAT_ACR_COMBAT_EXPERTISE);
        int bHasPA  = GetHasFeat(FEAT_ACR_POWER_ATTACK);

        if(bHasCE)
        {
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "SHOW_CE_PAGE", FALSE );
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "CE_PAGE", FALSE );
        }
        else
        {
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "SHOW_CE_PAGE", TRUE );
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "CE_PAGE", TRUE );
        }
        if(bHasPA)
        {
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "SHOW_POW_PAGE", FALSE );
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "POW_PAGE", FALSE );
        }
        else
        {
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "SHOW_POW_PAGE", TRUE );
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "POW_PAGE", TRUE );
        }
    }
    if(nEvent == POWER_EXPERT_EVENT_COMBAT_EXPERTISE_MENU || nEvent == POWER_EXPERT_EVENT_OPEN_MENU)
    {
        int nBAB = GetBaseAttackBonus(OBJECT_SELF);
        int bHasCE  = GetHasFeat(FEAT_ACR_COMBAT_EXPERTISE);
        int bHasICE = GetHasFeat(FEAT_ACR_IMPROVED_COMBAT_EXPERTISE);

        ClearListBox(OBJECT_SELF, "SCREEN_MODEBAR_2", "CEBAR_GRID");

        if(nBAB >= 1 && bHasCE)
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "COMBAT_EXPERTISE_1", FALSE );
        else
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "COMBAT_EXPERTISE_1", TRUE );

        if(nBAB >= 2 && bHasCE)
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "COMBAT_EXPERTISE_2", FALSE );
        else
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "COMBAT_EXPERTISE_2", TRUE );

        if(nBAB >= 3 && bHasCE)
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "COMBAT_EXPERTISE_3", FALSE );
        else
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "COMBAT_EXPERTISE_3", TRUE );

        if(nBAB >= 4 && bHasCE)
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "COMBAT_EXPERTISE_4", FALSE );
        else
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "COMBAT_EXPERTISE_4", TRUE );

        if(nBAB >= 5 && bHasCE)
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "COMBAT_EXPERTISE_5", FALSE );
        else
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "COMBAT_EXPERTISE_5", TRUE );

        if(nBAB >= 6 && bHasICE)
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "COMBAT_EXPERTISE_6", FALSE );
        else
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "COMBAT_EXPERTISE_6", TRUE );

        if(nBAB >= 7 && bHasICE)
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "COMBAT_EXPERTISE_7", FALSE );
        else
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "COMBAT_EXPERTISE_7", TRUE );

        if(nBAB >= 8 && bHasICE)
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "COMBAT_EXPERTISE_8", FALSE );
        else
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "COMBAT_EXPERTISE_8", TRUE );

        if(nBAB >= 9 && bHasICE)
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "COMBAT_EXPERTISE_9", FALSE );
        else
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "COMBAT_EXPERTISE_9", TRUE );

        if(nBAB >= 10 && bHasICE)
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "COMBAT_EXPERTISE_10", FALSE );
        else
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "COMBAT_EXPERTISE_10", TRUE );

        int nMode = GetLocalInt(OBJECT_SELF, COMBAT_EXPERTISE_MODE_ACTIVE);
        if(nMode > 0)
        {
            string sMode = "OVERLAY_ICON_CE_"+IntToString(nMode);
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", sMode, FALSE );
        }
    }
    else if(nEvent == POWER_EXPERT_EVENT_POWER_ATTACK_MENU || nEvent == POWER_EXPERT_EVENT_OPEN_MENU)
    {
        int nBAB = GetBaseAttackBonus(OBJECT_SELF);
        int bHasPA  = GetHasFeat(FEAT_ACR_POWER_ATTACK);
        int bHasIPA = GetHasFeat(FEAT_ACR_IMPROVED_POWER_ATTACK);

        ClearListBox(OBJECT_SELF, "SCREEN_MODEBAR_2", "POWBAR_GRID");

        if(nBAB >= 1 && bHasPA)
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "POWER_ATTACK_1", FALSE );
        else
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "POWER_ATTACK_1", TRUE );

        if(nBAB >= 2 && bHasPA)
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "POWER_ATTACK_2", FALSE );
        else
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "POWER_ATTACK_2", TRUE );

        if(nBAB >= 3 && bHasPA)
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "POWER_ATTACK_3", FALSE );
        else
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "POWER_ATTACK_3", TRUE );

        if(nBAB >= 4 && bHasPA)
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "POWER_ATTACK_4", FALSE );
        else
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "POWER_ATTACK_4", TRUE );

        if(nBAB >= 5 && bHasPA)
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "POWER_ATTACK_5", FALSE );
        else
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "POWER_ATTACK_5", TRUE );

        if(nBAB >= 6 && bHasIPA)
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "POWER_ATTACK_6", FALSE );
        else
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "POWER_ATTACK_6", TRUE );

        if(nBAB >= 7 && bHasIPA)
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "POWER_ATTACK_7", FALSE );
        else
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "POWER_ATTACK_7", TRUE );

        if(nBAB >= 8 && bHasIPA)
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "POWER_ATTACK_8", FALSE );
        else
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "POWER_ATTACK_8", TRUE );

        if(nBAB >= 9 && bHasIPA)
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "POWER_ATTACK_9", FALSE );
        else
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "POWER_ATTACK_9", TRUE );

        if(nBAB >= 10 && bHasIPA)
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "POWER_ATTACK_10", FALSE );
        else
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", "POWER_ATTACK_10", TRUE );

        int nMode = GetLocalInt(OBJECT_SELF, POWER_ATTACK_MODE_ACTIVE);
        if(nMode > 0)
        {
            string sMode = "OVERLAY_ICON_PA_"+IntToString(nMode);
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", sMode, FALSE );
        }
    }
    else if(nEvent == POWER_EXPERT_EVENT_COMBAT_EXPERTISE_TOGGLE)
    {
        if(!_TrySwitchModes(OBJECT_SELF)) return;
        int nOldMode = GetLocalInt(OBJECT_SELF, COMBAT_EXPERTISE_MODE_ACTIVE);
        int nNewMode = nAmount;
        if(nOldMode > 0)
        {
            string sMode = "OVERLAY_ICON_CE_"+IntToString(nOldMode);
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", sMode, TRUE );
        }
        if(nNewMode == nOldMode)
        {
            FightNormally(OBJECT_SELF);
            DeleteLocalInt(OBJECT_SELF, COMBAT_EXPERTISE_MODE_ACTIVE);
        }
        else
        {
            string sMode = "OVERLAY_ICON_CE_"+IntToString(nNewMode);
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", sMode, FALSE );
            SetLocalInt(OBJECT_SELF, COMBAT_EXPERTISE_MODE_ACTIVE, nNewMode);
            if(!GetLocalInt(OBJECT_SELF, POST_SPELLCAST_NO_COMBAT_MODE))
                FightWithExpertise(OBJECT_SELF, nNewMode);
        }
    }
    else if(nEvent == POWER_EXPERT_EVENT_POWER_ATTACK_TOGGLE)
    {
        if(!_TrySwitchModes(OBJECT_SELF)) return;
        int nOldMode = GetLocalInt(OBJECT_SELF, POWER_ATTACK_MODE_ACTIVE);
        int nNewMode = nAmount;
        if(nOldMode > 0)
        {
            string sMode = "OVERLAY_ICON_PA_"+IntToString(nOldMode);
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", sMode, TRUE );
        }
        if(nNewMode == nOldMode)
        {
            SendMessageToPC(OBJECT_SELF, "Command to disable Power Attack received.");
            DeleteLocalInt(OBJECT_SELF, POWER_ATTACK_MODE_ACTIVE);
        }
        else
        {
            string sMode = "OVERLAY_ICON_PA_"+IntToString(nNewMode);
            SetGUIObjectHidden( OBJECT_SELF, "SCREEN_MODEBAR_2", sMode, FALSE );
            SetLocalInt(OBJECT_SELF, POWER_ATTACK_MODE_ACTIVE, nNewMode);
            SendMessageToPC(OBJECT_SELF, "Power Attack intensity set to "+sAmount+".");
        }
    }
}
