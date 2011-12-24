/*

    Companion and Monster AI

    This file contains routines that are used for spells and melee attack checking against other
    creatures. Note that cure/inflict and heal/harm are done here since they are dual use.

*/
// Edited 2009/3/8 by AcadiusLost for ALFA / ACR
// 
//	2173-2175: Added clause to avert killing of downed PCs.
//

#include "hench_i0_spells"


// test attack spells, also tests heal, harm and cure, inflict since these are dual use
void HenchSpellAttack(int saveType, int targetInformation);

// test special attack spell - don't have normal saves, etc.
void HenchSpellAttackSpecial();

// get melee attack weight against creature (1.0 should kill, 0.0 can't do anything)
float HenchMeleeAttack(object oTarget, int iPosEffectsOnSelf, int bImmobileNoRange);

// test turn undead spell weight 
void HenchCheckTurnUndead();


// globals for spells

const string sCreatureSaveResultStr = "HENCH_CREATURE_SAVE";

const float HENCH_CREATURE_SAVE_UNKNOWN		= -1000.0;
const float HENCH_CREATURE_SAVE_ABORT		= -500.0;


const float HENCH_LOW_ALLY_DAMAGE_THRESHOLD		= 0.05;
const float HENCH_MED_ALLY_DAMAGE_THRESHOLD		= 0.15;
const float HENCH_HIGH_ALLY_DAMAGE_THRESHOLD	= 0.5;
const float HENCH_EXTR_ALLY_DAMAGE_THRESHOLD	= 100.0;

const float HENCH_LOW_ALLY_DAMAGE_WEIGHT		= -3.0;
const float HENCH_MED_ALLY_DAMAGE_WEIGHT		= -2.0;
const float HENCH_HIGH_ALLY_DAMAGE_WEIGHT		= -1.0;


float gfMaximumAllyDamage;
float gfAllyDamageWeight;
float gfMaximumAllyEffect;


void InitializeMonsterAllyDamage()
{
	if (GetHenchOption(HENCH_OPTION_MONSTER_ALLY_DAMAGE))
	{
		int nAlignment = GetAlignmentGoodEvil(OBJECT_SELF);
		if (nAlignment == ALIGNMENT_GOOD)
		{
			gfMaximumAllyDamage	= HENCH_LOW_ALLY_DAMAGE_THRESHOLD;
			gfAllyDamageWeight = HENCH_LOW_ALLY_DAMAGE_WEIGHT;
		}
		else if (nAlignment == ALIGNMENT_EVIL)
		{
			gfMaximumAllyDamage	= HENCH_EXTR_ALLY_DAMAGE_THRESHOLD;
			gfAllyDamageWeight = HENCH_HIGH_ALLY_DAMAGE_WEIGHT;
			gfMaximumAllyEffect = 0.3;	// allow minor effects to be used
		}
		else
		{
			gfMaximumAllyDamage	= HENCH_HIGH_ALLY_DAMAGE_THRESHOLD;
			gfAllyDamageWeight = HENCH_MED_ALLY_DAMAGE_WEIGHT;
		}
	}
	else
	{
		gfMaximumAllyDamage	= HENCH_LOW_ALLY_DAMAGE_THRESHOLD;
		gfAllyDamageWeight = HENCH_LOW_ALLY_DAMAGE_WEIGHT;
	}
}


void InitializeAssociateAllyDamage()
{
	if (GetHenchPartyState(HENCH_PARTY_HIGH_ALLY_DAMAGE))
	{
		gfMaximumAllyDamage	= HENCH_HIGH_ALLY_DAMAGE_THRESHOLD;
		gfAllyDamageWeight = HENCH_HIGH_ALLY_DAMAGE_WEIGHT;
	}
	else if (GetHenchPartyState(HENCH_PARTY_MEDIUM_ALLY_DAMAGE))
	{
		gfMaximumAllyDamage	= HENCH_MED_ALLY_DAMAGE_THRESHOLD;
		gfAllyDamageWeight = HENCH_MED_ALLY_DAMAGE_WEIGHT;
	}
	else
	{
		gfMaximumAllyDamage	= HENCH_LOW_ALLY_DAMAGE_THRESHOLD;
		gfAllyDamageWeight = HENCH_LOW_ALLY_DAMAGE_WEIGHT;
	}
}


const int HENCH_ATTACK_NO_CHECK										= 0;
const int HENCH_ATTACK_CHECK_HEAL									= 1;
const int HENCH_ATTACK_CHECK_NEG_HEALING							= 2;
const int HENCH_ATTACK_CHECK_HUMANOID								= 3;
const int HENCH_ATTACK_CHECK_NOT_ALREADY_EFFECTED					= 4;
const int HENCH_ATTACK_CHECK_INCORPOREAL							= 5;
const int HENCH_ATTACK_CHECK_DARKNESS								= 6;
const int HENCH_ATTACK_CHECK_PETRIFY								= 7;
const int HENCH_ATTACK_CHECK_ANIMAL									= 8;
const int HENCH_ATTACK_CHECK_NOT_CONSTRUCT_OR_UNDEAD				= 9;
const int HENCH_ATTACK_CHECK_DROWN									= 10;
const int HENCH_ATTACK_CHECK_SLEEP									= 11;
const int HENCH_ATTACK_CHECK_BIGBY									= 12;
const int HENCH_ATTACK_CHECK_UNDEAD									= 13;
const int HENCH_ATTACK_CHECK_NOT_UNDEAD								= 14;
const int HENCH_ATTACK_CHECK_IMMUNITY_PHANTASMS						= 15;
const int HENCH_ATTACK_CHECK_MAGIC_MISSLE							= 16;
const int HENCH_ATTACK_CHECK_INFERNO_OR_COMBUST						= 17;
const int HENCH_ATTACK_CHECK_DISMISSAL_OR_BANISHMENT				= 18;
const int HENCH_ATTACK_CHECK_SPELLCASTER							= 19;
const int HENCH_ATTACK_CHECK_NOT_ELF								= 20;
const int HENCH_ATTACK_CHECK_CONSTRUCT								= 21;
const int HENCH_ATTACK_CHECK_SEARING_LIGHT							= 22;
const int HENCH_ATTACK_CHECK_MINDBLAST								= 23;
const int HENCH_ATTACK_CHECK_EVARDS_TENTACLES						= 24;
const int HENCH_ATTACK_CHECK_IRONHORN								= 25;
const int HENCH_ATTACK_CHECK_PRISM									= 26;
const int HENCH_ATTACK_CHECK_SPIRIT									= 27;
const int HENCH_ATTACK_CHECK_WORDOFFAITH							= 28;
const int HENCH_ATTACK_CHECK_CLOUDKILL								= 29;
const int HENCH_ATTACK_CHECK_HUMANOID_OR_ANIMAL						= 30;
const int HENCH_ATTACK_CHECK_DAZE									= 31;
const int HENCH_ATTACK_CHECK_TASHAS									= 32;
const int HENCH_ATTACK_CHECK_CAUSE_FEAR								= 33;
const int HENCH_ATTACK_CHECK_PERCENTAGE								= 34;
const int HENCH_ATTACK_CHECK_CREEPING_DOOM							= 35;
const int HENCH_ATTACK_CHECK_DEATH_KNELL							= 36;
const int HENCH_ATTACK_CHECK_WARLOCK								= 37;
const int HENCH_ATTACK_CHECK_MOONBOLT								= 38;
const int HENCH_ATTACK_CHECK_SWAMPLUNG								= 39;
const int HENCH_ATTACK_CHECK_SEEN									= 40;
const int HENCH_ATTACK_CHECK_COLOR_SPRAY							= 41;
const int HENCH_ATTACK_CHECK_SUNBEAM                                = 42;
const int HENCH_ATTACK_CHECK_SUNBURST                               = 43;
const int HENCH_ATTACK_CHECK_MEDIUM									= 44;
const int HENCH_ATTACK_CHECK_CASTIGATE								= 45;
const int HENCH_ATTACK_CHECK_FIGHTER								= 46;
const int HENCH_ATTACK_CHECK_NOT_DEAF								= 47;
        
const int HENCH_ATTACK_TARGET_START									= 0;
const int HENCH_ATTACK_TARGET_ALLIES								= 1;
const int HENCH_ATTACK_TARGET_ENEMIES								= 2;
const int HENCH_ATTACK_TARGET_SELF									= 3;
const int HENCH_ATTACK_TARGET_DONE									= 4;


int giCurNumMaxAreaTest;
int giCurNumMaxSingleTest;

int gbRangedTouchAttackInit;

const string HENCH_RANGED_TOUCH_SAVEINFO	= "HenchRangedTouchSave";
const int HENCH_RANGED_TOUCH_REGULAR		= 0x1;
const int HENCH_RANGED_TOUCH_PLUS_TWO		= 0x2;
const int HENCH_MELEE_TOUCH_REGULAR			= 0x4;
const int HENCH_MELEE_TOUCH_PLUS_TWO		= 0x8;
string gsRangeSaveStr;


const int HENCH_MAX_SINGLE_TARGET_CHECKS	=  30;
const int HENCH_MAX_AREA_TARGET_CHECKS		=  60;


float gfMinHealAmountArea;
float gfLastHealAmountArea;
float gfMinHealWeightArea;
float gfMinHealAmountSingle;
float gfLastHealAmountSingle;
float gfMinHealWeightSingle;
float gfMinHarmAmountArea;
float gfLastHarmAmountArea;
float gfMinHarmWeightArea;
float gfMinHarmAmountSingle;
float gfLastHarmAmountSingle;
float gfMinHarmWeightSingle;


void HenchSpellAttack(int saveType, int targetInformation)
{
	int spellShape = gsCurrentspInfo.shape;
    int checkType = saveType & HENCH_SPELL_SAVE_TYPE_CUSTOM_MASK;
    int bIsBeneficial = (checkType == HENCH_ATTACK_CHECK_HEAL) || (checkType == HENCH_ATTACK_CHECK_NEG_HEALING);

	if (!bIsBeneficial)
	{
		if (spellShape != HENCH_SHAPE_NONE)
		{
			if (giCurNumMaxAreaTest > HENCH_MAX_AREA_TARGET_CHECKS)
			{		
//				Jug_Debug(GetName(OBJECT_SELF) + " over area limit with " + IntToString(spellID) + " " + Get2DAString("spells", "Label", spellID) + " other "  + IntToString(gsCurrentspInfo.otherID));
				return;
			}
		}
		else
		{
			if (giCurNumMaxSingleTest > HENCH_MAX_SINGLE_TARGET_CHECKS)
			{		
//				Jug_Debug(GetName(OBJECT_SELF) + " over single limit with " + IntToString(spellID) + " " + Get2DAString("spells", "Label", spellID) + " other "  + IntToString(gsCurrentspInfo.otherID));
				return;
			}
		}
	}

	int spellID = gsCurrentspInfo.spellID;
	float spellRange = gsCurrentspInfo.range;
	float spellRadius = gsCurrentspInfo.radius;

	if (targetInformation & HENCH_SPELL_TARGET_PERSISTENT_SPELL)
	{	
//		Jug_Debug(GetName(OBJECT_SELF) + " HenchSpellAttack persistent " + Get2DAString("spells", "Label", spellID) + " " + IntToString(spellID) + " level " + IntToString(gsCurrentspInfo.spellLevel));
		if (spellRange < 0.1)
		{
			if (GetHasSpellEffect(spellID))
			{
				// don't keep repeating some attack spells
				return;
			}
		}
		else
		{
			// if the spell is a one cast check early exit
			object oPersist = GetNearestObjectByTag(ObjectToString(OBJECT_SELF) + IntToString(spellID)); 
			if (GetIsObjectValid(oPersist))
			{
				if (GetDistanceBetween(GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oPersist, 1), oPersist) <= spellRadius)
				{
//					Jug_Debug(GetName(OBJECT_SELF) + " spell already cast");
					return;
				}
				spellRange = GetDistanceToObject(oPersist) - spellRadius - 1.5;
				if (spellRange < 0.0)
				{
//					Jug_Debug(GetName(OBJECT_SELF) + " target too close");
					return;
				}			
			}
		}		
	}
	
	float effectWeight = GetCurrentSpellEffectWeight(); 
	struct sDamageInformation spellDamage;
	int bFoundItemSpell = gsCurrentspInfo.spellInfo & HENCH_SPELL_INFO_ITEM_FLAG;
	int spellLevel = gsCurrentspInfo.spellLevel;
    int nCasterLevel =  bFoundItemSpell ? (spellLevel * 2) - 1 : nMySpellCasterLevel;
		
	if (targetInformation & HENCH_SPELL_TARGET_SCALE_EFFECT)
	{
//		Jug_Debug(GetName(OBJECT_SELF) + " orig effect weight " + FloatToString(effectWeight));
		effectWeight *= GetCurrentSpellBuffAmount(nCasterLevel); 	
//		Jug_Debug(GetName(OBJECT_SELF) + " mod effect weight " + FloatToString(effectWeight));			
		if (spellID == SPELLABILITY_EPIC_CURSE_SONG)
		{
			int bardLevel = GetLevelByClass(CLASS_TYPE_BARD);
			if (bardLevel >= 8)
			{
				int nPerformCheck = GetSkillRank(SKILL_PERFORM) / 5 + 10;
				if (nPerformCheck < bardLevel)
				{
					bardLevel = nPerformCheck;
				} 
				if (bardLevel >= 16)
				{
					spellDamage.amount = bardLevel * 2.0 - 12.0;
				}
				else if (bardLevel >= 14)
				{
					spellDamage.amount = 16.0;
				}
				else
				{
					spellDamage.amount = 8.0;
				}				
				spellDamage.damageTypeMask = DAMAGE_TYPE_SONIC;
				spellDamage.count = 1;
				spellDamage.damageType1 = DAMAGE_TYPE_SONIC;
				spellDamage.numberOfDamageTypes = 1;
			}	
		}
	}	
	else
	{	
		spellDamage = GetCurrentSpellDamage(nCasterLevel, bFoundItemSpell);
	}
	
	if (bIsBeneficial)
	{
		float spellDamageAmount = spellDamage.amount;
		if (spellShape != HENCH_SHAPE_NONE)
		{
			if (checkType == HENCH_ATTACK_CHECK_HEAL)
			{
				if (spellDamageAmount < gfMinHealAmountArea)
				{
//					Jug_Debug(GetName(OBJECT_SELF) + " don't consider " + Get2DAString("spells", "Label", spellID) + " amount " + FloatToString(spellDamage.amount) + " test amount " + FloatToString(gfMinHealAmountArea));
					return;
				}
			}
			else
			{
				if (spellDamageAmount < gfMinHarmAmountArea)
				{
//					Jug_Debug(GetName(OBJECT_SELF) + " don't consider " + Get2DAString("spells", "Label", spellID) + " amount " + FloatToString(spellDamage.amount) + " test amount " + FloatToString(gfMinHarmAmountArea));
					return;
				}			
			}
		}
		else if (spellRange > 0.0)
		{
			if (checkType == HENCH_ATTACK_CHECK_HEAL)
			{
				if (spellDamageAmount < gfMinHealAmountSingle)
				{
//					Jug_Debug(GetName(OBJECT_SELF) + " don't consider " + Get2DAString("spells", "Label", spellID) + " amount " + FloatToString(spellDamage.amount) + " test amount " + FloatToString(gfMinHealAmountSingle));
					return;
				}
			}
			else
			{
				if (spellDamageAmount < gfMinHarmAmountSingle)
				{
//					Jug_Debug(GetName(OBJECT_SELF) + " don't consider " + Get2DAString("spells", "Label", spellID) + " amount " + FloatToString(spellDamage.amount) + " test amount " + FloatToString(gfMinHarmAmountSingle));
					return;
				}
			}
		}
	}	
	
	int nTargetType = HENCH_ATTACK_TARGET_START;	
    string sTargetList;		
    float testRange;		
		
