#include "ginc_misc"

void main()
{
	object oEnteringObject	= GetEnteringObject();
	string sSecretObject	= GetLocalString(OBJECT_SELF, "sSecretItem");
	string sTag				= GetLocalString(OBJECT_SELF, "sSpawnTag");
	int	nSearchDC			= GetLocalInt(OBJECT_SELF, "nSearchDC");
	location lLocation		= GetLocation(GetNearestObjectByTag(sTag, oEnteringObject));
		
	if (!IsMarkedAsDone(OBJECT_SELF) && GetIsOwnedByPlayer(oEnteringObject))
		if ((GetDetectMode(oEnteringObject)==DETECT_MODE_ACTIVE
			|| GetRacialType(oEnteringObject)==RACIAL_TYPE_ELF)
			&& GetSkillRank(SKILL_SEARCH, oEnteringObject)>=nSearchDC)
		{
			AssignCommand(oEnteringObject, PlayVoiceChat(VOICE_CHAT_LOOKHERE));
			CreateObject(OBJECT_TYPE_ITEM, sSecretObject, lLocation);
			SendMessageToPC(oEnteringObject, "You've found something of interest.");
			MarkAsDone(OBJECT_SELF);
		}
}