// gc_item_count(string sItemTag, string sCheck, int bPCOnly)
/* 
   Compares the number of items with tag sItemTag the speaker/party possesses to condition sCheck.

   Parameters:
     string sItemTag  = Tag of the item to count.
     string sCheck    = Condition and value to check, for example:
						"<5" Less than 5
						">1" Greater than 1
						"=9" Equal to 9
						"!0" Not equal to 0
     int bParty      = If =1 then check party's inventory, else check speaker inventory only
*/
// BMA 5/9/05
// BMA-OEI 1/11/06 removed default param, replaced henchmen w/ faction
// TDE 9/21/08 - Changed bPCOnly to bParty to fix a bug in this function that was doing the opposite of what was described.

#include "ginc_var_ops"
#include "nw_i0_plot"

int StartingConditional(string sItemTag, string sCheck, int bParty)
{
	object oPC = GetPCSpeaker();
	object oMember;
	int nItems = 0;
	
	if (bParty == 0)
	{
		nItems = GetNumItems(oPC, sItemTag);
	}
	else
	{
		oMember = GetFirstFactionMember(oPC, FALSE);
		while (GetIsObjectValid(oMember))
		{
			nItems = nItems + GetNumItems(oMember, sItemTag);
			oMember = GetNextFactionMember(oPC, FALSE);
		}
	}
	
	return CompareInts(nItems, sCheck);
}