//	Jug_Debug(GetName(OBJECT_SELF) + " HenchSpellAttack " + Get2DAString("spells", "Label", spellID) + " " + IntToString(spellID) + " level " + IntToString(gsCurrentspInfo.spellLevel) + " save type " + IntToHexString(saveType) + " is item " + IntToString(bFoundItemSpell));
//	SpawnScriptDebugger();	
	
	int immunity1 = (saveType & HENCH_SPELL_SAVE_TYPE_IMMUNITY1_MASK) >> 6;
	int immunity2 = (saveType & HENCH_SPELL_SAVE_TYPE_IMMUNITY2_MASK) >> 12;
	int immunityMind = saveType & HENCH_SPELL_SAVE_TYPE_MIND_SPELL_FLAG;
	
	int effectTypes = GetCurrentSpellEffectTypes();
		
    int bCheckSR = saveType & HENCH_SPELL_SAVE_TYPE_SR_FLAG;
	int iCheckTouch = saveType &
		(HENCH_SPELL_SAVE_TYPE_TOUCH_MELEE_FLAG | HENCH_SPELL_SAVE_TYPE_TOUCH_RANGE_FLAG);
	int nTouchCheck;
	if (iCheckTouch)
	{
		if (!gbRangedTouchAttackInit)
		{	
	        location selfLoc = GetLocation(OBJECT_SELF);
	        object oTestTarget = GetFirstObjectInShape(SHAPE_SPHERE, 53.0, selfLoc, FALSE, OBJECT_TYPE_CREATURE);
	        while (GetIsObjectValid(oTestTarget))
	        {
	       			// reset flag on nearby creatures
	            DeleteLocalInt(oTestTarget, HENCH_RANGED_TOUCH_SAVEINFO);
	            oTestTarget = GetNextObjectInShape(SHAPE_SPHERE, 53.0, selfLoc, FALSE, OBJECT_TYPE_CREATURE);
	        }
			gbRangedTouchAttackInit = TRUE;
		}
		if (saveType & HENCH_SPELL_SAVE_TYPE_TOUCH_MELEE_FLAG)
		{
			nTouchCheck = nMyMeleeTouchAttack;
			iCheckTouch = HENCH_MELEE_TOUCH_REGULAR;
		}
		else
		{
			nTouchCheck = nMyRangedTouchAttack;
			iCheckTouch = HENCH_RANGED_TOUCH_REGULAR;
		}
		if (gbWarlockMaster && (checkType == HENCH_ATTACK_CHECK_WARLOCK))
		{
			nTouchCheck += 2;
			iCheckTouch *= 2;
		}
		gsRangeSaveStr = HENCH_RANGED_TOUCH_SAVEINFO + IntToString(iCheckTouch);
	}
    int checkFriendly = bIsBeneficial || (saveType & HENCH_SPELL_SAVE_TYPE_CHECK_FRIENDLY_FLAG);

	int nSpellPentetration =  bFoundItemSpell ? nCasterLevel : nMySpellCasterSpellPenetration;
	
	int saveDC = GetCurrentSpellSaveDC(bFoundItemSpell, spellLevel);
		
    if (spellShape == HENCH_SHAPE_NONE || spellShape == SHAPE_SPHERE || spellShape == SHAPE_CUBE)
    {
        testRange = spellRange;
    }
    else
    {
        testRange = spellRadius;
    }
		
//	Jug_Debug(GetName(OBJECT_SELF) + " saveDC " + IntToString(saveDC) + " spell damage " + FloatToString(spellDamage.amount) + " effect weight " + FloatToString(effectWeight));
//	Jug_Debug(GetName(OBJECT_SELF) + " testRange " + FloatToString(testRange) + " spell shape " + IntToString(gsCurrentspInfo.shape) + " radius " + FloatToString(gsCurrentspInfo.radius));
//	Jug_Debug(GetName(OBJECT_SELF) + " test friendly " + IntToString(checkFriendly));

	// note (testRange < 1.0) - self target spells don't hurt you	
	int bNotSelf = (saveType & HENCH_SPELL_SAVE_TYPE_NOTSELF_FLAG) || ((testRange < 1.0) && !bIsBeneficial);

	int bAllowWeightSave;
	int totalTargetsTested;
	int totalTargetsLimit;
		
	int bDoLoop = targetInformation & HENCH_SPELL_TARGET_SHAPE_LOOP;
		
	int firstSaveType = saveType & HENCH_SPELL_SAVE_TYPE_SAVES1_SAVE_MASK;
	int firstSaveKind = saveType & HENCH_SPELL_SAVE_TYPE_SAVES1_KIND_MASK;
	int secondSaveType = saveType & HENCH_SPELL_SAVE_TYPE_SAVES2_SAVE_MASK;
	int secondSaveKind = saveType & HENCH_SPELL_SAVE_TYPE_SAVES2_KIND_MASK;
		
	if (bDoLoop)
	{
		if (!(targetInformation & HENCH_SPELL_TARGET_MISSILE_TARGETS))
		{
			totalTargetsLimit = 12;
			bAllowWeightSave = TRUE;
		
	        location selfLoc = GetLocation(OBJECT_SELF);
			float testRadius = spellRadius + spellRange;
	        object oTestTarget = GetFirstObjectInShape(SHAPE_SPHERE, testRadius, selfLoc, FALSE, OBJECT_TYPE_CREATURE);
	        while (GetIsObjectValid(oTestTarget))
	        {
	       			// reset flag on nearby creatures
	            SetLocalFloat(oTestTarget, sCreatureSaveResultStr, HENCH_CREATURE_SAVE_UNKNOWN);
	            oTestTarget = GetNextObjectInShape(SHAPE_SPHERE, testRadius, selfLoc, FALSE, OBJECT_TYPE_CREATURE);
	        }
		}
		// else only one target for missile (totalTargetsLimit is zero)
	}
	else
	{
		totalTargetsLimit = 6;	
	}
	
    int curLoopCount = 1;
	int iLoopLimit;
		
	object oFinalTarget;
	float fFinalTargetWeight;
	location lFinalLocation;
	int bUseFinalTargetObject;
			
	int bDisableCheckEnemies = gbDisableNonHealorCure ||
		(gbDisableNonUnlimitedOrHealOrCure && !(gsCurrentspInfo.spellInfo & HENCH_SPELL_INFO_UNLIMITED_FLAG));
		
	object oCurTarget;
    while (TRUE)
    {
		if (GetIsObjectValid(oCurTarget))
		{
			oCurTarget = GetLocalObject(oCurTarget, sTargetList);
		}	
	 	if (!GetIsObjectValid(oCurTarget) || (curLoopCount > iLoopLimit))
		{			
			curLoopCount = 1;
//			Jug_Debug("setting target " + IntToString(nTargetType));
			if (nTargetType == HENCH_ATTACK_TARGET_START)
			{		
			    if (testRange < 1.0)
			    {				
					if (gbDisableNonHealorCure && !bDoLoop && (ogOverrideTarget != OBJECT_SELF))
					{
						return;
					}				
//					Jug_Debug("target self ");
					totalTargetsLimit = 0;	// force only one test
					nTargetType = HENCH_ATTACK_TARGET_SELF;
            		oCurTarget = OBJECT_SELF;
			   	}
				else if (bIsBeneficial)
				{
//					Jug_Debug("target beneficial ");
					nTargetType = HENCH_ATTACK_TARGET_ALLIES;
					// set allies up, include self
					
            		sTargetList = henchAllyStr;
                    iLoopLimit = testRange == 0.0 ? 1 : (spellShape == HENCH_SHAPE_NONE ? 10 : 3);
            		
            		oCurTarget = OBJECT_SELF;
            		
            		if (bNotSelf)
            		{	
            			oCurTarget = GetLocalObject(oCurTarget, sTargetList);
						if (GetIsObjectValid(oCurTarget))
            			{
            				curLoopCount = 2;
            			}
            			else
            			{
//							Jug_Debug("target enemies ");
            				nTargetType = HENCH_ATTACK_TARGET_ENEMIES;								
            			}					
            		}
				}
			    else
			    {
//					Jug_Debug("target enemies ");
					nTargetType = HENCH_ATTACK_TARGET_ENEMIES;					
				}
			}
			else if (nTargetType == HENCH_ATTACK_TARGET_ALLIES)
			{
//				Jug_Debug("target enemies 2 ");
				if (bDisableCheckEnemies)
				{				
					break;
				}

				nTargetType = HENCH_ATTACK_TARGET_ENEMIES;
								
				if (spellShape != HENCH_SHAPE_NONE)
				{
					if (giCurNumMaxAreaTest > HENCH_MAX_AREA_TARGET_CHECKS)
					{
//						Jug_Debug(GetName(OBJECT_SELF) + " over area limit with " + IntToString(spellID) + " " + Get2DAString("spells", "Label", spellID) + " other "  + IntToString(gsCurrentspInfo.otherID));
                        if (bIsBeneficial)
                        {
                            // allow final check for beneficial spells
                            break;
                        }
						return;
					}
				}
				else
				{
					if (giCurNumMaxSingleTest > HENCH_MAX_SINGLE_TARGET_CHECKS)
					{		
//						Jug_Debug(GetName(OBJECT_SELF) + " over single limit with " + IntToString(spellID) + " " + Get2DAString("spells", "Label", spellID) + " other "  + IntToString(gsCurrentspInfo.otherID));
                        if (bIsBeneficial)
                        {
                            // allow final check for beneficial spells
                            break;
                        }
						return;
					}
				}				
			}
			else
			{
//				Jug_Debug("target done ");
				break;
			}
			if (nTargetType == HENCH_ATTACK_TARGET_ENEMIES)
			{
				iLoopLimit = 20;
				if (targetInformation & HENCH_SPELL_TARGET_VIS_REQUIRED_FLAG)
		        {
//					Jug_Debug("setting seen targets");
		            sTargetList = sObjectSeen;
		        }
		        else
		        {
//					Jug_Debug("setting line of sight targets");
		            sTargetList = sLineOfSight;
		        }					
				oCurTarget = GetLocalObject(OBJECT_SELF, sTargetList);
				if (!GetIsObjectValid(oCurTarget))
				{
					break;
				}
			}
//			Jug_Debug("do target loop " + IntToString(nTargetType) + " list " + sTargetList + " limit " + IntToString(iLoopLimit));
		}
        curLoopCount++;	
		
//		Jug_Debug(GetName(OBJECT_SELF) + " checking target "  + GetName(oCurTarget) + " spell " + Get2DAString("spells", "Label", spellID) + " " + IntToString(spellID) + " level " + IntToString(gsCurrentspInfo.spellLevel) + " is item " + IntToString(bFoundItemSpell));

        if (nTargetType != HENCH_ATTACK_TARGET_ALLIES && GetDistanceToObject(oCurTarget) > testRange)
        {
            continue;
        }
		
        location testTargetLoc;
        int bTargetFound = !bgMeleeAttackers;
				
    	object oTestTarget;
		
		int nCountLimit;
		float fAccumChance;
		
		if (bDoLoop)
		{
			testTargetLoc = GetLocation(oCurTarget);
			if (targetInformation & HENCH_SPELL_TARGET_SECONDARY_TARGETS)
			{
				bAllowWeightSave = FALSE;
				oTestTarget = oCurTarget;
				if (gsCurrentspInfo.otherID == SPELL_I_ELDRITCH_CHAIN)
				{
					int nCasterLvl = GetLevelByClass(CLASS_TYPE_WARLOCK);
					if ( nCasterLvl >= 20 )
					{
						nCountLimit = 5;
					}
				    else
					{
						nCountLimit = nCasterLvl / 5 + 1;
					}
//					Jug_Debug(GetName(OBJECT_SELF) + " chain loop limit is " + IntToString(nCountLimit));
				}
				else
				{
					nCountLimit = 1000;
				}
			}
			else
			{
				if (targetInformation & HENCH_SPELL_TARGET_MISSILE_TARGETS)
				{
					if (spellID == SPELLABILITY_AA_HAIL_OF_ARROWS)
					{
						nCountLimit = GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER);
						spellDamage.count = 1;
					}
					else
					{
						nCountLimit = CountEnemies(testTargetLoc);
						if (nCountLimit == 0)
						{
							return;
						}
						if (nCountLimit > spellDamage.count)
						{
							nCountLimit = spellDamage.count;
						}
						if ((nCountLimit == 1) && (spellDamage.count > 10))
						{
							spellDamage.amount = (10 * spellDamage.amount) / spellDamage.count;			
							spellDamage.count = 10;
						}
						else
						{
							spellDamage.amount /= nCountLimit;
							spellDamage.count /= nCountLimit;
						}
					}					
//					Jug_Debug(GetName(OBJECT_SELF) + " do missile test count " + IntToString(nCountLimit) + " damage amount " + IntToString(spellDamage.amount) + " count " + IntToString(spellDamage.count));
				}
				// Declare the spell shape, size and the location.  Capture the first target object in the shape.
		        // note: GetPosition is needed for SHAPE_SPELLCYLINDER
		       	oTestTarget = GetFirstObjectInShape(spellShape, spellRadius, testTargetLoc, TRUE, OBJECT_TYPE_CREATURE, GetPosition(OBJECT_SELF));
			}
		}
		else
		{
			oTestTarget = oCurTarget;
		}
 		float fTotalWeight;
		
