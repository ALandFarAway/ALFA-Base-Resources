////////////////////////////////////////////////////////////////////////////////
//
//                     Wynna			9/18/2008   
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////



void main()
{
    object oDM = OBJECT_SELF;
	object oObject = GetLocalObject(oDM, "Object_Target");
	int iBaseTrap = GetTrapBaseType(oObject);
	
	
		 SendMessageToPC(oDM, Get2DAString("traps", "Label", iBaseTrap));
		 SendMessageToPC(oDM, "Unlock DC = " + IntToString(GetLockUnlockDC(oObject)));
		 SendMessageToPC(oDM, "Detect DC = " + IntToString(GetTrapDetectDC(oObject)));
		 SendMessageToPC(oDM, "Disarm DC = " + IntToString(GetTrapDisarmDC(oObject)));
		 
		 
	
}