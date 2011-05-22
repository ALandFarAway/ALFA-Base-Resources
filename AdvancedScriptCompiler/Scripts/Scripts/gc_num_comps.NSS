// gc_num_comps (string sCheck)
/* 
	This script checks number of roster companions the player has.

   Parameters:
     string sCheck 	 = 	The operation to check on the number of companions.
	 					If blank, defaults to "<MAX"

                        Comparison operator default is ==, but you can also specify <, >, or !
                        e.g. sCheck of "<5" returns TRUE if number of companions is <5
                        a sCheck of "9" or "=9" returns TRUE if number of companions is equal to 9
                        and a sCheck of "!0" returns TRUE if number of companions is not equal to 0.
						MAX can be used in place of a number to represent the current Roster NPC Party Limit.
*/
// ChazM 7/14/05
// 12/5/05 - BDF: updated for compatibility with new roster companions
// 5/18/07 - Added "MAX" support and "<MAX" defualt value

#include "ginc_var_ops"
#include "x0_i0_stringlib"

int StartingConditional( string sCheck )
{
	if (sCheck == "")
	{
		sCheck = "<MAX";
	}
	
	string sMax = IntToString(GetRosterNPCPartyLimit());
	sCheck = ReplaceSubString(sCheck, "MAX", sMax);
		
	// return number of henchman, -1 if a problem occurs.
	object oPC = GetPCSpeaker();
	object oFactionMember = GetFirstFactionMember( oPC, FALSE );
	int nNumCompanions = 0;
	
	while ( GetIsObjectValid(oFactionMember) )
	{
		if ( GetIsRosterMember(oFactionMember) )
		{
			nNumCompanions++;
		}
		oFactionMember = GetNextFactionMember( oPC, FALSE );
	}

    int iRet = CompareInts( nNumCompanions, sCheck );

    return (iRet);
}