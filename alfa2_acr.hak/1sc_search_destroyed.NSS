#include "1sc_searchable"

void main()
{
	if (GetTag(OBJECT_SELF) == "dotr_sarcophagus")
	{
		CreateObject(OBJECT_TYPE_CREATURE, "003_cr_ud_mummy", GetLocation(OBJECT_SELF));
	}
	
	if (FindSubString(GetTag(OBJECT_SELF),"corpse") != -1)
	{
		CreateObject(OBJECT_TYPE_ITEM, "abr_it_mi_body", GetLocation(OBJECT_SELF));
	}
}
