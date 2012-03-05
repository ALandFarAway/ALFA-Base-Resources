////////////////////////////////////////////////////////////////////////////////
//
//  System Name : 
//     Filename : 
//    $Revision:: 
//        $Date:: 
//       Author : 
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_trigger_i"
#include "acr_skills_i"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// The main event handler.
void main();

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void _ProcessNoAir(object oPC)
{
	if(GetHasSpellEffect(SPELL_LIVING_UNDEATH) ||
	   GetHasSpellEffect(SPELL_STONE_BODY) ||
	   GetHasSpellEffect(SPELL_IRON_BODY) ||
	   GetHasSpellEffect(SPELL_FLESH_TO_STONE))
	{
		SendMessageToPC(oPC, "You cannot breathe, but you also have no metabolism currently. If you do not find air before the spell expires, you will begin to suffocate.");
		return;
	}
		
	int nSuffocatingFor = GetLocalInt(oPC, "NO_AIR_FOR") + 1;
	SetLocalInt(oPC, "NO_AIR_FOR", nSuffocatingFor);
	if(nSuffocatingFor > (GetAbilityScore(oPC, ABILITY_CONSTITUTION) * 2))
	{
		int nCheckDC = GetLocalInt(oPC, "NO_AIR_DC") + 1;
		if(nCheckDC < 10)
		    nCheckDC = 10;
		int nConCheck = d20();
		int nConMod   = GetAbilityModifier(ABILITY_CONSTITUTION, oPC);
		if((nConCheck + nConMod) < nCheckDC)
		{
			int nDamage = 0;
			int nHP = GetCurrentHitPoints(oPC);
			string sMessage = _FormatCheck("Constitution", nConCheck, nConMod, GetName(oPC), nCheckDC);
			string sMessage2;
			if(nHP > 1)
			{
				nDamage = GetCurrentHitPoints(oPC) - 1;
				sMessage2 = "You're suffocating! If you don't find water NOW, you will DIE!";
			}
			else if(nHP > 0)
			{
				nDamage = 2;
				sMessage2 = "You've lost consciousness. Unless someone comes to rescue you, you will die.";
			}
			else
			{
				nDamage = 10;
				sMessage2 = "You have suffocated.";
			}
			ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamage), oPC);
			SendMessageToPC(oPC, sMessage);
			SendMessageToPC(oPC, sMessage2);
			return;
		}
		else
		{
			SetLocalInt(oPC, "NO_AIR_DC", nCheckDC);
			SendMessageToPC(oPC, "You're barely clutching to consciousness! Get to air NOW!");
			return;
		}
	}
	else
	{
		int nSecondsLeft = ((GetAbilityScore(oPC, ABILITY_CONSTITUTION) * 2) - nSuffocatingFor) * 6;
		if(nSecondsLeft > 60)
		{
			SendMessageToPC(oPC, "You can hold your breath for "+IntToString(nSecondsLeft)+" more seconds.");
			return;
		}
		else if(nSecondsLeft > 30)
		{
			SendMessageToPC(oPC, "Careful! You can hold your breath for only "+IntToString(nSecondsLeft)+" more seconds!");
			return;
		}
		else
		{
			SendMessageToPC(oPC, "If you don't find breathable air within "+IntToString(nSecondsLeft)+" seconds, you will DIE!");
			return;
		}
	}
}

void _SwimHeartBeat(object oPC)
{
	effect eEffect = GetFirstEffect(oPC);
	while(GetIsEffectValid(eEffect))
	{
		if(GetEffectCreator(eEffect) == OBJECT_SELF)
			RemoveEffect(oPC, eEffect);
		eEffect = GetNextEffect(oPC);
	}
	
	int bProceed = FALSE;
	object oCreature = GetFirstInPersistentObject();
	while(GetIsObjectValid(oCreature))
	{
		if(oCreature == oPC)
			bProceed = TRUE;
		oCreature = GetNextInPersistentObject();
	}

	if(bProceed == FALSE)
		return;

	int nSwimDC = GetLocalInt(OBJECT_SELF, "ACR_SWIM_DC");
	int nSinkDC = nSwimDC - 5;
    int bAirOverhead = GetLocalInt(OBJECT_SELF, "ACR_IS_AIR");

    int nDice = d20(1);
    int nBonus = GetSkillRank(SKILL_SWIM, oPC);
	int nFinal = nDice + nBonus;
	
	if(GetSubRace(oPC) != RACIAL_SUBTYPE_WATER_GENASI)
	{
	    if(nDice < nSinkDC && bAirOverhead == FALSE)
		{
		    ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectMovementSpeedDecrease(75)), oPC);
			string sMessage = _FormatCheck("Swim", nDice, nBonus, GetName(oPC), nSinkDC);
			
//=== Water breathing goes here-- we want to be able to reuse suffocation in other contexts ===//
			_ProcessNoAir(oPC);
			SendMessageToPC(oPC, sMessage);
			
		}
	    else if(nDice < nSwimDC)
		{
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectMovementSpeedDecrease(75)), oPC);
			string sMessage = _FormatCheck("Swim", nDice, nBonus, GetName(oPC), nSwimDC);
			SendMessageToPC(oPC, "You struggle to move through the water.");
			SendMessageToPC(oPC, sMessage);
			
			DeleteLocalInt(oPC, "NO_AIR_DC");
			DeleteLocalInt(oPC, "NO_AIR_FOR");
		}
		else
		{
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectMovementSpeedDecrease(50)), oPC);
			string sMessage = _FormatCheck("Swim", nDice, nBonus, GetName(oPC), nSwimDC);
			SendMessageToPC(oPC, sMessage);	
		}
	}
	else
	{
		SendMessageToPC(oPC, "Your swim speed and capacity to breathe water allows you to move easily through the water.");
		return;
	}
	DelayCommand(6.0f, _SwimHeartBeat(oPC));
}

void main() 
{
    ACR_TriggerOnEnter();

    object oPC = GetEnteringObject();
	_SwimHeartBeat(oPC);
}