// gp_plc_to_item_us
//
// placeables with the variable sRR set on them will self-destruct and spawn an item of that ResRef in the inventory of the user

// EPF 5/29/07

#include "ginc_misc"

void main()
{
	string sRR = GetLocalString(OBJECT_SELF, "sRR");
	
	object oUser = GetLastUsedBy();
	
	if(!IsMarkedAsDone())
	{	
		MarkAsDone();
		CreateItemOnObject(sRR,oUser,1);
		DestroyObject(OBJECT_SELF,0.1f);
	}		
}