//:://////////////////////////////////////////////////
//:: X0_I0_TALENT
/*
  Library for talent functions.

  All of these functions attempt to use a particular category
  of skill, and return TRUE on success, FALSE on failure. This
  allows for building up fall-through chains where one talent
  after another is attempted, with the order determined by the
  creature's particular tactics.

 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 01/20/2003
//:: Modified By: Georg Zoeller, 2003-Oct-21:
//::        - commented debug strings
//::        - updated talent advanced buff to include some xp2 stuff          \
//::        - added some code to prevent TalentBardsong from breaking in
//::          epic levels
//:://////////////////////////////////////////////////
// ChazM 7/20/06 - replaced TalentBardSong()
// ChazM 7/21/06 - minor fix - Bard song related
// BMA-OEI 8/01/06 - removed undetectable Bard Songs from selection
// ChazM 8/4/06 - modified calls to GetCreatureTalentRandom() and GetCreatureTalentBest() to 
//				observe an exclude flag set on the creature.
// DBR 08/06/06 - Typo fix - scope of GetCreatureTalent()
// DBR 09/07/06 - Added TalentKnockdown()
// ChazM 9/19/06 rename bkTalentFilter() as TalentFilter()
// ChazM 9/19/06 moved GetCreatureTalentBestStd(), GetCreatureTalentRandomStd(), GetCreatureTalent() to x0_inc_generic;
//				added prototype and moved TryKiDamage(), removed some commented code
// BMA-OEI 9/20/06 -- TalentHealingSelf(), TalentPersistentAbilities(): Disable spell casting while Polymorphed
// BMA-OEI 10/12/06 -- TalentMeleeAttack(): Check N2_COMBAT_MODE_USE_DISABLED
// ChazM 1/16/07 - inserted nwn2_inc_talent into the AI include chain
// ChazM 1/18/07 - EvenFlw AI functions added - includes numerous modified functions
// ChazM 1/29/07 - renamed oFirst()/oNext() to GetFirstTalentTarget()/GetFirstTalentTarget() to remove collision w/ variable names in some files 
//				- made both TalentAdvancedBuff() and TalentAdvancedBuff2() available (Many scripts still use this w/ the old interface)
// ChazM 1/27/07 - tweaked TalentHealingSelf()
// ChazM 6/8/07 - added condition constants, modified CureCondition code
// MDiekmann 6/27/07 - Modified TalentHealSelf, to not make animal companions go into defensive casting mode.
// MDiekmann 6/27/07 - Modified TalentHealSelf, to not make anyone go into defensive casting mode who is not capable.
// MDiekmann 7/17/07 - Fixes for determing whether or not companions go into defensive casting mode
// MDiekmann 8/10/07 - Fix for using heal spells when spellcasting is set to off 

//void main(){}
#include "nwn2_inc_talent"
//#include "x0_inc_generic" - include in nwn2_inc_talent

// "x0_inc_generic" has the frequently used TalentFilter().  There are also 
// references to assets from "x0_i0_enemy" and "x0_i0_match"

//========================================================
// CONSTANTS
//========================================================

// Added by Brent, constant for 'always get me it' things like Healing
const int TALENT_ANY = 20;


// Bitwise constants for negative conditions we might want to try to cure
const int COND_CURSE     = 0x00000001;
const int COND_POISON    = 0x00000002;
const int COND_DISEASE   = 0x00000004;
const int COND_ABILITY   = 0x00000008;
const int COND_DRAINED   = 0x00000010;
const int COND_BLINDDEAF = 0x00000020;
const int COND_FEAR      = 0x00000040;
const int COND_PARALYZE  = 0x00000080;
const int COND_PETRIFY   = 0x00000100;
const int COND_SLOW   	 = 0x00000200;

const float WHIRL_DISTANCE = 3.0; // * Shortened distance so its more effective (went from 5.0 to 2.0 and up to 3.0)

const string EVENFLW_AI_UNPOLY 			= "EVENFLW_AI_UNPOLY";
const string EVENFLW_LAST_TURN_TARGET 	= "EVENFLW_LAST_TURN_TARGET";
const string EVENFLW_SWITCHES 			= "EVENFLW_SWITCHES";

//========================================================
// FUNCTION PROTOTYPES
//========================================================

// * Tries to do the Ki Damage ability
int TryKiDamage(object oTarget);

// Try a spell to produce a particular spell effect.
// This will only cast the spell if the target DOES NOT already have the
// given spell effect, and the caster possesses the spell.
//
// Returns TRUE on success, FALSE on failure.
int TrySpell(int nSpell, object oTarget=OBJECT_SELF, object oCaster=OBJECT_SELF);

// Try a spell corresponding to a particular effect.
// This will only cast the spell if the target DOES have the
// given effect, and the caster possesses the spell.
//
// Returns TRUE on success, FALSE on failure.
int TrySpellForEffect(int nSpell, int nEffect, object oTarget=OBJECT_SELF, object oCaster=OBJECT_SELF);

// Try a given talent.
// This will only cast spells and feats if the targets do not already
// have the effects of those feats, and will funnel all talents
// through TalentFilter for a final check.
//int TryTalent(talent tUse, object oTarget=OBJECT_SELF, object oCaster=OBJECT_SELF);
int TryTalent(talent tUse, object oTarget=OBJECT_SELF, int area=FALSE);

// PROTECT SELF
// Returns TRUE on successful use of such a talent, FALSE otherwise.
int TalentUseProtectionOnSelf();

// PROTECT PARTY
// Returns TRUE on successful use of such a talent, FALSE otherwise.
int TalentUseProtectionOthers(object oDefault=OBJECT_INVALID);

// ENHANCE OTHERS
// Returns TRUE on successful use of such a talent, FALSE otherwise.
int TalentEnhanceOthers();

// ENHANCE SELF
// Returns TRUE on successful use of such a talent, FALSE otherwise.
int TalentUseEnhancementOnSelf();

// SPELL CASTER MELEE ATTACKED
//    Wrote this function so I could do further
//   checks such as making them not cast
//    Dispel Magic.
// * Possible Issue (brent): It may get stuck on
// * dispel magics...trying to cast them
// * and not proceed down Area Of Effect Discriminants...
//  SOLUTION: If this function returns true the TalentMeleeAttacked routine
//  will exit, however if it returns false, it will try and find some
//  other ability to use.
int genericDoHarmfulRangedAttack(talent tUse, object oTarget);

//    Will return true if it succesfully
//    used a harmful ranged talent.
int genericAttemptHarmfulRanged(talent tUse, object oTarget);

// MELEE ATTACKED
// Returns TRUE on successful use of such a talent, FALSE otherwise.
//int TalentMeleeAttacked(object oIntruder = OBJECT_INVALID);
int TalentMeleeAttacked(object oIntruder = OBJECT_INVALID, int nMelee=0);

// SPELL CASTER RANGED ATTACKED
// Returns TRUE on successful use of such a talent, FALSE otherwise.
int TalentRangedAttackers(object oIntruder = OBJECT_INVALID);

// SPELL CASTER WITH RANGED ENEMIES
// Returns TRUE on successful use of such a talent, FALSE otherwise.
int TalentRangedEnemies(object oIntruder = OBJECT_INVALID);

// SUMMON ALLIES
// Returns TRUE on successful use of such a talent, FALSE otherwise.
int TalentSummonAllies();

// HEAL SELF WITH POTIONS AND SPELLS
// Returns TRUE on successful use of such a talent, FALSE otherwise.
int TalentHealingSelf(int bForce = FALSE); //Use spells and potions

//Use spells only on others and self
// Returns TRUE on successful use of such a talent, FALSE otherwise.
int TalentHeal(int nForce = FALSE, object oTarget = OBJECT_SELF);

// MELEE ATTACK OTHERS
//     ISSUE 1: Talent Melee Attack should set the Last Spell Used
//     to 0 so that melee casters can use a single special ability.
// Returns TRUE on successful use of such a talent, FALSE otherwise.
int TalentMeleeAttack(object oIntruder = OBJECT_INVALID);

// SNEAK ATTACK OTHERS
// Returns TRUE on successful use of such a talent, FALSE otherwise.
int TalentSneakAttack();

// FLEE COMBAT AND HOSTILES
// Returns TRUE on successful use of such a talent, FALSE otherwise.
int TalentFlee(object oIntruder = OBJECT_INVALID);

// TURN UNDEAD
// Returns TRUE on successful use of such a talent, FALSE otherwise.
//int TalentUseTurning();
int TalentUseTurning(object oUndead=OBJECT_INVALID);

// ACTIVATE AURAS
// Returns TRUE on successful use of such a talent, FALSE otherwise.
int TalentPersistentAbilities();

// FAST BUFF SELF
// Returns TRUE on successful use of such a talent, FALSE otherwise.
int TalentAdvancedBuff(float fDistance, int bInstant = TRUE);
int TalentAdvancedBuff2(object oTarget=OBJECT_SELF, object oIntruder=OBJECT_INVALID, int ismage=0, int castingmode=0);

// USE POTIONS
//Used for Potions of Enhancement and Protection
// Returns TRUE on successful use of such a talent, FALSE otherwise.
int TalentBuffSelf();

// USE SPELLS TO DEFEAT INVISIBLE CREATURES
// THIS TALENT IS NOT USED
// Returns TRUE on successful use of such a talent, FALSE otherwise.
int TalentSeeInvisible();

// Utility function for TalentCureCondition
// Checks to see if the creature has the given condition in the
// given condition value.
// To use, you must first calculate the nCurrentConditions value
// with GetCurrentNegativeConditions.
// The value of nCondition can be any of the COND_* constants
// declared in x0_i0_talent.
int GetHasNegativeCondition(int nCondition, int nCurrentConditions);

// Utility function for TalentCureCondition
// Returns an integer with bitwise flags set that represent the
// current negative conditions on the creature.
// To be used with GetHasNegativeCondition.
int GetCurrentNegativeConditions(object oCreature);

// CURE DISEASE, POISON ETC
// Returns TRUE on successful use of such a talent, FALSE otherwise.
int TalentCureCondition();

// DRAGON COMBAT
// Returns TRUE on successful use of such a talent, FALSE otherwise.
int TalentDragonCombat(object oIntruder = OBJECT_INVALID);

// BARD SONG
// Returns TRUE on successful use of such a talent, FALSE otherwise.
int TalentBardSong();

// ADVANCED PROTECT SELF Talent 2.0
// This will use the class specific defensive spells first and
// leave the rest for the normal defensive AI
// Returns TRUE on successful use of such a talent, FALSE otherwise.
int TalentAdvancedProtectSelf();

// Cast a spell mantle or globe of invulnerability protection on
// yourself.
int TalentSelfProtectionMantleOrGlobe();

// Returns TRUE on successful use of such a talent, FALSE otherwise.
int TalentSpellAttack(object oIntruder);

// This function simply attempts to get the best protective
// talent that the caller has, the protective talents as
// follows:
// TALENT_CATEGORY_BENEFICIAL_PROTECTION_SELF
// TALENT_CATEGORY_BENEFICIAL_PROTECTION_SINGLE
// TALENT_CATEGORY_BENEFICIAL_PROTECTION_AREAEFFECT
talent StartProtectionLoop();

// KNOCKDOWN / IMPROVED KNOCKDOWN
// This function tries to use the knockdown feat on oIntruder.
// returns TRUE on Knockdown is ok to try on this combat round,
// returns FALSE if Knockdown will not be tried for whatever reason.
// If TRUE is returned, Kncokdown will already have been put on the action queue.
int TalentKnockdown(object oIntruder);


int TestTalent(talent tUse, object oTarget, int isArea=FALSE);
int genericAttemptHarmful(talent tUse, object oTarget, int cat);
int SumMord();
int TalentDebuff(object oIntruder=OBJECT_INVALID);
object GetFirstTalentTarget(int bFactionOnly, float fRadius);
object GetNextTalentTarget(int bFactionOnly, float fRadius);
int TalentResurrect();
int TrySpellGroup(int nSpell1, int nSpell2, int nSpell3=-1, int nSpell4=-1, object oTarget=OBJECT_SELF, object oCaster=OBJECT_SELF, int nSpell5=-1, int nSpell6=-1);
int TalentOthers(int nCompassion, object oIntruder=OBJECT_INVALID, int ismage=0, int castingmode=0);
int TalentLastDitch();
int TalentCantrip(object oIntruder);


//========================================================
// FUNCTION DEFINITIONS
//========================================================

 // * Tries to do the Ki Damage ability
int TryKiDamage(object oTarget)
{
    if (GetIsObjectValid(oTarget) == FALSE)
    {
        return FALSE;

    }
    if (GetHasFeat(FEAT_KI_DAMAGE) == TRUE)
    {
        // * Evaluation:
        // * Must have > 40 hitpoints AND  (damage reduction OR damage resistance)
        // * Or just have over 200 hitpoints
        int bHasDamageReduction = FALSE;
        int bHasDamageResistance = FALSE;
        int bHasHitpoints = FALSE;
        int bHasMassiveHitpoints = FALSE;
        int bOutNumbered = FALSE;

        int nCurrentHP = GetCurrentHitPoints(oTarget);
        if (nCurrentHP > 40)
            bHasHitpoints = TRUE;
        if (nCurrentHP > 200)
            bHasMassiveHitpoints = TRUE;
        if (GetHasEffect(EFFECT_TYPE_DAMAGE_REDUCTION, oTarget) == TRUE)
            bHasDamageReduction = TRUE;
        if (GetHasEffect(EFFECT_TYPE_DAMAGE_RESISTANCE, oTarget) == TRUE)
            bHasDamageResistance = TRUE;

        if (GetIsObjectValid(GetNearestEnemy(OBJECT_SELF, 3)) == TRUE)
        {
            bOutNumbered = TRUE;
        }

        if ( (bHasHitpoints && (bHasDamageReduction || bHasDamageResistance) ) || (bHasMassiveHitpoints) || (bHasHitpoints && bOutNumbered) )
        {
            ClearAllActions();
            ActionUseFeat(FEAT_KI_DAMAGE, oTarget);
            return TRUE;
        }
    }
    return FALSE;
}
 
 
 
// Try a spell to produce a particular spell effect.
// This will only cast the spell if the target DOES NOT already have the
// given spell effect, and the caster possesses the spell.
//
// Returns TRUE on success, FALSE on failure.
int TrySpell(int nSpell, object oTarget=OBJECT_SELF, object oCaster=OBJECT_SELF)
{
    if (GetHasSpell(nSpell, oCaster) && !GetHasSpellEffect(nSpell, oTarget)) {
        AssignCommand(oCaster,
                      ActionCastSpellAtObject(nSpell, oTarget));
        return TRUE;
    }
    return FALSE;
}

// Try a spell corresponding to a particular effect.
// This will only cast the spell if the target DOES have the
// given effect, and the caster possesses the spell.
//
// Returns TRUE on success, FALSE on failure.
int TrySpellForEffect(int nSpell, int nEffect, object oTarget=OBJECT_SELF, object oCaster=OBJECT_SELF)
{
    if (GetHasSpell(nSpell, oCaster) && GetHasEffect(nEffect, oTarget)) {
        AssignCommand(oCaster,
                      ActionCastSpellAtObject(nSpell, oTarget));
        return TRUE;
    }
    return FALSE;
}

// Try a given talent.
// This will only cast spells and feats if the targets do not already
// have the effects of those feats, and will funnel all talents
// through TalentFilter for a final check.
int TryTalent(talent tUse, object oTarget=OBJECT_SELF, int area=FALSE)
{
	if(!GetIsTalentValid(tUse)) return FALSE;
    int nType = GetTypeFromTalent(tUse);
    int nIndex = GetIdFromTalent(tUse);
    if(nType == TALENT_TYPE_SPELL  && (GetHasSpellEffect(nIndex, oTarget) || (area && GetHasSpellEffect(nIndex, OBJECT_SELF))))
    {
        return FALSE;
    }
    else if(nType == TALENT_TYPE_FEAT && (GetHasFeatEffect(nIndex, oTarget) || (area && GetHasFeatEffect(nIndex, OBJECT_SELF))))
    {
        return FALSE;
    }
	if(EvenTalentCheck(tUse, oTarget)) {
    	EvenTalentFilter(tUse, OBJECT_SELF);
	    return TRUE;
	}
    return FALSE;
}

/*
// Try a given talent.
// This will only cast spells and feats if the targets do not already
// have the effects of those feats, and will funnel all talents
// through TalentFilter for a final check.
int TryTalent(talent tUse, object oTarget=OBJECT_SELF, object oCaster=OBJECT_SELF)
{
    int nType = GetTypeFromTalent(tUse);
    int nIndex = GetIdFromTalent(tUse);
    if(nType == TALENT_TYPE_SPELL  && GetHasSpellEffect(nIndex, oTarget))
    {
        return FALSE;
    }
    else if(nType == TALENT_TYPE_FEAT && GetHasFeatEffect(nIndex, oTarget))
    {
        return FALSE;

    }
    // MODIFIED February 7 2003. Implicit else, implies success.
    TalentFilter(tUse, OBJECT_SELF);
    //MyPrintString("TryTalent Successful Exit");
    return TRUE;

    return FALSE;
}
*/

//:://////////////////////////////////////////////////////////
//:: Talent checks and use functions
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////////////////
//
//    This is a series of functions that check
//    if a particular type of talent is available and
//    if so then use that talent.
//
//:://////////////////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 16, 2001
//:://////////////////////////////////////////////////////////

// PROTECT SELF
int TalentUseProtectionOnSelf()
{
    //MyPrintString("TalentUseProtectionOnSelf Enter");
    talent tUse;
    int nType, nIndex;
    int bValid = FALSE;
    int nCR = GetCRMax();

    tUse = GetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_PROTECTION_SELF,
                                 GetCRMax());

    if(!GetIsTalentValid(tUse)) {
        tUse = GetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_PROTECTION_SINGLE,
                                     GetCRMax());
        if(GetIsTalentValid(tUse))  {
            ////MyPrintString("I have found a way to protect my self");
            bValid = TRUE;
        }
    } else {
        ////MyPrintString("I have found a way to protect my self");
        bValid = TRUE;
    }


    if (bValid == TRUE) {
        if (TryTalent(tUse)) {
            //MyPrintString("TalentUseProtectionOnSelf Successful Exit");
            return TRUE;
        }
    }

    //MyPrintString("TalentUseProtectionOnSelf Failed Exit");
    return FALSE;
}

