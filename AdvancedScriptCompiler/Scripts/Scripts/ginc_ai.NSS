//::///////////////////////////////////////////////////////////////////////////
//::
//::	ginc_ai
//::
//::	Include file for the multiple custom AI scripts dangling about.
//::
//::///////////////////////////////////////////////////////////////////////////
//   DBR 1/30/06
//   DBR 2/27/06 - DamageSwitch AI fabulousness
//   DBR 4/05/06 - Support for adding Spell Queue spells on the fly

#include "x2_inc_switches"
//#include "ginc_debug"	
#include "x0_i0_combat"

//void main() {}

	
//---------------------------------------CONSTANTS (DEFINES) ----------------------------------------------------	
	
const string VAR_NEXT_HANDLER = "HANDLER_INTERUPTED_";				//General Purpose defines
const string VAR_AP_BLOCKCOUNT = "AP_BLOCKCOUNT";					
const string SCRIPT_BLOCK_COUNTER = "gai_blockedcount_b";
const string VAR_AP_NUM_DAMAGERS = "AP_NUM_DAMAGERS";				//Attack Most Damaged By defines
const string VAR_AP_DAMAGER      = "AP_DAMAGER_";
const string VAR_AP_DAMAGER_PTS  = "AP_DAMAGER_DEALT_";
const string SCRIPT_DAMAGE_TRACKER = "gai_damagetracker_b";
const int ATTACK_PREFERENCE_STRONGEST 		= 1;					//Attack Preference defines
const int ATTACK_PREFERENCE_WEAKEST 		= 2;
const int ATTACK_PREFERENCE_GROUPATTACK 	= 3;
const int ATTACK_PREFERENCE_MOSTDAMAGEDBY 	= 4;
const int ATTACK_PREFERENCE_PROTECTOR 		= 5;
const int ATTACK_PREFERENCE_TANK 			= 6;
const int ATTACK_PREFERENCE_CLASS_PRIORITY	= 7;
const int ATTACK_PREFERENCE_AI_TYPE			= 8;
const string VAR_AP_NUM_PREF = "AP_NUM_PREFERANCES";
const string VAR_AP_PREF_PREFIX = "AP_PREFERANCE_";
const string VAR_AP_CHANCE_PREFIX = "AP_CHANCE_";
const string SCRIPT_PREFERENCE_DCR = "gai_preference_dcr";
const string VAR_AP_GROUP_TARGET = "AP_GROUP_ATTACK_TARGET";		//Attack in Group defines
const string SCRIPT_STAY_CLOSE 		= "gai_stayclose_b";			//Protector defines
const string VAR_P_PROXIMITY_COMBAT = "P_PROX_COMBAT";
const string VAR_P_PROXIMITY 		= "P_PROX_RUN";
const string VAR_P_PROXIMITY_RUN 	= "P_PROX";
const string VAR_P_GUARDTHIS		= "P_GUARD_THIS";
const string SCRIPT_FINITEPURSUIT_DCR = "gai_finitepursuit_dcr";	//Finite Pursuit defines
const string VAR_FP_MAXDIST = "FP_MAXIMUM_PURSUIT";
const string VAR_CS_COUNTERSPELL = "CS_COUNTERSPELL";				//Countercaster defines
const string VAR_CS_DISPEL       = "CS_DISPEL";
const string SCRIPT_COUNTERSPELL_DCR = "gai_counterspell_dcr";
const string SCRIPT_RUNNING_ALARM_DCR = "gai_runningalarm_dcr";		//RunningAlarm defines
const int AI_CLASS_TYPE_MELEE = 200;								//Attack Class Priority defines
const int AI_CLASS_TYPE_RANGED = 201;
const int AI_CLASS_TYPE_SPELLCASTERS = 202;
const string VAR_CP_ENTRY_PREFIX = "CP_ENTRY_";
const string VAR_CP_NUM_ENTRIES  = "CP_NUM_ENTRY";
const string SCRIPT_CLASS_PRIORITY_DCR  = SCRIPT_PREFERENCE_DCR;
const int AI_TYPE_RUNNING_ALARM = 1;								//Attack AI type Priority defines
const int AI_TYPE_COWARD		= 2;
const int AI_TYPE_PROTECTOR		= 3;
const int AI_TYPE_TANK			= 4;
const int AI_TYPE_COUNTER_CASTER= 5;
const int AI_TYPE_SPELL_QUEUE	= 6;
const int AI_TYPE_GROUP_ATTACK	= 7;
const string VAR_AIP_ENTRY_PREFIX = "AIP_ENTRY_";
const string VAR_AIP_NUM_ENTRIES  = "AIP_NUM_ENTRY";
const string SCRIPT_AI_PRIORITY_DCR  = SCRIPT_PREFERENCE_DCR;
const string sSPELL_QUEUE_ENTRY = "SPELL_QUEUE_";					//Spell Queue defines
const string sSPELL_QUEUE_TARGET_ENTRY = "SPELL_QUEUE_TARGET_";
const string sSPELL_QUEUE_NUM_CAST = "WHICH_SPELL_ON";
const string sSPELL_QUEUE_DCR_SCRIPT = SCRIPT_PREFERENCE_DCR;
const string sSPELL_QUEUE_ENTRY_CHEAT = "SPELL_QUEUE_CHEAT";		//cheat the spell, or cast it.
const string sSPELL_QUEUE_ENTRY_INSTANTCAST = "SPELL_QUEUE_INSTANTCAST"; // cast the spell without using the combat round.
const string sIGNORE_COMBAT_DCR = "gai_ignore_dcr";					//ignore combat AI stuff
const string VAR_DAMAGE_SWITCH_ON_STATE = "DAM_SWIT_ON";			//Damage Switch stuff
	
