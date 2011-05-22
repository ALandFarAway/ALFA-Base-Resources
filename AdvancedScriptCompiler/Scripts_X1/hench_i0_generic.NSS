/*

    Companion and Monster AI

    This file contains miscellaneous functions used by
    many scripts.

*/

#include "nw_i0_generic"
#include "x0_i0_voice"
#include "hench_i0_strings"
#include "hench_i0_options"

//void main() {    }


// This constant somewhat matches taking a henchmen hit dice and converting to CR rating
const float HENCH_HITDICE_TO_CR = 0.7;

// hitpoints threshold for death
const int HENCH_BLEED_NEGHPS = -10;
const float HENCH_MAX_SNEAK_ATTACK_DISTANCE     = 10.0;

// stored healing information state
const int HENCH_HEAL_SELF_UNKNOWN   = 0;
const int HENCH_HEAL_SELF_CANT      = 1;
const int HENCH_HEAL_SELF_WAIT      = 2;
const int HENCH_HEAL_SELF_IN_PROG   = 3;
const string HENCH_HEAL_SELF_STATE  = "HenchHealSelfState";

// new behavior settings used by this AI
const int HENCH_ASC_DISABLE_AUTO_WEAPON_SWITCH  =   0x00000001; // only for associates
const int HENCH_ASC_USE_RANGED_WEAPON           =   0x00000002; // this is not actually saved, use NW_ASC_USE_RANGED_WEAPON
const int HENCH_ASC_BEEN_SET_ONCE               =   0x00000002; // reuse of ranged weapon bit, this is set once to indicate basic flags have been set
const int HENCH_ASC_MELEE_DISTANCE_NEAR         =   0x00000004; // pick only one of the melee distance options
const int HENCH_ASC_MELEE_DISTANCE_MED          =   0x00000008;
const int HENCH_ASC_MELEE_DISTANCE_FAR          =   0x00000010;
const int HENCH_ASC_ENABLE_BACK_AWAY            =   0x00000020; // creature will try to avoid melee combat
const int HENCH_ASC_DISABLE_SUMMONS             =   0x00000040; // creature will not summon allies
const int HENCH_ASC_ENABLE_DUAL_WIELDING        =   0x00000080; // creature will dual wield (setting not needed if creature has two weapon fighting feat)
const int HENCH_ASC_DISABLE_DUAL_WIELDING       =   0x00000100; // creature will not dual wield
const int HENCH_ASC_DISABLE_DUAL_HEAVY          =   0x00000200; // only use light off hand weapons
const int HENCH_ASC_DISABLE_SHIELD_USE          =   0x00000400; // don't use a shield even if you have shield feats
const int HENCH_ASC_RECOVER_TRAPS               =   0x00000800; // only for associates
const int HENCH_ASC_AUTO_OPEN_LOCKS             =   0x00001000; // only for associates
const int HENCH_ASC_AUTO_PICKUP                 =   0x00002000; // only for companions
const int HENCH_ASC_DISABLE_POLYMORPH           =   0x00004000; // don't attempt polymorph or stone/ironskin
const int HENCH_ASC_DISABLE_INFINITE_BUFF       =   0x00008000; // only for associates
const int HENCH_ASC_ENABLE_HEALING_ITEM_USE     =   0x00010000; // only for associates
const int HENCH_ASC_DISABLE_AUTO_HIDE           =   0x00020000; // creature will not use stealth in combat or when master uses stealth
const int HENCH_ASC_GUARD_DISTANCE_NEAR         =   0x00040000; // only for associates
const int HENCH_ASC_GUARD_DISTANCE_MED          =   0x00080000; // only for associates
const int HENCH_ASC_GUARD_DISTANCE_FAR          =   0x00100000; // only for associates
const int HENCH_ASC_GUARD_DISTANCE_DEFAULT      =   0x00140000; // special for use in case statement
const int HENCH_ASC_MELEE_DISTANCE_ANY          =   0x00200000; // creature will go to melee if any members of party are melee with target
const int HENCH_ASC_NO_MELEE_ATTACKS            =   0x00400000; // creature will not use melee attacks
const int HENCH_ASC_NON_SAFE_RECOVER_TRAPS      =   0x00800000; // only for associates
//const int HENCH_ASC_IGNORE_SHOUTS             =   0x01000000; // not implemented, creature will not respond to shouts, only for associates
//const int HENCH_ASC_WEAPON_ATTACK_BONUS           =   0x02000000; // not implemented, equip weapons based on attack bonus

// in addition these standard associate settings work for monsters also -
// NW_ASC_HEAL_AT_75, NW_ASC_HEAL_AT_50, NW_ASC_HEAL_AT_25   percentage to heal at

// state options for entire party (stored on PC)
const int HENCH_PARTY_UNEQUIP_WEAPONS           =   0x00000001; // party members will unequip weapons outside of combat
const int HENCH_PARTY_SUMMON_FAMILIARS          =   0x00000002; // party members will summon familiars outside of combat
const int HENCH_PARTY_SUMMON_COMPANIONS         =   0x00000004; // party members will summon animal companions outside of combat
const int HENCH_PARTY_LOW_ALLY_DAMAGE         	=   0x00000008; // party members avoid giving damage to allies
const int HENCH_PARTY_MEDIUM_ALLY_DAMAGE       	=   0x00000010; // party members give small amount of damage to allies
const int HENCH_PARTY_HIGH_ALLY_DAMAGE       	=   0x00000020; // party members give moderate amount of damage to allies
const int HENCH_PARTY_DISABLE_PEACEFUL_MODE		=   0x00000040; // don't turn on peaceful mode with follow command
const int HENCH_PARTY_DISABLE_SELF_HEAL_OR_BUFF	=   0x00000080; // disable group buff and heal from having PC cast


// missing action modes
const int HENCH_ACTION_MODE_TRACKING            = 14;   // tracking action mode

// missing actions
const int HENCH_ACTION_MOVETOLOCATION           = 43;   // seems to occur when moving to location


// constants for standard NWN2 settings
const string sHenchStealthMode = "X2_HENCH_STEALTH_MODE";
const string sHenchStopCasting = "X2_L_STOPCASTING";
const string sHenchDontDispel = "X2_HENCH_DO_NOT_DISPEL";

const string henchAssociateSettings = "HENCH_ASSOCIATE_SETTINGS";
const string henchPartySettings = "HENCH_PARTY_SETTINGS";

const string sHenchDontAttackFlag = "DoNotAttack";
const string sHenchScoutingFlag = "Scouting";
const string sHenchScoutTarget = "ScoutTarget";
const string sHenchScoutMode = "ScoutMode";
const string sHenchRunningAway = "RunningAway";


// negative effect bit flags for a creature
const int HENCH_EFFECT_TYPE_NONE                = 0x0;
const int HENCH_EFFECT_TYPE_ENTANGLE            = 0x1;
const int HENCH_EFFECT_TYPE_PARALYZE            = 0x2;
const int HENCH_EFFECT_TYPE_DEAF                = 0x4;
const int HENCH_EFFECT_TYPE_BLINDNESS           = 0x8;
const int HENCH_EFFECT_TYPE_CURSE               = 0x10;
const int HENCH_EFFECT_TYPE_SLEEP               = 0x20;
const int HENCH_EFFECT_TYPE_CHARMED             = 0x40;
const int HENCH_EFFECT_TYPE_CONFUSED            = 0x80;
const int HENCH_EFFECT_TYPE_FRIGHTENED          = 0x100;
const int HENCH_EFFECT_TYPE_DOMINATED           = 0x200;
const int HENCH_EFFECT_TYPE_DAZED               = 0x400;
const int HENCH_EFFECT_TYPE_POISON              = 0x800;
const int HENCH_EFFECT_TYPE_DISEASE             = 0x1000;
const int HENCH_EFFECT_TYPE_SILENCE             = 0x2000;
const int HENCH_EFFECT_TYPE_SLOW                = 0x4000;
const int HENCH_EFFECT_TYPE_ABILITY_DECREASE    = 0x8000;
const int HENCH_EFFECT_TYPE_DAMAGE_DECREASE     = 0x10000;
const int HENCH_EFFECT_TYPE_ATTACK_DECREASE     = 0x20000;
const int HENCH_EFFECT_TYPE_SKILL_DECREASE      = 0x40000;
const int HENCH_EFFECT_TYPE_STUNNED             = 0x100000;
const int HENCH_EFFECT_TYPE_PETRIFY             = 0x200000;
const int HENCH_EFFECT_TYPE_MOVEMENT_SPEED_DECREASE = 0x400000;
const int HENCH_EFFECT_TYPE_DEATH               = 0x800000;
const int HENCH_EFFECT_TYPE_NEGATIVELEVEL       = 0x1000000;
const int HENCH_EFFECT_TYPE_AC_DECREASE         = 0x2000000;
const int HENCH_EFFECT_TYPE_SAVING_THROW_DECREASE = 0x4000000;
//const int HENCH_EFFECT_TYPE_KNOCKDOWN = 0x8000000;
const int HENCH_EFFECT_TYPE_DARKNESS            = 0x10000000;
const int HENCH_EFFECT_TYPE_MESMERIZE           = 0x20000000;
const int HENCH_EFFECT_TYPE_SPELL_FAILURE       = 0x40000000;
const int HENCH_EFFECT_TYPE_CUTSCENE_PARALYZE   = 0x80000000;
const int HENCH_EFFECT_DISABLED = 0x203005e2; /*HENCH_EFFECT_TYPE_PARALYZE | HENCH_EFFECT_TYPE_STUNNED |
    HENCH_EFFECT_TYPE_FRIGHTENED | HENCH_EFFECT_TYPE_SLEEP| HENCH_EFFECT_TYPE_DAZED |
    HENCH_EFFECT_TYPE_CONFUSED | HENCH_EFFECT_TYPE_TURNED | HENCH_EFFECT_TYPE_PETRIFY |
    HENCH_EFFECT_TYPE_MESMERIZE; */
const int HENCH_EFFECT_DISABLED_NO_PETRIFY = 0x201005e2; /*HENCH_EFFECT_TYPE_PARALYZE | HENCH_EFFECT_TYPE_STUNNED |
    HENCH_EFFECT_TYPE_FRIGHTENED | HENCH_EFFECT_TYPE_SLEEP| HENCH_EFFECT_TYPE_DAZED |
    HENCH_EFFECT_TYPE_CONFUSED | HENCH_EFFECT_TYPE_TURNED |
    HENCH_EFFECT_TYPE_MESMERIZE; */
const int HENCH_EFFECT_IMPAIRED = 0x01404009; /*HENCH_EFFECT_TYPE_ENTANGLE | HENCH_EFFECT_TYPE_BLINDNESS |
    HENCH_EFFECT_TYPE_SLOW | HENCH_EFFECT_TYPE_MOVEMENT_SPEED_DECREASE | HENCH_EFFECT_TYPE_NEGATIVELEVEL*/