//PROTECT PARTY
int TalentUseProtectionOthers(object oDefault=OBJECT_INVALID)
{
    //MyPrintString("TalentUseProtectionOthers Enter");
    talent tUse, tMass;
    int nType, nFriends, nIndex;
    int nCnt = 1;
    int bValid = FALSE;
    int nCR = GetCRMax();

    tUse = GetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_PROTECTION_SINGLE,
                                 nCR);
    tMass = GetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_PROTECTION_AREAEFFECT,
                                  nCR);
    object oTarget;

    // Pausanias: added option for the spell to have a specified target.
    if (oDefault == OBJECT_INVALID)  {
        oTarget = GetNearestSeenFriend();
    } else {
        oTarget = oDefault;
    }

    //Override the nearest target if the master wants aggressive buff spells
    if(GetAssociateState(NW_ASC_AGGRESSIVE_BUFF)
       && GetAssociateState(NW_ASC_HAVE_MASTER))
    {
        oTarget = GetMaster();
    }

    while(GetIsObjectValid(oTarget)) {
        if(GetIsTalentValid(tMass) && CheckFriendlyFireOnTarget(oTarget) > 2) {
            if (TryTalent(tMass, oTarget)) {
                //MyPrintString("TalentUseProtectionOthers Successful Exit");
                return TRUE;
            }
        }

        if(GetIsTalentValid(tUse)) {
            if (TryTalent(tUse, oTarget)) {
                //MyPrintString("TalentUseProtectionOthers Successful Exit");
                return TRUE;
            }
        }
        nCnt++;
        oTarget = GetNearestSeenFriend(OBJECT_SELF, nCnt);
    }
    //MyPrintString("TalentUseProtectionOthers Failed Exit");
    return FALSE;
}

// ENHANCE OTHERS
int TalentEnhanceOthers()
{
    //MyPrintString("TalentEnhanceOthers Enter");
    talent tUse, tMass;
    int nType, nFriends, nIndex;
    int nCnt = 1;
    int bValid = FALSE;
    int nCR = GetCRMax();
    object oTarget = GetNearestSeenFriend();
    tUse = GetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_SINGLE, nCR);
    tMass = GetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_AREAEFFECT, nCR);

    //Override the nearest target if the master wants aggressive buff spells
    if(GetAssociateState(NW_ASC_AGGRESSIVE_BUFF)
       && GetAssociateState(NW_ASC_HAVE_MASTER))
    {
        oTarget = GetMaster();
    }

    while(GetIsObjectValid(oTarget)) {
        if(GetIsTalentValid(tMass)) {
            if(CheckFriendlyFireOnTarget(oTarget) > 2) {
                if (TryTalent(tMass, oTarget)) {
                    //MyPrintString("TalentEnhanceOthers Successful Exit");
                    return TRUE;
                }
            }
        }

        if(GetIsTalentValid(tUse)) {
            if (TryTalent(tUse, oTarget)) {
                    //MyPrintString("TalentEnhanceOthers Successful Exit");
                    return TRUE;
            }
        }
        nCnt++;
        oTarget = GetNearestSeenFriend(OBJECT_SELF, nCnt);
    }
    //MyPrintString("TalentEnhanceOthers Failed Exit");
    return FALSE;
}

// ENHANCE SELF
int TalentUseEnhancementOnSelf()
{
    //MyPrintString("TalentUseEnhancementOnSelf Enter");
    talent tUse;
    int nType;
    int bValid = FALSE;
    int nIndex;
    int nCR = GetCRMax();

    tUse = GetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_SELF,
                                 GetCRMax());
    if(!GetIsTalentValid(tUse))  {
        tUse = GetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_SINGLE,
                                     GetCRMax());
        if(GetIsTalentValid(tUse)) {
            bValid = TRUE;
        }
    } else {
        bValid = TRUE;
    }

    if(bValid == TRUE) {
        if (GetIdFromTalent(tUse) == SPELL_INVISIBILITY && Random(2) == 0) {
            //MyPrintString("Decided not to use Invisibility");
            return FALSE; // BRENT JULY 2002: There is a 50% chance that
                          // they will not use invisibility if they have it
        }

        if (TryTalent(tUse)) {
            //MyPrintString("TalentUseEnhancementOnSelf Successful Exit");
            return TRUE;
        }
    }

    //MyPrintString("TalentUseEnhancementOnSelf Failed Exit");
    return FALSE;
}

// SPELL CASTER MELEE ATTACKED

// Wrote this function so I could do further
// checks such as making them not cast Dispel Magic.
// * Possible Issue (brent): It may get stuck on
// * dispel magics...trying to cast them
// * and not proceed down Area Of Effect Discriminants...
//  SOLUTION: If this function returns true the TalentMeleeAttacked routine
//  will exit, however if it returns false, it will try and find some
//  other ability to use.
//:: Created By: Brent
//:: Created On: July 2002

int genericDoHarmfulRangedAttack(talent tUse, object oTarget)
{
    //MyPrintString("BK: genericDoharmfulRangedAttack");

    int bConditionsMet = FALSE;
    // * check to see if this talent is a spell talent
    if (GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL)
    {
        int nSpellID = GetIdFromTalent(tUse);
        // * Check to see if Dispel Magic and similar spells should *not* be cast
        if (nSpellID == SPELL_DISPEL_MAGIC || nSpellID == SPELL_MORDENKAINENS_DISJUNCTION
           || nSpellID == SPELL_LESSER_DISPEL || nSpellID == SPELL_GREATER_DISPELLING)
        {
            //MyPrintString("BK: inside of dispel magic");
            effect eEffect = GetFirstEffect(oTarget);
            while (GetIsEffectValid(eEffect) == TRUE)
            {
                //MyPrintString("BK: Valid effect");
                int nEffectID = GetEffectSpellId(eEffect);
                // * JULY 14 2003
                // * If the effects originated from me (i.e., I cast
                // * a disabling effect on you. Then I will not
                // * dispel that effect
                if (GetEffectCreator(eEffect) == OBJECT_SELF)
                {

                  bConditionsMet = FALSE;
                  break;
                }
                else
                // * this effect was applied from a spell if it
                // * isn't -1
                // * dispel magic should only attempt to remove spell
                // * granted effects
                if (nEffectID == -1)
                {
                 //MyPrintString("BK: conditions NOT met");
                }
                else
                {
                    //MyPrintString("BK: conditions met");
                 bConditionsMet = TRUE;
                }
                eEffect = GetNextEffect(oTarget);
            }
        } else {
             // if not a special condition spell then conditions are met auto.
             bConditionsMet = TRUE;
        }
    }


    // * only returns true if all of the conditions are met.
    if (bConditionsMet == TRUE)
    {
        //MyPrintString("BK: bCOnditionsMet == TRUE");
        //DebugPrintTalentID(tUse);
        //MyPrintString("TalentMeleeAttacked Successful Exit");
        TalentFilter(tUse, oTarget);
        return TRUE;
    }

    return FALSE;
}

//    Will return true if it succesfully
//    used a harmful ranged talent.
//    BK: Wrapper function to encapsulate some
//    commonly used behavior in these scripts.
//:: Created By: Brent
//:: Created On: July 2002
int genericAttemptHarmfulRanged(talent tUse, object oTarget)
{
    //SpawnScriptDebugger();
    if(  GetTypeFromTalent(tUse) != TALENT_TYPE_SPELL
         ||
         (GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL
          && !GetHasSpellEffect(GetIdFromTalent(tUse), oTarget)
          && !CompareLastSpellCast(GetIdFromTalent(tUse)) )
      )
    {
        //MyPrintString("2164: Can try to do a DoHarmfulRangedAttack");
        if (genericDoHarmfulRangedAttack(tUse, oTarget)) {
            if( GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL) {
                SetLastGenericSpellCast(GetIdFromTalent(tUse));
            }
            return TRUE;
        }
    }
    else
    // MODIFIED
    // Try to find a suitable second choice (up to 5 tries to find one)
    {
    int nSteps = 0;
    int bDone = FALSE;


      while (bDone == FALSE)
      {
        if (nSteps >= 5)
            bDone = TRUE;

        nSteps++;

        tUse = GetCreatureTalentRandomStd(TALENT_CATEGORY_HARMFUL_RANGED);
        if (GetTypeFromTalent(tUse) != TALENT_TYPE_SPELL
          ||
          (GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL
           && !GetHasSpellEffect(GetIdFromTalent(tUse), oTarget)
           && !CompareLastSpellCast(GetIdFromTalent(tUse)) )
           )
           {
              if (genericDoHarmfulRangedAttack(tUse, oTarget))
              {
                    if( GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL)
                    {
                                 SetLastGenericSpellCast(GetIdFromTalent(tUse));
                    }
                  return TRUE;
              }
           }
       }
       // * End modification to loop through available talents

    }
    // else
    //MyPrintString("BK: Harmful Ranged will return false");
    return FALSE;
}

int TalentMeleeAttacked(object oIntruder = OBJECT_INVALID, int nMelee=0)
{
	if(!GetIsObjectValid(oIntruder)) return FALSE;
    talent tUse;
    object oTarget = oIntruder;
    int nCR = GetCRMax();
	int nSeed=d2();
	if(GetAssociateState(NW_ASC_SCALED_CASTING)) {
			if(GetGameDifficulty()>=GAME_DIFFICULTY_CORE_RULES)
				nSeed=10;
			else nSeed+=2;
		} else if(GetAssociateState(NW_ASC_POWER_CASTING)) nSeed+=1;
    if(nMelee == 1)
    {
        tUse = EvenGetCreatureTalent(TALENT_CATEGORY_HARMFUL_TOUCH, nCR, d2()-1, TRUE);
		if(TestTalent(tUse, oTarget)) return TRUE;
        tUse = EvenGetCreatureTalent(TALENT_CATEGORY_HARMFUL_RANGED, nCR, d2()-1, TRUE);
        if (genericAttemptHarmful(tUse, oTarget, TALENT_CATEGORY_HARMFUL_RANGED)) return TRUE;	
        tUse = EvenGetCreatureTalent(TALENT_CATEGORY_HARMFUL_AREAEFFECT_INDISCRIMINANT, nCR, d2()-1, TRUE);
        if(TestTalent(tUse, oTarget)) return TRUE;
		if(GetGameDifficulty()<GAME_DIFFICULTY_CORE_RULES) {
			tUse = EvenGetCreatureTalent(TALENT_CATEGORY_HARMFUL_AREAEFFECT_DISCRIMINANT, nCR, d2()-1, TRUE);
        	if(TestTalent(tUse, oTarget)) return TRUE;
		}
    }
    else if (nMelee > nSeed)
    {
        tUse = EvenGetCreatureTalent(TALENT_CATEGORY_HARMFUL_AREAEFFECT_INDISCRIMINANT, nCR, d2()-1, TRUE);
        if(TestTalent(tUse, oTarget)) return TRUE;
		if(GetGameDifficulty()<GAME_DIFFICULTY_CORE_RULES) {
			tUse = EvenGetCreatureTalent(TALENT_CATEGORY_HARMFUL_AREAEFFECT_DISCRIMINANT, nCR, d2()-1, TRUE);
        	if(TestTalent(tUse, oTarget)) return TRUE;
		}
        tUse = EvenGetCreatureTalent(TALENT_CATEGORY_HARMFUL_TOUCH, nCR, d2()-1, TRUE);
        if(TestTalent(tUse, oTarget)) return TRUE;
        tUse = EvenGetCreatureTalent(TALENT_CATEGORY_HARMFUL_RANGED, nCR, d2()-1, TRUE);
        if(genericAttemptHarmful(tUse, oTarget, TALENT_CATEGORY_HARMFUL_RANGED)) return TRUE;	
    }
    return FALSE;
}


/*
int TalentMeleeAttacked(object oIntruder = OBJECT_INVALID)
{
    //MyPrintString("TalentMeleeAttacked Enter");
    talent tUse;
    int nMelee = GetNumberOfMeleeAttackers();
    object oTarget = oIntruder;
    int nCR = GetCRMax();

    if(!GetIsObjectValid(oIntruder) && GetIsObjectValid(GetLastHostileActor()))
    {
        oTarget = GetLastHostileActor();
    }
    else
    {
        return FALSE;
    }

	// ISSUE 1: The check in this function to use a random ability
	// after failing to use best will fail in the following
	// case.  The creature is unable to affect the target with
	// the spell and has only 1 spell of that type.  This can
	// be eliminated with a check in the else to the effect of :
	// 
	// 	else if(!CompareLastSpellCast(GetIdFromTalent(tUse)))
	// 
	// This check was not put in in version 1.0 due to time constraints.
	// 
	// ISSUE 2: Given the Spell Attack is the drop out check the
	// else statements in this talent should be cut.

    if(nMelee == 1)
    {
        tUse = GetCreatureTalent(TALENT_CATEGORY_HARMFUL_TOUCH, nCR);
        if(GetIsTalentValid(tUse))
        {
            if( (GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL &&
                !GetHasSpellEffect(GetIdFromTalent(tUse), oTarget) &&
                !CompareLastSpellCast(GetIdFromTalent(tUse)) ) ||
                GetTypeFromTalent(tUse) != TALENT_TYPE_SPELL )
            {
                if( GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL)
                {
                    SetLastGenericSpellCast(GetIdFromTalent(tUse));
                }
                //DebugPrintTalentID(tUse);
                //MyPrintString("TalentMeleeAttacked HARMFUL TOUCH Successful Exit");
                TalentFilter(tUse, oTarget);
                return TRUE;
            }
        }

        tUse = GetCreatureTalent(TALENT_CATEGORY_HARMFUL_RANGED, nCR);
        if(GetIsTalentValid(tUse))
        {
            // * BK: July 2002: Wrapped up harmful ranged into
            // * a function to make it easier to make global
            // * changes to the decision making process.
            if (genericAttemptHarmfulRanged(tUse, oTarget) == TRUE)
            {
                return TRUE;
            }
        }

        tUse = GetCreatureTalent(TALENT_CATEGORY_HARMFUL_AREAEFFECT_DISCRIMINANT, nCR);
        if(GetIsTalentValid(tUse))
        {
            if( (GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL &&
                !GetHasSpellEffect(GetIdFromTalent(tUse), oTarget) &&
                !CompareLastSpellCast(GetIdFromTalent(tUse)) ) ||
                GetTypeFromTalent(tUse) != TALENT_TYPE_SPELL )
            {
                if( GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL)
                {
                    SetLastGenericSpellCast(GetIdFromTalent(tUse));
                }
                //DebugPrintTalentID(tUse);
                //MyPrintString("TalentMeleeAttacked AREAEFFECT D Successful Exit");
                TalentFilter(tUse, oTarget);
                return TRUE;
            }
        }
    }
    else if (nMelee > 1)
    {
        tUse = GetCreatureTalent(TALENT_CATEGORY_HARMFUL_AREAEFFECT_DISCRIMINANT, nCR);
        if(GetIsTalentValid(tUse))
        {
             if( (GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL &&
                !GetHasSpellEffect(GetIdFromTalent(tUse), oTarget) &&
                !CompareLastSpellCast(GetIdFromTalent(tUse)) ) ||
                GetTypeFromTalent(tUse) != TALENT_TYPE_SPELL )
             {
                if( GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL)
                {
                    SetLastGenericSpellCast(GetIdFromTalent(tUse));
                }
                //DebugPrintTalentID(tUse);
                //MyPrintString("TalentMeleeAttacked AREA EFFECT DSuccessful Exit");
                TalentFilter(tUse, oTarget);
                return TRUE;
            }
        }
        tUse = GetCreatureTalent(TALENT_CATEGORY_HARMFUL_TOUCH, nCR);
        if(GetIsTalentValid(tUse))
        {
            if( (GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL &&
                !GetHasSpellEffect(GetIdFromTalent(tUse), oTarget) &&
                !CompareLastSpellCast(GetIdFromTalent(tUse)) ) ||
                GetTypeFromTalent(tUse) != TALENT_TYPE_SPELL )
            {
                if( GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL)
                {
                    SetLastGenericSpellCast(GetIdFromTalent(tUse));
                }
                //DebugPrintTalentID(tUse);
                //MyPrintString("TalentMeleeAttacked HARMFUL TOUCH Successful Exit");
                TalentFilter(tUse, oTarget);
                return TRUE;
            }
        }

         tUse = GetCreatureTalent(TALENT_CATEGORY_HARMFUL_RANGED, nCR);
        if(GetIsTalentValid(tUse))
        {
            // * BK: July 2002: Wrapped up harmful ranged into
            // * a function to make it easier to make global
            // * changes to the decision making process.
            if (genericAttemptHarmfulRanged(tUse, oTarget) == TRUE)
            {
                //MyPrintString("TalentMeleeAttacked HARMFUL RANGED Successful Exit");

                return TRUE;
            }
        }

    }
    //MyPrintString("TalentMeleeAttacked Failed Exit");
    return FALSE;
}
*/


// SPELL CASTER RANGED ATTACKED
int TalentRangedAttackers(object oIntruder = OBJECT_INVALID)
{
    //MyPrintString("TalentRangedAttackers Enter");
    //Check for Single Ranged Targets
    talent tUse;
    object oTarget = oIntruder;
    int nCR = GetCRMax();
    if(!GetIsObjectValid(oIntruder))
    {
        oTarget = GetLastHostileActor();
    }
    if(GetIsObjectValid(oTarget) && GetDistanceBetween(oTarget, OBJECT_SELF) > 5.0)
    {
        if(CheckFriendlyFireOnTarget(oTarget) > 0)
        {
            tUse = GetCreatureTalent(TALENT_CATEGORY_HARMFUL_AREAEFFECT_DISCRIMINANT, nCR);
            if(GetIsTalentValid(tUse))
            {
                if( (GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL &&
                    !GetHasSpellEffect(GetIdFromTalent(tUse), oTarget) &&
                    !CompareLastSpellCast(GetIdFromTalent(tUse)) ) ||
                    GetTypeFromTalent(tUse) != TALENT_TYPE_SPELL )
                {
                    if( GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL)
                    {
                        SetLastGenericSpellCast(GetIdFromTalent(tUse));
                    }
                    // DebugPrintTalentID(tUse);
                    //MyPrintString("TalentRangedAttackers Successful Exit");
                    TalentFilter(tUse, oTarget);
                    return TRUE;
                }
            }
        }
        else if(CheckEnemyGroupingOnTarget(oTarget) > 0)
        {
            tUse = GetCreatureTalent(TALENT_CATEGORY_HARMFUL_AREAEFFECT_INDISCRIMINANT, nCR);


            if(GetIsTalentValid(tUse))
            {

            //MyPrintString("2346 : Choose Talent here " + IntToString(nCR));
                if( (GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL &&
                    !GetHasSpellEffect(GetIdFromTalent(tUse), oTarget) &&
                    !CompareLastSpellCast(GetIdFromTalent(tUse)) ) ||
                    GetTypeFromTalent(tUse) != TALENT_TYPE_SPELL )
                {
                    if( GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL)
                    {
                        SetLastGenericSpellCast(GetIdFromTalent(tUse));
                    }
                    // DebugPrintTalentID(tUse);
                    //MyPrintString("TalentRangedAttackers Successful Exit");
                    ClearActions(CLEAR_X0_I0_TALENT_RangedAttackers);
                    ActionUseTalentAtLocation(tUse, GetLocation(oTarget));
                    return TRUE;
                }
            }
        }
        else
        {
            tUse = GetCreatureTalent(TALENT_CATEGORY_HARMFUL_RANGED, nCR);
            if(GetIsTalentValid(tUse))
            {
                // * BK: July 2002: Wrapped up harmful ranged into
                // * a function to make it easier to make global
                // * changes to the decision making process.
                if (genericAttemptHarmfulRanged(tUse, oTarget) == TRUE)
                {
                    return TRUE;
                }
            }
       }
    }
    //MyPrintString("TalentRangedAttackers Failed Exit");
    return FALSE;
}

