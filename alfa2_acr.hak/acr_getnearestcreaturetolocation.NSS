
void main(int nFirstCriteriaType, int nFirstCriteriaValue, int nNth, int nSecondCriteriaType, int nSecondCriteriaValue, int nThirdCriteriaType,  int nThirdCriteriaValue) {
	
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
