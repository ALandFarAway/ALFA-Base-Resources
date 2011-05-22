#include "ginc_misc"

void main()
{
	object oEnteringObject	= GetEnteringObject();
	string sSecretObject	= GetLocalString(OBJECT_SELF, "sSecretPlaceable");
	string sTag				= GetLocalString(OBJECT_SELF, "sSpawnTag");
	int	nSearchDC			= GetLocalInt(OBJECT_SELF, "nSearchDC");
	location lLocation		= GetLocation(GetNearestObjectByTag(sTag, oEnteringObject));
	string sMessage			= GetStringByStrRef(220758);
		
	if (!IsMarkedAsDone(OBJECT_SELF) && (GetIsOwnedByPlayer(oEnteringObject) || GetIsPC(oEnteringObject)))
		if ((GetDetectMode(oEnteringObject)==DETECT_MODE_ACTIVE
			|| GetRacialType(oEnteringObject)==RACIAL_TYPE_ELF)
			&& GetSkillRank(SKILL_SEARCH, oEnteringObject)>=nSearchDC)
		{
			AssignCommand(oEnteringObject, PlayVoiceChat(VOICE_CHAT_LOOKHERE));
			CreateObject(OBJECT_TYPE_PLACEABLE, sSecretObject, lLocation);
			SendMessageToPC(oEnteringObject, sMessage);
			MarkAsDone(OBJECT_SELF);
		}
}