//		Jug_Debug(GetName(OBJECT_SELF) + " spell damage amount " + IntToString(spellDamage.amount) + " count " + IntToString(spellDamage.count));
		int nShapeLoopCount;
		
       //Cycle through the targets within the spell shape until an invalid object is captured.
        while (GetIsObjectValid(oTestTarget))
        {
//			Jug_Debug(GetName(OBJECT_SELF) + " checking loop creature " + GetName(oTestTarget));
			totalTargetsTested ++;

			float curTargetWeight;
		    int bIsEnemy;
		    int bIsFriend;
		
			if (bAllowWeightSave)
            {
                curTargetWeight = GetLocalFloat(oTestTarget, sCreatureSaveResultStr);
            }
            else
            {
                curTargetWeight = HENCH_CREATURE_SAVE_UNKNOWN;
            }
			
			if (bDoLoop)
			{
				if (targetInformation & HENCH_SPELL_TARGET_CHECK_COUNT)
				{
					if ((targetInformation & HENCH_SPELL_TARGET_SECONDARY_TARGETS) && (nShapeLoopCount > 0))
					{
						if (oTestTarget != oCurTarget)
						{
							if (GetIsEnemy(oCurTarget) && !GetIsDead(oCurTarget))
							{
								--nCountLimit;
							}
						}
					}
					else if (targetInformation & HENCH_SPELL_TARGET_MISSILE_TARGETS)
					{
						if (GetIsEnemy(oCurTarget))
						{
							--nCountLimit;
						}
					}
					else
					{
						--nCountLimit;
					}					
					if (nCountLimit < 0)
					{
						// make sure no more checks
//						Jug_Debug(GetName(OBJECT_SELF) + " reached count limit");
						break;
					}
				}
				if ((curTargetWeight == HENCH_CREATURE_SAVE_UNKNOWN) && ((oCurTarget != oTestTarget) || (oCurTarget == OBJECT_SELF)))
	            {		
					if (GetIsDead(oTestTarget) || (oTestTarget == OBJECT_SELF && bNotSelf) ||
						(!GetObjectSeen(oTestTarget) && !GetObjectHeard(oTestTarget) && oTestTarget != OBJECT_SELF))
					{
//						Jug_Debug(GetName(OBJECT_SELF) + " ignore 1 not self" + IntToString(bNotSelf));
						curTargetWeight = 0.0;
	                    SetLocalFloat(oTestTarget, sCreatureSaveResultStr, curTargetWeight);
					}
					else
					{
		                bIsEnemy = GetIsEnemy(oTestTarget);
		                bIsFriend = GetFactionEqual(oTestTarget) || GetIsFriend(oTestTarget);
//						Jug_Debug(GetName(OBJECT_SELF) + " friend " + GetName(oTestTarget) + " fr " + IntToString(bIsFriend));
		                if ((bIsFriend && !checkFriendly) || (!bIsFriend && !bIsEnemy))
		                {
//							Jug_Debug(GetName(OBJECT_SELF) + " ignore 2");
		                    curTargetWeight = 0.0;
		                    SetLocalFloat(oTestTarget, sCreatureSaveResultStr, curTargetWeight);
		                }
	                    else if (bIsFriend && checkFriendly)
	                    {
	                        if (GetAssociateType(oTestTarget) == ASSOCIATE_TYPE_DOMINATED)
	                        {
								if (!bIsBeneficial || (checkType == HENCH_ATTACK_CHECK_HEAL ?
									GetRacialType(oTestTarget) == RACIAL_TYPE_UNDEAD :
							 		GetRacialType(oTestTarget) != RACIAL_TYPE_UNDEAD))
								{
		                            // a hostile spell on a dominated creature breaks the domination                        
			                        curTargetWeight = -1.5 * GetThreatRating(oTestTarget);
			                        SetLocalFloat(oTestTarget, sCreatureSaveResultStr, curTargetWeight);
								}
	                        }
	                    }
					}
	            }
			}
							
            if (curTargetWeight == HENCH_CREATURE_SAVE_UNKNOWN)
            {
				int nTempResult;
  				float fCurChance = 1.0; //  TODO this causes higher level spells to be used when lower
					// level ones will work just as well 0.95 + IntToFloat(Random(11)) / 100.0;				
				int currentSaveDC = saveDC;		// some checks adjust saves
				float currentDamageAmount = spellDamage.amount;
				float currentEffectWeight = effectWeight;
             	int currentFirstSaveType = firstSaveType;
                int currentFirstSaveKind = firstSaveKind;
				int currentEffectTypes = effectTypes;
				int currentCheckSaves = TRUE;
				
				int currentCreatureNegativeEffects = GetCreatureNegEffects(oTestTarget);
				if (bIsEnemy && (currentCreatureNegativeEffects & HENCH_EFFECT_DISABLED))
				{
					currentEffectWeight = 0.0;			
				}
				
				if (targetInformation & HENCH_SPELL_TARGET_SECONDARY_TARGETS)
				{
					if (!nShapeLoopCount)
					{
						if (iCheckTouch && (currentFirstSaveType == HENCH_SPELL_SAVE_TYPE_SAVE1_REFLEX))
						{
							// remove reflex saves
//							Jug_Debug(GetName(OBJECT_SELF) + " removing reflex saves for " + GetName(oTestTarget));				
							currentFirstSaveType = 0;
						}
					}
					else
					{
						// secondary targets 1/2 damage
						if (targetInformation & HENCH_SPELL_TARGET_SECONDARY_HALF_DAM)
						{				
							currentDamageAmount /= 2.0;
						}
					}					
				}
				
//				Jug_Debug(GetName(OBJECT_SELF) + " check type " + IntToString(checkType));				
				switch (checkType)
                {
                case HENCH_ATTACK_NO_CHECK:
                    break;
                case HENCH_ATTACK_CHECK_HEAL:
					if (GetLocalInt(oTestTarget, VAR_IMMUNE_TO_HEAL))
					{
						nTempResult = TRUE;
					}
					else
					{
						bIsFriend = GetFactionEqual(oTestTarget) || GetIsFriend(oTestTarget);
						if (GetRacialType(oTestTarget) != RACIAL_TYPE_UNDEAD)
						{
							if (bIsFriend)
							{
								currentCheckSaves = FALSE;	// indicates that this is beneficial
							}
							else
							{
								nTempResult = TRUE;
							}
						}
						else if (!bIsFriend)
						{
							nTempResult = bDisableCheckEnemies;
						}
					}
					break;
                case HENCH_ATTACK_CHECK_NEG_HEALING:
					if (GetLocalInt(oTestTarget, VAR_IMMUNE_TO_HEAL))
					{
						nTempResult = TRUE;
					}
					else
					{
						bIsFriend = GetFactionEqual(oTestTarget) || GetIsFriend(oTestTarget);
						if (GetRacialType(oTestTarget) == RACIAL_TYPE_UNDEAD)
						{
							if (bIsFriend)
							{
								currentCheckSaves = FALSE;	// indicates that this is beneficial
							}
							else
							{
								nTempResult = TRUE;
							}
						}
						else if (!bIsFriend)
						{
							nTempResult = bDisableCheckEnemies;
						}
					}
					break;
                case HENCH_ATTACK_CHECK_HUMANOID:
                    nTempResult = !GetIsHumanoid(GetRacialType(oTestTarget));
                    break;
                case HENCH_ATTACK_CHECK_NOT_ALREADY_EFFECTED:
                    nTempResult = GetHasSpellEffect(spellID, oTestTarget);
                    break;
                case HENCH_ATTACK_CHECK_INCORPOREAL:
                    nTempResult = GetCreatureFlag(oTestTarget, CREATURE_VAR_IS_INCORPOREAL);
                    break;
/*                case HENCH_ATTACK_CHECK_DARKNESS:
                    nTempResult = oTestTarget == OBJECT_SELF ||
						 (GetCreaturePosEffects(oTestTarget) & (HENCH_EFFECT_TYPE_ULTRAVISION  | HENCH_EFFECT_TYPE_TRUESEEING)) ||
                        //  GetHasFeat(FEAT_BLINDSIGHT_60_FEET, oTestTarget) ||
                        GetHasFeat(FEAT_BLIND_FIGHT, oTestTarget) ||
                        (bIsFriend && (GetHasSpell(SPELL_TRUE_SEEING, oTestTarget) ||
                        GetHasSpell(SPELL_BLINDSIGHT, oTestTarget) ||
						GetHasSpell(SPELL_I_DEVILS_SIGHT, oTestTarget)));
                    break; */
                case HENCH_ATTACK_CHECK_PETRIFY:
                    nTempResult = spellsIsImmuneToPetrification(oTestTarget);
                    break;
                case HENCH_ATTACK_CHECK_ANIMAL:
                    nTempResult = GetRacialType(oTestTarget) != RACIAL_TYPE_ANIMAL &&
                        GetRacialType(oTestTarget) != RACIAL_TYPE_BEAST;
                    break;
                case HENCH_ATTACK_CHECK_NOT_CONSTRUCT_OR_UNDEAD:
                    nTempResult = GetRacialType(oTestTarget) == RACIAL_TYPE_CONSTRUCT ||
                        GetRacialType(oTestTarget) == RACIAL_TYPE_UNDEAD;
                    break;
                case HENCH_ATTACK_CHECK_DROWN:
                    nTempResult = GetRacialType(oTestTarget) == RACIAL_TYPE_CONSTRUCT ||
                        GetRacialType(oTestTarget) == RACIAL_TYPE_UNDEAD ||
                        GetRacialType(oTestTarget) == RACIAL_TYPE_ELEMENTAL;
					if (!nTempResult)
					{
						if (spellID == SPELLABILITY_PULSE_DROWN)
						{
							if (GetAssociateType(OBJECT_SELF) != ASSOCIATE_TYPE_SUMMONED)
							{
								fTotalWeight -= GetRawThreatRating(OBJECT_SELF) / 2.0;							
							}
						}
						else
						{
							currentDamageAmount = 0.9 * IntToFloat(GetCurrentHitPoints(oTestTarget));
							currentDamageAmount = GetDamageResistImmunityAdjustment(oTestTarget, currentDamageAmount, DAMAGE_TYPE_BLUDGEONING, 1);					
							currentEffectWeight = CalculateDamageWeight(currentDamageAmount, oTestTarget);
							currentDamageAmount = 0.0;					
						}					
					}
                    break;
                case HENCH_ATTACK_CHECK_SLEEP:
                    nTempResult = GetRacialType(oTestTarget) == RACIAL_TYPE_CONSTRUCT ||
                        GetRacialType(oTestTarget) == RACIAL_TYPE_UNDEAD ||
                        GetHitDice(oTestTarget) > 5;
                    break;
                case HENCH_ATTACK_CHECK_BIGBY:
					if (spellID == SPELL_BIGBYS_INTERPOSING_HAND)
					{					
						nTempResult = GetHasSpellEffect(SPELL_BIGBYS_CLENCHED_FIST, oTestTarget) || GetHasSpellEffect(SPELL_BIGBYS_CRUSHING_HAND, oTestTarget) || GetHasSpellEffect(SPELL_BIGBYS_GRASPING_HAND, oTestTarget) || GetHasSpellEffect(SPELL_BIGBYS_FORCEFUL_HAND, oTestTarget) || GetHasSpellEffect(SPELL_BIGBYS_INTERPOSING_HAND, oTestTarget);						
					}
					else if (spellID == SPELL_BIGBYS_FORCEFUL_HAND)
					{					
						nTempResult = GetHasSpellEffect(SPELL_BIGBYS_CLENCHED_FIST, oTestTarget) || GetHasSpellEffect(SPELL_BIGBYS_CRUSHING_HAND, oTestTarget) || GetHasSpellEffect(SPELL_BIGBYS_GRASPING_HAND, oTestTarget) || GetHasSpellEffect(SPELL_BIGBYS_FORCEFUL_HAND, oTestTarget);						
						if (!nTempResult)
						{				 
							fCurChance *= CheckGrappleResult(oTestTarget, 14, GRAPPLE_CHECK_RUSH);
						}					
					}
					else if (spellID == SPELL_BIGBYS_GRASPING_HAND)
					{					
						nTempResult = GetHasSpellEffect(SPELL_BIGBYS_CLENCHED_FIST, oTestTarget) || GetHasSpellEffect(SPELL_BIGBYS_CRUSHING_HAND, oTestTarget) || GetHasSpellEffect(SPELL_BIGBYS_GRASPING_HAND, oTestTarget);						
						if (!nTempResult)
						{				 
							fCurChance *= CheckGrappleResult(oTestTarget, nCasterLevel + GetCasterAbilityModifier(OBJECT_SELF) + 10, GRAPPLE_CHECK_HIT | GRAPPLE_CHECK_HOLD);
						}					
					}
					else if (spellID == SPELL_BIGBYS_CLENCHED_FIST)
					{					
						nTempResult = GetHasSpellEffect(SPELL_BIGBYS_CLENCHED_FIST, oTestTarget) || GetHasSpellEffect(SPELL_BIGBYS_CRUSHING_HAND, oTestTarget) || GetHasSpellEffect(SPELL_BIGBYS_GRASPING_HAND, oTestTarget);						
						if (!nTempResult)
						{				 
							fCurChance *= CheckGrappleResult(oTestTarget, nCasterLevel + GetCasterAbilityModifier(OBJECT_SELF) + 11, GRAPPLE_CHECK_HIT);
						}					
					}
					else /* if (spellID == SPELL_BIGBYS_CRUSHING_HAND) */
					{					
						nTempResult = GetHasSpellEffect(SPELL_BIGBYS_CRUSHING_HAND, oTestTarget) || GetHasSpellEffect(SPELL_BIGBYS_GRASPING_HAND, oTestTarget);						
						if (!nTempResult)
						{				 
							fCurChance *= CheckGrappleResult(oTestTarget, nCasterLevel + GetCasterAbilityModifier(OBJECT_SELF) + 12, GRAPPLE_CHECK_HIT | GRAPPLE_CHECK_HOLD);
						}					
					}
                    break;
                case HENCH_ATTACK_CHECK_UNDEAD:
                    nTempResult = GetRacialType(oTestTarget) != RACIAL_TYPE_UNDEAD;
                    break;
                case HENCH_ATTACK_CHECK_NOT_UNDEAD:
                    nTempResult = GetRacialType(oTestTarget) == RACIAL_TYPE_UNDEAD;
                    break;
                case HENCH_ATTACK_CHECK_IMMUNITY_PHANTASMS:
                    nTempResult = GetHasFeat(FEAT_IMMUNITY_PHANTASMS, oTestTarget);
                    break;
                case HENCH_ATTACK_CHECK_MAGIC_MISSLE:
                    nTempResult = GetHasSpellEffect(SPELL_SHIELD, oTestTarget) ||
						GetHasSpellEffect(SPELL_SHADES_TARGET_CASTER, oTestTarget);
                    break;
                case HENCH_ATTACK_CHECK_INFERNO_OR_COMBUST:
                    nTempResult = GetHasSpellEffect(SPELL_INFERNO, oTestTarget) ||
						GetHasSpellEffect(SPELL_COMBUST, oTestTarget);
                    break;
                case HENCH_ATTACK_CHECK_DISMISSAL_OR_BANISHMENT:
					{
						int bBanish = spellID == SPELL_BANISHMENT;

						int nAssocType = GetAssociateType(oTestTarget);
						int nRacial = GetRacialType(oTestTarget);
						nTempResult = !(nAssocType == ASSOCIATE_TYPE_SUMMONED ||
							nAssocType == ASSOCIATE_TYPE_FAMILIAR ||
							nAssocType == ASSOCIATE_TYPE_ANIMALCOMPANION ||
							nRacial == RACIAL_TYPE_OUTSIDER ||
							(!bBanish && (nRacial == RACIAL_TYPE_ELEMENTAL))) /*||
							GetLocalInt(oTestTarget, sHenchPseudoSummon))*/;
						if (!nTempResult && !bBanish)
						{
							currentSaveDC += nCasterLevel - GetHitDice(oTestTarget);
						}	
					}				
                    break;
                case HENCH_ATTACK_CHECK_SPELLCASTER:
                    nTempResult =
                        GetLevelByClass(CLASS_TYPE_WIZARD, oTestTarget) <= 0 &&
                        GetLevelByClass(CLASS_TYPE_SORCERER, oTestTarget) <= 0 &&
                        GetLevelByClass(CLASS_TYPE_BARD, oTestTarget) <= 0 &&
                        GetLevelByClass(CLASS_TYPE_CLERIC, oTestTarget) <= 0 &&
                        GetLevelByClass(CLASS_TYPE_DRUID, oTestTarget) <= 0 &&
                        GetLevelByClass(CLASS_TYPE_FAVORED_SOUL, oTestTarget) <= 0 &&
                        GetLevelByClass(CLASS_TYPE_SPIRIT_SHAMAN, oTestTarget) <= 0 &&
                        GetLevelByClass(CLASS_TYPE_WARLOCK, oTestTarget) <= 0;
                    break;
                case HENCH_ATTACK_CHECK_NOT_ELF:
                    nTempResult = GetRacialType(oTestTarget) == RACIAL_TYPE_ELF;
                    break;
                case HENCH_ATTACK_CHECK_CONSTRUCT:
                    nTempResult = GetRacialType(oTestTarget) != RACIAL_TYPE_CONSTRUCT;
                    break;
                case HENCH_ATTACK_CHECK_SEARING_LIGHT:			
					if (GetRacialType(oTestTarget) == RACIAL_TYPE_UNDEAD)
		            {
						currentDamageAmount = nCasterLevel > 10 ? 35.0 : 3.5 * nCasterLevel;
		            }
		            else if (GetRacialType(oTestTarget) == RACIAL_TYPE_CONSTRUCT)
		            {
						currentDamageAmount = nCasterLevel > 10 ? 17.5 : 1.75 * nCasterLevel;
		            }
                    break;
                case HENCH_ATTACK_CHECK_MINDBLAST:
                    {
	                    int nApp = GetAppearanceType(oTestTarget);
        				nTempResult = nApp == 413 || nApp== 414 || nApp == 415;
                    }
                    break;
                case HENCH_ATTACK_CHECK_EVARDS_TENTACLES:
					if (spellID == SPELL_I_CHILLING_TENTACLES)
					{
						currentDamageAmount += GetDamageResistImmunityAdjustment(oTestTarget, 7.0, DAMAGE_TYPE_COLD, 1);
					}
					fCurChance *= CheckGrappleResult(oTestTarget, 6, GRAPPLE_CHECK_HIT);
                    break;
                case HENCH_ATTACK_CHECK_IRONHORN:
					fCurChance *= CheckGrappleResult(oTestTarget, 20, GRAPPLE_CHECK_STR);
                    break;
                case HENCH_ATTACK_CHECK_PRISM:
                    {
                        int test = Random(8);
						if  (test == 0)
						{
							// fire
		           			currentDamageAmount = GetDamageResistImmunityAdjustment(oTestTarget, 20.0, DAMAGE_TYPE_FIRE, 1);
						}
						else if (test == 1)
						{
							// acid						
		           			currentDamageAmount = GetDamageResistImmunityAdjustment(oTestTarget, 40.0, DAMAGE_TYPE_ACID, 1);
						}
						else if (test == 2)
						{
							// electricity						
		           			currentDamageAmount = GetDamageResistImmunityAdjustment(oTestTarget, 80.0, DAMAGE_TYPE_ELECTRICAL, 1);
						}
                        else if (test == 3)
                        {
                            // poison
                            nTempResult = GetIsImmune(oTestTarget, IMMUNITY_TYPE_POISON, OBJECT_SELF);
							if (!nTempResult)
							{
								currentEffectWeight = 0.1;
								currentFirstSaveType = HENCH_SPELL_SAVE_TYPE_SAVE1_FORT;
								currentFirstSaveKind = HENCH_SPELL_SAVE_TYPE_SAVE1_EFFECT_ONLY;
							}
                        }
                        else if (test == 4)
                        {
                            // paralyze
                            nTempResult = GetIsImmune(oTestTarget, IMMUNITY_TYPE_MIND_SPELLS, OBJECT_SELF) ||
                                GetIsImmune(oTestTarget, IMMUNITY_TYPE_PARALYSIS, OBJECT_SELF);
							if (!nTempResult)
							{
								currentEffectWeight = 0.95;
								currentFirstSaveType = HENCH_SPELL_SAVE_TYPE_SAVE1_FORT;
								currentFirstSaveKind = HENCH_SPELL_SAVE_TYPE_SAVE1_EFFECT_ONLY;
							}
                        }
                        else if (test == 5)
                        {
                            // confusion
                            nTempResult = GetIsImmune(oTestTarget, IMMUNITY_TYPE_MIND_SPELLS, OBJECT_SELF) ||
                                GetIsImmune(oTestTarget, IMMUNITY_TYPE_CONFUSED, OBJECT_SELF);
							if (!nTempResult)
							{
								currentEffectWeight = 0.80;
								currentFirstSaveType = 0;
								currentFirstSaveKind = HENCH_SPELL_SAVE_TYPE_SAVE1_EFFECT_ONLY;
							}
                        }
                        else if (test == 6)
                        {
                            // death
                            nTempResult = GetIsImmune(oTestTarget, IMMUNITY_TYPE_DEATH, OBJECT_SELF);
							if (!nTempResult)
							{
								currentEffectWeight = 1.00;
								currentFirstSaveType = HENCH_SPELL_SAVE_TYPE_SAVE1_WILL;
								currentFirstSaveKind = HENCH_SPELL_SAVE_TYPE_SAVE1_EFFECT_ONLY;
							}
                        }
                        else
                        {
                            // flesh to stone
							nTempResult = spellsIsImmuneToPetrification(oTestTarget);
							if (!nTempResult)
							{
	 							currentEffectWeight = 1.00;
								currentFirstSaveType = HENCH_SPELL_SAVE_TYPE_SAVE1_FORT;
								currentFirstSaveKind = HENCH_SPELL_SAVE_TYPE_SAVE1_EFFECT_ONLY;
							}
                        }
                   }
				   break;
                case HENCH_ATTACK_CHECK_SPIRIT:
                    nTempResult = !GetIsSpirit(oTestTarget);
                    break;
                case HENCH_ATTACK_CHECK_WORDOFFAITH:
					if (GetAssociateType(oTestTarget) == ASSOCIATE_TYPE_SUMMONED)
					{					
						currentEffectWeight = 1.00;
						nTempResult = GetIsImmune(oTestTarget, IMMUNITY_TYPE_DEATH, OBJECT_SELF);
						currentEffectTypes = 0;
					}
					else
					{
						int hitDice = GetHitDice(oTestTarget);
						if (hitDice <= 4)
						{
							currentEffectWeight = 1.00;
							nTempResult = GetIsImmune(oTestTarget, IMMUNITY_TYPE_DEATH, OBJECT_SELF);
							currentEffectTypes = 0;
						}
						else if (hitDice < 8)
						{
							currentEffectWeight = 0.95;
							nTempResult = GetIsImmune(oTestTarget, IMMUNITY_TYPE_MIND_SPELLS, OBJECT_SELF) ||
								(GetIsImmune(oTestTarget, IMMUNITY_TYPE_STUN, OBJECT_SELF) && 
								GetIsImmune(oTestTarget, IMMUNITY_TYPE_CONFUSED, OBJECT_SELF));
							currentEffectTypes = HENCH_EFFECT_TYPE_CONFUSED | HENCH_EFFECT_TYPE_STUNNED;
						}
						else if (hitDice < 12)
						{
							currentEffectWeight = 0.75;
							nTempResult = GetIsImmune(oTestTarget, IMMUNITY_TYPE_MIND_SPELLS, OBJECT_SELF) ||
								GetIsImmune(oTestTarget, IMMUNITY_TYPE_STUN, OBJECT_SELF);
							currentEffectTypes = HENCH_EFFECT_TYPE_STUNNED;
						}
						else
						{
							// default is the blind effect
							nTempResult = GetIsImmune(oTestTarget, IMMUNITY_TYPE_BLINDNESS, OBJECT_SELF);
						}
					}
                    break;
                case HENCH_ATTACK_CHECK_CLOUDKILL:				
					{
						int hitDice = GetHitDice(oTestTarget);
						if (hitDice <= 3)
						{
							currentEffectWeight = 1.00;
							nTempResult = GetIsImmune(oTestTarget, IMMUNITY_TYPE_DEATH, OBJECT_SELF);
							currentEffectTypes = 0;
							currentFirstSaveType = 0;
						}
						else if (hitDice <= 6)
						{
							currentEffectWeight = 1.0;
							nTempResult = GetIsImmune(oTestTarget, IMMUNITY_TYPE_DEATH, OBJECT_SELF);
							currentEffectTypes = 0;
						}
						// default is the ability damage
					}				
                    break;
                case HENCH_ATTACK_CHECK_HUMANOID_OR_ANIMAL:
					{
						int nRacialType = GetRacialType(oTestTarget);
				    	nTempResult = !(GetIsHumanoid(nRacialType) || (nRacialType == RACIAL_TYPE_ANIMAL));
					}
                    break;
                case HENCH_ATTACK_CHECK_DAZE:
					nTempResult = (GetHitDice(oTestTarget) > 5) || !GetIsHumanoid(GetRacialType(oTestTarget));
                    break;
                case HENCH_ATTACK_CHECK_TASHAS:
					nTempResult = GetHasSpellEffect(spellID, oTestTarget);
				    if (GetRacialType(oTestTarget) != GetRacialType(OBJECT_SELF))
					{
						currentSaveDC -= 4;
					}
                    break;
                case HENCH_ATTACK_CHECK_CAUSE_FEAR:
					nTempResult = GetHitDice(oTestTarget) > 5;
                    break;
                case HENCH_ATTACK_CHECK_PERCENTAGE:
                    currentDamageAmount = currentDamageAmount / 100.0 * IntToFloat(GetCurrentHitPoints(oTestTarget));
                    break;
				case HENCH_ATTACK_CHECK_CREEPING_DOOM:
					if (spellID == SPELL_I_TENACIOUS_PLAGUE)
					{
						fCurChance *= CheckGrappleResult(oTestTarget, 5 + 2 * GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF), GRAPPLE_CHECK_HIT);
					}
					else
					{
						fCurChance *= CheckGrappleResult(oTestTarget, 7 + 2 * GetAbilityModifier(ABILITY_WISDOM, OBJECT_SELF), GRAPPLE_CHECK_HIT);
					}			
					break;
				case HENCH_ATTACK_CHECK_DEATH_KNELL:
					nTempResult = GetCurrentHitPoints(oTestTarget) > 3;
					break;
				case HENCH_ATTACK_CHECK_WARLOCK:
					if (currentSaveDC < giWarlockMinSaveDC)
					{
						currentSaveDC = giWarlockMinSaveDC;
					}
					if (secondSaveKind == HENCH_SPELL_SAVE_TYPE_SAVE2_DAMAGE_EVASION && 
						(GetHasFeat(FEAT_EVASION, oTestTarget) || GetHasFeat(FEAT_IMPROVED_EVASION, oTestTarget)))
					{
							// if you get no damage with these spells, effect doesn't happen					
						currentEffectWeight *= Getd20ChanceLimited(currentSaveDC - GetReflexSavingThrow(oTestTarget));
					}
					// shapes don't stack
					if ((gsCurrentspInfo.otherID) > 0 ? GetHasSpellEffect(gsCurrentspInfo.otherID, oTestTarget) :
						GetHasSpellEffect(spellID, oTestTarget))
					{
						currentEffectWeight = 0.0;
					}
						// fire, acid doesn't stack either
					else if (spellID == SPELL_I_VITRIOLIC_BLAST)
					{
//					Jug_Debug(GetName(OBJECT_SELF) + " extra for acid " + IntToString(gsCurrentspInfo.otherID) + " on " + GetName(oTestTarget));
						currentDamageAmount += GetDamageResistImmunityAdjustment(oTestTarget, 7.0, DAMAGE_TYPE_ACID, 1);					
					}
					else if (spellID == SPELL_I_BRIMSTONE_BLAST)
					{
//					Jug_Debug(GetName(OBJECT_SELF) + " extra for fire " + IntToString(gsCurrentspInfo.otherID) + " on " + GetName(oTestTarget));
						currentDamageAmount += GetDamageResistImmunityAdjustment(oTestTarget, 7.0, DAMAGE_TYPE_FIRE, 1);					
					}						
					else if ((spellID == SPELL_I_FRIGHTFUL_BLAST) && (GetHitDice(oTestTarget) > 5))
					{					
						currentEffectWeight = 0.0;
					}
					if (gsCurrentspInfo.otherID == SPELL_I_HIDEOUS_BLOW)
					{				
						currentDamageAmount += 5 + GetAbilityModifier(ABILITY_STRENGTH, OBJECT_SELF);					
					}				
					break;
				case HENCH_ATTACK_CHECK_MOONBOLT:
					{
						int nRacial = GetRacialType(oTestTarget);
						nTempResult = nRacial == RACIAL_TYPE_CONSTRUCT;
						if (!nTempResult)
						{
							if (nRacial == RACIAL_TYPE_UNDEAD)
							{				
								currentFirstSaveType = HENCH_SPELL_SAVE_TYPE_SAVE1_WILL;
								
								if (!GetIsImmune(oTestTarget, IMMUNITY_TYPE_MIND_SPELLS, OBJECT_SELF))
								{
									currentEffectWeight += 0.75;
								}
								else if (!GetIsImmune(oTestTarget, IMMUNITY_TYPE_ABILITY_DECREASE, OBJECT_SELF))
								{
									nTempResult = TRUE;
								}									
							}
							else
							{							
								nTempResult = GetIsImmune(oTestTarget, IMMUNITY_TYPE_ABILITY_DECREASE, OBJECT_SELF);
							}
						}
					}				
					break;
				case HENCH_ATTACK_CHECK_SWAMPLUNG:
					{
						int nRacial = GetRacialType(oTestTarget);				
						nTempResult = nRacial == RACIAL_TYPE_CONSTRUCT || nRacial == RACIAL_TYPE_ELEMENTAL ||
							nRacial == RACIAL_TYPE_VERMIN || nRacial == RACIAL_TYPE_OOZE || nRacial == RACIAL_TYPE_OUTSIDER ||
							nRacial == RACIAL_TYPE_UNDEAD;				
					}
					break;
				case HENCH_ATTACK_CHECK_SEEN:
//					Jug_Debug(GetName(OBJECT_SELF) + " checking " + GetName(oTestTarget) + " is seen " + IntToString(GetObjectSeen(oTestTarget)));
					nTempResult = !GetObjectSeen(oTestTarget);
					break;
				case HENCH_ATTACK_CHECK_COLOR_SPRAY:
					{
						int hitDice = GetHitDice(oTestTarget);
						if (hitDice < 2)
						{
							nTempResult = GetIsImmune(oTestTarget, IMMUNITY_TYPE_SLEEP, OBJECT_SELF);
						}
						else if (hitDice > 2 && hitDice < 5)
	                    {
							currentEffectWeight = 0.5;
							nTempResult = GetIsImmune(oTestTarget, IMMUNITY_TYPE_BLINDNESS, OBJECT_SELF);
						}
	                    else
	                    {
							currentEffectWeight = 0.75;
							nTempResult = GetIsImmune(oTestTarget, IMMUNITY_TYPE_STUN, OBJECT_SELF);
	                    }				
					}
					break;
				case HENCH_ATTACK_CHECK_SUNBEAM:
					if (GetRacialType(oTestTarget) == RACIAL_TYPE_UNDEAD)
		            {
						currentDamageAmount = nCasterLevel > 20 ? 70.0 : 3.5 * nCasterLevel;
		            }
                    break;
                case HENCH_ATTACK_CHECK_SUNBURST:
					if (GetRacialType(oTestTarget) == RACIAL_TYPE_UNDEAD)
		            {
                        int nApperanceType =  GetAppearanceType(oTestTarget);                        
                        if ((nApperanceType == APPEARANCE_TYPE_VAMPIRE_MALE) ||
                            (nApperanceType == APPEARANCE_TYPE_VAMPIRE_FEMALE))
                        {
						    currentDamageAmount = 10000.0;                        
                        }
                        else
                        {
						    currentDamageAmount = nCasterLevel > 25 ? 87.5 : 3.5 * nCasterLevel;                        
                        }
		            }                    
                    break;
				case HENCH_ATTACK_CHECK_MEDIUM:
					nTempResult = GetCreatureSize(oTestTarget) > CREATURE_SIZE_MEDIUM;
					break;
				case HENCH_ATTACK_CHECK_CASTIGATE:
					if (GetAlignmentLawChaos(oTestTarget) != GetAlignmentLawChaos(OBJECT_SELF))
					{
						if (GetAlignmentGoodEvil(oTestTarget) == GetAlignmentGoodEvil(OBJECT_SELF))
						{
							currentDamageAmount /= 2;
						}
					}
					else
					{
						if (GetAlignmentGoodEvil(oTestTarget) != GetAlignmentGoodEvil(OBJECT_SELF))
						{
							currentDamageAmount /= 2;
						}
						else
						{
							nTempResult = TRUE;
						}
					}
					break;
				case HENCH_ATTACK_CHECK_FIGHTER:
					nTempResult = GetBaseAttackBonus(oTestTarget) < (3 * GetHitDice(oTestTarget) / 4);
					if (!nTempResult)
					{
						if (GetAbilityScore(oTestTarget, ABILITY_STRENGTH) < GetAbilityScore(oTestTarget, ABILITY_DEXTERITY))
						{					
							currentEffectWeight /= 2.0;
						}
					}
					break;
				case HENCH_ATTACK_CHECK_NOT_DEAF:
					nTempResult = currentCreatureNegativeEffects & HENCH_EFFECT_TYPE_DEAF;
					break;
				}

//				Jug_Debug(" test target " + GetName(oTestTarget) + " 1 current effect weight " + FloatToString(currentEffectWeight));
				if (!nTempResult && currentEffectWeight >= 0.0)
				{
					if (immunityMind && GetIsImmune(oTestTarget, IMMUNITY_TYPE_MIND_SPELLS, OBJECT_SELF))
					{
						currentEffectWeight = 0.0;
					}
					else
					{
						if (immunity2)
						{
							if (GetIsImmune(oTestTarget, immunity2, OBJECT_SELF))
							{
								if (GetIsImmune(oTestTarget, immunity1, OBJECT_SELF))
								{
									currentEffectWeight = 0.0;
								}
								else
								{
									currentEffectWeight /= 2.0;
								}
							}
							else if (GetIsImmune(oTestTarget, immunity1, OBJECT_SELF))
							{
								currentEffectWeight /= 2.0;
							}
						}
						else if (immunity1)
						{
							if (GetIsImmune(oTestTarget, immunity1, OBJECT_SELF))
							{
								currentEffectWeight = 0.0;
							}
						}
					}
				}
//				Jug_Debug(" test target " + GetName(oTestTarget) + " 1 current effect weight " + FloatToString(currentEffectWeight));
				if (!nTempResult && currentEffectWeight >= 0.0)
				{
					int creatureNegEffects = GetCreatureNegEffects(oTestTarget);
//					Jug_Debug(" creature neg effects " + IntToHexString(creatureNegEffects) + " currentEffectTypes = " + IntToHexString(currentEffectTypes));
					if ((creatureNegEffects & HENCH_EFFECT_DISABLED) != 0)
					{
						currentEffectWeight = 0.0;
					}
					else
					{
						if ((currentEffectTypes & creatureNegEffects) == currentEffectTypes)
						{
							currentEffectWeight = 0.0;
						}
						else if ((currentEffectTypes & creatureNegEffects) != 0)
						{
							currentEffectWeight /= 2.0;
						}
					}
				}
//				Jug_Debug(" test target " + GetName(oTestTarget) + " 2 current effect weight " + FloatToString(currentEffectWeight));			
				if (nTempResult || fCurChance <= 0.0)
				{
					curTargetWeight = 0.0;
				}
				else
				{
					if (currentCheckSaves)
					{
						if (bCheckSR)
						{
							if (GetLocalInt(oTestTarget, spellLevelProtStr) >= spellLevel)
							{
//								Jug_Debug(GetName(OBJECT_SELF) + " spell level removal " + GetName(oTestTarget) + " val " + IntToString(GetLocalInt(oTestTarget, spellLevelProtStr)));
								fCurChance = 0.0;
							}
							else
							{						
//								Jug_Debug("Check spell resistance " + GetName(oTestTarget) + " val " + IntToString(GetSpellResistance(oTestTarget)) + " spell pen " + IntToString(nSpellPentetration) + " cur chance " + FloatToString(fCurChance));
								fCurChance *= Getd20Chance(nSpellPentetration - GetSpellResistance(oTestTarget));
//								Jug_Debug("cur chance after " + FloatToString(fCurChance));
							}
						}
				
						// adjust damage based on immunities and resistances
						// TODO this should be below in the code for resistances, but too many branches						
						int curTargetDamageInfo = GetLocalInt(oTestTarget, damageInformationStr) & spellDamage.damageTypeMask;
						if (curTargetDamageInfo)
						{
							// do some damage adjusting!
							int numberOfDamageTypes = spellDamage.numberOfDamageTypes;
							if (numberOfDamageTypes == 1)
							{								
//								Jug_Debug(GetName(oTestTarget) + " doing damage adjust start " + FloatToString(currentDamageAmount) + " damage type " + IntToHexString(curTargetDamageInfo));							
								currentDamageAmount *= GetFloatArray(oTestTarget, HENCH_DAMAGE_IMMUNITY_STR, spellDamage.damageType1);
								currentDamageAmount -= GetIntArray(oTestTarget, HENCH_DAMAGE_RESIST_STR, spellDamage.damageType1) * spellDamage.count;
//								Jug_Debug(GetName(oTestTarget) + " doing damage adjust resist " + FloatToString(currentDamageAmount));							
//								Jug_Debug(GetName(oTestTarget) + " doing damage adjust immunity " + FloatToString(currentDamageAmount));								
								if (currentDamageAmount < 0.5)
								{			
									currentDamageAmount = 0.0;
								}
							}
							else
							{							
								currentDamageAmount = GetDamageResistImmunityAdjustment(oTestTarget, currentDamageAmount / 2, spellDamage.damageType1, spellDamage.count) +
									GetDamageResistImmunityAdjustment(oTestTarget, currentDamageAmount / 2, spellDamage.damageType2, spellDamage.count);					
							}
						}	
											
						float ratio = 1.0;						
											
						if (currentFirstSaveType)
						{
							switch (currentFirstSaveType)
							{
							case HENCH_SPELL_SAVE_TYPE_SAVE1_FORT:
								ratio = Getd20ChanceLimited(currentSaveDC - GetFortitudeSavingThrow(oTestTarget));
								break;
							case HENCH_SPELL_SAVE_TYPE_SAVE1_REFLEX:
								ratio = Getd20ChanceLimited(currentSaveDC - GetReflexSavingThrow(oTestTarget));
								break;
							case HENCH_SPELL_SAVE_TYPE_SAVE1_WILL:
								ratio = Getd20ChanceLimited(currentSaveDC - GetWillSavingThrow(oTestTarget));
								break;
							}
//							Jug_Debug(" ratio is " + FloatToString(ratio) + " firstSaveKind = " + IntToHexString(firstSaveKind) + " firstSaveType " + IntToHexString(firstSaveType));
							switch (currentFirstSaveKind)
							{
							case HENCH_SPELL_SAVE_TYPE_SAVE1_EFFECT_ONLY:
								if (secondSaveType == 0)
								{
									curTargetWeight = currentEffectWeight * ratio;
									if (currentDamageAmount > 0.0)
									{				
										curTargetWeight += CalculateDamageWeight(currentDamageAmount, oTestTarget);
									}
								}
								else if (currentFirstSaveType == (secondSaveType / HENCH_SPELL_SAVE_TYPE_SAVE12_SHIFT))
								{
									curTargetWeight = currentEffectWeight * ratio;
								}
								else
								{
									fCurChance *= ratio;									
								}
								break;
		               		case HENCH_SPELL_SAVE_TYPE_SAVE1_DAMAGE_HALF:							
								curTargetWeight = ratio * CalculateDamageWeight(currentDamageAmount, oTestTarget) +
									(1.0 - ratio) * CalculateDamageWeight(currentDamageAmount / 2.0, oTestTarget); 
								break;							
		               		case HENCH_SPELL_SAVE_TYPE_SAVE1_EFFECT_DAMAGE:
								curTargetWeight = ratio * currentEffectWeight +
									(1.0 - ratio) * CalculateDamageWeight(currentDamageAmount, oTestTarget);
								break;	
		               		case HENCH_SPELL_SAVE_TYPE_SAVE1_DAMAGE_EVASION:
								if (GetHasFeat(FEAT_IMPROVED_EVASION, oTestTarget))
								{
									curTargetWeight = ratio * CalculateDamageWeight(currentDamageAmount / 2.0, oTestTarget);
								}
								else if (GetHasFeat(FEAT_EVASION, oTestTarget))
								{
									curTargetWeight = ratio * CalculateDamageWeight(currentDamageAmount, oTestTarget);
								}
								else
								{
									curTargetWeight = ratio * CalculateDamageWeight(currentDamageAmount, oTestTarget) +
										(1.0 - ratio) * CalculateDamageWeight(currentDamageAmount / 2.0, oTestTarget);
								}
							}
							if (secondSaveType)
							{
								if (secondSaveType != (currentFirstSaveType * HENCH_SPELL_SAVE_TYPE_SAVE12_SHIFT))
								{						
									switch (secondSaveType)
									{
									case HENCH_SPELL_SAVE_TYPE_SAVE2_FORT:
										ratio = Getd20ChanceLimited(currentSaveDC - GetFortitudeSavingThrow(oTestTarget));
										break;
									case HENCH_SPELL_SAVE_TYPE_SAVE2_REFLEX:
										ratio = Getd20ChanceLimited(currentSaveDC - GetReflexSavingThrow(oTestTarget));
										break;
									case HENCH_SPELL_SAVE_TYPE_SAVE2_WILL:
										ratio = Getd20ChanceLimited(currentSaveDC - GetWillSavingThrow(oTestTarget));
										break;
									}
								}
								switch (secondSaveKind)
								{
								case HENCH_SPELL_SAVE_TYPE_SAVE2_EFFECT_ONLY:
									curTargetWeight += currentEffectWeight * ratio;
									break;
		                		case HENCH_SPELL_SAVE_TYPE_SAVE2_DAMAGE_HALF:
									curTargetWeight += ratio * CalculateDamageWeight(currentDamageAmount, oTestTarget) +
										(1.0 - ratio) *  CalculateDamageWeight(currentDamageAmount / 2.0, oTestTarget); 
									break;							
		                		case HENCH_SPELL_SAVE_TYPE_SAVE2_EFFECT_DAMAGE:
									curTargetWeight += ratio * currentEffectWeight +
										(1.0 - ratio) * CalculateDamageWeight(currentDamageAmount, oTestTarget);
									break;	
		                		case HENCH_SPELL_SAVE_TYPE_SAVE2_DAMAGE_EVASION:							
									if (GetHasFeat(FEAT_IMPROVED_EVASION, oTestTarget))
									{
										curTargetWeight = ratio * CalculateDamageWeight(currentDamageAmount / 2.0, oTestTarget);
									}
									else if (GetHasFeat(FEAT_EVASION, oTestTarget))
									{
										curTargetWeight = ratio * CalculateDamageWeight(currentDamageAmount, oTestTarget);
									}
									else
									{
										curTargetWeight = ratio * CalculateDamageWeight(currentDamageAmount, oTestTarget) +
											(1.0 - ratio) * CalculateDamageWeight(currentDamageAmount / 2.0, oTestTarget);
									}
									break;
								}
							}
						}
						else
						{
							curTargetWeight = currentEffectWeight + CalculateDamageWeight(currentDamageAmount, oTestTarget);
						}
						if (curTargetWeight > 1.0)
						{				
							curTargetWeight = 1.0;
						}
//						Jug_Debug(" test target " + GetName(oTestTarget) + " 1 current target weight " + FloatToString(curTargetWeight) + " current chance " + FloatToString(fCurChance));
						if (bIsFriend && (fCurChance > 0.0)) 					
						{
							if (oTestTarget == OBJECT_SELF)
							{
								// always look out for number one
	                            if (currentEffectWeight > 0.0)
	                            {
									curTargetWeight = HENCH_CREATURE_SAVE_ABORT;
	                            }
	                            // don't drop self HP too much
	                            else if (curTargetWeight > HENCH_LOW_ALLY_DAMAGE_THRESHOLD)
	                            {
									curTargetWeight = HENCH_CREATURE_SAVE_ABORT;
	                            }
	                            else
	                            {
									curTargetWeight *= HENCH_LOW_ALLY_DAMAGE_WEIGHT * GetThreatRating(oTestTarget) * gfAttackWeight * fCurChance;                           
	                            }
							}
							else
							{						
	                            if (GetAssociateType(oTestTarget) == ASSOCIATE_TYPE_SUMMONED)
	                            {
	                                // summons are expendable
									curTargetWeight *= gfAllyDamageWeight * GetThreatRating(oTestTarget) * gfAttackWeight * fCurChance;                           
	                            }
	                            // avoid putting negative effects on allies
	                            else if (currentEffectWeight > gfMaximumAllyEffect)
	                            {
									curTargetWeight = HENCH_CREATURE_SAVE_ABORT;
	                            }
	                            // don't drop ally HP too much
	                            else if (curTargetWeight > gfMaximumAllyDamage)
	                            {
									curTargetWeight = HENCH_CREATURE_SAVE_ABORT;
	                            }
	                            else
	                            {
									curTargetWeight *= gfAllyDamageWeight * GetThreatRating(oTestTarget) * gfAttackWeight * fCurChance;                           
	                            }
							}
						}
						else						
						{						
				           	if ((GetDistanceToObject(oTestTarget) < 7.5) &&
								((curTargetWeight * fCurChance) > 0.0001))
				            {
				                bTargetFound = TRUE;
				            }
							curTargetWeight *= GetThreatRating(oTestTarget) * gfAttackWeight * fCurChance;                           
						}                        
//						Jug_Debug(" test target " + GetName(oTestTarget) + " 2 current target weight " + FloatToString(curTargetWeight));
	                }
					else
					{
						int currentRegenerateAmount = GetLocalInt(oTestTarget, regenerationRateStr);
						int iCurrent = GetCurrentHitPoints(oTestTarget) + currentRegenerateAmount * giRegenHealScaleAmount;
					    int iBase = GetMaxHitPoints(oTestTarget);
						
						float healthRatio = IntToFloat(iCurrent) / IntToFloat(iBase);
						
//						Jug_Debug(GetName(oTestTarget) + " max hp " + IntToString(iBase) + " current hp " + IntToString(iCurrent) + " heal amount " + FloatToString(currentDamageAmount));						
//						Jug_Debug(GetName(oTestTarget) + " health ratio " + FloatToString(healthRatio) + " healing thres " + FloatToString(gfHealingThreshold) + " threshold damage limit " + FloatToString(IntToFloat(iBase / (bgMeleeAttackers ?  8 : 15))));
//						SpawnScriptDebugger();

						if ((healthRatio < gfHealingThreshold) &&
							(currentDamageAmount >= IntToFloat(iBase / giHealingDivisor)))
						{
							if (gbDisableNonHealorCure || (GetLocalInt(oTestTarget, HENCH_HEAL_SELF_STATE) <= HENCH_HEAL_SELF_CANT) || GetIsPC(oTestTarget))
							{
								// this actually heals the target (a friend)
								curTargetWeight = currentDamageAmount / IntToFloat(iBase - iCurrent);
								if (curTargetWeight > 1.0)
								{
									curTargetWeight = 1.0;
								}
								curTargetWeight *= GetThreatRating(oTestTarget);
								if (gbDisableNonHealorCure || oTestTarget == OBJECT_SELF)
								{
									// make sure to heal self
									curTargetWeight *= gfHealSelfWeightAdjustment;
								}
								else
								{
									curTargetWeight *= gfHealOthersWeightAdjustment;
								}
							}
							else
							{
								curTargetWeight = 0.0;
							}
						}
						else
						{
							curTargetWeight = 0.0;
							if ((oTestTarget == OBJECT_SELF) && (currentDamageAmount >= IntToFloat(iBase / giHealingDivisor)))
							{
    							SetLocalInt(OBJECT_SELF, HENCH_HEAL_SELF_STATE, HENCH_HEAL_SELF_WAIT);
							}
						}
					}					
				}
				if (bAllowWeightSave)
				{
					SetLocalFloat(oTestTarget, sCreatureSaveResultStr, curTargetWeight);
				}				
            }
			
			if (curTargetWeight == HENCH_CREATURE_SAVE_ABORT)
			{
//				Jug_Debug(GetName(OBJECT_SELF) + " doing abort");
				fTotalWeight = HENCH_CREATURE_SAVE_ABORT;
				break;
			}
						
			// check touch attacks
			if (iCheckTouch)
			{
				if (!GetIsEnemy(oTestTarget))
				{
//					Jug_Debug("Touch attack ignore " + GetName(oTestTarget));					
				}				
				else if ((gsCurrentspInfo.otherID != SPELL_I_ELDRITCH_CHAIN) && (nShapeLoopCount > 0))
				{
//					Jug_Debug("Skipping touch attack for " + GetName(oTestTarget));					
				}
				else
				{
					float fTouchChance;
					int touchFlags = GetLocalInt(oTestTarget, HENCH_RANGED_TOUCH_SAVEINFO);
					if (touchFlags & iCheckTouch)
					{
						fTouchChance = GetLocalFloat(oTestTarget, gsRangeSaveStr);
//						Jug_Debug("Check touch attack saved " + GetName(oTestTarget) + " cur chance " + FloatToString(fTouchChance));					
					}
					else
					{
						int touchAC = GetTouchAC(oTestTarget);
//						Jug_Debug("touch ac " +	IntToString(10 + touchAC));
											
						fTouchChance = Getd20ChanceLimited(nTouchCheck - touchAC);								
						if (iCheckTouch & (HENCH_MELEE_TOUCH_REGULAR | HENCH_MELEE_TOUCH_PLUS_TWO))
						{
							fTouchChance *= 1.0 - GetLocalFloat(oTestTarget, meleeConcealmentStr);
						}
						else
						{
							fTouchChance *= 1.0 - GetLocalFloat(oTestTarget, rangedConcealmentStr);
						}
						SetLocalFloat(oTestTarget, gsRangeSaveStr, fTouchChance);
						touchFlags |= iCheckTouch;
						SetLocalInt(oTestTarget, HENCH_RANGED_TOUCH_SAVEINFO, touchFlags);
//						Jug_Debug("Check touch attack " + GetName(oTestTarget) + " cur chance " + FloatToString(fTouchChance));					
					}
					
					if (gsCurrentspInfo.otherID == SPELL_I_ELDRITCH_CHAIN)
					{
						if (!nShapeLoopCount)
						{
							fAccumChance = fTouchChance;
						}
						else if (oCurTarget != oTestTarget)
						{
							fAccumChance *= fTouchChance;
						}
//						Jug_Debug("Check touch attack accum " + GetName(oTestTarget) + " cur chance " + FloatToString(fAccumChance));
						curTargetWeight *= fAccumChance;
					}
					else
					{
						curTargetWeight *= fTouchChance;
					}			
				}				 
			}			
			fTotalWeight += curTargetWeight;
								
			if (!bDoLoop || (nShapeLoopCount > 19))
	        {
//				if (iLoopFlags) { Jug_Debug(GetName(OBJECT_SELF) + " break out of loop"); }
	            break;
	        }
			if (targetInformation & HENCH_SPELL_TARGET_SECONDARY_TARGETS)
			{
				do
				{
					if (!nShapeLoopCount)
					{				
						// hack, reset back to first shape target after first iteration
			            oTestTarget = GetFirstObjectInShape(spellShape, spellRadius, testTargetLoc, TRUE, OBJECT_TYPE_CREATURE, GetPosition(OBJECT_SELF));
						bAllowWeightSave = TRUE;
					}
					else
					{
			            //Select the next target within the spell shape.
			            oTestTarget = GetNextObjectInShape(spellShape, spellRadius, testTargetLoc, TRUE, OBJECT_TYPE_CREATURE, GetPosition(OBJECT_SELF));
					}
					nShapeLoopCount++;
				} while (oCurTarget == oTestTarget);
			}
			else
			{
	            //Select the next target within the spell shape.
	            oTestTarget = GetNextObjectInShape(spellShape, spellRadius, testTargetLoc, TRUE, OBJECT_TYPE_CREATURE, GetPosition(OBJECT_SELF));
				nShapeLoopCount++;
			}
        }
		