int TalentRangedEnemies(object oIntruder = OBJECT_INVALID)
{
	if(!GetIsObjectValid(oIntruder)) return FALSE;
    talent tUse;
    object oTarget = oIntruder;
    int nCR = GetCRMax();
    if(GetIsObjectValid(oTarget))
    {
        int nEnemy = CheckEnemyGroupingOnTarget(oTarget);
		int nSeed=d2()+nEnemy;
		if(GetAssociateState(NW_ASC_SCALED_CASTING)) {
			if(GetGameDifficulty()>=GAME_DIFFICULTY_CORE_RULES)
				nSeed=0;
			else nSeed-=2;
		} else if(GetAssociateState(NW_ASC_POWER_CASTING)) nSeed-=1;
        if(nSeed<3)
        {
         	tUse = EvenGetCreatureTalent(TALENT_CATEGORY_HARMFUL_RANGED, nCR, d2()-1, TRUE);
        	if(genericAttemptHarmful(tUse, oTarget, TALENT_CATEGORY_HARMFUL_RANGED)) return TRUE;	
       	}
        if(GetGameDifficulty()>=GAME_DIFFICULTY_CORE_RULES && CheckFriendlyFireOnTarget(oTarget) > 0)// &&  nEnemy > 0)
        {
            tUse = EvenGetCreatureTalent(TALENT_CATEGORY_HARMFUL_AREAEFFECT_INDISCRIMINANT,
                                         nCR, d2()-1, TRUE);
            if(TestTalent(tUse, oTarget)) return TRUE;
        }
        else if(nSeed > 1)
        {
            tUse = EvenGetCreatureTalent(TALENT_CATEGORY_HARMFUL_AREAEFFECT_DISCRIMINANT, nCR, d2()-1, TRUE);
            if(TestTalent(tUse, oTarget, TRUE)) return TRUE;
            else
            {
                tUse = EvenGetCreatureTalent(TALENT_CATEGORY_HARMFUL_AREAEFFECT_INDISCRIMINANT,
                                             nCR, d2()-1, TRUE);
                if(TestTalent(tUse, oTarget)) return TRUE;
            }
        }
		if(nSeed>=3) {
        	tUse = EvenGetCreatureTalent(TALENT_CATEGORY_HARMFUL_RANGED, nCR, d2()-1, TRUE);
        	if(genericAttemptHarmful(tUse, oTarget, TALENT_CATEGORY_HARMFUL_RANGED)) return TRUE;	
		}
    }
    return FALSE;
}

/*
// SPELL CASTER WITH RANGED ENEMIES
int TalentRangedEnemies(object oIntruder = OBJECT_INVALID)
{
    //MyPrintString("TalentRangedEnemies Enter");
    talent tUse;
    object oTarget = oIntruder;
    int nCR = GetCRMax();
    if(!GetIsObjectValid(oIntruder))
    {
        oTarget = GetNearestSeenEnemy();
    }

    if(GetIsObjectValid(oTarget))
    {
        int nEnemy = CheckEnemyGroupingOnTarget(oTarget);
        if(CheckFriendlyFireOnTarget(oTarget) > 0 &&  nEnemy > 0)
        {
            tUse = GetCreatureTalent(TALENT_CATEGORY_HARMFUL_AREAEFFECT_DISCRIMINANT,
                                         nCR);

            if(GetIsTalentValid(tUse))
            {
                if( (GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL &&
                    !GetHasSpellEffect(GetIdFromTalent(tUse), oTarget) &&
                    !CompareLastSpellCast(GetIdFromTalent(tUse)) ) ||
                    GetTypeFromTalent(tUse) != TALENT_TYPE_SPELL )
                {
                    if( GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL)
                    {
                        SetLastGenericSpellCast(GetIdFromTalent(tUse));
                    }
                    // DebugPrintTalentID(tUse);
                    //MyPrintString("TalentRangedEnemies Successful Exit");
                    // * ONLY TalentFilter not to have a ClarAllActions before it(February 6 2003)
                    TalentFilter(tUse, oTarget);
                    return TRUE;
                }
            }
        }
        else if(nEnemy > 0)
        {
            tUse = GetCreatureTalent(TALENT_CATEGORY_HARMFUL_AREAEFFECT_INDISCRIMINANT, nCR);

            if(GetIsTalentValid(tUse))
            {
                //MyPrintString("2428 : Choose Talent here " + IntToString(nCR));

              if( (GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL &&
                    !GetHasSpellEffect(GetIdFromTalent(tUse), oTarget) &&
                    !CompareLastSpellCast(GetIdFromTalent(tUse)) ) ||
                    GetTypeFromTalent(tUse) != TALENT_TYPE_SPELL )
                {
                    if( GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL)
                    {
                        SetLastGenericSpellCast(GetIdFromTalent(tUse));
                    }
                    // DebugPrintTalentID(tUse);
                    //MyPrintString("TalentRangedEnemies Successful Exit");
                    ClearActions(CLEAR_X0_I0_TALENT_RangedEnemies);
                    ActionUseTalentAtLocation(tUse, GetLocation(oTarget));
                    return TRUE;
                }
            }
            else
            {
                tUse = GetCreatureTalent(TALENT_CATEGORY_HARMFUL_AREAEFFECT_DISCRIMINANT,
                                             nCR);
                if(GetIsTalentValid(tUse))
                {
                    if( (GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL &&
                        !GetHasSpellEffect(GetIdFromTalent(tUse), oTarget) &&
                        !CompareLastSpellCast(GetIdFromTalent(tUse)) ) ||
                        GetTypeFromTalent(tUse) != TALENT_TYPE_SPELL )
                    {
                        if( GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL)
                        {
                            SetLastGenericSpellCast(GetIdFromTalent(tUse));
                        }
                        // DebugPrintTalentID(tUse);
                        //MyPrintString("TalentRangedEnemies Successful Exit");
                        TalentFilter(tUse, oTarget);
                        return TRUE;
                    }
                }
            }
        }
        else if(GetDistanceToObject(oTarget) > 5.0)
        {
           tUse = GetCreatureTalent(TALENT_CATEGORY_HARMFUL_RANGED, nCR);
            if(GetIsTalentValid(tUse))
            {
                // * BK: July 2002: Wrapped up harmful ranged into
                // * a function to make it easier to make global
                // * changes to the decision making process.
                if (genericAttemptHarmfulRanged(tUse, oTarget) == TRUE)
                {
                    return TRUE;
                }
            }
       }
    }
    //MyPrintString("TalentRangedEnemies Failed Exit");
    return FALSE;
}
*/

//
//  ISSUE 1: The check in this function to use a random ability
//  after failing to use best will fail in the following
//  case.  The creature is unable to affect the target with the
//  spell and has only 1 spell of that type.  This can
//  be eliminated with a check in the else to the effect of :
//
//  else if(!CompareLastSpellCast(GetIdFromTalent(tUse)))
//
//  This check was not put in in version 1.0 due to time constraints.
//  May cause an AI loop in some Mages with limited spell selection.

int TalentSpellAttack(object oIntruder)
{
    //MyPrintString("Talent Spell Attack Enter");
    talent tUse;
    object oTarget = oIntruder;
    if(!GetIsObjectValid(oTarget) || GetArea(oTarget) != GetArea(OBJECT_SELF) || GetPlotFlag(OBJECT_SELF) == TRUE)
    {
        oTarget = GetLastHostileActor();
        //MyPrintString("Last Hostile Attacker: " + ObjectToString(oTarget));
        if(!GetIsObjectValid(oTarget)
            || GetIsDead(oTarget)
            || GetArea(oTarget) != GetArea(OBJECT_SELF)
            || GetPlotFlag(OBJECT_SELF) == TRUE)
        {
            oTarget = GetNearestSeenEnemy();
            //MyPrintString("Get Nearest Seen or Heard: " + ObjectToString(oTarget));
            if(!GetIsObjectValid(oTarget))
            {
                return FALSE;
            }
        }
    }

    //Attack chosen target
    int bValid = FALSE;
    tUse = GetCreatureTalent(TALENT_CATEGORY_HARMFUL_AREAEFFECT_DISCRIMINANT,
                                 GetCRMax());
    if (GetIsTalentValid(tUse) == FALSE)
    {
        //MyPrintString("Discriminant AOE not valid");
        //newdebug("Discriminant AOE not valid");
        // * November 2002
        // * if there are no allies near the target
        // * then feel free to grab an indiscriminant spell instead
        int nFriends = CheckFriendlyFireOnTarget(oIntruder) ;
        if (nFriends <= 1)
        {
            //newdebug("no friendly fire");
            tUse = GetCreatureTalent(TALENT_CATEGORY_HARMFUL_AREAEFFECT_INDISCRIMINANT,
                                         GetCRMax());
        }
        if (GetIsTalentValid(tUse) == FALSE)
        {
            //newdebug("SpellAttack: INDiscriminant AOE not valid");
        }
    }
    if(GetIsTalentValid(tUse))
    {
        if( (GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL
             && !GetHasSpellEffect(GetIdFromTalent(tUse), oTarget)) )
        {
            //newdebug("Valid talent found AREA OF EFFECT DISCRIMINANT");
            //MyPrintString("Spell Attack Discriminate Chosen");
            bValid = TRUE;
        }
    }

    if(bValid == FALSE)
    {
        tUse = GetCreatureTalent(TALENT_CATEGORY_HARMFUL_RANGED,
                                     GetCRMax());
        if(GetIsTalentValid(tUse))
        {     //  SpawnScriptDebugger();

            // * BK: July 2002: Wrapped up harmful ranged into
            // * a function to make it easier to make global
            // * changes to the decision making process.
            if (genericAttemptHarmfulRanged(tUse, oTarget) == TRUE)
            {
                //MyPrintString("Spell Attack Harmful Ranged Chosen");
                bValid = FALSE; // * Keep bValid false because we have chosen
                                // * to actually cast the spell here.
                return TRUE;
            }

        }
    }

    if(bValid == FALSE)
    {
        tUse = GetCreatureTalent(TALENT_CATEGORY_HARMFUL_TOUCH,
                                     GetCRMax());

        if(GetIsTalentValid(tUse))
        {
            if( (GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL
                 && !GetHasSpellEffect(GetIdFromTalent(tUse), oTarget)) )
            {
                //MyPrintString("Spell Attack Harmful Ranged Chosen");
                bValid = TRUE;
            }
        }
    }

    if (bValid == TRUE)
    {
        if( GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL)
        {
            SetLastGenericSpellCast(GetIdFromTalent(tUse));
        }

        // DebugPrintTalentID(tUse);
        //MyPrintString("Talent Spell Attack Successful Exit");

        // Use a final filter to avoid problems
        if (TalentFilter(tUse, oTarget) == TRUE)
         return TRUE;
    }

    //MyPrintString("Talent Spell Attack Failed Exit");
    /* JULY 2003
       At this point grab a random spell attack to use, not just "best"
    */
    //SpawnScriptDebugger();
	 int iExcludeFlag = GetLocalInt(OBJECT_SELF, N2_TALENT_EXCLUDE);
     tUse = GetCreatureTalentRandom(TALENT_CATEGORY_HARMFUL_AREAEFFECT_DISCRIMINANT, OBJECT_SELF, iExcludeFlag);
     if (GetIsTalentValid(tUse) == FALSE || TalentFilter(tUse, oTarget, TRUE)==FALSE)
     {
      tUse = GetCreatureTalentRandom(TALENT_CATEGORY_HARMFUL_RANGED, OBJECT_SELF, iExcludeFlag);
     }
     if (GetIsTalentValid(tUse) == FALSE || TalentFilter(tUse, oTarget, TRUE)==FALSE)
     {
      tUse = GetCreatureTalentRandom(TALENT_CATEGORY_HARMFUL_AREAEFFECT_INDISCRIMINANT, OBJECT_SELF, iExcludeFlag);
     }
     if (GetIsTalentValid(tUse) == FALSE || TalentFilter(tUse, oTarget, TRUE)==FALSE)
     {
      tUse = GetCreatureTalentRandom(TALENT_CATEGORY_HARMFUL_TOUCH, OBJECT_SELF, iExcludeFlag);
     }

    // * if something was valid, attempt to use that something intelligently
    if (GetIsTalentValid(tUse) == TRUE)
    {
       if (!GetHasSpellEffect(GetIdFromTalent(tUse), oTarget))
       {
         // * so far, so good
         // Use a final filter to avoid problems
         if (TalentFilter(tUse, oTarget) == TRUE)
          return TRUE;
       }
    }


    /* End July 11 Mods BK */
    return FALSE;
}


int TalentSummonAllies()
{
    if(!GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_SUMMONED)))
    {
        int nCR = GetCRMax();
		if(!GetHasEffect(EFFECT_TYPE_SILENCE) && nCR>=18 && GetHasSpell(SPELL_GATE) && (GetHasSpell(321) || GetHasSpellEffect(SPELL_PROTECTION_FROM_EVIL)
		|| GetHasSpellEffect(321)) ) {
			ClearActions(CLEAR_X0_I0_TALENT_SummonAllies);
			if(!GetHasSpellEffect(SPELL_PROTECTION_FROM_EVIL) && !GetHasSpellEffect(321)) {
				ActionCastSpellAtObject(321, OBJECT_SELF);//, METAMAGIC_ANY, TRUE);
				//DecrementRemainingSpellUses(OBJECT_SELF, 321);
			}
			ActionCastSpellAtObject(SPELL_GATE, OBJECT_SELF);
			return TRUE;
		}
        talent tUse = GetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_OBTAIN_ALLIES, nCR);
        if(GetIsTalentValid(tUse))
        {
            location lSelf;
            object oTarget =  FindSingleRangedTarget();
            if(GetIsObjectValid(oTarget))
            {
                vector vTarget = GetPosition(oTarget);
                vector vSource = GetPosition(OBJECT_SELF);
                vector vDirection = vTarget - vSource;
                float fDistance = VectorMagnitude(vDirection) / 2.0f;
                vector vPoint = VectorNormalize(vDirection) * fDistance + vSource;
                lSelf = Location(GetArea(OBJECT_SELF), vPoint, GetFacing(OBJECT_SELF));
            }
            else
            {
                lSelf = GetLocation(OBJECT_SELF);
            }
            ClearActions(CLEAR_X0_I0_TALENT_SummonAllies);
            if(GetIsObjectValid(GetMaster()))
            {
                ActionUseTalentAtLocation(tUse, GetLocation(GetMaster()));
            }
            else
            {
                ActionUseTalentAtLocation(tUse, lSelf);
            }
            return TRUE;
        }
	}
    return FALSE;
}

/*
// SUMMON ALLIES
int TalentSummonAllies()
{
    //MyPrintString("TalentSummonAllies Enter");

    if(!GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_SUMMONED)))
    {
        int nCR = GetCRMax();
        talent tUse = GetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_OBTAIN_ALLIES, nCR);
        if(GetIsTalentValid(tUse))
        {
            location lSelf;
            object oTarget =  FindSingleRangedTarget();
            if(GetIsObjectValid(oTarget))
            {
                vector vTarget = GetPosition(oTarget);
                vector vSource = GetPosition(OBJECT_SELF);
                vector vDirection = vTarget - vSource;
                float fDistance = VectorMagnitude(vDirection) / 2.0f;
                vector vPoint = VectorNormalize(vDirection) * fDistance + vSource;
                lSelf = Location(GetArea(OBJECT_SELF), vPoint, GetFacing(OBJECT_SELF));
                //lSelf = GetLocation(oTarget);
            }
            else
            {
                lSelf = GetLocation(OBJECT_SELF);
            }
            ClearActions(CLEAR_X0_I0_TALENT_SummonAllies);
            //This is for henchmen wizards, so they do no run off and get killed
            //summoning in allies.
            if(GetIsObjectValid(GetMaster()))
            {
                //MyPrintString("TalentSummonAllies Successful Exit");
                ActionUseTalentAtLocation(tUse, GetLocation(GetMaster()));
            }
            else
            {
                //MyPrintString("TalentSummonAllies Successful Exit");
                ActionUseTalentAtLocation(tUse, lSelf);
            }
            return TRUE;
        }
        //   else
            //MyPrintString("No valid Talent for summoning Allies with Difficulty " + IntToString(GetLocalInt(OBJECT_SELF,"NW_L_COMBATDIFF")));
    }
    //MyPrintString("TalentSummonAllies Failed Exit");
    return FALSE;
}
*/

