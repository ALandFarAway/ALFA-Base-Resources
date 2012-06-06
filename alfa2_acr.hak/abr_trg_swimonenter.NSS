////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_trigger_i"
#include "acr_skills_i"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// Local trigger variable name: DC to swim in these waters.
const string ACR_SWIM_DC = "ACR_SWIM_DC";

// Local trigger variable name: Is there air above this body of water?
const string ACR_NO_AIR = "ACR_NO_AIR";

// Local trigger variable name: What is the difficulty of getting air?
const string ACR_NO_AIR_DC = "NO_AIR_DC";

// Local PC variable name: How long the PC has gone without air.
const string ACR_NO_AIR_FOR = "NO_AIR_FOR";

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


/*
 3500 = dwarf
 3501 = elf
 3502 = gnome
 3503 = halfling
 3504 = half elf
 3505 = half orc
 3506 = human
 3507 = aasimar
 3508 = tiefling
 3509 = sun elf
 3510 = wood elf
 3511 = drow
 3512 = svirfneblin
 3513 = gold dwarf
 3514 = duergar
 3515 = strongheart
 3516 = wild elf
 3517 = earth genasi
 3518 = fire genasi
 3519 = air genasi
 3520 = water genasi
 3521 = half drow
 3522 = yuanti
*/

void _SwimToWalk(object oPC)
{
    int nAppearance = GetAppearanceType(oPC);
    if(nAppearance < 3500)  return;
    if(nAppearance == 3500) nAppearance = 0;
    if(nAppearance == 3501) nAppearance = 1;
    if(nAppearance == 3502) nAppearance = 2;
    if(nAppearance == 3503) nAppearance = 3;
    if(nAppearance == 3504) nAppearance = 4;
    if(nAppearance == 3505) nAppearance = 5;
    if(nAppearance == 3506) nAppearance = 6;
    if(nAppearance == 3507) nAppearance = 563;
    if(nAppearance == 3508) nAppearance = 564;
    if(nAppearance == 3509) nAppearance = 565;
    if(nAppearance == 3510) nAppearance = 566;
    if(nAppearance == 3511) nAppearance = 567;
    if(nAppearance == 3512) nAppearance = 568;
    if(nAppearance == 3513) nAppearance = 569;
    if(nAppearance == 3514) nAppearance = 570;
    if(nAppearance == 3515) nAppearance = 571;
    if(nAppearance == 3516) nAppearance = 1036;
    if(nAppearance == 3517) nAppearance = 1037;
    if(nAppearance == 3518) nAppearance = 1038;
    if(nAppearance == 3519) nAppearance = 1039;
    if(nAppearance == 3520) nAppearance = 1040;
    if(nAppearance == 3521) nAppearance = 1041;
    if(nAppearance == 3522) nAppearance = 40;
    SetCreatureAppearanceType(oPC, nAppearance);
}

void _WalkToSwim(object oPC)
{
    int nAppearance = GetAppearanceType(oPC);
    if(nAppearance > 3499)  return;
    if(nAppearance == 0)    nAppearance = 3500;
    if(nAppearance == 1)    nAppearance = 3501;
    if(nAppearance == 2)    nAppearance = 3502;
    if(nAppearance == 3)    nAppearance = 3503;
    if(nAppearance == 4)    nAppearance = 3504;
    if(nAppearance == 5)    nAppearance = 3505;
    if(nAppearance == 6)    nAppearance = 3506;
    if(nAppearance == 563)  nAppearance = 3507;
    if(nAppearance == 564)  nAppearance = 3508;
    if(nAppearance == 565)  nAppearance = 3509;
    if(nAppearance == 566)  nAppearance = 3510;
    if(nAppearance == 567)  nAppearance = 3511;
    if(nAppearance == 568)  nAppearance = 3512;
    if(nAppearance == 569)  nAppearance = 3513;
    if(nAppearance == 570)  nAppearance = 3514;
    if(nAppearance == 571)  nAppearance = 3515;
    if(nAppearance == 1036) nAppearance = 3516;
    if(nAppearance == 1037) nAppearance = 3517;
    if(nAppearance == 1038) nAppearance = 3518;
    if(nAppearance == 1039) nAppearance = 3519;
    if(nAppearance == 1040) nAppearance = 3520;
    if(nAppearance == 1041) nAppearance = 3521;
    if(nAppearance == 40)   nAppearance = 3522;
    SetCreatureAppearanceType(oPC, nAppearance);
}

