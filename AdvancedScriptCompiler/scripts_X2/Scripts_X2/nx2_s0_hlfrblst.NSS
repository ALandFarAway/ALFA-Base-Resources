//::///////////////////////////////////////////////
//:: Hellfire Blast
//:: nx2_s0_hlfrblst
//:: Copyright (c)  2008 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
    Hellfire Warlock can turn on Hellfire Blast
	to get 2*HellfireWarlockLevel d6 bonus to all
	Eldritch Blasts. This spell cast once will 
	turn all eldritch blasts into Hellfire Blasts
	until cast again, which will turn it off.
*/
//:://////////////////////////////////////////////
//:: Created By: Justin Reynard (JWR-OEI)
//:: Created On: 06/18/2008
//:://////////////////////////////////////////////


#include "nw_i0_invocatns"

const int STRREF_HELLFIRE_GO 	= 220794;
const int STRREF_HELLFIRE_STOP  = 220795;

// THUNDERCATS HOOOOOOOOOOO!
void HellfirePowersGo(int nString)
{
	string sLocalizedText = GetStringByStrRef( nString );
	string sDiceBonus = " ("+IntToString(GetHellfireBlastDiceBonus())+"d6)";
	string sName = GetName( OBJECT_SELF );
	string sHellfireFeedbackMsg = "<c=tomato>" + sName + sLocalizedText + " </c>";
	if (nString == STRREF_HELLFIRE_STOP)
		sHellfireFeedbackMsg +  sDiceBonus;
	SendMessageToPC( OBJECT_SELF, sHellfireFeedbackMsg );
}

void main() 
{
	object oTarget = GetSpellTargetObject();
	int nCurrCon = GetAbilityScore( oTarget, ABILITY_CONSTITUTION );
	// if feat is active, turn it off
	//if ( GetHasFeatEffect(FEAT_HELLFIRE_BLAST) == TRUE )
	if ( IsHellfireBlastActive(oTarget) )
	{
		// this won't remove the CON down because they're not attached
		// to the hlfrblst spell ID
		RemoveEffectsFromSpell(oTarget, SPELLABILITY_HELLFIRE_BLAST);
		HellfirePowersGo(STRREF_HELLFIRE_STOP);
	}
	// else turn it on!
	else 
	{	
		if ( nCurrCon > 0 )
		{
			SignalEvent(oTarget, EventSpellCastAt(oTarget, SPELLABILITY_HELLFIRE_BLAST, FALSE));
			effect e = EffectHellfireBlast();
			//	effect evfx = EffectVisualEffect(VFX_AURA_BLADE_BARRIER);
			FloatingTextStringOnCreature("NEEDS VISUAL EFFECT", oTarget);
			//	effect eLink = EffectLinkEffects(evfx, e);
			e = SetEffectSpellId(e, SPELLABILITY_HELLFIRE_BLAST);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, e , oTarget);
			HellfirePowersGo(STRREF_HELLFIRE_GO);
		}
		else
		{
			ConTooLow(STRREF_HELLFIRE_BLAST_NAME);
		}
	}


}