int TalentHealingSelf(int bForce = FALSE)
{
    int nCurrent = GetCurrentHitPoints(OBJECT_SELF);
    int nBase = GetMaxHitPoints(OBJECT_SELF);
	int nRace = GetRacialType(OBJECT_SELF);
	
	// these guys can't use normal healing
    if (nRace != RACIAL_TYPE_UNDEAD 
		&& nRace != RACIAL_TYPE_CONSTRUCT 
		&& nRace != RACIAL_TYPE_OOZE)
    {
        if( (nCurrent*2 < nBase) || (bForce == TRUE) )
        {
		 	int iExcludeFlag = GetLocalInt(OBJECT_SELF, N2_TALENT_EXCLUDE);
            talent tUse = EvenGetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_HEALING_TOUCH, GetCRMax(), FALSE, TRUE);
			if ( GetIsTalentValid(tUse) && (GetLocalInt(OBJECT_SELF, "X2_L_STOPCASTING") != 10) && (GetHasFeat(FEAT_NATURAL_SPELL, OBJECT_SELF, TRUE) || !GetHasEffect(EFFECT_TYPE_POLYMORPH) ))
            {
				if(!GetLocalInt(OBJECT_SELF, N2_COMBAT_MODE_USE_DISABLED) && GetLocalInt(OBJECT_SELF, EVENFLW_NUM_MELEE)&& (GetLastGenericSpellCast() != 0))
					SetActionMode(OBJECT_SELF, ACTION_MODE_DEFENSIVE_CAST, TRUE);
                EvenTalentFilter(tUse, OBJECT_SELF);
                return TRUE;
            }
            else if(!(GetLocalInt(OBJECT_SELF, N2_TALENT_EXCLUDE)&0x1))
            {
                tUse = GetCreatureTalentBest(TALENT_CATEGORY_BENEFICIAL_HEALING_POTION, GetCRMax(), OBJECT_SELF, iExcludeFlag);
                if(GetIsTalentValid(tUse))
                {
                    EvenTalentFilter(tUse, OBJECT_SELF);
                    return TRUE;
                }
            }
        }
		
    }
	if((GetIsOwnedByPlayer(OBJECT_SELF) || GetIsRosterMember(OBJECT_SELF)) &&
		(nCurrent*2 < nBase && d6()==1 || nCurrent*4 < nBase && d4()==1) )
		PlayVoiceChat(VOICE_CHAT_HEALME);
    return FALSE;
}


/*
// HEAL SELF WITH POTIONS AND SPELLS
// * July 14 2003: If bForce=TRUE then force a heal
int TalentHealingSelf(int bForce = FALSE)
{
    // BK: Sep 2002
    // * Moved the racial type filter into here instead of having it
    // * out everyplace that this talent is called
    // * Will have to keep an eye out to see if this breaks anything
    if(GetRacialType(OBJECT_SELF) != RACIAL_TYPE_ABERRATION ||
       GetRacialType(OBJECT_SELF) != RACIAL_TYPE_BEAST ||
       GetRacialType(OBJECT_SELF) != RACIAL_TYPE_ELEMENTAL ||
       GetRacialType(OBJECT_SELF) != RACIAL_TYPE_VERMIN ||
       GetRacialType(OBJECT_SELF) != RACIAL_TYPE_MAGICAL_BEAST ||
       GetRacialType(OBJECT_SELF) != RACIAL_TYPE_UNDEAD ||
       GetRacialType(OBJECT_SELF) != RACIAL_TYPE_DRAGON    ||
//       GetRacialType(OBJECT_SELF) != RACIAL_TYPE_CONSTRUCT ||
       GetRacialType(OBJECT_SELF) != 29 || //oozes
       GetRacialType(OBJECT_SELF) != RACIAL_TYPE_ANIMAL)
    {

        //MyPrintString("TalentHealingSelf Enter");
        int nCurrent = GetCurrentHitPoints(OBJECT_SELF) * 2;
        int nBase = GetMaxHitPoints(OBJECT_SELF);

        if( (nCurrent < nBase) || (bForce == TRUE) )
        {
		 	int iExcludeFlag = GetLocalInt(OBJECT_SELF, N2_TALENT_EXCLUDE);

            talent tUse = GetCreatureTalentRandom(TALENT_CATEGORY_BENEFICIAL_HEALING_TOUCH, OBJECT_SELF, iExcludeFlag);
 			
			// BMA-OEI 9/20/06: Disable spell casting while Polymorphed
			if ( GetIsTalentValid(tUse) && !GetHasEffect(EFFECT_TYPE_POLYMORPH) )
            {
                //MyPrintString("Talent\ Successful Exit");
                TalentFilter(tUse, OBJECT_SELF);
                return TRUE;
            }
            else
            {
                tUse = GetCreatureTalentRandom(TALENT_CATEGORY_BENEFICIAL_HEALING_POTION, OBJECT_SELF, iExcludeFlag);
                if(GetIsTalentValid(tUse))
                {
                    //MyPrintString("TalentHealingSelf Successful Exit");
                    TalentFilter(tUse, OBJECT_SELF);
                    return TRUE;
                }
            }
        }
    }
    //MyPrintString("TalentHealingSelf Failed Exit");
    return FALSE;
}
*/

int TalentHeal(int nForce = FALSE, object oTarget = OBJECT_SELF)
{
    int nCurrent;
    int nBase;
	int total;
	int overkill=0;
    talent tUse = EvenGetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_HEALING_AREAEFFECT, 20, TRUE, TRUE);
	int owned=GetIsRosterMember(OBJECT_SELF) || GetIsOwnedByPlayer(OBJECT_SELF);
	if(GetAssociateState(NW_ASC_OVERKIll_CASTING)) overkill=1;
	if(GetIsTalentValid(tUse))
    {
      	total = 0;
		int nMass=0;
		oTarget=GetFirstTalentTarget(owned, RADIUS_SIZE_COLOSSAL);
      	while (GetIsObjectValid(oTarget) && (owned || total<5))
      	{
       		total++;
       		if(oTarget!=OBJECT_SELF && !GetIsEnemy(oTarget) && GetRacialType(oTarget)!=RACIAL_TYPE_UNDEAD && GetArea(OBJECT_SELF)==GetArea(oTarget) && GetDistanceBetween(OBJECT_SELF, oTarget)<RADIUS_SIZE_COLOSSAL)
      		{
       			if (nForce == TRUE)
       				nCurrent = GetCurrentHitPoints(oTarget);
       			else
       				nCurrent = GetCurrentHitPoints(oTarget)*2;
       			nBase = GetMaxHitPoints(oTarget);
       			if((nCurrent <= nBase || overkill && GetCurrentHitPoints(oTarget) < GetMaxHitPoints(oTarget)-19)
					&& !GetIsDead(oTarget))
       				nMass += 1;
        		if (nMass > 2)
       			{
                	EvenTalentFilter(tUse, oTarget);
        			return TRUE;
       			}
      		}
			oTarget=GetNextTalentTarget(owned, RADIUS_SIZE_COLOSSAL);
     	}
    }
    tUse = EvenGetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_HEALING_TOUCH, TALENT_ANY, FALSE, TRUE);
    if(!GetIsTalentValid(tUse)) return FALSE;
    total = 0;
	oTarget=GetFirstTalentTarget(owned, RADIUS_SIZE_COLOSSAL);
    while (GetIsObjectValid(oTarget) && (owned || total<5))
    {
        total++;
        if(oTarget!=OBJECT_SELF && !GetIsEnemy(oTarget) && GetArea(OBJECT_SELF)==GetArea(oTarget) && GetDistanceBetween(OBJECT_SELF, oTarget)<RADIUS_SIZE_COLOSSAL)
        {
            if (nForce == TRUE) {
                nCurrent = GetCurrentHitPoints(oTarget);
				nBase = GetMaxHitPoints(oTarget);
            } else {
            	nCurrent = GetCurrentHitPoints(oTarget);
				if(overkill)
					nBase=GetMaxHitPoints(oTarget)*3/4;
				else nBase = GetMaxHitPoints(oTarget)/2;
            }
			int mod=24;
			if(GetIdFromTalent(tUse)==SPELL_HEAL) mod=100;
            if((nCurrent <= nBase || overkill && GetCurrentHitPoints(oTarget) < GetMaxHitPoints(oTarget)-mod)
				&& !GetIsDead(oTarget))
            {
				if(GetRacialType(oTarget)!=RACIAL_TYPE_UNDEAD) {
			    	EvenTalentFilter(tUse, oTarget);
        			return TRUE;
				} /*else {
					int spell=0;
					if(GetHasSpell(SPELL_HARM)) spell=SPELL_HARM;
					else if(GetAlignmentGoodEvil(OBJECT_SELF)==ALIGNMENT_EVIL){
						if(GetHasSpell(SPELL_INFLICT_CRITICAL_WOUNDS)) spell=SPELL_INFLICT_CRITICAL_WOUNDS;
						else if(GetHasSpell(SPELL_INFLICT_SERIOUS_WOUNDS)) spell=SPELL_INFLICT_SERIOUS_WOUNDS;
						else if(GetHasSpell(SPELL_INFLICT_MODERATE_WOUNDS)) spell=SPELL_INFLICT_MODERATE_WOUNDS;
						else if(GetHasSpell(SPELL_INFLICT_LIGHT_WOUNDS)) spell=SPELL_INFLICT_LIGHT_WOUNDS;
					}
					if(spell) {
						ClearAllActions();
						ActionCastSpellAtObject(spell, oTarget);
						return TRUE;
					}
				}*/
            }
        }
		oTarget=GetNextTalentTarget(owned, RADIUS_SIZE_COLOSSAL);
    }
    return FALSE;
}

/*
// HEAL ALL ALLIES
// BK: Added an optional parameter for object.
int TalentHeal(int nForce = FALSE, object oTarget = OBJECT_SELF)
{
    //MyPrintString("TalentHeal Enter");
    int nCurrent = GetCurrentHitPoints(oTarget);

    //if (nForce == TRUE)
    //    nCurrent = nCurrent;
    //else
    //    nCurrent = GetCurrentHitPoints(oTarget)*2;
    if(nForce != TRUE)
        nCurrent = nCurrent*2;

    int nBase = GetMaxHitPoints(oTarget);
    //int nCR;

    talent tUse = GetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_HEALING_TOUCH, TALENT_ANY);

    int bValid = GetIsTalentValid(tUse);

    // * BK: force a heal
    if (bValid && oTarget != OBJECT_SELF && GetCurrentHitPoints(oTarget) < nBase)
    {
        TalentFilter(tUse, oTarget);
        //MyPrintString("TalentHeal (MASTER) Successful Exit");
        return TRUE;
    }
    // * Heal self
    if(nCurrent < nBase)
    {
        if(GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
        {
            //MyPrintString("TalentHeal Failed Exit");
            return FALSE;
        }

        tUse = GetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_HEALING_TOUCH, TALENT_ANY);
        if(GetIsTalentValid(tUse))
        {
            //MyPrintString("TalentHeal Successful Exit");
            TalentFilter(tUse, oTarget);
            return TRUE;
        }
    }
    // * change target
    // * find nearest friend to heal.
    oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_FRIEND);
    int i = 0;
    while (GetIsObjectValid(oTarget))
    {
        if(GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
        {
            //MyPrintString("TalentHeal Failed Exit");
        }
        else
        {
            if (nForce == TRUE)
                nCurrent = GetCurrentHitPoints(oTarget);
            else
            nCurrent = GetCurrentHitPoints(oTarget)*2;

            nBase = GetMaxHitPoints(oTarget);

            if(nCurrent < nBase && !GetIsDead(oTarget))
            {
                tUse = GetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_HEALING_TOUCH, TALENT_ANY);
                if(GetIsTalentValid(tUse))
                {
                    //MyPrintString("TalentHeal Successful Exit");
                    TalentFilter(tUse, oTarget);
                    return TRUE;
                }
            }
        }
        i++;
        oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_FRIEND, OBJECT_SELF, i);
    }

    //MyPrintString("TalentHeal Failed Exit");
    return FALSE;
}
*/

// MELEE ATTACK OTHERS
//
//  ISSUE 1: Talent Melee Attack should set the Last Spell Used to 0 so that melee casters can use
//  a single special ability.

int WhirlwindGetNumberOfMeleeAttackers(float fDist=5.0)
{
    object oOne = GetNearestEnemy(OBJECT_SELF, 1);

    if (GetIsObjectValid(oOne) == TRUE)
    {
        object oTwo = GetNearestEnemy(OBJECT_SELF, 2);
        if (GetDistanceToObject(oOne) <= fDist && GetIsObjectValid(oTwo) == TRUE)
        {
            if (GetDistanceToObject(oTwo) <= fDist)
            {
                // * DO NOT WHIRLWIND if any of the targets are "large" or bigger
                // * it seldom works against such large opponents.
                // * Though its okay to use Improved Whirlwind against these targets
                // * October 13 - Brent
                if (GetHasFeat(FEAT_IMPROVED_WHIRLWIND))
                {
                    return TRUE;
                }
                else
                if (GetCreatureSize(oOne) < CREATURE_SIZE_LARGE && GetCreatureSize(oTwo) < CREATURE_SIZE_LARGE)
                {
                    return TRUE;
                }
                return FALSE;
            }
        }
    }
    return FALSE;
}


// * Returns true if the creature's variable
// * set on it rolled against a d100
// * says it is okay to whirlwind.
// * Added this because it got silly to see creatures
// * constantly whirlwinded
int GetOKToWhirl(object oCreature)
{
    int nWhirl = GetLocalInt(oCreature, "X2_WHIRLPERCENT");



    if (nWhirl == 0 || nWhirl == 100)
    {
        return TRUE; // 0 or 100 is 100%
    }
    else
    {
        if (Random(100) + 1 <= nWhirl)
        {
            return TRUE;
        }

    }
    return FALSE;
}


int TalentMeleeAttack(object oIntruder = OBJECT_INVALID)
{
    //MyPrintString("TalentMeleeAttack Enter");
    //MyPrintString("Intruder: " + ObjectToString(oIntruder));

    object oTarget = oIntruder;
    if( !GetIsObjectValid(oTarget)
        || GetArea(oTarget) != GetArea(OBJECT_SELF)
        // not clear to me why we check this here...
        // || GetPlotFlag(OBJECT_SELF) == TRUE)
        || GetAssociateState(NW_ASC_MODE_DYING, oTarget))
    {
        oTarget = GetAttemptedAttackTarget();
        //MyPrintString("Attempted Attack Target: " + ObjectToString(oTarget));
        if(!GetIsObjectValid(oTarget) || GetIsDead(oTarget)
           || (!GetObjectSeen(oTarget) && !GetObjectHeard(oTarget))
           || GetArea(oTarget) != GetArea(OBJECT_SELF)
           || GetPlotFlag(OBJECT_SELF) == TRUE)
        {
            oTarget = GetLastHostileActor();
            //MyPrintString("Last Attacker: " + ObjectToString(oTarget));
            if(!GetIsObjectValid(oTarget)
               || GetIsDead(oTarget)
               || GetArea(oTarget) != GetArea(OBJECT_SELF)
               || GetPlotFlag(OBJECT_SELF) == TRUE)
            {
                oTarget = GetNearestPerceivedEnemy();
                //MyPrintString("Get Nearest Perceived: "                              + ObjectToString(oTarget));
                if(!GetIsObjectValid(oTarget)) {
                    //MyPrintString("TALENT MELEE ATTACK FAILURE EXIT"                                  + " - NO TARGET FOUND");
                    return FALSE;
                }
            }
        }
    }

    //MyPrintString("Selected Target: " + ObjectToString(oTarget));

    talent tUse;

    // If the difference between the attacker's AC and our
    // attack capabilities is greater than 10, we just use
    // a straightforward attack; otherwise, we try our best
    // melee talent.
    int nAC = GetAC(oTarget);
    float fAttack;
    int nAttack = GetHitDice(OBJECT_SELF);

    fAttack = (IntToFloat(nAttack) * 0.75)
        + IntToFloat(GetAbilityModifier(ABILITY_STRENGTH));

    //fAttack = IntToFloat(nAttack) + GetAbilityModifier(ABILITY_STRENGTH);

    int nDiff = nAC - nAttack;
    //MyPrintString("nDiff = " + IntToString(nDiff));

    // * only the playable races have whirlwind attack
    // * Attempt to Use Whirlwind Attack
    int bOkToWhirl = GetOKToWhirl(OBJECT_SELF);
    int bHasFeat = GetHasFeat(FEAT_WHIRLWIND_ATTACK);
    int bPlayableRace = FALSE;
    if (GetIsPlayableRacialType(OBJECT_SELF) || GetTag(OBJECT_SELF) == "x2_hen_valen")
      bPlayableRace = TRUE;

	// BMA-OEI 10/12/06: Check if Combat Mode Switching is disabled
	int bCombatModeUseDisabled = GetLocalInt( OBJECT_SELF, N2_COMBAT_MODE_USE_DISABLED );

    int bNumberofAttackers = WhirlwindGetNumberOfMeleeAttackers(WHIRL_DISTANCE);
    if (bOkToWhirl == TRUE && bHasFeat == TRUE  &&   bPlayableRace == TRUE
       &&  bNumberofAttackers == TRUE)
    {
        ClearActions(CLEAR_X0_I0_TALENT_MeleeAttack1);
        ActionUseFeat(FEAT_WHIRLWIND_ATTACK, OBJECT_SELF);
        return TRUE;
    }
    else
    // * Try using combat expertise
    if ((bCombatModeUseDisabled == FALSE) && GetHasFeat(FEAT_COMBAT_EXPERTISE) && nDiff < 12)
    {
        ClearActions(CLEAR_X0_I0_TALENT_MeleeAttack1);
        SetActionMode(OBJECT_SELF, ACTION_MODE_COMBAT_EXPERTISE, TRUE);
        WrapperActionAttack(oTarget);
        return TRUE;
    }
    else
    // * Try using expertise
    if ((bCombatModeUseDisabled == FALSE) && GetHasFeat(FEAT_IMPROVED_COMBAT_EXPERTISE) && nDiff < 15)
    {
        ClearActions(CLEAR_X0_I0_TALENT_MeleeAttack1);
        SetActionMode(OBJECT_SELF, ACTION_MODE_IMPROVED_COMBAT_EXPERTISE, TRUE);
        WrapperActionAttack(oTarget);
        return TRUE;
    }
    else
    if(nDiff < 10)
    {
        ClearActions(CLEAR_X0_I0_TALENT_MeleeAttack1);
        // * this function will call the BK function
        EquipAppropriateWeapons(oTarget);
        tUse = GetCreatureTalent(TALENT_CATEGORY_HARMFUL_MELEE,
                                     GetCRMax());
        //MyPrintString("Melee Talent Valid = "+ IntToString(GetIsTalentValid(tUse)));
        //MyPrintString("Feat ID = " + IntToString(GetIdFromTalent(tUse)));

        if(GetIsTalentValid(tUse)
           && VerifyDisarm(tUse, oTarget)
           && VerifyCombatMeleeTalent(tUse, oTarget))
        {
            //MyPrintString("TalentMeleeAttack: Talent Use Successful");
            // February 6 2003: Did not have a clear all actions before it
            TalentFilter(tUse, oTarget);
            return TRUE;
        }
        else
        {
            //MyPrintString("TalentMeleeAttack Successful Exit");
            WrapperActionAttack(oTarget);
            return TRUE;
        }
    }
    else
    {
        //MyPrintString("TalentMeleeAttack Successful Exit");
        ClearActions(CLEAR_X0_I0_TALENT_MeleeAttack2);
        // * this function will call the BK function
        EquipAppropriateWeapons(oTarget);
        WrapperActionAttack(oTarget);
        return TRUE;
    }

    //MyPrintString("TALENT MELEE ATTACK FAILURE EXIT - THIS IS VERY BAD");
    return FALSE;
}


