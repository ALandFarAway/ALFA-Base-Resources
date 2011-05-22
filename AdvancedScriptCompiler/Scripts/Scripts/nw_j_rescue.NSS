//::///////////////////////////////////////////////
//:: TEMPLATES: Rescue Plot Header
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By:  Brent
//:: Created On:  December
//:://////////////////////////////////////////////



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
void SetPlotRing(string sTag)
{
    SetLocalString(Global(), "NW_J_RESCUE_RING", sTag);
}
string GetPlotRingTag()
{
    return GetLocalString(Global(), "NW_J_RESCUE_RING");
}
void SetPlotJournal(string sTag)
{
    SetLocalString(Global(), "NW_J_RESCUE_JOURNAL", sTag);
}
string GetPlotJournal()
{
    return GetLocalString(Global(), "NW_J_RESCUE_JOURNAL");
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
//:: SetPrisoner
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
void SetPrisoner(object oPrisoner)
{
    SetLocalObject(Global(), "NW_J_MYPRISONER", oPrisoner);
}
//::///////////////////////////////////////////////
//:: GetPrisoner
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     Returns the object ID of the person to
     be rescued.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////


object GetPrisoner()
{
    return GetLocalObject(Global(), "NW_J_MYPRISONER");
}

//::///////////////////////////////////////////////
//:: SetRingGivenTo
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     Stores the player that received the ring.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: December
//:://////////////////////////////////////////////

void SetRingGivenTo(object oPC)
{
    SetLocalObject(Global(),"NW_Resc_RingGiven",oPC);
}

//::///////////////////////////////////////////////
//:: GetRingGivenTo
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     Returns the object
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

object GetRingGivenTo()
{
    return GetLocalObject(Global(),"NW_Resc_RingGiven");
}
//::///////////////////////////////////////////////
//:: GiveRingToPlayer
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Gives Ring to player and sets appropriate locals.
*/
//:://////////////////////////////////////////////
//:: Created By:  Brent
//:: Created On:  December
//:://////////////////////////////////////////////

void GiveRingToPlayer(object oPC)
{
    CreateItemOnObject(GetPlotRingTag(),oPC);
    SetRingGivenTo(oPC);
    SetCustomToken(GetPlotToken(),GetName(oPC));
}
//::///////////////////////////////////////////////
//:: PlayerHasRing
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: December
//:://////////////////////////////////////////////

int PlayerHasRing(object oPC)
{
    return GetIsObjectValid(GetItemPossessedBy(GetPCSpeaker(),GetPlotRingTag()));
}