//-------------------------------PROTOTYPES---------------------------------------------------------------
	
void AIAssignDCR(object oTarget, string sScript);							//general purpose protos
int GetHealthPercent(object oTarget=OBJECT_SELF);
void AIContinueInterruptedScript(int nEvent);
void AIInterceptEventHandler(object oTarget, int nEvent, string sScript);
int GetIsAIType(object oTarget,int nAIType);
void AIRestoreInterruptedScript(object oTarget, int nEvent);	//restores interupted script to what is was, or original
void AIAttackPreference(object oFiend,int nAttack_Pref, int nChance=100);	//attack preference protos
void AIMakeTank(object oTank, int nChance = 100);							//tank protos
void AIMakeProtector(object oGuard, object oGuardee, int nChance=100, float fProx=6.0f, float fProxCombat=10.0f, float fProxRun=11.0f);	//protector protos
void AIFinitePursuit(object oAggro, float fMaxDist);						//finite pursuit protos
void AIMakeCounterCaster(object oCaster, int bCounterSpell, int bDispel);	//countercaster protos
void AIAttackInOrder(object oAttacker, int nClass);							//class priority protos
void AISpellQueueEnqueue(object oSpellCaster, int nSpell, string sTarget, int bCheat=FALSE, int bInstantCast = FALSE);	//spell queue protos
int AIGetIsSpellQueued(object oSpellCaster = OBJECT_SELF);
void AIResetType(object oSmartee);										//reset to normal AI
void AIIgnoreCombat(object oApathetic);		//do nothing in combat
void AIDamageSwitchEndStatement();			//damageswitch magic
void AITurnOnDamageSwitch(object oTarget=OBJECT_SELF);
void AITurnOffDamageSwitch(object oTarget=OBJECT_SELF);

//-------------------------------GENERAL PURPOSE AI FUNCTIONS---------------------------------------------

