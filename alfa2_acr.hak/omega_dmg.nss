////////////////////////////////////////////////////////////////////////////////
//
//                     Wynna			9/18/2008   
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////


#include "acr_spawn_i"

void main()
{
    object oDM = OBJECT_SELF;
	object oObject = GetLocalObject(oDM, "Object_Target");
	int nDamage = GetLocalInt(oDM, "DM_Damage");
	effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_DIVINE, DAMAGE_POWER_NORMAL, TRUE);
	int nKnockdown = GetLocalInt(oDM, "DM_Knockdown");
	int nDaze = GetLocalInt(oDM, "DM_Daze");
	int nSleep = GetLocalInt(oDM, "DM_Sleep");
	int nParalyze = GetLocalInt(oDM, "DM_Paralyze");
	int nTrap = GetLocalInt(oDM, "DM_Trap");
	int nQuake = GetLocalInt(oDM, "DM_Quake");
	int nJumpQ = GetLocalInt(oDM, "DM_Jump_Q");
	int nJumpAdmin = GetLocalInt(oDM, "DM_Jump_Admin");
	effect eKnockdown = EffectKnockdown();
	effect eDaze = EffectDazed();
	effect eSleep = EffectSleep();
	effect eParalyze = EffectParalyze(50, SAVING_THROW_WILL, FALSE);
	effect eShake = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);
	effect eQuake = EffectVisualEffect(VFX_SPELL_HIT_EARTHQUAKE);
	
	object oQ = GetWaypointByTag("acr_quarantine_wp");
	object oAdmin = GetWaypointByTag("acr_admin_wp");
	
	
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oObject);
	SetLocalInt(oDM, "DM_Damage", 0);
	
	
	if(nKnockdown == 1)
		{ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oObject, 3.0);
		 SetLocalInt(oDM, "DM_Knockdown", 0);
		 }
	if(nDaze == 1)
		{ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDaze, oObject, 10.0);
		 SetLocalInt(oDM, "DM_Daze", 0);
		 }
	if(nSleep == 1)
		{ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSleep, oObject, 30.0);
		 SetLocalInt(oDM, "DM_Sleep", 0);
		 }
	if(nSleep == 2)
		{ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSleep, oObject, 300.0);
		 SetLocalInt(oDM, "DM_Sleep", 0);
		 }
	if(nParalyze == 1)
		{SetLocalInt(oObject, "Paralyzed", 1);
		 DelayCommand(60.0, SetLocalInt(oObject, "Paralyzed", 0));
		 ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eParalyze, oObject, 60.0);
		 SetLocalInt(oDM, "DM_Paralyze", 0);
		 }
	if(nParalyze == 2)
		 {SetLocalInt(oObject, "Paralyzed", 1);
		 DelayCommand(300.0, SetLocalInt(oObject, "Paralyzed", 0));
		 ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oObject, 300.0);
		 SetLocalInt(oDM, "DM_Paralyze", 0);
		 }
	if(nParalyze == 3)
		{if(GetLocalInt(oObject, "Paralyzed") == 0)
			{SetLocalInt(oObject, "Paralyzed", 1);
			 ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oObject, 36000.0);
			 }
		 else if(GetLocalInt(oObject, "Paralyzed") == 1)
			{SetLocalInt(oObject, "Paralyzed", 0);
			 RemoveEffect(oObject, eKnockdown);
			 if(GetIsPC(oObject) != TRUE)
			 	{int iHealth = GetCurrentHitPoints(oObject);
				 int iHP = GetMaxHitPoints(oObject);
				 int iDmg = iHP - iHealth;
				 effect eDamage = EffectDamage(iDmg, DAMAGE_TYPE_DIVINE, DAMAGE_POWER_NORMAL, TRUE);
				 object oNew = CreateObject(OBJECT_TYPE_CREATURE, GetResRef(oObject), GetLocation(oObject));
			 	 ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oNew);
				 DestroyObject(oObject);
				 }
			}
		 SetLocalInt(oDM, "DM_Paralyze", 0);
		}
	if(nQuake == 1)
		{ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, oObject, 5.0);
		 ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eQuake, oObject, 5.0);
		 SetLocalInt(oDM, "DM_Quake", 0);
		 }
	if(nQuake == 2)
		{ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, oObject, 5.0);
		 ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eQuake, oObject, 5.0);
		 DelayCommand(3.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, oObject, 5.0));
		 DelayCommand(3.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eQuake, oObject, 5.0));
		 DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, oObject, 5.0));
		 DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eQuake, oObject, 5.0));
		 SetLocalInt(oDM, "DM_Quake", 0);
		 }
	if(nQuake == 3)
		{ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, oObject, 5.0);
		 ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eQuake, oObject, 5.0);
		 DelayCommand(3.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, oObject, 5.0));
		 DelayCommand(3.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eQuake, oObject, 5.0));
		 DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, oObject, 5.0));
		 DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eQuake, oObject, 5.0));
		 DelayCommand(9.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, oObject, 5.0));
		 DelayCommand(9.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eQuake, oObject, 5.0));
		 DelayCommand(13.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, oObject, 5.0));
		 DelayCommand(13.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eQuake, oObject, 5.0));
		 DelayCommand(16.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, oObject, 5.0));
		 DelayCommand(16.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eQuake, oObject, 5.0));
		 DelayCommand(19.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, oObject, 5.0));
		 DelayCommand(19.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eQuake, oObject, 5.0));
		 DelayCommand(23.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, oObject, 5.0));
		 DelayCommand(23.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eQuake, oObject, 5.0));
		 DelayCommand(26.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, oObject, 5.0));
		 DelayCommand(26.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eQuake, oObject, 5.0));
		 DelayCommand(29.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, oObject, 5.0));
		 DelayCommand(29.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eQuake, oObject, 5.0));
		 SetLocalInt(oDM, "DM_Quake", 0);
		 }
	if(nJumpQ == 1)
		{AssignCommand(oObject, ActionJumpToObject(oQ, FALSE));
		 ActionJumpToObject(oQ, FALSE);
		 SetLocalInt(oDM, "DM_Jump_Q", 0);
		 }
	if(nJumpAdmin == 1)
		{AssignCommand(oObject, ActionJumpToObject(oAdmin, FALSE));
		 ActionJumpToObject(oAdmin, FALSE);
		 SetLocalInt(oDM, "DM_Jump_Admin", 0);
		 }
	if(nTrap == 1)
		{int nObjectType = GetObjectType(oObject);
		 if (nObjectType != OBJECT_TYPE_PLACEABLE && nObjectType != OBJECT_TYPE_DOOR)
		 {
			SendMessageToPC(oDM, "This function must be used on either a placeable or a door.");
			return;
		 }

		 int nTrap_Power = GetLocalInt(oDM, "Trap_Power");
		 int nTrap_Type = GetLocalInt(oDM, "Trap_Type");
		 CreateTrapOnObject(4 * nTrap_Type + nTrap_Power, oObject, STANDARD_FACTION_HOSTILE, "1sc_plc_ontrapdisarm");	 
		 int iUnlockDC = GetLocalInt(oObject, "iUnlockDC");
		 if(iUnlockDC == 0)
				{iUnlockDC = 30 + Random(11) - Random(11) + (5 * nTrap_Power);
				 SetLocalInt(oObject, "iUnlockDC", iUnlockDC);
				}
		 int iDetectDC = GetLocalInt(oObject, "iDetectDC");
		 if(iDetectDC == 0)
				{iDetectDC = 20 + Random(11) - Random(11) + (5 * nTrap_Power);
				 SetLocalInt(oObject, "iDetectDC", iDetectDC);
				}
		 int iDisableDC = GetLocalInt(oObject, "iDisableDC");;
		 if(iDisableDC == 0)
				{iDisableDC = 25 + Random(11) - Random(11) + (5 * nTrap_Power);
				 SetLocalInt(oObject, "iDisableDC", iDisableDC);
				}
		 SetLocked(oObject, TRUE);
		 SetLockUnlockDC(oObject, iUnlockDC);
		 SetLocalInt(oObject, "DM_Trapped", 1);
		 object oTrap = GetNearestTrapToObject(oObject, FALSE);
		 SetTrapDisarmable(oObject, TRUE);
		 SetTrapDetectDC(oObject, iDetectDC);
		 SetTrapDisarmDC(oObject, iDisableDC);
		 SendMessageToPC(oDM, "Unlock DC = "+IntToString(GetLockUnlockDC(oObject)));
		 SendMessageToPC(oDM, "Detect DC = "+IntToString(GetTrapDetectDC(oObject)));
		 SendMessageToPC(oDM, "Disarm DC = "+IntToString(GetTrapDisarmDC(oObject)));
		 SetLocalInt(oDM, "DM_Trap", 0);
		 SetLocalInt(oDM, "Trap_Power", 4);
		 SetLocalInt(oDM, "Trap_Type", 11);
		 
		 
		 	}
	
}
