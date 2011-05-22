//	g_ol_hb
/*
	Default Overland Map heartbeat script. Determines the spawning of neutral
	encounters (patrols, merchants, etc.) and special one-time encounters.
*/
//	NLC 8/20/08

#include "ginc_misc"
#include "ginc_overland"
#include "ginc_wp"
#include "ginc_vars"

const int NEUTRAL_ENC_SPAWN_TIME = 1;//39;

void main()
{
	object oPC = GetFactionLeader(GetFirstPC(FALSE));
	int nSpecialEncounterCooldown = GetLocalInt(OBJECT_SELF, VAR_ENC_SPECIAL_COOLDOWN);
	int nTimer = GetLocalInt(OBJECT_SELF, VAR_ENC_TIMER);

//	PrettyDebug("SE Timer: " + IntToString(nSpecialEncounterCooldown));
//	PrettyDebug("Overland Timer: " + IntToString(nTimer));
		
	if(GetArea(oPC) != OBJECT_SELF)
		return;
	
	ModifyLocalInt(OBJECT_SELF, VAR_ENC_SPECIAL_COOLDOWN, -1);	
	ModifyLocalInt(OBJECT_SELF, VAR_ENC_TIMER, 1);

	if((nTimer % NEUTRAL_ENC_SPAWN_TIME) == 0)
	{
		InitializeNeutralEncounter(oPC);
	}
	
	if(nSpecialEncounterCooldown <= 0)
	{
		InitializeSpecialEncounter(oPC);
		ResetSpecialEncounterTimer();
	}
	
	/* Failsafe - if the PC hasn't been shrunk yet, and you hit a heartbeat, shrink him. */
	while(GetIsPC(oPC) && GetIsObjectValid(oPC) && GetLocalInt(oPC, "pcshrunk") == FALSE)
	{
		SetLocalInt(oPC, "pcshrunk", TRUE);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSetScale(0.5, 0.5, 0.5),oPC);
		oPC = GetNextPC(FALSE);
	}
	
	//	Can specify a string variable on the specific Overland Map to use a custom
	//	heartbeat script.
	string sHeartbeatScript = GetLocalString(OBJECT_SELF, "sHeartbeatScript");
	
	if(sHeartbeatScript != "")
	{
		ExecuteScript(sHeartbeatScript, OBJECT_SELF);
	}
}