//returns an integer 0-100 (or theoretically more) of how much health oTarget has currently of their max
int GetHealthPercent(object oTarget=OBJECT_SELF)
{
	int nTotal=GetMaxHitPoints(oTarget);
	int nCurrent=GetCurrentHitPoints(oTarget);
	if (nCurrent==0)
		return 0;
	if (nCurrent==nTotal)
		return 100;
	return FloatToInt(  IntToFloat(nCurrent) / IntToFloat(nTotal) * 100.0f   );
}

//Assigns a custom DCR to a creature. Used to set custom behavior/AI during combat. DCR = DetermineCombatRound.
void AIAssignDCR(object oTarget, string sScript)
{
	SetCreatureOverrideAIScript(oTarget,sScript);
}	

//Used in a interupt script. When a creature's event handlers are intercepted with AIInterceptEventHandler(),
//  this must be called in the inserted script for the oriningal script to run. Can be chained/stacked.
void AIContinueInterruptedScript(int nEvent)
{
	string sTempStorage="",sCheck;
	int i=0;
	while((sCheck=GetLocalString(OBJECT_SELF,VAR_NEXT_HANDLER+IntToString(nEvent)+"_"+IntToString(++i)))!="")
		sTempStorage=sCheck;
	if (sTempStorage=="")
		return;
	i-=1;
	DeleteLocalString(OBJECT_SELF,VAR_NEXT_HANDLER+IntToString(nEvent)+"_"+IntToString(i));
	ExecuteScript(sTempStorage,OBJECT_SELF);
	SetLocalString(OBJECT_SELF,VAR_NEXT_HANDLER+IntToString(nEvent)+"_"+IntToString(i),sTempStorage);
}

//This hijacks a creature's (oTarget's) Event Handler and inserts a provided script.
// nEvent = CREATURE_SCRIPT_ON_ constant (nwscript.nss).
// sScript = Script to insert. This script must contain AIContinueInterruptedScript if the previous interupted scripts are to be run.
void AIInterceptEventHandler(object oTarget, int nEvent, string sScript)
{
	string sOld = GetEventHandler(oTarget,nEvent);
	if (sOld=="")//was no script there, so we just put ours there
	{		
		SetEventHandler(oTarget,nEvent,sScript);
		return;
	}
	int i=1;
	while(GetLocalString(oTarget,VAR_NEXT_HANDLER+IntToString(nEvent)+"_"+IntToString(i))!="")
		i++;
	SetLocalString(oTarget,VAR_NEXT_HANDLER+IntToString(nEvent)+"_"+IntToString(i),sOld);
	SetEventHandler(oTarget,nEvent,sScript);
}

void AIRestoreInterruptedScript(object oTarget,int nEvent)
{
	string sLast;
	int i=1;
	while(GetLocalString(oTarget,VAR_NEXT_HANDLER+IntToString(nEvent)+"_"+IntToString(i))!="")
		i++;
	sLast = GetLocalString(oTarget,VAR_NEXT_HANDLER+IntToString(nEvent)+"_"+IntToString(i-1));
	DeleteLocalString(oTarget,VAR_NEXT_HANDLER+IntToString(nEvent)+"_"+IntToString(i-1));
	SetEventHandler(oTarget,nEvent,sLast);
}