//		Jug_Debug("``````" + GetName(OBJECT_SELF) + " checking attack spell in weight " + FloatToString(fTotalWeight));			
		if (bTargetFound && (fTotalWeight > fFinalTargetWeight))
		{
//			Jug_Debug("``````" + GetName(OBJECT_SELF) + " putting attack spell in weight " + FloatToString(fTotalWeight));			
			fFinalTargetWeight = fTotalWeight;
			oFinalTarget = oCurTarget;
			lFinalLocation = testTargetLoc;
			bUseFinalTargetObject = spellShape == HENCH_SHAPE_NONE ||
				(targetInformation & HENCH_SPELL_TARGET_VIS_REQUIRED_FLAG) || (oCurTarget == OBJECT_SELF) ||
				(GetObjectSeen(oCurTarget) && (spellShape == SHAPE_SPELLCONE || spellShape == SHAPE_CONE || !checkFriendly));
		}
		// don't check too many targets
		if (totalTargetsTested >= totalTargetsLimit)
		{
//			if (iLoopFlags) { Jug_Debug(GetName(OBJECT_SELF) + " over limit for area spell " + IntToString(totalTargetsTested)); }
			break;
		}
    }
	
	if (spellShape == HENCH_SHAPE_NONE)
	{
		giCurNumMaxSingleTest += totalTargetsTested;
	}
	else
	{
		giCurNumMaxAreaTest += totalTargetsTested;
	}
    
	if (fFinalTargetWeight > 0.0)
	{
		if (targetInformation & HENCH_SPELL_TARGET_RANGED_SEL_AREA_FLAG)	
		{
			gsCurrentspInfo.castingInfo |= HENCH_CASTING_INFO_RANGED_SEL_AREA_FLAG;	
		}
		if (bUseFinalTargetObject)
		{
        	HenchCheckIfAttackSpellToCastOnObject(fFinalTargetWeight, oFinalTarget);
		}
		else
		{		
        	HenchCheckIfAttackSpellToCastAtLocation(fFinalTargetWeight, lFinalLocation);
		}
    }
	
	if (bIsBeneficial)
	{	
		float spellDamageAmount = spellDamage.amount;
		if (spellShape != HENCH_SHAPE_NONE)
		{
			if (checkType == HENCH_ATTACK_CHECK_HEAL)
			{
//				Jug_Debug(GetName(OBJECT_SELF) + " testing " + Get2DAString("spells", "Label", spellID) + " weight " + FloatToString(fFinalTargetWeight) + " test weight " + FloatToString(gfMinHealAmountArea));
				if (giCurNumMaxAreaTest > HENCH_MAX_AREA_TARGET_CHECKS)
				{
//					Jug_Debug(GetName(OBJECT_SELF) + " over maxium test level");
					gfMinHealAmountArea = 100000.0;	// prevent any more attempts			
				}
 				else if (fFinalTargetWeight > gfMinHealWeightArea)
				{				
//					Jug_Debug(GetName(OBJECT_SELF) + " replacing " + Get2DAString("spells", "Label", spellID) + " amount " + FloatToString(spellDamage.amount) + " test amount " + FloatToString(gfMinHealAmountArea));
					gfMinHealWeightArea = fFinalTargetWeight;
					gfMinHealAmountArea = gfLastHealAmountArea;
					gfLastHealAmountArea = spellDamageAmount;
				}
				else if (spellDamageAmount > gfMinHealAmountArea)
				{
//					Jug_Debug(GetName(OBJECT_SELF) + " replacing2 " + Get2DAString("spells", "Label", spellID) + " amount " + FloatToString(spellDamage.amount) + " test amount " + FloatToString(gfMinHealAmountArea));
					gfMinHealAmountArea = spellDamageAmount;
					gfLastHealAmountArea = gfMinHealAmountArea;
				}
			}
			else
			{
//				Jug_Debug(GetName(OBJECT_SELF) + " testing " + Get2DAString("spells", "Label", spellID) + " weight " + FloatToString(fFinalTargetWeight) + " test weight " + FloatToString(gfMinHarmAmountArea));
				if (giCurNumMaxAreaTest > HENCH_MAX_AREA_TARGET_CHECKS)
				{
//					Jug_Debug(GetName(OBJECT_SELF) + " over maxium test level");
					gfMinHarmAmountArea = 100000.0;	// prevent any more attempts			
				}
 				else if (fFinalTargetWeight > gfMinHarmWeightArea)
				{				
//					Jug_Debug(GetName(OBJECT_SELF) + " replacing " + Get2DAString("spells", "Label", spellID) + " amount " + FloatToString(spellDamage.amount) + " test amount " + FloatToString(gfMinHarmAmountArea));
					gfMinHarmWeightArea = fFinalTargetWeight;
					gfMinHarmAmountArea = gfLastHarmAmountArea;
					gfLastHarmAmountArea = spellDamageAmount;
				}
				else if (spellDamageAmount > gfMinHarmAmountArea)
				{
//					Jug_Debug(GetName(OBJECT_SELF) + " replacing2 " + Get2DAString("spells", "Label", spellID) + " amount " + FloatToString(spellDamage.amount) + " test amount " + FloatToString(gfMinHarmAmountArea));
					gfMinHarmAmountArea = spellDamageAmount;
					gfLastHarmAmountArea = gfMinHarmAmountArea;
				}
			}
		}
		else if (spellRange > 0.0)
		{
			if (checkType == HENCH_ATTACK_CHECK_HEAL)
			{
//				Jug_Debug(GetName(OBJECT_SELF) + " testing " + Get2DAString("spells", "Label", spellID) + " weight " + FloatToString(fFinalTargetWeight) + " test weight " + FloatToString(gfMinHealAmountSingle));
				if (giCurNumMaxSingleTest > HENCH_MAX_SINGLE_TARGET_CHECKS)
				{
//					Jug_Debug(GetName(OBJECT_SELF) + " over maxium test level");
					gfMinHealAmountSingle = 100000.0;	// prevent any more attempts			
				}
 				else if (fFinalTargetWeight > gfMinHealWeightSingle)
				{				
//					Jug_Debug(GetName(OBJECT_SELF) + " replacing " + Get2DAString("spells", "Label", spellID) + " amount " + FloatToString(spellDamage.amount) + " test amount " + FloatToString(gfMinHealAmountSingle));
					gfMinHealWeightSingle = fFinalTargetWeight;
					gfMinHealAmountSingle = gfLastHealAmountSingle;
					gfLastHealAmountSingle = spellDamageAmount;
				}
				else if (spellDamageAmount > gfMinHealAmountSingle)
				{
//					Jug_Debug(GetName(OBJECT_SELF) + " replacing2 " + Get2DAString("spells", "Label", spellID) + " amount " + FloatToString(spellDamage.amount) + " test amount " + FloatToString(gfMinHealAmountSingle));
					gfMinHealAmountSingle = spellDamageAmount;
					gfLastHealAmountSingle = gfMinHealAmountSingle;
				}
			}
			else
			{
//				Jug_Debug(GetName(OBJECT_SELF) + " testing " + Get2DAString("spells", "Label", spellID) + " weight " + FloatToString(fFinalTargetWeight) + " test weight " + FloatToString(gfMinHarmAmountSingle));
				if (giCurNumMaxSingleTest > HENCH_MAX_SINGLE_TARGET_CHECKS)
				{
//					Jug_Debug(GetName(OBJECT_SELF) + " over maxium test level");
					gfMinHarmAmountSingle = 100000.0;	// prevent any more attempts			
				}
 				else if (fFinalTargetWeight > gfMinHarmWeightSingle)
				{				
//					Jug_Debug(GetName(OBJECT_SELF) + " replacing " + Get2DAString("spells", "Label", spellID) + " amount " + FloatToString(spellDamage.amount) + " test amount " + FloatToString(gfMinHarmAmountSingle));
					gfMinHarmWeightSingle = fFinalTargetWeight;
					gfMinHarmAmountSingle = gfLastHarmAmountSingle;
					gfLastHarmAmountSingle = spellDamageAmount;
				}
				else if (spellDamageAmount > gfMinHarmAmountSingle)
				{
//					Jug_Debug(GetName(OBJECT_SELF) + " replacing2 " + Get2DAString("spells", "Label", spellID) + " amount " + FloatToString(spellDamage.amount) + " test amount " + FloatToString(gfMinHarmAmountSingle));
					gfMinHarmAmountSingle = spellDamageAmount;
					gfLastHarmAmountSingle = gfMinHarmAmountSingle;
				}
			}
		}
	}
}


