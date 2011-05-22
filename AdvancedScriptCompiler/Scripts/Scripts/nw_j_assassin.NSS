//::///////////////////////////////////////////////
//:: TEMPLATES: Assassin Plot Header
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By:  Brent
//:: Created On:  December
//:://////////////////////////////////////////////



//::///////////////////////////////////////////////
//:: GetP(arty)LocalInt
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Scans through all players in the party, to
    treat them all as 'one person' for the purposes
    of most plots. Makes our plots more multiplayer friendly.
*/
//:://////////////////////////////////////////////
//:: Created By: John
//:: Created On:
//:://////////////////////////////////////////////
int aGetPLocalInt(object oPC,string sLocalName)
{
    int nValue = 0;
    object oMember;

    oMember = GetFirstFactionMember(oPC);

    while (GetIsObjectValid(oMember))
    {
        if (GetLocalInt(oPC,sLocalName) > nValue)
        {
            nValue = GetLocalInt(oMember,sLocalName);
        }
        oMember = GetNextFactionMember(oPC);
    }

    return nValue;
}
//::///////////////////////////////////////////////
//:: SetP(arty)LocalInt
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: John
//:: Created On:
//:://////////////////////////////////////////////
void aSetPLocalInt(object oPC,string sLocalName, int nValue)
{
    object oMember;

    oMember = GetFirstFactionMember(oPC);

    while (GetIsObjectValid(oMember))
    {
        SetLocalInt(oMember,sLocalName,nValue);
         oMember = GetNextFactionMember(oPC);
    }

    return;
}



//::///////////////////////////////////////////////
//:: Global
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
 this returns the object where
 plot globals for this plot are suppose
 to be stored

*/
//:://////////////////////////////////////////////
//:: Created By:   Brent
//:: Created On:   December
//:://////////////////////////////////////////////

object Global()
{
    return GetLocalObject(OBJECT_SELF,"NW_J_MYGLOBALS");
}

//::///////////////////////////////////////////////
//:: SetGlobal
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Sets where all the globals for this plot
   are going to be stored.
*/
//:://////////////////////////////////////////////
//:: Created By:  Brent
//:: Created On:  December
//:://////////////////////////////////////////////

void SetGlobal(object oTarget, object oGlobal)
{
    SetLocalObject(oTarget,"NW_J_MYGLOBALS", oGlobal);
}
//::///////////////////////////////////////////////
//:: SetPlotToken
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Sets the plot token to a value the user wants.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
void SetPlotToken(int nID)
{
    SetLocalInt(Global(), "NW_J_PLOTTOKEN_1", nID);
}

//::///////////////////////////////////////////////
//:: GetPlotToken
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns the ID of the plot token.
    Remember, if this gets changed, then the
    dialog use of this token has to change as well.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
int GetPlotToken()
{
    return GetLocalInt(Global(), "NW_J_PLOTTOKEN_1");
}
//::///////////////////////////////////////////////
//:: SetPersonalItem
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
void SetPersonalItem(string sTag)
{
   SetLocalString(Global(), "NW_J_THE_PERSONAL_ITEM", sTag);
}

//::///////////////////////////////////////////////
//:: GetPersonalItem
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

string GetPersonalItem()
{
    return GetLocalString(Global(), "NW_J_THE_PERSONAL_ITEM");
}
//::///////////////////////////////////////////////
//:: Create Personal Item
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void CreatePersonalItemOn(object o)
{
    CreateItemOnObject(GetPersonalItem(),o);
}

//::///////////////////////////////////////////////
//:: PlayerHasPersonalItem
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns true if the player has the personal item
    of the assassination victim.
*/
//:://////////////////////////////////////////////
//:: Created By:  Brent
//:: Created On:  December 2001
//:://////////////////////////////////////////////

int PlayerHasPersonalItem(object oPC)
{
    return GetIsObjectValid(GetItemPossessedBy(oPC,GetPersonalItem()));
}

//::///////////////////////////////////////////////
//:: GivePlayerPersonalItem
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Gives the personal item of the victim
    to the player.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void GivePlayerPersonalItem(object oPC)
{
    object oRing = GetItemPossessedBy(OBJECT_SELF,GetPersonalItem());
    if (GetIsObjectValid(oRing) == TRUE)
    {
        ActionGiveItem(oRing, oPC);
    }
    else
    {
        CreateItemOnObject(GetPersonalItem(), oPC);
    }
}

