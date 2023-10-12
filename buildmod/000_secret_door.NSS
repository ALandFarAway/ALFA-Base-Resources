// Written by Saaz of ALFA
// Put this script OnEnter.
// ***000_secret_door***
// Spot = 17                  find skill #s on Skills.2da
// Search = 14
// Survival = 29
// Knowledge Dungeon = 33

#include "acr_trigger_i"
#include "acr_skills_i"
#include "acr_spawn_i"

const string SKILL_VAR = "nSkill"; // integer nSkill
const string SKILL_DC_VAR = "nDC"; // integer nDC
const string RESREF_VAR = "sResRef"; //string sResRef
const string WP_TAG_VAR = "sWayPointTag"; //string sWayPointTag

void main()
{
ACR_TriggerOnEnter();

    object oTarget;
    object oSpawn;

    // Get the creature who triggered this event.
    object oPC = GetEnteringObject();

    // Only fire for (real) PCs.
    if ( !GetIsPC(oPC)  ||  GetIsDMPossessed(oPC) )
        return;

    // Abort if a skill check is failed.
    if ( d20() + GetSkillRank(GetLocalInt(OBJECT_SELF,SKILL_VAR), oPC) < GetLocalInt(OBJECT_SELF,SKILL_DC_VAR) )
        return;

    // Spawn "secret door".
    oTarget = GetWaypointByTag(GetLocalString(OBJECT_SELF,WP_TAG_VAR));
    oSpawn = CreateObject(OBJECT_TYPE_PLACEABLE,GetLocalString(OBJECT_SELF,RESREF_VAR), GetLocation(oTarget));
}