void AIResetType(object oSmartee)										//reset to normal AI
{
	string sDCR=GetLocalString(oSmartee,CREATURE_VAR_CUSTOM_AISCRIPT);
	AIAssignDCR(oSmartee,"");
	int nNumPref=GetLocalInt(oSmartee,VAR_AP_NUM_PREF);
	DeleteLocalInt(oSmartee,VAR_AP_NUM_PREF);
	int nType,i;
	for (i=1;i<=nNumPref;i++)
	{
		DeleteLocalInt(oSmartee,VAR_AP_PREF_PREFIX + IntToString(i));
		DeleteLocalInt(oSmartee,VAR_AP_CHANCE_PREFIX + IntToString(i));
	}
	while (GetEventHandler(oSmartee,CREATURE_SCRIPT_ON_DAMAGED)==SCRIPT_DAMAGE_TRACKER)	//restore from MostDamagedBy
		AIRestoreInterruptedScript(oSmartee,CREATURE_SCRIPT_ON_DAMAGED);	
	while (GetEventHandler(oSmartee,CREATURE_SCRIPT_ON_BLOCKED_BY_DOOR)==SCRIPT_BLOCK_COUNTER) //restore from Pref
		AIRestoreInterruptedScript(oSmartee,CREATURE_SCRIPT_ON_BLOCKED_BY_DOOR);	
	while (GetEventHandler(oSmartee,CREATURE_SCRIPT_ON_HEARTBEAT)==SCRIPT_STAY_CLOSE)
		AIRestoreInterruptedScript(oSmartee,CREATURE_SCRIPT_ON_HEARTBEAT);			//restore from the protector type	
	DeleteLocalInt(oSmartee,VAR_CP_NUM_ENTRIES);			//restore from class priority
	
	i=1;
	while (GetLocalString(oSmartee,sSPELL_QUEUE_TARGET_ENTRY+IntToString(i))!="")//restore from spell queue
	{
		DeleteLocalString(oSmartee,sSPELL_QUEUE_TARGET_ENTRY+IntToString(i));
		DeleteLocalInt(oSmartee,sSPELL_QUEUE_ENTRY+IntToString(i));
		i+=1;
	}
}

//Looks for the tell tale signs
int GetIsAIType(object oTarget,int nAIType)
{
	if (nAIType==AI_TYPE_RUNNING_ALARM)
	{
		if (GetLocalString(oTarget,CREATURE_VAR_CUSTOM_AISCRIPT)==SCRIPT_RUNNING_ALARM_DCR)		
			return TRUE;
	}
	else if (nAIType==AI_TYPE_COWARD)
	{
		if (GetCombatCondition(X0_COMBAT_FLAG_COWARDLY,oTarget))
			return TRUE;
	}
	else if (nAIType==AI_TYPE_PROTECTOR)
	{
		if (GetEventHandler(oTarget,CREATURE_SCRIPT_ON_HEARTBEAT)==SCRIPT_STAY_CLOSE)
			return TRUE;
	}
	else if (nAIType==AI_TYPE_TANK)
	{
		int nNumPreferences=GetLocalInt(oTarget,VAR_AP_NUM_PREF);
		int i,nPref;
		for (i=1;i<=nNumPreferences;i++)
			if (GetLocalInt(oTarget,VAR_AP_PREF_PREFIX + IntToString(i))==ATTACK_PREFERENCE_TANK)
				return TRUE;
	}
	else if (nAIType==AI_TYPE_COUNTER_CASTER)
	{
		if (GetLocalString(oTarget,CREATURE_VAR_CUSTOM_AISCRIPT)==SCRIPT_COUNTERSPELL_DCR)
			return TRUE;
	}
	else if (nAIType==AI_TYPE_SPELL_QUEUE)
	{
		if (GetLocalString(oTarget,sSPELL_QUEUE_TARGET_ENTRY+IntToString(1))!="")
			return TRUE;
	}
	else if (nAIType==AI_TYPE_GROUP_ATTACK)
	{
		int nNumPreferences=GetLocalInt(oTarget,VAR_AP_NUM_PREF);
		int i,nPref;
		for (i=1;i<=nNumPreferences;i++)
			if (GetLocalInt(oTarget,VAR_AP_PREF_PREFIX + IntToString(i))==ATTACK_PREFERENCE_GROUPATTACK)
				return TRUE;		
	}
	return FALSE;
}

//---------------------------------ATTACK PREFERANCE AI SPECIFIC-----------------------------------------

