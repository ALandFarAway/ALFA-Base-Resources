// gui_option_hench_change
/*
	Global option script for the character sheet behavior sub-panel
		Serverside copied for ALFA by AcadiusLost, to compile in gui_bhvr_inc debug fix
*/

#include "gui_bhvr_inc"

#include "hench_i0_assoc"


void HenchSetOption(int nCondition, int bNewState, object oPlayerObject, object oTargetObject, string sScreen)
{
	switch (nCondition)
	{
		case HENCH_OPTION_STEALTH:
			SetHenchOption(HENCH_OPTION_STEALTH, bNewState);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, -1, sHenchMonsterStealthOn);
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, -1, sHenchMonsterStealthOff);
			}
			break;
			
		case HENCH_OPTION_WANDER:
			SetHenchOption(HENCH_OPTION_WANDER, bNewState);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, -1, sHenchMonsterWanderOn);
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, -1, sHenchMonsterWanderOff);
			}
			break;
			
		case HENCH_OPTION_OPEN:
			SetHenchOption(HENCH_OPTION_OPEN, bNewState);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, -1, sHenchMonsterOpenOn);
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, -1, sHenchMonsterOpenOff);
			}
			break;
			
		case HENCH_OPTION_UNLOCK:
			SetHenchOption(HENCH_OPTION_UNLOCK, bNewState);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, -1, sHenchMonsterUnlockOn);
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, -1, sHenchMonsterUnlockOff);
			}
			break;
			
		case HENCH_OPTION_KNOCKDOWN_DISABLED:
			SetHenchOption(HENCH_OPTION_KNOCKDOWN_DISABLED, bNewState);
			SetHenchOption(HENCH_OPTION_KNOCKDOWN_SOMETIMES, FALSE);
			if (!bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, -1, sHenchKnockdownOn);
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, -1, sHenchKnockdownOff);
			}
			break;
		case HENCH_OPTION_KNOCKDOWN_SOMETIMES:		
			SetHenchOption(HENCH_OPTION_KNOCKDOWN_DISABLED, FALSE);
			SetHenchOption(HENCH_OPTION_KNOCKDOWN_SOMETIMES, TRUE);
			SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, -1, sHenchKnockdownSometimes);
			break;
			
		case HENCH_OPTION_DISABLE_AUTO_BEHAVIOR_SET:
			SetHenchOption(HENCH_OPTION_DISABLE_AUTO_BEHAVIOR_SET, bNewState);
			if (!bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, -1, sHenchAutoBehaviorSetOn);
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, -1, sHenchAutoBehaviorSetOff);
			}
			break;
			
		case HENCH_OPTION_ENABLE_AUTO_BUFF:
			SetHenchOption(HENCH_OPTION_ENABLE_AUTO_BUFF, bNewState);
			SetHenchOption(HENCH_OPTION_ENABLE_AUTO_MEDIUM_BUFF, FALSE);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, -1, sHenchAutoBuffLongOn);
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, -1, sHenchAutoBuffOff);
			}
			break;
			
		case HENCH_OPTION_ENABLE_AUTO_MEDIUM_BUFF:
			SetHenchOption(HENCH_OPTION_ENABLE_AUTO_BUFF, bNewState);
			SetHenchOption(HENCH_OPTION_ENABLE_AUTO_MEDIUM_BUFF, bNewState);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, -1, sHenchAutoBuffMedOn);
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, -1, sHenchAutoBuffOff);
			}
			break;
			
		case HENCH_OPTION_ENABLE_ITEM_CREATION:
			SetHenchOption(HENCH_OPTION_ENABLE_ITEM_CREATION, bNewState);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, -1, sHenchCreateItemsOn);
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, -1, sHenchCreateItemsOff);
			}
			break;
			
		case HENCH_OPTION_ENABLE_EQUIPPED_ITEM_USE:
			SetHenchOption(HENCH_OPTION_ENABLE_EQUIPPED_ITEM_USE, bNewState);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, -1, sHenchEquipppedItemsOn);
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, -1, sHenchEquipppedItemsOff);
			}
			break;

		case HENCH_OPTION_HIDEOUS_BLOW_INSTANT:
			SetHenchOption(HENCH_OPTION_HIDEOUS_BLOW_INSTANT, bNewState);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, -1, sHenchHideousBlowOn);
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, -1, sHenchHideousBlowOff);
			}
			break;

		case HENCH_OPTION_MONSTER_ALLY_DAMAGE:
			SetHenchOption(HENCH_OPTION_MONSTER_ALLY_DAMAGE, bNewState);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, -1, sHenchMonsterAllyDamageOn);
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, -1, sHenchMonsterAllyDamageOff);
			}
			break;
						
			default:
			PrettyError( "gui_bhvr_hench_change: Behavior " + IntToString( nCondition ) + " definition does not exist." );
	}
}


void main(int nCondition, int bNewState)
{
	object oPlayerObject = GetControlledCharacter(OBJECT_SELF);
	object oTargetObject;
	string sScreen;
	
	oTargetObject = oPlayerObject;
	sScreen = SCREEN_CHARACTER;
	
	HenchSetOption(nCondition, bNewState, oPlayerObject, oTargetObject, sScreen);
	HenchGuiBehaviorInit(oPlayerObject, oTargetObject, sScreen);
}