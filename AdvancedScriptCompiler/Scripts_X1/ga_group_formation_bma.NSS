// ga_group_formation_BMA(string sGroupTarget, float fSpacing, int iMoveType)
/*
	Description:
	Puts the target group into BMA formation
	This is a standard party group formations:
//       1        fSpacing = distance between each row
//      2 3       
//     5 4 6       
//      7 8  etc.
	
	
	string sGroupTarget - Tag of the group member whose group is to be affected.  Defaults to the PC speaker.
					if this evaluates to a party member, the party will be treates as a group.
					(This is NOT the group name)					
	float fSpacing - distance between each row.  Defaults to DEFAULT_SPACING
 	int iMoveType - formation will initialize with a move to sGroupTarget using this move type:
		0 = don't move
		const int MOVE_WALK 					= 1;
		const int MOVE_RUN 						= 2;
		const int MOVE_JUMP 					= 3;
		const int MOVE_JUMP_INSTANT 			= 4;
		const int MOVE_FORCE_WALK 				= 5;
		const int MOVE_FORCE_RUN 				= 6;
	
*/
// ChazM 6/27/07


#include "ginc_group"
#include "ginc_companion"
#include "ginc_param_const"

void main(string sGroupTarget, float fSpacing, int iMoveType)
{
	
	string sGroupName = "";
	object oGroupMember = GetTarget(sGroupTarget, TARGET_PC_SPEAKER);
	
	// if this is a PC party, use GetPartyGroup()
	if (GetIsObjectValid(GetPCLeader(oGroupMember)))
		sGroupName = GetPartyGroup(oGroupMember);	// creates group for the party and returns name.
	else
		GetGroupName(oGroupMember);
	
	
	if (fSpacing == 0.0f)
		fSpacing=DEFAULT_SPACING;
	GroupSetBMAFormation(sGroupName, fSpacing);	// a staggered marching formation
	if (iMoveType != 0)
		GroupMoveToObject(sGroupName, oGroupMember, iMoveType);
	
}