//Sets an attack preference on a creature (oFiend). oFiend will use the AI type nAttack_Pref.
// nAttack_Pref's (see ATTACK_PREFERENCE_ constant list) can be mixed and matched using nChance.
// nChance is the probability out of 100 that nAttack_Pref is chosen. If the chances of all assigned
// attack preferences is less than 100, the remainder is used as a chance for a normal DetermineCombatRound().
// Examples:
//      AttackPref( me , ATTACK_PREFERENCE_STRONGEST,  60 );
//  this makes a creature 60% likely to attack the strongest, 40% likely to do a standard combat round.
//      AttackPref( me , ATTACK_PREFERENCE_MOSTDAMAGEDBY, 80 );
//      AttackPref( me , ATTACK_PREFERENCE_GROUPATTACK,   10 );
//		AttackPref( me , ATTACK_PREFERENCE_WEAKEST         7 );
// this makes a creature 80% likely to attack who most damaged them, 10% likely to attack with their group, 7% likely to attack the weakest around, and 3% likely for a Standard DCR.
//		AttackPref( me , ATTACK_PREFERENCE_TANK);
// this makes the creaure always use the Tank DCR. no chance for a Standard DCR (Cause nChance defaults to 100)
void AIAttackPreference(object oFiend,int nAttack_Pref, int nChance=100)
{
	int nNumPreferences=GetLocalInt(oFiend,VAR_AP_NUM_PREF)+1;
	SetLocalInt(oFiend,VAR_AP_NUM_PREF,nNumPreferences);
	SetLocalInt(oFiend,VAR_AP_PREF_PREFIX + IntToString(nNumPreferences), nAttack_Pref);
	SetLocalInt(oFiend,VAR_AP_CHANCE_PREFIX + IntToString(nNumPreferences), nChance);

	AIAssignDCR(oFiend,SCRIPT_PREFERENCE_DCR);//set up special DetermineCombatRound for these AI's

	//special cases require extra work
	if (nAttack_Pref==ATTACK_PREFERENCE_MOSTDAMAGEDBY)//means we gotta keep track who hurt me the most
		if (GetEventHandler(oFiend,CREATURE_SCRIPT_ON_DAMAGED)!=SCRIPT_DAMAGE_TRACKER)
			AIInterceptEventHandler(oFiend,CREATURE_SCRIPT_ON_DAMAGED,SCRIPT_DAMAGE_TRACKER);	
	//if ((nAttack_Pref==ATTACK_PREFERENCE_PROTECTOR)||(nAttack_Pref==ATTACK_PREFERENCE_TANK))
	if (nNumPreferences==1)
		AIInterceptEventHandler(oFiend,CREATURE_SCRIPT_ON_BLOCKED_BY_DOOR,SCRIPT_BLOCK_COUNTER);	
}

//---------------------------------TANK SPECIFIC---------------------------------------------------------

//Makes oTank use the speical AI DCR for Defensice tanks. Plugs into the Attack Preference system and can be mixed with
//	other AI's using the nChance system.
//Tanks will do the following in order:
//		1: heal self (potions, spells) if health is below 1/2.
//		2: if any friendly spellcaster nearby is being attacked, try to divert the attention by attacking them.
//		3: rule 1, but with clerics. and then with rangers. and then with any class.
//		4: use improved expertise, expertise, or parry.
void AIMakeTank(object oTank, int nChance = 100)
{
	AIAttackPreference(oTank,ATTACK_PREFERENCE_TANK,nChance);		
}	
	
//---------------------------------PRTOECTOR SPECIFIC----------------------------------------------------

