//::///////////////////////////////////////////////////////////////////////////
//::
//::	nw_s1_inspfrenzy.nss
//::
//::	This is the script for Frenzied Berserker feat Inspire Frenzy.
//::	Based largely off the script for the similar feat Frenzy.
//::
//::///////////////////////////////////////////////////////////////////////////
//::
//::	Created by: Brian Fox
//::	Created on: 7/11/06
//::
//::///////////////////////////////////////////////////////////////////////////
//:: AFW-OEI 08/07/2006: Inspire frenzy now lasts a fixed 2 rounds,
//::	and inflicts 12 points of damage per round.
//:: AFW-OEI 10/30/2006: Changed to 6 pts./rnd.
//:: RPGplayer1 12/29/2008: Limited frenzy to single area

#include "x2_i0_spells"
#include "nwn2_inc_spells"


void DoFrenzy( object oTarget, int nIncrease, float fDuration )
{
	// This is an immense hack to make the effect be created by the person going into the Frenzy;
	// the DoT effect causes you to become hostile to the effect creator, so to keep you from going
	// hostile to your own party, you must be the creator of the effect that damages you.
    effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, nIncrease);
    effect eAC = EffectACDecrease(4, AC_DODGE_BONUS);
    effect eDot = EffectDamageOverTime(6, RoundsToSeconds(1) - 0.5f, DAMAGE_TYPE_ALL);	// 6 points every round
    effect eDur = EffectVisualEffect( VFX_DUR_SPELL_RAGE );
    effect eAttackMod = EffectModifyAttacks(1);

    effect eLink = EffectLinkEffects(eStr, eAC);
    eLink = EffectLinkEffects(eLink, eDot);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eAttackMod);
	
    //Make effect extraordinary
    eLink = ExtraordinaryEffect(eLink);
	
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
	
	// Start the fatigue logic half a second before the frenzy ends
	DelayCommand(fDuration - 0.5f, ApplyFatigue(oTarget, 2, 0.6f));	// Fatigue duration is fixed to 2 rounds.
}

void main()
{
   //Declare major variables
    int nIncrease;
    int nSave;
	object oCaster = OBJECT_SELF;
	int nLevel = GetLevelByClass(CLASS_TYPE_FRENZIEDBERSERKER, oCaster);
	
//	if (!GetHasFeat(FEAT_GREATER_FRENZY, oCaster))
//	{
//	    nIncrease = 10;
//	}
//	else
	{
	    nIncrease = 6;
	}
	float fDuration = RoundsToSeconds(2);	// Fatigue duration fixed to 2 rounds
	
	object oFactionMember = GetFirstFactionMember( oCaster, FALSE );
	while ( GetIsObjectValid(oFactionMember) )
	{
    	if(!GetHasFeatEffect(FEAT_FRENZY_1, oFactionMember) && !GetIsDead(oFactionMember) &&
			GetArea(oFactionMember) == GetArea(oCaster) && //FIX: limit to single area
			oFactionMember != OBJECT_SELF )	// AFW-OEI 08/08/2006: Do not inspire frenzy on self.
	    {
	        PlayVoiceChat(VOICE_CHAT_BATTLECRY1, oFactionMember);
	        SignalEvent(oFactionMember, EventSpellCastAt(oCaster, GetSpellId(), FALSE));
	
	        //Apply the effects via the area, so that your companions don't go hostile on you.
			AssignCommand( oFactionMember, DoFrenzy(oFactionMember, nIncrease, fDuration) );

	    }
		oFactionMember = GetNextFactionMember( oCaster, FALSE );
	}
}