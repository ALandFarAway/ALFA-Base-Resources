//::///////////////////////////////////////////////
//:: Summon Undead
//:: X2_S2_SumUndead
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     The level of the Pale Master determines the
     type of undead that is summoned.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Feb 05, 2003
//:: Updated By: Georg Zoeller, Oct 2003
//:://////////////////////////////////////////////
//:: AFW-OEI 06/02/2006:
//::	Update creature blueprints

void PMUpgradeSummon(object oSelf, string sScript)
{
    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED,oSelf);
    ExecuteScript ( sScript, oSummon);
}

void main()
{
    //Declare major variables
    int nCasterLevel = GetLevelByClass(CLASS_TYPE_PALEMASTER,OBJECT_SELF);
    int nDuration = nCasterLevel;


    //effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
    effect eSummon;
    //Summon the appropriate creature based on the summoner level
    if (nCasterLevel <= 4)
    {
        //Ghoul
        eSummon = EffectSummonCreature("c_ghoul",VFX_FNF_SUMMON_UNDEAD,0.0f,0);
    }
    else if (nCasterLevel <= 6)
    {
        //Ghast
        eSummon = EffectSummonCreature("c_ghast",VFX_FNF_SUMMON_UNDEAD,0.0f,0);
    }
    else if (nCasterLevel <= 8)
    {
        //Mummy
        eSummon = EffectSummonCreature("c_mummy",VFX_FNF_SUMMON_UNDEAD,0.0f,1);
    }
    else if (nCasterLevel <= 10)
    {
        //Mummy Lord
        eSummon = EffectSummonCreature("c_mummylord",VFX_FNF_SUMMON_UNDEAD,0.0f,1);
    }
    // * Apply the summon visual and summon the two undead.
    // * ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_FNF_LOS_EVIL_10),GetSpellTargetLocation());
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), HoursToSeconds(nDuration));

    // * If the character has a special pale master item equipped (variable set via OnEquip)
    // * run a script on the summoned monster.
    string sScript = GetLocalString(OBJECT_SELF,"X2_S_PM_SPECIAL_ITEM");
    if (sScript != "")
    {
        object oSelf = OBJECT_SELF;
        DelayCommand(1.0,PMUpgradeSummon(oSelf,sScript));
    }
}
