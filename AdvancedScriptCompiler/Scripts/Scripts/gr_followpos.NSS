// gr_followpos
/*
	test script for setting up follow positions
*/
// ChazM 8/9/06
#include "ginc_debug"
#include "ginc_companion"

void main()
{
	object oPC = GetFirstPC();
	object oWho = GetFactionLeader(oPC);
	object oMember = GetFirstFactionMember( oPC, FALSE );
	int i = 0;
	float fFollowDistance;
	PrettyDebug("Everyone follow " + GetName(oWho) + "!");
	
	while ( GetIsObjectValid( oMember ) == TRUE )
	{
		
		AssignCommand(oMember, ClearAllActions());
		PrettyDebug(GetName(oMember) + " Follow Position = " + IntToString(i) );
		SetLocalInt(oMember, "FollowPos", i); // this will by the default AI, but not in gb_comp_heart yet.
		
		fFollowDistance = GetFollowDistance(oMember);
		AssignCommand(oMember, ActionForceFollowObject(oWho, fFollowDistance, i));
		
		i++;
		oMember = GetNextFactionMember( oPC, FALSE );
	}		

}