
void main(int nFirstCriteriaType, int nFirstCriteriaValue, int nNth=1, int nSecondCriteriaType=-1, int nSecondCriteriaValue=-1, int nThirdCriteriaType=-1,  int nThirdCriteriaValue=-1) {
	
	object oNearest = GetNearestCreatureToLocation(
		nFirstCriteriaType,
		nFirstCriteriaValue,
		GetLocalLocation(OBJECT_SELF, "ACR_GETNEARESTHOSTILE_LOC"),
		nNth,
		nSecondCriteriaType,
		nSecondCriteriaValue,
		nThirdCriteriaType,
		nThirdCriteriaValue
	);
	
	DeleteLocalLocation(OBJECT_SELF, "ACR_GETNEARESTHOSTILE_LOC");
	SetLocalObject(OBJECT_SELF, "ACR_GETNEARESTHOSTILE_OBJ", oNearest);
}