const int HENCH_EFFECT_DISABLED_OR_IMMOBILE = 0xa03005e3; /*HENCH_EFFECT_TYPE_PARALYZE | HENCH_EFFECT_TYPE_STUNNED |
    HENCH_EFFECT_TYPE_FRIGHTENED | HENCH_EFFECT_TYPE_SLEEP| HENCH_EFFECT_TYPE_DAZED |
    HENCH_EFFECT_TYPE_CONFUSED | HENCH_EFFECT_TYPE_TURNED | HENCH_EFFECT_TYPE_PETRIFY |
    HENCH_EFFECT_TYPE_MESMERIZE | HENCH_EFFECT_TYPE_CUTSCENE_PARALYZE | HENCH_EFFECT_TYPE_ENTANGLE; */
const int HENCH_EFFECT_IMMOBILE = 0x80000001; /* HENCH_EFFECT_TYPE_CUTSCENE_PARALYZE | HENCH_EFFECT_TYPE_ENTANGLE; */

// positive effect bit flags for a creature
const int HENCH_EFFECT_TYPE_AC_INCREASE         = 0x1;
const int HENCH_EFFECT_TYPE_REGENERATE          = 0x2;
const int HENCH_EFFECT_TYPE_ATTACK_INCREASE     = 0x4;
const int HENCH_EFFECT_TYPE_DAMAGE_REDUCTION    = 0x8;
const int HENCH_EFFECT_TYPE_HASTE               = 0x10;
const int HENCH_EFFECT_TYPE_TEMPORARY_HITPOINTS = 0x20;
const int HENCH_EFFECT_TYPE_SANCTUARY           = 0x40;
const int HENCH_EFFECT_TYPE_TIMESTOP            = 0x80;
const int HENCH_EFFECT_TYPE_SPELLLEVELABSORPTION = 0x100;
const int HENCH_EFFECT_TYPE_SAVING_THROW_INCREASE = 0x200;
const int HENCH_EFFECT_TYPE_CONCEALMENT         = 0x400;
//const int HENCH_EFFECT_TYPE_SUMMON = 0x800,     // not a "real" effect
const int HENCH_EFFECT_TYPE_DAMAGE_INCREASE     = 0x1000;
const int HENCH_EFFECT_TYPE_ABSORBDAMAGE        = 0x2000;
// new ones
const int HENCH_EFFECT_TYPE_ETHEREAL            = 0x4000;
const int HENCH_EFFECT_TYPE_INVISIBILITY        = 0x8000;
const int HENCH_EFFECT_TYPE_POLYMORPH           = 0x10000;
const int HENCH_EFFECT_TYPE_ULTRAVISION         = 0x20000;
const int HENCH_EFFECT_TYPE_TRUESEEING          = 0x40000;
const int HENCH_EFFECT_TYPE_WILDSHAPE           = 0x80000;
const int HENCH_EFFECT_TYPE_GREATER_INVIS       = 0x100000;
const int HENCH_EFFECT_TYPE_ELEMENTALSHIELD     = 0x200000;
const int HENCH_EFFECT_TYPE_ABILITY_INCREASE    = 0x400000;

const int HENCH_EFFECT_INVISIBLE = 0x0010c040; /* HENCH_EFFECT_TYPE_SANCTUARY | HENCH_EFFECT_TYPE_ETHEREAL | HENCH_EFFECT_TYPE_INVISIBILITY | HENCH_EFFECT_TYPE_GREATER_INVIS*/

// stored immunity and resist information on a creature
const string HENCH_DAMAGE_RESIST_STR = "HenchDamageResist";
const string HENCH_DAMAGE_IMMUNITY_STR = "HenchDamageImmunity";

const int HENCH_FLAGS_ALL_DAMAGE_TYPES  = 0x00000fff;   // DAMAGE_TYPE_FLAGS OR'ED
const int HENCH_FLAG_SPELL_IMMUNITY     = 0x00001000;
const int HENCH_FLAG_HASTE              = 0x00002000;
const int HENCH_FLAG_TRUE_SEEING        = 0x00004000;
const int HENCH_FLAG_REGENERATION       = 0x00008000;
const int HENCH_FLAG_FREE_MOVEMENT      = 0x00010000;
const int HENCH_FLAG_PROT_ELEM          = 0x00020000;
const int HENCH_FLAG_SPELL_MANTLE       = 0x00040000;

// cached effect information on creature
const string lastEffectQueryStr = "HenchLastEffectQuery";
const string curPostiveEffectsStr = "HenchCurPosEffects";
const string curNegativeEffectsStr = "HenchCurNegEffects";

const string abilityIncreaseStr = "HenchAbilityIncrease";
const string acIncreaseStr = "HenchACIncrease";
const int acIncreaseOffset = 6;
const string sPolymorphTypeStr = "HenchPolymorphType";

const string attackBonusStr = "HenchAttackBonus";
const string spellLevelProtStr = "HenchSpellLevelProtect";
const string damageInformationStr = "HenchDamageInformation";
const string rangedConcealmentStr = "HenchRangedConcealment";
const string meleeConcealmentStr = "HenchMeleeConcealment";
const string regenerationRateStr = "HenchRegenerationRate";

const int regenerateRateRounds = 4;

// global spell failure chance
float gfSpellFailureChance;


// As MyPrintString, but to screen instead of log
void Jug_Debug(string sString);

// gets all creature information
// for internal use only, use GetCreaturePosEffects, GetCreatureNegEffects, etc. instead
void InitializeCreatureInformationInternal(object oTarget);

// forces reset of creature information, only use on self once
void InitializeCreatureInformation(object oTarget);

// checks to see if cached creature information is stale
// for internal use only, use GetCreaturePosEffects, GetCreatureNegEffects, etc. instead
int GetIsOldCreatureInformation(object oTarget);

// gets bit flags of creature positive effects (HENCH_EFFECT_TYPE_*)
int GetCreaturePosEffects(object oTarget);

// gets bit flags of creature negative effects (HENCH_EFFECT_TYPE_*)
int GetCreatureNegEffects(object oTarget);

// gets the stat ability increase of a creature
int GetCreatureAbilityIncrease(object oTarget, int nAbilityType);

// gets the AC bonus by type for a creature
int GetCreatureACBonus(object oTarget, int nACType);

// get touch AC modifier of creature (does not include 10 base AC)
int GetTouchAC(object oTarget);

// gets unadjusted threat rating of a creature
float GetRawThreatRating(object oTarget);

// returns TRUE if racial type is a humanoid
int GetIsHumanoid(int nRacial);

// returns TRUE if creature can use items from their inventory
int GetCreatureUseItems(object oCreature);

// returns TRUE if the item property is present in any one of the equipped items
int GetCreatureHasItemProperty(int nItemProperty, object oCreature = OBJECT_SELF);

// set array access for objects
void SetObjectArray(object oSource, string sName, int iElem, object oElem);

// get array access for objects
object GetObjectArray(object oSource, string sName, int iElem);

// set array access for ints
void SetIntArray(object oSource, string sName, int iElem, int iState);

// get array access for ints
int GetIntArray(object oSource, string sName, int iElem);

// set array access for floats
void SetFloatArray(object oSource, string sName, int iElem, float fVal);

// get array access for floats
float GetFloatArray(object oSource, string sName, int iElem);

// returns TRUE if object1 and object are on opposite sides of door
int IsOnOppositeSideOfDoor(object oDoor, object obj1, object obj2);

// returns TRUE if target on other side of unused door
int HenchEnemyOnOtherSideOfUncheckedDoor(object oTarget);

// returns TRUE if part of PC's group
int GetIsPCGroup(object oAssociate = OBJECT_SELF);

// return top level master (non associate master, can be companion or PC)
object GetTopMaster(object oAssociate = OBJECT_SELF);

// converts a prestige class into the best matching primary class
int HenchConvertClass(int nClass, object oCharacter);

// returns the class type that best represents oCharacter
int HenchDetermineClassToUse(object oCharacter = OBJECT_SELF);

// returns 1 if creature should go to stealth, 2 if not
int CheckStealth();

// sets the given combat mode (-1 if none), clears out other modes
void SetCombatMode(int nCombatMode = -1);

// use given combat feat and mode against target
void UseCombatAttack(object oTarget, int nFeatID = -1, int nCombatMode = -1);

// Cleans all temporary values used during combat
void CleanCombatVars();

// does a speakstring of all unseen allies (used during heal or buff)
void ReportUnseenAllies();

// get associate state  (HENCH_ASC_*) for this AI (similar to GetAssociateState)
int GetHenchAssociateState(int nCondition, object oCreature = OBJECT_SELF);

// get state flag (HENCH_PARTY_*) for PC's party
int GetHenchPartyState(int nCondition, object oCreature = OBJECT_SELF);

// return size of melee weapon - if not melee returns 0
int GetMeleeWeaponSize(object oItem);

// attack and damage information in one place
struct sAttackInfo
{
    int attackBonus;
    int damageBonus;
};

//
// gets the attack and damage bonus information for a given item
struct sAttackInfo GetItemAttackBonus(object oTarget, object oItem);

// gets the melee attack and damage bonus information of given melee weapon against a target
struct sAttackInfo GetMeleeAttackBonus(object oCreature, object oWeaponRight, object oTarget);

// gets the range attack and damage bonus information of given melee weapon against a target
struct sAttackInfo GetRangeAttackBonus(object oCreature, object oRangedWeapon, object oTarget);

// gets the attack and damage information of a creature against a given target
struct sAttackInfo GetAttackBonus(object oCreature, object oTarget);



// As MyPrintString, but to screen instead of log
void Jug_Debug(string sString)
{
    SendMessageToPC(GetFactionLeader(GetFirstPC()), sString);
}


