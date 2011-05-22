// gui_party_hench_change
/*
	Party behavior script for the character sheet behavior sub-panel
*/

#include "gui_bhvr_inc"

#include "hench_i0_assoc"


void HenchSetPartyOption(int nCondition, int bNewState, object oPlayerObject)
{
	switch (nCondition)
	{
		case HENCH_PARTY_UNEQUIP_WEAPONS:
			SetHenchPartyState(HENCH_PARTY_UNEQUIP_WEAPONS, bNewState, oPlayerObject);
			if (!bNewState)
			{
				SetGUIObjectText(oPlayerObject, SCREEN_CHARACTER, BEHAVIORDESC_TEXT, -1, sHenchUnequipWeaponsOff);
			}
			else
			{
				SetGUIObjectText(oPlayerObject, SCREEN_CHARACTER, BEHAVIORDESC_TEXT, -1, sHenchUnequipWeaponsOn);
			}
			break;
		case HENCH_PARTY_SUMMON_FAMILIARS:
			SetHenchPartyState(HENCH_PARTY_SUMMON_FAMILIARS, bNewState, oPlayerObject);
			if (!bNewState)
			{
				SetGUIObjectText(oPlayerObject, SCREEN_CHARACTER, BEHAVIORDESC_TEXT, -1, sHenchSummonFamiliarsOff);
			}
			else
			{
				SetGUIObjectText(oPlayerObject, SCREEN_CHARACTER, BEHAVIORDESC_TEXT, -1, sHenchSummonFamiliarsOn);
			}
			break;
		case HENCH_PARTY_SUMMON_COMPANIONS:
			SetHenchPartyState(HENCH_PARTY_SUMMON_COMPANIONS, bNewState, oPlayerObject);
			if (!bNewState)
			{
				SetGUIObjectText(oPlayerObject, SCREEN_CHARACTER, BEHAVIORDESC_TEXT, -1, sHenchSummonCompanionsOff);
			}
			else
			{
				SetGUIObjectText(oPlayerObject, SCREEN_CHARACTER, BEHAVIORDESC_TEXT, -1, sHenchSummonCompanionsOn);
			}
			break;
			
		case HENCH_PARTY_LOW_ALLY_DAMAGE:			
			SetHenchPartyState(HENCH_PARTY_LOW_ALLY_DAMAGE, TRUE, oPlayerObject);
			SetHenchPartyState(HENCH_PARTY_MEDIUM_ALLY_DAMAGE, FALSE, oPlayerObject);
			SetHenchPartyState(HENCH_PARTY_HIGH_ALLY_DAMAGE, FALSE, oPlayerObject);
			SetGUIObjectText(oPlayerObject, SCREEN_CHARACTER, BEHAVIORDESC_TEXT, -1, sHenchAllyDamageLow);
			break;

		case HENCH_PARTY_MEDIUM_ALLY_DAMAGE:			
			SetHenchPartyState(HENCH_PARTY_LOW_ALLY_DAMAGE, FALSE, oPlayerObject);
			SetHenchPartyState(HENCH_PARTY_MEDIUM_ALLY_DAMAGE, TRUE, oPlayerObject);
			SetHenchPartyState(HENCH_PARTY_HIGH_ALLY_DAMAGE, FALSE, oPlayerObject);
			SetGUIObjectText(oPlayerObject, SCREEN_CHARACTER, BEHAVIORDESC_TEXT, -1, sHenchAllyDamageMed);
			break;

		case HENCH_PARTY_HIGH_ALLY_DAMAGE:			
			SetHenchPartyState(HENCH_PARTY_LOW_ALLY_DAMAGE, FALSE, oPlayerObject);
			SetHenchPartyState(HENCH_PARTY_MEDIUM_ALLY_DAMAGE, FALSE, oPlayerObject);
			SetHenchPartyState(HENCH_PARTY_HIGH_ALLY_DAMAGE, TRUE, oPlayerObject);
			SetGUIObjectText(oPlayerObject, SCREEN_CHARACTER, BEHAVIORDESC_TEXT, -1, sHenchAllyDamageHigh);
			break;

		case HENCH_PARTY_DISABLE_PEACEFUL_MODE:
			SetHenchPartyState(HENCH_PARTY_DISABLE_PEACEFUL_MODE, bNewState, oPlayerObject);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, SCREEN_CHARACTER, BEHAVIORDESC_TEXT, -1, sHenchPeacefulFollowOff);
			}
			else
			{
				SetGUIObjectText(oPlayerObject, SCREEN_CHARACTER, BEHAVIORDESC_TEXT, -1, sHenchPeacefulFollowOn);
			}
			break;

		case HENCH_PARTY_DISABLE_SELF_HEAL_OR_BUFF:
			SetHenchPartyState(HENCH_PARTY_DISABLE_SELF_HEAL_OR_BUFF, bNewState, oPlayerObject);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, SCREEN_CHARACTER, BEHAVIORDESC_TEXT, -1, sHenchSelfBuffOrHealOff);
			}
			else
			{
				SetGUIObjectText(oPlayerObject, SCREEN_CHARACTER, BEHAVIORDESC_TEXT, -1, sHenchSelfBuffOrHealOn);
			}
			break;

		default:
			PrettyError( "gui_party_hench_change: Behavior " + IntToString( nCondition ) + " definition does not exist." );
	}	

}


void main(int nCondition, int bNewState)
{
	object oPlayerObject = GetControlledCharacter(OBJECT_SELF);
	// PrettyError( "gui_bhvr_hench_change." );
			
	HenchSetPartyOption(nCondition, bNewState, oPlayerObject);
}