void _ProcessNoAir(object oPC)
{
	// Does the player have a metabolism?
    if(GetHasSpellEffect(SPELL_LIVING_UNDEATH) ||
       GetHasSpellEffect(SPELL_STONE_BODY) ||
       GetHasSpellEffect(SPELL_IRON_BODY) ||
       GetHasSpellEffect(SPELL_FLESH_TO_STONE))
    {
        SendMessageToPC(oPC, "You cannot breathe, but you also have no metabolism currently. If you do not find air before the spell expires, you will begin to suffocate.");
        return;
    }
	
	// Is the player otherwise immune to drowning?
	if ( GetHasSpellEffect( SPELL_WATER_BREATHING, oPC ) ) {
		SendMessageToPC( oPC, "Your transmutation allows you to breathe water, but if you do not find air before the spell expires, you will begin to suffocate." );
		return;
	}
	
    int nSuffocatingFor = GetLocalInt(oPC, ACR_NO_AIR_FOR) + 1;
    SetLocalInt(oPC, ACR_NO_AIR_FOR, nSuffocatingFor);
    if(nSuffocatingFor > (GetAbilityScore(oPC, ABILITY_CONSTITUTION) * 2))
    {
        int nCheckDC = GetLocalInt(oPC, ACR_NO_AIR_DC) + 1;
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
            SetLocalInt(oPC, ACR_NO_AIR_DC, nCheckDC);
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
    {
        _SwimToWalk(oPC);
        DeleteLocalInt(oPC, ACR_NO_AIR_DC);
        DeleteLocalInt(oPC, ACR_NO_AIR_FOR);
        return;
    }

    int nSwimDC = GetLocalInt(OBJECT_SELF, ACR_SWIM_DC);
    int nSinkDC = nSwimDC - 5;
    int bNoAir = GetLocalInt(OBJECT_SELF, ACR_NO_AIR);

    int nDice = d20(1);
    int nBonus = GetSkillRank(SKILL_SWIM, oPC);

    if(10 + nBonus <= nSwimDC)
    {
        // swimming is easy for this PC in this water. Take 10.
        nDice = 10;
    }
    int nFinal = nDice + nBonus;
	
    if(GetSubRace(oPC) != RACIAL_SUBTYPE_WATER_GENASI)
    {
        if(nDice < nSinkDC)
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

            if(bNoAir == FALSE)
            {
                DeleteLocalInt(oPC, ACR_NO_AIR_DC);
                DeleteLocalInt(oPC, ACR_NO_AIR_FOR);
            }
            else
            {
//=== Water breathing goes here-- we want to be able to reuse suffocation in other contexts ===//
                _ProcessNoAir(oPC);
            }
        }
        else
        {
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectMovementSpeedDecrease(50)), oPC);
            string sMessage = _FormatCheck("Swim", nDice, nBonus, GetName(oPC), nSwimDC);
            SendMessageToPC(oPC, sMessage);
            if(bNoAir == FALSE)
            {
                DeleteLocalInt(oPC, ACR_NO_AIR_DC);
                DeleteLocalInt(oPC, ACR_NO_AIR_FOR);
            }
            else
            {
//=== Water breathing goes here-- we want to be able to reuse suffocation in other contexts ===//
                _ProcessNoAir(oPC);
            }
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
    _WalkToSwim(oPC);
    _SwimHeartBeat(oPC);
}