void InitializeCreatureInformationInternal(object oTarget)
{
//	Jug_Debug("[[[[[[[[" + GetName(OBJECT_SELF) + " init creature information for " + GetName(oTarget));
    int negEffects;
    int posEffects;
    int abilityMask;
    int attackBonus;
    int iSpellLevelProt = -1;
    int damageInformation;
    float fRangedConcealment;
    float fMeleeConcealment;
	int iRegenerationRate;

    effect eCheck = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eCheck))
    {
//		Jug_Debug("checking effect type " + IntToString(GetEffectType(eCheck)) + " Creator " + GetName(GetEffectCreator(eCheck)) + " Caster Level " + IntToString(GetCasterLevel(GetEffectCreator(eCheck))) + " spell id " + IntToString(GetEffectSpellId(eCheck)));
//		{
//			int testSpellLevel0 = GetEffectInteger(eCheck, 0);
//			int testSpellLevel1 = GetEffectInteger(eCheck, 1);
//			int testSpellLevel2 = GetEffectInteger(eCheck, 2);
//			int testSpellLevel3 = GetEffectInteger(eCheck, 3);
//			int testSpellLevel4 = GetEffectInteger(eCheck, 4);
//			int testSpellLevelm1 = GetEffectInteger(eCheck, -1);
//			Jug_Debug("$$$$$$$ " + GetName(oTarget) + " eff " + IntToString(testSpellLevel0) + " "  + IntToString(testSpellLevel1) + " "  + IntToString(testSpellLevel2) + " "  + IntToString(testSpellLevel3) + " "  + IntToString(testSpellLevel4) + " "  + IntToString(testSpellLevelm1));
//		}
        switch (GetEffectType(eCheck))
        {
        case EFFECT_TYPE_VISUALEFFECT:  // this effect is very common, don't check everything
            break;
        case EFFECT_TYPE_ENTANGLE:
            negEffects |= HENCH_EFFECT_TYPE_ENTANGLE;
            break;
        case EFFECT_TYPE_PARALYZE:
            negEffects |= HENCH_EFFECT_TYPE_PARALYZE;
            break;
        case EFFECT_TYPE_DEAF:
            negEffects |= HENCH_EFFECT_TYPE_DEAF;
            break;
        case EFFECT_TYPE_BLINDNESS:
            negEffects |= HENCH_EFFECT_TYPE_BLINDNESS;
            break;
        case EFFECT_TYPE_CURSE:
            negEffects |= HENCH_EFFECT_TYPE_CURSE;
            break;
        case EFFECT_TYPE_SLEEP:
            negEffects |= HENCH_EFFECT_TYPE_SLEEP;
            break;
        case EFFECT_TYPE_CHARMED:
            negEffects |= HENCH_EFFECT_TYPE_CHARMED;
            break;
        case EFFECT_TYPE_CONFUSED:
            negEffects |= HENCH_EFFECT_TYPE_CONFUSED;
            break;
        case EFFECT_TYPE_FRIGHTENED:
            negEffects |= HENCH_EFFECT_TYPE_FRIGHTENED;
            break;
        case EFFECT_TYPE_DOMINATED:
            negEffects |= HENCH_EFFECT_TYPE_DOMINATED;
            break;
        case EFFECT_TYPE_DAZED:
            negEffects |= HENCH_EFFECT_TYPE_DAZED;
            break;
        case EFFECT_TYPE_POISON:
            negEffects |= HENCH_EFFECT_TYPE_POISON;
            break;
        case EFFECT_TYPE_DISEASE:
            negEffects |= HENCH_EFFECT_TYPE_DISEASE;
            break;
        case EFFECT_TYPE_SILENCE:
            negEffects |= HENCH_EFFECT_TYPE_SILENCE;
            break;
        case EFFECT_TYPE_SLOW:
            negEffects |= HENCH_EFFECT_TYPE_SLOW;
            break;
        case EFFECT_TYPE_ABILITY_DECREASE:
            if ((GetEffectCreator(eCheck) != OBJECT_SELF) && !(GetFactionEqual(GetEffectCreator(eCheck)) || GetIsFriend(GetEffectCreator(eCheck))))
            {
                negEffects |= HENCH_EFFECT_TYPE_ABILITY_DECREASE;
            }
            break;
        case EFFECT_TYPE_DAMAGE_DECREASE:
            negEffects |= HENCH_EFFECT_TYPE_DAMAGE_DECREASE;
            break;
        case EFFECT_TYPE_ATTACK_DECREASE:
            if ((GetEffectCreator(eCheck) != OBJECT_SELF) && !(GetFactionEqual(GetEffectCreator(eCheck)) || GetIsFriend(GetEffectCreator(eCheck))))
            {
                negEffects |= HENCH_EFFECT_TYPE_ATTACK_DECREASE;
            }
            attackBonus -= GetEffectInteger(eCheck, 0);
            break;
        case EFFECT_TYPE_SKILL_DECREASE:
            negEffects |= HENCH_EFFECT_TYPE_SKILL_DECREASE;
            break;
        case EFFECT_TYPE_STUNNED:
            negEffects |= HENCH_EFFECT_TYPE_STUNNED;
            break;
        case EFFECT_TYPE_PETRIFY:
            negEffects |= HENCH_EFFECT_TYPE_PETRIFY;
            break;
        case EFFECT_TYPE_MOVEMENT_SPEED_DECREASE:
            if ((GetEffectCreator(eCheck) != OBJECT_SELF) && !(GetFactionEqual(GetEffectCreator(eCheck)) || GetIsFriend(GetEffectCreator(eCheck))))
            {
                negEffects |= HENCH_EFFECT_TYPE_MOVEMENT_SPEED_DECREASE;
            }
            break;
        case EFFECT_TYPE_NEGATIVELEVEL:
            negEffects |= HENCH_EFFECT_TYPE_NEGATIVELEVEL;
            break;
        case EFFECT_TYPE_AC_DECREASE:
            if ((GetEffectCreator(eCheck) != OBJECT_SELF) && !(GetFactionEqual(GetEffectCreator(eCheck)) || GetIsFriend(GetEffectCreator(eCheck))))
            {
            	negEffects |= HENCH_EFFECT_TYPE_AC_DECREASE;
			}
			{
                int acDecrease = - GetEffectInteger(eCheck, 1);
                int acBitMask = 1 << (/* AC_DODGE_BONUS + */ acIncreaseOffset);
//				Jug_Debug("$$$$$$$ " + GetName(oTarget) + " ac decrease "  + IntToString(acDecrease) + " "  + IntToString(acBitMask));
                if (abilityMask & acBitMask)
                {
					int testAbility = GetIntArray(oTarget, acIncreaseStr, AC_DODGE_BONUS);
					SetIntArray(oTarget, acIncreaseStr, AC_DODGE_BONUS, testAbility + acDecrease);
                }
                else
                {
					abilityMask |= acBitMask;
					SetIntArray(oTarget, acIncreaseStr, AC_DODGE_BONUS, acDecrease);
                }   			
			}	
            break;
        case EFFECT_TYPE_SAVING_THROW_DECREASE:
            negEffects |= HENCH_EFFECT_TYPE_SAVING_THROW_DECREASE;
            break;
        //const int HENCH_EFFECT_TYPE_KNOCKDOWN = 0x8000000,
        case EFFECT_TYPE_DARKNESS:
            negEffects |= HENCH_EFFECT_TYPE_DARKNESS;
            break;
        case EFFECT_TYPE_MESMERIZE:
            negEffects |= HENCH_EFFECT_TYPE_MESMERIZE;
            break;
        case EFFECT_TYPE_SPELL_FAILURE:
            negEffects |= HENCH_EFFECT_TYPE_SPELL_FAILURE;
            if (oTarget == OBJECT_SELF)
            {
//              Jug_Debug("$$$$$$$ " + GetName(oTarget) + " spell failure " + IntToString(GetEffectInteger(eCheck, 0)));
                gfSpellFailureChance += IntToFloat(GetEffectInteger(eCheck, 0)) / 100.0 * (1.0 - gfSpellFailureChance);
            }
            break;
        case EFFECT_TYPE_CUTSCENE_PARALYZE:
            negEffects |= HENCH_EFFECT_TYPE_CUTSCENE_PARALYZE;
            break;
        case EFFECT_TYPE_AC_INCREASE:
            posEffects |= HENCH_EFFECT_TYPE_AC_INCREASE;
            {
                int acType = GetEffectInteger(eCheck, 0);
                int acIncrease = GetEffectInteger(eCheck, 1);
                int acBitMask = 1 << (acType + acIncreaseOffset);
//              Jug_Debug("$$$$$$$ " + GetName(oTarget) + " ac type " + IntToString(acType) + " ac inc "  + IntToString(acIncrease) + " "  + IntToString(acBitMask));
                if (abilityMask & acBitMask)
                {
                    int testAbility = GetIntArray(oTarget, acIncreaseStr, acType);
                    if (acType == AC_DODGE_BONUS)
                    {
                        SetIntArray(oTarget, acIncreaseStr, acType, testAbility + acIncrease);
                    }
                    else if (testAbility < acIncrease)
                    {
                        SetIntArray(oTarget, acIncreaseStr, acType, acIncrease);
                    }
                }
                else
                {
                    abilityMask |= acBitMask;
                    SetIntArray(oTarget, acIncreaseStr, acType, acIncrease);
                }
            }
            break;
        case EFFECT_TYPE_REGENERATE:
            posEffects |= HENCH_EFFECT_TYPE_REGENERATE;			
			{
				int regenRate = GetEffectInteger(eCheck, 0);
				int regenSpeed = GetEffectInteger(eCheck, 1);
				if (regenSpeed)
				{
					iRegenerationRate += regenRate * 24000 /* regenerateRateRounds * 6000 */ / regenSpeed;
//					Jug_Debug(GetName(OBJECT_SELF) + " effect regen rate now " + IntToString(iRegenerationRate));
				}	
			}
            break;
        case EFFECT_TYPE_ATTACK_INCREASE:
            attackBonus += GetEffectInteger(eCheck, 0);
            posEffects |= HENCH_EFFECT_TYPE_ATTACK_INCREASE;
            break;
        case EFFECT_TYPE_DAMAGE_REDUCTION:
            posEffects |= HENCH_EFFECT_TYPE_DAMAGE_REDUCTION;
            break;
        case EFFECT_TYPE_DAMAGE_RESISTANCE:
//            if (GetEffectInteger(eCheck, 2) == 0) // for now only consider unlimited
            {
                int damageType =  GetEffectInteger(eCheck, 0);
                int damageValue = GetEffectInteger(eCheck, 1);
                if (damageInformation & damageType)
                {
                    damageValue += GetIntArray(oTarget, HENCH_DAMAGE_RESIST_STR, damageType);
                }
                else
                {
                    damageInformation |= damageType;
                    SetFloatArray(oTarget, HENCH_DAMAGE_IMMUNITY_STR, damageType, 1.0);
                }
                SetIntArray(oTarget, HENCH_DAMAGE_RESIST_STR, damageType, damageValue);
            }
            break;
        case EFFECT_TYPE_DAMAGE_IMMUNITY_INCREASE:
            {
                int damageType =  GetEffectInteger(eCheck, 0);
                float damageValue = - IntToFloat(GetEffectInteger(eCheck, 1)) / 100.0;
                if (damageInformation & damageType)
                {
                    damageValue += GetFloatArray(oTarget, HENCH_DAMAGE_IMMUNITY_STR, damageType);
                }
                else
                {
                    damageValue += 1.0;
                    damageInformation |= damageType;
                    SetIntArray(oTarget, HENCH_DAMAGE_RESIST_STR, damageType, 0);
                }
                SetFloatArray(oTarget, HENCH_DAMAGE_IMMUNITY_STR, damageType, damageValue);
            }
            break;
        case EFFECT_TYPE_HASTE:
            posEffects |= HENCH_EFFECT_TYPE_HASTE;
            break;
        case EFFECT_TYPE_TEMPORARY_HITPOINTS:
            posEffects |= HENCH_EFFECT_TYPE_TEMPORARY_HITPOINTS;
            break;
        case EFFECT_TYPE_SANCTUARY:
            {
                // unable to tell apart - use spell id
                int spellId = GetEffectSpellId(eCheck);
                if ((spellId == 724 /* ethereal jaunt */) || (spellId == SPELL_ETHEREALNESS))
                {
                    posEffects |= HENCH_EFFECT_TYPE_ETHEREAL;
                }
                else
                {
                    posEffects |= HENCH_EFFECT_TYPE_SANCTUARY;
                }
            }
            break;
        case EFFECT_TYPE_TIMESTOP:
            posEffects |= HENCH_EFFECT_TYPE_TIMESTOP;
            break;
        case EFFECT_TYPE_SPELLLEVELABSORPTION:
            posEffects |= HENCH_EFFECT_TYPE_SPELLLEVELABSORPTION;
            {
                int spellLevel = GetEffectInteger(eCheck, 0);
                int levelsAbsorbed = GetEffectInteger(eCheck, 1);
                int spellSchool = GetEffectInteger(eCheck, 2);
//              Jug_Debug("$$$$$$$ " + GetName(oTarget) + " ids " + IntToString(testSpellLevel0) + " "  + IntToString(testSpellLevel1) + " "  + IntToString(testSpellLevel2));
                if ((levelsAbsorbed == 0) && (spellSchool == SPELL_SCHOOL_GENERAL) && (spellLevel > iSpellLevelProt))
                {
                    iSpellLevelProt = spellLevel;
                }
            }
            break;
        case EFFECT_TYPE_SAVING_THROW_INCREASE:
            posEffects |= HENCH_EFFECT_TYPE_SAVING_THROW_INCREASE;
            break;
        case EFFECT_TYPE_CONCEALMENT:
            posEffects |= HENCH_EFFECT_TYPE_CONCEALMENT;
            {
                float fConcealment = IntToFloat(GetEffectInteger(eCheck, 0)) / 100.0;
                int nSpellID = GetEffectSpellId(eCheck);
                if ((nSpellID != 945) && (nSpellID != SPELL_I_ENTROPIC_WARDING) &&
                    (nSpellID != SPELL_STORM_AVATAR) &&  (nSpellID != SPELL_ENTROPIC_SHIELD))
                {
                    if (fConcealment > fMeleeConcealment)
                    {
                        fMeleeConcealment = fConcealment;
                    }
                }
                if (fConcealment > fRangedConcealment)
                {
                    fRangedConcealment = fConcealment;
                }
            }
            break;
        case EFFECT_TYPE_DAMAGE_INCREASE:
            posEffects |= HENCH_EFFECT_TYPE_DAMAGE_INCREASE;
            break;
        case EFFECT_TYPE_ABSORBDAMAGE:
            posEffects |= HENCH_EFFECT_TYPE_ABSORBDAMAGE;
            break;
        case EFFECT_TYPE_ETHEREAL:
            posEffects |= HENCH_EFFECT_TYPE_ETHEREAL;
            break;
        case EFFECT_TYPE_INVISIBILITY:
            posEffects |= HENCH_EFFECT_TYPE_INVISIBILITY;
            break;
        case EFFECT_TYPE_POLYMORPH:
            posEffects |= HENCH_EFFECT_TYPE_POLYMORPH;
            SetLocalInt(OBJECT_SELF, sPolymorphTypeStr, GetEffectInteger(eCheck, 0));
            if (GetEffectInteger(eCheck, 3))
            {
                posEffects |= HENCH_EFFECT_TYPE_WILDSHAPE;
            }
//          {
//              int testSpellLevel0 = GetEffectInteger(eCheck, 0);
//              int testSpellLevel1 = GetEffectInteger(eCheck, 1);
//              int testSpellLevel2 = GetEffectInteger(eCheck, 2);
//              int testSpellLevel3 = GetEffectInteger(eCheck, 3);
//              Jug_Debug("$$$$$$$ " + GetName(oTarget) + " poly " + IntToString(testSpellLevel0) + " "  + IntToString(testSpellLevel1) + " "  + IntToString(testSpellLevel2) + " "  + IntToString(testSpellLevel3));
//          }
            break;
        case EFFECT_TYPE_ULTRAVISION:
            posEffects |= HENCH_EFFECT_TYPE_ULTRAVISION;
            break;
        case EFFECT_TYPE_TRUESEEING:
            posEffects |= HENCH_EFFECT_TYPE_TRUESEEING;
            break;
        case EFFECT_TYPE_GREATERINVISIBILITY:
            posEffects |= HENCH_EFFECT_TYPE_GREATER_INVIS;
            break;
        case EFFECT_TYPE_ELEMENTALSHIELD:
            posEffects |= HENCH_EFFECT_TYPE_ELEMENTALSHIELD;
            break;
        case EFFECT_TYPE_ABILITY_INCREASE:
            posEffects |= HENCH_EFFECT_TYPE_ABILITY_INCREASE;
            if (GetEffectSpellId(eCheck) != SPELLABILITY_BARBARIAN_RAGE)
            {
                int abilityType = GetEffectInteger(eCheck, 0);
                int abilityIncrease = GetEffectInteger(eCheck, 1);
                int abilityBitMask = 1 << abilityType;
//              Jug_Debug("$$$$$$$ " + GetName(oTarget) + " ability inc " + IntToString(abilityType) + " "  + IntToString(abilityIncrease) + " "  + IntToString(abilityBitMask));
                if (abilityMask & abilityBitMask)
                {
                    int testAbility = GetIntArray(oTarget, abilityIncreaseStr, abilityType);
                    if (testAbility < abilityIncrease)
                    {
                        SetIntArray(oTarget, abilityIncreaseStr, abilityType, abilityIncrease);
                    }
                }
                else
                {
                    abilityMask |= abilityBitMask;
                    SetIntArray(oTarget, abilityIncreaseStr, abilityType, abilityIncrease);
                }
            }
            break;
        }
        eCheck = GetNextEffect(oTarget);
    }

    int slotIndex;
    for (slotIndex = INVENTORY_SLOT_HEAD; slotIndex < NUM_INVENTORY_SLOTS; slotIndex++)
    {
        object oItem = GetItemInSlot(slotIndex, oTarget);

        if (GetIsObjectValid(oItem))
        {
//			Jug_Debug(GetName(oTarget) + " checking item " + GetName(oItem));
            itemproperty curItemProp = GetFirstItemProperty(oItem);
            while(GetIsItemPropertyValid(curItemProp))
            {
                int iItemTypeValue = GetItemPropertyType(curItemProp);
//				Jug_Debug(GetName(oItem) + " has item type value " + IntToString(iItemTypeValue) +
//					" isub type " + IntToString(GetItemPropertySubType(curItemProp)) + " cost table " + IntToString(GetItemPropertyCostTableValue(curItemProp)) +
//					" item param 1 " + IntToString(GetItemPropertyParam1(curItemProp)) + " item param 1 value " + IntToString(GetItemPropertyParam1Value(curItemProp)));
                switch(iItemTypeValue)
                {
                case ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL:
                    {
                        int levelProtect = GetItemPropertyCostTableValue(curItemProp);
                        if (levelProtect > iSpellLevelProt)
                        {
                            iSpellLevelProt = levelProtect;
                        }
                    }
                    break;
                case ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE:
                case ITEM_PROPERTY_DAMAGE_VULNERABILITY:
                    {
                        int subType = GetItemPropertySubType(curItemProp);
                        if (subType > IP_CONST_DAMAGETYPE_SLASHING)
                        {
                            subType -= 2;
                        }
                        int damageType = 1 << subType;
                        float damageValue;
                        switch (GetItemPropertyCostTableValue(curItemProp))
                        {
                            case IP_CONST_DAMAGEIMMUNITY_5_PERCENT:
                               damageValue = 0.05;
                               break;
                            case IP_CONST_DAMAGEIMMUNITY_10_PERCENT:
                               damageValue = 0.10;
                               break;
                            case IP_CONST_DAMAGEIMMUNITY_25_PERCENT:
                               damageValue = 0.25;
                               break;
                            case IP_CONST_DAMAGEIMMUNITY_50_PERCENT:
                               damageValue = 0.50;
                               break;
                            case IP_CONST_DAMAGEIMMUNITY_75_PERCENT:
                               damageValue = 0.75;
                               break;
                            case IP_CONST_DAMAGEIMMUNITY_90_PERCENT:
                               damageValue = 0.90;
                               break;
                            case IP_CONST_DAMAGEIMMUNITY_100_PERCENT:
                               damageValue = 1.00;
                               break;
                            default:
                               damageValue = 0.05;
                               break;
                        }
                        if (iItemTypeValue != ITEM_PROPERTY_DAMAGE_VULNERABILITY)
                        {
                            damageValue = - damageValue;
                        }
                        if (damageInformation & damageType)
                        {
                            damageValue += GetFloatArray(oTarget, HENCH_DAMAGE_IMMUNITY_STR, damageType);
                        }
                        else
                        {
                            damageValue += 1.0;
                            damageInformation |= damageType;
                            SetIntArray(oTarget, HENCH_DAMAGE_RESIST_STR, damageType, 0);
                        }
                        SetFloatArray(oTarget, HENCH_DAMAGE_IMMUNITY_STR, damageType, damageValue);						
//						Jug_Debug(GetName(oItem) + " set dt " + IntToString(damageType) +
//							" immunity " + FloatToString(GetFloatArray(oTarget, HENCH_DAMAGE_IMMUNITY_STR, damageType)) +
//							" resistance " + IntToString(GetIntArray(oTarget, HENCH_DAMAGE_RESIST_STR, damageType)));
                    }
                    break;
                case ITEM_PROPERTY_DAMAGE_RESISTANCE:
                    {
                        int subType = GetItemPropertySubType(curItemProp);
                        if (subType >= IP_CONST_DAMAGETYPE_MAGICAL)
                        {
                            // damage resistance piercing, slashing, and bludgeoning doesn't work in NWN2
                            subType -= 2;
                            int damageType = 1 << subType;
                            int damageValue = GetItemPropertyCostTableValue(curItemProp) * 5;
                            if (damageInformation & damageType)
                            {
                                damageValue += GetIntArray(oTarget, HENCH_DAMAGE_RESIST_STR, damageType);
                            }
                            else
                            {
                                damageInformation |= damageType;
                                SetFloatArray(oTarget, HENCH_DAMAGE_IMMUNITY_STR, damageType, 1.0);
                            }
                            SetIntArray(oTarget, HENCH_DAMAGE_RESIST_STR, damageType, damageValue);
//							Jug_Debug(GetName(oItem) + " set dt " + IntToString(damageType) +
//								" immunity " + FloatToString(GetFloatArray(oTarget, HENCH_DAMAGE_IMMUNITY_STR, damageType)) +
//								" resistance " + IntToString(GetIntArray(oTarget, HENCH_DAMAGE_RESIST_STR, damageType)));
                        }
                    }
                    break;
                case ITEM_PROPERTY_HASTE:
                    posEffects |= HENCH_EFFECT_TYPE_HASTE;
                    break;
                case ITEM_PROPERTY_TRUE_SEEING:
                    posEffects |= HENCH_EFFECT_TYPE_TRUESEEING;
                    break;
                case ITEM_PROPERTY_REGENERATION:
//					Jug_Debug(GetName(OBJECT_SELF) + " item regen " + IntToString(GetItemPropertyCostTableValue(curItemProp)));					
					iRegenerationRate += GetItemPropertyCostTableValue(curItemProp) * regenerateRateRounds;										
                    break;
                case ITEM_PROPERTY_ABILITY_BONUS:
                    {
                        posEffects |= HENCH_EFFECT_TYPE_ABILITY_INCREASE;
                        int abilityType = GetItemPropertySubType(curItemProp);
                        int abilityIncrease =  GetItemPropertyCostTableValue(curItemProp);
                        int abilityBitMask = 1 << abilityType;
//                      Jug_Debug("$$$$$$$ " + GetName(oTarget) + " property ability inc " + IntToString(abilityType) + " "  + IntToString(abilityIncrease) + " "  + IntToString(abilityBitMask));
                        if (abilityMask & abilityBitMask)
                        {
                            int testAbility = GetIntArray(oTarget, abilityIncreaseStr, abilityType);
                            if (testAbility < abilityIncrease)
                            {
                                SetIntArray(oTarget, abilityIncreaseStr, abilityType, abilityIncrease);
                            }
                        }
                        else
                        {
                            abilityMask |= abilityBitMask;
                            SetIntArray(oTarget, abilityIncreaseStr, abilityType, abilityIncrease);
                        }
                    }
                    break;
                case ITEM_PROPERTY_AC_BONUS:
                    {
                        posEffects |= HENCH_EFFECT_TYPE_AC_INCREASE;
                        int acType;
                        switch (slotIndex)
                        {
                            case INVENTORY_SLOT_BOOTS:
                                acType = AC_DODGE_BONUS;
                                break;
                            case INVENTORY_SLOT_NECK:
                                acType = AC_NATURAL_BONUS;
                                break;
                            case INVENTORY_SLOT_ARMS:
                                if (GetBaseItemType(oItem) != BASE_ITEM_BRACER)
                                {
                                    acType = AC_DEFLECTION_BONUS;
                                    break;
                                }
                                // anything else use armor bonus
                            case INVENTORY_SLOT_CHEST:
                                acType = AC_ARMOUR_ENCHANTMENT_BONUS;
                                break;
                            case INVENTORY_SLOT_LEFTHAND:
                                {
                                    // shield only
                                    int itemType = GetBaseItemType(oItem);
                                    if ((itemType == BASE_ITEM_TOWERSHIELD) ||
                                        (itemType == BASE_ITEM_LARGESHIELD) ||
                                        (itemType == BASE_ITEM_SMALLSHIELD))
                                    {
                                        acType = AC_SHIELD_ENCHANTMENT_BONUS;
                                        break;
                                    }
                                }
                                // anything else use deflection bonus
                            default:
                                acType = AC_DEFLECTION_BONUS;
                        }
                        int acIncrease = GetItemPropertyCostTableValue(curItemProp);
                        int acBitMask = 1 << (acType + acIncreaseOffset);
//						Jug_Debug("$$$$$$$ " + GetName(oTarget) + " ac item inc " + IntToString(acType) + " "  + IntToString(acIncrease) + " "  + IntToString(acBitMask));
                        if (abilityMask & acBitMask)
                        {
                            int testAbility = GetIntArray(oTarget, acIncreaseStr, acType);
                            if (acType == AC_DODGE_BONUS)
                            {
                                SetIntArray(oTarget, acIncreaseStr, acType, testAbility + acIncrease);
                            }
                            else if (testAbility < acIncrease)
                            {
                                SetIntArray(oTarget, acIncreaseStr, acType, acIncrease);
                            }
                        }
                        else
                        {
                            abilityMask |= acBitMask;
                            SetIntArray(oTarget, acIncreaseStr, acType, acIncrease);
                        }
                    }
                    break;
                }
                // ITEM_PROPERTY_IMMUNITY_SPECIFIC_SPELL    iprp_spellcost.2da
                // ITEM_PROPERTY_IMMUNITY_SPELL_SCHOOL IP_CONST_SPELLSCHOOL_
                curItemProp = GetNextItemProperty(oItem);
            }
        }
        // skip unneeded checks, this will go to INVENTORY_SLOT_CARMOUR next
        if (slotIndex == INVENTORY_SLOT_BELT)
        {
            slotIndex = INVENTORY_SLOT_CWEAPON_B;
        }
    }

    if (posEffects & HENCH_EFFECT_TYPE_HASTE)
    {
        // haste increased dodge and attack bonus by 1
        int acBitMask = 1 << (AC_DODGE_BONUS + acIncreaseOffset);
        if (abilityMask & acBitMask)
        {
            int testAbility = GetIntArray(oTarget, acIncreaseStr, AC_DODGE_BONUS);
            SetIntArray(oTarget, acIncreaseStr, AC_DODGE_BONUS, testAbility + 1);
        }
        else
        {
            abilityMask |= acBitMask;
            SetIntArray(oTarget, acIncreaseStr, AC_DODGE_BONUS, 1);
        }
        attackBonus++;
    }

    if (GetImmortal(oTarget) && (GetCurrentHitPoints(oTarget) <= 10))
    {
        int bNotATroll = GetEventHandler(oTarget, CREATURE_SCRIPT_ON_DAMAGED) != "gb_troll_dmg";
        int damageType = DAMAGE_TYPE_BLUDGEONING; // 1
        while (damageType <= DAMAGE_TYPE_SONIC) // 2048
        {
            // a troll with low hitpoints resistant to everything but acid and fire
            if (bNotATroll || ((damageType != DAMAGE_TYPE_ACID) && (damageType != DAMAGE_TYPE_FIRE)))
            {
                if (!(damageInformation & damageType))
                {
                    damageInformation |= damageType;
                    SetIntArray(oTarget, HENCH_DAMAGE_RESIST_STR, damageType, 0);
                }
                SetFloatArray(oTarget, HENCH_DAMAGE_IMMUNITY_STR, damageType, 0.0);
            }
            damageType *= 2;
        }
    }

    SetLocalInt(oTarget, curPostiveEffectsStr, posEffects);
    SetLocalInt(oTarget, curNegativeEffectsStr, negEffects);
    SetLocalInt(oTarget, abilityIncreaseStr, abilityMask);
    SetLocalInt(oTarget, attackBonusStr, attackBonus);
    SetLocalInt(oTarget, spellLevelProtStr, iSpellLevelProt);
    SetLocalInt(oTarget, damageInformationStr, damageInformation);
    SetLocalFloat(oTarget, rangedConcealmentStr, fRangedConcealment);
    SetLocalFloat(oTarget, meleeConcealmentStr, fMeleeConcealment);
	SetLocalInt(oTarget, regenerationRateStr, iRegenerationRate);

    SetLocalInt(oTarget, lastEffectQueryStr, GetTimeSecond() + 1);
}


