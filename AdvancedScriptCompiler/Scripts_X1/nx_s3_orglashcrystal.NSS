// Orglash Crystal
// nx_s3_orglashcrystal
//
// Summons the orglash when the crystal is used.
//
// JSH 1/12/07

void main()
{
    object oCaster = OBJECT_SELF;
    string sResRef = "c_orglash";
    int nLevel = GetCasterLevel(oCaster) - 4;
    float fDuration = 600.0; // Ten minutes
    
    // 0.5 sec delay between VFX and creature creation
    effect eSummon = EffectSummonCreature(sResRef, VFX_FNF_SUMMON_MONSTER_3, 0.5);

    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), fDuration);
}