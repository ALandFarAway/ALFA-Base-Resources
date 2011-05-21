//::///////////////////////////////////////////////
//:: Heal
//:: [NW_S0_Heal.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 12, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: Aug 1, 2001
//:: Update Pass By: Brock H. - OEI - 08/17/05
/*
	5.2.6.1.3	Heal
	This spell works differently now. Positive energy cures 10 damage per caster 
	level (maximum 150). It also removes the following conditions: ability damage, 
	blinded, confuse, dazzled, deafened, diseased, feebleminded, insanity, nausea, 
	poison, and stunned. [Note: some of these conditions may not exist in NWN. If the 
	condition doesn’t exist, just ignore during implementation.]

*/
// ChazM 5/15/07 - Now calls HealHarmTarget()


//#include "NW_I0_SPELLS"    
#include "x2_inc_spellhook" 
#include "nwn2_inc_spells"

void main()
{
	//SpawnScriptDebugger();

    if (!X2PreSpellCastCode())
    {
		// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }


	//Declare major variables
	object oCaster 	= OBJECT_SELF;
	object oTarget 	= GetSpellTargetObject();
	int 	nCasterLevel 	= GetCasterLevel( oCaster );
	
/*
    //Check to see if the target is an undead
    if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
    {
    	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)) //if the target is undead and hostile, or hardcore rules are on
    	{
			HarmTarget( oTarget, oCaster, SPELL_HEAL );
        }
		else //undead, even friendly ones, will never be healed by this spell
		{
			return;
		}
    }
    else
    {
		HealTarget( oTarget, oCaster, SPELL_HEAL );
	}
*/
	// Heal target will figure out if whether it needs to heal or harm
	int bIsHealingSpell = TRUE;
	int nSpellID = SPELL_HEAL;
	HealHarmTarget(oTarget, nCasterLevel, nSpellID, bIsHealingSpell );
	
	
}