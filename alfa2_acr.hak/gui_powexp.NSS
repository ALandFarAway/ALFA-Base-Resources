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

int POWER_EXPERT_EVENT_COMBAT_EXPERTISE_MENU      = 1;
int POWER_EXPERT_EVENT_POWER_ATTACK_MENU          = 2;
int POWER_EXPERT_EVENT_COMBAT_EXPERTISE_TOGGLE    = 3;
int POWER_EXPERT_EVENT_POWER_ATTACK_TOGGLE        = 4;

string POWER_ATTACK_MODE_ACTIVE     = "POWER_ATTACK_MODE_ACTIVE";
string COMBAT_EXPERTISE_MODE_ACTIVE = "COMBAT_EXPERTISE_MODE_ACTIVE";


void main ( string sEvent, string sAmount )
{
    int nEvent = StringToInt(sEvent);
    int nAmount = StringToInt(sAmount);

    if(nEvent == POWER_EXPERT_EVENT_COMBAT_EXPERTISE_MENU)
    {
        int nBAB = GetBaseAttackBonus(OBJECT_SELF);
        int bHasCE  = GetHasFeat(FEAT_COMBAT_EXPERTISE);
        int bHasICE = GetHasFeat(FEAT_IMPROVED_COMBAT_EXPERTISE);

        ClearListBox(OBJECT_SELF, "SCREEN_MODEBAR_2", "CEBAR_GRID");

        if(nBAB >= 1 && bHasCE)
            AddListBoxRow(OBJECT_SELF, "SCREEN_MODEBAR_2", "CEBAR_GRID", "CombatExpertise1", "", "BASE_ICON=comexp_01.tga", "5=1;6=+1 AC, -1 Attack", "");
        if(nBAB >= 2 && bHasCE)
            AddListBoxRow(OBJECT_SELF, "SCREEN_MODEBAR_2", "CEBAR_GRID", "CombatExpertise2", "", "BASE_ICON=comexp_02.tga", "5=2;6=+2 AC, -2 Attack", "");
        if(nBAB >= 3 && bHasCE)
            AddListBoxRow(OBJECT_SELF, "SCREEN_MODEBAR_2", "CEBAR_GRID", "CombatExpertise3", "", "BASE_ICON=comexp_03.tga", "5=3;6=+3 AC, -3 Attack", "");
        if(nBAB >= 4 && bHasCE)
            AddListBoxRow(OBJECT_SELF, "SCREEN_MODEBAR_2", "CEBAR_GRID", "CombatExpertise4", "", "BASE_ICON=comexp_04.tga", "5=4;6=+4 AC, -4 Attack", "");
        if(nBAB >= 5 && bHasCE)
            AddListBoxRow(OBJECT_SELF, "SCREEN_MODEBAR_2", "CEBAR_GRID", "CombatExpertise5", "", "BASE_ICON=comexp_05.tga", "5=5;6=+5 AC, -5 Attack", "");
        if(nBAB >= 6 && bHasICE)
            AddListBoxRow(OBJECT_SELF, "SCREEN_MODEBAR_2", "CEBAR_GRID", "CombatExpertise6", "", "BASE_ICON=comexp_06.tga", "5=6;6=+6 AC, -6 Attack", "");
        if(nBAB >= 7 && bHasICE)
            AddListBoxRow(OBJECT_SELF, "SCREEN_MODEBAR_2", "CEBAR_GRID", "CombatExpertise7", "", "BASE_ICON=comexp_07.tga", "5=7;6=+7 AC, -7 Attack", "");
        if(nBAB >= 8 && bHasICE)
            AddListBoxRow(OBJECT_SELF, "SCREEN_MODEBAR_2", "CEBAR_GRID", "CombatExpertise8", "", "BASE_ICON=comexp_08.tga", "5=8;6=+8 AC, -8 Attack", "");
        if(nBAB >= 9 && bHasICE)
            AddListBoxRow(OBJECT_SELF, "SCREEN_MODEBAR_2", "CEBAR_GRID", "CombatExpertise9", "", "BASE_ICON=comexp_09.tga", "5=9;6=+9 AC, -9 Attack", "");
        if(nBAB >= 10 && bHasICE)
            AddListBoxRow(OBJECT_SELF, "SCREEN_MODEBAR_2", "CEBAR_GRID", "CombatExpertise10", "", "BASE_ICON=comexp_10.tga", "5=10;6=+10 AC, -10 Attack", "");

        int nMode = GetLocalInt(OBJECT_SELF, COMBAT_EXPERTISE_MODE_ACTIVE);
        if(nMode > 0)
        {
            string sRow = "CombatExpertise"+IntToString(nMode);
            ModifyListBoxRow(OBJECT_SELF, "SCREEN_MODEBAR_2", "CEBAR_GRID", sRow, "", "", "", "OVERLAY_ICON=unhide");
        }
    }
    else if(nEvent == POWER_EXPERT_EVENT_POWER_ATTACK_MENU)
    {
        int nBAB = GetBaseAttackBonus(OBJECT_SELF);
        int bHasPA  = GetHasFeat(FEAT_POWER_ATTACK);
        int bHasIPA = GetHasFeat(FEAT_IMPROVED_POWER_ATTACK);

        ClearListBox(OBJECT_SELF, "SCREEN_MODEBAR_2", "POWBAR_GRID");

        if(nBAB >= 1 && bHasPA)
            AddListBoxRow(OBJECT_SELF, "SCREEN_MODEBAR_2", "POWBAR_GRID", "PowerAttack1", "", "BASE_ICON=powatt_01.tga", "5=1;6=+1 Damage, -1 Attack", "");
        if(nBAB >= 2 && bHasPA)
            AddListBoxRow(OBJECT_SELF, "SCREEN_MODEBAR_2", "POWBAR_GRID", "PowerAttack2", "", "BASE_ICON=powatt_02.tga", "5=2;6=+2 Damage, -2 Attack", "");
        if(nBAB >= 3 && bHasPA)
            AddListBoxRow(OBJECT_SELF, "SCREEN_MODEBAR_2", "POWBAR_GRID", "PowerAttack3", "", "BASE_ICON=powatt_03.tga", "5=3;6=+3 Damage, -3 Attack", "");
        if(nBAB >= 4 && bHasPA)
            AddListBoxRow(OBJECT_SELF, "SCREEN_MODEBAR_2", "POWBAR_GRID", "PowerAttack4", "", "BASE_ICON=powatt_04.tga", "5=4;6=+4 Damage, -4 Attack", "");
        if(nBAB >= 5 && bHasPA)
            AddListBoxRow(OBJECT_SELF, "SCREEN_MODEBAR_2", "POWBAR_GRID", "PowerAttack5", "", "BASE_ICON=powatt_05.tga", "5=5;6=+5 Damage, -5 Attack", "");
        if(nBAB >= 6 && bHasIPA)
            AddListBoxRow(OBJECT_SELF, "SCREEN_MODEBAR_2", "POWBAR_GRID", "PowerAttack6", "", "BASE_ICON=powatt_06.tga", "5=6;6=+6 Damage, -6 Attack", "");
        if(nBAB >= 7 && bHasIPA)
            AddListBoxRow(OBJECT_SELF, "SCREEN_MODEBAR_2", "POWBAR_GRID", "PowerAttack7", "", "BASE_ICON=powatt_07.tga", "5=7;6=+7 Damage, -7 Attack", "");
        if(nBAB >= 8 && bHasIPA)
            AddListBoxRow(OBJECT_SELF, "SCREEN_MODEBAR_2", "POWBAR_GRID", "PowerAttack8", "", "BASE_ICON=powatt_08.tga", "5=8;6=+8 Damage, -8 Attack", "");
        if(nBAB >= 9 && bHasIPA)
            AddListBoxRow(OBJECT_SELF, "SCREEN_MODEBAR_2", "POWBAR_GRID", "PowerAttack9", "", "BASE_ICON=powatt_09.tga", "5=9;6=+9 Damage, -9 Attack", "");
        if(nBAB >= 10 && bHasIPA)
            AddListBoxRow(OBJECT_SELF, "SCREEN_MODEBAR_2", "POWBAR_GRID", "PowerAttack10", "", "BASE_ICON=powatt_10.tga", "5=10;6=+10 Damage, -10 Attack", "");

        int nMode = GetLocalInt(OBJECT_SELF, POWER_ATTACK_MODE_ACTIVE);
        if(nMode > 0)
        {
            string sRow = "PowerAttack"+IntToString(nMode);
            ModifyListBoxRow(OBJECT_SELF, "SCREEN_MODEBAR_2", "POWBAR_GRID", sRow, "", "", "", "OVERLAY_ICON=unhide");
        }
    }
    else if(nEvent == POWER_EXPERT_EVENT_COMBAT_EXPERTISE_TOGGLE)
    {
        int nOldMode = GetLocalInt(OBJECT_SELF, COMBAT_EXPERTISE_MODE_ACTIVE);
        int nNewMode = nAmount;
        if(nOldMode > 0)
        {
            string sRow = "CombatExpertise"+IntToString(nOldMode);
            ModifyListBoxRow(OBJECT_SELF, "SCREEN_MODEBAR_2", "CEBAR_GRID", sRow, "", "", "", "OVERLAY_ICON=hide");            
        }
        if(nNewMode == nOldMode)
        {
            SendMessageToPC(OBJECT_SELF, "Command to disable Combat Expertise received.");
            DeleteLocalInt(OBJECT_SELF, COMBAT_EXPERTISE_MODE_ACTIVE);
        }
        else
        {
            string sRow = "CombatExpertise"+IntToString(nNewMode);
            ModifyListBoxRow(OBJECT_SELF, "SCREEN_MODEBAR_2", "CEBAR_GRID", sRow, "", "", "", "OVERLAY_ICON=unhide");        
            SetLocalInt(OBJECT_SELF, COMBAT_EXPERTISE_MODE_ACTIVE, nNewMode);
            SendMessageToPC(OBJECT_SELF, "Combat Expertise intensity set to "+sAmount+".");
        }
    }
    else if(nEvent == POWER_EXPERT_EVENT_POWER_ATTACK_TOGGLE)
    {
        int nOldMode = GetLocalInt(OBJECT_SELF, POWER_ATTACK_MODE_ACTIVE);
        int nNewMode = nAmount;
        if(nOldMode > 0)
        {
            string sRow = "PowerAttack"+IntToString(nOldMode);
            ModifyListBoxRow(OBJECT_SELF, "SCREEN_MODEBAR_2", "POWBAR_GRID", sRow, "", "", "", "OVERLAY_ICON=hide");            
        }
        if(nNewMode == nOldMode)
        {
            SendMessageToPC(OBJECT_SELF, "Command to disable Power Attack received.");
            DeleteLocalInt(OBJECT_SELF, POWER_ATTACK_MODE_ACTIVE);
        }
        else
        {
            string sRow = "PowerAttack"+IntToString(nNewMode);
            ModifyListBoxRow(OBJECT_SELF, "SCREEN_MODEBAR_2", "POWBAR_GRID", sRow, "", "", "", "OVERLAY_ICON=unhide");        
            SetLocalInt(OBJECT_SELF, POWER_ATTACK_MODE_ACTIVE, nNewMode);
            SendMessageToPC(OBJECT_SELF, "Power Attack intensity set to "+sAmount+".");
        }
    }
}