void HenchSpellAttackSpecial()
{
	int spellID = gsCurrentspInfo.spellID;
	int saveType = GetCurrentSpellSaveType();	
	float testRange = gsCurrentspInfo.range;
    int bCheckSR = saveType & HENCH_SPELL_SAVE_TYPE_SR_FLAG;
	int bFoundItemSpell = gsCurrentspInfo.spellInfo & HENCH_SPELL_INFO_ITEM_FLAG;	
	int spellLevel = gsCurrentspInfo.spellLevel;
    int nCasterLevel =  bFoundItemSpell ? (spellLevel * 2) - 1 : nMySpellCasterLevel;
	int nSpellPentetration =  bFoundItemSpell ? nCasterLevel : nMySpellCasterSpellPenetration;
		
//	Jug_Debug(GetName(OBJECT_SELF) + " HenchSpellAttackSpecial " + Get2DAString("spells", "Label", spellID) + " " + IntToString(spellID) + " level " + IntToString(gsCurrentspInfo.spellLevel) + " save type " + IntToString(saveType) + " is item " + IntToString(bFoundItemSpell));

	object oTestTarget = GetLocalObject(OBJECT_SELF, sObjectSeen);	
	object oBestTarget;
	float maxEffectWeight;
	int totalTargetsTested;

	while (GetIsObjectValid(oTestTarget) && (totalTargetsTested < 6))
	{
//		Jug_Debug(GetName(OBJECT_SELF) + " HenchSpellAttackSpecial checking target " + GetName(oTestTarget));
	 	if (GetDistanceToObject(oTestTarget) <= testRange)
		{		
			totalTargetsTested ++;
			if (giCurNumMaxSingleTest++ > HENCH_MAX_SINGLE_TARGET_CHECKS)
			{		
//				Jug_Debug(GetName(OBJECT_SELF) + " HenchSpellAttackSpecial over target limit " + GetName(oTestTarget));
				break;
			}			
			int currentCreatureNegativeEffects = GetCreatureNegEffects(oTestTarget);
			
			float curEffectWeight;		
			int skipTarget;
		
			switch (spellID)
			{
			case SPELL_POWORD_WEAKEN:
			case SPELL_POWORD_MALADROIT:
				if (GetIsImmune(oTestTarget, IMMUNITY_TYPE_ABILITY_DECREASE, OBJECT_SELF))
				{
					skipTarget = TRUE;
				}		
				else 
				{
					int	nTargetHP =	GetCurrentHitPoints(oTestTarget);
					if ((nTargetHP > 75) ||
						(currentCreatureNegativeEffects & (HENCH_EFFECT_DISABLED | HENCH_EFFECT_IMPAIRED | HENCH_EFFECT_TYPE_ABILITY_DECREASE)) ||				
						!GetIsObjectValid(GetAttackTarget(oTestTarget)))
					{
						skipTarget = TRUE;
					}
					else if (nTargetHP > 50)
					{
						curEffectWeight = 0.015;
					}
					else if (nTargetHP > 25)
					{
						curEffectWeight = 0.02;
					}
					else
					{
						curEffectWeight = 0.03;
					}		
				}
				break;
			case SPELL_POWORD_BLIND:		
				if (GetIsImmune(oTestTarget, IMMUNITY_TYPE_BLINDNESS, OBJECT_SELF))
				{
					skipTarget = TRUE;
				}		
				else 
				{
					int	nTargetHP =	GetCurrentHitPoints(oTestTarget);
					if ((nTargetHP > 200) ||
						(currentCreatureNegativeEffects & (HENCH_EFFECT_DISABLED | HENCH_EFFECT_IMPAIRED)))
					{
						skipTarget = TRUE;
					}
					else if (nTargetHP > 100)
					{
						curEffectWeight = 0.2;
					}
					else if (nTargetHP > 50)
					{
						curEffectWeight = 0.3;
					}
					else
					{
						curEffectWeight = 0.35;
					}		
				}
				break;
			case SPELL_POWORD_PETRIFY:	
				{
					int	nTargetHP =	GetCurrentHitPoints(oTestTarget);
					if ((nTargetHP > 100) ||
						(currentCreatureNegativeEffects & HENCH_EFFECT_DISABLED))
					{
						skipTarget = TRUE;
					}
					else
					{
						curEffectWeight = 1.0;
					}		
				}
				break;
			case SPELL_POWER_WORD_DISABLE:
				{
//					Jug_Debug(GetName(OBJECT_SELF) + " pw disable");
					int	nTargetHP =	GetCurrentHitPoints(oTestTarget);
					if ((nTargetHP > 50) || (nTargetHP < 2) ||
						(currentCreatureNegativeEffects & HENCH_EFFECT_DISABLED))
					{
						skipTarget = TRUE;
					}
					else
					{
						curEffectWeight = CalculateDamageWeight(IntToFloat(nTargetHP - 1), oTestTarget);
//							Jug_Debug(GetName(OBJECT_SELF) + " pw disable effect weight " + FloatToString(curEffectWeight));
					}
				}
				break;				
			case SPELL_POWER_WORD_KILL:
				if (GetIsImmune(oTestTarget, IMMUNITY_TYPE_DEATH, OBJECT_SELF))
				{
					skipTarget = TRUE;
				}		
				else 
				{
					int	nTargetHP =	GetCurrentHitPoints(oTestTarget);
					if ((nTargetHP > 100) ||
						(currentCreatureNegativeEffects & HENCH_EFFECT_DISABLED))
					{
						skipTarget = TRUE;
					}
					else
					{
						curEffectWeight = 1.0;
					}		
				}
				break;
			case SPELL_POWER_WORD_STUN:
				if (GetIsImmune(oTestTarget, IMMUNITY_TYPE_MIND_SPELLS, OBJECT_SELF) ||
					GetIsImmune(oTestTarget, IMMUNITY_TYPE_STUN, OBJECT_SELF))
				{
					skipTarget = TRUE;
				}		
				else 
				{
					int	nTargetHP =	GetCurrentHitPoints(oTestTarget);
					if ((nTargetHP > 150) ||
						(currentCreatureNegativeEffects & HENCH_EFFECT_DISABLED))
					{
						skipTarget = TRUE;
					}
					else if (nTargetHP > 100)
					{
						curEffectWeight = 0.70;
					}
					else if (nTargetHP > 50)
					{
						curEffectWeight = 0.75;
					}
					else
					{
						curEffectWeight = 0.8;
					}		
				}
				break;
			case 1132:		// Shadow Simulacrum
			case 1133:		// Glass Doppelganger
				if (!GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_SUMMONED)))
				{				
					int nTargetHD = GetHitDice(oTestTarget);
					if (spellID == 1132)
					{
						if (nTargetHD > (2 * nCasterLevel))
						{
							skipTarget = TRUE;
							break;
						}
						curEffectWeight = 0.75;
					}
					else
					{
						if ((nTargetHD > nCasterLevel) || (nTargetHD > 15))
						{
							skipTarget = TRUE;
							break;
						}
						curEffectWeight = 0.25;
					}
					curEffectWeight *= GetRawThreatRating(oTestTarget);
					curEffectWeight *= IntToFloat(GetCurrentHitPoints(oTestTarget)) / (4.5 * nTargetHD);
					curEffectWeight *= IntToFloat(GetBaseAttackBonus(oTestTarget)) / (0.75 * nTargetHD);					
					curEffectWeight *= gfSummonAdjustment * gfBuffSelfWeight;
				}
				break;
			}
		
			if (!skipTarget)
			{
				if (currentCreatureNegativeEffects & HENCH_EFFECT_DISABLED)
				{
					curEffectWeight = 0.0;			
				}
				else if (bCheckSR)
				{
					if (GetLocalInt(oTestTarget, spellLevelProtStr) >= spellLevel)
					{
//						Jug_Debug(GetName(OBJECT_SELF) + " spell level removal " + GetName(oTestTarget) + " val " + IntToString(GetLocalInt(oTestTarget, spellLevelProtStr)));
						curEffectWeight = 0.0;
					}
					else
					{						
//						Jug_Debug("Check spell resistance " + GetName(oTestTarget) + " val " + IntToString( GetSpellResistance(oTestTarget)) + " cur chance " + FloatToString(fCurChance));
						curEffectWeight *= Getd20Chance(nSpellPentetration - GetSpellResistance(oTestTarget));
//						Jug_Debug("cur chance after " + FloatToString(fCurChance));
					}
				}
				
				curEffectWeight *=  GetThreatRating(oTestTarget);
				
				if (curEffectWeight > maxEffectWeight)
				{
					oBestTarget = oTestTarget;
					maxEffectWeight = curEffectWeight;
				}
			}
		}
		oTestTarget = GetLocalObject(oTestTarget, sObjectSeen);	
	}
	if (maxEffectWeight > 0.0)
	{	
		HenchCheckIfAttackSpellToCastOnObject(maxEffectWeight, oBestTarget);
	}
}