//::///////////////////////////////////////////////
//:: SetPlotTag
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void SetPlotTag(string sTag)
{
    SetLocalString(Global(), "NW_J_ASSASSIN_PLOT_TAG", sTag);
}
//::///////////////////////////////////////////////
//:: GetPlotTag
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

string GetPlotTag()
{
    return GetLocalString(Global(), "NW_J_ASSASSIN_PLOT_TAG");
}

//::///////////////////////////////////////////////
//:: PCAcceptedPlot
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns true if the player accepted the assassin
    plot.
*/
//:://////////////////////////////////////////////
//:: Created By:   Brent
//:: Created On:   December
//:://////////////////////////////////////////////

int PCAcceptedPlot(object oPC)
{
    return aGetPLocalInt(oPC,"NW_Assa_Plot_Accepted");
}
//::///////////////////////////////////////////////
//:: SetAssassinHead
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void SetAssassinHead(string sTag)
{
    SetLocalString(Global(),"NW_J_ASSASSIN_HEAD_TAG", sTag);
}
//::///////////////////////////////////////////////
//:: GetAssassinHead
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     Returns the tag for the assassin head
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

string GetAssassinHead()
{
    return GetLocalString(Global(), "NW_J_ASSASSIN_HEAD_TAG");
}
//::///////////////////////////////////////////////
//:: PlayerHasHead
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns true if the player has the head
    of the assassination victim.
*/
//:://////////////////////////////////////////////
//:: Created By:  Brent
//:: Created On:  December 2001
//:://////////////////////////////////////////////

int PlayerHasHead(object oPC)
{
    return GetIsObjectValid(GetItemPossessedBy(oPC,GetAssassinHead()));
}

//::///////////////////////////////////////////////
//:: SetVictim
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Sets the victim object.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: December
//:://////////////////////////////////////////////

void SetVictim(object oVictim)
{
   SetLocalObject(Global(),"NW_J_ASSASSIN_VICTIM", oVictim);
}

//::///////////////////////////////////////////////
//:: GetVictim
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns the victim's object
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

object GetVictim()
{
    return GetLocalObject(Global(),"NW_J_ASSASSIN_VICTIM");
}

//::///////////////////////////////////////////////
//:: VictimDead
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
      Returns true if the assassin plot victim
      is dead.
*/
//:://////////////////////////////////////////////
//:: Created By:   Brent
//:: Created On:   December 2001
//:://////////////////////////////////////////////

int VictimDead()
{
        if (!GetIsObjectValid(GetVictim()))
        {
            return TRUE;
        }
            return FALSE;
}

//::///////////////////////////////////////////////
//:: SetVictim
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Sets the victim object.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: December
//:://////////////////////////////////////////////

void SetPlotGiver(object oVictim)
{
   SetLocalObject(Global(),"NW_J_ASSASSIN_PLOTGIVER", oVictim);
}

//::///////////////////////////////////////////////
//:: GetVictim
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns the victim's object
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

object GetPlotGiver()
{
    return GetLocalObject(Global(),"NW_J_ASSASSIN_PLOTGIVER");
}

//::///////////////////////////////////////////////
//:: VictimDead
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
      Returns true if the assassin plot victim
      is dead.
*/
//:://////////////////////////////////////////////
//:: Created By:   Brent
//:: Created On:   December 2001
//:://////////////////////////////////////////////

int PlotGiverDead()
{
        if (!GetIsObjectValid(GetPlotGiver()))
        {
            return TRUE;
        }
            return FALSE;
}
//::///////////////////////////////////////////////
//:: VictimDeadButNoItems
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns true if the victim is dead but
    oPC does not carrying either the head or
    the personal item.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

int VictimDeadButNoItems(object oPC)
{
    object oItem1=GetItemPossessedBy(oPC,GetPersonalItem());
    object oItem2=GetItemPossessedBy(oPC,GetAssassinHead());
    if ((!GetIsObjectValid(oItem1)) && (!GetIsObjectValid(oItem2)))
    {
        if (VictimDead() == TRUE)
        {
            return TRUE;
        }
        return FALSE;
    }
    return FALSE;
}

//::///////////////////////////////////////////////
//:: SetDoubleCrosserName
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Sets the name of the double crosser as a plot
    token.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void SetDoubleCrosserName(object oPC)
{
    SetCustomToken(GetPlotToken(),GetName(oPC));
}
