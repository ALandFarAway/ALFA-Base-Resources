#include "ginc_misc"

void main()
{
	object oEnteredObject	= GetFirstInPersistentObject();
	string sSecretObject	= GetLocalString(OBJECT_SELF, "sSecretPlaceable");
	string sTag				= GetLocalString(OBJECT_SELF, "sSpawnTag");
	int	nSearchDC			= GetLocalInt(OBJECT_SELF, "nSearchDC");
	string sMessage			= GetStringByStrRef(220758);
	location lLocation		= GetLocation(GetNearestObjectByTag(sTag, oEnteredObject));
	
	while (GetIsObjectValid(oEnteredObject) && !IsMarkedAsDone(OBJECT_SELF))
	{	
		if (GetIsPC(oEnteredObject) || GetIsOwnedByPlayer(oEnteredObject))
		{
			if ((GetDetectMode(oEnteredObject)==DETECT_MODE_ACTIVE
				|| GetRacialType(oEnteredObject)==RACIAL_TYPE_ELF)
				&& GetSkillRank(SKILL_SEARCH, oEnteredObject)>=nSearchDC)
			{
				AssignCommand(oEnteredObject, PlayVoiceChat(VOICE_CHAT_LOOKHERE));
				CreateObject(OBJECT_TYPE_PLACEABLE, sSecretObject, lLocation);
				SendMessageToPC(oEnteredObject, sMessage);
				MarkAsDone(OBJECT_SELF);
			}
		}
		
		oEnteredObject		= GetNextInPersistentObject();
	}
}