float HenchMeleeAttack(object oTarget, int iPosEffectsOnSelf, int bImmobileNoRange)
{
    float fMaxRange = bgMeleeAttackers ? GetDistanceToObject(ogClosestSeenOrHeardEnemy) + 1.5 : 1000.0;
	
	if (bImmobileNoRange)
	{
		fMaxRange = 3.5;
	}
	
//	Jug_Debug(GetName(OBJECT_SELF) + " start target0 " + GetName(oTarget) + " max range " + FloatToString(fMaxRange));
	if (!GetIsObjectValid(oTarget) && GetIsObjectValid(ogDyingEnemy) &&
   		(GetDistanceToObject(ogDyingEnemy) <= fMaxRange) &&
		LineOfSightObject(OBJECT_SELF, ogDyingEnemy))
    {
        //oTarget = ogDyingEnemy;
		// AcadiusLost: ACR Edits, 2009/03/09 to block finishing off of dead PCs.
		oTarget = OBJECT_INVALID;
		//SendMessageToPC(GetFirstPC(), GetResRef(OBJECT_SELF)+": HenchMeleeAttack on DYING PC averted.");
		AssignCommand(OBJECT_SELF, ClearAllActions(TRUE));
		return 0.0;
    }
//    Jug_Debug(GetName(OBJECT_SELF) + " start target1 " + GetName(oTarget) + " max range " + FloatToString(fMaxRange));

    int bHasSneakAttack = GetHasFeat(FEAT_SNEAK_ATTACK);
	int bIsInvisible = iPosEffectsOnSelf & HENCH_EFFECT_INVISIBLE;
	int bWeaponIsRanged = GetWeaponRanged(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND));

    if (!GetIsObjectValid(oTarget) && bHasSneakAttack && GetIsObjectValid(ogClosestNonActiveEnemy) &&
		(GetDistanceToObject(ogClosestNonActiveEnemy) <= fMaxRange) &&
		LineOfSightObject(OBJECT_SELF, ogClosestNonActiveEnemy))
    {
        // if target is non active finish them off		
        if (!(GetCreatureNegEffects(ogClosestNonActiveEnemy) & HENCH_EFFECT_DISABLED))
        {
            oTarget = ogClosestNonActiveEnemy;
//     Jug_Debug(GetName(OBJECT_SELF) + " start target2 " + GetName(oTarget) + " max range " + FloatToString(fMaxRange));
		}
    }	
		