void InitializeCreatureInformation(object oTarget)
{
    InitializeCreatureInformationInternal(oTarget);

    SetLocalInt(oTarget, HENCH_HEAL_SELF_STATE, HENCH_HEAL_SELF_UNKNOWN);
}


int gICheckCreatureInfoStaleTime;

int GetIsOldCreatureInformation(object oTarget)
{
    int lastQueryTime = GetLocalInt(oTarget, lastEffectQueryStr);
    if (!lastQueryTime)
    {
        return TRUE;
    }
    int lastEffectCheckDiff = GetTimeSecond() + 1 - lastQueryTime;
    if (lastEffectCheckDiff < 0)
    {
        lastEffectCheckDiff += 60;
    }
//  if (lastEffectCheckDiff > gICheckCreatureInfoStaleTime)
//  {
//  Jug_Debug(GetName(OBJECT_SELF) + " is obsolete for " + GetName(oTarget) + " value " + IntToString(lastEffectCheckDiff));
//  }
    return lastEffectCheckDiff > gICheckCreatureInfoStaleTime;
}

int GetCreaturePosEffects(object oTarget)
{
    if (GetIsOldCreatureInformation(oTarget))
    {
        InitializeCreatureInformationInternal(oTarget);
    }
    return GetLocalInt(oTarget, curPostiveEffectsStr);
}