//Makes oGuard a protector. Protectors will stay close to oGuardee, and attack anyone who is trying to damage them, or may
//		be about to damage them.
// Plugs in with Attack Preference, and can be used with other Attack Preferences using the nChance system.
// fProx = how close oGuard will try to stay to oGuardee.
// fProxCombat = how close oGuard will try to stay to oGuardee when they are in combat.
// fProxRun = when oGuard gets this distance away from oGuardee, he will run to oGuardee instead of walk. In combat, this
//		param is not used, and oGuard will always run to oGuardee when fProxCombat distance is exceeeded.
void AIMakeProtector(object oGuard, object oGuardee, int nChance=100, float fProx=6.0f, float fProxCombat=10.0f, float fProxRun=11.0f)
{
	SetLocalObject(oGuard,VAR_P_GUARDTHIS,oGuardee);
	SetLocalFloat(oGuard,VAR_P_PROXIMITY, fProx);
	SetLocalFloat(oGuard,VAR_P_PROXIMITY_COMBAT, fProxCombat);
	SetLocalFloat(oGuard,VAR_P_PROXIMITY_RUN, fProxRun);

	AIAttackPreference(oGuard,ATTACK_PREFERENCE_PROTECTOR,nChance);

	AIInterceptEventHandler(oGuard,CREATURE_SCRIPT_ON_HEARTBEAT,SCRIPT_STAY_CLOSE);//set up the stayclose hb	
}


//---------------------------------FINITE PURSUIT AI SPECIFIC--------------------------------------------

//Sets a creature to limit how far they wander/stray to attack enemies. "Break off pursuit"
void AIFinitePursuit(object oAggro, float fMaxDist)
{
	SetLocalFloat(oAggro,VAR_FP_MAXDIST,fMaxDist);
	AIAssignDCR(oAggro,SCRIPT_FINITEPURSUIT_DCR);
}

//---------------------------------COUNTERSPELL AI SPECIFIC----------------------------------------------

//Makes oCaster a counter-caster. Countercasters debuff enemies and have counterspell mode on otherwise.
// if bCounterSpell == 1, Counterspell mode is turned on. *NOT WORKING CURRENTLY. SADNESS*
// if bDispel == 1, oCaster will cast any Dispel spells on enemies with buffs.
void AIMakeCounterCaster(object oCaster, int bCounterSpell, int bDispel)
{
	if (bCounterSpell)
		SetLocalInt(oCaster,VAR_CS_COUNTERSPELL,1);
	if (bDispel)
		SetLocalInt(oCaster,VAR_CS_DISPEL,1);
	AIAssignDCR(oCaster,SCRIPT_COUNTERSPELL_DCR);
}


//---------------------------------CLASS PRIORITY AI SPECIFIC---------------------------------------------

//Used to set a list of classes I want to fight in order. Can be called several times in succession to form a list
//nClass = CLASS_TYPE_ constant.
void AIAttackInOrder(object oAttacker, int nClass)
{
	int nNumEntries = GetLocalInt(oAttacker,VAR_CP_NUM_ENTRIES)+1;
	SetLocalInt(oAttacker,VAR_CP_NUM_ENTRIES,nNumEntries);
	SetLocalInt(oAttacker,VAR_CP_ENTRY_PREFIX+IntToString(nNumEntries),nClass);
	
	if (nNumEntries==1)
		AIAssignDCR(oAttacker,SCRIPT_CLASS_PRIORITY_DCR);
}


//---------------------------------SPELL QUEUE AI SPECIFIC---------------------------------------------



//Used to enqueue spells with the specialty DCR. Meant to be called several times in succession to form a list
//nSpell = SPELL_ constant
//sTarget = tag of target, or "$PC",  "$ENEMY",   "$FRIEND",   "$SELF"
//bCheat = TRUE if caster ignores restrictions and rules and just casts no matter what
//bInstant = TRUE if the player casts the spell immediately "for free" without costing a combat round.  Just like the ActionCastSpell*() parameter.
void AISpellQueueEnqueue(object oSpellCaster, int nSpell, string sTarget, int bCheat = FALSE, int bInstantCast = FALSE)
{
	int nWhichEntry=GetLocalInt(oSpellCaster,sSPELL_QUEUE_NUM_CAST);//Which spell am I on?
	int index=nWhichEntry+1;
	while (GetLocalString(oSpellCaster,sSPELL_QUEUE_TARGET_ENTRY+IntToString(index))!="")//find next index
		index+=1;

	SetLocalInt(oSpellCaster,sSPELL_QUEUE_ENTRY+IntToString(index),nSpell);
	SetLocalString(oSpellCaster,sSPELL_QUEUE_TARGET_ENTRY+IntToString(index),sTarget);
	SetLocalInt(oSpellCaster,sSPELL_QUEUE_ENTRY_CHEAT+IntToString(index),bCheat);
	SetLocalInt(oSpellCaster,sSPELL_QUEUE_ENTRY_INSTANTCAST+IntToString(index),bInstantCast);

	if (index==1)//this is the first time I've been enqueued. Make sure I have the AI setup.
		SetCreatureOverrideAIScript(oSpellCaster,sSPELL_QUEUE_DCR_SCRIPT);
}
	
