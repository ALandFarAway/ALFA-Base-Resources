// gc_node
/*
	Used on nodes of a dialog to specify it's index.
	
	iNodeIndex		- This Node's index (for use w/ gtr_speak_node)
	
*/
// ChazM 4/6/05
// ChazM 5/25/05 - added check for OnceOnly flag

int StartingConditional (int iNodeIndex)
{
	// these 2 vars are set on creature by gtr_speak_node
	int iSavedNodeIndex = GetLocalInt(OBJECT_SELF, "sn_NodeIndex");
	int iOnceOnly = GetLocalInt(OBJECT_SELF, "sn_OnceOnly");	// signal that we should clear node if true
	
	//PrintString ("gc_node: iSavedNodeIndex = " + IntToString(iSavedNodeIndex));
	//PrintString ("gc_node: iNodeIndex = " + IntToString(iNodeIndex));
	
	if (iSavedNodeIndex == iNodeIndex)
	{
		if (iOnceOnly)
			SetLocalInt(OBJECT_SELF, "sn_NodeIndex", 0);
		return TRUE;
	}		
	else
		return FALSE;		
}