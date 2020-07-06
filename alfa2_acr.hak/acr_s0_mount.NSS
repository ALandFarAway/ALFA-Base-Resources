//::///////////////////////////////////////////////
//:: [Mount]
//:: [acr_s0_mount.NSS]
//:: Copyright (c) 2020 A Land Far Away
//::///////////////////////////////////////////////
/*
   Summons a magical light horse that can serve
   as a mount for the duration of the spell.
*/

#include "acr_movement_i"
#include "acr_spells_i"


// How often verify_is_in_effect is polled to confirm horse should still exist
const float VERIFY_IS_IN_EFFECT_POLL_DURATION = 60.0f;

// Polling for checking that horse is spawned in via other scripts
const float HORSE_SPAWN_WAIT_DURATION = 0.2f;

// Spell ID for Mount
const int SPELL_MOUNT = 3088;

// Made up VFX for tracking Mount spell duration
const int MOUNT_TRACKING_EFFECT = 34060;


string get_random_horse_resref()
{
    return "acr_horse0" + IntToString(Random(3) + 1);
}


// Checks if the spell is still in effect; if not, unsummons horse
void verify_is_in_effect(object oCaster, object oHorse, object oHorseTool)
{
    int bMountEffectActive = FALSE;
    effect e;

    // (For now) if caster doesn't exist, remove
    if (!GetIsObjectValid(oCaster)) {
        despawn_horse(oCaster, oHorse, oHorseTool);
        return;
    }

    // Find mount effect
    for (e = GetFirstEffect(oCaster); GetIsEffectValid(e); e = GetNextEffect(oCaster)) {
        if (GetEffectSpellId(e) == SPELL_MOUNT) {
            bMountEffectActive = TRUE;
            break;
        }
    }

    if (!bMountEffectActive) {
        ApplyEffectToObject(
            DURATION_TYPE_INSTANT,
            EffectVisualEffect(VFX_IMP_UNSUMMON),
            oHorse
        );
        DestroyHorse(oCaster, oHorseTool);
        return;
    }

    // Delay for subsequent check
    DelayCommand(
        VERIFY_IS_IN_EFFECT_POLL_DURATION,
        verify_is_in_effect(oCaster, oHorse, oHorseTool)
    );
}


void setup_horse(object oCaster, object oHorseTool)
{
    object oHorse;

    oHorse = GetLocalObject(oHorseTool, ACR_HORSE_OBJECT);

    // Horse is found, now we can cease setup
    if (GetIsObjectValid(oHorse)) {
        ApplyEffectToObject(
            DURATION_TYPE_INSTANT,
            EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1),
            oHorse
        );

        // Set up DelayCommand loop to remove once spell expires
        DelayCommand(
            VERIFY_IS_IN_EFFECT_POLL_DURATION,
            verify_is_in_effect(oCaster, oHorse, oHorseTool)
        );
        return;
    }

    // Setup isn't ready yet, wait again
    DelayCommand(
        HORSE_SPAWN_WAIT_DURATION,
        setup_horse(oCaster, oHorseTool)
    );
}


void main()
{
    effect e;
    object oCaster, oTarget, oHorseTool;
    int nCasterLevel;
    float fDuration;

    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!ACR_PrecastEvent()) {
        return;
    }

    oCaster = OBJECT_SELF;
    oTarget = OBJECT_SELF;  // Target is always the caster, no matter what

    // Prevent an additional mount being summoned
    for (e = GetFirstEffect(oCaster); GetIsEffectValid(e); e = GetNextEffect(oCaster)) {
        if (GetEffectSpellId(e) == SPELL_MOUNT) {
            SendMessageToPC(oCaster, "You already have a mount summoned!");
            return;
        }
    }

    // Signal event successful
    SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), FALSE));

    nCasterLevel = ACR_GetCorrectCasterLevel(OBJECT_SELF);
    fDuration = ACR_GetSpellDuration(oCaster, ACR_DURATION_TYPE_PER_CL, ACR_DURATION_1H * 2);

    // Create horse object on caster
    oHorseTool = CreateItemOnObject(get_random_horse_resref(), oCaster);

    // Set housekeeping/anti-exploit stuff on horse object
    SetDroppableFlag(oHorseTool, FALSE);
    SetPlotFlag(oHorseTool, TRUE);
    SetName(oHorseTool, "(( OOC )) Summoned Horse");
    SetLocalInt(oHorseTool, ACR_HORSE_SUMMONED, TRUE);

    // Create an invisible effect to track this spell
    ApplyEffectToObject(
        DURATION_TYPE_TEMPORARY,
        EffectVisualEffect(MOUNT_TRACKING_EFFECT),
        oCaster,
        fDuration
    );

    // Delay setup until the horse actually spawns
    DelayCommand(
        HORSE_SPAWN_WAIT_DURATION,
        setup_horse(oCaster, oHorseTool)
    );
}