int AIGetIsSpellQueued(object oSpellCaster = OBJECT_SELF)
{
	int nWhichEntry=GetLocalInt(oSpellCaster,sSPELL_QUEUE_NUM_CAST)+1;//Which spell am I on?
	string sTarget = GetLocalString(oSpellCaster,sSPELL_QUEUE_TARGET_ENTRY+IntToString(nWhichEntry));
	if (sTarget=="") //see if we are out of spells queued up
		return FALSE;
	return TRUE;
}


//----------------------------------DO NOTHING! AI TYPE-------------------------------------------------------

void AIIgnoreCombat(object oApathetic)
{
	AIAssignDCR(oApathetic,sIGNORE_COMBAT_DCR);	
}

//-----------------------------------DAMAGE SWITCH AI TYPE-----------------------------------------------------

void AITurnOnDamageSwitch(object oTarget=OBJECT_SELF)
{
	if (GetLocalInt(oTarget,VAR_DAMAGE_SWITCH_ON_STATE)==1)
		return;
	SetLocalInt(oTarget,VAR_DAMAGE_SWITCH_ON_STATE,1);
	AIInterceptEventHandler(oTarget,CREATURE_SCRIPT_ON_DAMAGED,GetLocalString(oTarget,"SpawnScript"));	
}

void AITurnOffDamageSwitch(object oTarget=OBJECT_SELF)
{
	SetLocalInt(oTarget,VAR_DAMAGE_SWITCH_ON_STATE,-1);
}


void AIDamageSwitchEndStatement()
{
	int nOn=GetLocalInt(OBJECT_SELF,VAR_DAMAGE_SWITCH_ON_STATE);//make sure DamageSwitch event is captured
	if (nOn==0)		//first inital call, before damage was dealt
	{
		AITurnOnDamageSwitch();
		return;
	}
	if (nOn==-1)	//I am being turned off
	{
		AIContinueInterruptedScript(CREATURE_SCRIPT_ON_DAMAGED);
		AIRestoreInterruptedScript(OBJECT_SELF,CREATURE_SCRIPT_ON_DAMAGED);
		DeleteLocalInt(OBJECT_SELF,VAR_DAMAGE_SWITCH_ON_STATE);
		return;
	}
	//otherwise, just continue through to the damaged script.	
	AIContinueInterruptedScript(CREATURE_SCRIPT_ON_DAMAGED);
}


//----------------------------------------AI PREFERENCE ATTACK TYPE--------------------------------------------


//Used to set a list of AI types I want to fight in order. Can be called several times in succession to form a list
//nAI = AI_TYPE_ constant.
void AIAttackTypeInOrder(object oAttacker, int nAI)
{
	int nNumEntries = GetLocalInt(oAttacker,VAR_AIP_NUM_ENTRIES)+1;
	SetLocalInt(oAttacker,VAR_AIP_NUM_ENTRIES,nNumEntries);
	SetLocalInt(oAttacker,VAR_AIP_ENTRY_PREFIX+IntToString(nNumEntries),nAI);
	
	if (nNumEntries==1)
		AIAssignDCR(oAttacker,SCRIPT_AI_PRIORITY_DCR);
}