int GetCreatureNegEffects(object oTarget)
{
    if (GetIsOldCreatureInformation(oTarget))
    {
        InitializeCreatureInformationInternal(oTarget);
    }
    return GetLocalInt(oTarget, curNegativeEffectsStr);
}

int GetCreatureAbilityIncrease(object oTarget, int nAbilityType)
{
    // assume already initialized
    int abilityBitMask = 1 << nAbilityType;
    if (abilityBitMask & GetLocalInt(oTarget, abilityIncreaseStr))
    {
        return GetIntArray(oTarget, abilityIncreaseStr, nAbilityType);
    }
    return 0;
}

int GetCreatureACBonus(object oTarget, int nACType)
{
    // assume already initialized
    int abilityBitMask = 1 << (nACType + acIncreaseOffset);
    if (abilityBitMask & GetLocalInt(oTarget, abilityIncreaseStr))
    {
        return GetIntArray(oTarget, acIncreaseStr, nACType);
    }
    return 0;
}


const string HENCH_SAVE_BASE_TOUCH_AC_TIME	= "HenchLastTouchACTime";
const string HENCH_SAVE_BASE_TOUCH_AC 		= "HenchLastTouchAC";

int GetTouchAC(object oTarget)
{
	int touchAC;

	if (GetLocalInt(oTarget, lastEffectQueryStr) == GetLocalInt(oTarget, HENCH_SAVE_BASE_TOUCH_AC_TIME))
	{
		touchAC = GetLocalInt(oTarget, HENCH_SAVE_BASE_TOUCH_AC);
	}
	else
	{
		touchAC = GetCreatureACBonus(oTarget, AC_DEFLECTION_BONUS) -
			GetCreatureSize(oTarget) + CREATURE_SIZE_MEDIUM;
		int classCheck = GetLevelByClass(CLASS_TYPE_MONK, oTarget);
		if (classCheck)
		{
			touchAC += classCheck / 5 + GetAbilityModifier(ABILITY_WISDOM, oTarget);		

			classCheck = GetLevelByClass(CLASS_TYPE_SACREDFIST, oTarget);
			if (classCheck)
			{
				touchAC += classCheck / 5 + 1;		
			}								
		}
		if (!(GetCreatureNegEffects(oTarget) & HENCH_EFFECT_DISABLED))
		{
			touchAC += GetAbilityModifier(ABILITY_DEXTERITY, oTarget) + 
				GetCreatureACBonus(oTarget, AC_DODGE_BONUS) +
				GetSkillRank(SKILL_TUMBLE, oTarget, TRUE) / 10;
		
			classCheck = GetLevelByClass(CLASS_TYPE_INVISIBLE_BLADE, oTarget);
			if (classCheck)
			{
				int abilityModifier =  GetAbilityModifier(ABILITY_INTELLIGENCE, oTarget);
				if (classCheck >= abilityModifier)
				{
					touchAC += abilityModifier;
				}
				else
				{							
					touchAC += classCheck;							
				}
			}
			classCheck = GetLevelByClass(CLASS_TYPE_DUELIST, oTarget);
			if (classCheck)
			{
				int abilityModifier =  GetAbilityModifier(ABILITY_INTELLIGENCE, oTarget);
				if (classCheck >= abilityModifier)
				{
					touchAC += abilityModifier;
				}
				else
				{							
					touchAC += classCheck;
				}
			}							
		}						
	
		SetLocalInt(oTarget, HENCH_SAVE_BASE_TOUCH_AC, touchAC);						
		SetLocalInt(oTarget, HENCH_SAVE_BASE_TOUCH_AC_TIME, GetLocalInt(oTarget, lastEffectQueryStr));
	}

	return touchAC;
}


