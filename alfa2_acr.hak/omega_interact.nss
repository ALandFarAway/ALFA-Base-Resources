void main()

	{object oDM = OBJECT_SELF;
	object oNPC = GetLocalObject(oDM, "Object_Target");
	object oPlaceable = GetNearestObject(OBJECT_TYPE_PLACEABLE, oNPC, 1);

	
	AssignCommand(oNPC, ActionForceMoveToObject(oPlaceable, FALSE));
	DelayCommand(2.0, AssignCommand(oNPC, ActionInteractObject(oPlaceable)));
	
	SendMessageToPC(oDM, GetName(oNPC) + " interacting with " + GetName(oPlaceable));
	
}		