//   Jug_Debug(GetName(OBJECT_SELF) + " start target2 " + GetName(oTarget) + " max range " + FloatToString(fMaxRange));
    if (!GetIsObjectValid(oTarget))
    {
        float curMaxThreatRating;
		object oTestTarget = GetLocalObject(OBJECT_SELF, sLineOfSight);
		
        while (GetIsObjectValid(oTestTarget))
        {
//            Jug_Debug(GetName(OBJECT_SELF) + " checking melee target " + GetName(oTestTarget) + " is seen " + IntToString(GetObjectSeen(oTestTarget)));
			float fDistanceToTarget = GetDistanceToObject(oTestTarget);
            if (fDistanceToTarget <= fMaxRange)
            {
                float curThreatRating = GetLocalFloat(oTestTarget, sThreatRating);

                if (!GetObjectSeen(oTestTarget))
                {
                    curThreatRating /= 2.0;
                }
				else if (bWeaponIsRanged)
				{
					curThreatRating *= 1.0 - GetLocalFloat(oTestTarget, rangedConcealmentStr);
				}
				else
				{
					curThreatRating *= 1.0 - GetLocalFloat(oTestTarget, meleeConcealmentStr);
				}
				if (GetIsWeaponEffective(oTestTarget))
				{
	                // provide bonus to gang up on damaged targets
	                curThreatRating *= 2.0 - IntToFloat(GetCurrentHitPoints(oTestTarget)) / IntToFloat(GetMaxHitPoints(oTestTarget));
	
	                if (bHasSneakAttack)
	                {
					// extra damage for sneak attack
	                    if (GetObjectSeen(oTestTarget) &&
							!GetIsImmune(oTestTarget, IMMUNITY_TYPE_SNEAK_ATTACK, OBJECT_SELF) &&
							(fDistanceToTarget <= HENCH_MAX_SNEAK_ATTACK_DISTANCE) &&
							(bIsInvisible || (GetAttackTarget(oTestTarget) != OBJECT_SELF) ||
							(GetLocalInt(oTestTarget, curNegativeEffectsStr) & HENCH_EFFECT_TYPE_BLINDNESS)))
	                    {
	                        curThreatRating *= 2.0;
	                    }
	                }
				}
				else
				{
//				Jug_Debug(GetName(OBJECT_SELF) + " target selection weapon not effective " + GetName(oTestTarget));
					curThreatRating /= 5.0;
				}
				
//                Jug_Debug(GetName(OBJECT_SELF) + " testing " + GetName(oTestTarget) + " TR " + FloatToString(curThreatRating));
                if (curThreatRating > curMaxThreatRating)
                {
//                Jug_Debug(GetName(OBJECT_SELF) + " setting target");
                    oTarget = oTestTarget;
                    curMaxThreatRating = curThreatRating;
                }
            }
 			oTestTarget = GetLocalObject(oTestTarget, sLineOfSight);
		}
    }
	
	if (!GetIsObjectValid(oTarget))
	{	
		return 0.0;
	}
	
	goSaveMeleeAttackTarget = oTarget;
	
	int baseAttackBonus = GetBaseAttackBonus(OBJECT_SELF);
	
	struct sAttackInfo attackInfo = GetAttackBonus(OBJECT_SELF, oTarget);
	
	// not completely accurate - guess at weapon damage amount
	float damageGuess = 4.5 + attackInfo.damageBonus;
	
