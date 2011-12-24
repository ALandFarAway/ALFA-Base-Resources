// NW_C2_DEFAULT9
/*
    Default OnSpawn handler
 
    To create customized spawn scripts, use the "Custom OnSpawn" script template. 
*/
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/11/2002
//:://////////////////////////////////////////////////
//:: Updated 2003-08-20 Georg Zoeller: Added check for variables to active spawn in conditions without changing the spawnscript
// ChazM 6/20/05 ambient anims flag set on spawn for encounter cratures.
// ChazM 1/6/06 modified call to WalkWayPoints()
// DBR 2/03/06  Added option for a spawn script (AI stuff, but also handy in general)
// ChazM 8/22/06 Removed reference to "kinc_globals".
// ChazM 3/8/07 Added campaign level creature spawn modifications script.  Moved excess commented code out to template.
// ChazM 4/5/07 Incorporeal creatures immune to non magic weapons
// JSH-OEI 5/1/08 - Check creature type before spawning random treasure.

#include "x0_i0_anims"
#include "x0_i0_treasure"
#include "x2_inc_switches"

void main()
{
    // Run this campaign's standard creature spawn modifications script (set in module load)
    string sScriptSpawnCreature = GetGlobalString("N2_SCRIPT_SPAWN_CREATURE");
    if (sScriptSpawnCreature != "")
    {
		ExecuteScript(sScriptSpawnCreature, OBJECT_SELF);
    }

    // ***** Spawn-In Conditions ***** //
    // See x2_inc_switches for more information about these
    
    // Enable stealth mode by setting a variable on the creature
    // Great for ambushes
    if (GetCreatureFlag(OBJECT_SELF, CREATURE_VAR_USE_SPAWN_STEALTH) == TRUE)
    {
        SetSpawnInCondition(NW_FLAG_STEALTH);
    }
    
    // Make creature enter search mode after spawning by setting a variable
    // Great for guards, etc
    if (GetCreatureFlag(OBJECT_SELF, CREATURE_VAR_USE_SPAWN_SEARCH) == TRUE)
    {
        SetSpawnInCondition(NW_FLAG_SEARCH);
    }

    // Enable immobile ambient animations by setting a variable
    if (GetCreatureFlag(OBJECT_SELF, CREATURE_VAR_USE_SPAWN_AMBIENT_IMMOBILE) == TRUE)
    {
        SetSpawnInCondition(NW_FLAG_IMMOBILE_AMBIENT_ANIMATIONS);
    }

    // Enable mobile ambient animations by setting a variable
    if (GetCreatureFlag(OBJECT_SELF, CREATURE_VAR_USE_SPAWN_AMBIENT) == TRUE)
    {
        SetSpawnInCondition(NW_FLAG_AMBIENT_ANIMATIONS);
    }

    // ***** DEFAULT GENERIC BEHAVIOR ***** //
    // * Goes through and sets up which shouts the NPC will listen to.
    SetListeningPatterns();

    // * Walk among a set of waypoints if they exist.
    // * 1. Find waypoints with the tag "WP_" + NPC TAG + "_##" and walk
    // *    among them in order.
    // * 2. If the tag of the Way Point is "POST_" + NPC TAG, stay there
    // *    and return to it after combat.
    //
    // * If "NW_FLAG_DAY_NIGHT_POSTING" is set, you can also
    // * create waypoints with the tags "WN_" + NPC Tag + "_##"
    // * and those will be walked at night. (The standard waypoints
    // * will be walked during the day.)
    // * The night "posting" waypoint tag is simply "NIGHT_" + NPC tag.
    WalkWayPoints(FALSE, "spawn");
    
    //* Create a small amount of treasure on the creature
    if (GetLocalInt(GetModule(), "X2_L_NOTREASURE") == FALSE
        && GetLocalInt(OBJECT_SELF, "X2_L_NOTREASURE") == FALSE
		&& GetRacialType(OBJECT_SELF) != RACIAL_TYPE_ANIMAL
		&& GetRacialType(OBJECT_SELF) != RACIAL_TYPE_BEAST
		&& GetRacialType(OBJECT_SELF) != RACIAL_TYPE_CONSTRUCT
		&& GetRacialType(OBJECT_SELF) != RACIAL_TYPE_ELEMENTAL
		&& GetRacialType(OBJECT_SELF) != RACIAL_TYPE_VERMIN)
    {
		if (GetChallengeRating(OBJECT_SELF) <= 5.0)
		{
        	CTG_GenerateNPCTreasure(TREASURE_TYPE_LOW, OBJECT_SELF);
		}
		else if (GetChallengeRating(OBJECT_SELF) >5.0 && GetChallengeRating(OBJECT_SELF) <=10.0)
		{
			CTG_GenerateNPCTreasure(TREASURE_TYPE_MED, OBJECT_SELF);
		}
		else
		{
			CTG_GenerateNPCTreasure(TREASURE_TYPE_HIGH, OBJECT_SELF);
		}
    }
    
    // encounter creatures use ambient animations
    if (GetIsEncounterCreature())
		SetSpawnInCondition(NW_FLAG_AMBIENT_ANIMATIONS, TRUE);

    // * If Incorporeal, apply changes
    if (GetCreatureFlag(OBJECT_SELF, CREATURE_VAR_IS_INCORPOREAL) == TRUE)
    {
        effect eConceal = EffectConcealment(50, MISS_CHANCE_TYPE_NORMAL);
        eConceal = ExtraordinaryEffect(eConceal);
        effect eGhost = EffectCutsceneGhost();
        eGhost = ExtraordinaryEffect(eGhost);
        effect eImmuneToNonMagicWeapons = EffectDamageReduction(1000, DAMAGE_POWER_PLUS_ONE, 0, DR_TYPE_MAGICBONUS);
        eImmuneToNonMagicWeapons = ExtraordinaryEffect(eImmuneToNonMagicWeapons);
		
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eConceal, OBJECT_SELF);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eGhost, OBJECT_SELF);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eImmuneToNonMagicWeapons, OBJECT_SELF);
    }	
	
	if (GetLocalInt(OBJECT_SELF, "NX2_NO_ORIENT_ON_DIALOG"))
		SetOrientOnDialog(OBJECT_SELF, FALSE);
    	
	//DBR 2/03/06 - added option for a spawn script (ease of AI hookup)
	string sSpawnScript=GetLocalString(OBJECT_SELF,"SpawnScript");
	if (sSpawnScript!="")
		ExecuteScript(sSpawnScript,OBJECT_SELF);
		

}