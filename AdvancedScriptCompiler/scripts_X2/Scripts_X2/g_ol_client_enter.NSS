//	g_ol_client_enter 
/* 
   	On Client Enter script for an overland map area.
*/
//	JH/EF-OEI: 01/17/08

#include "ginc_overland"
#include "ginc_overland_constants"

int StartingConditional()
{
	object oPC = GetFirstEnteringPC();
	
	while(GetIsObjectValid(oPC))
	{
		if(GetIsPC(oPC))
		{
			PrettyDebug("Swapping UI for " + GetName(oPC));
			ActivateOLMapUI(oPC);
			
		}		
		oPC = GetNextEnteringPC();
	}
	
	object oLeader = GetFactionLeader(GetFirstPC(TRUE));		
	SetPartyActor(oLeader);
			
	object oParty = GetFirstFactionMember(oLeader, FALSE);
	
	while(GetIsObjectValid(oParty))
	{
		PrettyDebug(GetName(oParty));

		if(GetLocalInt(oParty, "pcshrunk") == FALSE)
		{
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSetScale(0.5, 0.5, 0.5),oParty);
			SetLocalInt(oParty, "pcshrunk", TRUE);
			SetLocalInt(oParty, "bLoaded", TRUE); 
		}
						
		if(oParty != GetFactionLeader(oParty))
			SetScriptHidden(oParty, TRUE, FALSE);
			
		oParty = GetNextFactionMember(oLeader, FALSE);
	}
	string sSpawnScript = GetLocalString(OBJECT_SELF, "sSpawnScript");
	if( sSpawnScript!= "")
	{
		ExecuteScript(sSpawnScript, OBJECT_SELF);
	}
	
	int nDay = GetCalendarDay();
	int nMonth = GetCalendarMonth();
	int nYear = GetCalendarYear();
	
	if(!IsMarkedAsDone())
	{
		InitializeNeutralEncounter(oPC);
		
		
		SetGlobalInt(VAR_CURRENT_DAY, nDay);
		SetGlobalInt(VAR_CURRENT_MONTH, nMonth);
		SetGlobalInt(VAR_CURRENT_YEAR, nYear);
		
		int nGoodiesTotal = GetLocalInt(OBJECT_SELF, VAR_GOODIES_TOTAL);
		int nGoodiesPerSpawn = nGoodiesTotal / 10;
		
		float fDelay = 0.0f;
		DelayCommand(fDelay, GerminateGoodies(nGoodiesPerSpawn));
		fDelay += 1.0f;
		DelayCommand(fDelay, GerminateGoodies(nGoodiesPerSpawn));
		fDelay += 1.0f;
		DelayCommand(fDelay, GerminateGoodies(nGoodiesPerSpawn));
		fDelay += 1.0f;
		DelayCommand(fDelay, GerminateGoodies(nGoodiesPerSpawn));
		fDelay += 1.0f;
		DelayCommand(fDelay, GerminateGoodies(nGoodiesPerSpawn));
		fDelay += 1.0f;
		DelayCommand(fDelay, GerminateGoodies(nGoodiesPerSpawn));
		fDelay += 1.0f;
		DelayCommand(fDelay, GerminateGoodies(nGoodiesPerSpawn));
		fDelay += 1.0f;
		DelayCommand(fDelay, GerminateGoodies(nGoodiesPerSpawn));
		fDelay += 1.0f;
		DelayCommand(fDelay, GerminateGoodies(nGoodiesPerSpawn));
		fDelay += 1.0f;
		DelayCommand(fDelay, GerminateGoodies(nGoodiesPerSpawn));
		fDelay += 1.0f;
		
		
		ResetSpecialEncounterTimer();
				
		MarkAsDone();
	}
	
	return FALSE;
}