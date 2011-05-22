//::///////////////////////////////////////////////
//:: Summon Huge Elemental
//:: x0_s3_summonelem
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////
/*
    This spell is used for the various elemental-summoning
    items.
    It does not consider metamagic as it is only used for
    item properties.
*/
//:://////////////////////////////////////////////
//:: Created By: Nathaniel Blumberg
//:: Created On: 12/13/02
//:://////////////////////////////////////////////
//:: Latest Update: Andrew Nobbs April 9, 2003
//:: AFW-OEI 05/31/2006:
//::	Updated creature blueprints.
//::	Changed duration to 10 minutes

void main()
{
    // Level 1: Air elemental
    // Level 2: Water elemental
    // Level 3: Earth elemental
    // Level 4: Fire elemental

    //Declare major variables
    object oCaster = OBJECT_SELF;
    string sResRef = "c_elmair";
    int nLevel = GetCasterLevel(oCaster) - 4;
    float fDuration = 600.0; // Ten minutes
    
    // Figure out which creature to summon
    switch (nLevel)
    {
        case 1: sResRef = "c_elmair"; break;
        case 2: sResRef = "c_elmwater"; break;
        case 3: sResRef = "c_elmearth"; break;
        case 4: sResRef = "c_elmfire"; break;
		case 16: sResRef = "c_orglash"; break;
    }

    // 0.5 sec delay between VFX and creature creation
    effect eSummon = EffectSummonCreature(sResRef, VFX_FNF_SUMMON_MONSTER_3, 0.5);

    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), fDuration);
}