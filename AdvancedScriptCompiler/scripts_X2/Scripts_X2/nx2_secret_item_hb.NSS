#include "ginc_misc"

void main()
{
	object oEnteredObject	= GetFirstInPersistentObject();
	string sSecretObject	= GetLocalString(OBJECT_SELF, "sSecretItem");
	string sTag				= GetLocalString(OBJECT_SELF, "sSpawnTag");
	int	nSearchDC			= GetLocalInt(OBJECT_SELF, "nSearchDC");
	location lLocation		= GetLocation(GetNearestObjectByTag(sTag, oEnteredObject));
	
	while (GetIsObjectValid(oEnteredObject) && !IsMarkedAsDone(OBJECT_SELF))
	{	
		if (GetIsOwnedByPlayer(oEnteredObject))
		{
			if ((GetDetectMode(oEnteredObject)==DETECT_MODE_ACTIVE
				|| GetRacialType(oEnteredObject)==RACIAL_TYPE_ELF)
				&& GetSkillRank(SKILL_SEARCH, oEnteredObject)>=nSearchDC)
			{
				AssignCommand(oEnteredObject, PlayVoiceChat(VOICE_CHAT_LOOKHERE));
				CreateObject(OBJECT_TYPE_ITEM, sSecretObject, lLocation);
				SendMessageToPC(oEnteredObject, "You've found something of interest.");
				MarkAsDone(OBJECT_SELF);
			}
		}	
			
		oEnteredObject		= GetNextInPersistentObject();
	}
}