const string sThreatRating = "HenchThreatRating";

float GetRawThreatRating(object oTarget)
{
    int lastTestHitDice = GetLocalInt(oTarget, sThreatRating);
    int hitDice = GetHitDice(oTarget);
    float fThreat;
    if (GetHitDice(oTarget) == lastTestHitDice)
    {
        fThreat = GetLocalFloat(oTarget, sThreatRating);
    }
    else
    {
        fThreat = IntToFloat(GetHitDice(oTarget));
        fThreat = pow(1.5, fThreat * HENCH_HITDICE_TO_CR);
        int iAssocType = GetAssociateType(oTarget);
        if (iAssocType == ASSOCIATE_TYPE_FAMILIAR)
        {
            fThreat *= 0.1;
        }
        else if (iAssocType != ASSOCIATE_TYPE_NONE && iAssocType != ASSOCIATE_TYPE_HENCHMAN)
        {
            fThreat *= 0.8;
        }
        if ((GetLevelByClass(CLASS_TYPE_WIZARD, oTarget) >= 5) || (GetLevelByClass(CLASS_TYPE_SORCERER, oTarget) >= 6))
        {
            fThreat *= 1.3;
        }
        else if ((GetLevelByClass(CLASS_TYPE_DRAGON, oTarget) >= 11))
        {
            // dragons are extra tough
            fThreat *= 1.5;
        }
        if (fThreat < 0.001)
        {
            fThreat = 0.001;
        }
        SetLocalFloat(oTarget, sThreatRating, fThreat);
        SetLocalInt(oTarget, sThreatRating, hitDice);
    }
    return fThreat;
}


int GetIsHumanoid(int nRacial)
{
    return
        (nRacial == RACIAL_TYPE_DWARF) ||
        (nRacial == RACIAL_TYPE_ELF) ||
        (nRacial == RACIAL_TYPE_GNOME) ||
        (nRacial == RACIAL_TYPE_HUMANOID_GOBLINOID) ||
        (nRacial == RACIAL_TYPE_HALFLING) ||
        (nRacial == RACIAL_TYPE_HUMAN) ||
        (nRacial == RACIAL_TYPE_HALFELF) ||
        (nRacial == RACIAL_TYPE_HALFORC) ||
        (nRacial == RACIAL_TYPE_HUMANOID_MONSTROUS) ||
        (nRacial == RACIAL_TYPE_HUMANOID_ORC) ||
        (nRacial == RACIAL_TYPE_HUMANOID_REPTILIAN);
}


int GetCreatureUseItems(object oCreature)
{
    if (GetIsPlayableRacialType(oCreature))
    {
        return TRUE;
    }
    int nAppearanceType = GetAppearanceType(oCreature);
    string sUseItemsSizeStr = "HENCH_AI_USE_ITEMS_" + IntToString(nAppearanceType);
    object oModule = GetModule();
    int useItems = GetLocalInt(oModule, sUseItemsSizeStr);
    if (useItems == 0)
    {
        if ((GetRacialType(oCreature) == RACIAL_TYPE_DRAGON) || (nAppearanceType == 1011))
        {
            useItems = 1;
        }
        else
        {
            useItems = StringToInt(Get2DAString("appearance", "BodyType", nAppearanceType)) > 0 ? 2 : 1;
            SetLocalInt(oModule, sUseItemsSizeStr, useItems);
        }
    }
    return useItems > 1;
}


int GetCreatureHasItemProperty(int nItemProperty, object oCreature = OBJECT_SELF)
{
    int i;
    for (i = 0; i < NUM_INVENTORY_SLOTS; i++)
    {
        object oItem = GetItemInSlot(i, oCreature);
        if(GetItemHasItemProperty(oItem, nItemProperty))
        {
            return TRUE;
        }
    }
    return FALSE;
}


void SetObjectArray(object oSource, string sName, int iElem, object oElem)
{
    string sFull = sName+IntToString(iElem);
    SetLocalObject(oSource,sFull,oElem);
}

object GetObjectArray(object oSource, string sName, int iElem)
{
    string sFull = sName+IntToString(iElem);
    return GetLocalObject(oSource,sFull);
}

void SetIntArray(object oSource, string sName, int iElem, int iState)
{
    string sFull = sName+IntToString(iElem);
    SetLocalInt(oSource,sFull,iState);
}

int GetIntArray(object oSource, string sName, int iElem)
{
    string sFull = sName+IntToString(iElem);
    return GetLocalInt(oSource,sFull);
}

void SetFloatArray(object oSource, string sName, int iElem, float fVal)
{
    string sFull = sName+IntToString(iElem);
    SetLocalFloat(oSource,sFull,fVal);
}

float GetFloatArray(object oSource, string sName, int iElem)
{
    string sFull = sName+IntToString(iElem);
    return GetLocalFloat(oSource,sFull);
}

int IsOnOppositeSideOfDoor(object oDoor, object obj1, object obj2)
{
    float fDoorAngle = GetFacing(oDoor);

    vector vDoor = GetPositionFromLocation(GetLocation(oDoor));
    vector v1 = GetPositionFromLocation(GetLocation(obj1));
    vector v2 = GetPositionFromLocation(GetLocation(obj2));

    float fAngle1 = VectorToAngle(v1 - vDoor);
    float fAngle2 = VectorToAngle(v2 - vDoor);

    fAngle1 -= fDoorAngle;
    fAngle2 -= fDoorAngle;
    if (fAngle1 < 0.0)
    {
        fAngle1 += 360.0;
    }
    if (fAngle2 < 0.0)
    {
        fAngle2 += 360.0;
    }

    int bSide1 = fAngle1 < 90.0 || fAngle1 > 270.0;
    int bSide2 = fAngle2 < 90.0 || fAngle2 > 270.0;

    return bSide1 != bSide2;
}


int HenchEnemyOnOtherSideOfUncheckedDoor(object oTarget)
{
    float fEnemyDistance = GetDistanceToObject(oTarget);
    vector vMiddle = GetPosition(OBJECT_SELF) + GetPosition(oTarget);
    vMiddle.x /= 2.0;
    vMiddle.y /= 2.0;
    vMiddle.z /= 2.0;
    location middleLoc = Location(GetArea(OBJECT_SELF), vMiddle, GetFacing(OBJECT_SELF));
    float fRadius = fEnemyDistance < 10.0 ? 10.0 : fEnemyDistance;

    object oDoor = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, middleLoc,
                    FALSE, OBJECT_TYPE_DOOR);
    while (GetIsObjectValid(oDoor))
    {
//      Jug_Debug(GetName(OBJECT_SELF) + " check door " + GetName(oDoor));
        if (!GetIsOpen(oDoor) && GetLocalInt(oDoor, "tkDoorWarning"))
        {
//          Jug_Debug(GetName(OBJECT_SELF) + "door open with warning given");
            if (IsOnOppositeSideOfDoor(oDoor, oTarget, OBJECT_SELF))
            {
//              Jug_Debug(GetName(OBJECT_SELF) + "door open return false");
                return FALSE;
            }
        }
        oDoor = GetNextObjectInShape(SHAPE_SPHERE, fRadius, middleLoc,
                    FALSE, OBJECT_TYPE_DOOR);
    }
    return TRUE;
}


int GetIsPCGroup(object oAssociate = OBJECT_SELF)
{
    return GetIsObjectValid(GetFactionLeader(oAssociate));
}


object GetTopMaster(object oAssociate = OBJECT_SELF)
{
    object oMaster = GetMaster(oAssociate);
    if (GetIsObjectValid(oMaster) && GetAssociateType(oMaster) == ASSOCIATE_TYPE_HENCHMAN)
    {
        return oMaster;
    }
    return OBJECT_SELF;
}


int HenchConvertClass(int nClass, object oCharacter)
{
    switch(nClass)
    {
        case CLASS_TYPE_WEAPON_MASTER:
        case CLASS_TYPE_DWARVENDEFENDER:
        case CLASS_TYPE_SHADOWTHIEFOFAMN:
        case CLASS_NWNINE_WARDER:
        case CLASS_TYPE_DUELIST:
            return CLASS_TYPE_FIGHTER;
        case CLASS_TYPE_DIVINECHAMPION:
            return CLASS_TYPE_PALADIN;
        case CLASS_TYPE_FRENZIEDBERSERKER:
            return CLASS_TYPE_BARBARIAN;
        case CLASS_TYPE_SHADOWDANCER:
        case CLASS_TYPE_ASSASSIN:
            return CLASS_TYPE_ROGUE;
        case CLASS_TYPE_HARPER:
        case CLASS_TYPE_ARCANE_ARCHER:
        case CLASS_TYPE_DRAGONDISCIPLE:
        case CLASS_TYPE_ELDRITCH_KNIGHT:
            return CLASS_TYPE_BARD;
        case CLASS_TYPE_SHIFTER:
            return CLASS_TYPE_DRUID;
        case CLASS_TYPE_PALEMASTER:
        case CLASS_TYPE_WARPRIEST:
        case CLASS_TYPE_ARCANETRICKSTER:
        case CLASS_TYPE_RED_WIZARD:
        case CLASS_TYPE_ARCANE_SCHOLAR:
        case CLASS_TYPE_STORMLORD:
        // match to spellcasting class (hopefully first class)
           return GetClassByPosition(1, oCharacter);
    }
    return nClass;
}