int TalentSneakAttack()
{
    if(GetHasFeat(FEAT_SNEAK_ATTACK)) {
    	object oFriend = GetNearestNonEnemy();
        if(GetIsObjectValid(oFriend)) 
		{
             object oTarget = GetLastHostileActor(oFriend);
             if(GetIsObjectValid(oTarget) && !GetIsImmune(oTarget, IMMUNITY_TYPE_SNEAK_ATTACK, OBJECT_SELF) &&
			 GetAttackTarget(oTarget)!=OBJECT_SELF && ValidTarget(oTarget)) 
			 {
                 ActionAttack(oTarget);
                 return TRUE;
             }
         }
	}
    return FALSE;
}

/*
// SNEAK ATTACK OTHERS
int TalentSneakAttack()
{
     //MyPrintString("TalentSneakAttack Enter");

     if(GetHasFeat(FEAT_SNEAK_ATTACK))
     {
         object oFriend = GetNearestSeenFriend();
         if (GetIsObjectValid(oFriend)) {
             object oTarget = GetLastHostileActor(oFriend);
             if(GetIsObjectValid(oTarget)
                && !GetIsDead(oTarget)
                && !GetAssociateState(NW_ASC_MODE_DYING, oTarget)) {
                 //MyPrintString("TalentSneakAttack Successful Exit");
                 TalentMeleeAttack(oTarget);
                 return TRUE;
             }
         }
     }
     //MyPrintString("TalentSneakAttack Failed Exit");
     return FALSE;
}
*/

// FLEE COMBAT AND HOSTILES
int TalentFlee(object oIntruder = OBJECT_INVALID)
{
    //MyPrintString("TalentFlee Enter");
    object oTarget = oIntruder;
    if(!GetIsObjectValid(oIntruder))
    {
        oTarget = GetLastHostileActor();
        if(!GetIsObjectValid(oTarget) || GetIsDead(oTarget))
        {
            oTarget = GetNearestSeenEnemy();
            float fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
            if(!GetIsObjectValid(oTarget))
            {
                //MyPrintString("TalentFlee Failed Exit");
                return FALSE;
            }
        }
    }
    //MyPrintString("TalentFlee Successful Exit");
    ClearActions(CLEAR_X0_I0_TALENT_TalentFlee);
    //Look at this to remove the delay
    ActionMoveAwayFromObject(oTarget, TRUE, 10.0f);
    DelayCommand(4.0, ClearActions(CLEAR_X0_I0_TALENT_TalentFlee2));
    return TRUE;
}

// TURN UNDEAD
int TalentUseTurning(object oUndead=OBJECT_INVALID)
{
    int nCount;
    if(GetHasFeat(FEAT_TURN_UNDEAD))
    {
        if(!GetIsObjectValid(oUndead)) oUndead = GetNearestPerceivedEnemy();
        int nHD = GetHitDice(oUndead);
		if(GetDistanceBetween(OBJECT_SELF, oUndead)>=1.5*RADIUS_SIZE_COLOSSAL) return FALSE;
        if(!GetIsObjectValid(oUndead) || GetIsDead(oUndead) || GetHasEffect(EFFECT_TYPE_TURNED, oUndead)
           || GetHitDice(OBJECT_SELF) <= nHD || GetLocalObject(OBJECT_SELF, EVENFLW_LAST_TURN_TARGET)==oUndead)
        {
            return FALSE;
        }
        int TurnLevel=GetLevelByClass(CLASS_TYPE_CLERIC);
        if(GetLevelByClass(CLASS_TYPE_PALADIN)>3) TurnLevel+=GetLevelByClass(CLASS_TYPE_PALADIN)-3;
        if(GetLevelByClass(CLASS_TYPE_BLACKGUARD)>2) TurnLevel+=GetLevelByClass(CLASS_TYPE_BLACKGUARD)-2;
		if(TurnLevel <= nHD) return FALSE;
        if(GetHasFeat(FEAT_PLANT_DOMAIN_POWER) && GetRacialType(oUndead)==RACIAL_TYPE_VERMIN)
            nCount=1;
        if(GetRacialType(oUndead)==RACIAL_TYPE_UNDEAD)
			nCount=1;
        if(nCount > 0)
        {
            ClearActions(CLEAR_X0_I0_TALENT_UseTurning);	
			SetLocalObject(OBJECT_SELF, EVENFLW_LAST_TURN_TARGET, oUndead);
            ActionUseFeat(FEAT_TURN_UNDEAD, OBJECT_SELF);
            return TRUE;
        }
    }
    return FALSE;
}


/*
// TURN UNDEAD
int TalentUseTurning()
{
    //MyPrintString("TalentUseTurning Enter");
    int nCount;
    if(GetHasFeat(FEAT_TURN_UNDEAD))
    {
        object oUndead = GetNearestPerceivedEnemy();
        int nHD = GetHitDice(oUndead);
        if(GetHasEffect(EFFECT_TYPE_TURNED, oUndead)
           || GetHitDice(OBJECT_SELF) <= nHD)
        {
            return FALSE;
        }
        int nElemental = GetHasFeat(FEAT_AIR_DOMAIN_POWER)
            + GetHasFeat(FEAT_EARTH_DOMAIN_POWER)
            + GetHasFeat(FEAT_FIRE_DOMAIN_POWER)
            + GetHasFeat(FEAT_WATER_DOMAIN_POWER);

        int nVermin = GetHasFeat(FEAT_PLANT_DOMAIN_POWER)
            + GetHasFeat(FEAT_ANIMAL_COMPANION);
        int nConstructs = GetHasFeat(FEAT_DESTRUCTION_DOMAIN_POWER);
        int nOutsider = GetHasFeat(FEAT_GOOD_DOMAIN_POWER)
            + GetHasFeat(FEAT_EVIL_DOMAIN_POWER)
            + GetHasFeat(854);             // planar turning

        if(nElemental == TRUE)
            nCount += GetRacialTypeCount(RACIAL_TYPE_ELEMENTAL);

        if(nVermin == TRUE)
            nCount += GetRacialTypeCount(RACIAL_TYPE_VERMIN);

        if(nOutsider == TRUE)
            nCount += GetRacialTypeCount(RACIAL_TYPE_OUTSIDER);

        if(nConstructs == TRUE)
            nCount += GetRacialTypeCount(RACIAL_TYPE_CONSTRUCT);

        nCount += GetRacialTypeCount(RACIAL_TYPE_UNDEAD);

        if(nCount > 0)
        {
            //MyPrintString("TalentUseTurning Successful Exit");
            ClearActions(CLEAR_X0_I0_TALENT_UseTurning);
            //ActionCastSpellAtObject(SPELLABILITY_TURN_UNDEAD, OBJECT_SELF);
            ActionUseFeat(FEAT_TURN_UNDEAD, OBJECT_SELF);
            return TRUE;
        }
    }
    //MyPrintString("TalentUseTurning Failed Exit");
    return FALSE;
}
*/

// ACTIVATE AURAS
int TalentPersistentAbilities()
{
	// BMA-OEI 9/20/06: Disable spell casting while Polymorphed
	if ( GetHasEffect( EFFECT_TYPE_POLYMORPH )  == TRUE )
	{
		return ( FALSE );
	}
	
    //MyPrintString("TalentPersistentAbilities Enter");
    talent tUse = GetCreatureTalent(TALENT_CATEGORY_PERSISTENT_AREA_OF_EFFECT, GetCRMax());
    int nSpellID;
    if(GetIsTalentValid(tUse))
    {
        nSpellID = GetIdFromTalent(tUse);
        if(!GetHasSpellEffect(nSpellID))
        {
            //MyPrintString("TalentPersistentAbilities Successful Exit");
            TalentFilter(tUse, OBJECT_SELF);
            return TRUE;
        }
    }
    //MyPrintString("TalentPersistentAbilities Failed Exit");
    return FALSE;
}

int TalentAdvancedBuff2(object oTarget=OBJECT_SELF, object oIntruder=OBJECT_INVALID, int ismage=0, int castingmode=0)
{
	if (GetHasEffect(EFFECT_TYPE_SILENCE)) 
		return 0;
	int bValid = FALSE;
	int hd = GetHitDice(oIntruder);
	if (castingmode<3) 
		hd += 5;
	int melee = GetLocalInt(oTarget, EVENFLW_NUM_MELEE);
	
	if (hd > GetHitDice(oTarget)/3 
		|| melee)
	{		
		if (oTarget==OBJECT_SELF)
		{
			if(TrySpellGroup(SPELL_PREMONITION, SPELL_GREATER_STONESKIN, SPELL_I_DARK_FORESIGHT, SPELL_STONESKIN, oTarget)==TRUE) 
				bValid = TRUE;
		} 
		else 
		{
			if(TrySpell(SPELL_STONESKIN, oTarget)) 
				bValid=TRUE;
		}
	}
			
	if (castingmode<2 || hd>GetHitDice(oTarget)-5) 
	{
		if(!bValid && melee) 
		{
			if (!GetHasSpellEffect(SPELL_GREATER_INVISIBILITY, oTarget) 
				&& !GetHasSpellEffect(SPELL_I_RETRIBUTIVE_INVISIBILITY, oTarget)) 
			{
				if (GetModuleSwitchValue(EVENFLW_SWITCHES)<2) 
				{
					if (TrySpell(SPELL_GREATER_INVISIBILITY, oTarget)) 
						bValid=TRUE;
					if (oTarget==OBJECT_SELF 
						&& TrySpell(SPELL_I_RETRIBUTIVE_INVISIBILITY, oTarget)) 
						bValid=TRUE;
				} 
				else if(oTarget==OBJECT_SELF) 
				{
					if(TrySpellGroup(SPELL_MIRROR_IMAGE, SPELL_DISPLACEMENT, -1, -1, oTarget)==TRUE) bValid=TRUE;
				} 
				else if(TrySpell(SPELL_DISPLACEMENT, oTarget)) 
					bValid=TRUE;
			} 
			else 
			{
				if(oTarget==OBJECT_SELF && TrySpell(SPELL_MIRROR_IMAGE, oTarget)) 
					bValid=TRUE;
			}					
			if(oTarget==OBJECT_SELF) 
			{
				if(!bValid && TrySpellGroup(SPELL_SHADOW_SHIELD, SPELL_ETHEREAL_VISAGE, SPELL_GHOSTLY_VISAGE, -1, oTarget)==TRUE) bValid=TRUE;
				if(!bValid && TrySpellGroup(SPELL_ELEMENTAL_SHIELD, SPELL_DEATH_ARMOR, -1, -1, oTarget)==TRUE) bValid=TRUE;
			}
		}
		if(ismage) 
		{
			if(!bValid && oTarget==OBJECT_SELF && TrySpellGroup(SPELL_MIND_BLANK, SPELL_LESSER_MIND_BLANK, -1, -1, oTarget)==TRUE) bValid=TRUE;
			if(!bValid && TrySpellGroup(SPELL_ENERGY_IMMUNITY, SPELL_PROTECTION_FROM_ENERGY, SPELL_RESIST_ENERGY, SPELL_ENDURE_ELEMENTS, oTarget)==TRUE) bValid=TRUE;
		}
	}
	return bValid;
}