//	Jug_Debug(GetName(OBJECT_SELF) + " damage guess for " + GetName(oTarget) + " is " + FloatToString(damageGuess));		

	float result;
	int attackBonus = attackInfo.attackBonus + 20 - GetAC(oTarget);
	
	int bHasted = iPosEffectsOnSelf & HENCH_EFFECT_TYPE_HASTE;
	int bBABAbove20LevelAdjust; // according to notes from expansion, more than four attacks per round can happen at epic levels
	/*
	int bBABAbove20LevelAdjust = GetHitDice(OBJECT_SELF);
	if (bBABAbove20LevelAdjust > 21)
	{
		bBABAbove20LevelAdjust -= 20;
		bBABAbove20LevelAdjust /= 2;	
	}
	else
	{
		bBABAbove20LevelAdjust = 0;
	}*/
	
//	Jug_Debug(GetName(OBJECT_SELF) + " attack adjust for " + GetName(oTarget) + " is " + IntToString(attackInfo.attackBonus) + " BAB is " + IntToString(baseAttackBonus));	
	do
	{
		float curChance = Getd20ChanceLimited(baseAttackBonus + attackBonus);
		if (bHasted)
		{
			curChance *= 2.0;		
			bHasted = FALSE;
		}
		result += curChance;		
		baseAttackBonus -= 5;
//		Jug_Debug(GetName(OBJECT_SELF) + " current result for " + GetName(oTarget) + " is " + FloatToString(result));		
	} while (baseAttackBonus > bBABAbove20LevelAdjust);
	
	if (!GetObjectSeen(oTarget))
	{
		result /= 2.0;
	}
	if (bWeaponIsRanged)
	{
		result *= 1.0 - GetLocalFloat(oTarget, rangedConcealmentStr);
	}
	else
	{
		result *= 1.0 - GetLocalFloat(oTarget, meleeConcealmentStr);
	}
	result *= damageGuess;
//	Jug_Debug(GetName(OBJECT_SELF) + " estimated damage for " + GetName(oTarget) + " is " + FloatToString(result));		
	return CalculateDamageWeight(result, oTarget) * GetThreatRating(oTarget) / (GetIsWeaponEffective(oTarget) ? 1.0 : 5.0);	
}


void HenchCheckTurnUndead()
{
//	Jug_Debug(GetName(OBJECT_SELF) + " in turn undead");
    // don't turn again until five checks have passed
    int combatRoundCount = GetLocalInt(OBJECT_SELF, henchCombatRoundStr);
    int lastTurning = GetLocalInt(OBJECT_SELF, henchLastTurnStr);
    if (lastTurning != 0 && lastTurning > combatRoundCount - 5)
    {
//		Jug_Debug(GetName(OBJECT_SELF) + " exit turn undead last turning " + IntToString(lastTurning));
        return;
    }

    int nClericLevel = GetLevelByClass(CLASS_TYPE_CLERIC);
    int nPaladinLevel = GetLevelByClass(CLASS_TYPE_PALADIN);
    int nBlackguardlevel = GetLevelByClass(CLASS_TYPE_BLACKGUARD);
    int nTotalLevel =  GetHitDice(OBJECT_SELF);
    int nTurnLevel = nClericLevel;
    int nClassLevel = nClericLevel;
    if((nBlackguardlevel - 2) > 0 && (nBlackguardlevel > nPaladinLevel))
    {
        nClassLevel += (nBlackguardlevel - 2);
        nTurnLevel  += (nBlackguardlevel - 2);
    }
    else if((nPaladinLevel - 3) > 0)
    {
        nClassLevel += (nPaladinLevel - 3);
        nTurnLevel  += (nPaladinLevel - 3);
    }

    //Flags for bonus turning types
    int nElemental = GetHasFeat(FEAT_AIR_DOMAIN_POWER) || GetHasFeat(FEAT_EARTH_DOMAIN_POWER) ||  GetHasFeat(FEAT_FIRE_DOMAIN_POWER) || GetHasFeat(FEAT_WATER_DOMAIN_POWER);
    int nVermin = GetHasFeat(FEAT_PLANT_DOMAIN_POWER);
    int nConstructs = GetHasFeat(FEAT_DESTRUCTION_DOMAIN_POWER);
    int nOutsider = GetHasFeat(FEAT_GOOD_DOMAIN_POWER) || GetHasFeat(FEAT_EVIL_DOMAIN_POWER) || GetHasFeat(FEAT_EPIC_PLANAR_TURNING);

    //Flag for improved turning ability
    int nSun = GetHasFeat(FEAT_SUN_DOMAIN_POWER);

    //Make a turning check roll, modify if have the Sun Domain
    int nChrMod = GetAbilityModifier(ABILITY_CHARISMA);
    // normal check is d20 - changed to not try very often for very difficult turn
 	int nTurnCheck = d10(2) +  nChrMod;              //The roll to apply to the max HD of undead that can be turned --> nTurnLevel
 	int nTurnHD = d6(2) + nChrMod + nClassLevel;   //The number of HD of undead that can be turned.

    if(nSun)
    {
        nTurnCheck += d4();
		nTurnHD += d6();
    }
    if (nTurnCheck < 0)
    {
        nTurnCheck = 0;
    }
    else if (nTurnCheck > 22)
    {
        nTurnCheck = 22;
    }
    //Determine the maximum HD of the undead that can be turned.
    nTurnLevel += (nTurnCheck + 2) / 3 - 4;
		
//	Jug_Debug(GetName(OBJECT_SELF) + " turn level " + IntToString(nTurnLevel) + " turn HD " + IntToString(nTurnHD));

    float fTotalChallenge;
	int nHDCount = 0;	
	location lMyLocation = GetLocation( OBJECT_SELF );
	float fSize = 2.0 * RADIUS_SIZE_COLOSSAL;
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fSize, lMyLocation, TRUE);	
	
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while( GetIsObjectValid(oTarget) && nHDCount < nTurnHD )
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
        {
            int nRacial = GetRacialType(oTarget);
            if (((nRacial == RACIAL_TYPE_UNDEAD) && !GetHasEffect(EFFECT_TYPE_TURNED, oTarget)) ||
                ((nRacial == RACIAL_TYPE_VERMIN) && (nVermin > 0)) ||
                ((nRacial == RACIAL_TYPE_ELEMENTAL) && (nElemental > 0)) ||
                ((nRacial == RACIAL_TYPE_CONSTRUCT) && (nConstructs > 0)) ||
                ((nRacial == RACIAL_TYPE_OUTSIDER) && (nOutsider > 0)))
			{
//				Jug_Debug(GetName(OBJECT_SELF) + " found undead " + GetName(oTarget) + " racial " + IntToString(nRacial));
				int nHD = GetHitDice(oTarget) + GetTurnResistanceHD(oTarget);
				if ((nHD <= nTurnLevel) && (nHD <= (nTurnHD - nHDCount)))
				{
//					Jug_Debug(GetName(OBJECT_SELF) + " adding found undead " + GetName(oTarget) + " racial " + IntToString(nRacial));
					float fCurChallenge;
					if (!(GetCreatureNegEffects(oTarget) & HENCH_EFFECT_DISABLED))
					{
						if (nRacial == RACIAL_TYPE_CONSTRUCT)
						{					
							fCurChallenge = GetThreatRating(oTarget) * CalculateDamageWeight(IntToFloat(2 * nTurnLevel), oTarget);
						}
						else if ((nClassLevel/2) >= nHD)
						{
							fCurChallenge = GetThreatRating(oTarget);
						}
						else
						{
							fCurChallenge = 0.9 * GetThreatRating(oTarget);
						}
					}
					if (GetIsEnemy(oTarget))
					{
						fTotalChallenge += fCurChallenge;
					}
					else if (GetAssociateType(oTarget) == ASSOCIATE_TYPE_SUMMONED)
					{
						// summons are expendable
						fTotalChallenge -= fCurChallenge;
					}
					else
					{
						// don't turn allies
						return;					
					}
					nHDCount += nHD;
				}
			}
        }
        //Select the next target within the spell shape.
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fSize, lMyLocation, TRUE);
    }
	
	fTotalChallenge *= gfAttackWeight;
	
//	Jug_Debug("****" + GetName(OBJECT_SELF) + " checking turn undead in weight " + FloatToString(fTotalChallenge));
	if (fTotalChallenge > gfAttackTargetWeight)
	{		
//		Jug_Debug("****" + GetName(OBJECT_SELF) + " putting turn undead in weight " + FloatToString(fTotalChallenge));				
		gfAttackTargetWeight = fTotalChallenge;		
		gsAttackTargetInfo = gsCurrentspInfo;
		gsAttackTargetInfo.oTarget = OBJECT_SELF;
	}	
}