int HenchDetermineClassToUse(object oCharacter = OBJECT_SELF)
{
    int nClass;
    int nTotal = GetHitDice(oCharacter);
    if (nTotal < 1)
    {
        nTotal = 1;
    }

    int nClassLevel1 = GetLevelByPosition(1, oCharacter);
    int nClass1 =  GetClassByPosition(1, oCharacter);
    // quick exit
    if (nClassLevel1 >= nTotal)
    {
        return nClass1;
    }

    int nClassLevel2 = GetLevelByPosition(2, oCharacter);
    int nClass2 = GetClassByPosition(2, oCharacter);
    int nClassLevel3 = GetLevelByPosition(3, oCharacter);
    int nClass3 = GetClassByPosition(3, oCharacter);
    int nClassLevel4 = GetLevelByPosition(4, oCharacter);
    int nClass4 = GetClassByPosition(4, oCharacter);

    // adjust classes to remove prestige
    nClass1 = HenchConvertClass(nClass1, oCharacter);
    nClass2 = HenchConvertClass(nClass2, oCharacter);
    nClass3 = HenchConvertClass(nClass3, oCharacter);
    nClass4 = HenchConvertClass(nClass4, oCharacter);
    if (nClass1 == nClass2)
    {
        nClassLevel1 += nClassLevel2;
        nClassLevel2 = 0;
    }
    if (nClass1 == nClass3)
    {
        nClassLevel1 += nClassLevel3;
        nClassLevel3 = 0;
    }
    if (nClass1 == nClass4)
    {
        nClassLevel1 += nClassLevel4;
        nClassLevel4 = 0;
    }
    if (nClass2 == nClass3)
    {
        nClassLevel2 += nClassLevel3;
        nClassLevel3 = 0;
    }
    if (nClass2 == nClass4)
    {
        nClassLevel2 += nClassLevel4;
        nClassLevel4 = 0;
    }
    if (nClass3 == nClass4)
    {
        nClassLevel3 += nClassLevel4;
        nClassLevel4 = 0;
    }
    // find top class
    int nMaxClassLevel = nClassLevel1 >= nClassLevel2 ? nClassLevel1 : nClassLevel2;
    nMaxClassLevel = nMaxClassLevel >= nClassLevel3 ? nMaxClassLevel : nClassLevel3;
    // filter out classes less than two levels below the max
    if (nMaxClassLevel - 1 > nClassLevel1)
    {
        nClassLevel1 = 0;
    }
    if (nMaxClassLevel - 1 > nClassLevel2)
    {
        nClassLevel2 = 0;
    }
    if (nMaxClassLevel - 1 > nClassLevel3)
    {
        nClassLevel3 = 0;
    }
    nTotal = nClassLevel1 + nClassLevel2 + nClassLevel3;
    int nPickClass = Random(nTotal);
    nPickClass -= nClassLevel1;
    if (nPickClass < 0)
    {
        return nClass1;
    }
    nPickClass -= nClassLevel2;
    if (nPickClass < 0)
    {
        return nClass2;
    }
    return nClass3;
}


int CheckStealth()
{
    int nStealthCheck = GetLocalInt(OBJECT_SELF, "canStealth");
    if (nStealthCheck == 0)
    {
        int nThreshold = GetHitDice(OBJECT_SELF) / 2;
        nStealthCheck = ((GetSkillRank(SKILL_HIDE, OBJECT_SELF, TRUE) > nThreshold) ||
            (GetSkillRank(SKILL_MOVE_SILENTLY, OBJECT_SELF, TRUE) > nThreshold)) ? 1 : 2;
        SetLocalInt(OBJECT_SELF, "canStealth", nStealthCheck);
    }
    return nStealthCheck == 1;
}


void SetCombatMode(int nCombatMode = -1)
{
    // -2 means don't change anything
    if (nCombatMode < -1)
    {
        return;
    }
    int index;
    for (index = ACTION_MODE_PARRY; index <= ACTION_MODE_DIRTY_FIGHTING; index ++)
    {
        int bEnable = nCombatMode == index;
        if (GetActionMode(OBJECT_SELF, index) != bEnable)
        {
            if (bEnable)
            {
//          Jug_Debug(GetName(OBJECT_SELF) + " turn on " + IntToString(index));
                SetActionMode(OBJECT_SELF, index, TRUE);
            }
            else
            {
//          Jug_Debug(GetName(OBJECT_SELF) + " turn off " + IntToString(index));
                SetActionMode(OBJECT_SELF, index, FALSE);
            }
        }
    }
}


const string sHenchLastAttackLocation = "HENCH_LAST_ATTACK_LOC";

void UseCombatAttack(object oTarget, int nFeatID = -1, int nCombatMode = -1)
{
    SetCombatMode(nCombatMode);
    if (nFeatID < 0)
    {
        ActionAttack(oTarget);
    }
    else
    {
        ActionUseFeat(nFeatID, oTarget);
    }
    SetLocalLocation(OBJECT_SELF, sHenchLastAttackLocation, GetLocation(OBJECT_SELF));
}


const string henchCombatRoundStr = "tkCombatRoundCount";
const string henchLastDraBrStr = "tkLastDragonBreath";
const string henchLastDispelStr = "tkLastDispel";
const string henchLastDomStr = "tkLastDominate";
const string henchLastTurnStr = "tkLastTurning";
const string sHenchLastTarget = "LastTarget";
const string HENCH_AI_SCRIPT_HB             = "AIIntruderHB";
const string HENCH_AI_BLOCKED				= "HenchTargetIsBlocked";
const string sLastSpellTargetObject = "HenchLastSpellTarget"; // TODO remove this?


void CleanCombatVars()
{
    DeleteLocalInt(OBJECT_SELF, henchCombatRoundStr);
    DeleteLocalInt(OBJECT_SELF, henchLastDraBrStr);
    DeleteLocalInt(OBJECT_SELF, henchLastDispelStr);
    DeleteLocalInt(OBJECT_SELF, henchLastDomStr);
    DeleteLocalInt(OBJECT_SELF, henchLastTurnStr);
    DeleteLocalObject(OBJECT_SELF, sHenchLastTarget);
    DeleteLocalLocation(OBJECT_SELF, sHenchLastAttackLocation);
    DeleteLocalInt(OBJECT_SELF, HENCH_AI_SCRIPT_HB);
	DeleteLocalInt(OBJECT_SELF, HENCH_AI_BLOCKED);
}


void ReportUnseenAllies()
{
    location testTargetLoc = GetLocation(OBJECT_SELF);
    object oAllyTest = GetFirstObjectInShape(SHAPE_SPHERE, 20.0, testTargetLoc, TRUE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oAllyTest))
    {
        if ((oAllyTest != OBJECT_SELF) && !GetObjectSeen(oAllyTest) && GetFactionEqual(oAllyTest))
        {
            SpeakString(sHenchCantSeeTarget + GetName(oAllyTest));
        }
        oAllyTest = GetNextObjectInShape(SHAPE_SPHERE, 20.0, testTargetLoc, TRUE, OBJECT_TYPE_CREATURE);
    }
}


int GetHenchAssociateState(int nCondition, object oCreature = OBJECT_SELF)
{
    int result = GetLocalInt(oCreature, henchAssociateSettings);
    if (!result)
    {
        // check global setting to disable
        if (GetIsObjectValid(GetFactionLeader(OBJECT_SELF)) && !GetHenchOption(HENCH_OPTION_DISABLE_AUTO_BEHAVIOR_SET))
        {
            result |=  HENCH_ASC_BEEN_SET_ONCE | HENCH_ASC_ENABLE_HEALING_ITEM_USE |
				HENCH_ASC_DISABLE_POLYMORPH;
            int iBABLevel;
            int iHitDice = GetHitDice(oCreature);
            if (iHitDice < 5)
            {
                int nClass = GetClassByPosition(1, oCreature);
                switch (nClass)
                {
                case CLASS_TYPE_WIZARD:
                case CLASS_TYPE_SORCERER:
                case CLASS_TYPE_FEY:
                case CLASS_TYPE_WARLOCK:
                    iBABLevel = 0;
                    break;
                case CLASS_TYPE_BARD:
                case CLASS_TYPE_DRUID:
                case CLASS_TYPE_CLERIC:
                case CLASS_TYPE_MAGICAL_BEAST:
                case CLASS_TYPE_OUTSIDER:
				case CLASS_TYPE_FAVORED_SOUL:
				case CLASS_TYPE_SPIRIT_SHAMAN:
                    iBABLevel = 1;
                    break;
                default:
                    iBABLevel = 2;
                }
            }
            else
            {
                int iBABTest = 10 * GetBaseAttackBonus(oCreature);
                if (iBABTest >= 8 * iHitDice)
                {
                    iBABLevel = 2;  // high BAB creature
                }
                else if (iBABTest >= 6 * iHitDice)
                {
                    iBABLevel = 1; // medium BAB creature
                }
                else
                {
                    iBABLevel = 0; // low BAB creature
                }
            }
            if (GetWeaponRanged(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCreature)))
            {
                iBABLevel = 0; // treat as low BAB creature in order to keep using ranged weapons
                SetAssociateState(NW_ASC_USE_RANGED_WEAPON, TRUE, oCreature);
            }
            int associateType = GetAssociateType(oCreature);
            if ((associateType == ASSOCIATE_TYPE_NONE) || (associateType == ASSOCIATE_TYPE_HENCHMAN))
            {
                // still allow use of ranged weapons (prevents running off)
                SetAssociateState(NW_ASC_USE_RANGED_WEAPON, TRUE, oCreature);
            }
            // set follow and switch to melee distance
            if (iBABLevel == 0) // low BAB creature
            {
                SetAssociateState(NW_ASC_DISTANCE_2_METERS, FALSE, oCreature);
                SetAssociateState(NW_ASC_DISTANCE_4_METERS, FALSE, oCreature);
                SetAssociateState(NW_ASC_DISTANCE_6_METERS, TRUE, oCreature);
                result |= HENCH_ASC_MELEE_DISTANCE_NEAR | HENCH_ASC_ENABLE_BACK_AWAY;
            }
            else if (iBABLevel == 1) // medium BAB creature
            {
                SetAssociateState(NW_ASC_DISTANCE_2_METERS, FALSE, oCreature);
                SetAssociateState(NW_ASC_DISTANCE_4_METERS, TRUE, oCreature);
                SetAssociateState(NW_ASC_DISTANCE_6_METERS, FALSE, oCreature);
                result |= HENCH_ASC_MELEE_DISTANCE_MED;
            }
            else // high BAB creature
            {
                SetAssociateState(NW_ASC_DISTANCE_2_METERS, TRUE, oCreature);
                SetAssociateState(NW_ASC_DISTANCE_4_METERS, FALSE, oCreature);
                SetAssociateState(NW_ASC_DISTANCE_6_METERS, FALSE, oCreature);
                result |= HENCH_ASC_MELEE_DISTANCE_FAR;
            }
            // set overkill casting mode
            SetAssociateState(NW_ASC_OVERKIll_CASTING, TRUE, oCreature);
            SetAssociateState(NW_ASC_POWER_CASTING, FALSE, oCreature);
            SetAssociateState(NW_ASC_SCALED_CASTING, FALSE, oCreature);
            DeleteLocalInt(oCreature, N2_COMBAT_MODE_USE_DISABLED);
            SetLocalInt(oCreature, sHenchDontDispel, 10);
        }
        SetLocalInt(oCreature, henchAssociateSettings, result);
    }
    return result & nCondition;
}