// FAST BUFF SELF
// * Dec 19 2002: Added the instant parameter so this could be used for 'legal' spellcasting as well
int TalentAdvancedBuff(float fDistance, int bInstant = TRUE)
{
    //MyPrintString("TalentAdvancedBuff Enter");
    object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, OBJECT_SELF, 1, CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY);
    if(GetIsObjectValid(oPC))
    {
        if(GetDistanceToObject(oPC) <= fDistance)
        {
            if(!GetIsFighting(OBJECT_SELF))
            {
                ClearActions(CLEAR_X0_I0_TALENT_AdvancedBuff);
                //Combat Protections
                if(GetHasSpell(SPELL_PREMONITION) && !GetHasSpellEffect(SPELL_PREMONITION))
                {
                    ActionCastSpellAtObject(SPELL_PREMONITION, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                else if(GetHasSpell(SPELL_GREATER_STONESKIN)&& !GetHasSpellEffect(SPELL_GREATER_STONESKIN))
                {
                    ActionCastSpellAtObject(SPELL_GREATER_STONESKIN, OBJECT_SELF, METAMAGIC_NONE, 0, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                else if(GetHasSpell(SPELL_STONESKIN)&& !GetHasSpellEffect(SPELL_STONESKIN))
                {
                    ActionCastSpellAtObject(SPELL_STONESKIN, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                //Visage Protections
                if(GetHasSpell(SPELL_SHADOW_SHIELD)&& !GetHasSpellEffect(SPELL_SHADOW_SHIELD))
                {
                    ActionCastSpellAtObject(SPELL_SHADOW_SHIELD, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                else if(GetHasSpell(SPELL_ETHEREAL_VISAGE)&& !GetHasSpellEffect(SPELL_ETHEREAL_VISAGE))
                {
                    ActionCastSpellAtObject(SPELL_ETHEREAL_VISAGE, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                else if(GetHasSpell(SPELL_GHOSTLY_VISAGE)&& !GetHasSpellEffect(SPELL_GHOSTLY_VISAGE))
                {
                    ActionCastSpellAtObject(SPELL_GHOSTLY_VISAGE, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                //Mantle Protections
                if(GetHasSpell(SPELL_GREATER_SPELL_MANTLE)&& !GetHasSpellEffect(SPELL_GREATER_SPELL_MANTLE))
                {
                    ActionCastSpellAtObject(SPELL_GREATER_SPELL_MANTLE, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                else if(GetHasSpell(SPELL_SPELL_MANTLE)&& !GetHasSpellEffect(SPELL_SPELL_MANTLE))
                {
                    ActionCastSpellAtObject(SPELL_SPELL_MANTLE, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                else if(GetHasSpell(SPELL_LESSER_SPELL_BREACH)&& !GetHasSpellEffect(SPELL_LESSER_SPELL_BREACH))
                {
                    ActionCastSpellAtObject(SPELL_LESSER_SPELL_BREACH, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                // Globes
                if(GetHasSpell(SPELL_GLOBE_OF_INVULNERABILITY)&& !GetHasSpellEffect(SPELL_GLOBE_OF_INVULNERABILITY))
                {
                    ActionCastSpellAtObject(SPELL_GLOBE_OF_INVULNERABILITY, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                else if(GetHasSpell(SPELL_LESSER_GLOBE_OF_INVULNERABILITY)&& !GetHasSpellEffect(SPELL_LESSER_GLOBE_OF_INVULNERABILITY))
                {
                    ActionCastSpellAtObject(SPELL_LESSER_GLOBE_OF_INVULNERABILITY, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }

                //Misc Protections
                if(GetHasSpell(SPELL_ELEMENTAL_SHIELD)&& !GetHasSpellEffect(SPELL_ELEMENTAL_SHIELD))
                {
                    ActionCastSpellAtObject(SPELL_ELEMENTAL_SHIELD, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                else if (GetHasSpell(SPELL_MESTILS_ACID_SHEATH)&& !GetHasSpellEffect(SPELL_MESTILS_ACID_SHEATH))
                {
                    ActionCastSpellAtObject(SPELL_MESTILS_ACID_SHEATH, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                else if (GetHasSpell(SPELL_DEATH_ARMOR)&& !GetHasSpellEffect(SPELL_DEATH_ARMOR))
                {
                    ActionCastSpellAtObject(SPELL_DEATH_ARMOR, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }

                //Elemental Protections
                if(GetHasSpell(SPELL_PROTECTION_FROM_ENERGY)&& !GetHasSpellEffect(SPELL_PROTECTION_FROM_ENERGY))
                {
                    ActionCastSpellAtObject(SPELL_PROTECTION_FROM_ENERGY, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                else if(GetHasSpell(SPELL_RESIST_ENERGY)&& !GetHasSpellEffect(SPELL_RESIST_ENERGY))
                {
                    ActionCastSpellAtObject(SPELL_RESIST_ENERGY, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                else if(GetHasSpell(SPELL_ENDURE_ELEMENTS)&& !GetHasSpellEffect(SPELL_ENDURE_ELEMENTS))
                {
                    ActionCastSpellAtObject(SPELL_ENDURE_ELEMENTS, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }

                //Mental Protections
                if(GetHasSpell(SPELL_MIND_BLANK)&& !GetHasSpellEffect(SPELL_MIND_BLANK))
                {
                    ActionCastSpellAtObject(SPELL_MIND_BLANK, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                else if(GetHasSpell(SPELL_LESSER_MIND_BLANK)&& !GetHasSpellEffect(SPELL_LESSER_MIND_BLANK))
                {
                    ActionCastSpellAtObject(SPELL_LESSER_MIND_BLANK, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                else if(GetHasSpell(SPELL_CLARITY)&& !GetHasSpellEffect(SPELL_CLARITY))
                {
                    ActionCastSpellAtObject(SPELL_CLARITY, OBJECT_SELF, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                //Summon Ally
                if(GetHasSpell(SPELL_BLACK_BLADE_OF_DISASTER))
                {
                    ActionCastSpellAtLocation(SPELL_BLACK_BLADE_OF_DISASTER, GetLocation(OBJECT_SELF), METAMAGIC_NONE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                else if(GetHasSpell(SPELL_SUMMON_CREATURE_IX))
                {
                    ActionCastSpellAtLocation(SPELL_SUMMON_CREATURE_IX, GetLocation(OBJECT_SELF), METAMAGIC_NONE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                else if(GetHasSpell(SPELL_SUMMON_CREATURE_VIII))
                {
                    ActionCastSpellAtLocation(SPELL_SUMMON_CREATURE_VIII, GetLocation(OBJECT_SELF), METAMAGIC_NONE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                else if(GetHasSpell(SPELL_SUMMON_CREATURE_VII))
                {
                    ActionCastSpellAtLocation(SPELL_SUMMON_CREATURE_VII, GetLocation(OBJECT_SELF), METAMAGIC_NONE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                else if(GetHasSpell(SPELL_SUMMON_CREATURE_VI))
                {
                    ActionCastSpellAtLocation(SPELL_SUMMON_CREATURE_VI, GetLocation(OBJECT_SELF), METAMAGIC_NONE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                else if(GetHasSpell(SPELL_SUMMON_CREATURE_V))
                {
                    ActionCastSpellAtLocation(SPELL_SUMMON_CREATURE_V, GetLocation(OBJECT_SELF), METAMAGIC_NONE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                else if(GetHasSpell(SPELL_SUMMON_CREATURE_IV))
                {
                    ActionCastSpellAtLocation(SPELL_SUMMON_CREATURE_IV, GetLocation(OBJECT_SELF), METAMAGIC_NONE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                else if(GetHasSpell(SPELL_SUMMON_CREATURE_III))
                {
                    ActionCastSpellAtLocation(SPELL_SUMMON_CREATURE_III, GetLocation(OBJECT_SELF), METAMAGIC_NONE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                else if(GetHasSpell(SPELL_SUMMON_CREATURE_II))
                {
                    ActionCastSpellAtLocation(SPELL_SUMMON_CREATURE_II, GetLocation(OBJECT_SELF), METAMAGIC_NONE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }
                else if(GetHasSpell(SPELL_SUMMON_CREATURE_I))
                {
                    ActionCastSpellAtLocation(SPELL_SUMMON_CREATURE_I, GetLocation(OBJECT_SELF), METAMAGIC_NONE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, bInstant);
                }

                //MyPrintString("TalentAdvancedBuff Successful Exit");
                return TRUE;
            }
        }
    }
    //MyPrintString("TalentAdvancedBuff Failed Exit");
    return FALSE;
}


int TalentBuffSelf()
{
    int total=0;
	int t1=TALENT_CATEGORY_BENEFICIAL_PROTECTION_POTION;
	int t2=TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_POTION;
	if(d2()==1) {
		total=t2;
		t2=t1;
		t1=total;
	}
	talent tUse1=EvenGetCreatureTalent(t1, GetCRMax(), d2()-1);
	talent tUse2=EvenGetCreatureTalent(t2, GetCRMax(), d2()-1);
	if(TestTalent(tUse1, OBJECT_SELF)) return TRUE;
	if(TestTalent(tUse2, OBJECT_SELF)) return TRUE;
	return FALSE;
}


/*
// USE POTIONS
int TalentBuffSelf()
{
    //MyPrintString("TalentBuffSelf Enter");
    //int bValid = FALSE;
    int nCRMax = GetCRMax();
    talent tUse = GetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_PROTECTION_POTION,
                                 nCRMax);
    if(!GetIsTalentValid(tUse)) {
        tUse = GetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_POTION,
                                     nCRMax);
        if(!GetIsTalentValid(tUse))
            return FALSE;
    }
    int nType = GetTypeFromTalent(tUse);
    int nIndex = GetIdFromTalent(tUse);

    if(nType == TALENT_TYPE_SPELL && !GetHasSpellEffect(nIndex)) {
        //MyPrintString("TalentBuffSelf Successful Exit");
        TalentFilter(tUse, OBJECT_SELF);
        return TRUE;
    }

    //MyPrintString("TalentBuffSelf Failed Exit");
    return FALSE;
}
*/


int TalentSeeInvisible()
{
	if(GetHasEffect(EFFECT_TYPE_SILENCE)) return 0;
    int nSpell;
    int bValid = FALSE;
    if(GetHasSpell(SPELL_TRUE_SEEING))
    {
        nSpell = SPELL_TRUE_SEEING;
        bValid = TRUE;
    }
    else if(GetHasSpell(SPELL_I_SEE_THE_UNSEEN))
	{
		nSpell = SPELL_I_SEE_THE_UNSEEN;
        bValid = TRUE;
	}
	else if(GetHasSpell(SPELL_BLINDSIGHT))
	{
		nSpell = SPELL_BLINDSIGHT;
        bValid = TRUE;
	}
	else if(GetHasSpell(SPELL_SEE_INVISIBILITY))
    {
        nSpell = SPELL_SEE_INVISIBILITY;
        bValid = TRUE;
    }
	else if(GetHasSpell(SPELL_INVISIBILITY_PURGE))
    {
        nSpell = SPELL_INVISIBILITY_PURGE;
        bValid = TRUE;
    }
    if(bValid == TRUE)
    {
        ClearActions(CLEAR_X0_I0_TALENT_SeeInvisible);
        ActionCastSpellAtObject(nSpell, OBJECT_SELF);
    }
    return bValid;
}

/*
// USE SPELLS TO DEFEAT INVISIBLE CREATURES
// THIS TALENT IS NOT USED
int TalentSeeInvisible()
{
    //MyPrintString("TalentSeeInvisible Enter");
    int nSpell;
    int bValid = FALSE;
    if(GetHasSpell(SPELL_TRUE_SEEING))
    {
        nSpell = SPELL_TRUE_SEEING;
        bValid = TRUE;
    }
    else if(GetHasSpell(SPELL_INVISIBILITY_PURGE))
    {
        nSpell = SPELL_INVISIBILITY_PURGE;
        bValid = TRUE;
    }
    else if(GetHasSpell(SPELL_SEE_INVISIBILITY))
    {
        nSpell = SPELL_SEE_INVISIBILITY;
        bValid = TRUE;
    }
    else if(GetHasSpell(SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE))
    {
        nSpell = SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE;
        bValid = TRUE;
    }
	else if(GetHasSpell(SPELL_I_SEE_THE_UNSEEN))
	{
		nSpell = SPELL_I_SEE_THE_UNSEEN;
        bValid = TRUE;
	}
    if(bValid == TRUE)
    {
        //MyPrintString("TalentSeeInvisible Successful Exit");
        ClearActions(CLEAR_X0_I0_TALENT_SeeInvisible);
        ActionCastSpellAtObject(nSpell, OBJECT_SELF);
    }
    //MyPrintString("TalentSeeInvisible Failed Exit");
    return bValid;
}
*/

// Utility function for TalentCureCondition
// Checks to see if the creature has the given condition in the
// given condition value.
// To use, you must first calculate the nCurrentConditions value
// with GetCurrentNegativeConditions.
// The value of nCondition can be any of the COND_* constants
// declared in x0_i0_talent.
int GetHasNegativeCondition(int nCondition, int nCurrentConditions)
{
    return (nCurrentConditions & nCondition);
}


int GetIsPositiveBuffSpellWithNegativeEffect(int nSpellId)
{
	int nRet = FALSE;
	if (nSpellId == SPELL_ENLARGE_PERSON
		|| nSpellId == SPELL_RIGHTEOUS_MIGHT
		|| nSpellId == SPELL_STONE_BODY
		|| nSpellId == SPELL_IRON_BODY
		|| nSpellId == 803 //GrayEnlarge Special ability
		)
		nRet = TRUE;
	return (nRet);					
}

// Utility function for TalentCureCondition()
// Returns an integer with bitwise flags set that represent the
// current negative conditions on the creature.
// To be used with GetHasNegativeCondition.
int GetCurrentNegativeConditions(object oCreature)
{
    int nSum = 0;
    int nType=-1;
	int nSpellId = -1;
    effect eEffect = GetFirstEffect(oCreature);
	
    while(GetIsEffectValid(eEffect)) 
	{
        nType = GetEffectType(eEffect);
        nSpellId = GetEffectSpellId(eEffect); // the spell this effect comes from
		if (!GetIsPositiveBuffSpellWithNegativeEffect(nSpellId))
		{
	        switch (nType) 
			{
		        case EFFECT_TYPE_DISEASE:           nSum = nSum | COND_DISEASE; break;
		        case EFFECT_TYPE_POISON:            nSum = nSum | COND_POISON; break;
		        case EFFECT_TYPE_CURSE:             nSum = nSum | COND_CURSE; break;
		        case EFFECT_TYPE_NEGATIVELEVEL:     nSum = nSum | COND_DRAINED; break;
		        case EFFECT_TYPE_ABILITY_DECREASE:	nSum = nSum | COND_ABILITY; break;
					//if(GetEffectSpellId(eEffect)!=SPELL_ENLARGE_PERSON) nSum = nSum | COND_ABILITY;
					//break;
		        case EFFECT_TYPE_BLINDNESS:
		        case EFFECT_TYPE_DEAF:              nSum = nSum | COND_BLINDDEAF; break;
		       	case EFFECT_TYPE_FRIGHTENED:        nSum = nSum | COND_FEAR; break;
		        case EFFECT_TYPE_SLOW:				nSum = nSum | COND_SLOW; break;
		        case EFFECT_TYPE_PARALYZE:          nSum = nSum | COND_PARALYZE; break;
		        case EFFECT_TYPE_PETRIFY:           nSum = nSum | COND_PETRIFY; break;
			}
		}			
        eEffect = GetNextEffect(oCreature);
    }
    return nSum;
}

/*
These are the effects the various restore spells negate
Lesser Restore:
EFFECT_TYPE_ABILITY_DECREASE
EFFECT_TYPE_AC_DECREASE
EFFECT_TYPE_ATTACK_DECREASE
EFFECT_TYPE_DAMAGE_DECREASE
EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE
EFFECT_TYPE_SAVING_THROW_DECREASE
EFFECT_TYPE_SPELL_RESISTANCE_DECREASE
EFFECT_TYPE_SKILL_DECREASE

Restore: (above +)
EFFECT_TYPE_BLINDNESS
EFFECT_TYPE_DEAF
EFFECT_TYPE_PARALYZE
EFFECT_TYPE_NEGATIVELEVEL
  
Greater Restore: (above +)
EFFECT_TYPE_CURSE
EFFECT_TYPE_DISEASE
EFFECT_TYPE_POISON
EFFECT_TYPE_CHARMED
EFFECT_TYPE_DOMINATED
EFFECT_TYPE_DAZED
EFFECT_TYPE_CONFUSED
EFFECT_TYPE_FRIGHTENED
EFFECT_TYPE_SLOW
EFFECT_TYPE_STUNNED

*/
int GetHasConditionCuredBySpell(int nSum, int nSpellId)
{
	int nRet = FALSE;
	int LesserRestoreConditions = COND_ABILITY;
	int RestoreConditions = LesserRestoreConditions|COND_BLINDDEAF|COND_PARALYZE|COND_DRAINED;
	int GreaterRestoreConditions = RestoreConditions|COND_POISON|COND_DISEASE|COND_CURSE|COND_FEAR|COND_SLOW;
	
	switch (nSpellId)
	{
		case SPELL_NEUTRALIZE_POISON:
			nRet = (GetHasNegativeCondition(COND_POISON, nSum));
			break;
			
		case SPELL_REMOVE_DISEASE:
			nRet = (GetHasNegativeCondition(COND_DISEASE, nSum));
			break;

		case SPELL_REMOVE_CURSE:
			nRet = (GetHasNegativeCondition(COND_CURSE, nSum));
			break;

		case SPELL_REMOVE_BLINDNESS_AND_DEAFNESS:
			nRet = (GetHasNegativeCondition(COND_BLINDDEAF, nSum));
			break;

																
		case SPELL_LESSER_RESTORATION:
			nRet = (GetHasNegativeCondition(LesserRestoreConditions, nSum));
			break;

		case SPELL_RESTORATION:
			nRet = (GetHasNegativeCondition(RestoreConditions, nSum));
			break;

		case SPELL_GREATER_RESTORATION:
			nRet = (GetHasNegativeCondition(GreaterRestoreConditions, nSum));
			break;

		// probably won't be a potion of this, and if there was, how would you use it?			
		/*
		case SPELL_STONE_TO_FLESH:
			nRet = (GetHasNegativeCondition(GreaterRestoreConditions, nSum));
			break;
			
		case SPELL_REMOVE_PARALYSIS:
			nRet = (GetHasNegativeCondition(COND_PARALYZE, nSum));
			break;

		case SPELL_REMOVE_FEAR:
			nRet = (GetHasNegativeCondition(COND_FEAR, nSum));
			break;
		*/			
	}
	return (nRet);
}

// pick a random conditional potion and see if I can use it.
int TalentCureConditionSelf(int nSum)
{
	if (nSum == 0)
		return FALSE; // no negative condtions to cure

	//SpeakString("Pondering using a potion to cure myself...");
	talent tUse = GetCreatureTalentRandomStd(TALENT_CATEGORY_BENEFICIAL_CONDITIONAL_POTION);
	if (GetIsTalentValid(tUse))
	{
	   	int nSpellId = GetIdFromTalent(tUse);
		int nType=GetTypeFromTalent(tUse);
		if (nType == TALENT_TYPE_SPELL)
		{
			if (GetHasConditionCuredBySpell(nSum, nSpellId))
			{
				return(EvenTalentFilter(tUse, OBJECT_SELF));
			}
		}
	}
    return FALSE;
}							


// CURE DISEASE, POISON ETC
int TalentCureCondition()
{
	// if we are silenced then nevermind.
	if (GetHasEffect(EFFECT_TYPE_SILENCE)) 
		return 0;
		
    int nSum;		// bit flag list of negative conditions
    int nCondLR;	// count of the number of conditions that could be healed by any restoration
    int nCondR;		// count of the number of conditions that could be healed by restoration or greater restoration
    int nCondGR;	// count of the number of conditions that could be healed by greater restoration
	int nMinCond;
    int nSpell;
	int nTargetCount = 0;	// count of number of creatures looked at
	int bOwned = GetIsRosterMember(OBJECT_SELF) || GetIsOwnedByPlayer(OBJECT_SELF);
	
	
	object oTarget=GetFirstTalentTarget(bOwned, RADIUS_SIZE_LARGE);
	
	// only look at first few (5) targets for those who aren't PC's or Companions
    while(GetIsObjectValid(oTarget) && (bOwned || nTargetCount<5)) 
	{
		// we'll help anyone who is not an enemy (used to be GetIsFriend())
        // if(GetIsFriend(oTarget)) {
        if(!GetIsEnemy(oTarget)) 
		{
            nSpell = 0;
            nSum = GetCurrentNegativeConditions(oTarget);
            // friend has negative effects -- try and heal them

            // These effects will be healed in reverse order if
            // we have the spells for them and don't have
            // restoration.
            if (nSum != 0) 
			{
                if (GetHasNegativeCondition(COND_POISON, nSum)) {
                    nCondGR++;
                    if (GetHasSpell(SPELL_NEUTRALIZE_POISON))
                        nSpell = SPELL_NEUTRALIZE_POISON;
                }
                if (GetHasNegativeCondition(COND_DISEASE, nSum)) {
                    nCondGR++;
                    if (GetHasSpell(SPELL_REMOVE_DISEASE))
                        nSpell = SPELL_REMOVE_DISEASE;
                }
                if (GetHasNegativeCondition(COND_CURSE, nSum)) {
                    nCondGR++;
                    if (GetHasSpell(SPELL_REMOVE_CURSE))
                        nSpell = SPELL_REMOVE_CURSE;
                }
                if (GetHasNegativeCondition(COND_BLINDDEAF, nSum)) {
                    nCondR++;
                    if (GetHasSpell(SPELL_REMOVE_BLINDNESS_AND_DEAFNESS))
                        nSpell = SPELL_REMOVE_BLINDNESS_AND_DEAFNESS;
                }
                if (GetHasNegativeCondition(COND_PARALYZE, nSum)) {
                    nCondR++;
                    if(GetHasSpell(SPELL_REMOVE_PARALYSIS))
                        nSpell=SPELL_REMOVE_PARALYSIS;
                }
                if (GetHasNegativeCondition(COND_FEAR, nSum)) {
                    nCondGR++;
                    if(GetHasSpell(SPELL_REMOVE_FEAR))
                        nSpell=SPELL_REMOVE_FEAR;
                }
				
                // For the conditions that can only be cured by
                // restoration, we add 1
                if (GetHasNegativeCondition(COND_DRAINED, nSum)) {
                    nCondR++; // += 2;
                }
                if (GetHasNegativeCondition(COND_ABILITY, nSum)) {
                    nCondLR++; // += 2;
                }
                if (GetHasNegativeCondition(COND_SLOW, nSum)) {
                    nCondGR++;
				}
				
				// shoule we use a restoration spell instead?
				nMinCond = 1; // minimum number of conditions we must be able to negate to make this worthwhile
				if (nSpell>0) // we have something we could use already, so only use restore if we can remove 2 things...
					nMinCond = 2;
				
				// can we get rid of more things than if we just used one of the above spells?					
                if ((nCondLR >= nMinCond) && (GetHasSpell(SPELL_LESSER_RESTORATION))) 
				{
					nMinCond = nCondLR+1;
                	nSpell = SPELL_LESSER_RESTORATION;
				}
				// can we get rid of even more things with a restore?					
                if ((nCondR+nCondLR >= nMinCond) && (GetHasSpell(SPELL_RESTORATION))) // can we get rid of more GR only conditions than we could with spells?
				{
					nMinCond = nCondR+nCondLR+1;
					nSpell = SPELL_RESTORATION;
				}
				
				// can we get rid of even more things with a greater restore?					
                if ((nCondGR+nCondR+nCondLR >= nMinCond) && (GetHasSpell(SPELL_GREATER_RESTORATION))) // can we get rid of more GR only conditions than we could with spells?
				{
					nSpell = SPELL_GREATER_RESTORATION;
				}
	
                // If we have more than one condition or a condition
                // that can only be cured by restoration, try one of
                // those spells first if we have them.
                /*if (nCond > 1) {
                    if (GetHasSpell(SPELL_GREATER_RESTORATION)) {
                        nSpell = SPELL_GREATER_RESTORATION;
                    } else if (GetHasSpell(SPELL_RESTORATION)) {
                        nSpell = SPELL_RESTORATION;
                    } else if (GetHasSpell(SPELL_LESSER_RESTORATION)) {
                        nSpell = SPELL_LESSER_RESTORATION;
                    }
                }*/
				
                if (GetHasNegativeCondition(COND_PETRIFY, nSum)) {
                    //nCond++; // this effect are not cured by restoration
                    if(GetHasSpell(SPELL_STONE_TO_FLESH))
                        nSpell=SPELL_STONE_TO_FLESH;
                }
                if(nSpell != 0) {
                    ClearActions(CLEAR_X0_I0_TALENT_AdvancedBuff);
                    ActionCastSpellAtObject(nSpell, oTarget);
                    return TRUE;
                }
				else
				{  	// we don't have a spell to cure a condition
					// maybe we have a condition that could be cured by a potion on ourselves
					if (oTarget == OBJECT_SELF)
					{
						TalentCureConditionSelf(nSum);
					}						
				}
				
            }
        }
		nTargetCount++;
		oTarget=GetNextTalentTarget(bOwned, RADIUS_SIZE_LARGE);
    }
    return FALSE;
}


// DRAGON COMBAT
// * February 2003: Cut the melee interaction (BK)
int TalentDragonCombat(object oIntruder = OBJECT_INVALID)
{
    //MyPrintString("TalentDragonCombat Enter");
    object oTarget = oIntruder;
    if(!GetIsObjectValid(oTarget))
    {
        oTarget = GetAttemptedAttackTarget();
        if(!GetIsObjectValid(oTarget) || GetIsDead(oTarget))
        {
            oTarget = GetLastHostileActor();
            if(!GetIsObjectValid(oTarget) || GetIsDead(oTarget))
            {
                oTarget = GetNearestPerceivedEnemy();
                if(!GetIsObjectValid(oTarget))
                {
                    return FALSE;
                }
            }
        }
    }
    int nCnt = GetLocalInt(OBJECT_SELF, "NW_GENERIC_DRAGONS_BREATH");
    talent tUse = GetCreatureTalent(TALENT_CATEGORY_DRAGONS_BREATH, GetCRMax());
    //SpeakString(IntToString(nCnt));
    if(GetIsTalentValid(tUse) && nCnt >= 2)
    {
        //MyPrintString("TalentDragonCombat Successful Exit");
        TalentFilter(tUse, oTarget);
        nCnt = 0;
        SetLocalInt(OBJECT_SELF, "NW_GENERIC_DRAGONS_BREATH", nCnt);
        return TRUE;
    }
    // * breath weapons only happen every 3 rounds
    nCnt++;
    SetLocalInt(OBJECT_SELF, "NW_GENERIC_DRAGONS_BREATH", nCnt);

    //MyPrintString("TalentDragonCombat Failed Exit");
    //SetLocalInt(OBJECT_SELF, "NW_GENERIC_DRAGONS_BREATH", nCnt);
    return FALSE;
}

// BARD SONG
/* from nwscript.nss:

inspiration songs (toggable):
int FEAT_BARDSONG_INSPIRE_COURAGE			= 1466;
int FEAT_BARDSONG_INSPIRE_COMPETENCE		= 1467;
int FEAT_BARDSONG_INSPIRE_DEFENSE			= 1468;
int FEAT_BARDSONG_INSPIRE_REGENERATION		= 1469;
int FEAT_BARDSONG_INSPIRE_TOUGHNESS			= 1470;
int FEAT_BARDSONG_INSPIRE_SLOWING			= 1471;
int FEAT_BARDSONG_INSPIRE_JARRING			= 1472;

inspiration song spell effects:
int SPELLABILITY_SONG_INSPIRE_COURAGE      	= 905;
int SPELLABILITY_SONG_INSPIRE_COMPETENCE   	= 906;
int SPELLABILITY_SONG_INSPIRE_DEFENSE      	= 907;
int SPELLABILITY_SONG_INSPIRE_REGENERATION	= 908;
int SPELLABILITY_SONG_INSPIRE_TOUGHNESS    	= 909;
int SPELLABILITY_SONG_INSPIRE_SLOWING      	= 910;
int SPELLABILITY_SONG_INSPIRE_JARRING      	= 911;

normal songs (target self, uses per day):
int FEAT_BARDSONG_COUNTERSONG				= 1473;
int FEAT_BARDSONG_HAVEN_SONG				= 1475;
int FEAT_BARDSONG_IRONSKIN_CHANT			= 1477;
int FEAT_BARDSONG_INSPIRE_HEROICS			= 1479;
int FEAT_BARDSONG_INSPIRE_LEGION			= 1480;

normal song (target self) spell effects:
int SPELLABILITY_SONG_COUNTERSONG          	= 912;
int SPELLABILITY_SONG_HAVEN_SONG           	= 914;
int SPELLABILITY_SONG_IRONSKIN_CHANT       	= 916;
int SPELLABILITY_SONG_INSPIRE_HEROICS      	= 918;
int SPELLABILITY_SONG_INSPIRE_LEGION       	= 919;

normal songs (target other, uses per day):
int FEAT_BARDSONG_FASCINATE					= 1474;
int FEAT_BARDSONG_CLOUD_MIND				= 1476;
int FEAT_BARDSONG_SONG_OF_FREEDOM			= 1478;

normal song (target other) spell effects:
int SPELLABILITY_SONG_FASCINATE           	= 913;
int SPELLABILITY_SONG_CLOUD_MIND           	= 915;
int SPELLABILITY_SONG_OF_FREEDOM           	= 917;
*/

// Return TRUE if oObject is affected by a Normal Bard Song
int GetHasNormalBardSongSpellEffect( object oObject=OBJECT_SELF )
{
	if ( GetHasSpellEffect( SPELLABILITY_SONG_COUNTERSONG, oObject ) ||
		 GetHasSpellEffect( SPELLABILITY_SONG_HAVEN_SONG, oObject ) ||
		 GetHasSpellEffect( SPELLABILITY_SONG_IRONSKIN_CHANT, oObject ) ||
		 GetHasSpellEffect( SPELLABILITY_SONG_INSPIRE_HEROICS, oObject ) ||
		 GetHasSpellEffect( SPELLABILITY_SONG_INSPIRE_LEGION, oObject ) )
	{
		return ( TRUE );
	}
		 
	return ( FALSE );
}

// Return TRUE if oObject is affected by an Inspire Bard Song
int GetHasInspireBardSongSpellEffect( object oObject=OBJECT_SELF )
{
	if ( GetHasSpellEffect( SPELLABILITY_SONG_INSPIRE_COURAGE, oObject ) ||
		 GetHasSpellEffect( SPELLABILITY_SONG_INSPIRE_COMPETENCE, oObject ) ||
		 GetHasSpellEffect( SPELLABILITY_SONG_INSPIRE_DEFENSE, oObject ) ||
		 GetHasSpellEffect( SPELLABILITY_SONG_INSPIRE_REGENERATION, oObject ) ||
		 GetHasSpellEffect( SPELLABILITY_SONG_INSPIRE_TOUGHNESS, oObject ) ||
		 GetHasSpellEffect( SPELLABILITY_SONG_INSPIRE_SLOWING, oObject ) ||
		 GetHasSpellEffect( SPELLABILITY_SONG_INSPIRE_JARRING, oObject ) )
	{
		return ( TRUE );
	}
		 
	return ( FALSE );
}

// Return a useable Normal Bard Song feat, or 0 if none found.
int GetNormalBardSongFeat( object oCreature=OBJECT_SELF )
{
	if ( GetHasFeat( FEAT_BARDSONG_INSPIRE_LEGION, oCreature ) )
		return ( FEAT_BARDSONG_INSPIRE_LEGION );
	if ( GetHasFeat( FEAT_BARDSONG_INSPIRE_HEROICS, oCreature ) )
		return ( FEAT_BARDSONG_INSPIRE_HEROICS );
	if ( GetHasFeat( FEAT_BARDSONG_IRONSKIN_CHANT, oCreature) )
		return ( FEAT_BARDSONG_IRONSKIN_CHANT );
	return ( 0 );
}

/*
// Return a useable Normal Bard Song feat, or 0 if none found.
int GetNormalBardSongFeat( object oCreature=OBJECT_SELF ) 
{
	if ( GetHasFeat( FEAT_BARDSONG_INSPIRE_LEGION, oCreature ) )
		return ( FEAT_BARDSONG_INSPIRE_LEGION );
	if ( GetHasFeat( FEAT_BARDSONG_INSPIRE_HEROICS, oCreature ) )
		return ( FEAT_BARDSONG_INSPIRE_HEROICS );
	if ( GetHasFeat( FEAT_BARDSONG_IRONSKIN_CHANT, oCreature) )
		return ( FEAT_BARDSONG_IRONSKIN_CHANT );
	if ( GetHasFeat( FEAT_BARDSONG_HAVEN_SONG, oCreature) )
		return ( FEAT_BARDSONG_HAVEN_SONG );
	if ( GetHasFeat( FEAT_BARDSONG_COUNTERSONG, oCreature) )
		return ( FEAT_BARDSONG_COUNTERSONG );

	return ( 0 );
}
*/

// Return a useable Inspire Bard Song feat, or 0 if none found.
int GetInspireBardSongFeat( object oCreature=OBJECT_SELF ) 
{
	if ( GetHasFeat( FEAT_BARDSONG_INSPIRE_COURAGE, oCreature ) )
		return ( FEAT_BARDSONG_INSPIRE_COURAGE );
	return ( 0 );
}

/*
// Return a useable Inspire Bard Song feat, or 0 if none found.
int GetInspireBardSongFeat( object oCreature=OBJECT_SELF ) 
{
	if ( GetHasFeat( FEAT_BARDSONG_INSPIRE_JARRING, oCreature ) )
		return ( FEAT_BARDSONG_INSPIRE_JARRING );
	if ( GetHasFeat( FEAT_BARDSONG_INSPIRE_SLOWING, oCreature ) )
		return ( FEAT_BARDSONG_INSPIRE_SLOWING );
	if ( GetHasFeat( FEAT_BARDSONG_INSPIRE_TOUGHNESS, oCreature ) )
		return ( FEAT_BARDSONG_INSPIRE_TOUGHNESS );
	if ( GetHasFeat( FEAT_BARDSONG_INSPIRE_REGENERATION, oCreature ) )
		return ( FEAT_BARDSONG_INSPIRE_REGENERATION );
	if ( GetHasFeat( FEAT_BARDSONG_INSPIRE_DEFENSE, oCreature ) )
		return ( FEAT_BARDSONG_INSPIRE_DEFENSE );
	if ( GetHasFeat( FEAT_BARDSONG_INSPIRE_COMPETENCE, oCreature ) )
		return ( FEAT_BARDSONG_INSPIRE_COMPETENCE );
	if ( GetHasFeat( FEAT_BARDSONG_INSPIRE_COURAGE, oCreature ) )
		return ( FEAT_BARDSONG_INSPIRE_COURAGE );

	return ( 0 );
}
*/


// Return TRUE if chose to sing a Bard Song
int TalentBardSong()
{
	int nBardLevels = GetLevelByClass( CLASS_TYPE_BARD, OBJECT_SELF );
	if ( nBardLevels < 1 )
	{
		return ( FALSE );
	}

	int nBardFeat;

	//if ( GetHasNormalBardSongSpellEffect( OBJECT_SELF ) == FALSE )
	if ( GetHasNormalBardSongSpellEffect( OBJECT_SELF ) == FALSE && GetHasInspireBardSongSpellEffect( OBJECT_SELF ) == FALSE)
	{
		nBardFeat = GetNormalBardSongFeat();
		if ( nBardFeat > 0 )
		{
			ClearActions( CLEAR_X0_I0_TALENT_BardSong );
			ActionUseFeat( nBardFeat, OBJECT_SELF );
			return ( TRUE );
		}
	} 

	if ( GetHasInspireBardSongSpellEffect( OBJECT_SELF ) == FALSE )
	{
		nBardFeat = GetInspireBardSongFeat();
		if ( nBardFeat > 0 )
		{
			ClearActions( CLEAR_X0_I0_TALENT_BardSong );
			ActionUseFeat( nBardFeat, OBJECT_SELF );
			return ( TRUE );
		}
	}
	return ( FALSE );
}







//===========================================
// VERSION 2.0 TALENTS
//===========================================

// ADVANCED PROTECT SELF Talent 2.0
// This will use the class specific defensive spells first and
// leave the rest for the normal defensive AI
int TalentAdvancedProtectSelf()
{
    //MyPrintString("TalentAdvancedProtectSelf Enter");

    struct sEnemies sCount = DetermineEnemies();
    int bValid = FALSE;
    int nCnt;
    string sClass = GetMostDangerousClass(sCount);
    talent tUse = StartProtectionLoop();
    while(GetIsTalentValid(tUse) && nCnt < 10)
    {
        //MyPrintString("TalentAdvancedProtectSelf Search Self");
        tUse = GetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_PROTECTION_SELF,
                                     GetCRMax());
        if(GetIsTalentValid(tUse)
           && GetMatchCompatibility(tUse, sClass, NW_TALENT_PROTECT))
        {
            bValid = TRUE;
            nCnt = 11;
        } else {
            //MyPrintString(" TalentAdvancedProtectSelfSearch Single");
            tUse =
                GetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_PROTECTION_SINGLE,
                                      GetCRMax());
            if(GetIsTalentValid(tUse)
               && GetMatchCompatibility(tUse, sClass, NW_TALENT_PROTECT))
            {
                bValid = TRUE;
                nCnt = 11;
            } else {
                //MyPrintString("TalentAdvancedProtectSelf Search Area");
                tUse =
                    GetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_PROTECTION_AREAEFFECT,
                                          GetCRMax());
                if(GetIsTalentValid(tUse)
                   && GetMatchCompatibility(tUse, sClass, NW_TALENT_PROTECT))
                {
                    bValid = TRUE;
                    nCnt = 11;
                }
            }
        }
        nCnt++;
    }

    if(bValid == TRUE)
    {
        int nType = GetTypeFromTalent(tUse);
        int nIndex = GetIdFromTalent(tUse);

        if(nType == TALENT_TYPE_SPELL)
        {
            if(!GetHasSpellEffect(nIndex)) {
                //MyPrintString("TalentAdvancedProtectSelf Successful Exit");
                TalentFilter(tUse, OBJECT_SELF);
                return TRUE;
            }
        } else if(nType == TALENT_TYPE_FEAT) {
            if(!GetHasFeatEffect(nIndex)) {
                //MyPrintString("TalentAdvancedProtectSelf Successful Exit");
                TalentFilter(tUse, OBJECT_SELF);
                return TRUE;
            }
        } else {
            //MyPrintString("TalentAdvancedProtectSelf Successful Exit");
            TalentFilter(tUse, OBJECT_SELF);
            return TRUE;
        }
    }
    //MyPrintString("TalentAdvancedProtectSelf Failed Exit");
    return FALSE;
}

// Cast a spell mantle or globe of invulnerability protection on
// yourself.
int TalentSelfProtectionMantleOrGlobe()
{
    //Mantle Protections
    if (TrySpell(SPELL_GREATER_SPELL_MANTLE))
        return TRUE;

    if (TrySpell(SPELL_SPELL_MANTLE))
        return TRUE;

    if (TrySpell(SPELL_GLOBE_OF_INVULNERABILITY))
        return TRUE;

    if (TrySpell(SPELL_LESSER_GLOBE_OF_INVULNERABILITY))	// JLR - OEI 07/11/05 -- Name Changed
        return TRUE;

    return FALSE;
}

// KNOCKDOWN / IMPROVED KNOCKDOWN
// This function tries to use the knockdown feat on oIntruder.
// returns TRUE on Knockdown is ok to try on this combat round,
// returns FALSE if Knockdown will not be tried for whatever reason.
// If TRUE is returned, Kncokdown will already have been put on the action queue.
int TalentKnockdown(object oIntruder)
{
	int nFeat=-1;
    // use knockdown occasionally if we have it
    // and the target is not immune
	int nMySize = GetCreatureSize(OBJECT_SELF);
    if (GetHasFeat(FEAT_IMPROVED_KNOCKDOWN))
	{
		nFeat = FEAT_IMPROVED_KNOCKDOWN;
        nMySize++;
    }
	else if (GetHasFeat(FEAT_KNOCKDOWN))
		nFeat = FEAT_KNOCKDOWN;

    // prevent silly use of knockdown on immune or
    // too-large targets
    if (GetIsImmune(oIntruder, IMMUNITY_TYPE_KNOCKDOWN) || (GetCreatureSize(oIntruder) > nMySize+1) )
        nFeat = -1;		
	if ((GetHasFeatEffect(FEAT_IMPROVED_KNOCKDOWN, oIntruder))||(GetHasFeatEffect(FEAT_KNOCKDOWN, oIntruder)))
		nFeat = -1;			

    if (nFeat != -1)
	{
		ClearAllActions();
        ActionUseFeat(nFeat, oIntruder);
		//TalentFilter(TalentFeat(nFeat),oIntruder); 
        return TRUE;
    }
	return FALSE;
}


// This function simply attempts to get the best protective
// talent that the caller has, the protective talents as
// follows:
// TALENT_CATEGORY_BENEFICIAL_PROTECTION_SELF
// TALENT_CATEGORY_BENEFICIAL_PROTECTION_SINGLE
// TALENT_CATEGORY_BENEFICIAL_PROTECTION_AREAEFFECT
talent StartProtectionLoop()
{
    talent tUse;
    int nCRMax = GetCRMax();
    tUse = GetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_PROTECTION_SELF,
                                 nCRMax);
    if(GetIsTalentValid(tUse))
        return tUse;

    tUse = GetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_PROTECTION_SINGLE,
                                 nCRMax);
    if(GetIsTalentValid(tUse))
        return tUse;

    tUse = GetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_PROTECTION_AREAEFFECT,
                                 nCRMax);
    return tUse;
}

//===========================================
// EvenFlw functions
//===========================================

int TestTalent(talent tUse, object oTarget, int isArea=FALSE) 
{
    if(GetIsTalentValid(tUse))
    {
        if( (GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL &&
            !GetHasSpellEffect(GetIdFromTalent(tUse), oTarget) &&
            !CompareLastSpellCast(GetIdFromTalent(tUse)) ) ||
            GetTypeFromTalent(tUse) != TALENT_TYPE_SPELL )
        {
            if( GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL)
            {
                SetLastGenericSpellCast(GetIdFromTalent(tUse));
            }
			if(EvenTalentCheck(tUse, oTarget)) {
				if(!isArea)
            		return EvenTalentFilter(tUse, oTarget);
				else {
					ClearActions(CLEAR_X0_INC_GENERIC_TalentFilter);
					ActionUseTalentAtLocation(tUse, GetLocation(oTarget));
            	}
				return TRUE;
			}
        }
    }
	return FALSE;
}


int genericAttemptHarmful(talent tUse, object oTarget, int cat)
{
	if(TestTalent(tUse, oTarget)) return TRUE;
	int nSteps;
	int nCR=GetCRMax();
	int cumm=0;
	for(nSteps=0; nSteps<5; nSteps++) {
		cumm+=d2()+1;
		nCR-=cumm;
		if(nCR<4) nCR=4;
        tUse = EvenGetCreatureTalent(cat, nCR, d2()-1);
        if(TestTalent(tUse, oTarget)) return TRUE;
    }
    return FALSE;
}


// sub function of TalentDebuff()
int SumMord()
{
	if(GetModuleSwitchValue(EVENFLW_SWITCHES)>1) return 0;
    int nCnt=0;
    object oTarget=GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF), TRUE);
    while(GetIsObjectValid(oTarget)) {
        if(GetIsEnemy(oTarget) && !GetIsDead(oTarget)) nCnt++;
        else if(!GetIsDead(oTarget)) nCnt--;
        oTarget=GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF), TRUE);
    }
    return nCnt;
}


int TalentDebuff(object oIntruder=OBJECT_INVALID) 
{
	if(GetLocalInt(OBJECT_SELF, "X2_HENCH_DO_NOT_DISPEL") || GetHasEffect(EFFECT_TYPE_SILENCE)) return FALSE;
	int hd=GetHitDice(OBJECT_SELF);
	if(!GetAssociateState(NW_ASC_SCALED_CASTING)) hd/=2;
    if(GetHitDice(oIntruder)<hd) return FALSE;
    int canbanish=0;
    if(GetHasSpell(SPELL_BANISHMENT)) canbanish=SPELL_BANISHMENT;
    else if(GetHasSpell(SPELL_DISMISSAL)) canbanish=SPELL_DISMISSAL;
    if(canbanish) {
    	object master=GetMaster(oIntruder);
        if(GetIsObjectValid(master) && GetLocalString(oIntruder, "X2_S_PM_IMMUNE_DISMISSAL")!="IMMUNE" &&
               (GetAssociate(ASSOCIATE_TYPE_SUMMONED, master) == oIntruder ||
               GetAssociate(ASSOCIATE_TYPE_FAMILIAR, master) == oIntruder ||
               GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, master) == oIntruder ||
               canbanish==SPELL_BANISHMENT && GetRacialType(oIntruder) == RACIAL_TYPE_OUTSIDER ) ) {
            ClearAllActions();
			ActionCastSpellAtObject(canbanish, oIntruder);
            return TRUE;
        }
	}
    int canbuff=0;
    if(GetHasSpell(SPELL_MORDENKAINENS_DISJUNCTION) ||
        GetHasSpell(SPELL_GREATER_SPELL_BREACH) ||
        GetHasSpell(SPELL_LESSER_SPELL_BREACH)) canbuff=1;
    if(!canbuff && GetHitDice(oIntruder)<GetHitDice(OBJECT_SELF)+5 && ( GetHitDice(oIntruder)<25 &&
        GetHasSpell(SPELL_GREATER_DISPELLING) ||
        GetHitDice(oIntruder)<15 && GetHasSpell(SPELL_DISPEL_MAGIC) ||
        GetHitDice(oIntruder)<10 && GetHasSpell(SPELL_LESSER_DISPEL) ))
        canbuff+=2;
    if(!canbuff) return FALSE;

    int shouldbuff=0;
    effect eEffect = GetFirstEffect(oIntruder);
    while (GetIsEffectValid(eEffect) == TRUE) {
        int nEffectID = GetEffectSpellId(eEffect);
        if(!GetIsObjectValid(GetEffectCreator(eEffect)) || GetIsEnemy(oIntruder, GetEffectCreator(eEffect))) {
            shouldbuff=0;
            break;
        }
        if (nEffectID != -1 && GetEffectSubType(eEffect)!=SUBTYPE_EXTRAORDINARY)
            shouldbuff++;
        eEffect = GetNextEffect(oIntruder);
    }
    if(GetHasSpellEffect(SPELL_PREMONITION, oIntruder)) shouldbuff+=2;
    if(GetHasSpellEffect(SPELL_GREATER_SPELL_MANTLE, oIntruder)) shouldbuff+=2;
    if(GetHasSpellEffect(SPELL_SPELL_RESISTANCE, oIntruder)) shouldbuff+=2;
    if(GetHasSpellEffect(SPELL_SPELL_MANTLE, oIntruder)) shouldbuff+=1;
    if(GetHasSpellEffect(SPELL_SHADOW_SHIELD, oIntruder)) shouldbuff+=1;
    if(GetHasSpellEffect(SPELL_ELEMENTAL_SHIELD, oIntruder)) shouldbuff+=2;
	if(GetHasSpellEffect(SPELL_MIRROR_IMAGE, oIntruder)) shouldbuff+=1;
    int nSpell=-1;
    if(shouldbuff>5 && GetHasSpell(SPELL_MORDENKAINENS_DISJUNCTION))
        if(shouldbuff+SumMord()>5)
            nSpell=SPELL_MORDENKAINENS_DISJUNCTION;
    else if(GetHasSpell(SPELL_GREATER_SPELL_BREACH) &&
        (shouldbuff>3 || shouldbuff>2 && !GetHasSpell(SPELL_LESSER_SPELL_BREACH)) )
        nSpell=SPELL_GREATER_SPELL_BREACH;
    else if(canbuff>1 && shouldbuff>1 && GetHitDice(oIntruder)<25 && GetHasSpell(SPELL_GREATER_DISPELLING))
        nSpell=SPELL_GREATER_DISPELLING;
    else if(shouldbuff>1 && GetHasSpell(SPELL_LESSER_SPELL_BREACH))
        nSpell=SPELL_LESSER_SPELL_BREACH;
    else if(canbuff>1 && shouldbuff>1 && GetHitDice(oIntruder)<15 && GetHasSpell(SPELL_DISPEL_MAGIC))
        nSpell=SPELL_DISPEL_MAGIC;
    else if(canbuff>1 && shouldbuff>1 && GetHitDice(oIntruder)<10 && GetHasSpell(SPELL_LESSER_DISPEL))
        nSpell=SPELL_LESSER_DISPEL;
    if(nSpell!=-1) {
		ClearAllActions();
        ActionCastSpellAtObject(nSpell, oIntruder);
        return TRUE;
    }
    return FALSE;
}


// used by Talent functions
// int bFactionOnly: TRUE = look only at our faction, FALSE = Look at all in sphere of specified radius
// float fRadius: Radius of sphere (only if bFactionOnly=FALSE)
object GetFirstTalentTarget(int bFactionOnly, float fRadius)
{
	if(bFactionOnly)
		return GetFirstFactionMember(OBJECT_SELF, FALSE);
	else
    	return GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(OBJECT_SELF), TRUE);
}


// used by Talent functions
object GetNextTalentTarget(int bFactionOnly, float fRadius)
{
	if(bFactionOnly)
		return GetNextFactionMember(OBJECT_SELF, FALSE);
	else
        return GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(OBJECT_SELF), TRUE);
}	


int TalentResurrect()
{
	if(GetHasEffect(EFFECT_TYPE_SILENCE)) return 0;
    int nSpell;
    int total= 0;
    if(GetHasSpell(SPELL_RESURRECTION))
     	nSpell = SPELL_RESURRECTION;
    else if(GetHasSpell(SPELL_RAISE_DEAD))
     	nSpell = SPELL_RAISE_DEAD;
    else return FALSE;
	int owned=GetIsRosterMember(OBJECT_SELF) || GetIsOwnedByPlayer(OBJECT_SELF);
	object oTarget;
	oTarget=GetFirstTalentTarget(owned, RADIUS_SIZE_COLOSSAL);
	while(GetIsObjectValid(oTarget) && (owned || total<5))
    {
        total++;
        if(!GetIsEnemy(oTarget) && GetIsDead(oTarget) && GetRacialType(oTarget)!=RACIAL_TYPE_UNDEAD && GetArea(OBJECT_SELF)==GetArea(oTarget) && GetDistanceBetween(OBJECT_SELF, oTarget)<RADIUS_SIZE_COLOSSAL)
        {
			ClearAllActions();
          	ActionCastSpellAtObject(nSpell, oTarget);
         	return TRUE;
        }
		oTarget=GetNextTalentTarget(owned, RADIUS_SIZE_COLOSSAL);
    }
    return FALSE;
}


int TrySpellGroup(int nSpell1, int nSpell2, int nSpell3=-1, int nSpell4=-1, object oTarget=OBJECT_SELF, object oCaster=OBJECT_SELF, int nSpell5=-1, int nSpell6=-1)
{
	if(GetHasSpellEffect(nSpell1, oTarget) || GetHasSpellEffect(nSpell2, oTarget) || 
		nSpell3!=-1 && GetHasSpellEffect(nSpell3, oTarget) || (nSpell4!=-1 && GetHasSpellEffect(nSpell4, oTarget) ||
		(nSpell5!=-1 && GetHasSpellEffect(nSpell5, oTarget) || (nSpell6!=-1 && GetHasSpellEffect(nSpell6, oTarget)))))
		return -1;
	if(nSpell1==SPELL_ENERGY_IMMUNITY && (GetHasSpellEffect(SPELL_ENERGY_IMMUNITY_ACID, oTarget) ||
	GetHasSpellEffect(SPELL_ENERGY_IMMUNITY_COLD, oTarget) || GetHasSpellEffect(SPELL_ENERGY_IMMUNITY_ELECTRICAL, oTarget) || 
		GetHasSpellEffect(SPELL_ENERGY_IMMUNITY_FIRE, oTarget) || GetHasSpellEffect(SPELL_ENERGY_IMMUNITY_SONIC, oTarget))) return FALSE;
    if(GetHasSpell(nSpell1, oCaster)) {
		ClearActions(CLEAR_X0_I0_TALENT_AdvancedBuff);
		AssignCommand(oCaster, ActionCastSpellAtObject(nSpell1, oTarget));
        return TRUE;
    } else if(GetHasSpell(nSpell2, oCaster)) {
		ClearActions(CLEAR_X0_I0_TALENT_AdvancedBuff);
		AssignCommand(oCaster, ActionCastSpellAtObject(nSpell2, oTarget));
        return TRUE;
    } else if(nSpell3!=-1 && GetHasSpell(nSpell3, oCaster)) {
		ClearActions(CLEAR_X0_I0_TALENT_AdvancedBuff);
		AssignCommand(oCaster, ActionCastSpellAtObject(nSpell3, oTarget));
        return TRUE;
    } else if(nSpell4!=-1 && GetHasSpell(nSpell4, oCaster)) {
		ClearActions(CLEAR_X0_I0_TALENT_AdvancedBuff);
		AssignCommand(oCaster, ActionCastSpellAtObject(nSpell4, oTarget));
        return TRUE;
    } else if(nSpell5!=-1 && GetHasSpell(nSpell5, oCaster)) {
		ClearActions(CLEAR_X0_I0_TALENT_AdvancedBuff);
		AssignCommand(oCaster, ActionCastSpellAtObject(nSpell5, oTarget));
        return TRUE;
    } else if(nSpell6!=-1 && GetHasSpell(nSpell6, oCaster)) {
		ClearActions(CLEAR_X0_I0_TALENT_AdvancedBuff);
		AssignCommand(oCaster, ActionCastSpellAtObject(nSpell6, oTarget));
        return TRUE;
    }
    return FALSE;
}


int TalentOthers(int nCompassion, object oIntruder=OBJECT_INVALID, int ismage=0, int castingmode=0)
{
    int total=0;
	int t1, t2;
	switch(d4()) {
	case 1:t1=TALENT_CATEGORY_BENEFICIAL_PROTECTION_SINGLE;
	break;
	case 2:t1=TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_SINGLE;
	break;
	case 3:t1=TALENT_CATEGORY_BENEFICIAL_PROTECTION_SELF;
	break;
	case 4:t1=TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_SELF;
	break;
	}
	switch(d2()) {
	case 1:t2=TALENT_CATEGORY_BENEFICIAL_PROTECTION_AREAEFFECT;
	break;
	case 2:t2=TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_AREAEFFECT;
	break;
	}
	if(d2()==1) {
		total=t2;
		t2=t1;
		t1=total;
		total=0;
	}
	int seed=d2();
	talent tUse1=EvenGetCreatureTalent(t1, GetCRMax(), d2()-1, TRUE);
	talent tUse2=EvenGetCreatureTalent(t2, GetCRMax(), d2()-1, TRUE);
	if(seed==1) {
		if((nCompassion<50 || d2()==1) && TalentAdvancedBuff2(OBJECT_SELF, oIntruder, ismage, castingmode)) return TRUE;
		if(TestTalent(tUse1, OBJECT_SELF)) return TRUE;
		if(TestTalent(tUse2, OBJECT_SELF)) return TRUE;
	}
	if(nCompassion<50) return 0;
	int owned=GetIsRosterMember(OBJECT_SELF) || GetIsOwnedByPlayer(OBJECT_SELF);
	object oTarget=GetFirstTalentTarget(owned, RADIUS_SIZE_LARGE);
	while(GetIsObjectValid(oTarget) && (owned || total<5))
    {
        total++;
        if(!GetIsEnemy(oTarget) && !GetIsDead(oTarget) && GetArea(OBJECT_SELF)==GetArea(oTarget) && GetDistanceBetween(OBJECT_SELF, oTarget)<RADIUS_SIZE_LARGE)
        {
			if(d4()==1 && TalentAdvancedBuff2(oTarget, oIntruder, ismage, castingmode)) return TRUE;
          	if(TestTalent(tUse1, oTarget)) return TRUE;
			if(TestTalent(tUse2, oTarget)) return TRUE;
        }
		oTarget=GetNextTalentTarget(owned, RADIUS_SIZE_LARGE);
    }
	if(seed==2) {
		if(TestTalent(tUse1, OBJECT_SELF)) return TRUE;
		if(TestTalent(tUse2, OBJECT_SELF)) return TRUE;
	}
    return FALSE;
}


int TalentLastDitch()
{
	int ret=0;
	int issilenced=GetHasEffect(EFFECT_TYPE_SILENCE);
	if(!issilenced) {
		if(TrySpell(SPELL_DIVINE_POWER, OBJECT_SELF)) return TRUE;
		ret=TrySpellGroup(SPELL_SHAPECHANGE, SPELL_I_WORD_OF_CHANGING, SPELL_TENSERS_TRANSFORMATION, SPELL_IRON_BODY, OBJECT_SELF, OBJECT_SELF, SPELL_POLYMORPH_SELF, SPELL_STONE_BODY);
	}
	if(ret) SetLocalInt(OBJECT_SELF, EVENFLW_AI_UNPOLY, 1);
	if(!ret && !(GetLocalInt(OBJECT_SELF, N2_TALENT_EXCLUDE)& 0x2) &&
	!GetHasEffect(EFFECT_TYPE_POLYMORPH)) {
		if(GetHasFeat(FEAT_ELEMENTAL_SHAPE)) {
			ClearAllActions();
			ActionUseFeat(FEAT_ELEMENTAL_SHAPE, OBJECT_SELF);
			SetLocalInt(OBJECT_SELF, EVENFLW_AI_UNPOLY, 1);
			return TRUE;
		}
		if(GetHasFeat(FEAT_WILD_SHAPE))  {
			ClearAllActions();
			ActionUseFeat(FEAT_WILD_SHAPE, OBJECT_SELF);
			SetLocalInt(OBJECT_SELF, EVENFLW_AI_UNPOLY, 1);
			return TRUE;
		}
	}
	if(!ret && !issilenced && TrySpell(SPELL_TRUE_STRIKE, OBJECT_SELF)) return TRUE;
	return ret;
}


int TalentCantrip(object oIntruder) 
{
    if(GetHitDice(oIntruder)>5 || GetHitDice(OBJECT_SELF)>5 || GetHasEffect(EFFECT_TYPE_SILENCE)) return FALSE;
    int nSpell=-1;
    int seed1=SPELL_ACID_SPLASH, seed2=SPELL_RAY_OF_FROST;
    int dropout=0;
    if(d2()==1) {
        seed1=SPELL_RAY_OF_FROST;
        seed2=SPELL_ACID_SPLASH;
    }
    if(GetHasSpell(SPELL_RESISTANCE) && d2()==1 && !GetHasSpellEffect(SPELL_RESISTANCE) && GetDistanceBetween(OBJECT_SELF, oIntruder)>10.0f) {
        nSpell=SPELL_RESISTANCE;
        oIntruder=OBJECT_SELF;
    } else if(GetHasSpell(SPELL_DAZE) && !GetIsImmune(oIntruder, IMMUNITY_TYPE_MIND_SPELLS) && !GetHasSpellEffect(SPELL_DAZE, oIntruder))
        nSpell=SPELL_DAZE;
    else if(GetHasSpell(SPELL_FLARE) &&!GetHasSpellEffect(SPELL_FLARE, oIntruder))
        nSpell=SPELL_FLARE;
    else if(GetHasSpell(seed1))
        nSpell=seed1;
    else if(GetHasSpell(seed2))
        nSpell=seed2;
    /*else if(GetRacialType(oIntruder)==RACIAL_TYPE_UNDEAD && GetHasSpell(SPELL_CURE_MINOR_WOUNDS) && GetAlignmentGoodEvil(OBJECT_SELF)!=ALIGNMENT_EVIL)
        nSpell=SPELL_CURE_MINOR_WOUNDS;
    else if(GetRacialType(oIntruder)!=RACIAL_TYPE_UNDEAD && GetHasSpell(SPELL_INFLICT_MINOR_WOUNDS) && GetAlignmentGoodEvil(OBJECT_SELF)==ALIGNMENT_EVIL)
        nSpell=SPELL_INFLICT_MINOR_WOUNDS;*/
    else if(GetHasSpell(SPELL_VIRTUE) && !GetHasSpellEffect(SPELL_VIRTUE) && GetDistanceBetween(OBJECT_SELF, oIntruder)>10.0f) {
        nSpell=SPELL_VIRTUE;
		oIntruder=OBJECT_SELF;
    }
    if(nSpell!=-1) {
		ClearAllActions();
        ActionCastSpellAtObject(nSpell, oIntruder);
        return TRUE;
    }
    return FALSE;
}

/* void main() {} /* */