int GetHenchPartyState(int nCondition, object oCreature = OBJECT_SELF)
{
    object oPlayerCharacter = GetOwnedCharacter(GetFactionLeader(oCreature));
    int result = GetLocalInt(oPlayerCharacter, henchPartySettings);
    return result & nCondition;
}


int GetMeleeWeaponSize(object oItem)
{
    if (GetWeaponRanged(oItem) || (GetWeaponType(oItem) == WEAPON_TYPE_NONE))
    {
        return 0;
    }
    int nBase = GetBaseItemType(oItem);
    string sWeaponSizeStr = "HENCH_AI_WEAPON_SIZE_" + IntToString(nBase);
    object oModule = GetModule();
    int iWeaponSize = GetLocalInt(oModule, sWeaponSizeStr);
    if (iWeaponSize == 0)
    {
        iWeaponSize = StringToInt(Get2DAString("baseitems", "WeaponSize", nBase));
        if (iWeaponSize == 0)
        {
            iWeaponSize = -1;
        }
        SetLocalInt(oModule, sWeaponSizeStr, iWeaponSize);
    }
    if (iWeaponSize > 0)
    {
        return iWeaponSize;
    }
    return 0;
}


struct sAttackInfo GetItemAttackBonus(object oTarget, object oItem)
{
    struct sAttackInfo sReturnVal;
    // TODO not getting damage bonus, base item damage yet
//  int damageAdjust;

    itemproperty oProp = GetFirstItemProperty(oItem);
    while (GetIsItemPropertyValid(oProp))
    {
        int bGetSetting;
        int bAdjustDamage;
        switch (GetItemPropertyType(oProp))
        {
        case ITEM_PROPERTY_ENHANCEMENT_BONUS:
            bAdjustDamage = TRUE;
        case ITEM_PROPERTY_ATTACK_BONUS:
            bGetSetting = TRUE;
            break;
        case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP:
            bAdjustDamage = TRUE;
        case ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP:
            switch (GetItemPropertySubType(oProp))
            {
            case IP_CONST_ALIGNMENTGROUP_NEUTRAL:
                bGetSetting = (GetAlignmentGoodEvil(oTarget) == ALIGNMENT_NEUTRAL) ||
                    (GetAlignmentLawChaos(oTarget) == ALIGNMENT_NEUTRAL);
                break;
            case IP_CONST_ALIGNMENTGROUP_LAWFUL:
                bGetSetting = GetAlignmentLawChaos(oTarget) == ALIGNMENT_LAWFUL;
                break;
            case IP_CONST_ALIGNMENTGROUP_CHAOTIC:
                bGetSetting = GetAlignmentLawChaos(oTarget) == ALIGNMENT_CHAOTIC;
                break;
            case IP_CONST_ALIGNMENTGROUP_GOOD:
                bGetSetting = GetAlignmentGoodEvil(oTarget) == ALIGNMENT_GOOD;
                break;
            case IP_CONST_ALIGNMENTGROUP_EVIL:
                bGetSetting = GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL;
                break;
            }
            break;
        case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP:
            bAdjustDamage = TRUE;
        case ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP:
            bGetSetting = GetItemPropertySubType(oProp) == GetRacialType(oTarget);
            break;
        case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT:
            bAdjustDamage = TRUE;
        case ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT:
            {
                int iSpecificAlignment = GetItemPropertySubType(oProp);
                switch (iSpecificAlignment % 3)
                {
                case 0:
                    bGetSetting = GetAlignmentGoodEvil(oTarget) == ALIGNMENT_GOOD;
                    break;
                case 1:
                    bGetSetting = GetAlignmentGoodEvil(oTarget) == ALIGNMENT_NEUTRAL;
                    break;
                case 2:
                    bGetSetting = GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL;
                    break;
                }
                if (bGetSetting)
                {
                    bGetSetting = FALSE;
                    switch (iSpecificAlignment / 3)
                    {
                    case 0:
                        bGetSetting = GetAlignmentLawChaos(oTarget) == ALIGNMENT_LAWFUL;
                        break;
                    case 1:
                        bGetSetting = GetAlignmentLawChaos(oTarget) == ALIGNMENT_NEUTRAL;
                        break;
                    case 2:
                        bGetSetting = GetAlignmentLawChaos(oTarget) == ALIGNMENT_CHAOTIC;
                        break;
                    }
                }
            }
            break;
/*      case ITEM_PROPERTY_MIGHTY:
            {
                int nStrMod = GetAbilityModifier(ABILITY_STRENGTH, oCreature);
                int itemPropValue = GetItemPropertyCostTableValue(oProp);
                if (itemPropValue < nStrMod)
                {
                    nStrMod = itemPropValue;
                }
                damageAdjust += nStrMod;
            }
            break; */
        }
        if (bGetSetting)
        {
            int itemPropValue = GetItemPropertyCostTableValue(oProp);
            if (itemPropValue > sReturnVal.attackBonus)
            {
                 sReturnVal.attackBonus = itemPropValue;
            }
            if (bAdjustDamage && (itemPropValue > sReturnVal.damageBonus))
            {
                 sReturnVal.damageBonus = itemPropValue;
            }
        }
        oProp = GetNextItemProperty(oItem);
    }
    return sReturnVal;
}


struct sAttackInfo GetMeleeAttackBonus(object oCreature, object oWeaponRight, object oTarget)
{
    struct sAttackInfo sReturnVal;
    // Finesse only if we are using a proper weapon
    int nStrMod = GetAbilityModifier(ABILITY_STRENGTH, oCreature);
    int nDexMod = GetAbilityModifier(ABILITY_DEXTERITY, oCreature);
    int bCanFinesse = GetHasFeat(FEAT_WEAPON_FINESSE, oCreature) && (nDexMod > nStrMod);

    object oWeaponLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCreature);
    if (GetIsObjectValid(oWeaponRight))
    {
        sReturnVal = GetItemAttackBonus(oTarget, oWeaponRight);
        if (bCanFinesse)
        {
            switch (GetBaseItemType(oWeaponRight))
            {
                // only these weapons can be finessed
            case BASE_ITEM_DAGGER:
            case BASE_ITEM_HANDAXE:
            case BASE_ITEM_KAMA:
            case BASE_ITEM_KUKRI:
            case BASE_ITEM_LIGHTHAMMER:
            case BASE_ITEM_LIGHTMACE:
            case BASE_ITEM_RAPIER:
            case BASE_ITEM_SHORTSWORD:
            case BASE_ITEM_SHURIKEN:
            case BASE_ITEM_SICKLE:
            case BASE_ITEM_THROWINGAXE:
                break;
            default:
                bCanFinesse = FALSE;
            }
        }

        if (!GetIsObjectValid(oWeaponLeft))
        {
            if (GetMeleeWeaponSize(oWeaponRight) >= GetCreatureSize(oCreature))
            {
                sReturnVal.damageBonus += nStrMod / 2;
            }
        }
    }
    else
    {
            // note: creature weapons can be finessed
        oWeaponRight = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oCreature);
        if (GetIsObjectValid(oWeaponRight))
        {
            sReturnVal = GetItemAttackBonus(oTarget, oWeaponRight);
        }
        else
        {
            oWeaponRight = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oCreature);
            if (GetIsObjectValid(oWeaponRight))
            {
                sReturnVal = GetItemAttackBonus(oTarget, oWeaponRight);
            }
            else
            {
                oWeaponRight = GetItemInSlot(INVENTORY_SLOT_ARMS, oCreature);
                if (GetIsObjectValid(oWeaponRight))
                {
                    sReturnVal = GetItemAttackBonus(oTarget, oWeaponRight);
                }
            }
        }
    }
    int nOffHandWeaponSize = GetMeleeWeaponSize(oWeaponLeft);
    if (nOffHandWeaponSize > 0)
    {
        if (nOffHandWeaponSize == GetCreatureSize(oCreature))
        {
            sReturnVal.attackBonus -= 2;
        }
        else
        {
            // TODO more could be done here
            sReturnVal.attackBonus -= 4;
        }
    }
    if(bCanFinesse)
    {
        sReturnVal.attackBonus += nDexMod;
    }
    else
    {
        sReturnVal.attackBonus += nStrMod;
    }
    sReturnVal.damageBonus += nStrMod;
    return sReturnVal;
}


struct sAttackInfo GetRangeAttackBonus(object oCreature, object oRangedWeapon, object oTarget)
{
    struct sAttackInfo nReturnVal = GetItemAttackBonus(oTarget, oRangedWeapon);
    int nDexMod = GetAbilityModifier(ABILITY_DEXTERITY, oCreature);
    int nWisMod = GetAbilityModifier(ABILITY_WISDOM, oCreature);
    if (GetHasFeat(FEAT_ZEN_ARCHERY, oCreature) && (nWisMod > nDexMod))
    {
        nReturnVal.attackBonus += nWisMod;
    }
    else
    {
        nReturnVal.attackBonus += nDexMod;
    }
    int itemType = GetBaseItemType(oRangedWeapon);
    if ((itemType == BASE_ITEM_LONGBOW) || (itemType  == BASE_ITEM_SHORTBOW))
    {
        int nLevel = GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER, oCreature);
        if (nLevel > 0)
        {
            nLevel = (nLevel+1)/2;
            nReturnVal.attackBonus += nLevel;
            nReturnVal.damageBonus += nLevel;
        }
    }
    return nReturnVal;
}


struct sAttackInfo GetAttackBonus(object oCreature, object oTarget)
{
    struct sAttackInfo sReturnVal;
    object oRightWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCreature);
    if (GetWeaponRanged(oRightWeapon))
    {
        sReturnVal = GetRangeAttackBonus(oCreature, oRightWeapon, oTarget);
    }
    else
    {
        sReturnVal = GetMeleeAttackBonus(oCreature, oRightWeapon, oTarget);
    }
    sReturnVal.attackBonus += GetLocalInt(oCreature, attackBonusStr);
    return sReturnVal;
}